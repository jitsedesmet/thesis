#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "@preview/treet:0.1.1": tree-list

= Storage Guidance Vocabulary

#add[You could suggest addition], #delete[or deletion.]
We can refer to acronyms like: @oidc. It was long before, but now short @oidc.

#todo[why start annew an not use Shape Trees?]

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
It has been proven that this tree structure limitation heavily restricts the interface @bib:whats-in-pod.

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

Every @ldp container contained in a structured collection (@sec:structured-collection) is a grouped collection.
Grouped collections are used to group resources in structured collections together to provide additional structure.
This reduces cognitive load when browsing a collection.
@fig:example-structure visualizes two ways of organizing images.


#figure([
#block(breakable: false, width: 80%, inset: (left: 20%))[
  #set align(left)
  #set par(leading: 5pt)
  #grid(columns: (50%, 50%), [
    #tree-list[
       - pictures/
        - Valencia/
          - Klaas.ttl
          - Jitse.ttl
        - Ghent/
          - Simon.ttl
          - Hoyyiw.ttl
        - Paris/
          - Jonas.ttl
          - Ana.ttl
          - Liesbet.ttl
      ] 
    ], [
      #tree-list[
       - pictures/
        - 30-01-2024/
          - Erin.ttl
          - Oscar.ttl
        - 14-02-2024/
          - Henri.ttl
          - Snil.ttl
        - 17-05-2023/
          - Ghent/
            - Maurice.ttl
            - Lars.ttl
          - Paris/
            - Simon.ttl
      ]
    ])
  ]
],
  caption: [two example group strategies]
) <fig:example-structure>

=== Resource Description <sec:resource-description>

Both the canonical collection (@sec:canonical-collection) and the derived collection (@sec:derived-collection) require a description of the @rdf resources contained.
The the description is used to filter resource to be iserted in the pod, and can be used to browse the pod in an efficient way just like Shape Trees.
A structured collection should thus never contain a resource that does not match the shape description.
Two popular choices for describing a resource are @shex and @shacl.

Shape descriptions are powerful and allowing to express complicated expressions.
They include #link("https://www.w3.org/TR/shacl/#core-components-logical")[
logical constraint components] and #link("https://www.w3.org/TR/shacl/#core-components-property-pairs")[
property pair constraint components].

=== Group Strategy

A group strategy expresses how a structured collection (@sec:structured-collection) should group @rdf resources in grouped collections (@sec:grouped-collection).
Every structured container describes one group strategy.
A grouped collection can choose to define its own group strategy, thereby overruling the group strategy of the structured collection it resides in.

A group strategy maps each @rdf resource to part of a @uri.
The concatenation of the structured collection @uri, and the provided part should result in the @uri of the resulting resource.
A grouped collection with URI `https://example.com/pictures/Valencia/` together with a resulting strategy of
`Alice.ttl` would thus result in `https://example.com/pictures/Valencia/Alise.ttl`.
We suggest two possible ways of grouping resources, closed world through URI-templates @bib:uri-templates, or open world through a SPARQL query.


==== @uri Templates

Through @uri templates, one can construct a @uri based on some context variables.
Given the variables `var := "value"` and `hello := "Hello World!"` the @uri template `base/{var}/{hello}` would expand to `base/value/Hello%20World%21`.
The context available is the concise bounded description @bib:concise-bounded-description of the @rdf resource.
The context is referenced by entering the percent encoded @bib:uri-spec representation of the predicate @uri.
When multiple predicates need to be followed, we separate them using the "/" which is a character that is not present in @uri encoded strings. In a resource like this:

#text-example[
```turtle
@prefix ex: <https://example.com/> .
ex:Alice a ex:Person ;
  ex:owns-house
    [
      ex:address "Front Street 1"
    ] .
```
]

The template:\
`{https%3A%2F%2Fexample.com%2Fowns-house/https%3A%2F%2Fexample.com%2Faddress}` would expand to the percent encoded representation of "Front Street 1": `Front%20Street%201`.

Just like we use the "`/`" to convey special meaning, we also use the ":" to access special variables.
We can use the ":" because it is encoded by percent encoding, and is unused by uri-templates.
We currently support only one special variable, being "UUID_V4".
As an example, the uri template `one-file#{:UUID_V4}` could expand to `one-file#956242de-2c18-4985-8e9e-d490bc8f97b6`.


==== @sparql Query

The @uri template solution, altough is simple in use, but has the disadvantage that you can only access the @rdf resource itself.
To accomadate this shortcomming, we also suggest the use of a @sparql query that can access the world if it want's to.
We could for example create a SPARQL query that groups pictures in directories based on the creation date and the country a picture was taken in like `France-23-07-2023`.
When we assume an image only contains the city it was made in, we would need to discover the country the city is in.

We suggest a SPARQL query that uses the variable `?key`, being bounded to the named node of the @rdf resource,
and expect the return of a variable `?value` returning the location the resource should be in as described above.
An example query is shown below:

#text-example[
```sparql
PREFIX ex: <http://example.org/>
SELECT ?key ?value where {
    BIND(CONCAT(STR(?name), "-", STR(?date)) as ?value) .
    ?key ex:creationDate ?date;
    ?key ex:location [
        ex:locatedIn* [
            a ex:country ;
            ex:label ?name ;
        ] .
    ] .
}
LIMIT 1
```
]

It's possible the query needs to be evaluated over other sources, to discover required information.
For example, the query above might find its geolocation through data made available by wikidata.
A federated query allows us to dereference different sources.
This could be used as an attack vector if a bad actor creates a collection that contains everything and then uses the
@sparql query to pass through sensitive information to its own endpoint.
We therefore suggest that a pod lists trusted sources in some top-level resource. This would mean that query federation happens top level.

=== Save Condition
The save condition is used by a resource description (@sec:resource-description) when it matches.
When a resource matches a canonical collection resource description, the collection can decide whether it will save the resource based on what other collections would want the resource.
Optionally, additional context could be given as input to the save condition.
We suggest six save conditions:
#inline-enum[
+ state required, and
+ always stored, and
+ prefer other, and
+ prefer most specific, and
+ only stored when not redundant, and
+ never.
]

==== State Required
The state required save condition is a simple @sparql query over the current Solid pod.
The expected returning `?value` variable is coerced to a boolean, if true, the resource is saved in the collection.
The save condition allows for flexible additional features like basic locking mechanism, where a save is only allowed in case a lock is not present, for example.

==== Always Stored

A basic save condition, we always save the resource.

==== Prefer Other

This save condition indicates another collection takes precedence to save over this one.

I could, for example, have the canonical collections "family pictures" and "pictures".
Instead of creating a complex shape description for my "pictures" that excludes the shape of "family pictures", I could just say that the "family picture" collection takes precedence over the "pictures" collection. This would be described as below:

#text-example()[
```turtle
@prefix ex: <https://example.com/> .
@prefix sgv: <https://thesis.jitsedesmet.be/solution/storage-guidance-vocabulary/#> .

ex:Pictures a sgv:caonical-collection ;
  sgv:save-condition
    [
      a sgv:prefer-other ;
      sgv:other ex:FamilyPictures ;
    ] .
```
]

==== Prefer Most Specific

This saves condition specifies that this collection would only save in case its resource description is the most specific of the @rdf resource in focus.
It uses a distance metric to measure how much the resource description describes the resource.
A metric could be "the number of triples a projection of the resource by the description would cover".
#todo[Do others exist?]

We clarify using an example.
Take the resource below describing a person with their name and alternative name.
#text-example()[
```turtle
@prefix ex: <http://example.org/> .
ex:Alice a ex:Person ;
  ex:birthName "Alice"@en ;
  ex:alternativeName "Rabbit"@en .

```
]

Assume we have the two @shacl resource descriptions listed below available. 

#block(breakable: false)[
#grid(columns: (1fr, 1fr), column-gutter: 5pt,
grid.cell(colspan: 2, 
text-example(width: 100%, radius: 0pt)[
```turtle
@prefix ex: <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
```
]
),
text-example(width: 100%, radius: 0pt)[
```turtle
ex:shape1 a ex:Shape ;
  sh:property
    [
      sh:path ex:brithName ;
      sh:nodeKind sh:Literal ;
      sh:datatype rdf:langString ;
      sh:minCount 1 ;
    ] .
```
],
text-example(width: 100%, radius: 0pt)[
```turtle
ex:shape1 a ex:Shape ;
  sh:property
    [
      sh:path ex:brithName ;
      sh:nodeKind sh:Literal ;
      sh:datatype rdf:langString ;
      sh:minCount 1 ;
    ] ;
  sh:property
    [
      sh:path ex:alternativeName ;
      sh:nodeKind sh:Literal ;
      sh:datatype rdf:langString ;
      sh:minCount 1 ;
    ] .
```
]
)
]

After projection, we would get 1 triple for the left description, being:
#text-example()[
```
<http://example.org/Alice> <http://example.org/birthName> "Alice"@en .
```
]

The right description would have the additional triple:
#text-example()[
```
<http://example.org/Alice> <http://example.org/alternativeName> "Rabbit"@en .
```
]

The resource on the right would thus have the lowest distance because the projection has the most triples.


==== Only Stored When Not Redundant

The only stored when not redundant save condition saves only if no other collection stores the resource.
When choosing between two collections that both have this condition, we select the collection with a named node that is alphabetically first.
This condition can be used to create some kind of inbox collection containing resources that do not yet have a dedicated collection.
The pod owner could then manually go over the inbox and create the required collections.
This would primarily be the case for power users that want full control of their storage.


==== Never

The save condition "never" is fairly simple, it means no resource should be saved in this collection. 
We use this condition when we want to have a collection that contains resources, but cannot get new resources.


=== Update condition

A resource description's update condition is consulted when a resource within the collection, matching the description, is updated.
To prevent links from breaking, we also suppose the optional usage of a forward referencing pattern, preventing links to break in clients that are aware of this.
So when resource `ex:resource-one` is moved to `ex:resource-two`, there will be a tuple that describes just that: `ex:resource-one sgv:moved-to ex:resource-two`.
Servers could also be made aware of this triple, returning a 301 redirect to `ex:resource-two`.
A move procedure works by removing the existing resource and then inserting the resource in the pod using the insert procedure.
We propose multiple update conditions:
#inline-enum[
+ always keep, and
+ keep distance, and
+ prefer static, and
+ best match, and
+ disallow.
]

==== Always Keep

When using the always keep update condition, it does not matter how the resource has been manipulated, the resource will stay in the collection.
In case the resource description does not match the updated resource, it should be changed in such a way that it matches the original description and the updated resource.

==== Keep Distance

The "keep distance" update condition works similar to the "always keep" condition,
but places a limit on how much a description can stretch from its original form.
To implement this update condition, we require some distance metric between shape descriptions.
When the distance grows too big, the original description is reapplied and resources not matching the description are moved.

==== Prefer Static

The "prefer static" update condition will keep a resource in the current collection as long as the resource matches a resource description of the current collection, and move the resource when it does not.

==== Best Match

The best match update condition will discover the collection the update resource would be placed in, and move the resource in case this collection and the current collection are not the same. 

==== Disallow

The disallow update condition rejects any update made to the resource.

==== Removal Only

The "removal only" update condition rejects all updates except the full removal of the resource.

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
