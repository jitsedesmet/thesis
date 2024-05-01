#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Preface

== Introduction

The Web has become a primary driver for economic, scientific, and societal progress.
This Web was envisioned as a globally interconnected decentralized information space
against which anyone can read and write information.
However, today's Web has become increasingly centralized,
as most of the data is centralized in a few large data stores
which are in full control of massive companies such as Amazon and Google.
//
This centralization of data on the Web leads to a number of problems,
such as privacy-related issues as *people are not in control of their own personal data*~@bib:verborgh_timbl_chapter_2023.

To solve these problems caused by data centralization,
various initiatives are working towards _re-decentralizing_ data on the Web,
such as Solid~@bib:solid, Bluesky~@bib:bluesky, Mastodon~@bib:mastodon,
and various blockchain-based initiatives~@bib:nakamoto2008bitcoin.
These initiatives allow people to choose where their data is stored,
either in personal data vaults~@bib:solid, shared federation instances~@bib:mastodon, or publicly~@bib:nakamoto2008bitcoin.
// Could cite: https://www.cnbc.com/2022/11/04/web-inventor-tim-berners-lee-wants-us-to-ignore-web3.html or https://www.techtarget.com/whatis/feature/Tim-Berners-Lees-Solid-explained-What-you-need-to-know
Blockchains are not considered a viable data management system because all records are public, and the computational cost is huge.
They were also never intended for data management, rather they serve the purpose of a distributed ledger.
// They are seeing increasing adoption
Recent privacy scandals and emerging legislation such as @gdpr and @ccpa
are leading to increasing adoption of these decentralization initiatives.
Various companies and organizations world-wide are starting to build products and services on top of decentralization techniques, specifically solid,
such as _BBC_ (UK), _Digita_ (Flanders) and _Inrupt_ (USA).
// Introduces more complexity compared to centralized mgmt. (also large number of sources!)
The *fundamental shift* from centralized data management comes with various challenges.
The solid community tries to tackle these challenges through a specification.
Interestingly, a rather unexplored domain is that of writing data.
In this thesis, I will explore how we can *abstract data updates*, with a focus on solid. 

== Problem Statement

Solid can theoretically be described as a permissioned decentralized data store.
This large data store is split into many different pods that are individually governed.
Contrary to widely used NoSQL databases, solid does not create shards over these pods.
Instead, when a pod is experiences network partitioning, solid accepts that the data on that pod is not reachable.
This works because the underlying linked data principles always assume an open world principle,
meaning that when data is not found, it doesn't conclude that it does not exist.
Solid also deviates from blockchain because of this, nodes do not contain all data of the system, but only a fraction.
Additionally, access control, and even usage control are of great importance to solid.

Much research has been done as to how we can efficiently read from these pods.
This research asks both how to answer a query as completely as possible over different pods, and also how to query a single pod efficiently.
Solid currently describes only a single interface type, @ldp.

The idea of @ldp is to map a simple, common file structure to a linked data interface over @http.
The interface allows simple server implementation and limited computational overload for servers.
This means that all required intelligence comes from the client.
To relieve application developers from needing to write complex software to communicate with these pods, we use packages. These help developers though a linked data querying @api, commonly called a query engine.

These query engines already allow developers to query pods efficiently.
Through a technique called link traversal querying, a developer can give the root path of a solid pod and query the whole pod.
Speed-ups can be gained by incorporation the structure of the pod in the query evaluation.
This structure can be described through different vocabularies, examples include, Type Index, Shape Trees, @void, @tree and @ldes.

A pod can thus be structured, and since @ldp maps to a file system, everyone, from data consumer, data producer and data owner, benefit from a good structure.
Unfortunately, as of currently, there are no automated clients that infer where to store a resource in a way that does not break the structure.
Developers that want to write data to a pod thus need to have numerous checks in place, and often times, either break the structure, or store their data in a hard-coded location and then alter the structure.

In this thesis, I look at how we can create a query engine that can infer where a resource should be stored in a solid pod in an application-agnostic way. This scope of this thesis is limited to solid and the @ldp interface.


== Research Question

The research question for this thesis is:
*How can we abstract data updates over a document oriented interface of a permissioned decentralized behind a query abstraction layer?*
We quickly go over the different terms in that question.
- Abstract data updates: We aim to abstract the query process, so a developer does not need to interact with the pods interface themselves.
- Document oriented interface: the interface we interact with exposes data through @http resource in plain text.
- Permissioned: each @http resource has access rights configured, rights can target specific actors or everyone.
- Decentralized: each pod is self governed and limited rules apply to the system, a loosely defined systems data publisher to be opinionated. 
- Query abstraction layer: we want the abstraction to happen through a declarative query. We will use the @sparql query language.

== Hypotheses

// Can we do it without a large cost?
Our hypothesis is that we can create an automated client capable of deciding where to store a resource given a pod.
We hypothesize that the overhead such an intelligent client has, in comparison to a client that is not smart, is limited.
Concretely, we expect a maximum overhead of four times slower, double the @http requests.
For applications that do not write too often, this is an acceptable overhead for the amount of complexity it takes away from developers.

== Outline

#todo[describe outline when we are done]