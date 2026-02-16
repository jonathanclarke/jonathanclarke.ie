---
layout: post
title: "Fixing Longhorn CrashLoopBackOff on k3s: An nftables Cross-Node Networking Nightmare"
excerpt: "When adding a new agent node to a k3s cluster, everything looked fine on the surface; the node joined, pods were scheduled, and local workloads ran.  But Longhorn's manager pods started CrashLoopBackOff-ing with increasingly cryptic errors.  What followed was a multi-layered debugging session that uncovered a fundamental networking issue hiding behind misleading error messages."
date:   "2026-02-16"
---

When adding a new agent node to a k3s cluster, everything looked fine on the surface; the node joined, pods were scheduled, and local workloads ran.  But Longhorn's manager pods started CrashLoopBackOff-ing with increasingly cryptic errors.  What followed was a multi-layered debugging session that uncovered a fundamental networking issue hiding behind misleading error messages.

## The Environment

- **k3s** cluster with two nodes:
  - **knight** (control-plane, Debian 11, kernel 5.10)
  - **bishop** (agent node, Ubuntu 25.04, kernel 6.14)
- **Longhorn v1.6.0** for persistent storage
- **Flannel** VXLAN overlay networking (default k3s CNI)

## The Symptoms

After adding bishop as a new agent node, Longhorn pods on bishop entered `CrashLoopBackOff`:

```
longhorn-manager-xdbbf    0/1   CrashLoopBackOff
longhorn-csi-plugin-g9hld 0/3   CrashLoopBackOff
```

### Red Herring #1: Missing open-iscsi

The first error was straightforward:

```
Error starting manager: Failed environment check, please make sure you have
iscsiadm/open-iscsi installed on the host
```

Fixed with `sudo apt install -y open-iscsi && sudo systemctl enable --now iscsid` on bishop. But the problems continued.

### Red Herring #2: Stale Webhook TLS Certificates

After fixing iscsi, the managers crashed with webhook timeout errors:

```
Failed to check endpoint https://longhorn-conversion-webhook.longhorn-system.svc:9501/v1/healthz:
context deadline exceeded
```

The webhook TLS certificates were 547 days old from the original install. Deleting and letting them regenerate helped briefly:

```bash
kubectl delete secret -n longhorn-system longhorn-webhook-ca longhorn-webhook-tls
```

But the timeouts returned.

### Red Herring #3: Stale Webhook Configurations

Old `ValidatingWebhookConfiguration` and `MutatingWebhookConfiguration` resources from v1.6.0 were blocking the upgrade migration. Deleting them helped the managers start momentarily, but they'd crash again within minutes.

## The Real Problem: nftables Blocking VXLAN Traffic

After hours of chasing webhook and CSI errors, a simple DNS test from a pod on knight revealed the truth:

```bash
$ nslookup longhorn-backend.longhorn-system.svc.cluster.local
;; connection timed out; no servers could be reached
```

DNS was completely broken for cross-node communication. CoreDNS was running on bishop, and pods on knight couldn't reach it. A ping test confirmed:

```bash
# From a pod on knight, pinging bishop's CoreDNS
$ ping 10.42.5.17
2 packets transmitted, 0 packets received, 100% packet loss
```

Yet node-to-node communication worked fine:

```bash
$ ping 192.168.1.84  # bishop's node IP
2 packets transmitted, 2 received, 0% packet loss
```

### The Root Cause: Dual iptables/nftables Conflict

Both nodes were running **iptables-legacy** and **nftables** simultaneously. k3s and flannel configure their rules in iptables-legacy, but the actual packet filtering was happening in nftables -- which had a `FORWARD policy drop` that flannel knew nothing about.

On knight:
```
table ip filter {
    chain FORWARD {
        type filter hook forward priority filter; policy drop;
        ...
        counter packets 0 bytes 0 jump FLANNEL-FWD
    }
}
```

Flannel's `FLANNEL-FWD` chain had the right rules, but traffic never reached it -- it was dropped by the policy before getting there.

On bishop, it was even worse -- the `INPUT` chain had `policy drop`, which meant VXLAN UDP packets (port 8472) were being dropped before they could even be decapsulated:

```
table ip filter {
    chain INPUT {
        type filter hook input priority filter; policy drop;
```

`tcpdump` confirmed: knight was sending VXLAN packets out, bishop was receiving them, but bishop's firewall dropped them at INPUT before the kernel could decapsulate them into flannel traffic.

## The Fix

### Knight (FORWARD only)

```bash
sudo nft insert rule ip filter FORWARD iifname "flannel.1" accept
sudo nft insert rule ip filter FORWARD oifname "flannel.1" accept
sudo nft insert rule ip filter FORWARD iifname "cni0" accept
sudo nft insert rule ip filter FORWARD oifname "cni0" accept
```

### Bishop (INPUT + FORWARD)

```bash
sudo nft insert rule ip filter INPUT udp dport 8472 accept
sudo nft insert rule ip filter FORWARD iifname "flannel.1" accept
sudo nft insert rule ip filter FORWARD oifname "flannel.1" accept
sudo nft insert rule ip filter FORWARD iifname "cni0" accept
sudo nft insert rule ip filter FORWARD oifname "cni0" accept
```

### Making It Persistent

nftables rules don't survive reboots. Since k3s recreates its own chains on startup, the fix needs to run after k3s. A systemd oneshot service does the job:

```bash
# /usr/local/bin/k3s-nftables-fix.sh
#!/bin/bash
sleep 5
nft insert rule ip filter INPUT udp dport 8472 accept  # bishop only
nft insert rule ip filter FORWARD oifname "cni0" accept
nft insert rule ip filter FORWARD iifname "cni0" accept
nft insert rule ip filter FORWARD oifname "flannel.1" accept
nft insert rule ip filter FORWARD iifname "flannel.1" accept
```

```ini
# /etc/systemd/system/k3s-nftables-fix.service
[Unit]
Description=Fix nftables rules for k3s cross-node networking
After=k3s.service  # or k3s-agent.service for agent nodes

[Service]
Type=oneshot
ExecStart=/usr/local/bin/k3s-nftables-fix.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

## Upgrading Longhorn After the Fix

With networking fixed, we upgraded Longhorn from the EOL v1.6.0 through the required sequential path:

```
v1.6.0 → v1.7.2 → v1.8.1 → v1.9.2 → v1.10.1 → v1.11.0
```

Each step was a simple `kubectl apply`:

```bash
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.7.2/deploy/longhorn.yaml
# Wait for all pods healthy, then repeat for next version
```

Longhorn enforces sequential minor version upgrades -- you cannot skip versions.

## Lessons Learned

1. **When pods crash with service connectivity errors, test the network first.** A simple `nslookup` or `ping` from a pod would have saved hours of chasing webhook and CSI errors.

2. **Check for dual iptables/nftables.** Modern Linux distributions often have both installed. The warning `iptables-legacy tables present, use iptables-legacy to see them` is a red flag that two firewall systems are competing.

3. **VXLAN needs explicit firewall rules.** If your FORWARD or INPUT policy is `drop`, flannel's VXLAN overlay will silently fail. You need to allow UDP 8472 on INPUT and flannel.1/cni0 interfaces on FORWARD.

4. **Node-to-node ping working doesn't mean pod networking works.** ICMP between node IPs uses the physical network. Pod traffic uses VXLAN encapsulation, which traverses different firewall chains.

5. **Longhorn error messages are misleading during network issues.** Webhook timeouts, CSI connection failures, and admission controller errors all pointed at Longhorn problems, but the root cause was always the network.
