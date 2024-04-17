#import "../utils/review.typ": *
#import "@preview/treet:0.1.1": tree-list

= Storage Guidance Vocabulary

#add[You could suggest addition], #delete[or deletion.]
We can refer to acronyms like: @oidc. It was long before, but now short @oidc.

To empower automated clients to correctly store resources, we suggest the usage of a descriptive vocabulary.
#MRT[Ruben makes margin note]
Existing structure definitions of data spaces like Type Index and Shape Trees focus on read queries and insufficiently support write queries.
These structure definitions fail to express the underlying decision-making of why a resource is stored where it is. 

We therefore introduce a new vocabulary, @sgv.
#IRT[Ruben makes inline note]
This vocabulary takes inspiration from the Shape Tree Specification, but does not extend it.
The vocabulary aims to express where and why a resource is stored in a location.
@sgv is created with a primary focus on @ldp interfaces.
We suggest an interface where @ldp containers can be structured.
A container marked as structured has a strict definition of where containing containers/resources are located.
We shortly introduce some basic concepts in @sgv:
#list(marker: "", 
[*Resource Collection*: Corresponds to an @ldp container.],
[*Structured Collection*: A canonical or derived collection.],
[*Canonical Collection*: A resource collection containing resources.],
[*Derived Collection* A resource collection that stores resources already stored by one or more other structured containers.],
[*Resource Description*: A way of describing resources, for example through @shex or @shacl.],
[*Group Strategy*: A description of how resources should be grouped together, for example: my images have are grouped per creation date.],
[*Save Condition*: When multiple collections are eligible to save a resource, the save condition decides what collection(s) actually save the resource.],
[*Update Condition*: Describes what to do when a containing resource is changed.],
[*Client Control*: Describes the amount of freedom a client has when trying to save a resource.]
)


== Flow: A client wants to create an RDF-resource <sec:flow-create-rdf-resource>

Inserts happen on a pod level, meaning you just specify to the client what pod you'd want to insert a resource to.

+ The client gets the @sgv description of the storage space (can be cached).
+ The client checks all canonical resources and checks if the resource to be inserted matches the resource description of the collection.
+ If the resource matches the description, the client checks the save condition of the collection given the eligible collections.
+ For each collection that is saves the resource:
   + The client checks the group strategy of the collection and groups the resource accordingly, deciding on the name of the new resource.
   + The client checks the collections that are derived from this collection.  
        Step 4. is executed for all collections that are derived from this collection, and the resource matches the description. 
+ The client performs the save operation.

#figure(
  image("../static/flow-rdf-create.png"),
  caption: [Flow: create RDF resource]
) <fig:rdf-create>

== Flow: A client wants to update an RDF-resource:  

An update can be both an insert to an existing resource, a change in values of a resource, or a deletion the whole, or part of a resource.
In case of an update, it's important that the client knows what resource will be updated.
This is similar to how queries are executed right now, where you should always specify the web resource to query over (excluding link-traversal clients).

+ The client gets the @sgv description of the storage space and the HTTP resource containing the updated RDF resource.
+ The client virtually constructs the resource that would result from the requested operation.
+ The client check the update condition of the collection the resource currently resides in. Following action depends on the update condition.
    Typically, the update-condition will say whether an RDF-resource is moved or not.
    + Move required: follow the steps described in @sec:flow-create-rdf-resource.
    + No move required: just update the resource as requested by the user.

#figure(
  image("../static/flow-rdf-update.png"),
  caption: [Flow: update RDF resource]
) <fig:rdf-update>

== Details

This section delves into the details of the @sgv.
@sgv is constructed with future expansions in mind, some missing features might thus be by other actors.
This behaviour is easy to add because of the open world property in linked Data.
In @fig:sgv-vocab-overview an overview of the different components can be consulted.
The figure can be used as a reference while reading the different sections.
There are three arrows used in the graph, each with a different meaning, visualized in @fig:sgv-vocab-overview-legend.
Firstly, a full arrow means that there is can be a triple `?a ldp:contains ?b`.
Secondly, the dotted link means that the destination has the same fields or more as the source.
Finally, a diamond shaped arrow entails a link from the source to the destination, specifically, the destination can be seen as a property of the source.

#figure(
  image("../static/sgv-graph-legend.png"),
  caption: [A legend explaining the links used in @fig:sgv-vocab-overview]
) <fig:sgv-vocab-overview-legend>

#figure(
  image("../static/sgv-graph.png"),
  caption: [Visualisation of the Storage Guidance Vocabulary]
) <fig:sgv-vocab-overview>


=== Resource Collection <sec:resource-collection>

An `sgv:resource-collection` is any @rdf resource that groups multiple @http resources together.
This grouping into a collection can be done in either an explicitly structured or unstructured way.

=== Unstructured Collection <sec:unstructured-collection>

An unstructured collection is a kind of resource collection (@sec:resource-collection),
that does not explicitly define its structure. 
This work's primary focus is to enable automated clients to perform insert queries over @ldp interfaces.
It might help to see the type `sgv:unstructured-collection` as equivalent to the `ldp:Container` type.

=== Structured Collection <sec:structured-collection>

An `sgv:structured-collection` is a resource collection (@sec:resource-collection) that explicitly describes its structure.
The collection defines a filter, each resource is compared against this filter.
If a resource passes, the resource is collected into the collection.
The collection later defines where the resource should be saved.
Where a normal resource collection can contain resources in a graph structure,
a structured container adds the important restriction of a tree.
It has been proven that this tree structure limitation heavily restricts the interface @whats-in-pod.

=== Canonical Collection <sec:canonical-collection>

A `sgv:canonical-collection` is a structured collection (@sec:unstructured-collection) that saves @rdf resources.
When entering a Solid pod, we check what canonical containers want to save the resource.
The collections then individually decide where to save the resource.

=== Derived Collection <sec:derived-collection>

A `sgv:derived-collection` is a structured collection (@sec:structured-collection) that duplicates,
or links to @rdf resources contained in some other structured collections.
When a structured collection inserts, updates or removes an @rdf resource, the collections that derive from that collection are informed to act accordingly.
A derived collection can be used to create collections know a multitude of use cases, some examples are:
- Create a collection of all pictures in my pod, even though I have multiple canonical containers managing pictures. 
- Create a restricted view of resources that I could then use to share with others.

=== Grouped Collection <sec:grouped-collection>

An `sgv:grouped-collection` is contained in a structured collection (@sec:structured-collection).
Grouped Collections are used to group resources in structured collections together to provide
additional structure and reduces cognitive load when browsing a collection.


#figure(caption: [Example group strategy], [
#block(breakable: false, width: 60%, inset: 10%)[
  #set align(left)
  #set par(leading: 5pt)
  #grid(columns: (50%, 50%), gutter: 10pt, [
    #tree-list[
     - pictures/
      - Valencia/
        - one.ttl
        - two.ttl
      - Ghent/
        - one.ttl
        - two.ttl
      - Paris/
        - one.ttl
        - two.ttl
        - three.ttl
      - missing.tl
    ] 
  ], [
    #tree-list[
     - pictures/
      - Valencia/
        - one.ttl
        - two.ttl
      - Ghent/
        - one.ttl
        - two.ttl
      - Paris/
        - one.ttl
        - two.ttl
        - three.ttl
      - missing.tl
    ]
  ])
]
])

=== Resource Description


=== Group Strategy


=== Save Condition

=== Update condition

=== Client Control

==== One File One Resource
The big advantage of LDP is that it easily maps to the file structure storage of POSIX file systems.
If someone wants to save their Solid Pods on their own machine, it's easy for them to access the data.
The one file one resource flag signals an LDP server that no @http
#link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Identifying_resources_on_the_Web#fragment")[fragments]
are present in the named nodes in this collection.
The server can therefore use soft-links or hard-links to reduce the data duplication. 



=== Retention Policy



// === Pitfalls of Shape Trees
// text
