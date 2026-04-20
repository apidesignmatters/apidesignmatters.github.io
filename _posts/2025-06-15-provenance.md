---
title: Provenance
date: 2025-06-15 18:00:00 -0000
layout: post
---

> Origins of API Design Matters

I started API Design Matters in early 2023 (if you've been reading since
then, __*Thank You!*__), but the idea goes back much further.

Back in the mid 90's (yeah, I've been around a while&hellip;) I was deep into
that new "Java thang". In June 2025, Emmanuel Paraskakis shared slides from
a 2007 talk Joshua Bloch had given, titled
[How to Design Good APIs, and Why it Matters](https://www.linkedin.com/feed/update/urn:li:activity:7334632906079776768/). I had seen a version of this talk in my Java years at a
conference, and I had the pleasure of working with Java API design
experts like Josh Bloch and Doug Lea as they built out the Collection
framework (lists, maps, etc) for Java 2 in the early days. The title of that talk lodged
itself in the back of my brain, almost as much as the content of the
talk, and both were a large part of why I created _API Design Matters_&hellip;
and why I named it as I did.

![alt text]({{ '/assets/img/Provenance.png' | relative_url}})

Josh and Doug and others were gracious and accepted a lot of input from
the younger me, and answered my questions about the emerging design of
Java's Collection framework. Those conversations are lost to time, but I
do remember their impact. A specific example I recall from the early Java
Collection API design discussions centered on the collection interfaces'
`isEmpty()` query function, which returns `true` if the collection was
empty (had no items), `false` if not. I asked about the need for such a function, since
the collections already had a `length()` function. It seemed unnecessary
to add a `collection.isEmpty()` method because a client could trivially
use `(collection.length() == 0`). However, Josh kindly pointed out that,
with so many different/possible collection implementations, the `length()`
function may be expensive to compute. For example, for a linked list,
computing `linkedList.length()` is `O(n)` (where _n_ is the number of items in the list),
not `O(1)`, whereas the implementation of `linkedList.isEmpty()`
function for a linked list is trivially `O(1)`.
While API composability is nice, it may come at the cost of performance.

Many of the practices and pragmas Josh shared then, as well in his InfoQ
article,
["Bumper-Sticker API Design"](https://www.infoq.com/articles/API-Design-Joshua-Bloch/),
stuck with me because they also apply to Web API design.

The one principle I have shared the most:

> Public APIs, like diamonds, are forever."
>
> &mdash; Joshua Bloch

When I worked at SAS, I shared an example of this principle several
times when discussing API design. As late as 2017, I would show examples
of small SAS programs from the 1976 SAS manual, and the programs
continued to work unaltered in the SAS System of 2017. Backwards
compatibility is as critical to the longevity of an API as it is to a
programming language/platform.

Josh also wrote:

> If there is a fundamental theorem of API design, this is it &hellip; Every
> facet of an API should be as small as possible, but no smaller. You
> can always add things later, but you can't take them away. Minimizing
> conceptual weight is more important than class- or method-count.

Obviously, design forces often oppose on another. The collection
interface footprint would be smaller without an `isEmpty()` function, but
the negative impact of omitting it is offset by the benefit of including
it.

Another important aspect of _API Design Matters_ provenance that I wish
to share is that none of the text in _API Design Matters_ was generated
by AI. (I did try AI for one image and I doubt I'll do that again
because the result was so awful). But I have never used an AI to draft,
write, or rewrite my posts&mdash;It's all me. It always will be.

I wish to acknowledge and thank Josh Bloch and Doug Lea and others who taught me so much.

Who has inspired your work with APIs? Let me know in the comments.
<hr>

{% include discuss.md %}

{% include orig.md %}
