---
title: API Design Patterns
permalink: /api-design-patterns
date: 2023-03-21 18:00:00 -0000
layout: default
---

# Your Guide to API Design Patterns

A number of articles in _API Design Patterns_ discuss common design
patterns
for APIs... that is, _API Design Patterns_.
This page is an index of thos articles.

{% for tag in site.tags %}

{% if tag[0] == 'api-design-patterns' %}

{% assign sorted_posts = tag[1] | sort: 'date'  %}
{% for post in sorted_posts %}
## [{{ post.title }}]({{ post.url }})

{{ post.excerpt }}
 <p style='text-align: right'>Published: {{ post.date | date: '%B %-d, %Y' }}</p>

{% endfor %}
{% endif %}
{% endfor %}

Thanks for reading _API Design Matters_!
