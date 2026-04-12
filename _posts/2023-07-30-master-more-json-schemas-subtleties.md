---
title: Master More JSON Schema's Subtleties
date: 2023-07-30 18:00:00 -0000
layout: post
tags:
  - the-language-of-api-design
  - json-schema
---

> Don't be Surprised by JSON Schema's Surprising Surprises (Part II)

Today, I present Part II of _Master JSON Schema's Subtleties_,
imaginatively titled _Master More JSON Schema's Subtleties_.

![alt text]({{ '/assets/img/master-more-json-schemas-subtleties.png' | relative_url}})

{% include language-of-api-design-series.md %}

In the [last article]({{'2023/07/11/master-json-schemas-subtleties' | relative_url}}), I explained how the `unevaluatedProperties` keyword can be used with composing JSON schemas with allOf, to prevent clients from sending unexpected data in an object: only the properties defined in each of the subschemas within the allOf array are allowed.

This is great, but it does not go far enough. For, although schemas themselves are recursive structures, that behavior of a schema's keywords are not: unevaluatedProperties is not recursive&mdash;it does not apply to nested schemas/objects. What we really want is something akin to Jean-Luc Picard speaking of the Borg: "The line must be drawn here. This far. No further."

<iframe width="560" height="315" src="https://www.youtube.com/embed/Ms_WY0s_1XM?si=KM08YIYFgumNaBvj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Let's put this in the context of our Chain Links social media app, which
consists of chains, chain links, authors, universes, characters, etc. A
simplified resource model for a character object may include two
sub-object properties: the character's mother and father. (Ignore for
the moment the fantasy universes with asexual reproduction, cloning,
etc.).  The Picard character may be represented as

```yaml
name: Jean-Luc Picard
species: human
mother:
  id: ch-fjk4i9f3jk4-4hkd
  name: Yvette Picard
father:
  id: ch-489jkexbcsl-348dk
  name: Maurice Picard
```

We can define a schema named `character` for this object, then define a
schema named `characterReference` for the mother and father properties.
(Again, we only show skeletal schemas here to reveal the structure.)

```yaml
components:
  schemas:
    character:
      type: object
      unevaluatedProperties: false
      required:
        - name
        - species
      properties:
        name:
          type: string
        species:
          type: string
        mother:
          $ref: '#/components/schemas/characterReference'
        father:
          $ref: '#/components/schemas/characterReference'
    characterReference:
      type: object
      required:
        - id
        - name
      properties:
        id:
          type: string
        name:
          type: string
```

Adding the `unevaluatedProperties: false` assertion to the `character`
schema would disallow any properties other than `name`, `species`,
`mother`, and `father`. Thus, the following request body would be
rejected because the `id` property is not allowed:

```yaml
name: Jean-Luc Picard
id: ch-2305ncc-1701-d
species: human
mother:
  id: ch-fjk4i9f3jk4-4hkd
  name: Yvette Picard
father:
  id: ch-489jkexbcsl-348dk
  name: Maurice Picard
```

However, the above schemas _would_ allow additional properties in the
nested `mother` and `father` objects, even though they satisfy the
`characterReference` schema:

```yaml
name: Jean-Luc Picard
species: human
mother:
  id: ch-fjk4i9f3jk4-4hkd
  name: Yvette Picard
  species: human
father:
  id: ch-489jkexbcsl-348dk
  name: Maurice Picard
  species: human
```

This is because the `unevaluatedProperties: false` assertion in the
`character` schema does _not_ extend to schemas of its child properties.
Instead, we must explicitly declare this in the schema for those
properties:

```yaml
 characterReference:
      type: object
      unevaluatedProperties: false
      required:
        - id
        - name
      properties:
         ...
```

## unevaluatedProperties || ^unevaluatedProperties

Let's move on to a bit more of the rationale for using
`additionalProperties: false` or `unevaluatedProperties: false` in the first
place. As noted above, this prevents an API consumer from sending in
unexpected data. There are several reasons an API may want to enforce
this, and two of them are related to designing robust and secure APIs:

1. Disallowing additional properties can prevent malicious clients from
   flooding your APIs with tons of data (a form of a Denial of Service
   attack). By employing API edge security (such as a highly scalable
   API Gateway) that performs JSON schema validation at the edge, your
   services can detect and reject such malicious use before the request
   makes its way to the more important API business logic tear.
1. More importantly, such safety measures prevent Broken Object Property
   Level Authorization (formerly known as Mass Assignment), a well known
   API vulnerability. This vulnerability is #3 on the OWASP API Security
   Top Ten list (2023), described in API3:
   [2023 Broken Object Property Level Authorization](https://owasp.org/API-Security/editions/2023/en/0xa3-broken-object-property-level-authorization/).
   If unprotected, this vulnerability allows a malicious actor to alter
   data that it should not be allowed to change, or to cause other
   effects if, for example, the resource server blindly writes all the
   properties it receives in a request to the persistent store. See
   [this scenario](https://owasp.org/API-Security/editions/2023/en/0xa3-broken-object-property-level-authorization/#scenario-2)
   for an example.
1. These constraints also improve the developer experience (DX) for
   those coding to your APIs. These keywords help detect "syntax" errors
   and coding mistakes when developers misspell your properties.
   (Interactive Development Environments can support code completion
   and highlight fields not defined in source languages classes
   and interfaces in native language Software Development Kits.)

Thus, adding `unevaluatedProperties: false` assertions to your API's
schemas can enhance your API's security and DX. Score another point for
JSON Schema!

However, there is a key tradeoff between security and the API's evolution
and forwards/backwards compatibility.

Consider a client that uses the above `character` and `characterReference`
schemas, which were part of version 1.5.0 of the Chain Link API.
Later, the
`species` property was added in version 1.5.0. Client SDKs may perform
client-side schema validation when constructing API requests. If that
client happened to send such a request to a server that was running
version 1.4.0 of the API, the request would be rejected. This scenario
is rare but quite possible if an API definition has multiple
implementations, such as an open banking API that multiple financial
institutions implement independently. Some implementations may support
version 1.4.0 and others may have adopted version 1.5.0. This situation
is hard for clients to manage with one code base.

A complementary backwards compatibility issue arises if an API uses
`unevaluatedProperties: false` assertions in response schemas as well as
for request schemas. If the client is built against the schemas for
version 1.4.0, but version 1.5.0 added the new `species` property, the
client that validates responses against a schema will fail when it
receives a `character` object from the 1.5.0 server. Thus, when a
response schema has the `unevaluatedProperties: false` assertion, simply
adding a new property to an object schema constitutes a __breaking
change__ in clients. This means the API version (if it follows Semantic
Versioning) should have been bumped from 1.4.0 to 2.0.0 instead of to
1.5.0.

## Why you should avoid format: uuid

The OWASP API Top Ten number 1 vulnerability is
[API1:2023 Broken Object Level Authorization](https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/):
if the resource ID used in the resources' URL path uses database
sequential integers as the primary key, a hacker can use a valid integer
resource ID (such as .../path/to/resources/11478) and
increment/decrement that integer to probe for other resources and
possibly gain access to other user's data that they should not see. For
better security, all API resource IDs should be _opaque strings_ which
cannot be decoded to yield (sequential) integers. Often, back end
services use
[Universally Unique IDs](https://en.wikipedia.org/wiki/Universally_unique_identifier)
(UUIDs, also call Globally Unique IDs or GUIDs) or some other string
form that includes a significant number of random bytes. That's a useful
implementation practice but rarely belongs in an interface contract.

JSON Schema defines a `format: uuid` constraint for `string` properties;
this looks like a useful approach to close this vulnerability. However,
while it is useful to use a UUID or GUID for a resource ID or path parameter,
declaring the `uuid` format has two negative implications:

1. It exposes implementation details of your service, whereas an API should be about the _interface_.
2. It overly constrains the API implementation. If the property or path
parameter is defined with a `format: uuid` constraint, then it must _always_
be a UUID. You cannot later optimize the API with a shorter encoding of
the same data ([reducing a 36 byte UUID to a shorter Base64 byte string
encoding](https://github.com/salieri/uuid-encoder)) or enhance the ID with a resource type identifier prefix, as
suggested in
[Designing APIs for humans: Object IDs](https://dev.to/stripe/designing-apis-for-humans-object-ids-3o5a)).
<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>

Instead of using `format: uuid`, use just `type: string`, augmented with a
reasonable `maxLength` (such as 48, which gives a little wriggle room) and
a `pattern` that constrains the set of allowed characters in an ID. That
is useful for specifying alphanumeric characters and a few special
characters like `_` and `-`, but disallowing characters that require URL
encoding when used in a URL element:

```yaml
components:
  schemas:
    resourceId:
       title: Resource Identifier
       description: >-
         An immutable opaque string that uniquely identifies a resource.
       type: string
       minLength: 6
       maxLength: 48
       pattern: ^[-_.~a-zA-Z0-9]{6,48}$
       examples:
         - ch-2305ncc-1701-d
```

(A useful tip is add a marker or type prefix to identifiers when a new
resource
is added by the API service implementation. Here, character resources
may have a `ch-` previx; chain links may have a `cl-` prefix,
universes may have a `uni-` prefix.) This helps with visual inspection
of `id` properties in JSON data.

## "null" is a type

Some APIs support JSON Merge Patch
[[RFC7386](https://datatracker.ietf.org/doc/html/rfc7386)] semantics for
updating resources. With JSON Merge Patch,

> Null values in the merge patch are given special meaning to indicate
> the removal of existing values in the target.

Thus, a client can send a `null` value to _remove_ a property from a
resource<a id='footnote-2-ref'/><a href='#footnote-2'><sup>2</sup></a>
. To indicate that Jean-Luc Picard's species is unknown (or
unset) rather than "human" (and raise the ire of Star Trek fans
worldwide), one could `PATCH` the resource with the request

```json
{ "species": null }
```

However, this request is _not_ allowed if the `type` of the `species`
property is `type: string`;
the JSON value `null` is not a valid `string` value.

OpenAPI Specification 3.0 and previous versions of OAS used an extension
earlier JSON schema drafts, and employed the `nullable` keyword to
indicate a property supported a `null` value in addition to the other
values allowed for that schema.

```yaml
properties:
  species:
    type: string
    nullable: true
```

OpenAPI 3.1 uses JSON Schema 2020-12 which does not use the OAS-specific `nullable`
keyword to augment other type constraints. Instead, the string `"null"`<a id='footnote-3-ref'/><a href='#footnote-3'><sup>3</sup></a>
 is
the name of a special schema `type` constraint that allows the JSON value
`null` and nothing else. How does this help us?

```yaml
properties:
  species:
    type: "null"
```

Of course, we cannot simply change the `type` of the `species` property to `"null"`. Such a schema allows the above request but fails validation when a JSON string value such as `"human"` is sent.

![Obligatory Picard Face Palm meme: type: "null" allows only null]({{
 '/assets/img/allows-only-null-Picard-face-palm.png' | relative_url}})

Instead, we can employ the `oneOf`
[construct of JSON schema](https://json-schema.org/understanding-json-schema/reference/combining.html?highlight=oneof#oneof)&mdash;a
value is valid if it matches _exactly one_ of the alternate schemas in
an array of schemas:

```yaml
properties:
  species:
    oneOf:
      - type: string
      - type: 'null'
```

Fortunately, JSON Schema provides a more concise way to represent this
scenario. A schema's type may be an _array_:

```yaml
properties:
  species:
    type: [ string, 'null' ]
```

This schema will accept both PATCH requests for our friend, Jean-Luc:

```json
{ "species": null }
```

and

```json
{ "species": "human" }
```

Good, we've restored sanity to the universe!

## Always define a type constraint, except when you shouldn't

Let's tie up some of this knowledge of JSON schemas to see how API
data may be modeled. As mentioned in my previous article (see
[Defining properties does not imply type: object]({{'/2023/07/11/master-json-schemas-subtleties#defining-properties-does-not-imply-type-object' | relative_url}})), one should always add a `type` constraint when defining JSON schemas, because without it, the schema will allow values of other types.

Let’s consider composing schemas using mixin schemas, such as a
`mutableCharacterFields` schema that is mixed into our `character` and
`characterReference` schemas introduced above.

```yaml
components:
  schemas:
    mutableCharacterFields:
      description: >-
        A mixin schema to define mutable properties
        of other Character instances.
      type: object
      properties:
        name:
          type: string
          description: The full name of this character
          minLength: 1
          maxLength: 64
          pattern: '^[\p{L}\p{N}\p{M}\p{Zs}\p{P}]{1,64}$'
        // other mutable properties here...

    characterReference:
      description: >-
        A reference to another existing character
      type: object
      unevaluatedProperties: false
      required:
        - id
        - name
      allOf:
         - $ref: '#/components/schemas/mutableCharacterFields'
         - properties:
             id:
               $ref: '#/components/schemas/resourceId'

    character:
      description: >-
        A character in a chain link universe that
        appears in chains and chain links.
      type: object
      unevaluatedProperties: false
      required:
        - id
        - name
        - species
      allOf:
         - $ref: '#/components/schemas/mutableCharacterFields'
         - properties:
             id:
               $ref: '#/components/schemas/resourceId'
             species:
                type: string
                // other constraints
             mother:
               description: >-
                 The character's biological mother.
               $ref: '#/components/schemas/characterReference'
             father: >-
               description: >-
                 The character's biological father.
               $ref: '#/components/schemas/characterReference'
```

Such mixins help your API design follow the
[DRY principle]({{'/2023/04/09/dont-repeat-yourself-when-designing-apis'
| relative_url}}) by eliminating copy/paste of non-trivial schema
constraints, such as those on a character’s name.<a id='footnote-4-ref'/><a href='#footnote-4'><sup>4</sup></a>

This schema composition works well to define the schemas... until we want to support JSON Merge Patch to `PATCH` a character. As defined, we can patch a character’s `mother` or `father`, but we can’t unset those properties by sending a `null`:

```json
{ "mother": null, "father": null }
```

Changing the type of the characterReference schema from

```yaml
type: object
```

to

```yaml
type: [ object, 'null' ]
```

does not work because the semantics of `allOf` means that each schema must match the value. Unfortunately, while this type constraint on `characterReference` allows the `null` value, the effective type constraints from the schema composition are

```yaml
allOf:
  - type: object
  - type: [ object, 'null' ]
```

A character reference object must satisfy both type constraints, but a `null` value only satisfies the second.

Thus, it may be useful to omit the `type: object` constraint on mixin
schemas such as in `mutableCharacterFields`, provided that that the concrete
non-mixin schemas that are composed via the mixins can define the
correct `type` constraint.
That is, any schema used to define a request or response body or a
property of such objects, should have a narrow `type` constraint.

Another solution is to use the `oneOf` constraint on the properties instead of using the `array` type within the `characterReference` schema:

```yaml
    character:
      ...
      allOf:
         - $ref: '#/components/schemas/characterReference'
         - properties:
           ...
             mother:
               description: The character's biological mother.
               oneOf:
                 - $ref: '#/components/schemas/characterReference'
                 - type: 'null'
             father:
               description: The character's biological father.
               oneOf:
                 - $ref: '#/components/schemas/characterReference'
                 - type: 'null'
```

Alas, many OpenAPI SDK generation tools not not handle the `oneOf`
keyword well.

I prefer the first solution, as it requires only one source code change,
not extra code each time such a schema is used.

## Summary

This concludes API Design Matters articles on the subtleties of JSON
Schema. There are more subtleties to be covered, but we’ll deal with them later as
they arise in practical use.

{% include json-schema.md %}

{% include discuss.md %}

{% include orig.md %}

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
The examples I gave above use a `ch-` prefix for resource IDs for character resources.

<a id='footnote-2'/><a href='#footnote-2-ref'><sup>2</sup></a>
This is only valid for object properties which are not required.

<a id='footnote-3'/><a href='#footnote-3-ref'><sup>3</sup></a>
Note: The `type` value uses the `string` value `"null"` for the type name, not the
JSON `null` value. This is an important distinction! You’ll get a schema
error if you use `type: null`&mdash;`null` is not a valid type _name_.)

<a id='footnote-4'/><a href='#footnote-4-ref'><sup>4</sup></a>
The regular expression pattern `^[\p{L}\[{N}\p{M}\p{Zs}\p{P}]{1,64}$`
allows Unicode letters, numeric digits, accent marks, a space, and
punctuation, but not control characters, line separators, paragraph
separators, etc.
