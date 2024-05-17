#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Future Work

@sgv proves it is possible to create automated clients that can decide where to store resources.
In the state we present it here, it is not production ready, but it opens the gate to interesting research.

== Other Interfaces

This work focusses on @ldp exposed through a restful interface.
For such an interface, data is linked to newly created tuples through `ldp:contains` predicates.
When we don't use @ldp, or use a different kind of interface, the question we try to answer might shift from
"Where do I save this resource?" to "What other resources are linked to this new one, and through what predicates"?


There is merit to investigating different interfacing technologies because @ldp is far from perfect.
By nature, @ldp restricts data consumers @bib:whats-in-pod.
Even more so, much of the complexity of @sgv is resuired because of @ldp\s nature.
Nevertheless it is unlikely that @ldp completly disapears because the low server complexity makes it very attractive for data providers. 

Through @sgv, it would also be possible to create multiple interfaces on the same data.
You could for example expose the raw data graph of a pod through a @sparql endpoint.
The endpoint could then, for example, only be used by highly authorized users.
Another interface could be @ldp powered and be constructed based on an @sgv description of derived collections.
// Why do we want to move away? Like: what's in a pod

== Guided queries

// Intermediate work shows results?
Within the research around querying the semantic web is the link traversal approach is exciting.
Unlike federated querying where you define the sources to query over beforehand, link traversal will discover new sources while executing queries.
This comes with various difficulties, like safety issues~@bib:taelman-security, completeness modelled by completeness guarantees, and execution time.
There has been the assumption that we cannot reduce the execution time of a link traversal power query over the semantic web because of its enormous size.
The consensus has thus been that we should just make sure most results are received fast through link prioritization~@bib:hartig2016walking, that way we can set a timeout and assume no results would be found after a time. 
Recent work that uses completeness guarantees and the structured nature of some interfaces has shown that it is possible to speed up queries and be complete to a certain extent @bib:taelman-structure-assumptions.
That early work uses type indexes to get structural descriptions, but the complexity could be increased to use shape trees or even @sgv.
@sgv can prove to be more valuable than shape trees in this context because it expresses the underlying data flow better.
For example, a collection that is derived from another should not be consulted if the canonical container has already been consulted.

== View Creation and Discovery

The issues related to the document-based nature of the current Solid specification that have been described @bib:whats-in-pod can be solved by creating derived resources~@bib:vanherwergenderived.
The work by #cite(<bib:vanherwergenderived>, form: "author") shows that derived resources are a way forward.
Their work proves that the implementation of the @sgv derived collection is feasible.
In their work, they solve the issue of access control granularity.

In our empirical evaluation we discover that the execution time of our queries heavily relies on our pod structures (@sec:choke-new-resource).
We could however also implement a smart server that knows what optimizations are possible by query engines.
Such a server could create resources dynamically to facilitate query executions.
The resources to create could be based on the usage metrics the server has.

// Incermunica? 

== Smart Access Control

Both @wac and @acp don't allow users to create access control rules based on the @rdf content itself.
Since a long time, efforts exist to change this, one such effort is the #link("https://www.bergnet.org/people/bergi/files/documents/2014-02-14/index.html#/")[Universal Access Control] of Thomas Bergwinkl.
A motivation for disallowing these kinds of policies could be the rise in user complexity.
However, through the resource description formats like Shape Trees and @sgv, one could argue that we express what data is in a resource.
Therefore, we could extract an access control policy in function of the data based on the policy on the document.

Access control extraction could help create uniform access rules across multiple interfaces of the same pod in a way that feels familiar for users.


== SGV Integration with Existing Structure Ontologies

The vocabulary described in this work does not play nice with existing vocabularies.
Since @sgv is related to shape trees, it would make sense to adapt/ extend the vocabulary in such a way that it could be easily plugged into an existing shape tree environment.
This alternative structure would likely be less expressive.

#todo[link to Linked Data Event Streams in Solid LDP containers]

#todo[talk about shape trees and Tree and LDES]

== General Update Behaviour

The question we asked ourselves when starting this paper was: "how can we make updating solid pods easier?"
We ended up creating a base layer that allows query engines to decide how to store resources.
That was not the only possible way of making updates easier.
In this section, we list a few more possible improvements related to data updates.
May it inspire anyone to work on these challenging topics.

=== CRDT\s: The Eventual Consistency Approach

Through Solid, many applications are working on the same data and each application likely has their own cache in place.
As a result, applications working on the same data all have their own local copy of the data, essentially creating a distributed system.
It is important that one application does not just undo the work by another application.
A @crdt is a data type with the properties that essentially chooses for eventual consistency on the @cap scale.

=== ACID Transactions

Massive adaptation is the dream of any technology, but to achieve that, you need to be at least as good as the competition.
The largest competitor for data storage is the relational database offering the @acid properties.
Not only do developers expect these properties, many applications are unable to operate without these consistency guarantees.
We therefore advocate for research into stronger consistency guarantees in Solid.

Such a claim is not always well received, because of the @cap theorem that states that you can only have two out of {Consistency, Availability, Partition tolerance}~@bib:cap.
However, the choice is not binary, as later clarified by the writers of the @cap theorem~@bib:continous-cap.
Not only can the research decide in "how consistent" we want to be, we have a varying partition tolerance variable too!
Most distributed database systems replicate data across machines so that when one machine goes down, all data is still accessible, be it through other nodes in the system.
Solid does not have such a replication system in place.
When a single pod disconnects from the network, the data on that pod cannot be accessed until the pod connects to the network again.
We believe that this opens some space for research on stronger consistency requirements.

The decision of what point in the @cap space we work with need not be done at pod level, but could be done on @http resource level. For example, one @http resource might support @crdt\s essentially choosing for availability over consistency. Another resource might introduce some locking mechanism, choosing consistency over availability.

