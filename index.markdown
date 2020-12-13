---
layout: default
---

{% assign a4_files = site.static_files | where: "a4", true | where: "extname", ".pdf" | sort: "basename" %}
{% assign letter_files = site.static_files | where: "letter", true | where: "extname", ".pdf" | sort: "basename" %}
{% assign a3_files = site.static_files | where: "a3", true | where: "extname", ".pdf" | sort: "basename" %}
{% assign tabloid_files = site.static_files | where: "tabloid", true | where: "extname", ".pdf" | sort: "basename" %}
{% assign svg_files = site.static_files | where: "svg", true | where: "extname", ".svg" | sort: "basename" %}
{% assign midi_files = site.static_files | where: "midi", true | where: "extname", ".midi" | sort: "basename" %}
{% assign video_files = site.static_files | where: "video", true | sort: "basename" %}

# Downloads

{% if a4_files != empty %}
## A4
    {% for file in a4_files %}
* [{{ file.name }}]({{ file.path | relative_url }})
    {% endfor %}
{% endif %}

{% if letter_files != empty %}
## Letter
    {% for file in letter_files %}
* [{{ file.name }}]({{ file.path | relative_url }})
    {% endfor %}
{% endif %}

{% if a3_files != empty %}
## A3
    {% for file in a3_files %}
* [{{ file.name }}]({{ file.path | relative_url }})
    {% endfor %}
{% endif %}

{% if tabloid_files != empty %}
## Tabloid
    {% for file in tabloid_files %}
* [{{ file.name }}]({{ file.path | relative_url }})
    {% endfor %}
{% endif %}

{% if midi_files != empty %}
## MIDI
    {% for file in midi_files %}
* [{{ file.name }}]({{ file.path | relative_url }})
    {% endfor %}
{% endif %}

{% if video_files != empty %}
## Video

    {% for file in video_files %}
### {{ file.basename }}
<video title="{{ file.name }}" width="480" height="270" controls>
  <source type="video/mp4" src="{{ file.path | relative_url }}">
  <p><a href="{{ file.path | relative_url }}">{{ file.name }}</a></p>
</video>
    {% endfor %}
{% endif %}

{% if svg_files != empty %}
# Preview
    {% assign svg_file_count = 0 %}
    {% for file in svg_files %}
        {% assign suffix = file.basename | slice: -2, 2 %}
        {% comment %}
        If there are multiple pages per output, only count the first one
        {% endcomment %}
        {% if suffix == "-1" %}
            {% assign svg_file_count = svg_file_count | plus: 1 %}
        {% endif %}
    {% endfor %}
    {% if svg_file_count == 0 %}
        {% assign svg_file_count = svg_files | size %}
    {% endif %}
    {% for file in svg_files %}
        {% assign suffix = file.basename | slice: -2, 2 %}
        {% if svg_file_count > 1 %}
            {% comment %}
            If there's a single page, print the title as-is
            {% endcomment %}
            {% unless suffix contains "-" %}
## {{ file.basename }}
            {% endunless %}
            {% comment %}
            Check if the basename ends with "-1", then add a title containing the basename without "-1"
            {% endcomment %}
            {% if suffix == "-1" %}
## {{ file.basename | split: "" | reverse | join: "" | remove_first: "1-" | split: "" | reverse | join: "" }}
            {% endif %}
        {% endif %}
![{{ file.basename }}]({{ file.path | relative_url }})
    {% endfor %}
{% endif %}

<br>

{% if site.copyright %}
All content on this page is the property of the copyright owner of the original composition.
{% endif %}

Last update on {{ site.time | date: "%Y-%m-%d %H:%M UTC" }}.
