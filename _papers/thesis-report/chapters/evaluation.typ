#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "../raw/consts.typ": *
#import "../raw/evaluation-tables.typ": *

= Evaluation

This chapter provides an extensive evaluation of @sgv introduced in @sec:storage-guidance-voc.
To evaluate the vocabulary, we implemented a query engine with a minimal set of features from @sgv.
After discussing the implementation, we shortly discuss the theoretical cost of our operations.
We finish with an empirical evaluation of the query engine.


== Implementation


// What did we implement?

// What technologies?

// Considerations?


To analyse the capabilities of @sgv, we implemented a query engine capable of parsing a pod's @sgv description and acting accordingly.
The source code of the implementation and benchmark can be found
#link(thesis-code)[online].
The query engine acts as a wrapper around the modular Comunica query engine @bib:comunica.
We chose to implement a wrapper around Comunica for convenience because it allows us to quickly get results without the need of understanding, or changing Comunicas internal code.

For this proof of concept implementation, we only support essential parts of @sgv.
We therefore only provide an implementation of the following concepts:
+ Canonical Collection
+ Group Strategy: only @uri templates.
+ Resource Description: only @shacl.
+ Store Condition: "always stored", "prefer other", "only stored when not redundant", and "never stored".
+ Update Condition: "prefer static", "move to best matched", and "disallow".

To parse and validate our @shex descriptions, we use the
#link("https://www.npmjs.com/package/rdf-validate-shacl")[rdf-validate-shacl library].
This library is known to be quite inefficient and could be replaced by the faster
#link("https://www.npmjs.com/package/shacl-engine")[SHACL engine library].
Unfortunately, that library does not have type descriptions available, making adoptions less desirable.


== Theoretical Evaluation

In our theoretical evaluation, we analyse the number of @http requests.
In @sec:hypotheses we hypothesize that the required number of @http queries of an @sgv aware client would at most be double that of a normal one. 


=== Insert Operation <sec:eval-insert>

In this section, we analyse the cost of a simple insert operation as seen in @fig:insert-data-complete in the empirical evaluation.
In @sec:flow-create-rdf-resource we analysed the steps required for this operation.

==== Fetch the Description

The query engine should request the @sgv description.
This accounts for one @http request, assuming the @api publishes it as a single @http resource.
It should be noted that the @sgv description can easily be cached since it will not change a lot.

Do note however that using an outdated version can be detrimental.
Unfortunately, since @ldp exposes a pod through multiple different @http resources,
there is no way of checking whether your @sgv description has not grown outdated when you start updating data.
For example, you could compute the change, then fetch the @sgv again using an
#link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Modified-Since")[if-moified-since header] and recompute in case it did change.
However, in between confirming you have the  latest value and writing the data, the
@sgv could have been changed, causing you to write in an outdated way, nevertheless.
Because @ldp exposes multiple @http resources, using the
#link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Unmodified-Since")[If-Unmodified-Since] is not possible.
// in conclusion, either expand a pod so it knows what it is, or get rid of ldp?


==== Loop the Resource Descriptions

The next thing a query engine must do is checking what canonical collections want to store the resource.
Worst-case scenario, all collections could store the resource, but they only discover this at the last resource description of each collection.
In such a case, all resource descriptions pointed to by canonical collections need to be checked.

The cost of a single validation can be linear in the number of properties the description has.
Since the focus of the resource is on a single named node, only that named node should be considered as a focus node in the validation.

The computational load could be reduced when resource descriptions have overlapping descriptions.
A shape could in that case be defined as a conjunction using `sh:and`.
Take the example of images and personal images.
A personal image could be described using logical constraint components as described in @sec:resource-description.

As an example, for the case described in @fig:logical-constrained-components, a query engine could cache the evaluation result of `ex:Picture`.
Optimizations in the descriptions like this could likely be automated.

#figure(
text-example[
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
], caption: [SHACL description using logical constrained components]
) <fig:logical-constrained-components>

==== Filter Collections on Store Condition

The complexity of filtering the list of eligible collections could be significant.
We do, however, expect that this list will be small.
In case the `state required` condition is used, a whole @sparql query needs to be executed to check the state.
We will thus disregard that case here.
The worst-case performance is listed below:
- Always Stored: Constant
- Prefer Other: linear search in a list of eligible collections.
- Prefer Most Specific: linear scan trough eligible collections and distance function dependent cost for each collection. The distance could be cached.
- Only stored when not redundant: linear scan through collections in case no collection is clear-cut
- Never: constant

==== Compute Named Node

For each collection that will store the resource, we now have to compute the named node.
In the case of @uri templates with regexes, this cost negligible.

==== Create Resources

The Solid Specification requires updates to happen using N3Patch,
this means that each created resource requires its own @http request.

Interestingly, some implementations of a solid server, like the
#link("https://communitysolidserver.github.io/CommunitySolidServer/7.x/usage/example-requests/#patch-modifying-resources")[Community Solid Server]
also accept SPARQL update queries.

==== Conclusion Resource Creation

We now know that the resource creation takes 2 @http requests: reading @sgv and creating the resource.
This is compliant with our hypothesis.

=== Update Resource, No Move Required

This section theoretically analyses the cost of updating a resource when the resource needs not be moved.
A general update flow can be found in @sec:flow-update-rdf-resource.
An example update query is @fig:insert-where-tag in the empirical evaluation.

==== Fetch the Description and the Resource

Like with creating a resource, we need to fetch the @sgv, costing us one @http request.
Additionally, we need to fetch the current state of the resource, costing us one additional @http request.
Luckily, these requests can be done in parallel, minimizing delay.

==== Construct the result

We then construct the result using the default query engine.
The cost of this construction depends on the query engine and is not covered in the work.
For the Comunica query engine, the cost of local construction is low when the query engine can be reused.

==== Check the Update Condition

We know the canonical collection this @rdf resource is stored in because the prefix of the collection and the resource named node matches.
We then have to check the update condition the resource matches and check if, and how, we can update.
In most cases, this is a fairly simple process.

In the case of Keep Distance, an update that stretches the shape description too might cause many updates.
It's important to note though that the Amortized Computational Complexity~@bib:tarjan1985amortized would still make this a constant operation.

==== Commit Changes

In case no move is required, a single N3Patch request should suffice to update the resource.
However, because the primary focus of Comunica is in querying, their update implementation seems to require
two, non-parallel @http requests
#footnote[
  As seen in the discussion on https:\//github.com/comunica/comunica/pull/1326.
  Will be fixed in the next major release: https:\//github.com/comunica/comunica/pull/1331
].

==== Conclusion Resource Update, No Move

We can conclude that the cost of an @rdf resource update is three in the case of an update that only deletes or adds triples, and four in the case of an update that both deletes and updates.
It should, however, be possible to do it using only three @http requests.
Which is valid with our hypothesis, since a non-@sgv query engine would require either two or three requests.
One to get the original resource, and one or two to update.

=== Update Resource, Move Required

In the previous section, we assume the update condition concludes no move is required.
This section describes the cost when a move is required.
In this case, we delete the original @rdf resource and follow the steps of @sec:eval-insert, disregarding the @sgv fetch step.

Assuming we use N3Patch, and the @rdf resource is moved to by a different @http resource,
the required number of requests will be four. One for getting the @sgv description (cacheable), one for getting the deleting the resource, one for deleting the original resource, and one for creating the updated resource.
When a resource would be moved without @sgv, a client would also require three requests, one to get the resource, one to delete the old, and one to insert the new resource.
As a result, our hypothesis is still valid.

=== Conclusion theoretical evaluation

We can thus conclude that our hypothesis about the number of @http requests is valid.
An @sgv client requires at most double the number of @http requests a non @sgv client requires.

== Empirical Evaluation

// What do we want to measure?
After a theoretical evaluation, we also evaluate the implementation in an empirical way.
We perform time benchmarks for different queries, all following our use case.
The goal of this evaluation is to convince the reader the cost of @sgv on query execution is manageable.
The hypothesis (@sec:hypotheses) is that the execution time for the same query is at most four times as high when using the @sgv enabled query engine.

// using what technologies?
The empirical evaluation is performed using
#link("https://github.com/SolidBench/SolidBench.js")[SolidBench], which uses the same data as our use case, namely, the Social Network Benchmark @bib:ldbc. 
After the generation of our test data, we use SolidBench to host the data locally.
Under the hood, SolidBench will use the Community Solid Server~@bib:comunity-solid-server to expose the resources.

In our evaluation, we will focus on the @rdf resource of a post.
@fig:post-shex provides the @shex shape of a post.
Different pods will have different ways of storing these posts, called fragmentation strategies.
We will use four fragmentation strategies in our evaluation:
+ Posts are grouped in files based on the creation date. Within that file, they have a fragment based on the ID. (See @fig:frag-strat-creation-date)
+ Posts are grouped in files based on the location. Within that file, they have a fragment based on the ID. (See @fig:frag-strat-location)
+ All posts are stored in one file. Within that file, they have a fragment based on the ID. (See @fig:frag-strat-one-file)
+ Each posed is stored in their own file based on the ID. (See @fig:frag-strat-own-file)

In hindsight, the scope of SolidBench was too big as it creates 1528 pods, but we will only query 4 of them.
Each @sgv file contains approximately 33 triples.
For the writing data use case, the accessed data files are either empty, or in the case of the "one file" fragmentation strategy contain 2947 triples.
When updating, we first prepare the file with the insertion of a single post, adding another 9 triples to each data file.

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

#block(breakable: false)[#grid(
    columns: (1fr, 1fr),
    gutter: 16pt,
  [#figure(text-example[
```turtle
<posts/> a sgv:canonical-collection ;
  sgv:group-strategy
    [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template
        '{ldbc:creationDate:10}#{ldbc:id}' ;
    ] .
```
], caption: [Group strategy - by creation date]
  ) <fig:frag-strat-creation-date>],
    
    [#figure(text-example[
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
], caption: [Group strategy - by locations]
) <fig:frag-strat-location>],

[#figure(text-example[
```turtle
<posts> a sgv:canonical-collection ;
  sgv:group-strategy
    [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template
        '#{ldbc:id}' ;
    ] .
```
], caption: [Group strategy - one file]
) <fig:frag-strat-one-file> ],

[#figure(text-example[
```turtle
<posts/> a sgv:canonical-collection ;
  sgv:group-strategy
    [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template '{ldbc:id}' ;
    ] .
```
], caption: [Group strategy - own file],
) <fig:frag-strat-own-file> ],
)]

=== Test Hardware Specification

For completeness's sake, we briefly describe the system used in the benchmarking.
The benchmarks are performed on a `Dynabook Inc. Satallite Pro A50EC` with 16 GiB memory, an `Intel® Core™ i5-8250U x 8` processor and an `Intel® Graphic UHD Graphics 620 (KBL GT2)`.
The installed operating system is a Fedora Workstation 39 (64-bit), and firmware version 2.70.
It should further be noted that both the query engine and SolidBench run on this machine.
As a result, our benchmark does not truly capture the large delays an @http request causes over a real network. 

=== Choke Point Queries

We evaluate the vocabulary using multiple queries, each query testing a specific choke point.
The choke points we will be testing are:
+ *Create new resource*: @fig:insert-data-complete
+ *Update resource, no move*: @fig:insert-where-tag, @fig:insert-data-tag, @fig:delete-tags, @fig:delete-data-tag
+ *Update resource, move*: @fig:delete-insert-id
+ *Illegal update resource*: @fig:insert-data-id, @fig:delete-data-id
+ *Delete resource*: @fig:delete-data-complete, @fig:delete-where-complete

The queries should cover all different queries from the update @sparql specification (see @sec:sparql-query-types).
Because we want to cover all types of queries, some choke points are represented by more than one query.


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
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
prefix res: <http://localhost:3000/pods/00000000000000000096/posts/2024-05-08#>

INSERT {
    res:416608218494388 ?p tag:Cheese
} where {
    res:416608218494388 ?p tag:Austria
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


=== Choke Point: Create New Resource <sec:choke-new-resource>

#let prec = 3

The creation of a new resource is a type of query where we know we should find the collections the resource belongs to and store it there.
The non-@sgv variant of query @fig:insert-data-complete simply replaces the base @uri with the named node we decided for the resource.
The execution time results are given in @fig:res-insert-data-complete.
As expected, the @sgv engine is always slower.
It is, however, still within the expected range.
The ratios are in respective order: $#calc.round(22/35, digits: prec)$ ; $#calc.round(6/7, digits: prec)$ ; $#calc.round(10/13, digits: prec)$ ; and $#calc.round(23/35, digits: prec)$ .
Interestingly, we see that the execution time varies more between fragmentation strategies than it does between using @sgv or not.

#figure(
  insert-data-complete,
  caption: [Average execution time of insert data complete query (@fig:insert-data-complete) over 100 runs]
) <fig:res-insert-data-complete>

=== Choke Point: Update Resource, No Move

A different kind of choke point is simply a query that results in the same behaviour under @sgv as it does without @sgv.
We evaluate a set of queries that simply modify the resource without moving it in any way.


@fig:res-insert-where-tag, @fig:res-insert-data-tag, @fig:res-delete-where-tags, and @fig:res-delete-data-tag show the execution time of respectively query @fig:insert-where-tag, @fig:insert-data-tag, @fig:delete-tags, and @fig:delete-data-tag.
Each of those execution times is lower than those in the previous section.
The ratios of @sgv[-]operations over non-@sgv[-]operations per second are:
- For @fig:res-insert-where-tag\: $#calc.round(7/15, digits: prec)$ ; $#calc.round(4/8, digits: prec)$ ; $#calc.round(7/15, digits: prec)$ ; and $#calc.round(7/15, digits: prec)$
- For @fig:res-insert-data-tag\: $#calc.round(5/15, digits: prec)$ ; $#calc.round(3/8, digits: prec)$ ; $#calc.round(5/15, digits: prec)$ ; and $#calc.round(5/15, digits: prec)$
- For @fig:res-delete-where-tags\: $#calc.round(7/15, digits: prec)$ ; $#calc.round(4/8, digits: prec)$ ; $#calc.round(7/15, digits: prec)$ ; and $#calc.round(7/15, digits: prec)$
- For @fig:res-delete-data-tag\: $#calc.round(5/15, digits: prec)$ ; $#calc.round(3/8, digits: prec)$ ; $#calc.round(5/15, digits: prec)$ ; and $#calc.round(5/15, digits: prec)$

Although these ratios are still better than the hypothesized $0.25$, they are significantly worse than the previous section.
That's to be expected because the @sgv enabled a query engine has to perform more steps now.
Even tough it is worse across the board, we still see that the fragmentation strategy plays a roll.

#figure(
  insert-where-tag,
  caption: [Average execution time of insert where tag query (@fig:insert-where-tag) over 100 runs]
) <fig:res-insert-where-tag>

#figure(
  insert-data-tag,
  caption: [Average execution time of insert data tag query (@fig:insert-data-tag) over 100 runs]
) <fig:res-insert-data-tag>


#figure(
  delete-where-tags,
  caption: [Average execution time of delete where tags query (@fig:delete-tags) over 100 runs]
) <fig:res-delete-where-tags>

#figure(
  delete-data-tag,
  caption: [Average execution time of delete data tag query (@fig:delete-data-tag) over 100 runs]
) <fig:res-delete-data-tag>


=== Choke Point: Update resource: Move

This choke point is a vital one to defend @sgv as it is impossible to write a @sparql query that would show the same behaviour as the @sgv move.
@sparql is unable to select the @cbd.
Since a move moves the whole @cbd to a potentially new @http document, and @sparql is unable to select the @cbd, we required a different approach.
We compare the @sgv query engine to the execution of two queries in parallel, one delete data query and one insert data query.

@fig:res-delete-insert-id shows the execution times of query @fig:delete-insert-id.
The ratios of operations are:
$#calc.round(7/11, digits: prec)$ ; $#calc.round(2/4, digits: prec)$ ; $#calc.round(5/12, digits: prec)$ ; and $#calc.round(7/12, digits: prec)$
We can thus conclude that our hypothesis is still valid.
Again, we highlight the difference between fragmentation strategies.
Clearly, the delay experienced from loading the large file in the case all posts are stored in the same file is significant.

#figure(
  delete-insert-id,
  caption: [Average execution time of delete insert ID query (@fig:delete-insert-id) over 100 runs]
) <fig:res-delete-insert-id>

=== Choke Point: Illegal Update Resource

In this choke point, we evaluate queries that are rejected by an @sgv engine.
The behaviour is again different from a non-@sgv\-aware engine.
The resulting resources of a normal engine are considered wrong.
The execution time ratios are good in this case because the @sgv engine need not apply the changes.
It can therefore terminate execution early.
We have two queries, namely @fig:insert-data-id and @fig:delete-data-id, their execution times can be found in respectively @fig:res-insert-data-id and @fig:res-delete-data-id. The ratios are:
- for @fig:res-insert-data-id\: $#calc.round(12/15, digits: prec)$ ; $#calc.round(5/8, digits: prec)$ ; $#calc.round(12/15, digits: prec)$ ; and $#calc.round(12/15, digits: prec)$
- for @fig:res-delete-data-id\: $#calc.round(12/15, digits: prec)$ ; $#calc.round(5/8, digits: prec)$ ; $#calc.round(12/15, digits: prec)$ ; and $#calc.round(12/15, digits: prec)$

These results confirm our hypotheses.

#figure(
  insert-data-id,
  caption: [Average execution time of insert data ID query (@fig:insert-data-id) over 100 runs]
) <fig:res-insert-data-id>

#figure(
  delete-data-id,
  caption: [Average execution time of delete data ID query (@fig:delete-data-id) over 100 runs]
) <fig:res-delete-data-id>


=== Choke Point: Delete Resource

Queries under this choke point have the same behaviour for both an @sgv\-enabled engine and an engine that is not @sgv\-enabled.
@fig:res-delete-data-complete and @fig:res-delete-where-complete show the execution time for respectively query @fig:delete-data-complete and @fig:delete-where-complete.
The ratio of operations between @sgv and raw are:
- @fig:res-delete-data-complete\: $#calc.round(5/14, digits: prec)$ ; $#calc.round(3/8, digits: prec)$ ; $#calc.round(5/14, digits: prec)$ ; and $#calc.round(5/15, digits: prec)$
- @fig:res-delete-where-complete\: $#calc.round(7/15, digits: prec)$ ; $#calc.round(4/8, digits: prec)$ ; $#calc.round(7/14, digits: prec)$ ; and $#calc.round(7/15, digits: prec)$
These ratios confirm our hypothesis.


#figure(
  delete-data-complete,
  caption: [Average execution time of delete data complete query (@fig:delete-data-complete) over 100 runs]
) <fig:res-delete-data-complete>

#figure(
  delete-where-complete,
  caption: [Average execution time of delete where complete query (@fig:delete-where-complete) over 100 runs]
) <fig:res-delete-where-complete>


=== Conclusion

In conclusion, our hypothesis holds when we compare the execution time and @http request count of an @sgv query engine to a non-@sgv engine that executes the same operations that the @sgv engine would take.
Unfortunately, when a move of the @cbd of a resource is required,
a developer cannot use a @sparql query engine, since @sparql is not expressive enough to describe the @cbd.
In case such behaviour is desired, a manual interaction with the interface is required.

A different approach might be to use the "DESCRIBE" query of @sparql that is sometimes implemented as the @cbd of a resource.
However, since this choice is implementation-specific, and is not required by the @sparql spec, using describe to get the @cbd is not advised.

