---
title: From Domain Model to OpenAPI
date: 2023-03-09 18:00:00 -0000
layout: post
tag: the-language-of-api-deign
---

Welcome to the next article in the Language of API Design. Rather than jumping into the middle of this series, I encourage new subscribers/visitors start by reading Your Guide to The Language of API Design and scanning previous posts in the series.

We’ve built quite a bit of knowledge of the Chain Links API now: you know what the API needs to do, and what the resources are, and some of the constraints and bounds for the resources and behaviors. You can view my more complete Chain Links Domain Model below—this will be the foundation for the Chain Links API design.

> [API Design Matters]({{'/' | relative_url}})
> __Chain Links Domain Model__
> I present here a possible Domain Model for the Chain Links application that accompanies The Language of API design series in API Design Matters. Below are several key elements of a Domain Model, with a brief description of each, Domain Model A social media app in which fan fiction authors can compose content, mix other authors' existing content in new way…
[Read more]({{'/2023/03/07/chain-links-domain-model.html' | | relative_url}}))

Now it's time to create an [OpenAPI definition](https://spec.openapis.org/oas/latest.html) to define and describe the API. This transformation of a domain model to an API definition is not strictly a mechanical task&mdash;there is some art and skill involved. It's best to establish and use some consistent API design patterns. While we use the Chain Links API as an example, this process can be generalized to other APIs.

To start, copy [this generic skeleton OpenAPI 3.1 document](https://gist.github.com/DavidBiesack/26b04db45565eff3d34d6f1733b36dd1) and save it as a file called `openapi.yaml` in your source repository. You will build from this.

We'll code the API definition in [YAML](https://yaml.org/spec/1.2.2/), although some prefer JSON. I find YAML easier to read and write since there are fewer necessary syntactic adornments like { braces } and “quoting”. YAML is a bit complex, but we'll use a simpler subset that maps easily and directly to JSON.

Go ahead and edit the info section to add a proper title and description
for the Chain Links API, based on the summary in the
[domain model]({{'/2023/03/07/chain-links-domain-model' | relative_url}}).

The first step I take is to define the API resource model—this is the relative URLs of the resources in the API. (This is my first step because the OpenAPI structure sort of imposes this on you.) In OpenAPI terminology, the resource model is the set of API paths in which the API operations are organized.

In order to define a path for each resource, you need to choose good
names.
[That's not always easy](https://martinfowler.com/bliki/TwoHardThings.html).
<a id='footnote-1-ref'/>'<a href='#footnote-1'><sup>1</sup></a>

> There are only two hard things in Computer Science:
> cache invalidation and naming things.<br/>
> &mdash; Phil Karlton

Naming resource paths is a style choice; I will share the naming patterns that I have used for several years. I try to make the mapping obvious and intuitive, so that the API design has a close mapping to/from my mental and conceptual model of the API and its resources.

* Most resources are divided into collections and instances within those collections. For example, some of the resource collections from our domain model are chains, chain links, universes. These will map to resource paths such as /chains , /chainLinks , and /universes. By convention, collections use plural noun names.
* These three resources are all independent of one another, so they are separate resource paths. The domain model calls for API operations to list those resources, which we'll define within those resource paths.
* Thus, to start, we will have these resource paths:

```
    /chains
    /chainLinks
    /characters
    /universes
    /authors
```
* As you can see, I've directly used the names from the domain model, rather than using generic terms like /stories instead of /chains and /storyElements instead of /chainLinks. This is a critical decision in API design. By using the domain terms from your ubiquitous language, it ties everything together consistently. (Imagine a Slack API that did not use its ubiquitous language of channels, pins, conversations, or bots.) However, using the domain language requires a small learning curve.
* The instances of these collection resources are subresources of those collections. Each instance is referenced with the unique resource identifier, or ID. For example, the URL of a specific chain instance will have an ID in the path, represented with a path parameter: `/chains/{chainId}`. The notation {chainId} in a path marks a path parameter; it will be replaced with the actual ID string of the instance. The chain with an ID value of `kf739d-4jksl` is accessed at the path `/chains/kf739d-4jksl` by substituting it's ID value for the `{chainId}` path parameter.
* This resource structure of nested resources reflects an explicit containment relationship. All the instances are logically contained within the collections, and the instance resource paths are nested beneath the collection resource paths. This is a fairly significant API design pattern.
* Now our resource model looks like the following:

```
    /chains
    /chains/{chainId}
    /chainLinks
    /chainLinks/{chainLinkId}
    /characters
    /characters/{characterId}
    /universes
    /universes/{universeId}
    /authors
    /authors/{authorId}
```

* I use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case) for almost all identifiers in API design, including path elements such as chains and path parameter names such as `chainId`. As you will see later, I also use this case convention for schema names, query parameter names, property names, enumeration values, etc. Some prefer kebob-case for paths, such as `/chain-links`. It is strictly a style choice. I prefer using lowerCamelCase uniformly, because it is just one simple rule to remember instead of many. My main recommendation is to pick a convention, then use it consistently.

The next step is to code this resource model in OpenAPI format. You define your resource paths with the paths object in the OpenAPI document. In your openapi.yaml document, replace the empty paths object

```
    paths: {}
```

with a nested object (in YAML format). We'll use empty objects {} as placeholders for the API elements that we will associate with each path—that will come soon. Let's just start with the collection resources:

```
    paths:
      /chains: {}
      /chainLinks: {}
      /characters: {}
      /universes: {}
      /authors: {}
```

The paths object is a container that can hold all the API elements that are associated with that resource path. Most often this is the HTTP methods (get, put, post, patch, delete) for the API operation definitions.

For example, from the domain model, we know we need an API to list all the chains, and an operation to list all the universes, and so on, to facilitate browsing the content in the Chain Links service. List operations apply to the collections, and are implemented with an HTTP GET method:

```
    GET https://api.chainlinks.example.com/chains
    GET https://api.chainlinks.example.com/chainLinks
    GET https://api.chainlinks.example.com/universes
    GET https://api.chainlinks.example.com/characters
    GET https://api.chainlinks.example.com/authors
```

To define these API operations, we replace the empty object `{}` placeholders with a
[path item object](https://spec.openapis.org/oas/latest.html#path-item-object)&mdash;a
set of name/value pairs that define API elements related to that
resource path. The names of the path item objects are the HTTP methods
(in lower case, which is conveniently also lowerCamelCase) and the
values are
[OpenAPI operation objects](https://spec.openapis.org/oas/latest.html#operation-object).
We will need separate API operation objects for each of these list operations.

Each operation needs a one-line summary, a more detailed `description`, and an `operationId`. The `operationId` uniquely identifies the operation instead of using the more cumbersome combination of path and HTTP method; it is also used as a function name for that operation in any SDKs we might generate for the API. For example, the operationId `listChainLinks` is easier, more informative, and more concise than get `/chainLinks`. , and the SDK will have a `listChainLinks(...)` function.

Here is our working OpenAPI document. It is not complete enough to be useable, but it shows the emerging structure of the API and the list operations:

```yaml
openapi: 3.1.0
info:
  title: Chain Links
  summary: Crowdsourced Fan Fiction
  description: >-
    A social media app in which fan fiction authors can compose content,
    mix other authors' existing content in new ways, to author and share
    new stories called chains, or continue existing chains.
    Each chain exists within a universe.
    Characters (of various species) can span universes and
    have roles in many chains.
  contact:
    name: David Biesack
    url: https://apidesignmatters.substack.com/
  license:
    name: MIT
    identifier: MIT
  version: 0.1.0
servers:
  - url: https://api.chainLinks.example.com
paths:
  /chains:
    get:
      operationId: listChains
      summary: List the chains
      description:
        Return a paginated list of the chains in the system.
  /chains/{chainId}: {}
  /chainLinks:
    get:
      operationId: listChainLinks
      summary: List the chain links
      description:
        Return a paginated list of the chain links in the system.
  /chainLinks/{chainLinkId}: {}
  /characters:
    get:
      operationId: listCharacters
      summary: List the characters
      description:
        Return a paginated list of the characters in the system.
  /characters/{characterId}: {}
  /universes:
    get:
      operationId: listUniverses
      summary: List the universes
      description:
        Return a paginated list of the universes in the system.
  /universes/{universeId}: {}
  /authors:
    get:
      operationId: listAuthors
      summary: List the authors
      description: Return a paginated list of the authors in the system.
  /authors/{authorId}: {}

components:
  parameters: {}
  requestBodies: {}
  schemas: {}
  securitySchemes: {}
```

The important thing to notice here is the uniformity and consistency that is emerging, due to applying the same API design patterns to all the similar resources and operations (“list the items in a resource collection C”). We'll see many more examples of applying patterns—the recognition and use of patterns is a central focus of _API Design Matters_.

<div style='text-align:center'>
<em>Uniformity and consistency emerge from applying the same<br/>
API design patterns to similar resources and operations</em>
</div>


Let's dive a bit deeper into one of these list operations, `getChainLinks` ( `GET /chainLinks`). This operation lists all the published chain links in the system. There can be thousands of them (and if our Chain Links app is a huge success, there will be millions), so it is necessary to employ pagination in the API. That is, the client makes one call and the API returns subset of data—called a page—from the larger collection. Then the client can request the next page, and then the next page. Normally, this is combined with some filter criteria which yields a subset of all the resources. (Few clients will ever paginate though the entire unfiltered collection.) The client can then render a visual representation of each chain link and allow the user to scroll. As the scrolling approaches the end of the page, the client can request the next page and add it to the view, yielding an “infinite scroll” interface, or a page-by-page experience.

The Domain Model behaviors indicate an author or other user browsing chain links:

> _Visitors, fans, authors can list and search for and read content by author, title, universe, character, or date-time when the content was published._

In order to enable browsing/listing chain links by author, universe, or character, these other resources may be referenced with their resource ID. I.e., each universe has its own id value (an opaque, immutable string), and each character has its own unique id value. Thus, we want to enable queries against the chain links collection resource such as

```
    GET /chainLinks?character={someCharacterId}
    GET /chainLinks?universe={someUniverseId}
    GET /chainLinks?author={someAuthorId}
    GET /chainLinks?authoredOn=[2023-01-01,2023-03-31]
```

Such queries are useful in various views of the Chain Links application.
For example, when viewing a specific character's biography in the app
(such as Flingding, one of the fledgling dragons from
[our user story]({{'2023/02/21/building-an-api-design-model| relative_url}})), the app will have that character's unique id available and can offer a button or link to “View Chain Links that mention Flingding”. If the character Flingding has a character id value of `ch-389fjk-3489djs`, then the API operation

```
    GET /chainLinks?character=ch-389fjk-3489djs
```

will return the first page of chain links. There may be just a couple, or many thousands of chain links which mention Flingding, depending on how popular Flingding is with authors. (Flingding is no Thor, Harry Potter, or Gandalf… at least, not yet.) If we want to limit the search to see if anyone has written about Flingding in the date range between 2023-01-01 and 2023-03-31, we can augment the search by including a date range filter:

```
    GET /chainLinks?character=ch-389fjk-3489djs&authoredOn=[2023-01-01,2023-03-31]
```

There are many ways to model queries that express relational operations such as the authoredOn date on or after a start date and on before an end date. Simple range notation works quite well for this:

`?authoredOn=[2023-01-01,2023-03-31]` means between two dates, including the endpoints

`?authoredOn=(2023-01-01,2023-03-31)` means between two dates, excluding the endpoints

`?authoredOn=[2023-01-01,]` means authored on or after 2023-01-01

`?authoredOn=[,2023-03-31)` means any date before but not including 2023-03-31

`?authoredOn=[2023-03-31)` means authored on 2023-03-31

Let's define those query parameters using OpenAPI. This is done by defining a parameters array in the listChainLinks operation, and defining four query parameters:

```yaml
  /chainLinks:
    get:
      operationId: listChainLinks
      summary: List the chain links
      description: Return a paginated list of the chain links in the system.
      tags: [ 'Chain Links' ]
      parameters:
        - name: character
          description:
            Subset the collection to chain links including or
            mentioning a character.
          in: query
          schema:
            type: string
            minLength: 4
            maxLength: 40
        - name: author
          description:
            Subset the collection to chain links authored by an author.
          in: query
          schema:
            type: string
            minLength: 4
            maxLength: 40
        - name: universe
          description:
            Subset the collection to chain links set in a universe.
          in: query
          schema:
            type: string
            minLength: 4
            maxLength: 40
        - name: authoredOn
          description:
            Subset the collection to chain links authored in
            a date range.
          in: query
          schema:
            type: string
            minLength: 13
            maxLength: 23
            examples:
             - '[2023-01-01,2023-03-31]'
             - '[2023-01-01,]'
             - '(,2023-03-31)'
```

Each parameter is an item in the array is defined with a parameter object that contains:

* The parameter's `name`
* A `description` which tells the developer how this parameter changes the behavior of the operation. (Pro tip: try to not just rephrase the parameter's name…)
* Where the parameter is located. In this case, these are all in: query, meaning they are passed to the API in URL query parameters. Other possible in values include header for parameters passed in request headers or and path for parameters pass in the URL path.
* A required attribute which indicates if the parameter must be passed in the API call, or if it is optional. The required attribute defaults to false, so for conciseness, the above optional query parameter definitions leave out the required: false property. Path parameters must always be declared with required: true.
* A schema, which defines the type and format of the parameter. This is defined with a JSON schema; we'll discuss JSON schemas in depth later in this series.

Next up: We'll design the response models for the getChainLinks operation. This will involve a few design elements:

* Modeling the response that contains a page of chain link items
* Defining the getChainLinks operation responses
* Modeling the error response that the API returns when a client has an error such as invalid query parameters.
* Supporting pagination

<hr/>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
There are 2 hard problems in computer science: cache invalidation, naming things, and off-by-1 errors. — _Leon Bambrick_

Thanks for reading _API Design Matters_!

{% include discuss.md %}

{% include orig.md %}
