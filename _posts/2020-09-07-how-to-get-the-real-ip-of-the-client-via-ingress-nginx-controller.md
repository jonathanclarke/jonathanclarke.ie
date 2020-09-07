---
layout: post
title: How to get the real ip of the client via ingress nginx controller on GCP
---

I'm writing this down here so that someone else can be spared the agony of solving this one. 

We migrated a kubernetes service recently from Azure to Google Cloud, this was the only gotcha that we faced. 

Using the nginx ingress controller [https://kubernetes.github.io/ingress-nginx/] we had a lovely service which would automatically issue SSL certificates from LetsEncrypt and set up the Load Balancer with some nice decent configuration out of the box.

Unfortunately, one of our core pieces of business logic depended on knowing the current users IP address; this wasn't being passed through past the load balancer.  We tried a heap of different configuration but in the end the only one worth a damm was as follows. 

    kubectl patch svc nginx-ingress-controller-controller -p '{"spec":{"externalTrafficPolicy":"Loca"}l}' --namespace=default
	
And eureka, the clients IP addresses were correctly coming through.

Some explanation is required, I'll leave it to others to do that: Andrew Sy Kim does a great deep dive on the externalTrafficPolicy: Local setting below: [https://www.asykim.com/blog/deep-dive-into-kubernetes-external-traffic-policies]

> With this external traffic policy, kube-proxy will add proxy rules on a specific NodePort (30000-32767) only for pods that exist on the same node (local) as opposed to every pod for a service regardless of where it was placed.

> You’ll notice that if you try to set externalTrafficPolicy: Local on your Service, the Kubernetes API will require you are using the LoadBalancer or NodePort type. This is because the “Local” external traffic policy is only relevant for external traffic which by only applies to those two types. 

    $ kubectl apply -f mysvc.yml
    The Service "mysvc" is invalid: spec.externalTrafficPolicy: Invalid value: "Local": ExternalTrafficPolicy can only be set on NodePort and LoadBalancer service

> With this architecture, it’s important that any ingress traffic lands on nodes that are running the corresponding pods for that service, otherwise, the traffic would be dropped. For packets arriving on a node running your application pods, we know that all it’s traffic will route to the local pods, avoiding extra hops to other pods in the cluster.

> We can achieve this logic by using a load balancer, hence why this external traffic policy is allowed with Services of type LoadBalancer (which uses the NodePort feature and adds backends to a load balancer with that node port).  With a load balancer we would add every Kubernetes node as a backend but we can depend on the load balancer’s health checking capabilities to only send traffic to backends where the corresponding NodePort is responsive (i.e. only nodes who’s NodePort proxy rules point to healthy pods).

> This model is great for applications that ingress a lot external traffic and want to avoid unnecessary hops on the network to reduce latency. We can also preserve true client IPs since we no longer need to SNAT traffic from a proxying node! However, the biggest downsides to using the “Local” external traffic policy, as mentioned in the Kubernetes docs is that traffic to your application may be imbalanced. This is better explained in the diagram below:

Sounds absoloutely perfect for our use case and works really well. 
