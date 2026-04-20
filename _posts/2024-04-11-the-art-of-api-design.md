---
title: The Art of API Design
date: 2024-04-11 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> ... and the science of API Design

This article is a "re-presentation" <a id='footnote-1-ref'/><a href='#footnote-1'><sup>1</sup></a>
&mdash; a director's cut, if you will &mdash; of
my
[talk of the same name](https://nordicapis.com/sessions/the-art-of-api-design/)
at the
[2024 Nordic APIs Austin API Summit](https://nordicapis.com/events/austin-api-summit-2024/).
My talk kicked off the "API Design track on the first day of the
conference. You can
[view my talk on YouTube](https://www.youtube.com/watch?v=-Da3zHWXXko&list=PLd2MPdlXKO12G6zbXgTtKr5J48b8kVtaF&index=4)
and other talks on the
[2024 Nordic APIs Austin API Summit playlist](https://www.youtube.com/playlist?list=PLd2MPdlXKO12G6zbXgTtKr5J48b8kVtaF).

{% include language-of-api-design-series.md %}

![alt text]({{ '/assets/img/the-art-of-api-design.jpg' | relative_url}})

## About Me

* My professional profile, [davidbiesack.github.io](https://davidbiesack.github.io)
* Software professional for 38+ years
* Have been defining "APIs" for most of that time
  * For many years, "APIs" were libraries and frameworks that I wrote in C, SAS, Java etc.
  * then I started designing REStful APIs
* I Headed SAS' API Center of Excellence for 5+ years
* I joined Apiture as an API designer when it was founded in 2017. I served as Chief API Officer (API design, DX) until March 2026, shortly after Apiture was acquired
* [linkedin.com/in/davidbiesack/](https://linkedin.com/in/davidbiesack/)
* [fosstodon.org/@DavidBiesack](https://fosstodon.org/@DavidBiesack)
* [apidesignmatters.org](https://apidesignmatters.org) - Here!

![alt text]({{ '/assets/img/api-design-is.png' | relative_url}})

## API Design Is

(This is my own take. You probably have a different definition - please
share in the comments!)

* Understanding Business Requirements and the problem(s) to be solved
* Translating Requirements into an API that solves those problems
* Creating a durable abstraction which
  * is fit to the problem/product at hand
  * is comprehensible/usable
  * isolates clients from change and details that should not impact them
  * can evolve over time

![alt text]({{ '/assets/img/api-design-is-an-art.png' | relative_url}})

## API Design is an Art

* Each API is a Commissioned Work
* The Role of Creativity in API Design
* API Design artifacts [should] have aesthetics
  * _Beauty - Elegance - Balance - Harmony_

## The Role of Creativity in API Design

* Is Creativity (Novelty) Welcome in API Design?
* Creativity is in Conflict with Developer Experience
* Creativity is in Conflict with Consistency
* Creativity Increases Learning Curve
* Creativity Ignores Reuse

> Using Greek letters or musical notes in API path elements is
> certainly creative, but that does not make the API good or usable.

Instead of being highly creative,

* APIs must be Utilitarian
* APIs must value Function over Form,
* APIs must value Substance over Style
* A "beautiful, elegant" API that no one can use is an __A__bominable __P__retender __I__mposter

![alt text]({{ '/assets/img/api-design-is-a-science.png' | relative_url}})

## API Design is a Science

(or at least a scientific endeavor)

* We can study APIs (&hellip;easier if they are defined using API specification languages)
* We can identify/discover Patterns
* We can apply rigor, methods, and standards to API Design
* We can learn from others
* We can evolve our practice
* We can improve the State of the Art of API Design

![alt text]({{ '/assets/img/the-art-of-api-design-practitioners.png' | relative_url}})

![alt text]({{ '/assets/img/api-design-is-an-act-of-intelligence.png' | relative_url}})

## API Design is an Act of Intelligence

In my mind, API Design is a whole brain activity which employs both Art
and Science, making it an act of intelligence.

_**API Design**_ weighs multiple competing forces

* Domain Analysis / Modeling (see [API Design First is not API Design First]({{'/2023/02/15/api-design-first-is-not-api-design-first'|relative_url}})
)
* Solve the problems at hand
* Security (see [Understanding the Language of API Security]({{'/2023/11/06/understanding-the-language-of-api-security'|relative_url}})
)
* Developer Experience
* Ease of Use
* Clarity
* Can be implemented
* Consistency
* Conceptual Integrity
* API Evolution

## API Design is&hellip; The Art of Making Decisions

* API designers must choose from many alternate/possible design options
  * Use rubrics or decision procedures
  * Record and measure outcomes
* Knowing when applying a pattern is the right decision&hellip; and knowing when it is not
  * CRUDL &#124; HATEOAS &#124; REST vs. RPC vs&hellip;
* [Naming things](https://netapinotes.com/the-necessity-of-naming-in-apis/)
  is a good summary of one set of decisions that impact API design

## On AI

* [Aboard "Startup Year in Review" podcast](https://aboard.com/podcast/startup-year-in-review/)
  * Everybody thinks everybody else's job is easy.
* [Aboard "Don't Let the Robots Get You Down" podcast/](https://aboard.com/dont-let-the-robots-get-you-down/)
  * "&hellip; maybe Anna Indiana represents the first steps towards some sort of AI pop star. Maybe she could write a better song. Maybe she could be 50% good instead of 100% horrifying. But what I wish I could get across to our friends in the Palo Alto area is that the last 20% is really, actually, hard&mdash;not just in tech, but in writing, music-making, carpentry, middle-school teaching, cobbling&mdash;it's a grind."

## On AI (continued)

* Current AI technologies (generative AI, Large Language Models (LLMs) rely heavily on _**Tons o' Training Data**_&trade;
* What APIs will you use to train your API Generating AI?
  * Are the decisions made when creating those APIs correct?
  * Does the training data fit your domain?
  * Do those APIs solve similar problems?
  * Do styles match your developers' needs?
* Was your AI trained on poor API designs like Pet Store or
  [crAPI](https://owasp.org/www-project-crapi/) &hellip; or worse? How do you
  know? How do you continue to know?
  * [Pet Store API - Just Say No!]({{'/2024/04/01/pet-store-api-just-say-no'|relative_url}})

## On AI-Generated API Designs

* An API Designed by an AI trained on _**Tons 'o [Open Source] Training Data**_&trade&hellip;.
* Is an API Designed by Crowdsourced Committee

## API generating robots breathing down your neck?

* Having an AI write your API definition is like pushing a horse with a rope&hellip;.
  * API design through Prompt Engineering
  * An AI is not (yet) going to challenge requirements that are poor or not articulated well
  * To succeed, and AI needs to participate in PR reviews and other human feedback - perhaps this requires true artificial general intelligence (AGI)
* We have to be (can be) better than the AI
* We have to do the first 20% and the last 20% that are hard

## Good APIs&hellip;

* Are "Frustration Free Packaging"
* Obvious, Comprehensible, and Intuitive - an Open Book
* Reveal their intent (self-explanatory)
* Direct Mapping of the problem domain
* Use the domain terms to increase comprehension
* Lead to correct and efficient solutions
* Are a joy to work with
* Can be Beautiful and Elegant and Pragmatic - highly usable

![alt text]({{ '/assets/img/frustration-free-packaging.png' | relative_url}})

## Hope

We are not alone in feeling our place and our passion for creating great APIs is threatened.

A couple generations ago, computer scientists could have feared the next
generation of computer scientists that would follow them, a new
generation that might replace them.

Instead of cowering or quitting, they chose to build the software and
write the great papers and books that passed on what they had learned,
so that the field would continue to thrive.

(I have listed below some of my favorite books that shaped me as a computer scientist/programmer/technologist)

* [Structure and Interpretation of Computer Programs](https://web.mit.edu/6.001/6.037/sicp.pdf) (SICP) by Abelson, Sussman and Sussman
* [The Design and Analysis of Computer Algorithms](https://doc.lagout.org/science/0_Computer%20Science/2_Algorithms/The%20Design%20and%20Analysis%20of%20Computer%20Algorithms%20%5BAho,%20Hopcroft%20&%20Ullman%201974-01-11%5D.pdf) by Aho, Hopcroft and Ullman
* [G&#246;del, Escher, Bach: An Eternal Golden Braid](https://philosophygeek.medium.com/why-g%C3%B6del-escher-bach-is-the-most-influential-book-in-my-life-49d785a4e428) (GEB:EGB) by Douglas Hofstadter
* [The C Programming Language](https://courses.physics.ucsd.edu/2014/Winter/physics141/Labs/Lab1/The_C_Programming_Language.pdf) by Kernigan and Ritchie
* [Common LISP: The Language](https://www.cs.cmu.edu/Groups/AI/html/cltl/cltl2.html) (CLTL) by Guy Steele
* [Design Patterns: Elements of Reusable Object-Oriented Software](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612) (GOF) by Gamma, Helm, Johnson, Vlissides
* [Refactoring: Improving the Design of Existing Code](https://martinfowler.com/books/refactoring.html) by Martin Fowler
* [Principles of Compiler Design](https://en.wikipedia.org/wiki/Principles_of_Compiler_Design) (The "Dragon Book") by Aho and Ullman

These intelligent people made human decisions to continue, to pass on their knowledge to the next generation. They stood as giants so we could stand on their shoulders. I hope they inspire us to do the same


## Other resources

One of the best news/podcast episodes I've listened to on AI and tech is
the
"[Will AI Save the Internet? Or Break It?](https://www.nytimes.com/2024/04/05/opinion/ezra-klein-podcast-nilay-patel.html)"
episode of the
[Ezra Klein Show](https://www.nytimes.com/column/ezra-klein-podcast),
featuring Nilay Patel

<hr>

<a id='footnote-1'/><a href='#footnote-1-ref'><sup>1</sup></a>
Not a "representation" in the REST sense :-)

{% include discuss.md %}

{% include orig.md %}
