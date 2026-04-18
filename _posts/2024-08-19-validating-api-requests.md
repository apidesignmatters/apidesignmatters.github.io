---
title: Validating API Requests
date: 2024-08-19 18:00:00 -0000
layout: post
tags:
  - the-language-of-api-design
  - api-design-patterns
---

> Techniques for API Request Validation

Next up in the [API Design Patterns]({{'/api-design-patterns' | relative_url}}) series on API Design Matters, I'd like to present some patterns for validating API requests.

![alt text]({{ '/assets/img/Validating-API-Requests.png' | relative_url}})

{% include language-of-api-design-series.md %}

As I discussed in
[Improve the Security of Your API's Data]({{'/2024/02/06/improve-the-security-of-your-apis-data'|relative_url}}):

> An API that allows unconstrained values to be passed is an API that likely has security vulnerabilities

That is, to keep an API secure, _it should not trust any data that it
receives_.
Applying strict JSON schema constraints and ensuring all API operations
are properly secured via authentication/authorization help with
maintaining the secure API posture.
But is there a flip side - can an API help client's validate their
interactions with the API?

A promise of REST APIs is good decoupling of clients and services. This
is achieved in part by reducing business logic as much as possible in
the client application. For example, a client application may use a form
for collecting information used in a `POST` operation to create an API
resource, or to edit an existing resource before updating it with a `PUT`
or `PATCH` operations. The client then maps the form fields to the
properties of the operation's request body. Clients can use front end
frameworks and libraries to perform lots of low-level validation in the
front end corresponding to JSON schema constraints. Examples include:

* Forms which use required data fields for properties that are required in the JSON schema
* Using date pickers
* Checkboxes for selecting Boolean true or false values
* Drop down lists that allows selection from a list of fixed enum values
* Constrained numeric text entry
* Form fields that enforce a regular expression matching of input from a
  `pattern` constraint

However, this only covers "syntactic" or static field-level validation.
Often, an API will also have _business rules_ that the client must
follow. Secure API services will enforce those business rules in the API
operations - for example:

* Parse the options and (JSON) request body and return a 400 Bad Request if any of the request data is malformed (i.e. does not satisfy the constraints of the operation&mdash;such as required body or required parameters&mdash;or all the JSON Schemas associated with the operation's parameters or request body)
* Verify that the caller passes valid Authorization to the API call, and return __401 Unauthorized__ if not
* Verify that the caller is authorized to perform the API operation, and return a __403 Forbidden__ error if not.
* Verify the state of the application and return __409 Conflict__ if the operation would put the application into an inconsistent state
* Verify the semantics of the request body and return a __422 Unprocessable Content__ error if the request is incomplete, inconsistent, or otherwise invalid

However, such problem responses only occur "after the fact" - they are returned after the client has made an API call. Many of these checks cannot be made by the client at all&mdash;for example, the client cannot validate a OAuth2 access token.

Can the API help the client prevent errors by performing business logic
and other validation for the client, so that such business rules do not
have to be embedded in the client?

One pattern is to extend the API operations with a _dry run_ feature. A
dry run is a variant of the API operation which performs all (and only)
the validation performed by the full operation, but does not execute the
associated behavior. As such, it will return the same
400/401/403/409/422 that the full operation would return, allowing the
client to highlight invalid form data or otherwise correct the problem.
The client can use dry run operations incrementally as the user fills out
a form, and disable the "Save" or "Next" or "Submit" or similar UI controls if
there are validation errors.

One way to implement a dry run is to create a separate "validation"
operation for each API operation. This has the significant disadvantage
of greatly increasing the footprint (size) of the API and adding a lot
of duplication.

Rather than duplicate operations to add sibling validation operations,
another approach is to add a

    ?dryRun=true

query parameter to the operations. When used, the operation can return __204 No Content__ if the request contains no problems. The `dryRun` parameter acts as a "short circuit" in the API operation. The implementation performs the full validation it would normally do before executing the desired behavior, but then stops before actually executing anything other than the validation.

This pattern has a small impact on the API footprint compared to making
sibling (duplicate) validation operations. A smaller footprint makes the API easier
to read and understand. It is also a good use of the [DRY principal]({{'/2023/04/09/dont-repeat-yourself-when-designing-apis'|relative_url}})
, since you do not have to duplicate the definition of all the operation
request parameters and request bodies, which opens up the chance for
them to become out of sync.
_You do not have to invent a new operation ID or create a new API path
for each operation._

For example, here is how to add a dryRun query parameter to the OpenAPI
definition, within the createCharacter operation to create a new
character in the Chain Links sample API:

```yaml
paths:
  '/characters':
    post:
      title: Create a Character
      description: >-
        Create a new Character. Use ?dryRun=true to perform validation
        of the data without actually creating a character.
      operationId: createCharacter
      parameters:
        - $ref: '$/components/parameters/dryRunQueryParam'
          description: >-
            If `true`, this operation only validates the request and
            it's data but does not actually create a character.
            The operation returns one of the defined 4XX errors
            if there are any problems, or
            returns 204 if there are no problems.
      security:
        ...
      responses:
        '204':
           description: >-
             No Content. There are no validation errors
             with the request data.
        '201':
           description: Created
           ...
components:
  parameters:
    dryRunQueryParam:
      name: dryRun
      in: query
      schema:
        type: boolean
        default: false
      description: >-
        If `true`, this operation only validates the request and
        it's data but does not execute the remainder of the request.
        The operation returns one of the defined 4XX errors
        if there are any problems, or
        returns 204 if there are no problems.
```

It is hard to make a completely generic dryRun parameter component
because the description should be specific to each operation where it is
used. In this case, I've used a component parameter `dryRunQueryParam`,
but provided a context-specific description of the `dryRun` parameter
for the `createCharacter` operation.

There is another API pattern that addresses these problems in a completely different way. The definition of a true REST API &mdash; Level 3 in the Richardson Maturity Mode &mdash; is _Hypermedia as the Engine of API State_, or HATEOAS. An important component of HATEOAS is "code on demand", whereby the API service _returns code to the client_ which can implement application logic. This can include performing some business logic checks/validation without such business logic being hard-coded in the client. I'll tackle HATEOAS in the future.
<hr>

{% include discuss.md %}

{% include orig.md %}
