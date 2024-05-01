#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Evaluation

This chapter provides an extensive evaluation of @sgv introduced in @sec:storage-guidance-voc.
To evaluate the vocabulary, we implemented a query engine with a minimal set of features from @sgv.
After discussing the implementation, we shortly discuss the theoretical cost of our operations.
We finish with an empirical evaluation of the query engine on an adapted benchmark.


== Implementation


// What did we implement?

// What technologies?

// Considerations?


To analyse the capabilities of @sgv, we implemented a query engine capable of parsing a pod's @sgv description and acting accordingly.
The source code of the implementation can found
#link("https://github.com/jitsedesmet/sgv-update-engine")[online].
The query engine acts as a wrapper around the modular
#link("https://comunica.dev/")[Comunica query engine].
We chose to implement a wrapper around Comunica for convenience because it allows us to quickly get results without the need of understanding, or changing internal code.

For this proof of concept implementation, we will only support essential parts of @sgv.
We therefore provide an implementation of only the following concepts:
+ Canonical Collection
+ Group Strategy: only @uri templates
+ Resource Description: only @shex
+ Save Condition: always stored, prefer other, only stored when not redundant, and never stored
+ Update Condition: prefer static, move to best matched, and disallow

To parse and validate our @shex descriptions, we use the
#link("https://www.npmjs.com/package/rdf-validate-shacl")[rdf-validate-shacl library].
This library is known to be quite inefficient and could be replaced by the faster
#link("https://www.npmjs.com/package/shacl-engine")[SHACL engine library].


== Theoretical Evaluation

In our theoretical evaluation, we will analyse a few metrics like: number of @http requests.


=== Insert Operation <sec:eval-insert>

In this section, we analyse the cost of a simple insert operation like:
#text-example[
```sparql
prefix ns1: <http://www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix card: <http://example.com/pod/profile/card#>
prefix tag: <http://www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX resource: <http://dbpedia.org/resource/>

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
]

In @sec:flow-create-rdf-resource we analysed the steps required for this operation.

==== Fetch the Description

The query engine should request the @sgv description.
This accounts to one @http request, assuming the @api publishes it as a single @http resource.

==== Loop the Resource Descriptions

The next thing a query engine must do is checking what canonical collections want to save the resource.
In the worst-case scenario, all collections could save the resource, but they only discover this at the last resource description of each collection.
In such a case, all resource descriptions pointed to by canonical collections need to be checked.

The cost of a single validation can be linear in the number of properties the description has.
Since the focus of the resource is on a single named node, only that named node should be seen as a focus node in the validation.

The computational load could be reduced when multiple resource descriptions share have overlapping descriptions.
A shape could in that case be defined as a conjunction using `sh:and`.
Take the example of images and personal images.
A personal image could be described as:
#text-example[
```turtle
ex:PictureShape
  a sh:NodeShape .

ex:WhatMakesPicturePersonalShape
  a sh:NodeShape .
 
ex:PersonalPictureShape
	a sh:NodeShape ;
	sh:and (
		ex:pictureShape
		ex:WhatMakesPicturePersonalShape
	) .
```
]
In this case, a query engine could cache the evaluation result of `ex:Picture`.
Optimizations like this could likely be automated.

==== Filter Collections on Save Condition

The complexity of filtering the list of eligible collections could be significant.
We do, however, expect that this list will be small.
In case the `state required` condition is used, a whole @sparql query needs to be executed to check the state.
We will thus disregard that case here.
The worst-case performance is listed below:
- Always Stored: Constant
- Prefer Other: linear search in list of eligible collections.
- Prefer Most Specific: linear scan trough eligible collections and distance function dependent cost for each collection. The cost is cacheable.
- Only stored when not redundant: linear scan through collections in case no collection is clear-cut
- Never: constant

==== Compute Named Node

For each collection that will save the resource, we now have to compute the named node.
In the case of @uri templates with regexes, this cost negligible.

==== Create Resources

The Solid Specification requires updates to happen using N3Patch,
this means that each created resource requires its own @http request.

Interestingly, some implementations of a solid server, like the 
#link("https://communitysolidserver.github.io/CommunitySolidServer/7.x/usage/example-requests/#patch-modifying-resources")[Community Solid Server]
also accept SPARQL queries.

==== Conclusion Resource Creation

We now know that the resource creation takes 2 @http requests.

=== Update Resource, No Move Required

This section theoretically analyses the cost of updating a resource when the resource needs not be moved.
A general update flow can be found in @sec:flow-update-rdf-resource.
An example update query is:

#text-example[
```sparql
PREFIX ns1: <http://www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
INSERT {
    ?id ns1:hasTag <http://www.ldbc.eu/ldbc_socialnet/1.0/tag/Cheese> .
} WHERE {
    ?id ns1:hasTag <http://www.ldbc.eu/ldbc_socialnet/1.0/tag/Austria> .
}
```
]

==== Fetch the Description and the Resource

Like with creating a resource, we need to fetch the @sgv, costing us one @http request. 
Additionally, we need to fetch the current state of the resource, costing us at least one additional @http request.
Luckily, these requests can be done in parallel, minimizing delay.

==== Construct the result

We then construct the result using the default query engine.
The cost of this construction depends on the query engine and is not covered in the work.
For the Comunica query engine, the cost of local construction is low when the query engine can be reused.

==== Check the Update Condition

We know the canonical collection this @rdf resource is stored in because the prefix of the collection and the resource named node matches.
We then have to check the update condition the resource matches and check if, and how, we can update.
In most cases, this is a fairly simple process.

In the case of Keep Distance, an update that stretches the shape description too hard might cause many updates.
It's important to note though that the Amortized Computational Complexity would still make this a constant operation.
// https://en.wikipedia.org/wiki/Amortized_analysis -> Tarjan, Robert Endre (April 1985)

==== Commit Changes

In case no move is required, a single N3Patch request should suffice to update the resource.
However, because the primary focus of Comunica is in querying, their update implementation seems to require
two, non-parallel @http requests
#footnote[
  As seen in the discussion on https:\//github.com/comunica/comunica/pull/1326.
  Will be fixed in the next major release: https:\//github.com/comunica/comunica/pull/1331
].

==== Conclusion Resource Update, No Move

We can conclude that the cost of an @rdf resource update is two in case of an update that only deletes or adds triples, and three in case of an update that does both deletes and updates.

It should, however, be possible to do it using only two @http requests.

=== Update Resource, Move Required

In the previous section, we assume the update condition concludes no move is required.
This section describes the cost when a resource is required.
In this case, we delete the original @rdf resource and follow the steps of @sec:eval-insert, disregarding the @sgv fetch step.

Assuming we use N3Patch, and the @rdf resource is hosted by a different @http resource,
the required number of requests will be three. One for getting the @sgv description (cacheable), one for getting the deleting the resource, and one for creating the updated resource.


== Empirical Evaluation

// What do we want to measure?
After a theoretical evaluation, we will also evaluate the implementation in an empirical way.
We will perform time and memory benchmarks for different queries, all following the same use case.
The goal of this evaluation is to convince the reader the cost of @sgv on query execution is manageable.

// using what technologies?
The empirical evaluation is performed using SolidBench @bib:taelman-structure-assumptions and a slightly altered fragmenter so each pod contains a @sgv description.
After the generation of our test data, we use SolidBench to host the data locally.
Under the hood, SolidBench will use the Comunity Solid Server.

In our evaluation we will focus on the @rdf resource describing a post.
Different pods will have different ways of storing these posts.
@fig:post-shex provides the @shex shape of a post while @fig:fragmentation-strategies shows the different fragmentation strategies used.


#figure(
  text-example[
```
prefix ex: <http://example.org/>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix ldbc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
ex:PostShape {
  ldbc:browserUsed xsd:string ;
  ldbc:creationDate xsd:dateTime ;
  ldbc:hasCreator @ex:PersonShape ;
  ldbc:id xsd:long ;
  ldbc:isLocatedIn @dbo:PlaceShape ;
  ldbc:locationIP xsd:string ;
  ldbc:content xsd:string ? ;
  ldbc:length xsd:int ? ;
  rdfs:seeAlso @sh:IRI * ;
  ldbc:language xsd:string ? ;
}
```
  ],
  caption: [ShEx description of a post]
) <fig:post-shex>

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 16pt,
    text-example[
```turtle
<posts/> a sgv:canonical-collection ;
  sgv:group-strategy
    [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template
        '{ldbc:creationDate:10}#{ldbc:id}' ;
    ] .
```
    ],
    text-example[
```turtle
<posts/> a sgv:canonical-collection ;
  sgv:group-strategy [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template
        '{ldbc:isLocatedIn}#{ldbc:id}' ;
      sgv:regex-match '([^/]+)#([^#]+)$' ;
      sgv:regex-replace '$1/$2' ;
    ] .
```
    ],
    text-example[
```turtle
<posts> a sgv:canonical-collection ;
  sgv:group-strategy
    [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template
        '#{ldbc:id}' ;
    ] .
```
    ],
    text-example[
```turtle
<posts/> a sgv:canonical-collection ;
  sgv:group-strategy
    [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template '{ldbc:id}' ;
    ] .
```
    ],
  ),
  caption: [Pseudo description of the four fragmentation strategies used.]
) <fig:fragmentation-strategies>

==== Test Hardware Specification

For completeness sake, We quickly describe the system used in the benchmarking.
I am using a Dynabook Inc. Satallite Pro A50EC with 16 GiB memory, an Intel® Core™ i5-8250U x 8 processor and an Intel® Graphic UHD Graphics 620 (KBL GT2).
The installed operating system is a Fedora Workstation 39 (64-bit), and firmware version 2.70.

=== Choke Point Queries

We evaluate the vocabulary using multiple queries, each query testing a specific choke point.
The choke points we will be testing are:
+ *Create new resource*: @fig:insert-data-complete
+ *Update resource, no move*: @fig:insert-where-tag, @fig:insert-data-tag, @fig:delete-tags, @fig:delete-data-tag
+ *Update resource, move*: @fig:delete-insert-id
+ *Illegal update resource*: @fig:insert-data-id, @fig:delete-data-id
+ *Delete resource*: @fig:delete-data-complete, @fig:delete-where-complete

The queries should cover all different queries from the update @sparql spec.
Because we want to cover all type of queries, some choke points are represented by more then one query.


#grid(
  columns: (1fr, 1fr),
  [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix card: <http://localhost:3000/pods/00000000000000000096/profile/card#>
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
PREFIX resource: <http://localhost:3000/dbpedia.org/resource/>

INSERT DATA {
  <> a ns1:Post ;
    ns1:browserUsed "Chrome" ;
    ns1:content
      "I want to eat an apple." ;
    ns1:creationDate "2024-05-08T23:23:56.83Z"^^xsd:dateTime ;
    ns1:id "416608218494388"^^xsd:long ;
    ns1:hasCreator card:me ;
    ns1:hasTag tag:Alanis_Morissette, tag:Austria ;
    ns1:isLocatedIn resource:China ;
    ns1:locationIP "1.83.28.23" .
}
```
      ],
      caption: [insert data - complete post]
    ) <fig:insert-data-complete>
  ],
   [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix card: <http://localhost:3000/pods/00000000000000000096/profile/card#>
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
prefix resource: <http://localhost:3000/dbpedia.org/resource/>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

DELETE DATA {
    res:416608218494388
        a ns1:Post ;
        ns1:browserUsed "Chrome" ;
        ns1:content
            "I want to eat an apple." ;
        ns1:creationDate "2024-05-08T23:23:56.83Z"^^xsd:dateTime ;
        ns1:id "416608218494388"^^xsd:long ;
        ns1:hasCreator card:me ;
        ns1:hasTag tag:Alanis_Morissette, tag:Austria ;
        ns1:isLocatedIn resource:China ;
        ns1:locationIP "1.83.28.23" .
}
```
      ],
      caption: [delete data - complete post]
    ) <fig:delete-data-complete>
  ],
  [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>

INSERT {
    ?id ns1:hasTag tag:Cheese
} where {
    ?id ns1:hasTag tag:Austria
}
```
      ],
      caption: [insert where - insert tag where tag]
    ) <fig:insert-where-tag>
  ],
    [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

INSERT DATA {
    res:416608218494388 ns1:id "416608218494389"^^xsd:long ; .
}
```
      ],
      caption: [insert data - an id (illegal)]
    ) <fig:insert-data-id>
  ],
    [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

INSERT DATA {
    res:416608218494388  ns1:hasTag tag:Mountain .
}
```
      ],
      caption: [insert data - additional tag]
    ) <fig:insert-data-tag>
  ],
    [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

DELETE {
    ?id ns1:id "416608218494388"^^xsd:long .
} INSERT {
      ?id ns1:id "416608218494389"^^xsd:long .
} where {
    BIND(res:416608218494388 as ?id)
}
```
      ],
      caption: [delete insert - replace id]
    ) <fig:delete-insert-id>
  ],
    [
    #figure(
      text-example[
```sparql
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

DELETE WHERE {
  res:416608218494388 ?p ?o
}
```
      ],
      caption: [delete where - complete post]
    ) <fig:delete-where-complete>
  ],
   [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

DELETE {
    res:416608218494388 ns1:hasTag ?x
} where {
    res:416608218494388 ns1:hasTag ?x
}
```
      ],
      caption: [delete - tags]
    ) <fig:delete-tags>
  ],
    [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

DELETE DATA {
    res:416608218494388 ns1:id "416608218494388"^^xsd:long ; .
}
```
      ],
      caption: [delete data - id (illegal)]
    ) <fig:delete-data-id>
  ],
    [
    #figure(
      text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

DELETE DATA {
    res:416608218494388 ns1:hasTag tag:Mountain .
}
```
      ],
      caption: [delete data - a tag]
    ) <fig:delete-data-tag>
  ],
)


=== Choke Point: Create New Resource
// Discuss the measured cost. - Memory consumption and Excecution time


=== Choke Point: Update Resource, No Move



=== Choke Point: Update resource: Move



=== Choke Point: Illegal Update Resource



=== Choke Point: Delete Resource


