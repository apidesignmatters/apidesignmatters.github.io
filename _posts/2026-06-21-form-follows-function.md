---
title: "Form Follows Function Follows Form..."
date: 2026-06-21 16:00:00 -0000
slug: form-follows-function
layout: post
---

I've been dwelling on this topic for a long time,
but when Bruno Pedro published an article,
[_The Taxonomy of API Operation_](https://apichangelog.substack.com/p/the-taxonomy-of-api-operations)
recently, I decided I should polish this one off and publish it.
Thus, I wish to talk about how _Form Follows Function_ as
a means understanding API designs.
Also making an appearance in today's duality's fray
are the clashes of _style over substance_ and _syntax vs. semantics_.

![form follows function as an aid in understanding API designs]({{ '/assets/img/form-follows-function.png' | relative_url}})

My interpretation of Bruno's post (please read) is that there is a
_classification of API operations_ (well, likely many possible classifications) that can aid
API consumers (both human developers and AI agents) in their consumption of the APIs.
Humans can understand the implied language of the API through insight
and intuition and by applying patterns of thought from other APIs to
the one they are currently coding to. That is, human intelligence
picks up many semantic clues from well-designed, consistent APIs.
AI systems rely on more explicit hints (prompts, large contexts, RAG
systems, etc.)

In
[_What is the Meaning of This?_]({{'/2024/01/11/what-is-the-meaning-of-this'|relative_url}}),
I claimed that AI (agents) will be more successful with APIs if
they have

1. better training data
2. better prompts
3. good feedback loops

but the main point of my 2024 talk is

> _...other semantic hints in the API definition can help not just an AI
> to "understand" the API, but humans as developers as well. I'm not
> sure what form such semantic hints will take._

For both types of consumers, _consistency_ with prior API
definition/structure is what aids in building
positive feedback loops. That is, consistent _form_
is key to good _developer experience_, and I assert, key
to good _agentic experience_ as well.
Similarly, when I think about API design and consistency,
a certain degree of consistent _style_ and _syntax_ is as important as
the _substance_ (_semantics_).
That is, good (i.e. consistent) _style_ or good (consistent)
_syntax_ will inform and improve
the consumer's understanding of the API.

> Form follows function&mdash;that has been misunderstood.
> Form and function should be one, joined in a spiritual union.
>> &mdash;Frank Lloyd Wright

Thus, in API design, _form follows function_, but _function follows
form_: Seeing a consistent API design syntax and consistent style leads
to well-understood API substance - the API capabilities and function.
For example, consider a consistent API Style Guide that promotes uniform URL
notation (clean URLs) for CRUDL operations. The form (URL syntax, use of
corresponding HTTP methods, etc.) is a natural expression of the design
function&mdash;that of creating, reading, updating, deleting and listing API resources.
(See ['!Oh CRUD!']({{'/2024/06/17/oh-crud'|relative_url}}).)

One of the core architectural constraints of REST APIs
(as per Roy Fielding) is the
[_Uniform Interface_](https://en.wikipedia.org/wiki/REST#Uniform_interface).
This is another variant of _form follows function_:
The semantics (function) of the REST architectural style are
strongly informed by the syntax or structure (form) of the uniform
interface,
and (I assert) vice-versa.
Those who have internalized that architectural constraint will have
an easier time using APIs that are designed following that constraint.

----

Thus, I'm a strong advocate of having a robust _API Style Guide_
when designing APIs&mdash;assuming the style guide
is well-informed and itself consistent (with industry
norms and developer expectations);
as I noted in
[The Art of API Design]({{'/2024/04/11/the-art-of-api-design'|relative_url}}),
one can abuse creativity when designing APIs&mdash;do not be creative
for the sake of creativity.

Arnaud Lauret wrote about
[The 5 dimensions of API consistency](https://blog.postman.com/the-5-dimensions-of-api-consistency/).
These dimensions of consistency aid consumers in understanding
new APIs that follow the mold set by previous APIs
(by the same producer, same domain, same internet protocols.)

One of my _Developer Experience_ "rules of thumb" in API design is to
_not violate the developer's expectations_ of how APIs work.

> Do Not Violate the Developer's Expectations

Developers have learned through experience&mdash;exposure to numerous
APIs and applications&mdash;that certain (HTTP and other) standards and
conventions imply _specific semantics_, so it is important to adhere to
(not violate) those expectations, be they standards or conventions or
just the weight of experience.

As Arnaud Lauret stated it:

> Following standards will ensure users have no surprises.

For example, many will assume/accept that a `GET` operation
operation is idempotent, so good API design will follow
that expectation (perhaps more so than by standard):
a `GET` operation won't modify observable application state.
(I once saw an API design where `GET` operations were used
to start and quiesce servers... don't get me started.)

For me, a formative book on the interplay of syntax and semantics
is Douglas Hofstadter's Pulitzer prize winning
[_G&ouml;del, Escher, Bach: An Eternal Golden Braid_](https://en.wikipedia.org/wiki/G%C3%B6del,_Escher,_Bach)
(GEB).

In my 20th anniversary edition, Hofstadter wrote a new introduction,
and on page 12 wrote of the book:

> GEB is in a large part about how content is inseparable from form, how
> semantics is of a piece with syntax,
> how inextricable pattern and matter are from each other.

The gist of what Hofstadter is trying to say in GEB (or, if not, what I infer
from it) is
that meaning can arise out of
emergent patterns in symbolic formal systems (information)...
_form follows function_ and _function follows form_.
Thus, as I see it, the form (the syntax, structure) of information and
knowledge systems is as important as (or as necessary as)
the semantics and meaning we derive from
them. I think this idea can apply to understanding APIs
(by humans and perhaps by artificial intelligences);
that is, the consistent use of _form_ may be as critical
as more explicit descriptions of the semantics and behavior
of an API. In API design, form follows function follows form
in a virtuous cycle or... perhaps even a (Hostadter) Strange Loop.

In the age of AI chatbots and coding assistants,
it is interesting how focused we've become with _context_: context windows, prompts, etc.
But I think that the expression of context (including our own implicit
knowledge and intuition) is what guides human intelligence in
understanding APIs and such context also is (or will be) necessary for
AI systems to "understand" (if that is the right word) APIs as well.

However, human intuition and memory, being so deep and intricate, (and
at times, _inconsistent_) is where I see the true challenge in building
AI systems (or Artificial General Intelligence) which can match human
intelligence. As I said in my 2024 Nordic APIs Austin API Summit talk on
[The Art of API Design]({{'/2024/04/11/the-art-of-api-design'|relative_url}}),
prompting an AI system

> is like pushing a horse with a rope&hellip;

If I were more clever, I would preface this discussion
with a dialog between Achilles and the Tortoise, but alas,
I'm not that clever.
<hr>

{% include discuss.md %}
