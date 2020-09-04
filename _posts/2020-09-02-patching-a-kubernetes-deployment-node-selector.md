---
layout: post
title: How to update Node Selector field for Kubernetes PODs in real time
excerpt: "So given the fact that we might want to use a really expensive node pool, you might need a GPU, you might need to use additional mememory and you've already deployed your deployments.  Our recent case was to change a nginx ingress controller from a pre-emptible node (one that lives for less than 24 hours over to a stable node pool pool which has a much longer lifespan). "
---


So given the fact that we might want to use a really expensive node pool, you might need a GPU, you might need to use additional mememory and you've already deployed your deployments.  Our recent case was to change a nginx ingress controller from a pre-emptible node (one that lives for less than 24 hours over to a stable node pool pool which has a much longer lifespan). 


    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: "nginx"
      namespace: "nginx"
      labels:
        app: "nginx"
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: "nginx"
      template:
        metadata:
          labels:
            app: "nginx"
        spec:
          containers:
          - name: nginx
            image: nginx:latest
            ports:
            - containerPort: 80
          nodeSelector:
            pool: node-pool-1
		
		


Anyhow, you might want to patch it so you can change it over in real time from node-pool-1 to expensive-pool-1.

## JSON Patch

You can patch the deployment to change the desired node as follows:

    kubectl patch deployment nginx --namespace=nginx -p '{"spec": {"template": {"spec": {"nodeSelector": {"pool": "expensive-pool-1"}}}}}'

## YAML Patch

Create patch.yaml

    spec:
      template:
        spec:
          nodeSelector:
            pool: expensive-pool-1
		
By running kubectl patch deployment nginx --namespace=nginx --patch "$(cat patch.yaml)".


So this will result in scheduler scheduling new pod on requested node, and terminating the old one as soon as the new one is ready resulting in no downtime.  Awesome sauce. 
