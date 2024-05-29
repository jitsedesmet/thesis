#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "@preview/treet:0.1.1": tree-list
#import "../raw/vocab-examples.typ": *

= Storage Guidance Vocabulary <sec:storage-guidance-voc>

To empower automated clients to correctly store @rdf resources, we suggest the usage of a descriptive vocabulary.
Existing structure definitions of data spaces like Type Index @bib:type-index and Shape Trees @bib:shape-tree focus on read queries and insufficiently support write queries.
These structure definitions fail to express the underlying decision-making of why a resource is stored where it is.
As an example we give a small list of questions that can not be answered by either data store descriptions:
+ What if multiple directories match? Do I dublicate the resource?
+ What should I do if no documents match?
+ How are resources grouped?
  + Can I infer that resources grouped by a property are always grouped by that property?
  + Does that mean that if I get a new object for that property that I can just create a new document?
+ What should I do when I update a resource?
  + Should I alter the data store description? 
  + Should I move the resource? (Assign a new named node?)
+ Are all clients equal? Do they all abide the strctural information description?


To answer these questions, we develop a new vocabulary, namely, @sgv.
This vocabulary takes inspiration from the Shape Tree Specification, but does not extend it.
The vocabulary aims to express where a resource is stored and why.
@sgv is created with a primary focus on @ldp @bib:ldp interfaces, extending @ldp containers to be structured.
A container marked as structured has a strict definition of where containing containers/resources are located.
We shortly introduce some basic concepts in @sgv:
#list(marker: "",
[*Resource Collection*: Corresponds to a group of @rdf resources.],
[*Unstructured Collection*: Corresponds to a classical @ldp container or @http resource],
[*Structured Collection*: A canonical or derived collection. (below)],
[*Canonical Collection*: A resource collection containing resources.],
[*Derived Collection*: A resource collection that stores resources already stored by one or more other structured containers.],
[*Resource Description*: A way of describing resources, for example through @shex or @shacl.],
[*Group Strategy*: A description of how resources should be grouped together, for example: my images are grouped per creation date.],
[*Store Condition*: When multiple collections are eligible to store a resource, the store condition decides what collection(s) actually store the resource.
Allowing the creation of a store priority system.],
[*Update Condition*: Describes what to do when a containing resource is changed.],
[*Client Control*: Describes the amount of freedom a client has when trying to store a resource.]
)

We will first describe two simple flows, the creation, and the modification of an @rdf resource.
This should provide an idea of what @sgv tries to accomplish without going into all the details first.
After explaining the two example flows, we will look into the details of @sgv.


== Flow: A client wants to create an RDF-resource <sec:flow-create-rdf-resource>

Inserts happen on a pod level, meaning you specify to the client what pod you'd want to insert a resource to.
The client will then discover a fiting location for the resource.
@fig:example-insert is an example query that would trigger the resource creation flow.

An automated client is now required to discover the base (`<>`) of this query.
The client will follow the flow described below and visualized in @fig:rdf-create.
+ The client gets the @sgv description of the storage space (can be cached).
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
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix card: <http://localhost:3000/pods/00000000000000000096/profile/card#>
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
prefix resource: <http://localhost:3000/dbpedia.org/resource/>

INSERT DATA {
  <> a ns1:Post ;
    ns1:browserUsed "Chrome" ;
    ns1:content
      "I want to eat an apple while scavenging for mushrooms in the forest." ;
    ns1:creationDate "2024-05-08T23:23:56.830000+00:00"^^xsd:dateTime ;
    ns1:id "416608218494388"^^xsd:long ;
    ns1:hasCreator card:me ;
    ns1:hasTag tag:Alanis_Morissette, tag:Austria ;
    ns1:isLocatedIn resource:China ;
    ns1:locationIP "1.83.28.23" .
}
```
], caption: [Example resource insertion query]
) <fig:example-insert>

#figure(
  image("../static/flow-rdf-create.png", width: 80%),
  caption: [Flow: create RDF resource]
) <fig:rdf-create>

== Flow: A client wants to update an RDF-resource <sec:flow-update-rdf-resource>

An update can be both an insert to an existing resource, a change in values of a resource, or a deletion of the whole, or part of a resource.
In case of an update, it's important that the client knows what resource will be updated.
This is similar to how queries are executed right now, where you should always specify the @http resource to query over (excluding link-traversal clients).

The flow of an automated client is depicted in @fig:rdf-update and described further below.
+ The client gets the @sgv description of the storage space and the @http resource containing the updated RDF resource.
+ The client virtually constructs the resource that would result from the requested operation.
+ The client check the update condition of the original matching resource description. Following action depends on the update condition.
    Typically, the update-condition will say whether an @rdf resource is moved or not.
    + Move required: remove the existing resource and follow the steps described in @sec:flow-create-rdf-resource.
    + No move required: just update the resource as requested by the user.

#figure(
  image("../static/flow-rdf-update.png", width: 80%),
  caption: [Flow: update RDF resource]
) <fig:rdf-update>

== Details

This section delves into the details of @sgv.
The vocabulary is constructed with future expansions in mind, missing features could thus be added by other actors.
In @fig:sgv-vocab-overview an overview of the different components can be consulted.
The figure can be used as a reference while reading the different sections.
There are three arrows used in the graph, each with a different meaning, visualized in @fig:sgv-vocab-overview-legend.
Firstly, a full arrow means that there can be a triple `?a ldp:contains ?b`.
Secondly, the dotted arrow means that the destination has the same fields or more as the source.
Finally, a diamond shaped arrow entails a link from the source to the destination, specifically, the destination can be considered a property of the source.
@fig:example-sgv-description is provided as an example description to help clarify the vocabulary.
For completeness we also provide the @shex description of the vocabulary in @fig:shex-descr-sgv.

#figure(
  image("../static/sgv-graph-legend.png", width: 80%),
  caption: [A legend explaining the links used in @fig:sgv-vocab-overview]
) <fig:sgv-vocab-overview-legend>

#figure(
  image("../static/sgv-graph.png", width: 80%),
  caption: [Visualisation of the Storage Guidance Vocabulary]
) <fig:sgv-vocab-overview>

#figure(vocab-excample,
  caption: [Example pod description using Storage Guidance Vocabulary]
) <fig:example-sgv-description>

#figure(vocab-shex, caption: [Shape description of Storage Guidance Vocabulary. Starts left, continues on the right.]) <fig:shex-descr-sgv>

=== Resource Collection <sec:resource-collection>

An `sgv:resource-collection` is any @rdf resource that groups multiple @rdf resources together.
This grouping into a collection can be done in either an explicitly structured or unstructured way.
Note that we group @rdf resources, a collection can either be an @ldp Container, or an  @http resource.

=== Unstructured Collection <sec:unstructured-collection>

An unstructured collection is a kind of resource collection (@sec:resource-collection),
that does not explicitly define its structure.
This work's primary focus is to enable automated clients to perform insert queries over @ldp interfaces.
It might help to see the type `sgv:unstructured-collection` as similar to the `ldp:Container` type.

=== Structured Collection <sec:structured-collection>

An `sgv:structured-collection` is a resource collection (@sec:resource-collection) that explicitly describes its structure.
The collection defines a filter, each resource is compared against this filter.
If a resource passes, the resource is stored into the collection.
The collection later defines where the resource should be stored.
Where a normal resource collection can contain resources in a graph structure,
a structured container adds the important restriction of a tree.
It has been proven that this tree structure limitation heavily restricts the interface @bib:whats-in-pod.

=== Canonical Collection <sec:canonical-collection>

A `sgv:canonical-collection` is a structured collection (@sec:unstructured-collection) that stores @rdf resources.
When entering a Solid pod, we check what canonical containers want to store the resource.
The collections then individually decide where to store the resource given the other collections that are eligible to store.

=== Derived Collection <sec:derived-collection>

A `sgv:derived-collection` is a structured collection (@sec:structured-collection) that contains (part of) resources contained in one or more other collections.
Existing work around derived resources in solid specifies a "template", "selector" and "filter"~@bib:vanherwergenderived.
@sgv uses those same components but in a different format.
The template describes where the resource should be stored, in @sgv this is done using the group strategy (@sec:group-strategy).
The selector describes what resources are derived. In @sgv the selector is a combination of the Resource Description and Source in the "Derived from" node.
As for the filter or projection, @sgv uses a construct query over the @rdf resource.
This is different than the work of #cite(<bib:vanherwergenderived>, form: "author") where the construct if performed on @http resources which contain multiple resources~@bib:vanherwergenderived.
In case no filter is present, each resource is derived as a whole.
A derived collection without a filter defined on a pod with the "one file one resource" flag, can use soft/ hard links, and thus has a very low cost.

When a structured collection inserts, updates or removes an @rdf resource, the collections that derive from that collection are informed to act accordingly.
A derived collection can be used to create collections and knows a multitude of use cases, some examples are:
- Create a collection of all pictures in my pod, even though I have multiple canonical collections managing pictures.
- Create a restricted view of resources that I could then use to share with others.

=== Grouped Collection <sec:grouped-collection>

Every @ldp container contained in a structured collection (@sec:structured-collection) is a grouped collection.
Grouped collections are used to group resources in structured collections together to provide additional structure.
This reduces cognitive load when browsing a collection.
@fig:example-structure visualizes two ways of organizing images,
on the left by city and depicted person, and on the right by creation date and depicted person.


#figure([
#block(breakable: false, width: 90%, inset: (left: 10%))[
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
  caption: [Two Example Group Strategies]
) <fig:example-structure>

=== Resource Description <sec:resource-description>

Both the canonical collection (@sec:canonical-collection) and the derived collection (@sec:derived-collection) require a description of the @rdf resources contained.
The description is used to filter resources to be inserted in the pod, and could be used as an index when querying the pod efficiently using link traversal @bib:taelman-structure-assumptions.
A structured collection should thus never contain a resource that does not match the shape description.
Two popular choices for describing a resource are @shex and @shacl.

Shape descriptions are powerful and allow expressing complicated expressions inclusing
#link("https://www.w3.org/TR/shacl/#core-components-logical")[logical constraint components] and
#link("https://www.w3.org/TR/shacl/#core-components-property-pairs")[property pair constraint components].
Logical constraint components allow you to perform boolean operations on existing shapes, through: `sh:not`, `sh:and`, `sh:or`, and `sh:xone`.
This allows you to split shapes in parts, these parts could be evaluated once and the result of the evaluation can be shared with other shapes.
The sharing of evaluation effectivelly creates a cache.
Property pair constraint components allow you to assert relations between two values present within the same shape.


=== Group Strategy <sec:group-strategy>

A group strategy expresses how a structured collection (@sec:structured-collection) should group @rdf resources in grouped collections (@sec:grouped-collection).
Every structured container describes one group strategy.
A grouped collection can choose to define its group strategy, thereby overruling the group strategy of the structured collection it resides in.

A group strategy maps each @rdf resource to part of a @uri.
The concatenation of the structured collection @uri, and the provided part should result in the @uri of the resulting resource.
A grouped collection with URI `https://example.com/pictures/Valencia/` together with a resulting strategy of
`Alice.ttl` would thus result in `https://example.com/pictures/Valencia/Alice.ttl`.
We suggest two possible ways of grouping resources, closed world through URI-templates @bib:uri-templates, or open world through a SPARQL query.


==== URI Templates

Through @uri templates, one can construct a @uri based on some context variables.
Given the variables `var := "value"` and `hello := "Hello World!"` the @uri template `base/{var}/{hello}` would expand to `base/value/Hello%20World%21`.
The context available is the @cbd @bib:concise-bounded-description of the @rdf resource.
Since only properties described in the resource description are guaranteed to be present, only those should be accessed in the @uri template.
The context is referenced by entering the percent encoded @bib:uri-spec representation of the predicate @uri.
When multiple predicates need to be followed, we separate them using the "/" which is a character that is not present in @uri encoded strings.
The template
`{https%3A%2F%2Fexample.com%2Fowns-house/https%3A%2F%2Fexample.com%2Faddress}` evaluated over @fig:uri-template-nesting-example
would expand to the percent encoded representation of "Front Street 1": `Front%20Street%201`.

Just like we use the "`/`" to convey special meaning, we also use the ":" to access special variables.
We can use the ":" because it is encoded by percent encoding, and is unused by URI-templates.
We currently support only one special variable, being "UUID_V4".
As an example, the @uri template `one-file#{:UUID_V4}` could expand to `one-file#956242de-2c18-4985-8e9e-d490bc8f97b6`.

@uri templates by themselves do not allow very complex structures.
@sgv therefore allows you to express a regex replace over the result of the template.

#figure(
text-example[
```turtle
@prefix ex: <https://example.com/> .
ex:Alice a ex:Person ;
  ex:owns-house
    [
      ex:address "Front Street 1"
    ] .
```
], caption: [Simple resource with blank nodes]
) <fig:uri-template-nesting-example>


==== SPARQL Query

The @uri template solution above, although simple in use, has the disadvantage that you can only access the @rdf resource itself.
To accommodate this shortcoming, we also suggest the use of a @sparql query that can access the world if it pleases.
We could, for example, create a SPARQL query that groups pictures in directories based on the creation date and the country a picture was taken in like `France-23-07-2023`.
When we assume an image only contains the city it was made in, we would need to discover the country the city is in.

We suggest a SPARQL query that uses the variable `?key`.
This variable is bounded to the (temporary) named node of the @rdf resource.
The query expects the return of a variable `?value` returning the location of the resource relative to the collection.
@fig:sparql-group-strategy shows an example grouping @sparql query.

It's possible the query needs to be evaluated over other sources to discover required information.
For example, the query above might find its city/country data through data made available by #link("https://www.wikidata.org/wiki/")[Wikidata].
A federated query allows us to dereference different sources.
This could be used as an attack vector if a bad actor creates a collection that contains everything and then uses the
@sparql query to pass through sensitive information to its own endpoint @bib:taelman-security.
We therefore suggest that a pod lists trusted sources in some top-level resource. This would mean that query federation happens top level.
#cite(<bib:taelman-security>, form: "author") describe many more possible security issues in their paper @bib:taelman-security.

#figure(
text-example[
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
], caption: [Example group strategy SPARQL query]
) <fig:sparql-group-strategy>

=== Store Condition <sec:store-condition>

The store condition decides when an @rdf resource is stored, given all canonical collections (@sec:canonical-collection) that are eligible to store the resource.
Optionally, additional context could be given as input to the store condition.
A canonical collection can have multiple store conditions,
and each store condition has an update condition (@sec:update-condition) and therefore a resource description (@sec:resource-description).
We suggest six store conditions:
#inline-enum[
+ state required, and
+ always stored, and
+ prefer other, and
+ prefer most specific, and
+ only stored when not redundant, and
+ never.
]

==== State Required
The state required store condition is a simple @sparql query over the current Solid pod.
The expected returning `?value` variable is coerced to a boolean, if true, the resource is stored in the collection.
The store condition allows for flexible additional features like a basic locking mechanism, where a store is only allowed in case a lock is not present.

==== Always Stored

A basic store condition, we always store the resource.

==== Prefer Other

This store condition indicates another collection takes precedence to store over this one.

I could, for example, have the canonical collections "family pictures" and "pictures".
Instead of creating a complex shape description for my "pictures" that excludes the shape of "family pictures",
I could just say that the "family picture" collection takes precedence over the "pictures" collection.
This example is writen out in @fig:prefer-other.

#figure(
text-example[
```turtle
@prefix ex: <https://example.com/> .
@prefix sgv: <https://example.com/storage-guidance-vocabulary#> .

ex:Pictures a sgv:canonical-collection ;
  sgv:store-condition
    [
      a sgv:prefer-other ;
      sgv:other ex:FamilyPictures ;
    ] .
```
], caption: [Example prefer other SGV description]
) <fig:prefer-other>

==== Prefer Most Specific

This store condition specifies that this collection would only store in case its resource description is the most specific to the @rdf resource in focus.
It uses a distance function to measure how good the resource description describes the resource.
A distance function could be the inverce of "the number of triples a projection of the resource by the description would cover".

We clarify using an example.
It's important to note that the example is by no means a "good" distance function, we just wish to mention it is possible.
@fig:person describes a person with their name, alternative name and birthdate.
Assume we have the two @shacl resource descriptions listed in @fig:two-shape-descriptions.
After projection, we would get 1 triple for the left description, being:
#text-example()[
```
<http://example.org/Alice> <http://example.org/birthdate> "1865-10-01T00:00:00Z"^^<http://www.w3.org/2001/XMLSchema#dateTime> .
```
]
#block(breakable: false)[
The right description would return the two triples listed below.
The shape projection on the right results in the most triples after projection and would thus have the lowest distance.
#text-example()[
```
<http://example.org/Alice> <http://example.org/birthName> "Alice"@en .
<http://example.org/Alice> <http://example.org/alternativeName> "Rabbit"@en .
```
]
]

#figure(
text-example()[
```turtle
@prefix ex: <http://example.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
ex:Alice a ex:Person ;
  ex:birthName "Alice"@en ;
  ex:alternativeName "Rabbit"@en ;
  ex:birthdate "1865-10-01T00:00:00Z"^^xsd:dateTime .
```
],
caption: [RDF description of a person]
) <fig:person>

#figure(
grid(columns: (1fr, 1fr), column-gutter: 4pt,
text-example(width: 100%, inset: 4pt)[
```turtle
@prefix ex: <http://example.org/> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

ex:left-shape a ex:Shape ;
  sh:property
    [
      sh:path ex:brithdate ;
      sh:nodeKind sh:Literal ;
      sh:datatype xsd:dateTime ;
      sh:minCount 1 ;
      sh:maxCount 1 ;
    ] .
```
],
text-example(width: 100%, inset: 4pt)[
```turtle
@prefix ex: <http://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
ex:right-shape a ex:Shape ;
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
),
caption: [Two open shape descriptions of the person in @fig:person]
) <fig:two-shape-descriptions>


==== Only Stored When Not Redundant

The "only stored when not redundant" store condition stores only if no other collection stores the resource.
When choosing between two collections that both have this condition, we select the collection with a named node that is alphabetically first.
This condition can be used to create some kind of inbox collection containing resources that do not yet have a dedicated collection.
The pod owner could then manually go over the inbox and create the required collections.
This would primarily be the case for power users that want full control of their storage.


==== Never

The store condition "never" is fairly simple, it means no new resource should be stored in this collection.
We use this condition when we want to have a collection that contains resources, but cannot get new resources.


=== Update condition <sec:update-condition>

When an @rdf resource is updated, the update condition with the shape description matching the original resource is consulted.
To prevent links from breaking, we also suppose the optional usage of a forward referencing pattern, preventing links to break in clients that are aware of this.
So when resource `ex:orininal-name` is moved to `ex:new-name`, there will be a tuple that describes just that: `ex:original-name sgv:moved-to ex:new-name`.
Servers could also be made aware of this triple, returning a 301 redirect to `ex:new-name`.
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
but places a limit on how much a resource description can stretch from its original form.
To implement this update condition, we require some distance metric between shape descriptions.
When the distance grows too big, the original description is reapplied and resources not matching the description are moved.

To our knowledge, there does not yet exist a distance metric to see how much two shape descriptions differ, only whether two descriptions are contained @bib:shape-containment.
An example metric could be inspired by the Levenshtein distance where, we count the number of additions and deletions of a @shacl properties.
Let's say each addition or deletion has a cost of 1.
The distance between the shapes in @fig:two-shape-descriptions would be three because to go from the left description to the right, three operations are required:
+ Remove the property with a path of `ex:birthdate`.
+ Add the property with a path of `ex:birthName`.
+ Add the property with a path of `ex:alternativeName`.

==== Prefer Static

The "prefer static" update condition will keep a resource in the current collection as long as the resource matches a resource description of the current collection, and move the resource when it does not.

==== Best Match

The "best match update" condition will discover the collection the updated resource would be placed in,
and moves the resource in case this collection and the current collection are not the same.

==== Disallow

The "disallow" update condition rejects any update made to the resource.

==== Removal Only

The "removal only" update condition rejects all updates except the full removal of the resource.

==== State Dependent

Like the "state required" store condition, this update condition allows you to create a @sparql query.
A return variable of a simple update condition is expected.

=== Client Control

Each resource collection (@sec:resource-collection) can specify the level of freedom a client/ actor has to deviate from the @sgv.
A few example control policies are discussed:
#inline-enum[
  + free client, and
  + additional allowed, and
  + allowed when not preferred, and
  + allowed when not claimed, and
  + no control.
]
Important to note, no client control allows a client to enter an invalid state.
When a state would be invalid to the @sgv description, the client needs to update the description.

==== Free Client

A collection that specifies a client is free, specifies that the client itself can choose where a resource is stored.
Since the collection still needs to be in a correct state, the client might have to edit @sgv descriptions.
Take again the example of "pictures" and "family pictures" collections, where normally a picture matching the family picture description, would be placed in that collection.
A free client might choose to store the resource only in the general pictures collection and not in the family pictures collection. They can choose to do this without changing the @sgv description.

==== Additional Allowed

The "additional allowed" client control describes that the client might decide that a canonical container stores a resource it would normally not. Take the pictures example above, the client might decide to store a family picture in both collections.

==== Allowed When Not Preferred

The "allowed when not preferred" client control states that a client may decide where to store a resource when no collection explicitly wants to store the resource.
The collections that want to explicitly store a resource are those collections that would store a resource, but do not have the store condition (@sec:store-condition) "only stored when not redundant".
The idea here is that that store condition is only used for those collections that are a last resort to saving a resource automatically.
A client can in this case see this last resort option and perform a more suitable action.

==== Allowed When Not Claimed

The "allowed when not claimed" client control policy describes that a client may decide where to store a resource in case no collection wants to store the resource. This policy deviates from the "allowed when not preferred" policy because this one does not have a store condition filter.

==== No Control

The "no control" client control allows no deviation from the @sgv rules. If a resource is not stored, it will not be stored.


=== One File One Resource

A big advantage of LDP is that it easily maps to the file structure storage of a typical file systems.
If someone wants to store their Solid Pods on their own machine, it's easy for them to access the data.
The one file one resource flag signals an LDP server that no @http
#link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Identifying_resources_on_the_Web#fragment")[fragments]
are present in the named nodes in this collection.
The server can therefore use soft-links or hard-links to reduce the physical data duplication.


=== Retention Policy


As a little extra, @sgv could be expanded with retention policies like those present in @ldes @bib:ldes.

== Use Case: No Collection Claims Resource

Now that the details are understood, we sketch 3 cases of handling resources that are not claimed.
We propose either notifying the owner, letting the client assume a location, or to deny the operation.


=== Notification

When the owner would like to receive a notification when a resource is not claimed by their pod,
they would create a "@sgv notification" collection.
That collection would have a resource description that matches any resource and a corresponding store condition of "only stored when not redundant".
If the pod owner wants to force a client into this use case, the root resource collection would need a client control to be set to "no control".
When the user of the client is also the pod owner, the client could provide the user with a popup requesting to handle the notification immediately.

=== Assume

In the case that a pod owner would want the client to assume the location, root resource collection would need a policy less strict than "no control".
In addition, no notification collection as described above can be present if the client control would be "allowed when not claimed".


=== Deny

In case the pod owner never wants to store a resource that cannot be stored by their @sgv description,
the root resource collection would need to have a client control of "no control" and no notification collection should be made.

// === Pitfalls of Shape Trees
// text
