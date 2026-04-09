---
title: Your API Has Problems. Deal With It.
date: 2023-03-26 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> _Learn how RESTful APIs can respond to run-time problems_

Having tackled the problem of describing the output of a successful API
operation, you now have some useful API design skills&mdash;well done!
Unfortunately, in today's world, a successful API call often feels like
the exception rather than the rule. The list of problems which can arise
with a public API is big. You just won't believe how vastly, hugely,
mind-bogglingly big it is. I mean, you may think the list of problems
with those darn teenagers is long, but that's just peanuts to public API
problems.<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>

![Banner with graphic text: Your API Has Problems. Deal with It. The Language of
API Design: David Biesack]({{'/assets/img/your-api-has-problems.jpg' | relative_url}})

{% include language-of-api-design-series.md %}

Even if your API has the most elegant and tightest design, problems can
arise when external systems try to use it.

* A client can pass invalid data, such as sending non-JSON text or JSON that does conform to the required schema.
* A client can reference a resource that does not exist.
* A client can attempt an operation with improper or no authentication.
* A client can attempt to put the system into an inconsistent state.
* A malicious client can try to flood the service, try to access someone else's personal or financial information, or otherwise cause harm.

So, problems are a reality that a well-designed API should (must) deal
with. There are two primary OpenAPI design elements related to
addressing such problems.

1. HTTP status codes
1. API response bodies

First, let's look at how we might define problem responses for the
`listChinLinks` operation introduced in
[From Domain Model to OpenAPI]({{'/2023/03/09/from-domain-model-to-OpenAPI'
| relative_url}}). That
operation has several query parameters, and hence two possible problems
are passing query parameters with invalid syntax or passing nonsense
values. Each query parameter is defined with an OpenAPI parameter object
and a schema which constrains the value. For example, the operation
definition allows an authoredOn query parameter:

```yaml
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

such as

```text
GET .../chainLinks?authoredOn=[2023-01-01,2023-03-31]
```

but a client may pass ill-formed request:

```text
GET .../chainLinks?authoredOn=[purple,rain]
GET .../chainLinks?authoredOn=3.14159
```

A robust API will _detect and reject invalid requests_. (We'll discuss why that is important to API security later in _The Language of API Design_.)

## HTTP Status Codes

As we saw in the last article in The Language of API Design, you define the normal success response to an API operation in the responses object, with a response object corresponding to the 200 or other 2XX HTTP status code:

```yaml
paths:
  /chainLinks:
    get:
      responses:
        '200':
          description: OK. The operation succeeded.
          content:
            application/problem+json:
              schema:
                title: Chain Links
                ...
```

Along with that `"OK"` response, you can also define the response for a
`201` Created response code when an API creates a new resource, `202`
Accepted when a service accepts a valid request but does not fully process it
before returning, `204` if there is no response body, and other
`200`-level status codes, etc.

When a problem occurs&mdash;more correctly, when the service detects one
of that mind-bogglingly huge list of possible problems&mdash;other HTTP
status codes describe a variety of problem responses. With OpenAPI, you
can add new entries to the operation's `responses` object, one for each
of the applicable status codes.

A `400` response means __Bad Request__: the service has detected some
issue with the request and rejects it as "bad". It is most often used
when there is a syntactic error in the request, such as input not being
valid JSON when the operation requires JSON, or the value not conforming
to the corresponding JSON schema. This validation obviously applies to
the request body, but also to header parameters, request parameters, and
even path parameters: OpenAPI lets you define JSON Schema and
fine-grained validation constraints for them all.

The response corresponding to the `400` Bad Request status is defined
with a `'400'` key (a string) in the `responses` object.

```yaml
paths:
  /chainLinks:
    get:
      responses:
        '200': ... as seen above ...
        '400':
          description: Bad Request.
          content:
            application/problem+json:
              schema:
                title: Problem
                ... filled in below ...
```

`400` is a broad "category" response: any invalid request could result in a `400`, although there are other response codes for more _specific_ kinds of bad requests. In addition to `400` Bad Request, the most common 4xx errors I see in APIs are:

* [401](https://davidbiesack.github.io/http-status-codes/401) [Unauthorized](https://davidbiesack.github.io/http-status-codes/401) - No authorization was passed to an operation that required authorization.
* [403](https://davidbiesack.github.io/http-status-codes/403) [Forbidden](https://davidbiesack.github.io/http-status-codes/403) - Authorization was passed but it is insufficient to access this resource.
* [404](https://davidbiesack.github.io/http-status-codes/404) [Not Found](https://davidbiesack.github.io/http-status-codes/404) - The resource at the given URL does not exist.
* [405](https://davidbiesack.github.io/http-status-codes/405) [Method Not Allowed](https://davidbiesack.github.io/http-status-codes/405) - The HTTP method is not supported for this resource.
* [406](https://davidbiesack.github.io/http-status-codes/406) [Not Acceptable](https://davidbiesack.github.io/http-status-codes/406) - The requested response media type (Accept header) is not supported.
* [409](https://davidbiesack.github.io/http-status-codes/9) [Conflict](https://davidbiesack.github.io/http-status-codes/9) - The request would cause a state conflict in the target resource.
* [418](https://davidbiesack.github.io/http-status-codes/418) [I'm a teapot](https://davidbiesack.github.io/http-status-codes/418) - An attempt to brew coffee with a teapot (No, I'm kidding, 418 I'm a teapot is not really very common.)
* [422](https://davidbiesack.github.io/http-status-codes/422) [Unprocessable Entity](https://davidbiesack.github.io/http-status-codes/422) - The request was syntactically correct but cannot be processed because the service cannot interpret it.
* [429](https://davidbiesack.github.io/http-status-codes/429) [Too Many Requests](https://davidbiesack.github.io/http-status-codes/429) - The request exceeds allow rate limits.

`4XX`-level status codes are meant for problems originating in the
calling client application, and the client should alter the request to
correct the problem. The client should not simply retry the operation
hoping for a better result.

`5XX`-level status codes refer to problems that occur in the service.
Such errors cannot be corrected from the client side, although some
`500`-level errors may be transient, and the client might be able to
successfully retry the operation later.

An OpenAPI definition need not&mdash;and should not&mdash;list every
possible status code for each operation. Some response codes are simply
not possible for some of an API's operations, such as a 413 Request
Payload Too Large response code for a GET or DELETE operation that has
no request body. I prefer to list the likely status codes but note that
any operation may return any appropriate HTTP status code, and clients
should not code to only those status codes listed in the API definition.

## The API Hall of Shame

Before moving on to discuss the response body representation of API
problems, I'll offer some advice to keep you out the API Hall Of Shame.
APIs end up in the API Hall of Shame when they return a 200 OK status
for all API responses, then include error: true or an errorMessage
string in the response when there is a problem. Please don't do this, as
it violates developer expectations and forces developers to intermingle
error handling with normal response handling. The number of Internet
memes for this design flaw is big. You just won't believe how vastly,
hugely, mind-bogglingly big it is. I mean, ... well, you get it.

API Design Matters readers may also view a special article,
[My Favorite API Memes]({{'/2023/03/25/my-favorite-api-memes' | relative_url}}), which includes several memes related to this anti-pattern.

## API response bodies

Yes, you could just return raw 400 or other 4xx/5xx status codes, with no response body. That's analogous to a compiler that aborts without an error message when your program has a syntax error... basically giving the middle finger to any developer using your API.

![image from http.cat/400]({{'/assets/img/cat-response-to-using-200-ok-for-problems.png' | relative_url}})

I recommend returning JSON responses with accurate, specific 4xx and 5xx
status code. Moreover, I recommend using the `application/problem+json`
format as defined by [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457).
This format, used by more and more APIs, provides standard properties
for describing the problem in more detail, as well as adding a `type`
property which can pinpoint exactly the type of error that occurred.
Below is a possible `400` response object definition for the above

```text
GET .../chainLinks?authoredOn=3.14159
```

call, augmented with the `application/problem+json`
response description for the `400` __Bad Request__ HTTP status:

```yaml
paths:
  /chainLinks:
    get:
      responses:
        '200': ... as seen above ...
        '400':
          description: Bad Request.
          content:
            application/problem+json:
              schema:
                title: API Problem
                description: >-
                  API problem response, as per
                  [RFC 9457](https://tools.ietf.org/html/rfc9457).
                type: object
                properties:
                  type:
                    description: >-
                       A URI reference
                       [RFC 3986](https://tools.ietf.org/html/rfc3986)
                       that identifies the problem type.
                    type: string
                    format: uri-reference
                    maxLength: 2048
                  title:
                    description: >-
                      A short, human-readable summary
                      of the problem type.
                    type: string
                    maxLength: 120
                  status:
                    description: >-
                      The
                      [RFC 9110](https://tools.ietf.org/html/rfc9110)
                      HTTP status code generated by the origin server
                      for this occurrence of the problem.
                    type: integer
                    format: int32
                    minimum: 100
                    maximum: 599
                  instance:
                    description: >-
                      A URI reference that identifies
                      the specific occurrence of the problem.
                    type: string
                    format: uri-reference
                    maxLength: 256
                  detail:
                    description: >-
                      A human-readable explanation
                      specific to this occurrence of the problem.
                    type: string
                    maxLength: 2048
```

The `title` and `detail` properties are informative. The `type` property
is a URI that uniquely identifies the specific problem. Even if the
error is a generic `400` Bad Request, the `type` can provide additional
information about the specific bad request, which can specify why the
request is bad. In the example problem response below, the URI indicates
the problem is an invalid parameter. RFC 9457 does not mandate what this
URI is and does not even require that it resolve to a resource, but it
is helpful if it is the URL of a resource (such as an HTML page) which
describes that specific problem.

> _Warning_: Don't start copying this problem response schema into other
> 4xx responses or other operations yet&mdash;The Language of API Design will
> soon describe the _Don't Repeat Yourself_ (DRY) Principal to eliminate the
> need for copy/paste and overly verbose/repetitive API definitions.

When the `getChainLinks` operation is invoked with invalid query
parameters, the JSON response may look something like the following:

```json
{
  "type": "https://api.chainlinks.example.com/problems/invalidQueryParameter?names=authoredOn",
  "title": "Invalid query parameter",
  "detail": "The authoredOn parameter has invalid date range syntax.",
  "instance": "https://api.chainlinks.example.com/chainLinks?authoredOn=[purple,rain]"
}
```

This is certainly a big improvement over no information! Good on ya, mate! Returning such a problem description is one way to improve an API's developer experience (another major theme of _API Design Matters_.)

## Observations on Problem Responses

One significant point about RFC 9457 is that it defines a _problem_
response, not necessarily an _error_ response. This means that the
`application/problem+json` format may be used for many situations, _not
just errors_. It can be used for warnings or validation responses. For
example, if an API provides an operation to validate some data, the
response could be a list of data validation problems using
this problem format.

The `title` and `detail` and other properties of a problem response
__should not__ include tracebacks or other data that might reveal
service implementation details. Such information could expose attack
vectors that hackers can exploit. Tracebacks can help verify specific
versions of frameworks and utility libraries used in the API service,
and there may be known vulnerabilities with those versions that hackers
can exploit.

Having a good framework for reporting problems may help you as an API
designer think more about what problems may occur with your API. Just
reviewing all the standard 4xx and 5xx HTTP status codes will help you
account for them in your APIs.

Typically, the `title` and `detail` properties are intended for the
_developer_, not the end user. Rarely, if ever, should a client
application display those strings to the end user. The user is not aware
of the API layer nor how the application maps user experience activity
to API calls. Most 4xx errors indicate defects in the client
application&mdash;it may have constructed the request incorrectly, so it does
not help the user to present a message such as _The authoredOn parameter
has invalid date range syntax_.

This implies that the client developer should be reading the API
documentation carefully and know what is and is not valid input. Using a
client SDK, generated from the OpenAPI document, can greatly help with
this, and we'll discuss SDK's later in _API Design Matters_. Developing
and testing the client application against a realistic test environment
(i.e., not just a mock) can also help identify all such client defects
before releasing the client to end users.

The last piece of advice inspired by our discussion of problem responses
is to _follow standards as much as possible_. This means returning the
correct HTTP status code based on the actual type of error or problem,
and equally important, using the HTTP methods as intended. Use
well-defined standard models like RFC 9457 and `application/problem+json`
rather than inventing your own error/problem format. (Note: RFC 9457
does allow adding additional properties besides those listed in the
RFC.) By adhering to these standards, your API will meet most
developers' expectations. Your API consumers will also get the maximum
benefit from libraries and infrastructure that are designed to work with
the well-testing HTTP application protocol.

Problems happen. Often. Planning for problems and building appropriate
mechanisms to deal with and describe those problems go a long way
towards our goal of better API design for all.

<hr>

<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
With sincere apologies and utmost reverence to Douglas Adams.

{% include discuss.md %}

{% include orig.md %}
