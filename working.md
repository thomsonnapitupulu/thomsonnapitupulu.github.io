---
layout: default
title: Working
permalink: /working/
---

<h1 class="text-2xl lg:text-4xl mt-8 mb-4 text-black font-extrabold tracking-tighter italic leading-tight">Working</h1>

<div class="posts">
  {% assign posts_by_year = site.posts | where: "category", "project" | group_by_exp: "post", "post.date | date: '%Y'" %}
  
  {% for year in posts_by_year %}
    <div class="year-group">
      <div class="year-label">{{ year.name }}</div>
      
      {% for post in year.items %}
        <div class="post-item">
          <span class="post-date">{{ post.date | date: "%b %d" }}</span>
          <span class="post-title"><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></span>
        </div>
      {% endfor %}
    </div>
  {% endfor %}
</div>