#import "../utils.typ": MRT, todo, IRT, delete, add

= Storage Guidance Vocabulary

#add[You could suggest addition], #delete[or deletion.]

To empower automated clients to correctly store resources, we suggest the usage of a descriptive vocabulary.
#MRT[RT makes margin note]
Existing structure definitions of data spaces like Type Index and Shape Trees focus on read queries and insufficiently support write queries.
These structure definitions fail to express the underlying decision-making of why a resource is stored where it is. 

We therefore introduce a new vocabulary, the Storage Guidance Vocabulary (SGV).
#IRT[RT makes inline note]
This vocabulary takes inspiration from the Shape Tree Specification, but does not extend it.
The vocabulary aims to express where and why a resource is stored in a location.
SGV is created with a primary focus on LDP interfaces.
We suggest an interface where LDP containers can be structured.
A container marked as structured has a strict definition of where containing containers/resources are located.
We shortly introduce some basic concepts in SGV:
#list(marker: "", 
[*Resource Collection*: Corresponds to an LDP container.],
[*Structured Collection*: A canonical or derived collection.],
[*Canonical Collection*: A resource collection containing resources.],
[*Derived Collection* A resource collection that stores resources already stored by one or more other structured containers.],
[*Resource Description*: A way of describing resources, for example through ShEx or SHACL.],
[*Group Strategy*: A description of how resources should be grouped together, for example: my images have are grouped per creation date.],
[*Save Condition*: When multiple collections are eligible to save a resource, the save condition decides what collection(s) actually save the resource.],
[*Update Condition*: Describes what to do when a containing resource is changed.],
[*Client Control*: Describes the amount of freedom a client has when trying to save a resource.]
)


== Flow: A client wants to create an RDF-resource <flow-create-rdf-resource>

Inserts happen on a pod level, meaning you just specify to the client what pod you'd want to insert a resource to.

+ The client gets the SGV description of the storage space (can be cached).
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
) <rdf-create>

== Flow: A client wants to update an RDF-resource:  

An update can be both an insert to an existing resource, a change in values of a resource, or a deletion the whole, or part of a resource.
In case of an update, it's important that the client knows what resource will be updated.
This is similar to how queries are executed right now, where you should always specify the web resource to query over (excluding link-traversal clients).

+ The client gets the SGV description of the storage space and the HTTP resource containing the updated RDF resource.
+ The client virtually constructs the resource that would result from the requested operation.
+ The client check the update condition of the collection the resource currently resides in. Following action depends on the update condition.
    Typically, the update-condition will say whether an RDF-resource is moved or not.
    + Move required: follow the steps described in @flow-create-rdf-resource.
    + No move required: just update the resource as requested by the user.

#figure(
  image("../static/flow-rdf-update.png"),
  caption: [Flow: update RDF resource]
) <rdf-update>

== Details

This section delves into the details of the SGV.
SGV is constructed with future expansions in mind, some missing features might thus be by other actors.
This behaviour is easy to add because of the open world property in linked Data.
In @sgv-vocab-overview an overview of the different components can be consulted.
The figure can be used as a reference while reading the different sections.
There are three arrows used in the graph, each with a different meaning, visualized in @sgv-vocab-overview-legend.
Firstly, a full arrow means that there is can be a triple `?a ldp:contains ?b`.
Secondly, the dotted link means that the destination has the same fields or more as the source.
Finally, a diamond shaped arrow entails a link from the source to the destination, specifically, the destination can be seen as a property of the source.

#figure(
  image("../static/sgv-graph-legend.png"),
  caption: [A legend explaining the links used in @sgv-vocab-overview]
) <sgv-vocab-overview-legend>

#figure(
  image("../static/sgv-graph.png"),
  caption: [Visualisation of the Storage Guidance Vocabulary]
) <sgv-vocab-overview>

=== Unstructured Collection

=== Structured Collection


=== Resource Collection


=== Canonical Collection

=== Derived Collection

=== Grouped Collection


=== Resource Description


=== Group Strategy


=== Save Condition

=== Update condition

=== Client Control

=== Retention Policy



// === Pitfalls of Shape Trees
// text
