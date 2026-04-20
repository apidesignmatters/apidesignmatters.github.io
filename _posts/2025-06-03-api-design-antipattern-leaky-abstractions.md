---
title: 'API Design Antipattern: Leaky Abstractions'
date: 2025-06-03 18:00:00 -0000
layout: post
tag: api-design-patterns
---

> Pro tip: Do not let internal implementation constraints leak into your API

In this edition of _API Design Matters_, I will discuss an API design
practice that I recommend avoiding &mdash; leaking internal implementation
details into the API design. This does not fit the original definition
of an _antipattern_<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
but I'm going to use that term anyway and call _Leaky
Abstractions_ an _API Design Antipattern_.

![alt text]({{ '/assets/img/API-Design-Anitipattern-Leaky-Abstractions.png' | relative_url}})

{% include api-design-patterns.md %}

Exposing internal implementation details in an API design has negative consequences:

1. If the API design is too coupled to the underlying system, changes to
   that internal system likely will require changes to the API, which in
   turn can disrupt the API's clients and consumers.
1. Such detail often reflects cultural, historical, technical and other
   influences that pertain to the engineering team, requirements, system
   and other constraints for a different scenario or problem set than
   the API. As such, the internal implementation decisions may not
   address the needs of the API. For example, databases are often designed
   to optimize for certain access patterns of the system or application
   they were originally built to support. Such patterns may be very
   different for an API that is designed to use that data at a later
   time.
1. Internal system design often uses jargon or concepts that are
   unrelated to the conceptual model that your API consumers have of
   your system. This impedes adoption of your API.

Thus, one should avoid letting the internal system design leak into the API in order to create and maintain an API abstraction that fits the API consumer's needs. Don't sacrifice API usability just to facilitate expediency in the API implementation.

(Corollary: avoid generating an API directly from a database schema.)

Here is a more concrete example. I recently saw the following construct
in a third party API (I renamed the schema to keep the vendor anonymous,
but I did not change the enum names.)

    ...
    components:
      schemas:
        CommunicationMethod:
          title: Communication Method
          enum:
            - FAXI
            - EDIC
            - URID
            - EMAL
            - POST
            - SMSM
          type: string

Unfortunately, the schema that defines these enum values does not define
what these values mean... this is understandable, since OpenAPI and JSON
Schema do not provide a specific notation for describing what each
enumeration in an enum list means. Still, a better developer experience
calls for a description that tells the reader what each of these values
means.

In this case, the descriptions of these values appear _elsewhere_ in the
OpenAPI source file, in the description of a property that is
constrained by the schema. If this schema is needed elsewhere, it is
likely the API author would either not describe the values at all or,
more likely, follow the existing code pattern and duplicate this verbose
description. The result would be fragile &mdash; if the API needed a new value
in the list, this would require updating multiple descriptions in the
API definition. This violates the **Don't Repeat Yourself (DRY)
Principle**, which I've discussed before:
> [Don't Repeat Yourself When Designing APIs]({{'/2023/04/09/dont-repeat-yourself-when-designing-apis'|relative_url}}))

However, this **WET** ("Write Everything Twice") design is not the real
API design antipattern I want to discuss. Instead, it is the __names__ of
these enumerated strings that strike me as a leaky abstraction. Here is
the definition of the property which uses this schema:

```yaml
  properties:
        method:
          $ref: '#/components/schemas/CommunicationMethod'
          description: >-
            The method used to deliver the the status to the originator.
            - `EMAL` - Email
            - `URID` - URI (HTTP URL or similar)
            - `POST` - Postal services
            - `SMSM` - Short Message Service (SMS)
            - `FAXI` - FAX
            - `EDIC` - Electronic Data Interchange
```

Unfortunately, this API appears to leak some internal implementation
constraints &mdash; perhaps this format is required by a separate pre-existing
back end service, or some internal communication protocol, or perhaps
even a database table where only 4 characters are allowed and EMAIL
would not fit. However, there is no need to let such internal
constraints affect the API design by constraining these enum strings to
four characters with reduced readability and diminished self
description.

The purpose of an API is to provide an abstraction of the underlying
service. That abstraction should be expressed in terms the API consumer
can use and understand, not just what is convenient for the implementor.
The goals of the API designer&mdash;and implementor&mdash;should be to do the hard
work to make the API easier to learn and use.

> The goals of the API designer&mdash;and implementor&mdash;should be to do the hard
> work to make the API easier to learn and use.

The above example highlights several issues which decrease the API
usability. For example:

I believe `EMAIL` would be much better than `EMAL`. Why decrease
readability and increase cognitive load by removing just one letter? The
abbreviated spelling reduces one's ability to discuss (talk about) the
API - i.e. one cannot simply mention EMAIL in a conversation and have it
be easily understood - one might even have to spell it out E-M-A-L to
avoid miscommunication.

Why add an `I` to `"FAX"`, or add `C` to `"EDI"` (Electronic Data Interchange) or
add an `M` to `"SMS"` Short Message Service (SMS) or add a `D` to `"URI"` &mdash; just
to make them all 4 character strings?
The terms FAX, EDI, SMS and URI
are well-known, recognizable names; adding extra characters to them only
obfuscates them, especially when the given definitions do not explain
why those extra characters are there:

* `SMSM` - Short Message Service (SMS)
* `FAXI` - FAX
* `EDIC` - Electronic Data Interchange
* `URID` - URI (HTTP URL or similar)

I don't know the origin of these names, but I suspect they came directly
from implementation code. However, this semantic gap between the names
and what they represent only _increases API friction_. There is no
justification given here for why these enum values are named as they are
(perhaps because there is no good rationale). The API design only makes
consumers pause and ask "Why?". When this happens, the API design detracts
from the API's purpose and becomes a pointless distraction.

Your API design should anticipate and answer the domain questions your
consumers may have; it should not raise additional questions in their
minds; nor should reading or using the API be frustrating.
In other words:

> APIs should help you solve your problems. APIs should not be your
> problem.
>
> -[The API Team Mantra]({{'/2025/04/22/the-api-team-mantra'|relative_url}}):

A useful tip is to _always look at your API design from the perspective
of someone who has never seen your system before and does not have the
same institutional knowledge that your API team has_.

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
Martin Fowler defines antipattern as "something that seems like a good idea when you begin, but leads you into trouble. Since then the term has often been used just to indicate any bad idea, but I think the original focus is more useful."
I'm using the latter interpretation of the term.
{% include discuss.md %}

{% include orig.md %}
