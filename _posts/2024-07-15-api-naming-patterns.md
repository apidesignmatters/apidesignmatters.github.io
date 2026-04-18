---
title: API Naming Patterns
date: 2024-07-15 18:00:00 -0000
layout: post
tags:
  - the-language-of-api-design
  - api-design-patterns
---

> Patterns for naming things in APIs

While [CRUD]({{'/2024/06/17/oh-crud'|relative_url}})
may be the most common pattern in RESTful APIs, how to name things sure seems to be the most talked about.

Next up in the [API Design Patterns]({{'/api-design-patterns' |
relative_url}}) series on API Design Matters, I'd like to present
a common pattern for managing API resources.


Certainly, one can name API elements without following any
pattern&hellip;. that will likely yield unfavorable results. As I noted
in my
[The Art of API Design]({{'/2024/04/11/the-art-of-api-design'|relative_url}})
presentation at the 2024 _Nordic APIs Austin API Summit_, you could get creative and start using musical notes or Greek letters to name things&hellip; but that will hinder the usability of the API. In other words, applying consistent naming patterns will increase the usability of your API&hellip; and that won't hurt adoption.

{% include language-of-api-design-series.md %}

![alt text]({{ '/assets/img/API-Naming-Patterns.png' | relative_url}})

Matthew Reinbold posted in [Net API News](https://netapinotes.com/) in September 2023 about
[The Necessity of Naming in APIs](https://netapinotes.com/the-necessity-of-naming-in-apis/):

> "naming should convey the API producer's mental model to many consumers with minimal fuss" &mdash; Matthew Reinbold

> "To lower the cognitive overhead required to integrate with your API,
> you must consider naming design issues. It is the #1 thing that an API
> producer can do to improve a design, always." &mdash; Matthew Reinbold

Matthew lists serval factors that contribute to the long-held (and
justifiable) belief that naming is hard, then recommends a book,
[Naming Things: The Hardest Problem in Software Engineering](https://leanpub.com/naming-things?ref=netapinotes.com)
by Tom Benner.

So there is a lot of good advice on choosing domain names for your API.
I'm going to step back and suggest naming patterns in APIs to improve
the _developer experience_. Using consistent naming patterns (or using
any pattern consistently, when it is the right pattern) will help lessen
the cognitive load when others try to adopt your API. But consistent
naming will also help you in the design process&mdash;basically, a
naming pattern serves as a preemptive design decision that removes the
need to make lots of similar decisions in the rest of the API design
process.

For example, here is a list of the important (OpenAPI) API elements that require a name from the API designer:

* Path elements
  * static path elements
  * dynamic path elements - path parameters
* Operation IDs
* Requests and Response Headers
* Query Parameters
* Schemas
  * schema names
  * object property names
  * string enumerations
* Response objects
* Parameter objects
* Security Schemes
* Security scopes

With each name, you have a some important name attributes to consider:

* Style &mdash; do you use snake_case, _camelCase_, _PascalCase_,
  _kebob-case_ (something else?)
* Is the name _case sensitive_ or _case insensitive_? Both OpenAPI and
  HTTP sort of make this decision for you - most names in the OpenAPI
  Specification are _case sensitive_. However, HTTP says that _header
  names_ are _case insensitive_. The convention adopted in many
  revisions of the HTTP standards are to use _Title-Kebab-Case_ for
  headers, such as `Content-Type`, `Content-Length`, `Retry-After`, and
  so on.

Rather than defining a separate naming rule or pattern for each
category (I count 14 naming categories above), I have adopted a meta rule for API design: Unless otherwise
indicated, use _camelCase_ style for all names, with the exception of
header names, which should follow the _Title-Kebab-Case_ style described above.
(Every rule needs an exception, so that you can claim a small bit of
edginess or sense of rebelliousness.) I prefer using _camelCase_ because
such names can be used as programming language identifiers in most
programming languages without transformation rules, and OpenAPI also
uses it throughout (for example `operationId`, `securitySchemes`,
`requestBodies`, etc. &mdash; perhaps for the same reason :-) )

This does not cover _all_ naming situations. Heres a few more naming
patterns&mdash;beyond the purely syntactic style pattern&mdash; that I
have adopted:

## URL Paths

* I use plural names for the domain resource (entity) collections, such
  as (in our API Design Matters Chain Links sample application's domain
  example): `/chains`, `/chainLinks`, `/authors`, `/universes`, `/characters`,
  etc. (Note how the compound-word resource term "chain link" becomes
  `chainLink` via the _camelCase_ style). Others prefer using kebab case for
  path elements (i.e. `chain-links). This is perfectly valid, although it
  deviates from the "one pattern to rule them all" that I prefer. This is
  a matter of preference and style, so _choose one rule and use it
  consistently throughout your API_.
* For path parameters which indicate the unique resource ID of an
  instance within a collection, I use a `<resourceName>Id` naming pattern:
  `/chains/{chainId}` , `/chainLinks/{chainLinkId}`, `/authors/{authorId}`,
  `/universes/{universeId}`, `/characters/{characterId}`, and so on.

## Operation IDs

The `operationId` assigned define in each operation object is often used
in code generation as the name of a function or method to invoke the
operation. Thus, I start all `operationId` names with direct present-tense
imperative verbs, such as `listAuthors`, `createUniverse`, `getCharacter` etc. I use `list`
for operations that return lists or collections of API resources and `get` for
operations which return individual instances within collections or other
non-collection resources.

## Model Schemas

The model schemas in APIs are the names of _things_ and thus should use
_nouns_ or _noun phrases_, such as author, `character`, `universe`,
`chain`, and `chainLink`.
For convenience thoughout _API Design Matters_, I'll use a generic _camelCase_
placeholder `{resourceName}` for the name of an API resource when
talking about naming patterns, not about a specific API resource. The case
here is significant. For example, for the "chain link" domain resource
for the Chain Links API, `{resourceName}` is `chainLink` and `{ResourceName}`
is `ChainLink`.

Here are the API naming patterns for model schemas (used in request and
response bodies):

* `new{ResourceName}` is the name of the model schema used (via a `POST` operation) to create
a new instance in the [create]({{'/2023/08/27/getting-creative-with-openapi'|relative_url}})
operation. Example: `newChainLink` is the request body to create a new
chain link.
* `{resourceName}Patch` is the name of the model schema used for the for
  a `PATCH` operation request body. Example: `chainLinkPatch` is the request body to patch
  an existing chain link.
* `{resourceName}Update` is the name of the model schema for the `PUT`
  operation request body to replace a resource with a completely new representation.
* `{resourceName}` is the name of the model schema normally returns from
  a GET operation, or in the response from the create or patch or
  replace  operation, such as `chainLink`.

By applying these model schema naming patterns with the operation ID and path element patterns, larger aggregate patterns become evident.

To create a resource:

```text
POST .../{pluralResourceName}
operationId: create{ResourceName}
request body model schema: {newResourceName}
response body model schema: {resourceName}
```

For example:

```text
POST .../characters
operationId: createCharacter
request body model schema: newCharacter
response body model schema: character
```

## Property Names

In general, the names of properties in an object model should use
the names from your domain model and ubiquitous language. However, there are a number
of commonly repeated property names which pop up, regardless of domain.
Having "reserved" property names as part of your API pattern language
can guide your consistent API design:

* `id` &mdash; the unique identifier (string ID) for a resource, often
  automaticalluy assigned by the API service in the `POST` operation that creates a resource. This `id` is used in the `.../{pluralResourceName}/{resourceName}Id` resource path to access the instance resource within the collection, such as `.../characters/{characterId}` or `.../authors/{authorId}`
* `createdAt` is an
[RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339) `date-time`
when a resource was created.
* `updatedAt` is the `date-time` the resource was last updated with a
  `PUT` or `PATCH` or other transformation operation. In general, I
  suggest using `{event}At` for `date-time` properties and `{eventAt}On` for
  `date` properties when the time of day is too precise and only the
  date is needed.
* The property `name` is for resources which have names (often names
  which people assign to them); `label` for resources which have
  slightly longer word-phrase labels that are displayed in the user
  interface; and `description` for resources which allow longer
  sentence-length or paragraph descriptions).

## Meta Patterns

### Name Everything

My preference is to provide names for _all_ API elements, especially
schemas &mdash; avoid using anonymous nested schemas (i.e. if a property
`p` within an object schema `s` is defined by another object schema (or
array of objects), do not define the schema for `s` in line. Instead,
extract them to a _named schema_. This is important for code generation
(Software Development Kits or SDKs) for your API, as different vendors
choose different "automatic" naming strategies for any anonymous/unnamed
schemas, and this can diminish usability of the SDK and therefore the
API. Such auto-generated names can often be overly long and cumbersome
because they tend to be derived from the context.

This applies not only to schemas nested inside other object schemas or
array item schemas, but to response object schemas, request body
schemas, parameters, and subschemas used schema composition with `allOf`.

Naming the schemas also makes it much easier to reuse a schema later,
and helps prevent code duplication and "API drift" &mdash; For example,
if someone reading the API later sees the same object structure with the
same four properties defined two or  more times, natural question arise:

1. Are these the same structures?
2. If not, why not?
3. Is the similarity accidental?
4. What is different about them?

Naming such schemas helps has several benefits<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
:

* It reveals your intention
* It eliminates the need for such questions about your design
* It removes the need for copy and paste (and copy and paste errors -- see [Don't Repeat Yourself When Designing APIs]({{'/2023/04/09/dont-repeat-yourself-when-designing-apis'|relative_url}}))
* It makes future maintenance and API evolution easier

### Use widely recognized domain names : your ubiquitous language

If you have used the [ADDR process](https://addrprocess.com/) or
domain-driven design and created a ubiquitous language&mdash;especially one
that is driven by external API consumers and feedback, that is a great
starting point for the names in your API. I encourage you to review your
API domain analysis and your API Domain's
[ubiquitous language]({{'/2023/02/15/api-design-first-is-not-api-design-first'|relative_url}})
and choose names from that common language, provided they are clear and
not based on jargon that is not really part of the domain.

### Use Standard Names

When there is an existing internet standard, use the names defined by that standard. This begins with the HTTP standard (for example, for header names such as `Content-Type`, `Accept`, `Accept-Language`, `Retry-After`), media type names such as `application/json`, `application/pdf`, `text/plain`, etc.

If you are using `application/problem+json` ([RFC 9457](https://www.rfc-editor.org/rfc/rfc9457.html)) representation for API problems/errors, use the property names it defines (`type`, `status`, `title`, `detail`, `instance`). ( [Your API Has Problems. Deal With It.]({{'/2023/03/26/your-api-has-problems.-deal-with-it'|relative_url}}) )

Few things will irritate a developer more than an API which does not
follow existing standards.

## Anti-Patterns

### Avoid Brand Names

One thing that I've learned over more than 35 years working in corporate software development is to _avoid using brand names or marketing names_ in API element names.

Brand and marketing names change over time&mdash;it is a fact of
software development. If you incorporate brand/marketing names into an
API, then the API becomes semi-obsolete when the name changes.

During my time working at one organization, I saw a single product renamed three separate times.

### Always Avoid redundancy and repetition

When naming properties inside a model schema, avoid repeating the model name in the model schema's property names. For example, use `universe.id`, `character.name`, and `author.name`, not `universe.universeId`, `character.characterName` or `author.authorName`.

## Avoid Jargon

Another anti-pattern is using jargon, especially if such jargon derives
from internal implementation choices such as code names, legacy systems,
or terms that have seeped in from other domains. If the term is not in
common use with a clear meaning understood by most domain practitioners
and/or your API consumers, that is a strong hint that the name requires more
thought. Better than writing documentation explaining why you chose a
name, it's better off to completely remove the need to ask such
questions.

## Summary

I've presented a small catalog of reusable patterns for naming elements
of APIs. I hope they work for you, or at least inspire you to create
your own patterns to increase the consistency and predictability of your
APIs.

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
Naming things gives you power over them. Or so I'm told.

{% include discuss.md %}

{% include orig.md %}
