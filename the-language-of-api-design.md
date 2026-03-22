---
title: The Language of API Design
date: 2023-03-21 18:00:00 -0000
layout: default
---

# Your Guide to The Language of API Design

For new subscribers and visitors to API Design Matters, this guide will
orient you to the The Language of APIs series. This series is dedicated
to a key topic of API design: expressing API ideas and concepts using
the OpenAPI specification-the language of APIs, . Below are abstracts of
the articles in the series, and also a brief summary of the sample API
that we develop within the series. I encourage new readers to "go back
to the beginning" to establish the context (and the fictional example
used throughout) of the series. While I'd love for you to read all the
articles in sequence, skimming them will provide some context for
understanding later articles.

{% for tag in site.tags %}
  <ol>
    {% assign sorted_posts = tag[1] | reversed %}
    {% for post in sorted_posts %}
      <li><a href="{{ post.url }}">{{ post.title }}</a>
            {{ post.excerpt }}
            <p style='text-align: right'>Published: {{ post.date | date: '%B %-d, %Y' }}</p>
      </li>
    {% endfor %}
  </ol>
{% endfor %}

Thanks for reading _API Design Matters_!

{% include discuss.md %}

{% include orig.md %}
