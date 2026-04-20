---
layout: default
title: Archive
permalink: /archive
---
# {{ page.title }}

Below is the full archive of {{site.title}} articles in chronological
order.
You can also visit articles tagged with specific topics:
* [The Language of API Design]({{'/the-language-of-api-design' |  relative_url}})
* [API Design Patterns]({{'/api-design-patterns' | relative_url}})
* [JSON Schema]({{'/json-schema' | relative_url}})

{% assign sorted_posts = site.posts | sort: 'date'  %}
{% for post in sorted_posts %}
## [{{ post.title }}]({{ post.url | relative_url }})
{{ post.excerpt }}
<p style='text-align: right'>Published: {{ post.date | date: '%B %-d, %Y' }}</p>
{% endfor %}

{% include discuss.md %}
