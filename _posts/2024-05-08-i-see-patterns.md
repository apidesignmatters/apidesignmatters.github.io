---
title: I See Patterns
date: 2024-05-08 18:00:00 -0000
layout: post
tags:
  the-language-of-api-design
  patterns
---

Humans are great at recognizing patterns. In software, software design
patterns gained popularity in the 1990's as a way of capturing design
constraints and reusable solutions to recurring problems, accompanied by
a "pattern language" to describe them. (Fielding's dissertation even
cites Christopher Alexander's thinking on pattern languages.)

![alt text]({{ '/assets/img/I-See-Patterns.png' | relative_url}})

If you have been reading API Design Matters, you may have noticed a
recurring theme<a id='footnote-1-ref'/><a
href='#footnote-1'><sup>1</sup></a> : _I'm a big advocate of patterns._

{% include language-of-api-design-series.md %}

I'm an advocate because I believe patterns are a great communication
tool. (How's that for getting controversial?) Seeing patterns&mdash;or having
them pointed out in a software design&mdash;accelerates our understanding of
larger systems. Patterns help us manage complexity by pushing mundane
details down a level and allowing us to discuss software at a higher
level of abstraction. (Humans are really good at abstraction, too.)

> Omitted here out of respect for my readers: Cliche meme based on
> either "I see dead people" from The Sixth Sense, or "API Patterns&hellip; API
> Patterns Everywhere" from Toy Story.

Of course, the other main API Design Matters theme you may have noticed is that of languages, and specifically a language's expressiveness &mdash; it's ability to express and communicate ideas. Just as a for loop is easy to understand as a programming pattern or language idiom, a pattern language can define a vocabulary that conveys a huge amount of meaning with a small number of words. That's powerful.

> Patterns are a great communication tool

This API Design Matters series will focus on a number of API design patterns &mdash; recurring patterns that we see over and over in API designs.

Some of the [API Design Patterns]({{'/api-design-patterns'|relative_url}}) I'll discuss:

* Oh, CRUD (or, Being Resourceful)
* Resources and Collections; pagination/filtering/sorting
* URL patterns and meta-patterns
* The Mother of All Initialism: HATEOAS and Hypermedia
* REST is a State of Mind
* Resource sets to model state changes on resources
* Revisionist History:  Pattern for immutable revisions of mutable resources

Oops, I did it again

Handling errors in APIs, error/problem responses, and common abstract resource representation.

Certainly, I'm not the first to write about API patterns. There are several excellent resources which discuss API patterns, notably:

API Design Patterns by J.J. Geewax

RESTful Web API Patterns and Practices Cookbook by Mike Amundsen

API Design Patterns for REST by Adam DuVander

Essential API Design Patterns: A Guide to Crafting Superior Web Services by Moesif
<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
Kindly note that I did not say "recurring pattern" ;-)

{% include discuss.md %}

{% include orig.md %}
