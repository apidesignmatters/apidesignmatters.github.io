---
title: Understanding the Language of API Security
date: 2023-11-06 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> How OpenAPI expresses API security.... and how it does not

In today's issue, we begin a deeper dive into keeping APIs secure. I
hope you do not mind me assuming that you know why API security is
important. The how is harder, and there are many facets of API security.
We begin by exploring what can and cannot be expressed with
[OpenAPI 3.1](https://spec.openapis.org/oas/latest.html).

{% include language-of-api-design-series.md %}

The OpenAPI Specification (OAS) is a domain-specific language (DSL) for
defining HTTP APIs. As a language, it has a fixed syntax, and is thus
constrained by the expressiveness of that DSL. Let's explore that
language of APIs a bit more as it pertains to the security aspects of
APIs.

OAS provides two primary structures for defining an API's security:

1. [Security Schemes](https://spec.openapis.org/oas/latest.html#security-scheme-object) define the kind of authorization required to use the API. Each security scheme has a required security type and additional properties which configure and constrain that security scheme.
1. [Security Requirements](https://spec.openapis.org/oas/latest.html#security-requirement-object) specify which authorization a caller must supply when invoking an API operation, along with the authorization scopes that the caller's authorization must include. (We'll explain scopes below).

In addition to this explicit description of API security, there is also
implicit security scattered throughout OAS's expression of an API. Quite
a bit of security concerns are embedded in JSON schema, which we've
touched on in previous posts and which we will explore in more detail in
the next post.

![alt text]({{ '/assets/img/The-Language-of-API-Design-banner.png' | relative_url}})

## Sample Security Schemes and Requirements

In order to secure an operation in
[our sample Chain Links API](/2023/03/07/chain-links-domain-model), we
must complete a domain analysis of the API and understand the actors and
what they do. For example, only the authenticated Author should be
allowed to edit or delete their author resource or to view their account
details. We must also evaluate our options for authentication and
authorization for the Chain Links application and API. For example, we
can reject Basic authentication, as it is too insecure. For now, assume
we have chosen to use [OpenID Connect](https://openid.net/specs/openid-connect-core-1_0.html) for Chain Link API's
authentication/authorization.<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
 This is (in my opinion) the most robust
API authentication model that is directly expressible in OpenAPI.

We can express this in the OpenAPI source by defining a security scheme
with type: openIdConnect in the securitySchemes of the API components:

```yaml
components:
  securitySchemes:
    oidcAuthCodeFlow:
      type: openIdConnect
      ...
```

`securitySchemes` is an object; the keys are the names of the schemes, and
the values are their definitions, as per
[Security Scheme Object](https://spec.openapis.org/oas/latest.html#security-scheme-object).

The _name_ allows the security scheme to be referenced later. We choose
the name `oidcAuthCodeFlow` to make it clear that API operations that use this authorization
uses OIDC Authorization Code Flow. <a id='footnote-2-ref'/><a href='#footnote-2'><sup>2</sup></a>
To make our security scheme complete,
we add a description and the required `openIdConnectUrl`:

```yaml
components:
  securitySchemes:
    oidcAuthCodeFlow:
      type: openIdConnect
      description: >-
        OpenID Connect authorization using OAuth2
        Authorization Code Flow.
      openIdConnectUrl: >-
         https://auth.chainlinks.example.com/oidc/.well-known/openid-configuration
```

The `openIdConnectUrl` is the OpenID Connect discovery URI which a
client uses to perform the OAuth2 Authorization Code Flow that is part
of OpenID Connect. The client performs a GET on that URL to fetch a JSON
representation of the authorization server's
[OIDC metadata](https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata). Note: This
process should be done with a client library that implements the
authorization flow.

![alt text]({{ '/assets/img/The-Language-of-API-Security---Lock-2.png' | relative_url}})

Here is an example of defining OAuth2 authorization:

```yaml
components:
  securitySchemes:
    oauth2AuthCodeFlow:
      type: oauth2
      description: >-
        Authorization via OAuth2 Authorization Code Flow.
      flows:
        authorizationCode:
          authorizationUrl: >-
            https://auth.chainlinks.example.com/authorize
          tokenUrl: >-
            https://auth.chainlinks.example.com/token
          refreshUrl: >-
            https://auth.chainlinks.example.com/refresh
          scopes:
            author/read: Read Author resources
            author/update: Update Author resources
```

You'll notice that this is much more complex that the OpenID Connect
scheme, because OpenID Connect buries that complexity in the discovery
protocol: the authorization and token URLs are discovered while
negotiating the authorization. For OAuth2, the configuration has to be
spelled out (i.e. "discovered" via the OpenAPI document). There is a
higher degree of
[Convention over Customization](https://en.wikipedia.org/wiki/Convention_over_configuration)
with the openIdConnect scheme. (Hey, Convention over Customization: Big
fan.)

Once your security schemes are defined, you can annotate your APIs
operations with a security requirement. For example, to specify that the
patchAuthor operation requires authorization via our oidcAuthCodeFlow
security scheme, we express this in OpenAPI as:

```yaml
paths:
  /authors/{authorId}:
    patch:
      summary: Update an author
      description: ...
      operationId: patchAuthor
      security:
        - oidcAuthCodeFlow: [ author:update ]
```

## Understanding the Language of API Security

The language of this `security` object within an API operation
definition is not immediately evident, so let's explain the meaning of a
[security requirement](https://spec.openapis.org/oas/latest.html#security-requirement-object).
The `security` keyword introduces the operation's security requirement,
which is expressed as an array of objects. This structure is a bit
clearer if we show the JSON equivalent:

```json
  "security": [
    {
      "oidcAuthCodeFlow": [
        "author:update"
      ]
    }
  ]
```

In the example, the array has only one element, and that object has only
one key/value pair. The key is the name of a security scheme (
`oidcAuthCodeFlow` in this case, matching the ``oidcAuthCodeFlow``
security scheme we defined above ) and the value is always an array. If the security scheme's type is `oauth2` or `openIdConnect`, the array is a list of _scopes_. For all other security scheme types, the array must be empty.

That array of scopes lists the
[OAuth scopes](https://oauth.net/2/scope/) that the client must be
granted during the authorization flow in order to use the API operation.
(Explaining all of the OAuth flows, or event the basics of the
Authorization Code Flow, is beyond the scope of this article.<a
id='footnote-3-ref'/><a href='#footnote-3'><sup>3</sup></a>) Each scope
represents a specific access to an API operation or resource. In this
example, the scope author:update grants access to updating an author
within the Chain Links API. If the current authorization does not
include all of the scopes in the security requirement, then the API
should reject the request with a 403 Forbidden response code.

> Tip: Scope names often take the form of "noun:verb" or "noun/verb",
> where the _noun_ names a resource (or resource category) and the
> _verb_ names an action performed on, against, or with that resource.

You may have noticed an interesting difference between OAuth2 and OpenID
Connect security schemes: You must define the scopes with OAuth2, but
you cannot define the scopes with a OpenID Connect scheme. Like the
authorization and token URLs, the scopes are defined in the OIDC
discovery JSON data. This unfortunately means the descriptions of the
OIDC scopes are not available in the OpenAPI document, even though the
security requirements must still list the operation's required scopes.

## Defining an Operation's Security Requirement

An operation's
[Security Requirements](https://spec.openapis.org/oas/latest.html#security-requirement-object)
specify which authorization a caller must supply when invoking an API
operation and the authorization scopes that the caller's authorization
must include.

OpenAPI provides a very flexible means of composing the security
requirements as an array of one or more objects, in the security value
of an OpenAPI operation object.<a id='footnote-4-ref'/><a
href='#footnote-4'><sup>4</sup></a>

<pre>
    ...
      operationId: identifier<sub>0</sub>
      security:
        - security-requirements-object<sub>1</sub>
        - security-requirements-object<sub>2</sub>
        - ...
        - security-requirements-object<sub>n</sub>
</pre>

The caller must provide authorization that _at least one_ of the _n_
security requirement objects.

Each security-requirements-object<sub>i</sub> is an object consisting of
_key/value_ pairs, where the _key_ is the name of a security scheme
(as defined above) and the
_value_ is an array of scopes necessary to invoke the corresponding
operation:

<pre>
security-requirements-object<sub>i</sub> = {
   scheme-name<sub>1</sub> : [ scope<sub>1a</sub>, scope<sub>1b</sub>, ..., scope<sub>1x</sub> ],
   scheme-name<sub>2</sub> : [ scope<sub>2a</sub>, scope<sub>2b</sub>, ..., scope<sub>2x</sub> ],
   ...
   scheme-name<sub>n</sub> : [ scope<sub>na</sub>, scope<sub>nb</sub>, ..., scope<sub>nx</sub> ],
</pre>

In order to match a security requirement object, the API call must satisfy all of the _n_ elements of the security requirement object. The security requirements notation&mdash;a mini-language, if you will&mdash;is a concise representation of an implicit OR of ANDs.

Consider this contrived example involving 7 different security schemes
s1 through s7 using scopes a:read b:read and c:read.

```yaml
security:
  - s1: [ a:read, b:read ]
    s2: [ b:read, c:read ]
  - s3: [ a:read, b:read ]
    s4: [ b:read, c:read ]
  - s5: [ a:read, b:read ]
    s6: [ a:read, b:read ]
    s7: [ b:read, c:read ]
```

This notation expresses the equivalent of the following logical
combination. (I've omitted the scopes to make the logical structure
clearer.)

```text
   ( s1 AND s2 )
OR ( s3 AND s4 )
OR ( s5 AND s6 AND s7 )
```

> The security requirements notation is a
> concise representation of an implicit OR of ANDs.

This notation is fairly expressive, yet quite concise. Most uses are not
nearly this complex. Luckily, many times, both n and m is are 1, such
as:

```yaml
   security:
        - oidcAuthCodeFlow: [ author:update ]
```

Caution: More complex security requirements result in more complex SDKs!

## Consistent... Except When It Is Inconsistent

With OAS, the references to security schemes in a security requirements
object are only by name, and not via a `$ref`
([reference object](https://github.com/OAI/OpenAPI-Specification/issues/2475)).
This means that the named security scheme must be defined in the same
source file as the operations that use it.

This differs from how one references OAS components elsewhere. A `$ref`
allows an element in one OpenAPI document to reference a component
defined in the document or in another OAS document. However, one cannot
do that within security requirements&mdash;one can only name a security scheme
defined in the same document.

> Tip: this is not a serious problem, because you can still code the
> security schemes in a reusable component source file accessed relative
> to the current file (such as common.yaml ) and then put the $ref to
> those schemes in the same OAS document with the operations&mdash;a sort of
> daisy-chain effect:

```yaml
components:
  securitySchemes:
    oidcAuthCodeFlow:
      $ref: >-
        common.yaml#/components/securitySchemes/oidcAuthCodeFlow
```

Normally, I'm a big advocate of consistency. One might say that I consistently advocate for consistency. It's important&mdash;for good Developer Experience&mdash;for an API to be consistent:

* Consistent within itself (i.e. across schemas and operations)
* Consistent with other APIs
* Consistent with standards.

But I guess every rule has its exceptions.<a id='footnote-6-ref'/><a href='#footnote-6'><sup>6</sup></a>
Had security requirements used `$ref` notation instead of just names of
security schemes, its expression would be much more cumbersome and
verbose, with little benefit.

## So What's Missing?

We've seen that APIs defined with OpenAPI can use a variety of API security schemes. While all of these represent authorization to use API operations, none of them express data-level entitlements (also known as row-level security), such as which bank accounts the user has access to out of all the accounts held at a bank.

The `oauth2` security scheme lists the names and descriptions of all the
scopes, which allows validation that the `security` objects for the API
operations use only scopes that are defined. This also provides a
`description` of each scope in any API documentation you generate from
the OpenAPI document. In order to full understand the scopes when using
`openIdConnect`, the tooling must fetch the OIDC discovery document and
check its scopes, although that document is not guaranteed to be
available to such tools.

Also, while the
[server object](https://spec.openapis.org/oas/latest.html#serverObject)
in an OpenAPI document can use variables to parameterize the URL by
which the API is invoked, one cannot use server variables to
parameterize the `authorizationUrl`, `tokenUrl`, or `openIdConnectUrl`.
[Project Moonwalk](https://github.com/OAI/moonwalk), the OpenAPI
Initiative's work on version 4 of the OpenAPI Specification, may address
this shortcoming. Using a relative URI instead of an absolute URL (so
that the OIDC configuration is relative to the runtime API base path)
can also help.

In the next issue of API Design Matters, we'll look at less explicit
means of securing APIs with the OpenAPI Specification: Defining `401`,
`403`, and `404` response codes<a id='footnote-7-ref'/><a href='#footnote-7'><sup>7</sup></a>
, and specifying strict JSON Schema
constraints. Stay tuned!

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
OpenAPI defines other security scheme types:

1. `http` authorization, using the basic format, uses an Authorization header with an encoded username:password string which is easily decoded, and thus inherently very insecure. (It is quite easy for a malicious actor to steal your user ID and password.) I strongly recommend against using authorization based on basic authentication.
1. The `http` type may also be used with the `bearer` format to pass a Java Web Token for authorization.
1. `apiKey` is a way to pass one or more an authorization strings on each operation, in different request headers. This is also not very secure (and in fact is not really API security&mdash;API keys are really mechanisms to identify the client making the API call. However, an apiKey security scheme can be used to implement other non-standard security protocols.
1. `mutualTLS` is used for client certificate based security. The client passes an encoded certificate with the request and the lower level Transport Layer Security (TLS) tier validates the certificate at the edge. The certificate identifies the user and represents their authorization to use the service. Oddly, the OpenAPI specification does not define what the mutualTLS security scheme is; it is simply implicitly client certificates via TLS.

<a id='footnote-2'/><a href='#footnote-2-ref'><sup>2</sup></a>
This name informs readers that authentication is done via OIDC and uses Authorization Code Flow&mdash;a secure way to obtain authorization in otherwise insecure applications like web and mobile apps.

<a id='footnote-3'/><a href='#footnote-3-ref'><sup>3</sup></a>
Did I just say that scopes are out of scope?

<a id='footnote-4'/><a href='#footnote-4-ref'><sup>4</sup></a>
You can define a general security object at the root of the OpenAPI. The defines a default security requirement that applies to all operations that do not explicitly define their own security requirements. However, with OAuth2 or OpenIDConnect security, different operations often require different fine-grained sets of scopes, so it is less common for a document-wide default security requirement to work well... unless one defines a very broadly applicable scope that covers multiple resources and multiple actions, or one partitions operations into separate OpenAPI document based on the scopes. While possible, this does not seem to be a useful way to organize APIs.

<a id='footnote-5'/><a href='#footnote-5-ref'><sup>5</sup></a>
Luckily, most of the time, n is 1!

<a id='footnote-6'/><a href='#footnote-6-ref'><sup>6</sup></a>
Does the rule "every rule has its exceptions" have an exception? Kurt G&ouml;del or Douglas Hofstadter may know...

<a id='footnote-7'/><a href='#footnote-7-ref'><sup>7</sup></a>
Much easier and much more concise than defining `401,403,404` response
codes.

{% include discuss.md %}

{% include orig.md %}
