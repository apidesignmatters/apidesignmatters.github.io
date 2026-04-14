---
title: Pet Store API - Just Say No!
date: 2024-04-01 18:00:00 -0000
layout: post
---

> Why I don't use Pet Store API in _API Design Matters_

When I launched API Design Matters, one of my reasons was the lack of good API examples out there. "Pet Store" got an early foothold and unfortunately has been pervasive when authors discuss OpenAPI and API Design.

I wrote in [The Language of API Design]({{'/2023/02/08/the-language-of-api-design'|relative_url}}):

> I'm probably not unique in that I severely dislike trivial examples.
> Instead of using something cliche and tired like Pet Store, this
> series will employ a single realistic but fictional scenario
> throughout, and explore many API design and DX matters of this
> scenario

and

> I want to completely divorce API Design Matters from the plague that
> is the "Pet Store" API. It is cliche, and it exhibits what I consider
> poor API design that should not be emulated

In other words: ___Pet Store: Just Say No!___

![alt text]({{ '/assets/img/Pet-Store---Just-Say-No.png' | relative_url}})

This sentiment is growing, and there are now two different proposals to supplant Pet Store as a "better" example of an API definition written in OpenAPI.

First, [bump.sh introduced the Train Travel API](https://bump.sh/blog/modern-openapi-petstore-replacemen):

> Everyone working with OpenAPI (formerly Swagger) will have come across
> the PetStore at some point. It's a sample OpenAPI description for an
> imaginary Pet Store with an API, but the OpenAPI is old, and the API
> it describes is pretty far from best practices. We thought it was time
> for a refresh, so we're bringing you the
> [Train Travel API](https://github.com/bump-sh-examples/train-travel-api),
> a new sample OpenAPI you can use for your tooling and testing.

and its source [README.md](https://github.com/bump-sh-examples/train-travel-api/blob/main/README.md) states:

> The world of OpenAPI has been plagued by "The Pet Store", an old API
> description used as a demo in every project ever. It describes a
> RPC-esque API that's mascerading as REST, and describes it poorly,
> using old OpenAPI 2.0 which has been upgraded to OpenAPI v3.0 without
> taking advantage of any of the new features.

(Interesting that the Train Travel API authors also used "plague" in the
> same sentence as "Pet Store" :-)

Not long after, the Redocly folks introduced another contender to knock
> Pet Store off the King of it's Mountain position; see
> [Meet the Museum OpenAPI](https://redocly.com/blog/museum-api-introduction/)
> description:

> The Museum API was created with OpenAPI learners in mind. The fun,
> light-hearted examples are designed to mirror real-world API use cases
> and challenges. For developers, writers, and anyone seeking to deepen
> their understanding of APIs, the Museum API serves as a useful
> resource for learning about OpenAPI and its role in delivering
> exceptional API experiences.

I welcome these contributions, an laud the authors for offering to share their knowledge in order to increase adoption of better/modern OpenAPI design practices! I am also glad both are offered as Open Source software, with public repositories on GitHub through which you can contribute and improve/evolve these API definitions.

* [https://github.com/bump-sh-examples/train-travel-api](https://github.com/bump-sh-examples/train-travel-api)

* [https://github.com/Redocly/museum-openapi-example](https://github.com/Redocly/museum-openapi-example)

The Train Travel API describes itself

> This API is provided under license
> [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](https://spdx.org/licenses/CC-BY-NC-SA-4.0.html).

and the Museum API has the [MIT license](https://opensource.org/license/mit/)
attached to it. Kudos!

In the context of API Design Matters and what I've previously written here, I suggest a few changes to the Museum API &mdash; i.e. we can learn something from them.

* It is widely understood that APIs should avoid HTTP Basic Auth, which
  is inherently insecure.
  [I recommend revising the Museum OpenAPI example](https://github.com/Redocly/museum-openapi-example/issues/9)
  to use a more secure security scheme, such as `oauth2` with
  `authorizationCode` flow, or `openIdConnect`, and define more specific
  scopes for the operations. (See more information in Understanding the
  Language of API Security in API Design Matters.
* The Museum API also mixes operations meant for museum visitors and
  other operations meant for museum administration (creating special
  events). I think those different capabilities should be split into
  separate APIs, based on domain contexts and who will use the APIs.
  I.e. a client app aimed at museum visitors should not have API access
  to museum administration operations. As coded, the API implies anyone
  with valid userid/password can create or delete special programs.

The Train Travel API uses the oauth2 security scheme with read and write scopes for different operations. That's definitely an improvement. It also embraces lots of standards, such as `application/problem+json` for error responses (as I advocate in [Your API Has Problems. Deal With It.]({{'/2023/03/26/your-api-has-problems.-deal-with-it'|relative_url}})
) and ISO country codes, ISO currency codes, and IANA time zone names.
However, defining an API that accepts credit cards or connects bank
accounts for payments introduces compliance concerns - processing full
credit card numbers and card security codes in the US (even over TLS)
will likely require PCI compliance, which is a major roadblock that is
not mentioned. I think payments is not really a suitable domain for
examples meant to document API design and OpenAPI best practices&hellip;
Payments introduces too many ramifications/complications that get in the
way of such a project's goals. I instead suggest that the API refer to
another (perhaps third party) API for payment processing. We know there
are several out there&hellip;.

I don't want to be or appear to be overly critical of these offerings. I
think a good replacement for Pet Store is necessary, and I'm delighted
to see new examples making an appearance, and in an open manner. I hope
they get a lot of traction and acceptance and spread far and wide. These
are both good starts, and we can learn from them immediately. A great
first takeaway is that good API design is hard to get right, for many
reasons. I'll followup with more details on this in a future post, The
Art of API Design.

<hr>

{% include discuss.md %}

{% include orig.md %}
