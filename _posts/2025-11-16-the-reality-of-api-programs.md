---
title: The Reality of API programs
date: 2025-11-16 18:00:00 -0000
layout: post
---

[Shane O'Conner](https://www.linkedin.com/in/shaneopenapi)
(Founding Team @ Scalar ) has started a  Q&A series on LinkedIn called
_Behind The API_. Shane graciously asked me to participate, and also
allowed me to re-publish the content here. Below is Shane's initial
announcement of the Q&A, followed by the full content.

## Introduction

Below is Shane's first
[LinkedIn announcement on Nov 11, 2025](https://www.linkedin.com/feed/update/urn:li:activity:7393950763816742912/),
sharing
the [_Behind The API featuring David Biesack_](https://www.linkedin.com/feed/update/urn:li:activity:7393950763816742912/) article:

> I've been thinking a lot about what "mature API strategy" actually means as we build Scalar.
> So I did what any sane person would do: tracked down someone with
> "Chief API Officer" in their title and asked him everything.

>  [David Biesack](https://www.linkedin.com/in/davidbiesack/) spent some time walking me through the reality of API programs - not just the highlights, but the actual messy, cultural, people-first work.
>
> A few things that come up;
>
> The "API-first" paradox: APIs can't come first. The business problem does. But once you solve that, APIs become the unified way you deliver your entire business value. That mindset shift changes everything.
>
> Governance = velocity: I've always known this, but hearing David explain how standards like OAuth2 and OpenID Connect are precisely what enable speed (not constrain it) reframed the whole governance conversation for me.
>
> The people problem: API maturity isn't a tech problem. It's culture. It's convincing people that "API as a Product" means something fundamentally different than "we have APIs."
>
> If you're working in APIs, developer tools, or platform strategy&mdash;I think you'll find something useful here.
>
> Enjoy!
>
> \* if you'd like to partake in my interview series, please let me know. Would love to chat with as many of you as possible.
>
>  [#BehindTheAPI](https://www.linkedin.com/search/results/all/?keywords=%23behindtheapi&origin=HASH_TAG_FROM_FEED)

![alt text]({{ '/assets/img/behind-the-api-with-david-biesack.png' | relative_url}})
<br><em>(Image by Shane O'Conner, used with permision)</em>

The remainder of this API Design Matters article is a full reprint of
Shane's full
[Behind The API](https://www.linkedin.com/pulse/behind-api-david-biesack-shane-o-connor-uyjme/?trackingId=G6o0aPqkR0qaGJRTYgL6gA%3D%3D) article, courtesy of Shane (Thanks, Shane!):

## Behind the API with David Biesack

An interview with David Biesack, who is Chief API Officer at Apiture (now part of CSI).

\* all views expressed are his own and are not of his employer

Shane: Most people don't wake up dreaming of being a 'Chief API Officer.' Walk me through how this role came to be at Apiture - was it reactive to chaos or proactive vision?

David: This was a proactive move that I suggested to Apiture executives as the API program matured and began to realize its potential and impact. "API" was in the founding DNA of the company, so it was not a hard sell that APIs merited guidance and governance and quality controls&mdash;and ultimately responsibility. We could establish the role, or it we could partition it out and dilute it amongst other roles, to the risk and detriment of all. So yes, proactive against chaos.

Shane: You lead Apiture's 'API First' initiative. For folks who think that just means 'we have APIs'- what does TRUE API-first actually look like in practice? What are the non-negotiables?

David: APIs exist within a business context, so APIs can't come first &mdash; the problems and needs of the user and the business capabilities come first. APIs are just part of a technical solution to the business problems, so APIs come after fully understanding the business domain and its problems. They are the vehicle for accessing the core capabilities, so they must be shaped based on how users want to consume those capabilities. If the API came first, it would not align with the desired outcomes. So, the non-negotiable is accepting that APIs are part of a larger ecosystem. People who work on APIs must rely on others&mdash;the domain experts, the customers, product managers and business analysts and strategists&mdash;to tell them what needs to be solved before taking any "how" first steps with building an API
Secondly, a true API First mindset means the API solution is the primary tool in the business' toolbelt for gaining access to the domain. Rather than implementing five competing access methods (and differing authorization management, etc) to your business capabilities, focus on APIs as the first and foremost way of exposing those features to all consumers, internal and external. This unifying theme brings tremendous power, more secure solutions, and faster business agility."

Shane: What's the hardest part about instilling an API-first mindset in an organization? Is it technical, cultural, or something else entirely?

David: It is definitely culture &mdash; one can't instill a mindset with technology (I'm not gonna let anyone put a chip in my brain). Many people talk about "API as a Product", and I think grasping that idea is the largest hurdle: One of the hardest things to understand is that providing a unified way for others to access your business' data and processes requires a newer, deeper way of thinking what your product is. It forces people to think what is the true value of your business, and realizing that it does not have to be packaged up in some older, rigid, legacy, monetized widget, but that by enabling your capabilities through APIs, you can really understand the value your company provides, then make it available to more partners and markets.
For many, holding onto a UX-first mindset (and the business analysis tools that lock them into that mindset) is what holds them back. I get it &mdash; comfort, momentum, familiarity are hard things to let go. But when they shift to an API-first mindset, it clicks and it becomes very freeing and powerful for all parties, and this leads to accelerated success."

Shane: Let's talk API governance - it's one of those things everyone nods about but few do well. How do you think about the balance between enabling developer velocity and maintaining standards?

David: This one is relatively easy to position, because standards are precisely what enable productivity and deliver velocity. Imagine how slow you would be if you also had to take time to invent, implement, and harden a new authorization protocol instead of relying on standards such as OpenID Connect and OAuth 2? Reality Check: no existing libraries, frameworks, tools, agents or infrastructure would integrate with your non-standard API. Who would consume your API if it were not built upon the standards that all developers know and expect
API Governance is all about managing risk&mdash;reducing risk and enabling velocity by following standards, so teams can focus on getting their unique capabilities right, rather than re-implementing the API "chrome" of HTTP or JSON or OAuth2 or encryption or inventing a new protocol that no one else understands.
The other dimension of your question is balancing developer creativity vs. following standards. I spoke about this at my talk at the Nordic APIs Austin API Summit in 2024.

Shane: You talk about 'APIs as a Product' - what does that mindset shift mean in practical terms? How does it change how you build, document, and support APIs?

David: I hinted at this above&hellip; There is a spectrum of engagement in APIs as a Product. The most trivial (and least useful) is the "widget" approach to commoditizing and commercializing digital products, as done with any product. The other extreme is full buy-in throughout the organization to "API all the things", to rephrase your main business value as digital capabilities that are available via APIs and which allow innovation and growth by inviting other organizations to partner with you. This is a monumental shift, because it requires a significant investment in doing it right &mdash; getting security right, getting consistency and evolution right, aligning teams on a strategic vision, addressing Developer Experience. For the business, seeing APIs as part of the innovation chain, as part of what brings your business' value to customers, shifts it from being an expense sink to a growth product.

Shane: Developer Experience is core to your role. What are the most common DX sins you see API teams commit? And what separates a 'good enough' API from a genuinely great one?

David: I think the most common mistake is for engineers to not think like their API consumers. This applies to so many aspects, from using internal jargon, to making unstated assumptions about intimate internal knowledge about how things work, to missing the core abstractions and concepts that consumers think about&hellip; or simply not answering (in the API design, or in the accompanying documentation) the important questions that developers needs to know about your API.
My goal is to make APIs a joy to work with. If you have ever worked with a library that "thought" the way you did and which made it a breeze to use, vs. a highly opinionated competing library that incurred mental load that was all friction and confusion, then you know joy vs. agony.
"Good enough" is an API that allows solving the obvious problems, whereas a Great API and corresponding developer experience are truly expressive, adaptable, intuitive, flexible, simple, composable, and comprehensible, yet highly usable. They allow solving the 20% obvious use cases as well as the 80% harder use cases. Of course, the risk is making the API too general, too complex, too abstract, so it does everything poorly but does nothing well. Never trade simplicity and directness for overly abstracted "elegance". Ever try to program an actual Turing Machine? Sure, it can perform any computation, but at what cost to Developer Experience? DX means delivering the right abstractions based on the API consumer's conceptual model, not an API coupled to some elegant platform design that they don't care about."

Shane: When you think about your external developer partners using Apiture's open banking APIs, what metrics or signals tell you the developer experience is working?

David: We have the great fortune of working with a world-class Support team and an equally stellar Customer Success team, so we get great (and fast) feedback from partners through them. Our company mantra has always been to "Treat every customer like they were your only customer", so that leads directly into seeking and accepting great feedback. We hear it when someone can't achieve their goals, and also when they do succeed

Shane: What's your philosophy on API versioning and evolution when you have that many partners depending on your APIs? How do you ship new capabilities without breaking things?

David: Joshua Bloch wrote, "Public APIs, like diamonds, are forever." I once gave a talk on API evolution and backwards compatibility at SAS, where I took a SAS program from the 1976 SAS Manual and ran it on the most recent version of SAS &mdash; and it worked, unchanged, 40+ year later. That's my goal with APIs&mdash; design for evolution by building in enough extensibility to allow for the system to change. We've done a great job of this, by understanding and anticipating how a system can or will change, and guiding partners along the way. We're lucky enough to be able to build and validate our APIs alongside our front-end mobile and web and system applications, to get early enough feedback. But just as I mentioned the API First myth above, we also push back heavily on the product team to get firm commitments about what can change in the future. For example, cardinality is always a critical aspect of API design, so whenever we get a requirement for one of this, or two of that, we always push back and design things with arrays to allow future evolution, or use arrays of objects rather than arrays of strings, to allow the data to evolve in multiple dimensions.

Shane: CSI just acquired Apiture, and the press release specifically called out your 'API-first platform' and 'API-driven flexibility' as key value drivers. That's not typical M&A language. What do you think that signals about where API strategy fits in the broader fintech landscape?

David: I'm heartened to hear this, certainly. I hope this bodes well for the broader industry. There is certainly a lot of activity and change in the industry, but APIs are here to stay, especially with the growth of AI agents. By being thoughtful and by recognizing the growth enabled by partnerships built on APIs, others will also position APIs as an crucial dimension of their portfolio. And investment firms etc. will be looking at API enablement and robust API governance and developer experience as hallmarks of mature, valuable companies.

Shane: Who are some other API leaders or companies doing interesting work in this space that you admire or learn from?

David: Top of mind is Matthew Reinbold. I appreciate his thoughtful analysis and consistent reminder that most of our industry problems (especially those around API Governance) are people problems, not technology problems. We also learn from the past, and his work on software forensics is so valuable and intriguing

I'll attend a keynote or talk by Mike Amundsen any chance I get.

I also admire Kin Lane , of course, as he has established a long record of telling stories about API success and for building and inspiring our community around the people behind the APIs."


Shane: Last one - if someone's reading this and thinking about how to mature their own API program, what's your advice on where to start?

David: There is no reason to jump into this alone. I feel lucky to be involved with such a great community of passionate people who want to help each other. When you can, attend conferences and make yourself known. Don't be shy, because everyone is helpful and wants to see their peers succeed. Participate to the extent you can &mdash; even sign up to present at an API conference

One of my favorite quotes, attributable to Richard Feynman:
"If you want to master something, teach it!".

I hope you enjoyed the article. Thank you again Shane for this and other
[#BehindTheAPI](https://www.linkedin.com/search/results/all/?keywords=%23behindtheapi&origin=HASH_TAG_FROM_FEED)
content. I hope all my readers will check it out - there's
lots of great content there &mdash; please read!

<hr>

{% include discuss.md %}

{% include orig.md %}
