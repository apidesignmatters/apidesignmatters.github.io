---
title: Chain Links Domain Model
date: 2023-03-07 18:00:00 -0000
layout: post
tag: the-language-of-api-deign
---

I present here a possible Domain Model for the Chain Links application
that accompanies
[The Language of API Design]({{'/the-language-of-api-design' |
relative_url}}) series in [API Design Matters]('/' | relative_url). Below are several key elements of a Domain Model, with a brief description of each,

## Domain Model

A social media app in which fan fiction authors can compose content, mix other authors' existing content in new ways, to author and share new stories called chains, or continue existing chains. Each chain exists within a universe. Characters (of various species) can span universes and have roles in many chains.

## Context

Reading, authoring, composing, and sharing fan fiction stories, called chains, by chaining together story elements, called chain links.

Out of scope for the context of the [The Language of API Design]({{'/the-language-of-api-design' |
relative_url}}) series series (but things that may be in scope in a commercially viable product):

Content moderation, plagiarism detection, content safety ratings, censorship, and banning authors

Content tagging, commenting, and star rating systems

Flexible Copyright management: via Terms of Use, all authors must consent to a single [Creative Commons BY-NC-SA copyright](https://creativecommons.org/licenses/by-nc-sa/4.0/).

Copyright infringement controls: via Terms of Use, authors agree to only contribute original work, not other's copyrighted work.

Monetization: authors cannot put up paywalls to access their content, or sell other's work

Crowd-sourced editorial actions (approving changes to existing published story elements)

Gamification, rewards, incentives for contributing

localization - translation of stories to other natural languages

Author levels with earned trust/permissions (such as changing/editing previously published content)

... What other domain-specific scope limitations can we impose to narrow the context of the solution?

## Resources

### Chains

Stories, a.k.a. story lines. For this product, stories are called "chains" (branding name). Properties:

* name - a text string, 4 to 120 characters
* universe - the universe in which the chain exists. Universes contain characters and themes and genres.
* authors - a list of authors who have created one or more chain links used to build the chain/story
* characters - the set of characters that participate in the chain,
derived as the union of the sets of characters from all the chain links.
* chain type - the type of story; this can constrain what types of
stories may be added.
For example, a "graphic novel" can only contain panel images, not text.
  * one of: text, graphicNovel
* structure - how the chain is structured, one of linear, branching
* story elements (chain links; see below) - story elements that are chained together to form a chain or story.
* creation timestamp
* modification timestamp

### Chain Links

Story elements - reusable content that may be added to other stories. For this product, story elements are called "chain links" (branding name). Chain links can be as small as a chapter heading, a few sentences, or an image and caption, or larger elements such many paragraphs. Chain links may be strung together to create chains. Properties:

* author
* a list of chains in which this chain link is used
* type - plain text, rich text, image with optional caption, branch (to define alternate, non-sequential story lines)
* content - the actual block of (Markdown) text, or the image data.
* creation timestamp

### Authors

Registered app users who have contributed content. Properties:

* name (literary name) - a text string, 4 to 64 characters
* biography - author's biography (implemented as a chain of biographical chain links)
* bibliography - a list of chains chains links that the author has contributed to

### Universes

Genres in which stories and characters exist. Properties:

* name - a text string, 2 to 64 characters
* description - a chain of chain links which describes the universe and its themes
* characters - list of characters in the universe
* stories - list of stories (in the fan fiction library) that occur in this universe

### Characters

* name - a text string, 2 to 64 characters
* originUniverse - the universe in which the character was first introduced
* biography - the character's biography (implemented as a chain of biographical chain links)

## Actors

(People to interact with the system,
and their roles.)

* Visitors - causal site visitors who read content but do not contribute content
* Fans - registered users who read content but do not author content
* Authors - registered users who read and write content

## Behaviors

(The activity that an actor performs in the system when interacting with the resources. Behaviors are the business actions within our domain’s contexts—what the users do.)

1. Visitors, fans, authors can list and search for and read content by author, title, universe, character, or date-time when the content was published.
1. Visitors can register on the site to become fans or authors
1. Authors can update their profile
1. Authors can draft new chain links
1. Authors can edit existing chain links that have not yet been published
1. Authors can copy existing chain links for editing. This is not limited to chain links the author created.
1. Authors can add chain links to existing chains
1. Authors can create new chains
1. Authors can create new universes
1. Authors can create new characters

## Constraints

(Conditions which put bounds on our context. Constraints can be large and small, such as a system invariant that is always true before, during, and after a behavior, or a minimum/maximum value range of a property in a value object.)

1. Text chain links are limited to 1,000 words
1. Images used in chain links are limited to 2,000 pixels along the largest dimension, and limited to JPEG and PNG images (no raw, TIFF, GIF, BMP, ICO, PSD, or other image types)
1. Authors are limited to 100 media for the free tier, 10,000 media files for paid tiers. (This is not a photo sharing site.)
1. Chains are limited to 1,000 chain links
1. Chain titles are limited to 120 characters
1. Published chain link contents are immutable, although this may change in the future when authors can earn change permissions
