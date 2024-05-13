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
The consensus has thus been that we should just make sure most results are received fast through link prioritization, that way we can set a timeout and assume no results would be found after a time. 
Recent work that uses completeness guarantees and the structured nature of some interfaces has shown that it is possible to speed up queries and be complete to a certain extent @bib:taelman-structure-assumptions.

That early work uses type indexes to get structural descriptions, but the complexity could be increased to use shape trees or even @sgv we proposed.
@sgv can prove to be more valuable than shape trees in this context because it expresses the underlying data flow better.
For example, a collection that is derived from another should not be consulted if the canonical container has already been consulted.

== View Creation and Discovery

The issues related to the document-based nature of the current Solid specification that have been described @bib:whats-in-pod can be solved by creating derived resources~@bib:vanherwergenderived.
The work by #cite(<bib:vanherwergenderived>, form: "author") shows that derived resources are a way forward.
Their work proves that the implementation of the @sgv derived collection is feasible.
In that work, they solve the issue of access control granularity.
We could however also implement a smart server that, knows what optimizations are possible by query engines and creates resources dynamically to facilitate their execution.
The resources to create could be based on the usage metrics the server has.

// Incermunica? 

== Smart Access Control



== SGV Tree Integration

== CRDT Integration

// Transaction hier ook nog mentionen?