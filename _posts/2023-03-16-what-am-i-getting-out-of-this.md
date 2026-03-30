---
title: What Am I Getting Out of This?
date: 2023-03-16-am-i-getting-out-of-this
layout: post
tag: the-language-of-api-deign
---

In the [last article of The Language of API Design series]({{ '/2023/03/07/chain-links-domain-model' | relative_url}}),
you saw how to express a few HTTP API operations to list resources in the Chain Links
domain model, focusing on the design for calling the getChainLinks
operation. (If you are just jumping into API Design Matters, I recommend
going back and skimming the previous articles in the The Language of API
Design series to get caught up.)

{% include language-of-api-design-series.md %}

## Modeling API responses with OpenAPI

Now you know how to express a GET operation to list chain links and
filter the list by some useful attributes of the items in it. But if
your relationship with your API is one-sided-all talk and no
listening-it won't be very satisfying. You need to get something out of
the relationship!

In this article, we'll explore how you get something out of the API: how to design API responses to fit your consumer's needs. We'll continue with the getChainLinks operation. Our tasks for today:

* Modeling the response representation that contains a page of chain link items
* Defining the `getChainLinks` operation responses

These techniques can be applied to the other resources in the API in a straightforward manner... there's that "API design pattern" concept again!

![meme of Buzz Lightyear explaining "API Design Patterns. API Design Patterns Everywhere"]({{ '/assets/img/api-patterns-everywhere.jpg' | relative_url}})

## Modeling the response that contains a page of chain link items

First, let's work out the design for the API response. It should be a page of chain link items-this implies an array type.

For our first approximation, we want the JSON response to look like the following:

```json
[
    {
      "id": "cl-489fjkd-49d9d",
      "type": "text",
      "authorId": "au-4639fjk3-fjkf",
      "createdAt": "2023-03-08T20:22:50.000Z"
    },
    {
      "id": "cl-f89jf-3jkdkh",
      "type": "text",
      "authorId": "au-4639fjk3-fjkf",
      "createdAt": "2023-03-08T21:44:05.000Z"
    },
    {
      "id": "cl-d9h4d83-dh49dhe",
      "type": "image",
      "authorId": "au-4639fjk3-fjkf",
      "createdAt": "2023-03-08T22:58:37.000Z"
    },
    {
      "id": "cl-478d9d-4hjdhj93",
      "type": "text",
      "authorId": "au-4639fjk3-fjkf",
      "createdAt": "2023-03-08T23:52:19.000Z"
    }
]
```

Each item is a brief summary of a chain link. In API speak, each item is just one _representation_ of a chain link. It includes some but not all of the properties of a chain link, as listed in the domain model:

* The `id` to identify this chain link. This is needed so the client can fetch the full representation of a chain link with GET /chainLinks/{chainId}
* The `type` of chain link (text, image, etc.)
* The ID of the author
* Timestamp when the chain link was created/authored.
  * _Note:_ I follow a style convention for date and time property names in APIs. I use names such as `"createdAt"`, with an `"At"` suffix, to denote `date-time` or instant values, and names such as `"joinedOn"` with an `"On"` suffix for `date` properties without a time component.

We need only include the properties necessary for the consumer to view or list the chain links, not all the fields in the full representation of a chain link. (Thought experiment: What obvious property is missing from this list, which would make a list of chain links better?)

This use of a concise summary representation of a chain link highlights an important point of API design: there can be multiple _representations_ of the same resource. Each representation serves a specific purpose. A different representation of a chain link may include other details not present in the list item representation, including references to chains which include that chain link, or universes or characters mentioned in that chain link, or many other properties. In our case, these are all JSON representations. There can also be non-JSON representations, such as the rendered version of the chain link when a user reads the assembled chain, or a thumbnail image of a large image chain link.

> In an API, there can be multiple representations of the same resource.

The above array representation looks fairly straight forward. However, I
avoid returning arrays as top-level API responses because arrays do not
allow for API evolution. We all know that APIs change over time, and
using an object schema allows an API to evolve more naturally: you can
add new properties to an object in future releases of the API when new
requirements emerge. You cannot add new properties to an array. You will
see the greater flexibility of using an object when we add support for
paginated responses, and later in API Design Matters when we take a deep
dive into HATEOS.<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>

So instead of an array, we will return an object that contains the array. When I design such collection responses, I uniformly name the array field `"items"` rather than name the array of chain links `"chainLinks"` or name the array of authors `"authors"` in the `getAuthors` response, etc. This is a style preference, which I do for consistency and predictability across APIs. For example, this naming allows API clients to treat all collections uniformly via `jsonResponse.items` accessors. The client code to check if the collection is empty can use `jsonResponse.items.length == 0` instead of different code for each collection. Pro Tip: Use whatever convention you like, but make it a pattern and apply it consistently across your APIs. API Design Patterns Everywhere...

## Defining the `getChainLinks` operation responses

Now that we know what we want our JSON response to look like, OpenAPI
requires us to define the data type and shape of data with a JSON Schema
and connect it to the getChainLinks operation. This includes the request
and response bodies, and as we saw in the previous article, the type and
shape of query and path parameters, and even request and response
headers.

First, let's walk through the JSON Schema modeling. JSON Schema is a
complex topic&em;a rich field for future API Design Matters articles,
certainly&em;so we'll come back to it frequently.

We want a schema with an items property, and each item is an object that contains the id, type, authorId, and createdAt properties. Here is a complete JSON Schema to describe the response from getChainLinks:

```yaml
title: Chain Links
description: A page of chain link items from a
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
      description: A concise representation of a chain link item
        in a list of chain links.
      type: object
      properties:
        id:
          description: This chain links unique resource identifier.
          type: string
          minLength: 4
          maxLength: 48
          pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
        type:
          description: Describes what type of chain link this is.
          type: string
        authorId:
          description: The ID of the author who created this chain link.
          type: string
          minLength: 4
          maxLength: 48
          pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
        createdAt:
          description: The RFC 3339 `date-time`
            when this chain link was created.
          type: string
          format: date-time
example:
  items:
    - id: cl-489fjkd-49d9d
      type: text
      authorId: au-4639fjk3-fjkf
      createdAt: 2023-03-08T20:22:50Z
    - id: cl-f89jf-3jkdkh
      type: text
      authorId: au-4639fjk3-fjkf
      createdAt: 2023-03-08T21:44:05Z
    - id: cl-d9h4d83-dh49dhe
      type: image
      authorId: au-4639fjk3-fjkf
      createdAt: 2023-03-08T22:58:37Z
    - id: cl-478d9d-4hjdhj93
      type: text
      authorId: au-4639fjk3-fjkf
      createdAt: 2023-03-08T23:52:19Z
```

I won't explain everything here-it should be somewhat self-explanatory, thanks to the great descriptive nature of JSON Schema. Just note that the first use of items is to define the items property of the response object; the second use is to define the schema of items in the array.

A more detailed treatment of the many subtleties of JSON Schema merits a few dedicated articles in API Design Matters, but there are a few things to point out quickly:

* Each property definition in a properties object is itself a JSON schema.
* I always explicitly define the type of every schema. Although some JSON schema constraints may lead you to assume a type (a properties object implies type: object; the minItems, maxItems, or items constraints imply type: array), this does not in fact define or specify a strict type. These constructs merely specify validation criteria. That is, if a JSON value is an array, the items constraint in the JSON schema applies to the array items. However, if non-array JSON value (such as a boolean true or a string `"API Design Matters"`) is still valid against a JSON schema that defines items but does not explicitly specify type: array. Similarly, if the schema has properties but does not declare type: object, those same values will also be valid against that schema.
* JSON Schema is really a language for validating whether JSON data conforms to a schema. It's use as a modeling language to define data models is secondary, so some interpretation of JSON Schema constructs is required. More on this later.

Next, let's define the 200 OK response for the `getChainLinks`
operation. Each operation's responses are defined, as you might expect,
in a
[responses object](https://spec.openapis.org/oas/latest.html#responses-object)
within the operation object. The responses object is a map whose keys are the HTTP response codes (or patterns that cover a range of response codes such as 5XX), and a response object description of the API response that correspond to that response code. This is further broken down into the definition of any response headers that may accompany the result and a content object whose keys are media types, such as `application/json` or `text/plain` or `image/png` etc. and the definition of the response body for that media type.

```yaml
operation object:
  responses object:
    '200':
       content:
         media-type:
           schema:
             # a JSON schema defining the representation
             # corresponding to the media-type
       headers:
         Header-Name:
           description:
           schema:
             # a JSON schema defining the response header
```

(We don't have any response headers yet, so we'll defer that discussion until later.)

Tying this all together, we merge the layout of the responses object and the 200 response with the schema definition for the JSON representation of the list of chain link objects, and we have the following:

```yaml
paths:
  /chainLinks:
    get:
      operationId: listChainLinks
      summary: List the chain links
      description: Return a paginated list of the
        chain links in the system.
      tags: [ 'Chain Links' ]
      responses:
        '200':
          description: OK. The operation succeeded.
          content:
            application/json:
              schema:
                title: Chain Links
                description: A page of chain link items from a
                  collection of chain links.
                type: object
                properties:
                  items:
                    title: Chain Link Items
                    description: A list of chain links in this page
                    type: array
                    maxItems: 10000
                    items:
                      title: Chain Link Item
                      description: A concise representation of
                        a chain link item in a list of chain links.
                      type: object
                      properties:
                        id:
                          description: This chain link's
                            unique resource identifier.
                          type: string
                          minLength: 4
                          maxLength: 48
                          pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
                        type:
                          description:
                            Describes what type of chain link this is.
                          type: string
                        authorId:
                          description: The ID of the author who
                            created this chain link.
                          type: string
                          minLength: 4
                          maxLength: 48
                          pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
                        createdAt:
                          description: The [https://www.rfc-editor.org/rfc/rfc3339#section-5](date-time)
                            when this chain link was created.
                          type: string
                          format: date-time
```

([Download this excerpt as an OpenAPI file](https://gist.github.com/DavidBiesack/1d0f20f40c5cc3ec7682b00917e7085d))

From this example, it is quite easy to apply this to the other list operations in the API... but there is a better way, so hold off going full bore just yet. In an upcoming article in _The Language of API Design_ series, you will see how to _Keep your OpenAPI DRY_ through the use of reusable OpenAPI schema and other OpenAPI components.

Next up:

* Modeling the error responses that the API returns when a client request has an error such as invalid query parameters.
* Supporting pagination

<a id='footnote-1'><a href='#footnote-1-ref'><sup>1</sup></a> HATEOAS -
<strong>H</strong>ypermedia <strong>A</strong>s <strong>T</strong>he <strong>E</strong>ngine <strong>O</strong>f <strong>A</strong>pplication
<strong>S</strong>tate, a principle of REST APIs and a really difficult initialism.
My colleague Michael Johnson taught me to pronounce this acronym as
“Hypermedia”... It is a broad and important topic (the concept, not the
pronunciation) which I don’t have room to discuss here.

{% include discuss.md %}

{% include orig.md %}
