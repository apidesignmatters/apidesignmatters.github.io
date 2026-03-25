---
title: API Design First is not API Design First
date: 2023-02-15 18:00:00 -0000
layout: post
tag: the-language-of-api-deign
---

To kick off The Language of API Design series, we will take a brief but
important diversion from the OpenAPI Specification and it's unique but
powerful language of API design. Our detour will focus on a different
sort of language: the _ubiquitous language_ of Domain-Driven Design.

<a id='footnote-1-ref'/>
In other words, today, I'm "Mr. Language Person".[<sup>1</sup>](#footnote-1)

The term "API Design First" is quite popular now, but it is misleading. If one began by first creating an API design (fun as that may be for some of us), the result is likely not going to meet any real business need. Something needs to inform that design. That is, you need to know what problem your API is solving and what value the API brings to your consumers, before design starts. In many organizations, the folks who assess business goals and strategy have a "product" focus. They know the customers and their customer's needs and coalesce them into a series of user stories and other activities which result in a set of requirements. They are the folks who, acting as the voice of the customer, decide what needs to be done. Then the architects and engineering and technology teams decide how it will be done-often with an API. (That's good for you and me-Go APIs Go!)

![Banner graphic reading "API Design First is not API Design First" &vert; "The Language of API Design" &vert; "David Biesack" in bold graphic text]({{'/assets/img/API-Design-First-is-not-API-Design-First.png'
 | relative_url}})

Thus, our journey begins with the true "First" step of leaving Bag End.
You step onto the road, and if you don't keep your feet, there's no
knowing where you might be swept off to...

Sorry, LOTR:FOTR is on.

Our journey begins with the true "First" step that comes before API Design: knowing why you are building an API. API development projects begin by understanding product requirements in order to design an API that solves a specific set of business problems. This may be a new, innovative idea, or it may be creating an API that exposes an existing critical business capability or information.

There are many techniques for developing good product requirements, but I've had success with a method much like that outlined by James Higginbotham in his book Principles of Web API Design. The four phases he outlines-Align, Define, Design, Refine-put structure around this process so your team can be as effective and productive as today's competitive market demands. The ADDR process draws heavily from Domain-Driven Design (DDD). The Align phase is critical to aligning all stakeholders on the requirements-the expression of what needs to be done. The Design phase focuses on how those requirements map into software and an API design. (That design phase is the bulk of most of the upcoming Language of API Design series.)

I endorse reading James' book and/or attending one of James' workshops to learn all the details of ADDR, Jobs to be Done, and more.

## Know the Lingo

DDD defines what is called the ubiquitous language. Let's demystify it, because it's not nearly as mysterious as it sounds. DDD focuses on clearly defining and communicating the problem domain. Each problem domain defines a context in which actors in that domain behave and operate, and the entities that they operate on. The ubiquitous language is merely the vocabulary or set of terms that are pervasive and well-understood within the domain.

he ubiquitous language is merely the vocabulary or set of terms that are pervasive and well-understood within the domain
As the product team defines the requirements of the domain, those requirements should refer to and are expressed using the terms the domain experts use daily. A critical component of expressing requirements is to map out that ubiquitous languagedefine the domain vocabulary-and then use those terms consistently, unambiguously. Hypermedia documents such as Wikis are very useful for this purpose because the first use of a term in a document can easily link to its entry in the domain glossary.

## The Ubiquitous Language of DDD and API Modeling

DDD has its own ubiquitous language. Warning: we're going to go a little meta here. I'll define the ubiquitous language of DDD so the remainder of this series (and throughout _API Design Matters_), you'll know what I'm talking about when I use these terms. In the next issue of The Language of API Design, you will get practical and define the ubiquitous language for a sample domain and scenario that will be, well, ubiquitous in the series.

Here are the terms in the DDD ubiquitous language. (Fanfare, drumroll, or both should be playing in your head right about now.)

### Domain

> The application or solution domain that your software product will improve, such as exposing your company's processes or goods, or the next killer app to solve personal productivity once and for all.

### Domain model

> A system of abstractions that describes pertinent aspects of the solution domain, used to model and solve problems related to that domain.

### Context

> Defining a context helps put boundaries around the problem and the solution: what is in scope, what we ignore. In software architecture, the use of bounded contexts helps create services and APIs that are bounded and focused on the context rather than trying to solve everything.

### Entity (Resource)

> DDD uses "Entity" to refer to the business objects within the domain; the "things" in the domain. When mapped to APIs (and specifically RESTful APIs based on resource-oriented architecture), entity is interchangeable with resource. In API Design Matters, we prefer to use the broader API term Resource rather than Entity from the narrower area of DDD. Sometimes something's gotta give and something's gotta win. If you already have a background and familiarity with DDD, then simply s/resource/entity/g when reading API Design Matters.

### Traits

> A list of (reusable) characteristics or attributes that apply to this domain's resources and behaviors.

### Value Object

> A data structure that contains data properties, also known as a Data Transfer Object. Value objects are usually representations containing one or more properties of a resource, but they can contain other data, such as requests and responses, options, etc. An astute reader may note that requests and responses, options, etc., can also be resources. In APIs, a JSON or other representation of a resource is a Value Object.

### Events

> An activity that occurs in the domain that are within our context and thus are of interest to domain experts. Events can be triggered by the actors in the system, such as application users interesting with the application, triggered by system activity, or outside agents interacting with the system.

### Actor

> Someone or something that interacts with the system.

### Behavior

> The activity that an actor performs in the system when interacting with the resources. Behaviors are the business actions within our domain's contexts-what the users do.

### Constraint

> Conditions which put bounds on our context. Constraints can be large and small, such as a system invariant (something that is always true before, during, and after a behavior) or a minimum/maximum value range of a property in a value object.

You are now equipped with a Ubiquitous Language of both API requirements
and API models. Whether you define requirements or whether you must
implement an API and service to satisfy requirements that someone else
has given you, using these concepts in a structured way will help
communicate the problem domain to all the key stakeholders: the
customers, the product team, the engineering team, the quality assurance
team, the executives. By collaboratively building a shared understanding
of the domain, and defining your own ubiquitous language for that
domain, you help ensure everyone on the team has a shared understanding
of the all the key concepts and terms. Your ubiquitous language creates
the vocabulary for building that first-of-firsts critical to API First
Design.

Next up, we'll do the inverse of going meta and get more concrete with
an example of defining an API model using these DDD concepts for a
fictional but realistic domain that we will use throughout The Language
of API Design.


<hr>
<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
"Mr. Language Person", shamelessly stolen from another Dave B. author. For the record, If Dave Barry vows to not claim API design cred, I vow to not claim I've won a Pulitzer Prize for Commentary.

{% include discuss.md %}

{% include orig.md %}
