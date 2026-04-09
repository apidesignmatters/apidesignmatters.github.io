---
title: Composing API Models with JSON Schema
date: 2023-06-05 18:00:00 -0000
layout: post
tags:
  - the-language-of-api-design
  - json-schema
---

> Use JSON Schema effectively to build real API request and response bodies

In today's post, I expand upon API request and response data modeling
with JSON Schema. We saw last time how constructing a deeply nested
schema does not result in a good developer experience when generating a
Software Development Kit (SDK) for our Chain Links API. We'll learn how
restructuring the models improves the generated SDKs and also allows us
to
[keep our API definitions DRY]({{'/2023/04/09/dont-repeat-yourself-when-designing-apis'
| relative_url}}).

![banner with graphic text "Composing-API-Models-with-JSON-Schema &vert; The Language of API Design &vert; David Biesack"alt text]({{
 '/assets/img/Composing-API-Models-with-JSON-Schema.png' | relative_url}})

{% include language-of-api-design-series.md %}

Previously, I showed the nested JSON schema for the listChainLinks operation response. That value is a JSON object with a property named items which is an array of objects describing chain link objects. Here is the structural outline of the chainLinks schema:

```yaml
components:
  type: object
  properties:
    items:
      type: array
      items:
        type: object
        properties:
          id:
            type: string
          type:
            type: string
          authorId:
            type: string
          createdAt:
            type: string
```

However, when we generated an SDK, the Typescript type for the
`chainLinks` schema wass a huge disappointment.

There is another way to express this, and it also provides additional
benefits to the API definition: _composition and reuse_, as I'll explain
below.

The first step is to refactor the schema by lifting the anonymous (that is, unnamed) schema for the array items and giving it a name. I'll name it `chainLinkItem`. This is a standard pattern I used for schemas which define the items in a containing array of API resources. Here is the skeleton to see the structure:

```yaml
components:
  schemas:
    chainLinks:
      type: object
      properties:
        items:
          type: array
          items:
            $ref: '#/components/schemas/chainLinkItem'
    chainLinkItem:
      type: object
      properties:
        id:
          type: string
        type:
          type: string
        authorId:
          type: string
        createdAt:
          type: string
```

The above omits the useful description and other schema details, so you
can see the structure more clearly. A more complete version of the
`chainLinks` and `chainLinkItem` schema is at
[this gist](https://gist.githubusercontent.com/DavidBiesack/5a4f10faa993db999b8ab2ce41f96a79/raw/070dd76230eaba33be8d2e610f351520c28518e0/chainLinks-and-chainLinkItem-schemas.yaml).

If we try code generation on the updated OpenAPI document:

```yaml
$ swagger-codegen generate \
   -l typescript-axios \
   -o typescript-axios \
   -i openapi.yaml
```

we see the `ChainLinkItem` interface defined in the generated source
`typescript-axios/models/chain-link-item.ts`:

```typescript
export interface ChainLinkItem {
    /**
     * This chain link's unique resource identifier.
     * @type {string}
     * @memberof ChainLinkItem
     */
    id: string;
    /**
     * Describes what type of chain link this is.
     * @type {string}
     * @memberof ChainLinkItem
     */
    type: string;
    /**
     * The ID of the author who created this chain link.
     * @type {string}
     * @memberof ChainLinkItem
     */
    authorId: string;
    /**
     * The [https://www.rfc-editor.org/rfc/rfc3339#section-5](date-time)
     * when this chain link was created.
     * @type {Date}
     * @memberof ChainLinkItem
     */
    createdAt: Date;
}
```

and the revised `chainLinks` schema is converted to this
`models/chain-links.ts`:

```typescript
import { ChainLinkItem } from './chain-link-item';

export interface ChainLinks {
    /**
     * A list of chain links in this page
     * @type {Array<ChainLinkItem>}
     * @memberof ChainLinks
     */
    items: Array<ChainLinkItem>;
}
```

Success! We've solved the problem from
[our last attempt]({{'/2023/05/18/learning-the-language-of-api-data' | relative_url}})
which only gave us the nearly useless construct:

```typescript
export interface ChainLinks {
    items: Array<any>;
}
```

We also see similar improvements in Java code generation. For example,
the `ChainLinks.java` has this code

```java
import io.chainlinks.models.ChainLinkItem;

public class ChainLinks {
  private List<ChainLinkItem> items = new ArrayList<ChainLinkItem>();
```

It's important to note how this transformation leads to a better developer experience: the properties of the target programming language class/interface/structure are strongly typed rather than untyped. This adds type safety (even in dynamic languages), allows IDE code completion, aids code readability, and allows static analysis tools, refactoring tooling, and so much more.

And that's just by using a JSON Schema language construct to define
useful types for fields...

## Composition

As promised above, we can do much more with schema composition and schema construction while applying the Don't Repeat Yourself principle.

For example, in APIs that support CRUDL (Create, Read, Update, Delete, List) operations, there is a great deal of similarity across the request and response bodies for the various POST/PUT/GET/PATCH API operations. Consider the Chain Link resource in the Chain Links API. Here's a recap of what is in a Chain Link, from Chain Links Domain Model:

* `author` - a list of chains in which this chain link is used
* `type` - plain text, rich text, image with optional caption, branch (to define alternate, non-sequential story lines)
* `content` - the actual block of (Markdown) text, or the image data.
* `createdAt` - creation timestamp

Different combinations of these values show up in different API model schemas.

1. A schema to define the items within the list of chain links returned from the listChainLinks operation-this is the chainLinkItem schema from above. The chainLinkItem schema has four properties:
   * `type`
   * `authorId`
   * `createdAt`
   * `id`<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
2. A schema to represent the full chain link resource from the getChainLink ( GET /chainLinks/{chainLinkId} ) operation-we'll name this schema chainLink. This has six properties, four of which should look very familiar:
   * `type`
   * `authorId`
   * `createdAt`
   * `id`
   * `content`
   * `chains_url`<a id='footnote-2-ref'/><a href='#footnote-12><sup>2</sup></a>

Importantly, notice that these schemas build upon each other. A
`chainLink` has all the properties from the `chainLinkItem` schema, plus
two additional properties. Here is a diagram which shows this structural
composition:

![`chainLinkItem` and `chainLink` composition]({{ '/assets/img/chainLinkItem-and-chainLink-composition.png | relative_url}})

(This is a simplification; below we'll describe a more flexible composition method.)

Luckily, JSON Schema has a direct language construct for this type of
structural composition.
The [`allOf` keyword of JSON Schema](https://json-schema.org/draft/2020-12/json-schema-core.html#section-10.2.1)
declares that a
schema is composed of _all of_ the elements one or more other subschemas. The value of `allOf`
is an array of schemas or references to the subschemas.

The formal definition of `allOf` is:

> This keyword's value MUST be a non-empty array. Each item of the array MUST be a valid JSON Schema.
>
> An instance validates successfully against this keyword if it
> validates successfully against all schemas defined by this keyword's
> value.

This reflects JSON Schema's origins for validating JSON, so it is not evident how this helps us build API data models. Patience, dear reader!

Let us define the chainLink object schema as a composition of two subschemas:

* The `chainLinkItem` schema
* An object schema with additional `properties`, `chains_url` and `content`

Here is a skeleton of the chainLinkItem and chainLink schemas. (Again,
I've omitted the important titles, descriptions etc. so that the
structure and schema composition is clearer.
See [this gist](https://gist.githubusercontent.com/DavidBiesack/2c69678b7d36c316f9763daaff4017df/raw/444f4abf7077d998e022f2443605e106d3662e5d/chainLink-and-chainLinkItem-schema-composition.yaml)
for a more complete definition.`<a id='footnote-3-ref'/><a
href='#footnote-3'><sup>3</sup></a>)

```yaml
components:
  schemas:
    chainLink:
      type: object
      allOf:
        - $ref: '#/components/schemas/chainLinkItem'
        - type: object
          properties:
            content:
              $ref: '#/components/schemas/chainLinkContent'
            chains_url:
              type: array
```

Within the `allOf` definition, the first array item is a _schema
reference_. This allows us to reuse existing schemas rather than
reverting to copy/paste, thus keeping our API definition DRY.

The `allOf` keyword means that _all of_ the subschemas apply when the
JSON Schema is used to validate a JSON document instance: the instance
is valid if and only if it validates against _all of_ the subschemas in
the array.

When used to define an API model, however, code generation tools
interpret the `allOf` construct as a model composition construct of the
target language. This interpretation (or translation) varies by target
language and by tool used to define the API model.

When we use `swagger-codegen` to build a client SDK using this schema
composition, we get a `ChainLinksItem.java` model definition that
contains the following (comments and annotations removed):

```java
public class ChainLinkItem {
  private String id = null;
  private String type = null;
  private String authorId = null;
  private OffsetDateTime createdAt = null;
  ...
}

We can see that the schema composition construct is interpreted by the
code generation tool with inheritance for the Java target language. For
Typescript, the story is different. We saw the interface ChainLinkItem
above.<a id='footnote-4-ref'/><a href='#footnote-4'><sup>4</sup></a>

Here is an excerpt from `chain-link.ts` (with comments and annotations
removed)

```java
import { ChainLinkItem } from './chain-link-item';
export interface ChainLink extends ChainLinkItem {
    chainsUrl: string;
}
```

Things get a bit trickier when the `allOf` array contains more than one
reference.
For example, Java does not support multiple class inheritance.
`swagger-codegen` employs a strategy of using class inheritance for the
first `$ref` schema, then it inlines the properties of other schemas.
For example, if we define the `chainLink` schema as follows, using a new
`chainLinkContentField` schema (because that schema will be useful when
defining other schemas):

```yaml
 chainLinkContentField:
      type: object
      properties:
        content:
          $ref: '#/components/schemas/chainLinkContent'

    chainLink:
      allOf:
        - $ref: '#/components/schemas/chainLinkItem'
        - $ref: '#/components/schemas/chainLinkContentField'
        - type: object
          properties:
            chains_url:
              description: >-
                A link to the API operation to return the paginated
                list of chains in which that this chain link is used.
              type: string
              format: uri
              maxLength: 256
```

then `swagger-codegen` defines the `ChainLink.java` class as follows:

```java
import apiDesignMatters.ChainLinkContent;
import apiDesignMatters.ChainLinkContentField;
import apiDesignMatters.ChainLinkItem;
public class ChainLink extends ChainLinkItem {
  private ChainLinkContent content = null;
  private String chainsUrl = null;
  ...
}
```

(The code imports but does not use or reference the `ChainLinkContentField` class.)

I recommend you try reordering the items in the allOf schema to see the
effect on the generated code.
([Here is a source OpenAPI document to work with](https://gist.githubusercontent.com/DavidBiesack/cdcb51e60268fe466f8845b09e07d6db/raw/5f1d0e64021ab2a62597e6507aeab4de24f2f9dc/chainLinkItem-schema-composition-with-contentField.yaml).)

Can you spot how such changes can introduce breaking changes in client code?

### Defining Elemental Schemas for Composition

This approach of defining tiny schemas, such as the `chainLinkContentField`, is a useful design pattern for keeping API definitions DRY. This is analogous to creating small, atomic, highly reusable functions in a programming language, rather than long, complex, single-purpose functions.

If you find yourself repeating a property definition across multiple schemas, consider lifting that property into its own field definition schema. If there are groups of related properties that you use together in multiple schemas, you can group them together into a reusable `{group`}Fields schema (with a descriptive schema name that indicates its purpose, such as `mutableChainLinkFields`), then mix them into other schemas using the `allOf` schema composition construct.

This practice is one form of
[refactoring](https://martinfowler.com/books/refactoring.html) that is
useful when defining and refining schemas.

## Composition is not Inheritance

Warning: this JSON Schema composition construct is not inheritance...
even if some tools translate this into inheritance in a target language.
This means that, as the `"allOf"` name implies, _all of_ the schema
constraints apply: you cannot override or replace constraints.

For example, note that the full schema definition for the `authorId`
property in `chainLinkItem` contains the following constraints:

```yaml
           authorId:
              description: >-
                The ID of the author resource:
                who created this chain link.
              type: string
              minLength: 4
              maxLength: 48
              pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
              readOnly: true

```

Suppose we want to use schema composition but loosen those constraints
in the `chainLink` schema's `authorId` to allow 2 to 64 characters, we can
express this as follows:

```yaml
 chainLink:
      title: A Chain Link
      allOf:
        - $ref: '#/components/schemas/chainLinkItem'
        - type: object
          properties:
            authorId:
              description: >-
                The ID of the author resource:
                who created this chain link.
              type: string
              minLength: 2
              maxLength: 64
              pattern: ^[-_a-zA-Z0-9:+$]{2,64}$
              readOnly: false
```

However, we won't get the desired effect. While the code generation may not change, the schema validation of a JSON object containing an `authorId` still enforces _all of_ the subschema constraints. Thus, the _effective_ schema constraints for the `authorId` property are the union of all the constraints:

1. `type: string`
1. `minLength: 4`
1. `maxLength: 48`
1. `pattern: ^[-_a-zA-Z0-9:+$]{4,48}$`
1. `type: string`
1. `minLength: 2`
1. `maxLength: 64`
1. `pattern: ^[-_a-zA-Z0-9:+$]{2,64}$`

While a value such as `"C289D6F7-6B30-4788-9C70-4274730FAFCA"` satisfies
all 8 of these constraints, a shorter author ID string of 3 characters,
`"A00"`, will fail the constraint \#2 and \#4, and thus that JSON would
be rejected.

As far as JSON validation is concerned, there is no conflict here, even
though the constraints look to be in conflict For example, both
constraints `minLength: 4` and `minLength: 2` apply to every instance;
they are independent of each other and one does not replace or override
the other, no matter where they are defined. Longer strings satisfy both
of these `minLength` constraints, but strings shorter than 4 (such as
`"A00"`) will not satisfy the `minLength: 4` constraint and
thus not satisfy the overall effective schema.

A final note on schema composition. The behavior of the allOf construct is well defined within JSON Schema for JSON validation. However, there is no standard for how this JSON schema construct must be treated in other tools such as code generation for client or server SDKs. Thus, each tool vendor (SmartBear’s swagger-codegen, the OSS openapi-generator, APIMatic, Speakeasy, Fern, Kiota, etc.) may interpret JSON Schema in individual and different ways. It is useful to try them out to see if their interpretation and implementation meets your needs and expectations.

JSON Schema provides other keywords for schema composition (the `oneOf`,
`anyOf`, and not keywords, as well as conditionals with a `if/then/else`
construct) but these are more advanced topics and I’ve already asked too
much of you to read this far. Stay tuned, however, there is more to
come!

{% include json-schema.md %}

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
The id property is the unique resource ID of a chain link instance, a concept I introduced in From Domain Model to OpenAPI. The id is used to reference the chain link instance for GET /chainLinks/{chainLinkId}, PATCH /chainLinks/{chainLinkId} and DELETE /chainLinks/{chainLinkId} operations

<a id='footnote-2'/><a href='#footnote-2-ref'><sup>2</sup></a>
This property contains an API URL to list all the chains that contain this chain link.

<a id='footnote-3'/><a href='#footnote-3-ref'><sup>3</sup></a>
The source files I provide as GitHub gists use openapi: 3.0.3 because, sadly, the swagger-codegen tool still does not support OpenAPI 3.1. C’mon SmartBear—OpenAPI 3.1 was released in 2021!

<a id='footnote-4'/><a href='#footnote-4-ref'><sup>4</sup></a>
Typescript interfaces may define properties; interfaces in Java cannot define properties/fields, only methods, hence the code generation differences.

{% include discuss.md %}

{% include orig.md %}
