---
title: Learning the Language of API Data
date: 2023-05-18 18:00:00 -0000
layout: post
tag: the-language-of-api-deign
---

> On the road to becoming fluent with JSON Schema

The OpenAPI Specification is a language for expressing the design of an
API. But contained within OpenAPI is another language: JSON Schema. Like
OpenAPI, JSON Schema is defined by a standards specification (published
at [json-schema.org](https://json-schema.org/specification.html)). You
saw the tip of the JSON Schema iceberg in
[What Am I Getting Out of This?]({{
'2023/03/16/what-am-i-getting-out-of-this' | relative_url}}), but that wee bit of knowledge will only get you so far. Diving into JSON Schema and gaining fluency will require several API Design Matters articles&mdash;there is much to learn!

{% include language-of-api-design-series.md %}

![banner with graphic text on colored backgrounds, reading "Learning the Language of API Data &vert; One the road to becoming fluent with JSON Schema &vert; API Design Matters & vert; The Language of API Design &vert; David Biesack" ]({{
 '/assets/img/Learning-the-Language-of-API-Data---wide-1.png' | relative_url}})

OpenAPI uses JSON Schema to define and describe<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
 all the data conveyed in an API operation:

* Request and response bodies
* Request and response header values
* Query parameter values

> JSON Schema is really a domain specific language,
> coded in JSON, for describing JSON data

When you include a JSON schema in an OpenAPI document for these purposes, you are doing two things:

* JSON Schemas informs your API consumer how to structure the JSON data
  they pass to the API and how the API's response data is
  structured&mdash;that is, the objects, arrays, and properties in the
  JSON document. This is using JSON Schema for modeling your APIs data.
  For example, many API providers also supply _Software Development
  Kits_ (SDKs) for their APIs, and those SDKs contain data types,
  interfaces, or classes in the target language that represent
  translations of the schemas into that language's programming
~  constructs.
* JSON Schemas define what is valid data for the API by defining
  constraints for the data such as regular expression patterns for
  strings, the minimum and maximum number of items in arrays, which properties of an object are required, etc. Many of these constraints do not have an equivalent representation in the data types, interfaces, or classes in the target language.

This duality was the topic of a talk I recorded for the 2020 API Specifications Conference,
[Wielding the Double-Edged Sword of JSON Schema](https://www.youtube.com/watch?v=6ukZEUBRpqo).

<iframe width="560" height="315" src="https://www.youtube.com/embed/6ukZEUBRpqo?si=L3_heVqnW6GscULF" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Keep in mind that JSON Schema was originally designed (independently of OpenAPI Specification) as a _JSON validation tool_&mdash;that is, for the second purpose above. As an API designer, knowing how to properly constrain your API's input can lead to increased security (as I'll discuss in a future post dedicated to that.) However, your first need is likely leaning heavily in the modeling aspect. To be effective with both, you need to know the lingo:

* How JSON Schema expresses JSON validation
* How some of those same constructs are interpreted in order to express data modeling.

Let's revisit some of the schemas we defined earlier&mdash;see [What Am I Getting Out of This?]({{
'2023/03/16/what-am-i-getting-out-of-this' | relative_url}}) for the JSON schema that describes the response from the `getChainLinks` operation. Here is that schema for reference. (I use YAML, but remember that this is just a more convenient and legible representation of a JSON value.)

```yaml
components:
  schemas:
    chainLinks:
      title: Chain Links
      description: >-
        A page of chain link items from a
        collection of chain links.
      type: object
      properties:
        items:
          title: Chain Link Items
          description: A list of chain links in this page.
          type: array
          maxItems: 10000
          items:
            title: Chain Link Item
            description: >-
              A concise representation of a chain link item
              in a list of chain links.
            type: object
            properties:
              id:
                description: >-
                  This chain links unique resource identifier.
                type: string
                minLength: 4
                maxLength: 48
                pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
              type:
                description: >-
                  Describes what type of chain link this is.
                type: string
              authorId:
                description: >-
                  The ID of the author who created this chain link.
                type: string
                minLength: 4
                maxLength: 48
                pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
              createdAt:
                description: >-
                  The RFC 3339 `date-time`
                  when this chain link was created.
                type: string
                format: date-time
```

Let's break this `chainLinks` schema down.

* This schema is an object.<a id='footnote-2-ref'/><a href='#footnote-2'><sup>2</sup></a>
          1. As a JSON object, the above `chainLinks` schema consists of a set of named values: `title`, `description`, `type`, `properties`. These names are called `keywords`. A keyword is part of the Ubiquitous Language of the JSON Schema domain, along with other terms described below. The core of JSON schema defines some keywords and what they mean

  1. Schemas are nested.

     * Each property _value_ within the `properties` object is another independent JSON schema that defines the value of the named property.

       1. In this case, there is one property called `items`; it is defined with `type: array` and another keyword, `items`, that defines yet another schema for all items in the array.<a id='footnote-3-ref'/><a href='#footnote-3'><sup>3</sup></a>

          * Similarly, the values of the `id`, `type`, `authorId`, and `createdAt` properties are JSON schemas that define those properties within an array item.

In total, there are seven schemas nested four deep in those few lines of JSON Schema code. That is some great expressiveness!

Here is the nested schema structure. This one JSON schema is really seven schemas in one&mdash;each colored box contains a schema.

![`chainLinks` Nested schema structure]( {{ '/assets/img/chainLinks-nested-schema-structure-1.png' | relative_url }})

## The Very Model of a Modern Major General Purpose API Client

The OpenAPI specification (and the JSON Schema specification) do not overstep their responsibility of describing the API and its data. Specifically, they do not specify how one maps those API definitions into API client applications or API implementations in web services. That is left as an implementation choice for the tool providers. As I noted above, one must interpret the JSON schema when creating code artifacts.

> One must interpret the JSON schema when creating code artifacts

To continue our discussion of using JSON Schema to model API data within an OpenAPI definition, let's show how some OpenAPI tools perform that translation from JSON Schema into code constructs, such as a client Software Development Kits or SDKs.

A widely used tool is [swagger-codegen](https://swagger.io/tools/swagger-codegen/) (Open-Source Software supported by SmartBear.) Other options include an OSS fork of this called [openapi-generator](https://openapi-generator.tech/), and some commercial tools like [APIMatic](https://www.apimatic.io/), [Speakeasy](https://speakeasyapi.dev/), [Fern](https://www.buildwithfern.com/) and [many more](https://openapi.tools/categories/sdk-generators). If we use our current `openapi.yaml` file, we can run

```bash
swagger-codegen generate -l typescript-angular -i openapi.yaml -o ts
```

This generates a number of files, including `ts/model/chainLinks.ts` which holds the TypeScript interface for the `chainLinks` schema returned from the `getChainLinks` operation.

This has the very unsatisfying result shown below.

```typescript
/**
 * A page of chain link items from a collection of chain links.
 */
export interface ChainLinks {
    /**
     * A list of chain links in this page
     */
    items?: Array<any>;
}
```

![yellow and black smiley wall art &vert; Photo by [Andre Hunter](https://unsplash.com/@dre0316) on [Unsplash](https://unsplash.com/)](https://images.unsplash.com/photo-1503525537183-c84679c9147f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzMDAzMzh8MHwxfHNlYXJjaHwyfHxzYWQlMjBlbW9qaXxlbnwwfHx8fDE2ODQ0NTkzMDl8MA&ixlib=rb-4.0.3&q=80&w=1080)

While this code defines a `ChainLinks` interface with an `items` property, it falls short of modeling the structure or interface of the _elements_ of that array. We get similar results when we try other languages, such as Java

```bash
swagger-codegen generate -l java -i openapi.yaml -o java
```

The resulting `ChainLinks.java` source file is equally dissatisfying, with the declaration of the items array as:

```java
private List<Object> items = null;
```

![a woman covering her eyes with her hands &vert Photo by [Jussara Paulo](https://unsplash.com/de/@jussarapaulo) on [Unsplash](https://unsplash.com/)](https://images.unsplash.com/photo-1646831055574-b945ace1b495?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzMDAzMzh8MHwxfHNlYXJjaHwyfHxmYWNlcGFsbXxlbnwwfHx8fDE2ODQ0MjI1NDR8MA&ixlib=rb-4.0.3&q=80&w=1080)

We'll show how to address that huge deficiency in code gen with some schema restructuring in a future post. (How is that for a cliffhanger?)

## The Ubiquitous Language of JSON Schema

As a language geek (after all, I am writing a series titled _The Language of APIs_), I will close by pointing JSON Schema's own terminology&mdash;the [Ubiquitous Language](https://apidesignmatters.github.io/2023/02/15/api-design-first-is-not-api-design-first.html#know-the-lingo) of JSON Schema. The [Conventions and Terminology](https://json-schema.org/draft/2020-12/json-schema-core.html#name-conventions-and-terminology) section of the specification defines some of the terms of JSON Schema (emphasis mine).

> JSON Schema uses __keywords__ to assert constraints on JSON instances or annotate those instances with additional information. Additional keywords are used to apply assertions and annotations to more complex JSON data structures, or based on some sort of condition.
> To facilitate re-use, keywords can be organized into __vocabularies__.
A vocabulary consists of a list of keywords, together with their syntax
and semantics.
> A __dialect__ is defined as a set of vocabularies and their required support identified in a meta-schema.

Pardon me for going a bit meta here, but I like that JSON Schema uses the language of languages (words, vocabularies, dialects, syntax, and semantics) to describe itself.

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
Define: specify the type and shape of data, and any constraints such as minimum and maximum numeric values, minimum and maximum numeric values. Describe: provide prose descriptions of the data as documentation.

<a id='footnote-2'/><a href='#footnote-2-ref'><sup>2</sup></a>
A schema may also be a boolean true or false. We'll discuss the use of those later.

<a id='footnote-2'/><a href='#footnote-3-ref'><sup>3</sup></a>
The apparent overloading of the identifier `items` here can be
confusing, but that's not intentional. Each serves a different
independent purpose which just happens to result in a lexically adjacent
coincidence. The JSON Schema keyword `items` is an appropriate name for
the schema that applies to the _items_ within an array. The property
name `items` in the chain link API arises from a choice to name arrays
within collections uniformly as that collection's _items_. Thus, the
word `"items"` has two natural uses in an API definition ... because
`"items"` is a very good choice for naming things within an array.
