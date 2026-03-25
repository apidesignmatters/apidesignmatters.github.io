---
title: The Language of API Design
permalink: /the-language-of-api-design
date: 2023-03-21 18:00:00 -0000
layout: default
---

# Your Guide to The Language of API Design

For new subscribers and visitors to API Design Matters, this guide will
orient you to the _The Language of API Design_ series. This series is dedicated
to a key topic of API design: expressing API ideas and concepts using
the OpenAPI specification&mdash;the language of APIs.

Below are abstracts of the articles in the series, and also a brief
summary of the sample API that we develop within the series. I encourage
new readers to "go back to the beginning" to establish the context of (and
the fictional API example used throughout) the series. While I'd love for
you to read all the articles in sequence, skimming them will provide
some context for understanding later articles.

{% for tag in site.tags %}

{% assign sorted_posts = tag[1] | sort: 'date'  %}
{% for post in sorted_posts %}
## [{{ post.title }}]({{ post.url }})

{{ post.excerpt }}
 <p style='text-align: right'>Published: {{ post.date | date: '%B %-d, %Y' }}</p>

{% endfor %}
{% endfor %}

Thanks for reading _API Design Matters_!

{% include discuss.md %}

{% include orig.md %}
