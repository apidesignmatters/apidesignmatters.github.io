---
title: Growing a Language
date: 2023-04-18 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

Today, we take a short diversion from our normal journey through The Language of API Design&mdash;though we're not deviating very far off our path.

I've focused on the importance of language in this series:

How a language expresses ideas, such as how the language of OpenAPI can describe concepts and ideas of RESTful web API

How acquiring and learning a language like the OpenAPI Specification, JSON Schema, or HTTP 1.1 gives you skills to not just design APIs but to solve business problems with APIs

How Domain-Driven Design uses the ubiquitous language to describe the domain for a software system

... which implies that an API is itself a mini-language for communicating with the back-end API service

... and, like other languages, that API mini-language grows and evolves over time

There are parallels in how these different classes of languages evolve
over time&mdash;whether they are programming languages, API
specification languages, or domain specific API mini-languages. That is
what I am focusing on in _The Language of API Design_ series. As you
read the series, your language fluency changes and grows. You will
probably use 20% of the OpenAPI specification 80% of the time
([Jarkko Moilanen](https://github.com/kyyberi) makes the same point in
[_Pareto principle (80/20) and Developer eXperience&mdash;why should I care?_](https://speakerdeck.com/kyyberi/20-and-developer-experience-why-should-i-care).
But the professional practitioner polyglot that you are is not satisfied
with 20% mastery&mdash;you want know all of what is possible, when to
use it and why!

Guy Steele<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
 gave a wonderfully self-referential presentation of this topic of Growing a Language in his keynote of the same name at the ACM OOPSLA conference twenty-five years ago in 1998, and I was fortunate to be in the audience. As a language geek, it is one of my favorite talks of all time. (If you need a hook&mdash;and why I say Steel's talk is "self-referential"&mdash;Steele grows the natural language of his talk as he progresses, by defining the language's vocabulary as he goes.) While his talk is not specifically about web and RESTful APIs, the concepts apply to all manner of language evolution, including APIs and their specification languages.

I strongly encourage my readers to watch and listen to this talk. (You
can read it if you search for the text, but please don't.) Listen to how
Steele uses language to define what a language is, what a program is,
and (another of my favorite API Design Matters topics), what a pattern
is.

<iframe width="560" height="315" src="https://www.youtube.com/embed/_ahvzDzKdB0?si=85YSnPk50EBhwrBC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

I'm certainly not as clever as Guy Steele. Few of us are (no slight intended to my very clever readership). But we can all appreciate his insights and his humor, and learn something new from him. From Steele, we can all grow our knowledge, and grow our own Language of APIs, and even grow our own manner of thinking.

I hope you enjoy Guy's talk as much as I did&mdash;so much so that you too will find a way to recommend it 25 years after you first heard it. (2048 is a great year for that!)

I'll finish with some of my favorite quotes from Steele's talk:

> I stand on this claim: I should not design a small language, and I should not design a large one. I need to design a language that can grow.

> It is good to design a thing, but it can be far better (and far harder) to design a pattern. Best of all is to know when to use a pattern.

> A language design can no longer be a thing. It must be a pattern&mdash;a
> pattern for growth&mdash;a pattern for growing the pattern for defining the
> patterns that programmers can use for their real work and their main
> goal.

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
With Samuel P. Harbison, Guy Steele wrote wrote C: A Reference Manual. He was also the author of Common Lisp: The Language (a very accessible language specification) and with James Gosling, Bill Joy, and Gilad Bracha, Steele coauthored three editions of The Java Language Specification. He is an widely acknowledged expert in the domain of programming language design.

{% include discuss.md %}

{% include orig.md %}
