---
layout: post
title: The direction of Dev-ops
---

Container-based development will power the future of the enterprise.  Containers And Functions-As-A-Service have become the defacto-norm in enterprise architecture.

Even though most developers do not agree on what the term "cloud-native" means, they are already rapidly moving to cloud-native platforms and apps.   Two technologies, containers and functions-as-a-service (FaaS), have started to dominate the industry.

The reasons these tools have gained significant traction is simply because they have improved the time to bring new applications to market and because they have enabled the streamlining of application changes by breaking up monolithic applications into microservices.

Development and IT leaders are rapidly embracing containers and functions-as-a-service.  I guarantee that while most have not implemented them in production level applications they firmly intend on dong so in the future

Containers and functions simply make development teams more effective. Developers that use both containers and functions find that they definitely address their development challenges.

We've been playing with Docker and Kubernetes for the past few years at my organisation, this year we've fully embraced it.  Not only do certain services such as elasticsearch / redis run as containers on my development system but we've also deployed most of our production applications to Kubernetes on GCP.  Containers have brought down our deployment times by a factor of 7.  Our development team also enjoys no longer being tied to specific staging servers to test out their code with the PM, they can simply deploy it themselves and tear it down when no longer needed.  Conflicts are a thing of the past.

By allowing our developers to have a key role in deployments, containers and infrastructure we remove the need at an early stage for a dedicated dev-ops team.  Welcome to the new world. 

[Ninety-eight percent of respondents see value in using containers or functions for cloud development]: https://cloudplatformonline.com/rs/248-TPC-286/images/Google_PaaS_TLP_Final_us.pdf