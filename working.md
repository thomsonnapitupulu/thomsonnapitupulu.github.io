---
layout: page
title: Working
permalink: /working/
---

{% include search.html %}

<div class="posts">
  {% for post in site.posts %}
    {% if post.category == "project" %}
      <article class="post-item">
        <h2 class="post-title">
          <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a>
        </h2>
        <div class="post-meta">
          <time datetime="{{ post.date | date_to_xmlschema }}">
            {{ post.date | date: "%B %-d, %Y" }}
          </time>
          {% if post.tags.size > 0 %}
            <span class="tags">
              • 
              {% for tag in post.tags %}
                <span class="tag">{{ tag }}</span>{% unless forloop.last %}, {% endunless %}
              {% endfor %}
            </span>
          {% endif %}
        </div>
        <div class="post-excerpt">
          {{ post.excerpt }}
        </div>
        <a href="{{ site.baseurl }}{{ post.url }}" class="read-more">Read More</a>
      </article>
    {% endif %}
  {% endfor %}
</div>