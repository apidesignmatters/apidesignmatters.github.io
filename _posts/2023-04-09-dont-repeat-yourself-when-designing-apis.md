---
title: Don't Repeat Yourself When Designing APIs
date: 2023-04-09 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> Techniques for keeping your OpenAPI definitions DRY

Your journey of implementing API ideas with OpenAPI designs has reached
a critical mass. In previous articles, you've seen
[how to model responses]({{'/2023/03/16/what-am-i-getting-out-of-this.html' | relative_url}}) for `GET` operations as well as [describing problem and error responses]({{'/2023/03/26/your-api-has-problems.-deal-with-it'|relative_url}}). In both cases, we include the JSON Schema to describe the results directly in the operation's [`responses` object](https://spec.openapis.org/oas/latest.html#responses-object). However, this is not scalable, as it would require copious copying and pasting, which in turn leads to fragile code and increased likelihood of bugs. This article will show you the path of API Design enlightenment via OpenAPI's support for the [Don't Repeat Yourself Principle](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), otherwise known as the DRY principle<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>.
{% include language-of-api-design-series.md %}

![alt text]({{ '/assets/img/dont-repeat-yourself-wide.png' | relative_url}})

## The Horrible Experience

First, let's look at the wrong approach. Consider defining multiple problem responses in just one operation, to cover [`400`](https://davidbiesack.github.io/http-status-codes/400) (Bad Request) and [`422`](https://davidbiesack.github.io/http-status-codes/422) (Unprocessable Entity) HTTP status codes. If each response repeated the JSON schema for the application/problem+json response, the API definition becomes quite verbose quite quickly, almost 150 lines of YAML source for just those three responses for one operation.

See my [`multiple-400-level-application-problem+json-response.yaml`](https://gist.github.com/DavidBiesack/5319932920759b07c65e72eb635c0125) gist&mdash;I hope you see the "bad code smell" in that solution. Repeat that for every operation in an API and the result is a horrible developer experience. (This pattern is also known as _Write Everything Twice_ or _WET_.)

Here are just a few immediately obvious problems of this WET method:

Once a construct is copied, changing that construct requires updating duplicate code in numerous places.

A natural consequence of updating multiple sections of code is that developers may accidentally skip some copies, resulting in defects.

Similarly, if the original code had defects, copy and paste also duplicates those defects.

Fortunately, there is a better way!

## The (Not Horrible) Better Experience

OpenAPI provides two general mechanisms to avoid the need for such verbosity and duplication of code.

The [`components` object](https://spec.openapis.org/oas/latest.html#components-object) provides a place to define reusable API design elements, such as schemas, parameters, and response objects. Instead of inlining a schema or response object or other element, you can reference a component that is defined within the components object.

You can split the API definition into multiple source documents. Components that are used across multiple APIs can be moved into the components of a common or shared OpenAPI document.

With regard to problem responses, OpenAPI also provides a way to define one response object for all 4XX level (or all 5XX level) responses for an operation that are not already explicitly defined.

Refactoring an OpenAPI Document to Use components
Let's refactor our API document to use OpenAPI components correctly. We will do this in stages instead of one huge rewrite, since incremental refactorings are easier to verify. (Unfortunately, I don't know of IDE tools which support such OpenAPI refactorings. This is a great opportunity for a clever toolsmith...)

First, let's extract the JSON schemas definition for our RFC 7807 application/problem+json responses. To do this, we need a name for the schema so we can reference the schema by name where needed. [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457) does not specify a standard name, so we'll pick something that is descriptive: `apiProblem`.

OpenAPI's `components` object defines a place to put all reusable schemas: inside the nested schemas object. (The `components` object sits at the top level of the OpenAPI document, as a sibling of the info and paths and other top-level objects.) The name of the items in the `/components/schemas` object is the name of the schema:

```yaml
components:
  schemas:
    apiProblem:
      title: API Problem
      description: >-
        API problem response, as per
        [RFC 7807](https://tools.ietf.org/html/rfc7807).
      type: object
      properties:
        ... properties as listed above
```

Next, we'll reference that schema by name instead of making in-line copies. To reference a reusable component, OpenAPI uses a [reference object](https://spec.openapis.org/oas/latest.html#reference-object) with `$ref` as the key and a value that is a URI of the referenced element's location in the document. Prior to OpenAPI 3.1, this was a (restrictive) [JSON Reference](https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-03) object, but for 3.1, the specification loosened this to allow these reference objects to also include `description` and/or `summary` values. We'll see how that benefits us below.

For example, the reference to our `apiProblem` schema is

```yaml
$ref: '#/components/schemas/apiProblem'
```

(The path must be quoted in the YAML format because the `#` character is
interpreted as a comment character when not in a quoted string.)

This path is a fragment portion of a relative URI. The # marks the beginning of the fragment, and the rest are path elements: the components object, its nested schemas object, and the schema named apiProblem. In general, the fragment is interpreted as an [RFC 6901 JSON-Pointer](https://www.rfc-editor.org/rfc/rfc6901).

If the `$ref` location starts with `"#"`, the referenced component is resolved from the same source document. The `$ref` may also start with a document URI or a (relative) file references, such as

```yaml
$ref: '../common/openapi.yaml#/components/schemas/apiProblem'
```

to reference API elements from a library of reusable components in another file.

This leaves us with the following somewhat shorter definition of the `400` and `422` responses for the `getChainLinks` operation:

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
                $ref: '#/components/schemas/apiProblem'
        '422':
          description: Unprocessable Entity.
          content:
            application/problem+json:
              schema:
                $ref: '#/components/schemas/apiProblem'
```

Note that this more concise code is much easier to understand because all the repetitive schema definitions are referenced rather than copied. But we can do even better!

To allow multiple operations ( `listChainLinks` as shown above, but also
`listAuthors`, `listChains`, `listUniverses`, `listCharacters`, etc.) to
share the same problem responses, you can put reusable
[response objects](https://spec.openapis.org/oas/latest.html#response-object)
in the `#/components/responses`
object and reference them. For example:

```yaml
components:
  responses:
    '400':
      description: Bad Request.
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/apiProblem'
    '422':
      description: Unprocessable Entity.
      content:
        application/problem+json:
          schema:
            $ref: '#/components/schemas/apiProblem'
```

Now our operation can reference those common response objects and be even more concise (and more consistent):

```yaml
paths:
  /chainLinks:
    get:
      responses:
        '200': ... as seen above ...
        '400':
          $ref: '#/components/responses/400'
        '422':
          $ref: '#/components/responses/422'

  /characters:
    get:
      responses:
        '200': ... as seen above ...
        '400':
          $ref: '#/components/responses/400'
        '422':
          $ref: '#/components/responses/422'
  # ... and so on for other operations
```

## Default/Wildcard Response Objects

You can explicitly list different responses, as shown above. OpenAPI provides an additional shortcut for defining responses. A "wildcard" 4XX response defines a default response format for all 4xx-level response codes not explicitly listed in an operation's responses object:

```yaml
paths:
  /chainLinks:
    get:
      responses:
        '200': ... as seen above ...
        '400':
          description: Bad Request. Invalid query parameters for the
            listChainLinks operation.
          $ref: '#/components/responses/400'
        '422':
          description: Unprocessable Entity. The listChainLinks request
            was syntactically correct but could not be processed due to
            unsupported combinations or values.
          $ref: '#/components/responses/422'
        '4XX':
          $ref: '#/components/responses/4XX'
```

Rather than use the 4XX wildcard character to define all client request problems, I recommend using response objects, with a `description`, for the most common problems a developer may face. This allows better API documentation and defines some expectations for how the client should handle the most common API problems.

OpenAPI also lets you define a default response object for 5xx-level HTTP response codes that are not explicitly defined:

```yaml
        ...
        '5XX':
          description: Server error.
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/apiProblem'
```
## Reusable response body schemas

As I discussed in [What Am I Getting Out of This?]({{'/2023/03/16/what-am-i-getting-out-of-this.html' | relative_url}}), the `listChainLinks` operation returns a JSON object containing a page of chain link items. The initial implementation put that schema directly in the operation's responses object. However, it is helpful to lift such response schemas into the `schemas` component and reference them:

1. You are more likely to reuse that schema elsewhere in the API.
1. Providing a named schema helps when generating Software Development Kits
(SDK) for your API consumers to use with your API. SDK generators <a
id='footnote-2-ref'/><a href='#footnote-2'><sup>2</sup></a> can use the
schema names as the names for programming language constructs such as
types, classes or interfaces. If you use "anonymous" (unnamed) schemas,
the generated symbols are fabricated, gangly, and harder to use. Named
schemas provide a direct association between the OpenAPI document and
the SDK, resulting in a better Developer Experience.

## Observations

Much literature exists on the benefits of the DRY principle. Here are my primary reasons to apply DRY (modularization and componetization) to API design with OpenAPI:

* DRY API designs lead to better API design consistency.
* DRY API definitions are more concise and therefore easier to construct, easier to read and understand, easier to review (as part of an API governance program), and easier to maintain.
* Named reusable schemas lead to well-named SDK constructs like types, classes, and interfaces.
* Less copy and paste results in fewer defects.
* By making reuse of API elements convenient for the API designer, the structure of the OpenAPI Specification actively encourages good API design. That is, your are more likely to reuse components simply because it is easy to do so. It's one of those virtuous cycle things. That is, via the use of component references, you can establish rich and powerful patterns of API design.
* Additionally, by removing API element duplication, you eliminate the need to read between the lines or wonder "Is this instance of the response schema different from that one, and if so, how do they differ and why do they differ?" (Can you tell if or how the 400 response differs from the 422 response in this example?) Remember, you are not the only one who will be reading the OpenAPI documents. Future maintainers will as well.
* To me, the most important benefit of moving key API elements (schemas, responses, parameters, etc.) into components is that the intent and design structure of the API becomes much more evident&mdash;it is not buried in all the syntax chrome that is otherwise required to define all those elements without components.

> The structure of the OpenAPI Specification actively encourages good API design

The remainder of _The Language of API Design_ will employ the
`components` objects for these reasons. So stick around, we'll be right
back.

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
Otherwise known as the DRY principle

<a id='footnote-2'/><a href='#footnote-2-ref'><sup>2</sup></a>
SwaggerHub, openapi-generator, APIMatic, Speakeasy and others

{% include discuss.md %}

{% include orig.md %}
