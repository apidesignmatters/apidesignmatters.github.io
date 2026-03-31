---
layout: default
title: Archive
permalink: /archive
---
# {{ page.title }}

View the archive of {{site.title}} articles here.

{% assign sorted_posts = site.posts | sort: 'date'  %}
{% for post in sorted_posts %}
## [{{ post.title }}]({{ post.url | relative_url }})
{{ post.excerpt }}
<p style='text-align: right'>Published: {{ post.date | date: '%B %-d, %Y' }}</p>
{% endfor %}

{% include discuss.md %}
