---
title: Wherefore HATEOAS
date: 2025-01-23 18:00:00 -0000
layout: post
---

> Hypermedia as the Engine of Application State

It's finally time for _API Design Matters_ to tackle one of the more
complex API design patterns/practices: Hypermedia, or more aptly named,
_Hypermedia As The Engine Of Application State_ (HATEOAS).

(Please note that what follows are _my personal observations and
perspectives_ on Hypermedia APIs. I encourage _API Design Matters_ readers
to explore other voices.)

![alt text]({{ '/assets/img/Wherefore-HATEOAS.png' | relative_url}})

[Roy Fielding defined the REST API architectural style](https://ics.uci.edu/~fielding/pubs/dissertation/top.htm)
and
[has stated](https://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven)
that an API is not a REST API if it is not hypermedia driven. So what does this mean?

( REST? RESTful? REST-like? REST-ish? See [We Talk "API" One Day]({{'/2023/12/26/we-talk-api-one-day'|relative_url}}) )

At the structural level, a Hypermedia API is one in which the
capabilities of the API&mdash;or more accurately, the capabilities of
the application that the API enables&mdash;are conveyed in the API's
responses, typically through hypermedia _links_ embedded in the data.
Much as a web page is more useful because it contains links to other
related web pages, an API response (that is, a representation of one of
the API's resources) is enriched when it includes links to resources or
API actions related to that resource.

Hypermedia APIs allows both discoverability of the features of the
API/application as well as looser coupling between the client
application and the API services&mdash;both admirable goals. As a pattern,
Hypermedia is fine solution to the design force of decoupling a web
application front end from the back end that manages it. Key to this is
allowing business rules to be managed on the back end rather than
replicated in the front end. For example, by including or excluding
certain links in responses from the back end, the application can
control what the end user can do. More importantly, it allows the
application to evolve by adding new features, expressed through
hypermedia, without having to re-write or update the client.

However, just as there is no standard definition of a REST API, there is
no definitive standard for how such hypermedia links are conveyed.
Instead, there are myriad competing standards and formats, such as

* [Hypertext Application Language](https://datatracker.ietf.org/doc/html/draft-kelly-json-hal-00) (HAL)
* [Siren](https://github.com/kevinswiber/siren)
* [Restful JSON](https://restfuljson.org/)
* [Collection+JSON](https://mamund.com/media-types/collection/format/)
* [JSON-LD](https://www.w3.org/TR/json-ld11/)
* [JSON:API](https://jsonapi.org/)
* [Hydra](https://www.hydra-cg.com/spec/latest/core/)
* &hellip; and others.

I won't dive into the details of all of these (that would be a couple
chapters worth of book material, and not too helpful right now).
Instead, I want to discuss the pros and cons of embedding Hypermedia in
a web API.

One of the primary goals of encapsulating a back end service or process
with an API is to add a level of abstraction. The API is the embodiment
of an abstraction at a point in time. However, services evolve over
time - they may add more capabilities or features. This is typically
exposed with new versions of an API, or even entirely new APIs if the
new behavior does not fit well in the existing API.

However, another way to deliver new functionality within an API is more
dynamically, by returning new links in the payload of the existing API.

For example, in the
[Chain Links sample API]({{'/2023/03/07/chain-links-domain-model'|relative_url}})
I have provided in this series, the `listUniverses` operation returns a
representation of a list of `universes` (i.e. an array of `universeItem`
objects, each of which has the unique `id` of a universe.) The `getUniverse`
API operation accepts a `universeId` path parameter and fetches the
representation of that universe. This requires the client (or a Software
Development Kit or SDK library) to construct URLs to use the API - i.e.
the `getUniverse(universeId: string)` operation will substitute the
`universeId` into into the API path `/universes/{universeId}` and prepend
the API server base URL from the OpenAPI `servers` object in order to
invoke the `getUniverse` operation, then parse the JSON response and bind
it to a `universe` data structure in the target language. In a hypermedia
API, the URL of each item would be included in the list of universe
items in the `listUniverses`'s `universes` response, so that the client is
more loosely coupled to the API. This allow the API service to evolve
over time, such as providing a more efficient URL for fetching
resources. Such changes are not possible if the client has a tight
coupling to (a specific version of) the API.

The other challenge with hypermedia links is conveying the semantics. At
the base level, a link is just that - a URL. But in an HTTP API, a URL
is only part of the operation: there is also the HTTP verb, the
authorization, the request and response bodies, HTTP request and
response headers, and if the client is going to present the link or
action in the client application (such as a button or menu item or
link), it requires a title or label or descriptive text. Unadorned
Hypermedia links may work well with `GET` operations, but less so with
`POST` operations.

A key element of that unwieldy name "HATEOAS"
(__H__ypermedia __A__s __T__he __E__ngine __O__f __A__pplication
__S__tate)
is _**Application**_. Hypermedia APIs work well when
they are part of a web application. Applications have state; they
combine user input and back end processing, and the API encapsulates
that application's behavior and capabilities. In such cases, these
HATEOAS APIs can contain links that expose or enable the next possible
steps in the application, based on the current state of the application
and what the authenticated user can do, given that application state and
what roles and permissions that user has. For example, from a list of
application domain objects, there may be an "edit" link which allows the
user to edit that object. Lack of such a link means that the current
user, given the current application state, cannot edit the object. The
appeal of this decoupling is obvious - the client application does not
(and rightfully should not) contain such business rules, as these are
subject to change (perhaps at a cadence more frequent than API version
releases).

Supporting a Hypermedia API is of course most useful if the client
application is written in such a way that it can do something with those
dynamic links. This is no easy task&hellip; most application developers don't
want to deal with that kind of complexity.

However, we are all familiar with one type of such dynamic application -
your favorite web browser. This ability to handle arbitrary links and
dynamic content is what allows the browser to host myriad client
applications, such as Gmail, Substack, LinkedIn, and so on&hellip; without
having any prior knowledge of those applications.

However, when an API is the front end of a very general and reusable web
service with a well defined functional boundary (such as sending Email
or SMS messages or making a credit card payment for an purchase), there
is not a single application that the API is attached to - it must work
with arbitrary applications. Such atomic and composable service APIs may
be stateless, and since they are not part of any one specific
application, they have less application state to convey, and hence
HATEOAS links are less impactful for conveying application state.
Related resource links are still useful, such as a link from a Chain
Link Character to the Universe in which that character lives.

I suggest reading Bruno Pedro's article,
[Why Aren't APIs Using Code on Demand?](https://apichangelog.substack.com/p/why-arent-apis-using-code-on-demand)
in [The API Changelog](https://apichangelog.substack.com/). Bruno's
article discusses one of the (optional) constraints of the REST
architecture style, namely _Code-on-Demand_. It is what makes an API
driven application (such as a single page application) powerful and
reactive, compared to older web application architectures which are
built around server-generated web pages. Code-on-Demand works for web
applications because such applications run within an application host (a
browser) which can execute that code.

Code-on-Demand is also necessary to fully interpret the links in a
Hypermedia API. For example, consider a resource in our Chain Links
application, a Universe. How does one add a new universe? Certainly the
API answer is trivial - by using the POST operation on the /universes
collection, passing a request body that satisfies the newUniverse
schema. In a hypermedia API, the universes collection resource may have
a hypermedia link with a link relation called createUniverse, but if a
client application does not know about this resource or which request
body schema is needed to create a universe, it can't use that
link&hellip; just as a client coded to version 2.1 of an API has no
knowledge of a resource introduced in version 3.0 of the API.

However, Code-on-Demand will allow the application to fetch the code to
do new things, such as create a universe, edit a universe, update a
universe. Creating can be done via a link to a web page or form or
applet which prompts the user to fill in and submit the data necessary
to complete the request. That is, the link to create a new universe is
may be a link to a web page &mdash; part of the broader application that the
API encapsulates. It may contain UI form controls and JavaScript to
handle the dynamic aspects, and perhaps optional controls based on the
current application state, such as where to go next after completing the
current task, or where to return to if the user decides to cancel. In
such a way, the client is adaptable and not tied to a specific version
of the API - the application, the API, and the client can evolve
together.

The downside is that, as it's name implies, Code-on-Demand requires
passing executable code from the back end to the front end. If the
client is a browser, it can dynamically load JavaScript as part of
rendering a web page. Other clients may not have this dynamic
capability. If the client is a secure back office headless application
written in some other language such as Go, it can't use such
Code-on-Demand without adding a lot of complex client code execution
features. (Of course, security must also be considered any time an
application introduces a new code execution feature.) Also, I am not
aware of APIs which support languages other that JavaScript, though
using [WebAssembly](https://webassembly.org/)
(see [Why Aren't APIs Using Code on Demand?](https://apichangelog.substack.com/p/why-arent-apis-using-code-on-demand) ) may be
the technology bridge.

Developing clients to consume and fully exploit Hypermedia APIs requires
not just handling Code-on-Demand; it requires a different mindset. That
is, one must consider the API to be a dynamic entity, not a static one,
with new features possible every time an API call is made. This is a
difficult thing to implement well or correctly, especially when many
applications are often written to do very specific things.

For example, the AI summary on the
[Gmail API page](https://developers.google.com/workspace/gmail/api/guides)
states (as of Jan 19, 2025):

> The API is not intended as a full email client replacement but is
> ideal for web applications needing authorized access to user data.

Most developers prefer using some sort of language Software Development
Kit when coding to an API. However, these SDKs are often tied to a
specific version of an API, with a specific URL layout and fixed set of
operations and parameters&mdash;this goes very much against the grain of
Hypermedia APIs which are meant to be dynamic and flexible, not strictly
rigid structures with statically defined URLs and statically defined
request and response body schemas. Such SDKs (often generated from an
OpenAPI definition) typically use rigid interface constructs, such as
representing path parameters (which the SDK will inject to API resource
URLs) as function parameters, with one function per API operation. But a
Hypermedia application is more dynamic - the URLs are all provided by
the API, so the client should never construct a URL. (For example, the
getUniverse function in an SDK for a static API may accept the
universeId parameter; for a Hypermedia based API, the getUniverse
function in an SDK may accept the universe's URL as a parameter instead
(where that URL is obtained in a link within another API response.)

Let's revisit an application like Gmail. How would you design this
application to automatically support dynamic features that were not in
your requirements when you first started?

For example, Gmail allows adding attachments to a mail message; that is
part of the mime message format. The user can select a file from their
local file system and the client encodes that in the email message body.
However, if the file is too large, Gmail now has the ability to upload
the file to Google Drive (and set the permissions on that file so the
recipient can access it) and instead of adding an attachment, Gmail will
insert a hyperlink to that file on Google Drive. Imagine trying to
design the client app to allow executing this type of dynamic behavior -
it is not trivial. But with Code-on-Demand, it is possible.

Yes, hypermedia APIs are a useful replacement for server generated web
page architecture, and decoupling a (browser) web application from back
end logic and business rules. HATEOAS seems a better fit when there is a
(server managed) web application, but harder to exploit when the API is
a general purpose component meant to be embedded in arbitrary
applications that the service knows nothing about.

<hr>

{% include discuss.md %}

{% include orig.md %}
