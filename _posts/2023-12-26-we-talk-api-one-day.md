---
title: We Talk "API" One Day
date: 2023-12-26 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> What we mean when we talk about APIs

In case you have not caught on by now, I'm a bit of a language geek. I
like to ruminate on languages, how well they express ideas, and how we
use them, and how the structure and capabilities of languages change the
way we think and how we solve problems. This is what my _Language of API
Design_ series is all about.

{% include language-of-api-design-series.md %}

![alt text]({{ '/assets/img/The-Language-of-API-Design-banner.png' | relative_url}})

Today, I'm "going meta". I'm not going to talk about how languages (like
the OpenAPI Specification and JSON Schema) describe specific API
concepts and artifacts, but rather how we talk about APIs themselves. In
other words, I want to explore the
[Ubiquitous Language]({{'/2023/02/21/building-an-api-design-model' | relative_url}}) of APIS.

> The ubiquitous language is the vocabulary or set of terms that are
> pervasive and well-understood within the domain.

The word "language" gets thrown around a lot:

* specification language
* programming language
* constraint language
* mini-language
* domain-specific language
* modeling language
* data definition language
* query language
* ubiquitous language

## What do I Mean by "Language" When Talking About the Language of APIs?

To me, a language is a means of communicating ideas and concepts. There
is intent behind a language&mdash;a reason for its existence. The author
uses a language try to communicate an idea or concept with that
language, so that a program or a person can understand and process it as
intended, with the fewest errors in interpretation.

There are myriad ways we measure the quality and value of languages:

* How well does the language communicate the author's intent and meaning?
* How well does communication in the language achieve the author's goals?
* How easy is it to process source written in the language (parse it, compile it, interpret it, generate code from it, etc.)?
* How precise or ambiguous is the language?
* How close is the language to the conceptual model of what it represents?
* How concise or verbose is the source written in the language?
* How consistent is the language?
* How large is the language?
* How easy is it to learn or master?
* How well-equipped is the language to evolving or growing over time to
  ccommodate changes, such as accommodating new concepts?

There are two classes of languages I want to discuss. The first is our
own human languages (I use English); the second is technical languages,
such as the OpenAPI Specification and JSON Schema.

## The Human Language of APIs

Like any other topic that we talk and write about, our use of Human Language to describe APIs is fuzzy. Because of the inconsistencies and contradictions in these Human creations, learning a language can be frustrating, confusing... even humorous, Like David Sedaris learning French in [_Me Talk Pretty One Day_](https://en.wikipedia.org/wiki/Me_Talk_Pretty_One_Day).

Let's explore the frailties of Human Language we use to talk about APIs.

![An "API" word cloud filled with colorful Words]({{ '/assets/img/api-word-cloud.png' | relative_url}})

The term "API" itself is unclear because we do not use it consistently. In the context of _API Design Matters_, I primarily discuss Web APIs: APIs that allow distributed systems to communicate with each other via internet protocols. However, "API" is overloaded&mdash;it can also mean a programming language library, such as the [Java Text API](https://docs.oracle.com/javase/8/docs/api/java/text/package-summary.html), or even a command line interface such as the Linux [`find`](https://man7.org/linux/man-pages/man1/find.1.html) command. The latter are primarily APIs for applications running within a single process, most commonly on one machine.

However, even in the narrower domain of just "Web APIs", we may differ
on what "API" means. I don't mean there is argument about whether "API"
as an [initialism](https://simple.wikipedia.org/wiki/Initialism) means
"Application Programming Interface", but rather what that term refers to.

Some people use "API" to refer to a single operation within a larger
suite: for example, GitHub's
_[List forks](https://docs.github.com/en/rest/repos/forks?apiVersion=2022-11-28#list-forks)_
operation is "an API" to some. Others use "API" to refer to an entire API suite, such as ["The GitHub API"](https://docs.github.com/en/rest) or ["The Slack API"](https://api.slack.com/apis), as a collection of capabilities. I'm strongly in this latter camp.

Using the terminology of the OpenAPI specification, I refer to the
combination of an HTTP method (like `POST`, `PUT`, `GET`...) and a resource path
such as `/repos/{owner}/{repo}/forks` as an _operation_. In OpenAPI, one can
assign an `operationId` to each operation, further cementing the
terminology.

For example, see the GitHub API's [OpenAPI definition](https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/ghes-3.9/ghes-3.9.2022-11-28.yaml).
This OpenAPI document
defines an operation named `"repos/create-fork"`:

```yaml
 "/repos/{owner}/{repo}/forks":
    post:
      summary: Create a fork
      description: ...
      tags:
      - repos
      operationId: repos/create-fork
```

Thus, an API is a collection of related operations that enable a set or
capabilities.

>an API is a collection of related operations that enable a set or capabilities

## Endpoint

The word "endpoint" is also used somewhat widely (and inconsistently).
Normally it is used to refer to a path in an API. For example, in the
GitHub API, one may refer to "the `/repos/{owner}/{repo}/forks`
endpoint". Sometime "endpoint" refers to a specific operation (such as
`GET`) available on that path, although an API may contain several
operations on each path.

To me, "endpoint" sounds like a destination: the end of a journey, whereas in APIs, one operation (or its response) often leads to other operations or other resources.

Thus, I avoid this term and use "operation" to be more precise.

## Swagger

This term, or perhaps its misuse, raises the most eyebrows. "Swagger"
was the name of the first versions of the API definition specification
(up until version 1.2), before the OpenAPI Initiative open-sourced the
technology as the OpenAPI Specification as OAS 2.0 on 2015-12-31.
"Swagger" is now a brand name for a set of tools and is owned and
governed by Smartbear.

> The OpenAPI Specification, formerly known as the Swagger
> Specification, is the world's standard for defining RESTful
> interfaces. The OAS enables developers to design a technology-agnostic
> API interface that forms the basis of their API development and
> consumption.
> &mdash;
> [OpenAPI Specification and Swagger](https://swagger.io/solutions/getting-started-with-oas/)

When someone says a document is a "Swagger document", it is a holdover
from those pre-OAS days. I also abstain from this terminology because
"Swagger" is a brand name and it does not apply to _all_ OpenAPI
documents. One of my favorite API memes mirrors the over the top
reactions some people have when others utter "Swagger" when they should
really say "OpenAPI":

![alt text]({{ '/assets/img/Batman-slaps-Robin-its-been-OpenAPI-since-20Bloody16.png' | relative_url}})
<br>
_Batman slapping Robin, who used the word "SWAGGER"; Batman replies "ITS
BEEN OPENAPI SINCE 20BLOODY16". Source unknown but there is
[a backstory to the meme](https://screenrant.com/batman-slaps-robin-meme-comic/)._

I don't slap people when they use "Swagger" when they should use
"OpenAPI". However, since the term "Swagger" is often misused, it does
bear correcting when it is misused, at least in print. Otherwise , unchecked use of "Swagger" results in confusion, such as one open-source tool for creating/editing "API documentation" calling itself ["Swagger Editor"](https://docs.scalar.com/swagger-editor)... despite that name already used for the open source [`swagger-editor`](https://github.com/swagger-api/swagger-editor) tool, now supported by SmartBear.

Arnaud Lauret (The API Handyman and author of the excellent
[The Design of REST APIs](https://www.amazon.com/Design-Web-APIs-Arnaud-Lauret/dp/1617295108))
started
[an interesting LinkedIn discussion](https://www.linkedin.com/posts/arnaudlauret_openapi-does-what-swagger-dont-activity-7140014875501568000-PsvZ?utm_source=share&utm_medium=member_desktop)
about the use of Swagger vs. OpenAPI and the "stickiness" of names,
which confirms my suggestion of forming the right (ubiquitous) language
habits for APIs early.

## REST, RESTful, REST-like, RESTish

REST is an acronym for Representational State Transfer, but what does
that really mean? Coined by visionary Roy Fielding to describe the
architecture of scalable web applications, "REST" has a decent
definition on Wikipedia, so I won't try to improve on it, or even
reproduce it here. Therefore the best and "most correct" definition of a
REST API (or RESTful API) is an API that adheres to the constraints of
the REST architectural style.

I interpret "REST API" or "RESTful API" more liberally than the above
stricter view, because I think most people's understanding and mental
model of "REST API" is also not as strict because I prefer community
consensus over pedantry.

> A RESTful API is a Web API which uses synchronous request/response
> exchanges between a client and a web service to transfer representations
> of domain resources and application state, using URIs&mdash;uniform resource
> identifiers&mdash;as the addresses of the resources (the domain entities)&mdash;and
> standard HTTP methods to invoke application actions on the resources.

(I describe the common use of the HTTP methods&mdash;GET to request a
representation of a resource or to list a collection of resources; POST
to create new resources, PUT and PATCH to update resource, DELETE to
delete resources&mdash;in
[Getting Creative with OpenAPI]({{'/2023/08/27/getting-creative-with-openapi'
| relative_url}}).)

REST is an architectural style, however, and HTTP (and an API's use of
the HTTP methods) is not required for an API to be a RESTful API.
However, most folks think of OpenAPI when they think of RESTful APIs,
and OpenAPI is tightly coupled to HTTP (because OpenAPI was designed to
define HTTP APIs.) Some may define "RESTful API" as "an API that can be
defined with the OpenAPI Specification". However, _OAS does not even
mention REST_ [here](https://www.openapis.org/) or [here](https://spec.openapis.org/oas/v3.1.0).

I'm somewhat relaxed in classifying APIs: A RESTful API is an API
designed with the REST architectural style as a guiding principle,
compared to other API styles, such as
[GraphQL](https://spec.graphql.org/) or
pAsyncAPI](https://www.asyncapi.com/) or
[gRPC](https://grpc.io/).

"REST-like" and "RESTish" are adjectives people apply to APIs that are
similar in style to REST APIs but which may not adhere to all of the
constraints of the REST architecture. OAS can also be used to describe
REST-like APIs. Most commonly, "REST-like" APIs are those which do not
implement the Hypermedia and code-on-demand constraints. But that does not mean such APIs are not useful - many are used every day to provide value, even if they are not "pure" REST APIs. However, by not addressing all the constraints of the REST uniform interface, such APIs typically sacrifice some of the benefits achieved by the REST architecture. That's OK&mdash;all software systems make some tradeoffs.

"RESTful" sometimes means an API which fully follows the constraints of the REST architecture. But fully REST-compliant APIs seem truly hard to find, and "RESTful" now often is a synonym for "REST-like".

## HATEOAS

This term is the most confusing, even though it has a more specific
definition: _Hypermedia As The Engine of Application State_. As with
REST, I think Wikipedia also defines
[HATEOAS](https://en.wikipedia.org/wiki/HATEOAS) well. Also first
defined by Roy Fielding, HATEOAS is an important characteristic (or
constraint) of a REST API&mdash;so much so that many authorities,
including Fielding, state that an API without HATEOAS is _not_ truly
RESTful.

> ...if the engine of application state (and hence the API) is not being driven by hypertext, then it cannot be RESTful and cannot be a REST API.
>
> &mdash; Roy Fielding, [REST APIs must be hypertext-driven](https://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven)

As we explore the Chain Link API, we can embed some hypermedia controls,
notably URLs of related resources, using the [_Restful JSON_](https://restfuljson.org/) notation. For
example the `universe` response from the `getUniverse` operation contains
hypermedia links such as `creator_url`, `characters_url`, and `chains_url`
which link to resources related to the universe:

```yaml
        id: uni-489f34dhj37sghj
        url: https://api.chainlinks.example.com/universes/uni-489f34dhj37sghj
        name: DragonTerr
        description: >-
           A world where dragons rule, but not without challengers.
        createdAt: '2023-08-23T18:34:10.444Z'
        creator_url: /authors/au-ndklxhjf8933x0
        characters_url: /characters?universe=uni-489f34dhj37sghj
        chains_url: /chains?universe=uni-489f34dhj37sghj
```

(A future article in _API Design Matters_ will discuss HATEOAS in more detail.)

## API First, API Design First, Code First API

These terms are also mentioned quite frequently when discussing APIs. These terms refer to the development methodology and process that API producers use to deliver APIs. _API Design First_ starts with designing the API first, then developing the code to implement that API. OAS is most useful for API Design First because it allows one to use additional tools to automate much of the development process, such as generating API documentation and generating software development kits (SDKs) for the consumers, generating mock servers that a front-end team can use to develop client applications before an API has been implemented, or even generating server code stubs and classes/interfaces for the implementation. This process also allows consumers to provide early feedback on whether the API design meets their needs.

_Code First_ involves developing the implementation first, then either authoring an OpenAPI document to match the implementation or perhaps using tools to generate an OpenPI document from the implementation source, perhaps by extracting information from annotations or tags in the source. Manually authoring the OpenAPI document is the most error prone.

As I've written before (see
[API Design First is not API Design First]({{'/2023/02/15/api-design-first-is-not-api-design-first'
| relative_url}})), the general term "API First" or "API Design First"
is misleading because other tasks (such as domain analysis and SMART API
requirements) must come _before_ API design. Starting with API Design
First for Code First API risks implementing an API that does not deliver
the necessary features.

## The Language of Talking About OpenAPI

There are several words in use for referring to APIs defined using the OpenAPI specification. I present some terms with my opinion on their use. I'm not trying to be the language police; I'm merely trying to avoid confusion and improve our communication and common understanding when we talk about APIs.

## Description

GitHub's API repository
[rest-api-description](https://github.com/github/rest-api-description)
uses the term "description" :

> This repository contains [OpenAPI](https://www.openapis.org/) descriptions for [GitHub's REST API](https://docs.github.com/rest).

That is, GitHub refers to the source files in that repository, written
using OAS 3.0 or OAS 3.1, as API ___descriptions___.

I do not use this term, as I think "description" is too ambiguous. There are many ways to describe an API. For example, it could be a Web API, A RESTful API, a verbose or concise API, an elegant API, a secure API, a consistent API, a well-documented API, an easy to use API, etc. These are all useful ways of _describing_ an API, so the term "description" is not very helpful when applied to a source file written in OpenAPI. I'm in the minority on this view, however; OAS even says

> ___What is the OpenAPI Specification?___
>
> The OpenAPI Specification (OAS) defines a standard, programming language-agnostic interface description for HTTP APIs, []
>
> &mdash; [https://spec.openapis.org/oas/v3.1.0](https://spec.openapis.org/oas/v3.1.0)

## Definition

I prefer the term "definition" to refer to a YAML or JSON source file (or set of files) written using the OpenAPI Specification, since that file _defines_ the API rather than just _describes_ the API. OAS even uses the term definition document:

> Use cases for machine-readable API definition documents include, but
> are not limited to: interactive documentation; code generation for
> documentation, clients, and servers; and automation of test cases.

## Document

The source file(s) that contains an OpenAPI definition is called a
document. It is coded in YAML or JSON and contains a definition of an
API or elements of an API (such as components and/or paths and/or
webhooks).

OAS defines an [OpenAPI Document](https://spec.openapis.org/oas/latest.html#openapi-document)

> A self-contained or composite resource which defines or describes an API
> or elements of an API. The OpenAPI document MUST contain at least one
> `paths` field, a `components` field or a `webhooks` field. An OpenAPI document
> uses and conforms to the OpenAPI Specification.

To me, the key point of this OAS statement is

> An OpenAPI document uses and conforms to the OpenAPI Specification.

## Specification

Another word that gets widely used, especially when discussing APIs
defined with the Open API Specification, is the term "specification",
often abbreviated as "spec". Some use it to refer to an OpenAPI document that defines an API,
such as the GitHub API's [rest-api-description](https://github.com/github/rest-api-description), as an "API Specification"
or and API's "OpenAPI specification" or for short, an "API Spec".

See this [LinkedIn post](https://www.linkedin.com/posts/sagar-batchu-981b3738_just-finished-up-the-recording-of-my-talk-activity-7137500630054563841-NaSf?utm_source=share&utm_medium=member_desktop) ([edits] and emphasis mine):

[a] company's API spec becomes the source of truth for more than just documentation. [It is] now the primary means of defining the shape of your SDK, the definition for your #chatgpt plugin and much more.
[...]
[you] can get a great SDK from your OpenAPI spec

I do ___not___ use "specification" or "spec" when talking about API
definitions written using the OpenAPI Specification. Instead, I
exclusively reserve the word "specification" for discussing the
stadards,
such as the [OpenAPI Specification](https://spec.openapis.org/oas/latest.html) (OAS) or the [Asycnc API Specification](https://www.asyncapi.com/docs/reference/specification/latest).

## Technical API Languages

At a low level, a language consists of a vocabulary and grammar. The vocabulary is the symbols, tokens, or keywords from which the language is constructed, and the grammar is the rules by which you compose those tokens into language constructs. The tokens by themselves do not convey much meaning, but the constructs built from those tokens are what capture and express the ideas of the language's domain.

OpenAPI is expressed in JSON or YAML. OpenAPI's syntax has some
boilerplate tokens due to that foundational JSON syntax, such as `{` `:`
`}` `[` `,` `]` , `true`, `false`, `null`, and JSON number and string literals. On top of that JSON substrate, OpenAPI defines keywords that define the structure and syntax of the language:

* `openapi`
* `info`
* `servers`
* `paths`
* `put`, `post`, `get`, `delete`, `patch`, `options`, `head`, `trace`
* `webhooks`
* `requestBody`
* `components`
* `parameters`
* `schemas`
* `responses`
* `content`
* `schema`

and so on.

[JSON Schema](https://jsonschema.org) is similarly expressed in JSON or YAML and has it's own vocabulary and keywords such as

* `type
* `number`, `integer`, `string`, `enum`, `array`, `items`, `true`, `boolean`, `false`
* `properties
* `allOf`
* `oneOf`
* `anyOf`
* `minimum`
* `maximum`
* `multipleOf`
* `minItems`
* `maxItems`
* `minLength`
* `maxLength`
* `format`
* `additionalProperties`
* `unevaluatedProperties`
etc.

To be fluent in the [Language of APIs]({{'/the-language-of-api-design' | relative_url}}), one must know what all these keywords mean, and more importantly, how to interpret the language constructs that these keywords introduce. These are not huge languages, and luckily humans excel at learning languages.

<hr>

I hope this presentation of the Ubiquitous Language of Web APIs will
help us all communicate clearly and effectively when we talk about APIs.

{% include discuss.md %}

{% include orig.md %}
