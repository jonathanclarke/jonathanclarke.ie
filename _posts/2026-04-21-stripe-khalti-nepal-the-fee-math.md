---
layout: post
title: "Khalti Says Stripe. Stripe Says Nothing. Nobody Knows the Fees."
excerpt: "Khalti launched international payments powered by Stripe. Stripe has no public announcement about Nepal and doesn't list it as a supported country. The fees aren't published anywhere. Freelancers are doing the math in group chats."
date: "2026-04-21"
image: https://www.jonathanclarke.ie/public/article_images/2026-04-21/khalti-stripe-nepal.webp
---

![Khalti and Stripe in Nepal](https://www.jonathanclarke.ie/public/article_images/2026-04-21/khalti-stripe-nepal.webp)

A few weeks ago I ended [a post about Nepal's payment infrastructure](/2026/04/06/nepal-startups-unleashed-almost/) with three words: "Now do Stripe."

Consider that wish granted. Kind of.

Khalti has launched international payments powered by Stripe. A freelancer in Lalitpur can now generate a payment link, send it to a client in London or New York, and receive funds directly into their Khalti wallet. The client pays via Visa, Mastercard, Google Pay, Apple Pay, or international bank transfer. The sender completes a one-time identity check, liveness and document verification, and future payments to the same email skip it entirely. The funds convert to NPR and land in the wallet.

For a country where receiving international payments through official channels has been impossible, this is a step forward.

I read [Khalti's announcement](https://blog.khalti.com/services-in-khalti/khalti-stripe-international-payments-nepal/) top to bottom. It mentions "competitive exchange rates." It does not mention a single fee, percentage, or cost to the recipient. Not one number.

And yet freelancers on social media are quoting 5% as Khalti's take. Where does that number come from? Apparently the app itself, or word of mouth. Not the official announcement. The official announcement says "real-time conversion at competitive exchange rates" and stops there.

So the question everyone is actually asking is not being answered by the people who could answer it.

Before going further: I checked Stripe's official supported countries list. Nepal is not on it. I checked Stripe's newsroom for a press release about Khalti or Nepal. There is none. Stripe's documentation on cross-border payouts is explicit that payouts are supported only within the US, UK, EEA, Canada, and Switzerland, and directs anyone outside those regions to contact sales.

What Khalti has built is a product that uses Stripe to power the payment page on the sender's side. When your client in London pays you, they are paying through a Stripe-hosted checkout. That part is real. But this is not "Stripe launching in Nepal." It is Khalti integrating Stripe as their payment processor, the same way any online business can. Nepal is not a Stripe market. Stripe has said nothing publicly about this arrangement.

That matters for a few reasons. It means the verification requirement in the Khalti announcement is for the sender, your client, not for you. It means the settlement, conversion, and payout to your wallet are entirely Khalti's responsibility, not Stripe's. And it means if something goes wrong, you are dealing with Khalti, not with Stripe.

The consequence for you, the freelancer, is that there are two intermediaries between your client's credit card and your wallet, and each one has a price.

Stripe's fees are public. Standard rate: 2.9% plus USD 0.30 per transaction, plus a 1.5% cross-border fee on international cards. Stripe charges that to Khalti as the account holder. Whether Khalti absorbs it or passes it through in their 5% is, like everything else, not stated. If it is passed through, the floor is closer to 4.4% before currency conversion. If your client pays in EUR or GBP, Stripe adds a conversion fee on top of that. The 3-4% figure people cite is optimistic.

Khalti's fees on this product: apparently 5%, based on what people are reporting. Not officially confirmed in writing anywhere I can find.

TDS, Tax Deducted at Source on foreign service income in Nepal: 5%. This one is law, not rumour.

The question that matters is whether Khalti's 5% is all-in, covering Stripe's cut as the settlement partner, or whether it sits on top.

|                           | Stripe fee | Khalti fee | TDS | Total   |
|:--------------------------|:-----------|:-----------|:----|:--------|
| If 5% covers everything   | absorbed   | 5%         | 5%  | ~10%    |
| If 5% is on top of Stripe | ~4.4%+     | 5%         | 5%  | ~14-15% |

Ten percent is painful but workable. You can price it into your rates. Payoneer supports NPR as a receiving currency, with its own verification requirements and withdrawal complications, but no NPR settlement via a Stripe-powered payment link. That part of this product is genuinely new, and a flat 10% all-in could be a competitive price for it.

Fourteen to fifteen percent is a different calculation entirely. Bill a client USD 1,000 and you receive somewhere around USD 850 worth of rupees, before exchange rate margin. And the exchange rate Khalti uses is described as "competitive," which is not a number.

Earn NPR 1,00,000 in a month. Clear NPR 86,000 or NPR 87,000. Then factor in that the conversion rate you get is not the interbank rate. You lose on fees and you lose on conversion, and the gap between your invoice and your wallet is significant enough to plan around.

## The SaaS and recurring payments problem

The fee math above assumes a one-off payment: a client pays an invoice, money arrives, done. For freelancers on project work, that is the whole story.

For anyone building a SaaS product or running a subscription business, it gets worse.

Stripe's subscription billing, recurring charges, and checkout flows are core to how the platform works. But because Nepal is not an official Stripe market, a Nepali SaaS founder cannot create a Stripe account, set up products, or bill customers directly. What Khalti has built handles inbound payments to a wallet. It does not give you a Stripe account. You cannot create subscription plans, set up webhooks, or manage customer billing from Kathmandu the way a founder in Dublin or Singapore can.

The 4.4% Stripe fee also compounds on recurring billing. Every monthly charge from every customer carries that cost. The difference between 2.9% and 4.4% on every subscription renewal is not something you absorb. It comes straight out of margin.

There is also the USD 0.30 fixed fee per transaction. On a USD 10 monthly subscription, that fixed component alone is 3% before the percentage fee kicks in. On a USD 5 plan it is 6%. A product designed around invoice payments does not work for low-value subscriptions. The unit economics are completely different.

Stripe simply has not built the infrastructure in Nepal that would let a local company use the full platform. So the options have not changed. Incorporate abroad, usually Singapore or Dubai, and route payments through a foreign entity. Use a merchant of record like Lemon Squeezy or Paddle and accept their cut. Or use informal channels that do not scale and are not what anyone building a real business should be relying on. Khalti has created a usable path for people receiving invoice payments. That is real and useful. But the bedroom SaaS founder in Lalitpur that the previous post described still does not have a clean way to bill customers internationally.

The spending problem got easier. The earning problem remains mostly unsolved.

On the TDS: yes, you can claim it back.  TDS is not a dead loss. It is tax withheld at source and it can be credited against your annual income tax liability. If you are filing properly, you get it back.

In practice, that means documentation, coordination with whoever processed the withholding, and a functional relationship with the tax office. For a solo freelancer, it means the government holds 5% of your income for up to twelve months before you see it again. That is a cash flow hit, not a permanent loss. The distinction matters, but it does not make the hit disappear.

## What Khalti should do this week

Publish a worked example. Not "competitive exchange rates." An actual table:

Here is a USD 1,000 payment. Here is what Stripe takes. Here is what Khalti takes. Here is the exchange rate applied on a specific date. Here is what lands in your wallet in NPR.

That is it. That is the whole ask. It takes one blog post to write, it takes a freelancer an afternoon to find if it does not exist, and right now people are reverse-engineering it from social media because Khalti has not done it.

Publishing the fees would not undermine this product. Hiding them already has. Khalti's announcement describes a one-time identity check that future payments bypass entirely, and a full set of payment methods: Visa, Mastercard, Google Pay, Apple Pay, international bank transfer. The NPR settlement is exactly what was missing. None of that stops being true once you publish a percentage. The number floating around in group chats right now becomes the official number by default when nobody corrects it, and nobody trusts a number they had to dig for.

## The larger point

Nepal's IT exports crossed a billion dollars in 2025. The developers and designers and consultants doing that work are not a niche case. They are a meaningful part of the economy, and they have spent years routing around the absence of proper payment infrastructure, accepting delays, using informal channels, incorporating abroad, paying middlemen.

This product gives them an official path. That is worth something. But "official" needs to mean transparent, not just legitimate. Right now the announcement says "Stripe is here" and goes quiet on the part that determines whether anyone uses it or keeps routing around it.

Someone from Khalti: publish the fee breakdown. Full numbers, worked example, exchange rate methodology. Do it this week. The freelancers asking are not looking for a reason to complain. They are trying to decide whether to change how they run their business. Everything else is noise.

And Stripe: if this is a product you are standing behind, say so publicly. A payment infrastructure for a billion-dollar IT export economy probably deserves more than silence.
