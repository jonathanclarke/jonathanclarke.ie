---
layout: post
title: Domain transfer woes
excerpt: "So one of my domains, my main business domain vayu.com.au has been hosted with Crazy domains for the past number of years.  I had been waiting for Route 53 to support AU domains and decided the week before it was due to expire was a good time to do so.  Big mistake."
---

So one of my domains, my main business domain vayu.com.au has been hosted with Crazy domains for the past number of years.  I had been waiting for Route 53 to support AU domains and decided the week before it was due to expire was a good time to do so.  Big mistake.

I initiated the transfer as I had done quite a few times for my previous domains.  I had fully expected the DNS to completely transfer over including the Name servers.  The name servers were set to a host within Route 53 even though the domain was not.

So, Amazon transfered the domain but two things happened:
1. The nameservers were changed
2. The domain expired during this period.
3. There was about a day of lag between the domain being transferred from crazy domains to AWS Route 53 where my domain was nowhere to be found.

This lead to 4 days of downtime while I first tried to get to the bottom of what actually happened.  Website, email were all affected.

I still have no why Amazon decided my existing nameservers were not good enough.

When I tried to update the nameservers the Domain registrar decided that as the domain had expired that a nameserver was not allowed (fair enough).  After I mentioned to Amazon that I could not update the nameservers they determined I was doing this incorrectly (I wasn't).  

Anyhow, this has really taught me an important lesson.  Never shall I ever transfer a domain days before it's going to expire.  Apparently AWS has a 16 day window to complete these tasks (this was not clear to me before I undertook the transfer.  

