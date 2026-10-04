---
title: Variation and Change
date: 2026-10-03 12:00:00 -0000
layout: post
---

> Some things change. And some things don't stay the same.

I have two topics to discuss today: _Variation_ and _Change_.

Although the two terms are similar, the content under each is very different.
One is on track with _API Design Matters_; the other: its author.

![Banner graphic reading Variation and Change, API Design Matters, David Biesack]({{
 '/assets/img/Variation-and-Change.png' | relative_url}})

## Variation

I was meeting with some API stakeholders this week;
one noted that (paraphrasing) the resource in the API system does
not fully capture the full business entity and what it means and conveys.

This made me think of
[_Amundsen's Maxim_](https://www.amundsens-maxim.com/):

> "Remember, when designing your Web API, your data model is not your
> object model is not your resource model is not your message model." —
> Mike Amundsen

Amundsen's Maxim is worth internalizing because, as Mike
[writes](https://www.amundsens-maxim.com/), the maxim is
an _"open admonishment to all API architects, designers, & implementors"_.

(If you do not know [Mike Amundsen](https://mamund.com/), I urge all
readers of _API Design Matters_: **Get Schooled!** Mike is a widely
known and respected author, speaker, and educator in the API space. If
you have the chance to attend one of his keynotes at a conference, do
not miss the opportunity.)

In *maxim*al due respect to Mike and his wisdom, I modestly propose a slight
variation of the Maxim:

> "Remember, when designing your Web API, your data model is not your
> object model is not your resource model is not your message model is
> not your mental model." — David Biesack, via Mike Amundsen

or another variation:

> "Remember, when designing your Web API, your data model is not your
> object model is not your resource model is not your message model is
> not reality." — David Biesack, via Mike Amundsen

Maybe I'll refer to that variation as _David Biesack's Mike Amundsen's
Maxim_.

That is, we all need to keep in mind that the resources and message
objects in our API services are just that — _models, not the real world
object they represent._ They are bits and bytes; they are not atoms and
molecules or concepts or ideas.

Granted, in the world of banking APIs where I've been working for 9
years, many of the entities are really just digital manifestations of a
concept: there is no _physical_ banking account you can touch; there
is only the digital (and maybe paper) manifestations of accounts.
Within an API, the resource and message models for an account
are not the _actual_ accounts stored in the bank's core system - they
are _models, facsimiles, representations_, and they exist separately from
the real-world entities they model.

Changing a _representation_ of such a resource model does not change the
thing it represents. I can't vary my account's balance by simply
replacing the `balance` property of a JSON object in some client system'
memory, no more than I can improve my bottom line by simply changing the
balance in my check register.

Similarly, a physical change in the real world resource may not
be instantly manifested in the multiple data models. There is
variance in the variations. Similarly, my variation of Amundsen's Maxim
does not alter Amundsen's Maxim. My facsimile, my enhancement,
is just a representation of the original Maxim.

Thus, it is useful to **RE**member what the **RE** means in "**REST**"
(**RE**presentational **S**tate **T**ransfer). The message
objects and resource objects are just that — data _representations_ of
the real-work object the system is modeling. These representations are
very thin facsimiles of reality. We have to keep in mind that, as
attributed to George E. P. Box,

> "All models are wrong, but some are useful". — George E. P. Box

(Box was referring to statistical models, but I think this applies
equally well to message/resource/object/data model, even mental models:
that is the nature of a model.)

Data models and even mental models must, as models, omit or ignore the
many (inumerable?) aspects of the real world entities they represent,
etc. We must use caution when we implement systems and keep in mind that
the models do not supplant the real thing. We must recognize their
weaknesses while maximizing the benefits of using a simpler model to
achieve the desired results within the software system.

[Side note: I asked Mike if he agreed to me creating _variations_ of his Maxim,
and he kindly agreed. Thanks, Mike, for letting so many stand on your
giant shoulders!]

## Change

... Speaking of variation and change, now is a good time to explain why
I have not been posting new content on _API Design Matters_ much over the past
eight months.

As you may know, I held the position of _Chief API Officer_ at Apiture.
Apiture was acquired by [CSI](https://www.csiweb.com) in October 2025,
and in February 2026, CSI decided to eliminate my position.
My last day with Apiture/CSI was March 30.

The transition and job search took up a lot of my focus. (I may share
some of that experience, as there is much to be said... at a later time)

Alas, _API Design Matters_ suffered... but I should be able to return to
a more regular cadence: I have a new position (to be announced soon),
which I started a month ago. I'm very excited about my role and the
organization and their mission. Two months in, the most gratifying
aspect for me is the team of people I'm working with.

I had a fabulous time at Apiture for the full 8-year tenure of its existence.
I am very proud of the work we did there, and very grateful
for the people I worked with. They gave me great freedom to grow, and
they offered me an abundance of opportunities to contribute to some
excellent products, culture, teamwork, learnings, and awesome APIs. It
was sad to leave on those terms, but I look forward tackling some very
interesting problems and putting my passions for great APIs and
Developer Experience towards a new adventure.

<hr>

{% include discuss.md %}
