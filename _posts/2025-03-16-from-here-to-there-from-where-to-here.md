---
title: From Here to There, from Where to Here
date: 2025-03-16 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> Patterns for Web API Query Parameters

There are many different patterns for using query parameters in web
APIs. Today's article in my API Design Patterns series in API Design
Matters is about query parameters in Web APIs. Let's explore some of
these patterns&hellip;

![alt text]({{ '/assets/img/From-Here-to-There,-from-Where-to-Here.png' | relative_url}})

{% include language-of-api-design-series.md %}

## It is what it is

In HTTP APIS, query parameters occur after the path and before optional anchor tags in a URL. The query parameters begin with the `?` special character, which is followed by a `&`-delimited list of _name=value_ pairs

It's quite natural to interpret this `=` character to mean equality, i.e
`?x=6` means "where x equals 6". However, I prefer to interpret this `=`
character as "is" , such as "where x is 6"

Thus, one can read or "interpret" a URL such as the following (ignore line breaks)

> `http://api.chainlinks.example.com/universes` <br>
> `?author=au345bd84` <br>
> `&genre=fantasy`

as

> universes where<br>
> the author _is_ (the author with id au345bd84)<br>
> and genre _is_ "fantasy"

I find this style slightly more [literate](http://www.literateprogramming.com/)
as well as more flexible than a rigid "equals" interpretation.

## Filtering List Operations

For consistency across APIs, I use query parameters to, as the name implies, parameterize the query. What does this mean? Most commonly, I use query parameters to serve as filters on List operations, as a means of subsetting the response list to a narrower set that satisfies the conditions defined in one or more query parameters.

In these cases, the interpretation of the query parameters is done with an implicit context of an element of the referenced collection.

In our [Chain Links API]({{'/2023/03/07/chain-links-domain-model'|relative_url}}), one such collection is the `chainLinks` resource.

A chain link has several properties:

* the author who created/write the chain link
* a set of characters who are mentioned in or are part of the chain link
* the universe in which the chain link occurs
* the date when the author create/wrote the chain link (`authoredOn`)

Thus, we can use these property names as query parameter names to subset
the list response to those chain link instances whose property values
match the query parameters.

The next design decision is what query parameter _values_ to use after the `=` sign. For `author` and `universe` query parameters, we want to allow the client to pass the author's resource ID (author names are not unique) or perhaps the author's URI. Similarly, it is most convenient for the client to pass the resource ID for for a universe resource.

As I wrote in
[From Domain Model to OpenAPI]({{'/2023/03/09/from-domain-model-to-OpenAPI'|relative_url}}),
one can parameterize the request to return a list of chain links:

    GET /chainLinks?character={someCharacterId}
    GET /chainLinks?universe={someUniverseId}
    GET /chainLinks?author={someAuthorId}
    GET /chainLinks?authoredOn=[2023-01-01,2023-03-31]

I hope the first three are intuitive. A common pattern is to filter
resources on a _range_ of values, such as a date range. In banking APIs
(such as filtering a list of transactions), it's common to filter based
on a range of values. I like using range notation as shows with the date
range above; this works for numeric values as well, such as `GET
/banking/accounts/{accountId}/transactions?amount=(0,100.00]` to match
transactions whose amount is greater than 0 and less than or equal to
100.00.

I've seen lots of other query designs for ranges, such as

    ?amount=gt:0&amount=le:100.00
    ?filter=and(gt(amount,0),le(amount:100.0)
    ?where=amount > 0 and amount <= 100
    ?$filter=amount gt 0 and amount le 100.00

The last one is based on OData. It and the ?where style before it are
more common in APIs which directly expose the underlying data schema.
However, this is more of an anti-pattern in modern web APIs, which are
more robust when they support (or even enforce) an abstraction layer
between the API consumer and the back-end system behind the API.
[Mike Amundsen](https://mamund.substack.com/) put this eloquently when
he wrote

> [Amundsen's Maxim](https://www.amundsens-maxim.com/)
> "Remember, when designing your Web API, your data model is not your
> object model is not your resource model is not your message
> model." &mdash; Mike Amundsen

(Mike shared this in 2016 on a social media microblogging site that I
choose to not quote here. However, you can read more about it at
[What is Amundsen's Maxim?](https://mamund.substack.com/p/what-is-amundsens-maxim))

In other words, if you expose the current data schema of your (internal) database, you lock your API into that implementation, or you risk breaking clients if you wish to refactor the database. (Mike followed up the original message with a clarification: "we need to be able to design/implement each aspect (data, object, resource, representation) independently without breaking the others.") Thus, I advise against adopting any query parameter patterns that expose the back-end implementation details of the API web service. I think this emphasizes the main purpose of following good API design and API design patterns: Expect change, and use API design to hide the API consumer from changes which should not impact them.

Getting back to our other patterns, I hope you can see why I think that
interpreting = in a URL's query parameters as _"is"_ works better than
_"equals"_, such as:

    ?amount=gt:0&amount=le:100.00

> amount is greater than 0 and amount is less than 100.00

Some of these obviously require URL encoding, namely:

    ?amount=(0%2C100.00%5D       // ?amount=amount=(0,100.00]
    ?amount=gt%3A0&le%3A100.00   // ?amount=gt:0&amount=le:100.00
    ?amount=and(gt(amount%2C0)%2Cle(amount%3A100.0)
    ?where=amount%20%3E%200%20and%20amount%20%3C%3D%20100
    ?$filter=amount%20gt%200%20and%20amount%20le%20100.00

Unfortunately, none of these are very legible once they have been URL encoded.

I like the range notation (also known as interval notation) because it
has existed in mathematics since before I first studied math (decades
ago). It is concise and very flexible. The ( and ) characters denote
open ended intervals (the interval does not include the adjacent
endpoint) and the [ and ] characters denote closed-ended intervals (the
interval includes the adjacent endpoint):

    ?amount=(20.0,100.0]  : amount > 20.0 && amount <= 100.0
    ?amount=[20.0,100.0]  : amount >= 20.0 && amount <= 100.0
    ?amount=(20.0,100.0)  : amount > 20.0 && amount < 100.0
    ?amount=[20.0,100.0)  : amount >= 20.0 && amount < 100.0
    ?amount=(20.00,)      : amount > 20.0
    ?amount=[20.00,)      : amount >= 20.00
    ?amount=(,100.0]      : amount <= 100.00
    ?amount=(,100.0)      : amount < 100.00

## This or That, Here or There

One additional query parameter pattern I use comes in handy when you
wish to express a condition where a resource's property is one of a
small list of values (usually string enumerations). I.e. to capture the
condition of testing if the state property of a chain link is one of
three values, draft, published, withdrawn, the desired natural language
query is something like

> List chain links where the chain link's state is either draft or
> published or withdrawn

As a query parameter, the
[OpenAPI Specification allows defining a query
using an pipe-delimited array](https://spec.openapis.org/oas/v3.1.1.html#style-values). This is convenient because the pipe
character, `|`, is used as a binary _**or**_ operator in several programming
languages. Thus, this filter maps to query parameter notation

    ?state=draft|published|withdrawn

In OAS 3.x notation, one can define a parameter:

```yaml
parameters:
  - name: state
    in: query
    explode: false
    style: pipeDelimited
    schema:
      type: array
      minItems: 1
      maxItems: 3
      uniqueItems: true
      items:
        $ref: '#/components/schemas/chainLinkState'
```

The `chainLinkState` schema is defined with a JSON schema such as

```yaml
components:
  schemas:
    chainLinkState:
      title: Chain Link State
      description: The state that a chain link resource may be in.
      type: string
      enum:
        - draft
        - published
        - withdrawn
```

The schema for the query parameter further constrains the parameter, allowing an API service to validate the value and reject invalid queries such as


    ?state=                         # minItems constraint violated
    ?state=garbage                  # items enum constraint violated
    ?state=draft|draft|draft|draft  # maxItems / uniqueItems: true
                                    # constraint violated

I prefer using named schemas for such cases compared to putting the enum
schema in line in the parameter definition, as this helps Software
Development Kit (SDK) code generation tools generate cleaner code.
Absent named schemas, code generation tools often construct new names
for data types based on the context or location, and I find the result
somewhat unsatisfactory.

## Parameterizing Operations

Query parameters can parameterize other operations, not just List operations. I try to avoid mixing request body data with parameterization. For example, when creating (POST) or updating a resource (PATCH or PUT), I put all the data necessary to create or update the resource in the request body. Query parameters may alter how the operation is performed, but the request body conveys what data to use.

For example, see how the `?dryRun=` query parameter alters the behavior
of a POST or other operation in
[Validating API Requests]({{'/2024/08/19/validating-api-requests'|relative_url}}).
There, the value of the `?dryRun=` query parameter is not part of the
request body payload &mdash; it does not get stored in the resource. Instead,
this parameterizes the operation, requesting that the server stop short
of creating or updating the resource, so that the client can let the API
service perform full validation of the request.

## Your Options

There are many conventions and patterns for Web API query parameters.
It's less important which style you choose, but as with any pattern,
what is more important is that you use it consistently across your APIs.

<hr>

{% include discuss.md %}

{% include orig.md %}
