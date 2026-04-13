---
title: Building an API Domain Model
date: 2023-02-21 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

In my last article, API Design First is not API Design First, I presented a vastly over-simplified introduction of a domain modeling process and its desired outcomes. Our goal is to build a shared understanding of the problem for our team, focusing on the domain's ubiquitous language. In this next foray into the prerequisite for good API design process, we're going to get down and dirty and apply some of this to our fictional software start up scenario to build a working domain model.

{% include language-of-api-design-series.md %}

![The Language of API Design &vert; David Biesack]({{'/assets/img/The-Language-of-API-Design-banner.png' | relative_url}})


Caveat: This series does not strive to teach an entire domain modeling
technique. I use my own process that is similar to the _[Align, Define,
Design, Refine](https://addrprocess.com/what-is-addr/)_ (ADDR) process in James Higginbotham's
_[Principals of Web API Design_](https://www.oreilly.com/library/view/principles-of-web/9780137355754/)_,
so there here are some similarities and also many differences. I am
sharing what works for me, with the hope that you will benefit from
that. I hope you are inspired to explore ADDR, Domain-Driven Design, and
other design processes like Event Storming, Arnaud Lauret's API design
canvas (from his excellent book,
_[The Design of Web APIs](https://www.manning.com/books/the-design-of-web-apis-second-edition)_),
Mike Amundsen's
[Web API Design Methodology](https://www.infoq.com/articles/web-api-design-methodology/),
and find what works best for you and your team.

The primary focus of API Design Matters is transforming requirements and domain models into an API design, not domain modeling. However, a robust and clearly articulated domain model ensures all stakeholders have the same vision for what you are building before design begins.

Let's begin!

## Scenario

We're going to define the ubiquitous language for our new social fan fiction application and create a shared Domain Model. Let's start with a reminder of what our little venture is. (We'll assume the founders have already done the hard part of selling the vision and convincing a VC firm to provide a few million dollars of seed money and building a business model, including a revenue model. Now we need to execute.)

> You work as a full stack developer for a new startup which is building a social platform for fan fiction authors. Authors create stories, called chains, using the characters from fictional universes, "chaining" together and remixing text, images, and audio and video media clips. These story elements are called chain links. Authors can mix and remix chain links into new chains, or branch one chain to create alternate story lines and endings. You are tasked with creating the ChainLinks REST API for a web service to be used by the web and mobile experience applications.

That's a start, but not quite enough to work with, so let's build this out with a more in-depth user story that the application must support, and by inference, what the API will need to support. Rather than a trivial toy-like example, we want a scenario that is rich enough to evoke interesting design questions, but not so complex that we get mired down with lots of irrelevant details. In real life, applications and API services are large and complex. This series, though, is about using the Language of APIs to map product and feature sets into good APIs, not how to architect large complex systems.

> As a fan fiction aficionado, you have been reading published Chains on the ChainLinks site for a few months. You decide you would like to begin authoring stories (chains) yourself. You register on the site as a new author, with the pen name Harbold Quickstrike. You like fantasy and decide you wish to write a new chain in an existing universe called Sorrdith that is populated with many interesting characters, mostly people, wizards, and dragons.

> You decide to create a new chain titled Fledgling Dragons, which will be the saga of some young dragons and the trouble they cause when they start exploring their world and interacting with some characters you like from other chains.

> You create two new characters in the universe, "Flurry" and "Flingding". Flurry and Flingding are two fledgling dragons and nest-mates. You create brief descriptions of each character.

> ![Flurry and Flingding dragons in flight]({{ '/assets/img/Flurry-and-Flingding.png' | relative_url}})

> To get the chain started, you draft three chain links to introduce the characters and establish their storyline. After creating each draft, you revise the content over several days until you are happy with it. After you have authored the three chain links, you add them to the Fledgling Dragons chain and publish the chain so others can pick up the storyline.

OK, that should suffice for kicking off some brainstorming and starting the domain modeling process of capturing the core of the ChainLinks service so we can confirm the model with all stakeholders. (We don't have a real team to work with, so we will have to imagine/simulate iterating on this with others.)

## Exercise: Capturing a Domain Model

Our first step is to review the vision and story above and define our domain, contexts, and our ubiquitous language. Remember:

The ubiquitous language is merely the vocabulary or set of terms that are pervasive and well-understood within the domain.

Remember, you are tasked with just creating the ChainLinks service and API. We will constrain the scope of the example to just that of creating characters and universes, authoring story elements and story lines based on the characters in those fictional universes, and remixing content from other authors to extend existing story lines.

We'll start with defining a subset of the Domain Model elements. (view
their definitions from this previous API Design Matters article, )

* Domain & Domain model
* Context
* Resources
* Actors
* Behaviors
* Constraints

I encourage you to try this out yourself before reading further. Download this template and fill it in (or fill it out, whichever you prefer). I've seeded the template with some prompts and some initial content.

I'll wait here while you take the time to think about the problem and solution domain. It's OK, I'm very patient...

Not so quick! Really, copy that template and fill in a few ideas! What fits within the domain? How can you narrow the context so it is achievable for a minimally viable product? How can you remove any ambiguity, increase understanding?

OK, good. I told you I was patient!

Some observations on domain models:

While it is important to define what is and is not in scope-the context boundaries-it is also important to avoid the pitfall of trying to enumerate the full negative space of what is out of scope. Why? Because that space is infinite. Instead, focus on identifying closely related domain features and only list those features that are out of scope. Although one can easily "cheat" and implement only the exact requirements the product team has listed, that would be a disservice. The point of the domain modeling collaborative exercise it to explore the space and offer perspectives that others may not have thought of. Everyone's experiences count in this phase.

As you worked with the Domain Model, you may have noticed what is not mentioned in the template: APIs. What else is omitted? A user interface design. It is important that the domain model remain an abstraction that all stakeholders can use and understand. The API model will fall out of the Domain Model once consensus is reached and the API Design phase begins.

The outcome from this domain modeling process should be a comprehensive understanding of what the customer or client does within the domain and the application, not how the application implements those behaviors or even how the API addresses those behaviors. That is, the domain model should express what resources the customer or client interacts with, not how the application implements or stores those resources. The model should anticipate and answer questions the team members may have about the domain and its context boundaries. We're taking some shortcuts here since this is a learning exercise, but real-world domain modeling can (and should) take days to complete. The ultimate goal is to deliver a set of SMART (specific, measurable, assignable, realistic and time-related) product requirements so the API design team can proceed with API design, the User Experience design team can proceed with UX design, the Quality Assurance team can proceed with acceptance, functional, regression, stress, and other test ware design, with some level of autonomy and confidence.

Next up: we'll kick-start the API design process using the OpenAPI
Specification.

Thanks for reading _API Design Matters_!

{% include discuss.md %}

{% include orig.md %}
