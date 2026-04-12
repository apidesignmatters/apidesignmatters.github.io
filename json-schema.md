---
title: JSON Schema
permalink: /json-schema
date: 2026-04-09 18:00:00 -0000
layout: default
---

# JSON Schema

Several articles in _API Design Matters_ cover JSON Schema,
listed here.

{% for tag in site.tags %}
{% if tag[0] == 'json-schema' %}

{% assign sorted_posts = tag[1] | sort: 'date'  %}
{% for post in sorted_posts %}
## [{{ post.title }}]({{ post.url }})

{{ post.excerpt }}
 <p style='text-align: right'>Published: {{ post.date | date: '%B %-d, %Y' }}</p>

{% endfor %}
{% endif %}
{% endfor %}

Thanks for reading _API Design Matters_!
