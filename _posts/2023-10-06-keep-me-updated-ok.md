---
title: Keep Me Updated, OK?
date: 2023-10-06 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

We've already explored API List operations in depth in What Am I Getting
Out of This? We also covered how to Create new resources in Getting
Creative with OpenAPI. Next, let's explore the many API design matters
of Updating resources.

![alt text]({{ '/assets/img/Keep-Me-Updated,-OK.png' | relative_url}})

{% include language-of-api-design-series.md %}

## Updating API Resources with the PUT Method

While `PUT` is a conventional way to implement the Update operation in a
CRUDL pattern, relying to heavily on CRUDL is perilous. The HTTP
specification establishes
[the semantics of the PUT method](https://datatracker.ietf.org/doc/html/rfc9110#name-put).

Notably:

> The PUT method requests that the state of the target resource be
> created or replaced with the state defined by the representation
> enclosed in the request message content. A successful PUT of a given
> representation would suggest that a subsequent GET on that same target
> resource will result in an equivalent representation being sent in a
> 200 (OK) response.

This is an important distinction. If an object has optional properties,
such that a Read (`GET`) operation may omit some values based on the state
of the application, then omitting those values in a PUT request should
be interpreted as a request to reset those values to an omitted state,
not simply a request to skip updating those properties.

Thus, APIs should avoid using PUT to perform partial updates of a
resource. A _partial_ update assigns only the fields that are present in
the request and does not update any properties not present in the
request. Using `PUT` for partial updates breaks the implicit and accepted
understanding of HTTP `PUT`'s semantics, which can confuse your API
consumers who expect consistency across API providers.

## Using PATCH for API Updates

An alternative to using `PUT` is to use the `PATCH` method. Although `PATCH`
is not officially part of the HTTP specification&mdash;it is defined by [its
own RFC](https://datatracker.ietf.org/doc/html/rfc5789)&mdash;the HTTP specification does reference it:

> Partial resource updates are also possible [...] by using a different
> method that has been specifically defined for partial updates (for
> example, the PATCH method defined in [[RFC5789](https://datatracker.ietf.org/doc/html/rfc5789))

JSON Merge Patch
([RFC 7386](https://datatracker.ietf.org/doc/html/rfc7386)) is a
standard that defines a set of semantics for `PATCH`. There are other
standards, such as
[JSON Patch](https://datatracker.ietf.org/doc/html/rfc6902), that define
alternative semantics for `PATCH`. JSON Patch is a language of its own,
and it requires complex implementation support. By contrast, JSON Merge
Patch has only three behaviors:

1. A named non-`null` value in the request replaces the same named value in the target resource.
1. A named `null` value unsets or removes a named value in the target resource.
1. Any value not named in the request is left unchanged in the target resource.

Here is the definition of the `patchUniverse` operation, which allows
the client to specify the request body is using JSON Merge Patch by
using the `application/merge-patch+json` content type or just
`application/json`.


```yaml
paths:
  /universes/{universeId}:
    parameters:
      - $ref: '#/components/parameters/universeIdPathParam'
    patch:
      summary: Patch a Universe instance.
      description: >-
        Update the mutable properties a Chain Link Universe instance.
        This update follows
        [JSON Merge Patch](http://datatracker.ietf.org/doc/html/rfc7386)
        semantics.
      operationId: patchUniverse
      tags:
        - Universes
      requestBody:
        description: Mutable properties of the universe to be updated.
        content:
          application/merge-patch+json:
            schema:
              $ref: '#/components/schemas/universePatch'
          application/json:
            schema:
              $ref: '#/components/schemas/universePatch'
      responses:
        '200':
          description: OK. The operation succeeded.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/universe'
        '400':
          $ref: 'common.yaml#/components/responses/400'
        '404':
          $ref: 'common.yaml#/components/responses/404'
```

(The cited
[common.yaml file is defined here](https://gist.github.com/DavidBiesack/fd879884aea86e0b76648a3657a0ef54).
The universePatch schema is defined below.)

The __Update__ operation is expressed with an OpenAPI operation object with one path parameter, denoted here by {universeId}. A path parameter lets you define an API URL path element that varies from call to call; the parameter is a placeholder for the value of that varying path element. The parameter {universeId} is replaced with the id value of a specific Universe instance. Path parameters are defined with a parameter object in the OpenAPI Specification. Each OpenAPI parameter has the following properties:

* a `name` (`"universeId"` in this example)
* a required `in` property. For path parameters, the value of the `in` property is always `path`. The `in` property may also have the value `header`, `query`, or `cookie` for those type of operation parameters.
* a `description`
* a flag to indicate if the parameter is _required_. This must always be `true` for path parameters.
* a schema to define the parameter's valid values (JSON Schema data type and constraints).

OpenAPI allows you to define the path parameter at either the path level
(shared among all operations defined for that path), or at the operation
level. We use a `$ref` to reference a parameter component. OpenAPI uses
a `parameters` array, since a path or operation can have multiple
parameters.

To define parameters at the path level, we nest the parameters beneath the path 1/universes/{universeId}1 as a sibling object of the patch operation:

```yaml
paths:
  /universes/{universeId}:
    parameters:
      - $ref: '#/components/parameters/universeIdPathParam'
    patch: ....
components:
  parameters:
    universeIdPathParam:
      name: universeId
      description: The unique `id` of an existing Universe instance.
      in: path
      required: true
      schema:
        type: string
        minLength: 4
        maxLength: 48
        pattern: ^[-_a-zA-Z0-9:+$]{4,48}$
```

At the operation level:

```yaml
paths:
  /universes/{universeId}:
    patch: ....
      parameters:
        - $ref: '#/components/parameters/universeIdPathParam'
```

I prefer the former for path parameters since it is easier to add other operations (such as a delete) that share the same path parameters.
This way, all operations defined within the path use the same definition
for the `{universeId}` path parameter, keeping the API definition DRY.

Finally, the `200 OK` response uses the `universe` schema so that the
client receives the updated state of the resource, including any derived
properties. By returning the full representation, the client does not
need to make another API call to the Read (`GET`) operation.

## Modeling the Update Operations' Request Body

Keeping in mind that REST is the exchange of representations of resources and application state, an Update is an operation that passes a representation of the resource in the request body. The JSON representation of our Universe resource may look like the following, as defined by a universe schema and returned by the Read and Create operations:

```json
{
  "id": "uni-489f34dhj37sghj",
  "name": "DragonTerr",
  "description": "A world where dragons rule",
  "createdAt": "2023-08-23T18:34:10.444Z",
  "creator_url": "/authors/au-ndklxhjf8933x0",
  "characters_url": "/characters?universe=uni-489f34dhj37sghj",
  "chains_url": "/chains?universe=uni-489f34dhj37sghj"
}
```

However, several (most!) of these properties are derived and immutable, and thus unnecessary in the update request body. This is a fairly common situation.

One way to code for this in OpenAPI is to mark the immutable properties as `readOnly: true` in their JSON Schema. The OpenAPI Specification (version 3.0) says of `readOnly: true` :

> Declares the property as "read only". This means that it MAY be sent as part of a response but SHOULD NOT be sent as part of the request. If the property is marked as readOnly being true and is in the required list, the required will take effect on the response only. A property MUST NOT be marked as both readOnly and writeOnly being true. Default value is false.

However, since OpenAPI 3.1 relies on JSON Schema, OAS 3.1 is now silent
on `readOnly`. JSON Schema says of the [`readOnly` keyword](https://json-schema.org/draft/2020-12/json-schema-validation#name-readonly-and-writeonly):

> If `"readOnly"` has a value of boolean `true`, it indicates that the value of the instance is managed exclusively by the owning authority, and attempts by an application to modify the value of this property are expected to be ignored or rejected by that owning authority.

Thus, the service behind the API (the "owning authority") must be
careful to not update the value of read-only properties when updating
the subsequent representation of the resource (normally by not updating
the application storage of the resource). Indeed, improper adherence to
the `readOnly: true` constraint is a common API security vulnerability,
described by [API3:2023 Broken Object Property Level Authorization](https://owasp.org/API-Security/editions/2023/en/0xa3-broken-object-property-level-authorization/) in
the OWASP API Security Top Ten vulnerabilities (formerly
[API6:2019 - Mass Assignment](https://owasp.org/API-Security/editions/2019/en/0xa6-mass-assignment/) in the 2019 OWASP API Security Top Ten).

A better option (in my opinion) is to limit the properties the client is
allowed to send, employing a more restrictive update schema: one which
does not include any readOnly properties. Throw in
[`unevaluatedProperties: false`]({{'/2023/07/11/master-json-schemas-subtleties'|relative_url}})
while you're at it.

For a Universe instance, we only wish to allow updating the `name` and
`description` properties.

We can use a JSON schema with only those two mutable properties. Using
some of the techniques for schema composition presented in
[Composing API Models with JSON Schema]({{'/2023/06/05/composing-api-models-with-json-schema'|relative_url}}), we can define those two properties in one
`mutableUniverseFields` schema, then reuse those properties to refactor
the `universe` schema presented earlier and our new `universePatch` schema
for the `patchUniverse` operation.

```yaml
components:
  schemas:
    mutableUniverseFields:
      title: Mutable Universe Fields
      description: Mutable properties of a Chain Link universe instance.
      properties:
        name:
          description: The name of the universe.
          minLength: 4
          maxLength: 64
        description:
          description: The description of the universe.
          minLength: 4
          maxLength: 512

    universe:
      title: Universe
      description: >-
        A universe in which authors can
        create new characters and new chains.
      type: object
      required:
        - id
        - name
        - description
        - createdAt
        - creator_url
        - characters_url
        - chains_url
      unevaluatedProperties: false
      allOf:
        - $ref: '#/components/schemas/mutableUniverseFields'
        - type: object
          properties:
            id:
              $ref: 'common.yaml#/components/schemas/resourceId'
            sourceUniverse_url:
              description: >-
                An optional universe that this one is derived from.
              type: string
              format: uri_reference
            createdAt:
              description: >-
                The date and time the author created universe,
                in RFC 3339 date-time format.
              type: string
              format: date-time
            creator_url:
              description: The URL of this universe's creator/author.
              type: string
              format: uri-reference
            characters_url:
              description: >-
                The URL of the API operation to list
                 the characters that exist in this universe.
              type: string
              format: uri-reference
            chains_url:
              description: >-
                The URL of the API operation to list
                the chains that exist in this universe.
              type: string
              format: uri-reference

    universePatch:
      title: Universe Patch
      description: >-
        Request body for updating the mutable properties of
        a Chain Link universe instance.
      type: object
      unevaluatedProperties: false
      allOf:
        - $ref: '#/components/schemas/mutableUniverseFields'
```

Note that `type` constraints in the `name` and `description` properties
do not include JSON Schema's `null` type (as described in
[Master More JSON Schema's Subtleties]({{'/2023/07/11/master-json-schemas-subtleties'|relative_url}})) because this API does not support removing (unsetting) a universe's `name` or `description`. Even though JSON Merge Patch allows using a `null` to remove a property from a target resource, the JSON Schema `type` constraints on these properties of a Universe prohibits that.

Below are four valid examples for the `universePatch` schema: an empty request, updating just the name, updating just the description, or updating both:

```json
{ }

{ "name": "DragonTerr" }

{ "description": "A world where dragons rule." }

{
  "name": "Dragon-Terr",
  "description": "A world where dragons rule."
}
```

## Avoiding API Abuse

Earlier I mentioned some perils of using the CRUDL pattern for APIs.

As described at the beginning of this series, the best APIs arise when they closely map to and implement behaviors that the clients need, rather that be derived from or reveal back-end implementation details (such as SQL and database schemas). A CRUDL API is an closer to the latter. The most severe CRUDL peril lies in casting all client behaviors in the CRUDL mold.

For example, an API for a vehicle may include the vehicle's speed in the Read response. If thinking only in terms of CRUDL, one may treat the speed property as mutable within a general vehicle update operation, passing it among other mutable properties as one way to stop a moving vehicle:

```yaml
PUT /vehicles/{vehicleId}
{ ..., "speed": 0, ... }
```

This is a somewhat circuitous way to "stop" the vehicle, analogous to
manually moving an mechanical speedometer to 0 to stop the car rather
than using the brake. Manu vehicles let on adjust the spee cruise
control by incrementing or decrementing the speed in units.
Stopping a car traveling 30 MPH would require 30 button pushes&dash;
not a great user interface, and ptentially disasterous in a
vehicle emergency.

![Image of a human hand forcing a speedometer dial to 0]({{ '/assets/img/Speedometer.png' | relative_url}})
<br>
Photo credit [Brian Snelson](https://www.flickr.com/people/32659528@N00)
from Hockley, Essex, England -
[Speedometer](https://www.flickr.com/photos/32659528@N00/408255529/),
[CC BY 2.0](https://creativecommons.org/licenses/by/2.0/)

API operations should be atomic: do one thing and do that one thing well. If operations have multiple unrelated behaviors attached to them, the API becomes very complex and hard to reason about for both consumers and implementors.
Such undue complexity increases by an order of magnitude if the resource's Read representation contains nested objects. Mixing updates of the resource along with updates to nested objects leads to a confusing API, and one that is hard to evolve as new properties are added over time (which will almost always happen).

Instead, consider using `POST` operations to issue _commands_ or to apply
actions to resources to implement independent behaviors in the
application's domain. For example, one can define a `publishChain`
operation that applies to a Chain instance to publish them

```text
POST /chains/{chainId}/published
```

The `publishChain` operation can implement all the behaviors necessary to
publish the Chain, the smallest of which is updating the `chain.published`
status to `true` (which is then available in the `publishChain` operation
response, which is symmetric with the Read response.)

Such designs make the API's intent clearer&mdash;there is a specific
operation dedicated to each behavior in the domain, rather than blending
many behaviors into a single "do everything" operation that gets more
complex and more fragile as the API evolves. Especially when one
considers a Software Development Kit that you may generate from the
OpenAPI definition, the benefits of such intention-revealing operations
become even clearer. For example, there will be a `publishChain()`
function in the SDK. As a result, both the SDK and the API become
more self-descriptive.

Today's lesson ends with this warning against an creating an API that is
(to paraphrase the words of Brian Foote and Joseph Yoder in
[Big Ball of Mud](http://www.laputan.org/mud/)) "dictated more by
expediency than design". CRUDL may seem like an easy pattern, but tread
lightly when tempted to (over) use it.

<hr>

{% include discuss.md %}

{% include orig.md %}
