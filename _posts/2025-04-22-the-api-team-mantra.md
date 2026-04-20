---
title: The API Team Mantra
date: 2025-04-22 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> 200 is Not OK

In April 2025, I
[posted on LinkedIn](https://www.linkedin.com/posts/davidbiesack_the-mantra-of-a-good-api-program-manager-activity-7315537628420845569-t49X?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAfzL5sBDSFE339Qa5vhQeVWS39Vc_HFFkU):

> The mantra of a good API Program Manager/Product Manager/Developer Advocate:
>
> APIs should help you solve your problems. APIs should not be your problem.
>
> &mdash; David Biesack

Today, I want to break this down and discuss _API Success_.

![alt text]({{ '/assets/img/API-team-mantra.png' | relative_url}})

{% include language-of-api-design-series.md %}

As I've stated multiple times in podcasts where I've been a guest, the most important
measure for API success is if it is solves real problems &mdash; if developers can use your API
to build their applications. This means the API must be fit for purpose. I won't be
successful sending a text message to someone if I try to use the Amazon Web Services S3
cloud storage API, and I will find the Tenth Level of Hell if I try to upload a PDF of a
Platinum Checking Account Terms and Conditions document, March 2025 revision, using the
Twillio API.

Of course, to obtain this highest level of success, someone has to be able to find (i.e.
discover) your API. This normally means being able to find it in an API registry (alas,
[ProgrammableWeb.com is no more](https://apievangelist.com/2022/10/15/programmableweb-is-shutting-down/)),
or find it through a search service (Google, Bing, Ask Jeeves!, pick your poison), as long
as the API is on a web site that can be indexed by search services. (Pro tip - don't put
your API documentation behind a paywall or require registering and logging in to see the
API documentation.) You may even try the AI chatbot of your choice to find the API that
solves your problem, but for that to work, the AI engine needs to be able to see the API
doc too&hellip; that's not likely if the API doc is not easily available.

Either way, success in finding the right API requires that 1) the API be discoverable, and
that 2) the API documentation clearly describes what the API does using the terms the
potential consumer understands. I've seen way too many APIs described with woefully
inadequate documentation. This often stems from technical people documenting the API "from
the inside out" - i.e. describing how the system behind the API was designed (at one point
in time&hellip;), or using internal code names or marketing terms, rather than documenting the
API from the perspective of a consumer who, at least initially, knows next to nothing
about your API.

This problem often extends deeply into the API documentation. There are few things worse
than wasting bits and bytes (and your readers' time) by providing a circular description
of a field or operation that has an obscure or non-obvious purpose, described with
undefined, obsolete, or misleading terms that raise more questions than answers:

```yaml
  paths:
    /lincoln/v14/indications/:
      post:
         summary:
           Create a new laminar indication in the layers V12 API.
```

Don't. Do. This.

(Yes, this is an excerpt from a vendor's production API.)

A successful API clearly articulates its purpose, and the API design and documentation is
built upon a foundation of a good conceptual model of the API's domain. Such APIs arise
when the team applies an API design process [ADDR recommended] rather than simply
generating an API from a (soon to be obsolete) database schema or other structure which
has been optimized for completely different use case than a clean API. (For my thoughts on
using Generative AI to design APIs, see my
[The Art of API Design]({{'/2024/04/11/the-art-of-api-design'|relative_url}}) talk at
Nordic APIs Austin API Summit, 2024)

A successful API designed via a solid process is more likely to provide the needed
services.

Other problems you may encounter which inhibit API success are listed below. (Fret not,
I've included lots of guidance on how to avoid the problems.)

1. An API that uses proprietary authorization. I led a _Birds of a Feather_ session at an API
conference a few years ago, and the largest hurdle that most of the participants expressed was
getting API authentication/authorization right. It's not too hard to use OpenIDConnect /
OAuth2 correctly, especially if you use a good library that implements the protocol, but
if an API has proprietary auth, then auth becomes a problem for your API users, an thus,
your API becomes a problem for them.
1. An API that shuns HTTP standards.
  1. The most common "hall of shame" for APIs (as I shared in [My Favorite API Memes]({{'/2023/03/25/my-favorite-api-memes'|relative_url}})
) is not using correct 4XX and 5XX HTTP response codes and their semantics, but instead returning a 200 OK HTTP response code with `{ "error": true, ... }` or `{ "success": false, ... }`
  1. A related problem is not using the correct 2xx response codes. If your POST creates a new resource, return 201, not 204. If your operation only has side effects but does not return any data, use a 204, not a 200.
  1. Other examples are violating the uniform interface constraint of RESTful APIs - i.e. misusing the HTTP methods `GET`, `PUT`, `POST`, `PATCH`, `DELETE`; or a `GET` operation not being idempotent and safe (I once saw an API which used a `GET` operation to shut down a server! **Do. Not. Do. This.** _Run, don't walk, away from such APIs.`) There was a lot of thought put into the design of the HTTP protocol, and the protocol ecosystem (libraries, proxies, gateways, and other intermediaries, etc), works well only if the protocol is followed. Ignorance or hubris says "I know better&hellip;.".
  1. Not using the standard HTTP headers can be a problem. When a POST operation creates a new resource, return the new resource's URL in the standard Location [response header](https://www.rfc-editor.org/rfc/rfc9110.html#section-10.2.2). If a resource is not ready, the GET operation should return the standard [HTTP Retry-After response header](https://www.rfc-editor.org/rfc/rfc9110.html#name-retry-after).
  1. Always use date-time values in [RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339) `date-time` format in UTC ("Zulu") time done. Let clients map these to the user's time zone or date/time format. The [5 laws of API dates and times](https://apiux.com/2013/03/20/5-laws-api-dates-and-times/) by [Jason Harmon](https://www.linkedin.com/in/jasonhnaustin/) is an oldie but a goodie&hellip;
1. An API that tries to avoid or minimize good use of JSON Schema is a problem. If you are defining an API, you owe it to your consumers to use JSON Schema well. This includes well-named schemas and properties, but also appropriate use of JSON Schema constraints and annotations as declarations of what data is valid in a request, and what data to expect in responses.
  The simplest example of such a problem is using strings with `"Y"` or `"N"` (or other string values) instead of boolean values, but it also includes exposing data taken directly from packed/encoded raw database fields, such as CHAR(1) codes or integer codes instead of self-describing enum values (See [Amundsen's Maxim](https://www.amundsens-maxim.com/)). Here are a couple examples from a real-world API: ![API documentation showing a property named `business` which is defined with enumerated values `"Y"` and `"N"` instead of using JSON Boolean types]({{ '/assets/img/wrong-use-of-boolean-values.png' | relative_url}})
  <br>
  ![API documentation showing a `code` property with a single character codes rather than mnemonic enumeration strings]({{ '/assets/img/non-mnemonic-codes-in-api-design.png' | relative_url}})
1. I don't know about you, but I have no way to know how to use those single character
   code in the matches property&hellip; and the `pattern: \w{1}` constraint is certainly
   more obtuse than `minLength: 1, maxLength: 1`. _A good API team will anticipate and answer the questions developers will have about your API._ This is another reason to use the [ADDR Process](https://addrprocess.com/) &mdash; and _not skip the Refine phase_, where you improve the API after feedback from real users.
  > Don't be afraid to refine and revise your API - instead, plan for it!
  >
  > &mdash; David Biesack
1. Any design aspect which violates basic and widely adopted conventions or developer expectations for how APIs work is a problem. Just as a good User Experience (UX) should be intentionally designed, a good Developer Experience (DX) should be intentionally designed,, with the goal of enabling the desired feature as intuitively as possible, without surprises.
1. An incomplete API is one example of violating these expectations. Normally, if your API supports creating a resource, it should also provide a way to update/patch that resource, fetch the most recent representation of that resource, and ultimately delete it. Omitting one or more leads to a frustratingly incomplete API that violates basic expectations.
1. Inconsistency can be is another caustic API problem. A consistent API design is easier to
learn and use because it adheres to those expectations; an inconsistent design adds
frustration. (Recommended:
[The 5 dimensions of API consistency](https://blog.postman.com/the-5-dimensions-of-api-consistency/)
by Arnaud Lauret)
1. An API that is not designed for evolution will not evolve gracefully when it needs to
   change&hellip; that's a problem. An no, changing the API URL from `/v1/...` to `/v2/...` is
   not graceful API evolution.
1. An API that is not designed with error handling from the start will have problems when
   consumers start using the API &mdash; developers make mistakes; apps have bugs, and not every
   request is perfect. Oh, and hackers or bad actors will use invalid requests to launch
   Denial of Service Attacks or worse. (Pro Tip: use [`application/problem+json`]({{'/2023/03/26/your-api-has-problems.-deal-with-it'|relative_url}})
 to describe the problems you detect)
1. A poor or fragmentary Developer Experience can add to the growing list of API problems:

   1. Onerous registration process
   1. Unclear license and terms of use
   1. Unclear or unpredictable rate plans
   1. Hard to navigate documentation; documentation that one can't bookmark or reference or search&hellip; Oh, the plethora of potential API documentation problems!
   1. No easily downloaded OpenAPI documents, or OpenAPI documents based on OpenAPI 2.0 instead of 3.x, or "Swagger" documents (Again, see [those favorite API memes]({{'/2023/03/25/my-favorite-api-memes'|relative_url}})
!)

API success is certainly more than a lack of problems. Identifying and removing problems
is a necessary but insufficient element of building a successful API or API program. "Zero
problems" is analogous to the definition of the HTTP 200 status code&hellip;. you go to all the
bother of assembling a API request, getting the authorization correct, pushing your API
call over the wire, capturing the response&hellip; and you end up with the less-than-satisfactory

    200 OK

It's almost a let down! "Meh, your API call was, well, just OK."

Instead, I prefer: "200 is Not (just) OK. It's Success! Hooray! Hooray!"

![banner graphic reading "200 is not OK" in graphic text]({{ '/assets/img/200-Is-Not-OK.png' | relative_url}})

By reducing the common problems and pitfalls when designing and delivering APIs, you can help your consumers insucceed&hellip; If you do it really well and focus not only on removing problems and roadblocks to success, but focus on enabling innovative solutions, you APIs may even be a joy to work with. You have my permission to be more than just OK; you may use "200 Success! Happy Happy Joy Joy!" in your API documentation.

![Blue block-lettered text on white background reading "200: Success! Happy Happy Joy Joy!]({{ '/assets/img/200-Success,-Happy-Happy-Joy-Joy.png' | relative_url}})

<hr>

{% include discuss.md %}

{% include orig.md %}
