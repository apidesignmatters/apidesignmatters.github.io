---
title: "Don't Go Off the Rails"
date: 2026-05-13 08:00:00 -0000
slug: dont-go-off-the-rails
layout: post
---

As we journey down the path of API design and delivery,
the topic of _governance_ comes up often.
There may be some resistance from multiple teams when it
comes to governing APIs.
Management may not like spending time and team capacity on governing
the API program, fearing that this slows down
time-to-market. Engineering teams may resist,
feeling that it overly constrains them
or limits their creativity.

![alt text]({{ '/assets/img/Dont-Go-Off-the-Rails.png' | relative_url}})

As a counterpoint, I believe good API governance
actually _accelerates_ good API programs, at least
in the long run, where it really matters.

[Justin Miller](https://www.linkedin.com/in/justin-miller-793a019a) started
a LinkedIn thread about
[effective
Enterprise Architecture (EA)](https://www.linkedin.com/feed/update/urn:li:activity:7451736443611426816/).
One key sentence really stand out to me:

> EA should not be where decisions go to wait, it should be where decisions go to get smarter.

There, I replied:

> _EA/Governance has an important role of socializing
> decision making. That is, EA decisions allow engineering
> teams to skip re-adjudicating decisions that have already
> been explored/made/justified/recorded, so teams can start
> from proper guidance/foundation and focus on what's new and
> important instead of rehashing the same decisions again.
> This allows teams to speed up, not get mired in process._

Justin replied:

> ... _love how you framed this as acceleration through
> clarity. In my experience, teams embrace architecture when
> they see it saving them cycles, not adding steps. The
> trust comes from showing that past decisions actually
> remove today’s blockers._

I agree with that sentiment,
and I noted that saving cycles/steps:

> .. means (among others) removing duplication, avoiding
> errors/defects, increasing security, capabilities,
> maintainability, other *ilities ..
> i.e. delivering robust products.

To me, _API Governance_ is a process of keeping
your API from going off the rails. The governance rules,
guidelines, standards, and processes establish _a safe set of rails
on which to run your API program._

> API Governance tells us: Don't Go Off the Rails

![Canada Pacific Railway tracks (photo by the author)]({{
 '/assets/img/CPR-view-1.jpg' | relative_url}})
 <br>
_Photo by the author_

My exercise regiment includes frequent rides on iFit on a NordicTrack
S22i indoor cycle. iFit provides recorded training rides, led by
iFit trainers. One of my recent rides was along the "_Train Wreck Trail_"
near Whistler, BC. The trail is noted for several train cars
strewn across the wilderness, which
([according to the Whistler Museum](https://whistlermuseum.org/2016/07/28/train-wreck-mystery-revealed/))
are the result of a train wreck in 1956 when a logging train
exceeded (by 20+ MPH) the 15 MPH speed limit on a stretch of
the rails going around a bend, (in an attempt
make up time on the run.)

![Slanted Carriage, one of the freight cars on the Train Wreck Trail near Whistler, BC]({{'/assets/img/Slanted-Carriage.jpg'| relative_url}})
<br>
[_Slanted Carriage_](https://www.flickr.com/photos/26968630@N08/14362466922) photo by [Craig Dennis](https://www.flickr.com/photos/craigmdennis/), used under CC BY 2.0 License.

Not to specifically call out Canadian rail wrecks, but in 2017, I
traveled Canadian Pacific Railway through the Canadian Rockies, where we rode
through the
[Spiral Tunnels](https://parks.canada.ca/pn-np/bc/yoho/culture/kickinghorse/visit/spirale-spiral).
The tunnels were dug into the mountains in order to reduce runaway
train accidents (some fatal) on the original 4.5&deg; grade descent.
The tunnels, opened in
1909, reduced the grade to 2.2&deg;.

![Map depicting the Spiral Tunnels route through the mountains.]({{ '/assets/img/CPR-spiral-tunnel-1.jpg' | relative_url}})
 <br>
_Images from an historical marker sign at site._

![Photo of old locomotive passing over one of the tunnels as passenger cars enter the tunnel]({{
 '/assets/img/CPR-spiral-tunnel-2.jpg' | relative_url}})
 <br>
_Images from an historical marker sign at site._

These are examples of what can happen when there is insufficient
governance: systems can lead to failure instead of staying on the tracks.

## Governance Culture

Modern trains have governors which limit their speeds. Prior to this,
signals and signs warned train conductors/engineers when to slow down
for safety. But that was not always enough.

APIs (and API programs) do not have governors built in. People, or the
processes that the people employ, are the governors. Tools may assist
with governance, but the true key to safer API programs is _cultural_
&mdash; gaining adoption by stakeholders and teams, based on recognition
that the shared benefits (such as _reduced_ risk) outweigh the costs.

Teams already accept other forms
of software development governance, such as established
unit and regression and stress tests, compiler code validation and linting,
Git or other software source code control with peer-led
code reviews, license checking, code scanning,
delivery gates such as Quality Assurance and other team sign-off, etc.
Analogous but sometimes different governance for APIs
is quite possible in comparison.
Once good governance is in place, it
can become second nature, and teams will appreciate
identifying and mitigating risky design as early in the process
as possible, to eliminate the extra work to address
issues (and root causes) after an API is in production.

## Examples of API Governance

Some ways to employ effective API governance:

* Establish and follow an API Style Guide. This is probably the most widely used tactic.
* Related to a style guide is using tools such as Spectral to _lint_ an OpenAPI document, to identify violations of the style guide.
* Peer review of API Design, such as reviewing new APIs or changes to
  APIs via source code control pull request review.
* Training programs

The consequences of going off the API rails may
not be as severe as a train wreck, but it can lead
to many negative effects:

* Harder to use and inconsistent APIs
* Increased documentation and support costs
* Engineering delays to implement and test new client or service code rather than reusing established code flows that are based on the standards/conventions
* Expensive deprecation/remediation
processes when updates introduce breaking changes<a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
* Loss of trust
* Loss of business

<hr>

If you were like me, you may have been raised with the advice: "Stay off the Tracks", but
when it comes to good API programs, my advice is to "Don't Go Off the
Rails" and __*"Stay on the Tracks"*__.

![Canada Pacific Railway tracks]({{ '/assets/img/CPR-view-2.jpg' | relative_url}})
 <br>
_Photo by the author_

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
I originally wrote "when updates accidentally introduce breaking changes", but I decided
to remove "accidentally" there.
It is not really an accident
if you deliver a breaking change because of a lack of good API Governance.
Instead, it is a _conscious decision_ to bypass governance and ignore the
processes that can prevent such negative effects.

{% include discuss.md %}
