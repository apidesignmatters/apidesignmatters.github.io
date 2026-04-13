---
title: What is the Meaning of This?
date: 2024-01-11 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> Semantics is the key to successful API/AI integration

After 2023, "The Year of AI", I'd be insulting my valued readers if I claimed that the biggest change in APIs in 2024 will be anything but AI related... for me the question is how will AI impact APIs? I believe adding semantics (meaning) to APIs is the key to successful API/AI integration.

{% include language-of-api-design-series.md %}

![Banner image with text "What is the meaning of this?", "API Design Matters" and "David Biesack", on an abstract background.]({{
 '/assets/img/What-is-the-Meaning-of-This.png' | relative_url}})

Hey! This article is part of **#APIFutures**, a broad initiative started
in 2024 to connect many creators in the #API space. See [API Futures](https://matthewreinbold.github.io/APIFutures) for view many excellent perspectives on what the Future of APIs may hold!

![API Futures logo]({{'/assets/img/API-Futures-logo.png' | relative_url}})

There are three important aspects of the AI/API story to consider. The first is generating APIs with the help of an AI assistant. The second is using an AI assistant to generate client code to consume APIs to solve problems in client applications. The third is AI systems calling APIs directly on behalf of end users.

For all three to succeed, I believe APIs will need to convey _semantics_ &mdash; the meaning of the API.

### Semantics provide purpose

> That a `PUT`/`PATCH`/`DELETE` returns a 200 or a 204 is an implementation detail that pales in comparison to the function it performs for the client<br>
> &mdash; [OpenAPI Moonwalk](https://www.openapis.org/blog/2023/12/04/openapi-moonwalk-2024)

### I - Generating API Definitions

There are a number of excellent explorations of generating API definitions with AI assistants:

1. Matthew Reinbold has authored several Net API Notes articles:

    1.  _[What Happened When GitHub's AI Copilot Wrote My OpenAPI Description](https://netapinotes.substack.com/p/what-happen-when-githubs-ai-copilot)_
    2.  _[The Thing About Using ChatGPT for API Design](https://netapinotes.substack.com/p/the-thing-about-using-chatgpt-for)_
    3.  _[Sorry AI, APIs Are for Humans](https://netapinotes.substack.com/p/sorry-ai-apis-are-for-humans)_

2.  Bruno Pedro demonstratted _[API definition, including OpenAPI creation, with chatGPT](https://www.youtube.com/watch?v=-x1LCWE4XnA)_ in a YouTube video

An AI coding assistant (whether it is ChatGPT, Claude Code, Microsoft/GitHub CoPilot or something else) is doing what these LLM-based AI's do best&mdash;working from immense training data, parsing and interpreting natural language prompts, and "generating" text based on patterns gleaned from that data to satisfy the goals of the prompts. This means their output is biased towards the patterns "learned" from that training data. In my experience, the hardest part of API design is not the mechanical process of creating the OpenAPI source, but in interpreting the requirements&mdash;from the Product team or from business analysts&mdash;using a process similar the Align, Define, Design, Refine (ADDR) process that James Higginbotham outlines in his book, _[Principles Of Web API Design](https://www.oreilly.com/library/view/principles-of-web/9780137355754/)&mdash;_ and then _translating_ those domain design requirements into code. So unless you are looking for a Pet Store clone, with the resource names changed to match you domain entities, don't get your hopes up. However, I think that we (as "API prompt engineers") will soon learn how to best use such tools as coding assistants, even if they are only a few steps above a smart template engine or code snippet manager IDE extension.

For this aspect of AI/API integration to succeed, several things are necessary:

1.  **Better training data**. The Large Language Model need much better API definitions (most likely, those coded with the OpenAPI specification). Unfortunately, what is there now is not great - IMHO, Pet Store is a terrible "example" to start from, as it violates so many API design best practices I've learned from the experts over the past dozen years. And since so may tutorials and other material use it as an example, lots of APIs (in API catalogs or repositories like GitHub &mdash; i.e. the current training data) perpetuate those design flaws, skewing (polluting? corrupting?) the training data. This will likely get worse before it gets better if people start publishing new AI generated API definitions, leading to [model collapse.](https://www.techtarget.com/whatis/feature/Model-collapse-explained-How-synthetic-training-data-breaks-AI)

2.  **Better prompts**. This will come as we experiment with these AI systems and learn what works and what does not, and as the LLMs evolve. I'm intrigued to see how we as an API community learn to share such knowledge in this arena starting in 2024. Such "open source prompt" knowledge capture is a great opportunity to exploit. "Better prompts" really comes down to being able to express functional requirements in a way that the AI tool can parse and use to guide the code it generates. This sounds very much like past efforts to create [formal software specification languages](https://en.wikipedia.org/wiki/Specification_language) for describing requirements and software system behavior. I do not believe such systems have seen widespread adoption or success; perhaps applying AI to such system will reinvigorate the field. The main point is that we need to inject _**meaning**_ into the conversation to guide the tool toward the best outcome. I feel such coding assistants will be most successful if we can create better ways of clearly conveying intent and behavior/semantics. I suspect that using examples and scenarios/workflows (rather that abstract notation) will be most fruitful.

3.  **Good feedback loops**. If I were to start using an AI coding assistant, I would treat it as an untrusted/unproven junior developer. Only with good feedback from an expert will such systems improve their "API Authoring" skills. Mentors and senior developers and team leads use normal human interaction and communication to give feedback to mentees and junior staff. How one provides good feedback to an AI assistant is part of the chat/conversation/interaction flow. Truly excellent AI assistants will mimic the organic intelligences in this regard and "learn" through similar feedback loops. I hope to see such tools worth with Git Pull Request comments. I don't know if a Generative AI (LLM) will be able to work in this way, or if that level of interaction requires something closer to Artificial General Intelligence.


We'll be successful if an AI never generates an OpenAPi document like [OpenAI's API](https://github.com/openai/openai-openapi/blob/manual_spec/openapi.yaml) for ChatGPT which has this glaring inconsistency:

```
openapi: 3.0.0
info:
  title: OpenAI API
  description: The OpenAI REST API. Please see
    https://platform.openai.com/docs/api-reference for more details.
  version: 2.3.0
...
servers:
  - url: https://api.openai.com/v1
```

You tell me &mdash; is the "OpenAI API" version `.../v1` or is it `version: "2.3.0"`? Either way, this looks like a very human-like mistake.

This API definition, residing in a GitHub repository, is a likely candidate for OpenAPI training data, so don't be surprised when Generative AI API coding assistants emit similar inconsistencies.

## II - Generating Client Code to Consume APIs

Aspect II of the AI/API integration question is _**using an AI assistant to generate client code to consume APIs to solve problems in client applications**_. I think this is where we will see the first successes. However, in order for AI-based tools to succeed here, we have to see API definitions provide (encode) more semantics and meaning, compared to the syntax-oriented approach we have today. That is, OpenAPI et al focus on the _mechanical/lexical_ aspect of API design (HTTP verbs, URL paths, query and head parameter definitions, request/response body structures defined with JSON Schema). Thus, OpenAPI is great at defining the _signature or contract_ of an API, but not great at defining _what the API actually does_ or _why one should use the API_. Such information gets pushed into the `info.description` or operation `description` strings in the API definition as Markdown prose.

How will a Generative AI Coding Assistant use an OpenAPI definition to guide the generation of API client code? It needs to understand the programmer's goals and intent (gleaned from the prompts or conversation). It then needs to be able to discover APIs that meet the needs (unless the prompt is very specific on which APIs to use) and which operations to invoke and what data to pass, and how to process the responses and map them to client state.

Some of this "knowledge" or understanding of an APIs goals can be inferred from common patterns (several of which I've covered in API Design Matters), such as CRUDL resource-oriented APIs. I.e a `POST` operation with an `operationId` that begins with `create` and which includes a 201 Created response with a `Location` header provides several hints that the operation's purpose&mdash;its meaning&mdash;-is to create a new resource. But not all operations are quite as clear. This is where other semantic hints in the API definition can help not just an AI to "understand" the API, but humans as developers as well. I'm not sure what form such semantic hints will take.

Coding assistants for specific languages may be able to use generated language-specific SDKs for building client application code, since that is a more direct and natural fit for coding assistants which can "learn" programming tasks.

It may be that sufficiently rich `description` strings on operations and parameters and response will be sufficient for a powerful Generative AI, but I suspect not. Project Moonwalk (within the OpenAPI Initiative) [aims to address semantics in API definitions in OpenAPI 4 (Project Moonwalk](https://www.openapis.org/blog/2023/12/06/openapi-moonwalk-2024):

> **Semantics provide purpose**. It is not sufficient to describe the
> mechanics of an API without also describing its semantics, whether the
> consumer is a human or an AI. Semantics join the _what_ (what does
> this do?) and the _why_ (why does this matter?) to the _how_ (how does this work?).

The OAI is also developing the [Arazzo Specification](https://www.openapis.org/arazzo-specification), which will be a tremendous benefit for AI LLMs when it comes to understanding how APIs are used in larger contexts &mdash; beyond just a single operation.

> such a definition will be useful for understanding how to implement any dependent sequence of functional calls for any user of an API

I am very interested in both of these topics and how they evolve (which mean I need to get involved with the OAI...)

As above, I think it prudent to use such tools carefully &mdash; treat
the generated code similar to how you would treat code by a new junior
programmer (or even an intern) on your team. Review and inspect all such
code for correctness, suitability, security, etc.

## III - AI systems calling APIs directly on behalf of end users

Our final API integration aspect is the most risky endeavor because it lacks the governance or control systems (code review, static code analysis, etc) that software teams often build around code generation processes. However, it is likely to be the form of AI/API integration that gets the most buzz and perhaps the most funding... using an AI as an agent (working on behalf of people), for doing digital tasks in "the real world", such as making travel or entertainment reservations or even conducting financial transactions, via APIs for those services.

To safeguard you privacy and personal assets from API agents, I believe APIs need appropriate metadata&mdash;the analog of a `robots.txt` file&mdash;to inform AI agent consumers whether the API is appropriate for or suitable for use by AI Agents. For example, an API to control a medical device such as a Magnetic Resonance Image (MRI) or CT scanner is likely something that should not be put into under the control of an AI agent. Following a zero-trust model, the default should be a "no agent access allowed" setting unless a human deems it is safe an provides another less restrictive setting.

## Related Reading

### What is the meaning of "What is the meaning of this?" ?

I chose this title because of the connotation and association that
phrase may bring to your mind &mdash; the cliche is an adult authority figure
entering a chaotic situation, regaining control of things (and people)
running amok after exclaiming
"_**What is the meaning of this**_?".

My hope is that we as software professionals do not have to ask this question after API/AI integrations have run amok and caused irreversible damage. That is, we need to be the adults in the room and create the guardrails and controls so that AI and APIs can work well together, safely.

### llms.txt

See also [llms.txt](https://llmstxt.org/), "A proposal to standardise on
using an `/llms.txt` file to provide information to help LLMs (large
language models) use a website at inference time."

### ALPS

See also [https://mamund.substack.com/p/what-is-alps](https://mamund.substack.com/p/what-is-alps) by Make Amundsen; ALPS (Application-Level Profile Semantics). ALPS is (in the words of an AI :-) :

> a format created by Mike Amundsen for describing the semantics, or meaning, of an application's data and actions in a simple and reusable way.

{% include discuss.md %}

{% include orig.md %}
