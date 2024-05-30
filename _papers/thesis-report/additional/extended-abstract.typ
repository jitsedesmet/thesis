#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "../raw/consts.typ": *

// multiple bibliography issues: https://github.com/typst/typst/issues/1097
// And title scope undesired... would scope titles
// -> We will use a pdf concat :/
// https://github.com/typst/templates/blob/main/charged-ieee/lib.typ

// #set document(title: title, author: "Jitse De Smet")
#set text(font: "Times New Roman", size: 10pt)
#set page(paper: "a4", margin: (bottom: 1.78cm, top: 1.78cm, left: 1.3cm, right: 1.3cm))
#set raw(syntaxes: ("../utils/turtle.sublime-syntax", "../utils/sparql.sublime-syntax"))

#show heading: set text(size: 10pt)
#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): set text(features: ("smcp", "c2sc"))
#set heading(numbering: (..numbers) => {
  let level = numbers.pos().len()
  if (level == 1) {
    return numbering("I.", numbers.pos().at(level - 1))
  } else if (level == 2) {
    return numbering("A.", numbers.pos().at(level - 1))
  } else {
    return numbering("1.", numbers.pos().at(level - 1))
  }
})
#show heading.where(level: 1): it => {
  if it.level == 1 {
    if it.body in ([Acknowledgements], [References]) and it.numbering != none {
      heading(numbering: none, it.body)
    } else {
      it
    }
  } else {
    it
  }
}

#show figure.where(kind: "table"): set figure.caption(position: top)
#show figure.caption: set align(left)
#show figure.where(kind: raw): set figure(kind: image)

#set enum(numbering: "1.i.")
#set figure(placement: auto)

// Title
#[
  #set text(size: 24pt)
  #set align(center)
  #title
]

// Authors
#[
  #set align(center)
  Jitse De Smet#footnote(numbering: it => [])[
    #show: columns.with(2, gutter: 12pt)
  J. De Smet is a master student with the KNowledge On Web Scale team within IDLab, Ghent University (UGent), Gent, Belgium.
  Email: #link("mailto:jitse.desmet@ugent.be")[jitse.desmet\@ugent.be]
  ]
  #counter(footnote).update(0)

  Supervisors: #supervisors.join(", ")
]


#show: columns.with(2, gutter: 12pt)
#set par(justify: true, first-line-indent: 1em)
#show par: set block(spacing: 0.65em)

// Abstract

#[
#set text(size: 9pt)
  _Abstract_ - *#abstract-text*

  _Keywords_ - #keywords.join(", ")
]

// The extended abstract has a standard length of minimum 2 and maximum 6 pages.

= Introduction

Data in today's web is increasingly captured in huge data silos.
The extent of these silos is enormous, reaching the limits of what is societal and legislative permitted. 
From a societal perspective, these silos are a giant threat to the privacy of users.
This centralization of privacy causes social turbulence, since it centralizes the attention of the masses and thus media control into a select few. 
Luckily, legislative measures have been taken to protect society from this centralization~@bib1:gdpr @bib1:ccpa.
As a response, centralization technologies are being developed, such as Solid~@bib1:solid, Bluesky~@bib1:bluesky, Mastodon~@bib1:mastodon and various blockchain-based initiatives~@bib1:nakamoto2008bitcoin.

The Solid initiative achieves centralization by creating a standard building on top of existing Web standards.
This approach allows for interoperability and easier workflow adaptation by leveraging existing expertise.
Nevertheless, the re-decentralization of the Web comes with various challenges ranging from efficient and effective read and write operations, to expressing and enforcing access and usage control policies.
Reading data in this context has already gained some scientific attention @bib1:hartig2016walking @bib1:taelman-structure-assumptions, but effectively writing data remains rather unexplored.

Data decentralization initiatives such as Solid and Bluesky decentralize data by providing each user with a data store governed by the user.
Users are in control of their data store, how they interact with the datastore and who they share their data with.  
The effectiveness of reading data in a decentralized environment has been increased by abstracting data reads through a query abstraction layer, the query engine, by using query languages like GraphQL~@bib1:graphql and SPARQL~@bib1:sparql.
In this work, we will similarly research how we can abstract data updates by using a query abstraction layer.
The current (draft) Solid specification~@bib1:solid-spec describes each data store, or pod, as a document oriented interface where a user decides for each document who can access that document.
Our goal is thus to create a query engine that effectively decides what document a resource should be stored in. Easily eliminating the access-path data dependency.
We hypothesize that such a query engine has a 2x overhead in the number of HTTP requests and a 4x overhead in the execution time compared to a query engine that requires the user to configure the document explicitly. Such an overhead is acceptable since write speeds are, in contrast with read speeds, often not critical.  


= Related Work

// Solid uses RDF & LDP 
The Solid specification~@bib1:solid-spec builds on top of existing Semantic Web technologies such as RDF (Resource Description Framework)~@bib1:rdf and LDP (Linked Data Platform)~@bib1:ldp.
LDP is a set of rules that is used to create a document oriented interface acceptable through HTTP.
Such an interface essentially exposes a file system over HTTP, it creates directories, called Containers,
that group together data documents and directories.
Each of the exposed HTTP resources has their own access control policy declared through either WAC~@bib1:wac or ACP~@bib1:acp.

== Concise Bounded Description
In this work, we will try to store RDF resources, defined as the CBD (Concise Bounded Description)~@bib1:concise-bounded-description of a Named Node.
The CBD of a resource is defined as the collection of triples that can be accessed by recursively following objects, without following named nodes.
As an example, @fig1:rdf-example contains some RDF data in turtle~@bib1:turtle format, taking the CBD of named node `<me>` results in @fig1:cbd-example. 

#figure(
text-example(
```turtle
@prefix ex: <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
<me> a foaf:Person ;
  foaf:givenName "Alice" ;
  foaf:knows ex:Bob, ex:Carol ;
  foaf:knows [
      foaf:givenName "Dave"
    ] .
ex:Bob
  foaf:givenName "Bob" ;
  foaf:familyName "Builder" .
```
), caption: [An example RDF file.]
) <fig1:rdf-example>
#figure(
text-example(
```turtle
@prefix ex: <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
<me> a foaf:Person ;
  foaf:givenName "Alice" ;
  foaf:knows ex:Bob, ex:Carol ;
  foaf:knows [
      foaf:givenName "Dave"
    ] .
```
), caption: [The CBD of named node \<me> in @fig1:rdf-example.]
) <fig1:cbd-example>

== Resource Descriptions
RDF datastores, and by extension, Solid pods, are schemaless. This means that data contained does not follow a specific, rigid format unlike a relational database.
In the context of Big Data, this is beneficial because defining a schema that should be followed by all actors that write data is impossible, since both the actors, and their way of working constantly changes.
Data consumers might expect data they consume to follow a certain format.
Shape descriptions describe the format of data and can be used to validate that data indeed follows the expected format.
Two RDF shape description languages are important, ShEx~@bib1:shex and SHACL~@bib1:shacl.
A self-descriptive declaration of ShEX can be found in @fig1:shex-example.
We do not provide a similar example for SHACL since its syntax uses turtle. This is more verbose, but the predicate names are self-describing. 

#figure(
text-example[
```
# our EmployeeShape reuses the FOAF ontology
# An <EmployeeShape> has:
<EmployeeShape> {
# at least one givenName.
  foaf:givenName xsd:string+,
  foaf:familyName xsd:string, # one familyName.
  foaf:phone IRI*, # any number of phone numbers.
  foaf:mbox IRI # one FOAF mbox.
}
```
  ],
  caption: [Self-explanetory example ShEx shape.]
) <fig1:shex-example>

// Pod descriptions (Type Index & Shape trees) -> Why do we need SGV?
== Storage Organization Descriptions
Just like RDF does not define its data schema, so does LDP not define its data organization.
As a result, someone reading a pod does not know where it can find the data relevant to them.
However,  just like RDF data can be described using a resource description, so can an LDP interface organization be described.
Solid proposes two ways of describing a pod: Type Indexes~@bib1:type-index and Shape Trees~@bib1:shape-tree.
The Type Indexes specification was a first attempt at describing the resources of a Pod. It describes the use of a public and private index over the `rdf:type` predicate.
The construction of a public and private index is, however, fundamentally flawed since resources cannot be grouped into either public or private because more complex access control is the norm.

Shape Trees are the proposed replacement of Type Indexes.
Type Indexes were limited to creating indexes based on the type predicate. As an improvement Shape Trees index is based on some Resource Description.
Moreover, Shape Trees are the natural extension of these resource descriptions to resource hierarchies.

In the context of read queries, it has been proven that using the structure of a pod
by, for example, consulting the type indexes can be beneficial~@bib1:taelman-structure-assumptions.
It thus makes sense to speculate that a similar structural description can help write queries.

= Storage Guidance Vocabulary

Unfortunately, neither Type Indexes~@bib1:type-index, nor Shape Trees~@bib1:shape-tree are sufficiently descriptive to assess whether a resource should be stored in a document.
As an example, we give a small list of questions that cannot be answered by either data store descriptions:
+ What if multiple directories match? Do I duplicate the resource?
+ What should I do if no documents match?
+ How are resources grouped?
  + Can I infer that resources grouped by a property are always grouped by that property?
  + Does that mean that if I get a new object for that property that I can just create a new document?
+ What should I do when I update a resource?
  + Should I alter the data store description? 
  + Should I move the resource? (Assign a new named node?)
+ Are all clients equal? Do they all abide the structural information description?

To answer these questions, we developped a new vocabulary, namely, the Storage Guidance Vocabulary (SGV).
The basic concepts of the vocabulary are:
#[
  #set list(marker: "", indent: 0cm, body-indent: 0cm)
  - *Resource Collection*: Corresponds to a group of RDF resources.
  - *Unstructured Collection*: Corresponds to a classical LDP container or HTTP resource.
  - *Structured Collection*: A canonical or derived collection. (below)
  - *Canonical Collection*: A resource collection containing resources.
  - *Derived Collection*: A resource collection that stores resources already stored by one or more other structured containers.
  - *Resource Description*: A way of describing resources, for example through ShEx or SHACL.
  - *Group Strategy*: A description of how resources should be grouped together, for example: my images are grouped per creation date.
  - *Store Condition*: When multiple collections are eligible to store a resource, the store condition decides what collection(s) actually store the resource. Allowing the creation of a store priority system.
  - *Update Condition*: Describes what to do when a containing resource is changed.
  - *Client Control*: Describes the amount of freedom a client has when trying to store a resource.
]

== Flow: Create Resource

To clarify the different concepts, we will walk through an example flow to create a resource.
@fig1:example-insert shows a query that would trigger this flow.
The query engine will essentially discover what URI should be used as a base.
To do so, it goes through the followings steps:
+ The client gets the SGV description of the storage space (can be cached).
+ The client checks all canonical collections and checks if the resource to be inserted matches a resource description of the collection.
+ If the resource matches a description, the client checks the store condition of the description given the eligible collections.
+ For each collection that stores the resource:
   + The client checks the group strategy of the collection and groups the resource accordingly, deciding on the name of the new resource.
   + The client checks the collections that are derived from this collection.
        Step 4 is executed for all collections that are derived from this collection, and the resource matches the description.
+ The client performs the store operation.

#figure(
text-example[
```SPARQL
INSERT DATA {
  <> a ns1:Post ;
    ns1:content
      "I want to eat an apple." ;
    ns1:creationDate "2024-05-08T23:23:56Z"^^xsd:dateTime ;
    ns1:id "416608218494388"^^xsd:long ;
    ns1:hasCreator card:me ;
    ns1:hasTag tag:Austria ;
    ns1:isLocatedIn resource:China .
}
```
], caption: [Example resource insertion query]
) <fig1:example-insert>

== Flow: Update Resource

Creating a resource is, of course, only one facet. Now we will look at the flow of updating, or similarly, deleting data.
@fig1:example-update shows an example update query that would trigger an update flow:
+ The client gets the SGV description of the storage space and the HTTP resource containing the updated RDF resource.
+ The client virtually constructs the resource that would result from the requested operation.
+ The client checks the update condition of the original matching resource description. The following action depends on the update condition.
    Typically, the update-condition will say whether an RDF resource is moved or not.
    + Move required: remove the existing resource and follow the steps described in the create resource flow.
    + No move required: just update the resource as requested by the user.

#figure(
text-example(
```SPARQL
DELETE {
  ?id ns1:id "416608218494388"^^xsd:long .
} INSERT {
  ?id ns1:id "416608218494389"^^xsd:long .
} where {
    BIND(:416608218494388 as ?id)
}
```
), caption: [Example resource update query]
) <fig1:example-update>


#todo[Skipping Details and use cases! -> \@RT: is it worth adding more given the 6p limit?]


= Evaluation
To verify our hypothesis, we implemented an SGV aware query engine and benchmarked it
#footnote[Both the implementation, and the benchmark are available at:\ #link(thesis-code)[#thesis-code]].
The provided implementation does not implement all features of SGV, but provides a sufficient implementation to verify the hypothesis.
Our hypothesis is two-fold. We want to verify both the HTTP-request overhead and the execution time overhead.
The former will be evaluated theoretically as it provides more insights into the system. The latter, on the other hand, will require an empirical evaluation.

== Theoretical Evaluation
Depending on the operation, a different number of HTTP requests is required.
We will analyse three different cases:
#inline-enum[
+ creating a resource,
+ updating a resource, but not moving it, and
+ updating a resource and moving it.
]

=== Creating a Resource
The creation of a resource requires the client to fetch the SGV description.
Assuming the description is located in a single file, this amounts to one HTTP request.

After getting the description, the client computes the location the resource should be stored.
When done, the client performs another HTTP request to store the resource there.

Our hypothesis holds for this operation, since a client not using SGV would require but one HTTP request, namely to create the resource.

=== Updating a resource, not moving it

In the case of updating a resource, we need to both get the SGV description and the original resource.
Getting both resources can, however, be done in parallel.

A client will now compute whether the resource should be moved, and conclude it need not be moved.
The client will thus perform another request to update the HTTP resource it just received.

In total, this amounts to tree HTTP requests.
A non-SGV aware client would require two HTTP requests,
one to get the original resource in order to create its binding, and one to perform the update.
The hypothesis thus holds true.

=== Updating a resource, moving it

In case a move is required, an SGV engine would do the same steps as before, but when updating the resource, it would need two (parallel) HTTP requests.
One to delete the original and one to create the new one. Resulting in four HTTP requests.
A non-SGV query engine would require at least three HTTP requests to achieve the same result, two of which can also be parallelized.
This thus verifies our HTTP requests count hypothesis.

== Empirical evaluation

#let solidbench = "https://github.com/SolidBench/SolidBench.js"
For our empirical evaluation, we benchmark our SGV-aware engine using SolidBench
#footnote[#link(solidbench)[#solidbench]].
This exposes pods containing LDBC Social Network Benchmark (SNB)~@bib1:ldbc data.
We created four pods with their own way of organizing social media posts:
#inline-enum[
+ organizing all posts in a directory with a file for each creation date,
+ organizing all posts in a directory with a file for each creation location,
+ organizing all posts in a directory with a file post, and
+ organizing all posts in one file.
]

These organization structures are then evaluated using queries that test five different choke points:
#inline-enum[
+ creating a resource,
+ updating a resource, not modifying it,
+ updating a resource, moving it,
+ performing an illegal update, and
+ deleting a resource.
]

From these evaluations, we concluded that our hypothesis holds for all choke points except one.
An SGV-aware query engine evaluating a query that does move the resource is slower than the same query evaluated by a non-SGV aware engine.
Note that the other engine does not move the resource, and that a SPARQL query has no way of expressing a resource move because it cannot express the CBD.

We can thus conclude from our benchmarks that the hypothesis holds only in case the SGV-query behaviour could be expressed using a SPARQL query.


= Future Work

To our knowledge, this is the first effort of abstracting data updates over a document-oriented interface of a decentralized permissioned environment.
As such, there is a plenty of future work.

== Inter-Pod updates

In this work we reduced the complexity by assuming that we want to update a single pod.
Of course, updating multiple pods with a single query is a logical next step where different considerations need to be taken into account.
+ As a pod owner, I want to transfer the pictures I have to someone else, so they now own that picture.
  Note that I am not guaranteed to have write permissions to the other Solid pod.
+ As a pod owner, I want to transfer a token to a pod I do, or do not, have write access to.
  The token should always exist _exactly once_, meaning there is always one person holding the token, and everyone can see who has it.
+ As a pod owner, I want to insert an additional property to an existing resource in someone else's pod.
  For example, I transferred a picture and forgot to add a description.
+ As a pod owner, I want to delete a property of an existing resource in someone else's pod.
+ As a pod owner, I want to remove a resource in someone else's pod, so I don't see it any more.
  Essentially, I want to change my view over the resource.
  This could be achieved by using the Subweb Specification~@bib1:subweb and adding a rule that makes me ignore the "virtually" deleted triple.
+ As a pod owner, I want to remove a resource in someone else's pod, so no one can see it.
  I might want to send a suggestion in a notification collection of the targetted pod.

== Other Interfaces

In this work, we investigate document-oriented interfaces, focussing on LDP.
With document-oriented interface, the question when inserting a resource is mostly: "Where do I store this resource?"
When using a different interface, that question might shift to "What other resources are linked to this new one, and though what links?"
There is merit in investigating different interfaces for the use of decentralized data storages, as document oriented interfaces come with drawbacks~@bib1:whats-in-pod.
Beyond the drawbacks listed there, much of the complexities of SGV are a result of the unordered, document oriented nature of SGV.
This non-descriptiveness, however, is at the benefit of the data provider, and thus it's unlikely that LDP will disappear.

Another interesting approach would be to create multiple interfaces on the same data, as an example one interface would serve as a SPARQL endpoint.
Another endpoint could be an LDP interface that derives collections based on the canonical collection that is the SPARQL endpoint.

== View Creation And Discovery

Derived resources have already proved to be beneficial to solve issues of LDP~@bib1:vanherwergenderived.
In our benchmarks, we see that the pod data organization heavily influences the execution time of queries.
The application exposing the data could infer what kind of resource organization would benefit clients through usage statistics.
The server could then decide to create a derived collection to enable faster query execution.

== Smart Access Control

Access control policies are currently created per document.
This makes access control difficult to understand, since it is not clear why a single document has a certain access policy.
SGV describes why and what data is stored in a certain document.
Configuring an access policy in a certain document can thus be translated to what kind of resources follow what policy.
Extracting policies based on the data can be useful when derived resources come into play.
For example, it could be inferred when you have access to some resource in a canonical collection, that you should also have access to that resource in a derived collection given no data enrichment happened when the derived resource was created.

== Update Behaviour

In this work we created a client that autonomously created an RDF resource without requiring to specify a URI. 
To achieve this, we used a query engine that abstracts complex operations.
A query engine, just like any update API, has the power to choose where to position themselves within the CAP (Consistency, Availability, Partition tolerance) space~@bib1:cap. CAP essentially says you can only have two of three properties of {C, A, P} with the choice of a distributed system either being the ACID~@bib1:acid or BASE~@bib1:base properties.

When choosing the BASE properties, a user chooses to drop consistency.
One way of doing so is by creating CRDTs (Conflict-free Replicated Data Types)~@bib1:crdt.
Essentially, when multiple people are using the same resource, they will all have their own local copy of the resource.
When the resource is edited, a CRDT will edit the local copy and synchronize the state later.
This means that the user does not always have the latest state of a resource, thus sacrificing consistency.
When synchronizing the resource, however, the synchronization should not just undo changes made by others.
Instead, both changes should be considered when updating the canonical resource.
A query engine that implements a CRDTs helps developers to create faster software.

Another approach is to choose the ACID properties.
These properties are widely used in the form of relational database transactions.
They are not only expected by developers, but many applications are unable to operate without the consistency guarantees ACID brings.
We therefore believe that we should examine the possibility of ACID transaction within the decentralized data storage research.
This does not mean that we completely drop the availability property, as the inventors of the CAP theorem later describe~@bib1:continous-cap.
Furthermore, we believe that within the CAP space, Web technologies take on an interesting position.
Namely, the Web intentionally does not break when links do~@bib1:links-can-break.
in the context of distributed data spaces, this means that when a data store is unavailable, so is the data managed by that store.
This is in sharp contrast to a distributed database that duplicates data across many nodes so that all data remains accessible when a node goes offline.
Related to the CAP theorem, that means that data spaces do not have strong Partition Tolerance requirements, allowing us to devote more attention to consistency and availability.

= Conclusion
// Small resume
In this work, we presented a vocabulary that allows smart clients to autonomously discover the location a created or updated resource should be stored within a document oriented decentralized interface of a permissioned decentralized environment.
The vocabulary also introduces checks on whether a resource can be created or removed.
Additionally, we proved that our vocabulary is indeed expressive by implementing a smart client that consumes it.

We hypothesized that such a smart client would be a maximum of four times slower and would require a maximum of double the amount of HTTP requests.
Through theoretical evaluation, we discovered that the amount of HTTP requests is within those bound.
Using empirical evaluation, we also validated that the execution time overhead is within the accepted range.
Moreover, we saw that some of SGVs behaviour cannot be modelled using a SPARQL query.

// Questions to myself
In essence, SGV tries to provide structure to a widely unstructured document store, namely LDP.
It does this by defining a server-side description of the structure that should be enforced by clients.
In reality, clients can still interact with the data store however they want, since the server is not aware that a structure should be followed.
This lack of server-side verification is perhaps the biggest shortcoming of this work.
That being said, it is entirely possible to extend an existing data store server with an SGV verification system.
The downside at that being that both the client and server need to calculate the proposed location of a resource.
Unfortunately, this is a shortcoming of choosing for a low-complexity server, only to later conclude you want to assert complex guarantees.
Additionally, since one server interface is used by many decentralized clients, it becomes almost impossible to guarantee a system that respects the structure of a permissive interface without creating server-side validation.

= Acknowledgements

#acknowledgements

= References

#[
  #include "../utils/EA-bib.typ"
]

// #bibliography(title: none, "../items.bib")

