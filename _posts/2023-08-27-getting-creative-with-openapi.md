---
title: Getting Creative with OpenAPI
date: 2023-08-27 18:00:00 -0000
layout: post
tag: the-language-of-api-deign
---

> Defining resource creation and update operations with OpenAPI

Developers like to consider themselves as creators&mdash;we create code, we create ideas, we create experiences. In the realm of APIs, we create interfaces so others can use our software. An important aspect of most APIs is their ability to create things as well. In the past1, we started at the end of the "CRUDL" initialism and discussed basic List operations in APIs. Next, we jump to the beginning of that "CRUDL" initialism and talk about the Create operations. Along the way, we'll apply many of the skills we've covered in the previous dozen or so articles of the Language of API Design.

![banner graphic text reading "Getting Creative with OpenAPI" | The Language of APIs | API Design Matters | David Biesack ]({{ '/assets/img/Getting-Creative-with-OpenAPI.png | relative_url}})

{% include language-of-api-design-series.md %}

Let's get creative! Consider yourself a user&mdash;an author or content
creator&mdash;of the Chain Links app. You want to create a new story. What's
more, you are really ambitious and you want to create an entirely new
universe for that story. Good for you! Taking the role of creator to its
limit!

To enable your creative juices, the Chain Link API needs an API operation to create a new Universe.

From our previous work, we already saw the skeleton for the API
operations of Chain Link universes:

```yaml
paths:
  /universes:
    get:
      operationId: listUniverses
      summary: List the universes
      description:
        Return a paginated list of the universes in the system.
  /universes/{universeId}:
    ...
```

Within this structure which defines the paths for the universes
collection (/universes) and universe instances
(/universes/{universeId}), we can fit the basic Create, Read, Update,
Delete, List (CRUDL) operations. This is done by following a common API
design pattern:

* Create
  * `POST /universes`
  * `operationId: createUniverse`
* Read
  * `GET /universes/{universeId}`
  * `operationId: getUniverse`
* Update
  * `PUT /universes/{universeId}`
  * `operationId: updateUniverse`
  * `PATCH /universes/{universeId}`
  * `operationId: patchUniverse`
* Delete
  * `DELETE /universes/{universeId}`
    Careful&mdash;that's a lot of power!
  * `operationId: deleteUniverse`
* List
  * `GET /universes`
  * `operationId: listUniverses`

<hr>

{% include discuss.md %}

{% include orig.md %}
