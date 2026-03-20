---
layout: default
title: Archive
permalink: /archive/
---
# {{ page.title }}

View the archive of {{site.title}} articles here.

{% for post in site.posts %}
* [{{ post.title }}]({{ post.url | relative_url }}) <time datetime="{{ post.date | date_to_xmlschema }}">{{ post.date | date: "%B %-d, %Y" }}</time>
{% endfor %}

{% include discuss.md %}
