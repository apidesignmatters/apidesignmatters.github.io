---
title: Leave a Calling Card
date: 2024-09-19 18:00:00 -0000
layout: post
tags:
  - the-language-of-api-design
  - api-design-patterns
---

> Make API responses more self-descriptive with reference objects

Here's today's quick tip to make your API really stand out: make the response payloads as cryptic as possible.

I'm kidding, of course. I suppose if your message models are super
cryptic, your API will stand out&hellip; but for the wrong reason. Today, I'll
present a useful pattern for making API data less cryptic with the
equivalent of a "calling card" - API reference objects.

![alt text]({{ '/assets/img/Leave-a-Calling-Card.png' | relative_url}})

{% include language-of-api-design-series.md %}

Most api resources don't exist in isolation - instead, they have relationships with other resources. in the api design matters sample domain, chain links, i've shown how to use restful json to capture these relationships. a chain link has an author, and in the json model of a chain link, there is a property

```yaml
  "author_url": "https://api.chainlinks.example.com/authors/a733fhab"
```

which is the URL of the author resource. A chain link also resides in a universe that is conveyed with a property as well:

```yaml
"universe_url": "https://api.chainlinks.example.com/universes/ucc87e09"
```

If not using [Restful JSON](https://restfuljson.org/) or some other
hypermedia based format, these relationships may be modeled instead with
the lower level equivalent of foreign database keys, namely the resource
IDs of the related resources:

```yaml
"authorId": "a733fhab"
"universeId": "ucc87e09"
```

While these representations convey the necessary information, it's not
very satisfying for human consumption and results in a poor developer
experience.

I prefer JSON representations which are less cryptic and more
self-descriptive. This is where small reference objects can be useful.

My use of the term "reference object" is only slightly related to a $ref
reference object as used in [JSON Schema](https://json-schema.org)
and [OpenAPI Specification](https://spec.openapis.org/oas/v3.1.2.html) (OAS). In
OAS, a _Reference Object_ is a JSON object with a `$ref` keyword and a URI
of a referenced value defined elsewhere in the OAS API definition. (See
[Don't Repeat Yourself When Designing APIs]({{'/2023/04/09/dont-repeat-yourself-when-designing-apis'|relative_url}})
) For example, an API
operation's response object may define the response's schema with a
Reference Object to a schema component. The `getAuthor` operation's 200 OK
response is defined with a `$ref` to the author schema:

```yaml
      responses:
        '200':
          description: OK. The operation succeeded.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/author'
```

In OAS, a reference object contains a `$ref` value and may contain `summary` or `description` values. However, there is a kernel of usefulness here that can be used outside of defining an API with OpenAPI &mdash; we can use a construct inspired by OAS reference objects instead of terse and cryptic Restful JSON URLs or naked resource ID properties.

_An API reference object is a (JSON) object that references another
resource._

Such API reference objects (or more simply a _reference object_) in API responses (or requests) can include other key identifying data about the referenced resource; these are optional and informative. The id or url of the resource are required to actually identify the referenced resource. This makes the overall JSON payload more self-descriptive and does not send the developer down ratholes trying to understand data they see when exploring and learning the API.

Instead of seeing a terse/cryptic representation of a chain from the
Chain Links API:

```json
{
  "id": "36abf4ceb72389",
  "author_url":
     "https://api.chainlinks.example.com/authors/a733fhab",
  "universe_url":
     "https://api.chainlinks.example.com/universes/ucc87e09"
  ...
}
```

we can use reference objects (a different reference object schema for each resource) that includes the resource ID of that resource, its URL, and other identifying data:

```json
{
  "id": "36abf4ceb72389",
  "author": {
     "name": "D.T. Weintraub",
     "id": "a733fhab",
     "url":
        "https://api.chainlinks.example.com/authors/a733fhab"
  },
  "universe": {
     "name" : "Edgar Rice Burroughs' Mars",
     "id": "ucc87e09",
     "url":
        "https://api.chainlinks.example.com/universes/ucc87e09"
  }
  ...
}
```

While a bit more verbose, I find the extra data to be immensely useful
in understanding the overall data.

In my work with designing banking APIs, we use _account reference objects_ when one resource has a relationship to a banking account. For example, a transfer from a source account to a target account can be represented (albeit cryptically) as

```json
{
  "sourceAccountId" : "30623674-5a14-99eed7a86549",
  "targetAccountId": "4f3775d0-94e5-39cb8fb6924d",
  "amount" : "500.00"
}
```

By itself, this is not very informative because the opaque resource IDs do not add much usable stand-alone information to the reader; all we have is the means to find out more information about those accounts, but that is indirect and cumbersome.

A much more descriptive representation uses account reference objects
which tell more about the accounts:

```json
{
  "sourceAccount" : {
    "id": "30623674-5a14-99eed7a86549",
    "url" :
      "https://api.example.com/accounts/30623674-5a14-99eed7a86549",
    "type" : "checking",
    "maskedNumber" : "*7844"
  },
  "targetAccount" : {
    "id": "4f3775d0-94e5-39cb8fb6924d",
    "url" :
      "https://api.example.com/accounts/4f3775d0-94e5-39cb8fb6924d",
    "type" : "savings",
    "maskedNumber" : "*1363"
  },
  "amount" : "500.00"
}
```

## Resources can contain their own reference objects

To make these reference objects even more useful, the API service can
build them for you instead of making the client construct them. For
example, the response from the `getUniverse` operation can contain a
`reference` or `ref` property which is the reference object that the
client can embed in other requests when citing a universe. The `*Item`
schema in the API's list responses (see
[What Am I Getting Out of This?]({{'/2023/03/16/what-am-i-getting-out-of-this'|relative_url}}))
can also include the reference object instead of just the `id` of the
item in the colletion.
<hr>

## Avoiding Excessive Data Exposure

Reference objects should be small and only contain necessary data, not
many or most of the properties of the referenced resource. For example,
by no means is the universe property of a chain link defined by the full
universe schema. This limited, small reference object helps avoid
Excessive Data Exposure (OWASP API Security 2023
"[Broken Object Property Level Authorization](https://owasp.org/API-Security/editions/2023/en/0xa3-broken-object-property-level-authorization/)"
vulnerability. Using small reference objects helps keep payloads smaller
but still informative. Too many properties will just add noise,
defeating the Developer Experience benefits of using reference objects.
Choose key attributes of the resource to include in the reference
object, such as the name or type of the resource. Avoid sensitive data,
such as full account numbers, sensitive Personally Identifiable
Information (PII), etc. (Note: the author name shown in examples above
is not PII, but is the author's public pen name.)

<hr>
I hope you see value in using reference objects over more cryptic and
opaque identifiers or URLs. Why not try them out in your next API
design? Please leave comments to share your experience.

<hr>

{% include discuss.md %}

{% include orig.md %}
