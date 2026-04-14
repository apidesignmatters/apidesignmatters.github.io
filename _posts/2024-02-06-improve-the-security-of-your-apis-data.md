---
title: Improve the Security of Your API's Data
date: 2024-02-06 18:00:00 -0000
layout: post
tags:
  - the-language-of-api-design
  - json-schema
---

> Employ the strength of JSON Schema in OpenAPI to increase your API's security

The OpenAPI Specification is a language for expressing the design of an API. But contained within OpenAPI is another language: JSON Schema. Like OpenAPI, JSON Schema is defined by a standards specification (published at [json-schema.org](https://json-schema.org/specification.html)). You saw the tip of the JSON Schema iceberg in [What Am I Getting Out of This?]({{'/2023/03/16/what-am-i-getting-out-of-this'|relsative_url}}).

Fortunately for us, _**JSON Schema also contains constructs that assist in keeping your API secure**_.

![Banner with graphic text "Improve the Security of your API's Data" , "API Design Matter", "David Biesack"]({{
 '/assets/img/Improve-the-Security-of-Your-APIs-Data.png' | relative_url}})

{% include language-of-api-design-series.md %}

As a motivating example, I encourage you to read [_How Spoutible's Leaky API Spurted out a Deluge of Personal Data_](https://www.troyhunt.com/how-spoutibles-leaky-api-spurted-out-a-deluge-of-personal-data/) by Troy Hunt, or simply search for "top API data leaks" and read a sample. But don't get sucked down that rabbit hole.

None of us want our APIs to be called out in someone's blog post on leaky APIs, or showing up in an "API Hall of Shame" or even making into national news.

A common theme in such leaky API stories is _excessive data exposure_ - an API that returns too much sensitive data that can then be exploited. We covered the most obvious steps to securing APIs by ensuring you have adequate security requirements guarding who can call each operation: see [Understanding the Language of API Security]({{'/2023/11/06/understanding-the-language-of-api-security'|relative_url}}).


In today's issue, we begin a deeper dive into keeping APIs secure. I hope you do not mind me assuming that you know why API security is important. The _how_ is harder, and there are many facets of API security. We begin by exploring what can and cannot be expressed with


But there are more ways that poorly designed APIs can be exploited, even if they have good `security` requirements on all operations and are implemented and configured correctly. So how does JSON Schema help us plug those holes?

Let's revisit some of the schemas we defined earlier&mdash;see [What Am I Getting Out of This?]({{'/2023/03/16/what-am-i-getting-out-of-this'|relsative_url}}) for the JSON schema that describes the response from the `getChainLinks` operation. Here is that schema (and YAML example) for reference:

```
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

Let's explore some refinement allowed by JSON Schema.

This is a fairly well constrained schema definition. Adding validation constraints is important for API data schemas, both for informing your consumers what values are valid, and also for API security. An API that allows unconstrained values to be passed is an API that likely has security vulnerabilities: it is open to Denial of Service attacks by malicious clients that pump really large data values (such as 100,000 character strings) into the API. By adding constraints such as `maxItems` to array and `maxLength` to strings, you can help reduce the API's risk. (Other strategies, such as using middleware the rejects unreasonably large request bodies can also help)

An API that allows unconstrained values to be passed is an API that likely has security vulnerabilities

Some development tools, like the [Spectral API linter](https://stoplight.io/open-source/spectral) and its [OWASP ruleset](https://github.com/stoplightio/spectral-owasp-ruleset) (both [open-source software from Stoplight](https://stoplight.io/open-source)) the can check your OpenAPI definition and schemas and highlight where you can tighten up security. (See the second link for some installation instructions for those who already have Node.js installed.) The Spectral OWASP ruleset applies some linting checks based on the [OWASP API Security Top Ten, 2019 edition](https://owasp.org/www-project-api-security/). An update to the Open Worldwide Application Security Project (OWASP) list was released in late 2023; as of this writing, an update to the Spectral OWASP ruleset for the 2023 edition is in the works.

See also the
[OpenAPI Editor by 42Crunch](https://42crunch.com/tutorial-openapi-swagger-extension-vs-code/);
it also helps "shift left" and identifies potential security risks in an
OpenAPI definition by using 42Crunch's [API Audit](https://42crunch.com/api-security-audit/) tool. Other API security vendors have similar static OpenAPI scanning tools.

Running Spectral+OWASP ruleset against the early drafts of our Chain Links OpenAPI definition shows a few schema related candidates for tightening up the API definition:

```
error  owasp:api4:2019-string-limit                Schema of type string must specify maxLength, enum, or const.           paths./chainLinks.get.responses[200].content.application/json.schema.properties.items.items.properties.type
error  owasp:api4:2019-string-restricted           Schema of type string must specify a format, pattern, enum, or const.   paths./chainLinks.get.responses[200].content.application/json.schema.properties.items.items.properties.type
error  owasp:api4:2019-string-limit                Schema of type string must specify maxLength, enum, or const.           paths./chainLinks.get.responses[200].content.application/json.schema.properties.items.items.properties.createdAt
```

The `owasp:api4:2019-string-limit` error is based on [API4:2019 Lack of Resources & Rate Limiting](https://owasp.org/API-Security/editions/2019/en/0xa4-lack-of-resources-and-rate-limiting/) which recommends

> Define and enforce maximum size of data on all incoming parameters and payloads such as maximum length for strings and maximum number of elements in arrays.

The `owasp:api4:2019-string-restricted `error is based on the same OWASP rule, but with a different twist. By specifying a `format` annotation or `pattern` assertion on string properties (when `enum` or `const` do not apply), you can also reject some malicious requests. An example of a suitable string `format` is using `format: date` or `format: date-time` for properties that convey a date or timestamp value.

The OWASP rule applies to incoming payloads, but Spectral does not do deep analysis of the API and JSON models to determine if a field is confined to only response schemas or may be used in a request schema, so it errs on the side of caution and assumes the latter.

By adding a `maxLength` constraint to string schemas (or using an `enum` list of allowed values or a single `const` allowed value, bad (malicious) requests can be blocked early in the API request processing&mdash;when validating the request. This work can be pushed to the "edge" of your network such as an API gateway (where it is often cheaper to detect such problems), rather than deferring checks until the request has made its way into your back end service tier where such invalid requests can negatively impact response time and scalability needed for valid traffic.

This implies an API implementation and deployment that performs _full request validation_. That is, a secure API implementation must treat all input data as untrusted, and reject any data that it deems to be invalid. Since all the data in a request&mdash;response bodies, even query and header parameters&mdash;are defined with JSON Schema in OpenAPI, look for infrastructure and middleware that performs JSON Schema validation of such request data, including support of the [Format-Assertion vocabulary](https://json-schema.org/draft/2020-12/json-schema-validation#name-format-assertion-vocabulary) which mandates checking strings against the defined OpenAPI and JSON schema formats. This will prevent a number of OWASP vulnerabilities.

A secure API implementation must treat all input data as untrusted, and reject any data that it deems to be invalid.

To go further, use the `unevaluatedProperties: false `assertion in your object schema definitions, as explained in [Master More JSON Schema's Subtleties]({{'/2023/07/30/master-more-json-schemas-subtleties'|relative_url}}). Place this assertion above/next to your properties object. This assertion in a schema causes a validator to reject any properties that are not evaluated (not matched) by other assertions, such as `properties` in your schema composition. (See [Master JSON Schema's Subtleties]({{'/2023/07/11/master-json-schemas-subtleties'|relative_url}}) for some tips on composing JSON Schemas.)

Part of [Spoutible's Leaky API](https://www.troyhunt.com/how-spoutibles-leaky-api-spurted-out-a-deluge-of-personal-data/) could have been plugged if it defined a strict JSON schema, not just for validating the API's input, but for also validating its response bodies:

*   By employing `unevaluatedProperties: false` in your API's request schemas (coupled with an accurate and restrictive set of properties you explicitly want the caller to send), you can prevent [Mass Assignment](https://owasp.org/API-Security/editions/2019/en/0xa6-mass-assignment/) vulnerabilities.

*   By employing `unevaluatedProperties: false` in your API's response schemas, you can also prevent [Excessive Data Exposure](https://owasp.org/API-Security/editions/2019/en/0xa3-excessive-data-exposure/).


The [Excessive Data Exposure](https://owasp.org/API-Security/editions/2019/en/0xa3-excessive-data-exposure/) OWASP API Security page advises:

> Avoid using generic methods such as `to_json()` and `to_string()`. Instead, cherry-pick specific properties you really want to return

That is, simply returning _all_ the data properties stored for a
resource risks including highly sensitive or exploitable data in API
responses. Additionally, if an engineer adds new data to a data table,
that data may get returned automatically, resulting in another type of
data exposure. If the OpenAPI definition and schema define a response
schema to include only properties `a,` `b` and `c`, and your
implementation validates response bodies against the defined schema, it
will catch a poor implementation which tries to return other properties
not defined by the `properties` object(s) for the response, such as an
`_code` or a `password` property. Applying JSON Schema validation to
your response bodies will cause validation to fail if the service
implementation is or becomes leaky.

JSON Schema is nice for modeling your API data, but it goes well beyond
that by providing an API language for securing your API in multiple
dimensions. Master these Language of APIs skills to protect your
customer's data, your job, and your company's future... Stay safe out
there, folks.

<hr>

{% include discuss.md %}

{% include orig.md %}
