---
title: Tags
permalink: /tags/
layout: page
---

<h2>Tags</h2>

<ul>
  {% assign tags = site.tags | sort %}
  {% for tag in tags %}
    <li><a href="#{{ tag[0] }}">{{ tag[0] }} ({{ tag[1].size }})</a></li>
  {% endfor %}
</ul>

{% for tag in tags %}
  <h3 id="{{ tag[0] }}">{{ tag[0] }}</h3>
  <ul>
    {% for post in tag[1] %}
      <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> <small>{{ post.date | date: "%Y-%m-%d" }}</small></li>
    {% endfor %}
  </ul>
{% endfor %}
