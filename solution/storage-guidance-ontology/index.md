---
title: Storage Guidance Ontology (SGO) (WIP)
---

After the [meeting of 21 november 2023](../../meetings/meeting_ruben_taelman_21_11_2023.md)
we can start writing an ontology that guides automated clients in performing updates as instructed by pod owners.

## Visual representation
<script type="module">
    import mermaid from '/static/mermaid/mermaid.esm.min.mjs';
    mermaid.initialize({ startOnLoad: true, theme: 'forest', securityLevel: 'loose' });
</script>

<pre class="mermaid">
classDiagram
    SG "1" -- "1..*" SC
    SG "1" -- "1..*" RD
    SG "1" -- "1..*" GS
    SG "1" -- "1..*" CC
    SG "1" -- "1..*" M
    class SG["Storage Guidance"]{
        Save Condition
        Resource Description
        Group Strategy
        Client Control
        Materialization
    }
namespace StorageGuidanceOntology{
    class SC["Save Condition"]{
        Always
        Derived `from?`
        `Hierarchical?`
        Only Stored When Not Redundant
        None
    }
    class RD["Resource Description"] {
        SHACL
    }
    class GS["Group Strategy"]{
        SPARQL Description
        `END NODE?`
    }
    class CC["Client Control"] {
        Free Client
        Additional Allowed
        Allowed When Not Prefferd
        Allow When Not Claimed
        No Control
    }
    class M["Materialization"] {
        One File One Resource
        One File multiple Resources
    }
}
link SG "#"
link SC "#save-condition"
link RD "#resource-description"
link GS "#group-strategy"
link CC "#client-control"
link M "#resource-materialization"
</pre>

## Reusing Existing Ontologies
When writing a new ontology, it is important to use existing ontologies as much as possible,
or express the relation of your ontology to existing ones as much as possible.

We can use most parts of [shape trees](https://jitsedesmet.github.io/shape-trees-spec/).

### OPTIONAL Retention Policy
A user can define [LDES](https://semiceu.github.io/LinkedDataEventStreams/#retention)
inspired retention policy and warn writers of event streams, for example,
that they should regularly aggregate their stream data.
This could work just like a garbage collector.
Based on a certain time attribute, a garbage collector cleans event streaming data.


## Adding new components
### Save Condition
`sgo:save-condition`
#### sgo:always-stored/ sgo:canonicalContainer
Just stores the data in case the description matches.

#### sgo:derived-container
A derived container can use soft links in specific LDP cases.
It could also describe a construct query in the case of SPARQL endpoints.


#### sgo:only-stored-when-not-redundant
Stores only when no one else stores it, a dedicated container could be set up instead of falling back to an exception.

Q: What if multiple containers say this about a resource?  
A: Pick a random container, the user does not care.

#### sgo:none
Stores only when no one else stores it, a dedicated container could be set up instead of falling back to an exception.

Q: What if multiple containers say this about a resource?  
A: Pick a random container, the user does not care.

### Resource Description
`sgo:shape-selector`
#### [SHACL](https://www.w3.org/TR/shacl/)  
The shape selector can either be equal to the shape of the shape tree or can be more loose than it.
This allows containers to dynamically allow for stretching the shape description.

Shape description needs to be able to say both.
-> You can use [logical constraint components](https://www.w3.org/TR/shacl/#core-components-logical)
  1. Picture contains son or daughter: 
  2. picture contains son and daughter

Should be able to state dates after x
-> You can use 
[Property Pair Constraint Components](https://www.w3.org/TR/shacl/#core-components-property-pairs)
more precisely the [lessThan rule](https://www.w3.org/TR/shacl/#LessThanConstraintComponent).


### Group Strategy
`sgo:group-strategy`
#### sgo:groupsBy ?GroupDescription
`?GroupDescription` should be a SPARQL select query over the resources in the scoped collection returning `?key` and `?value`
The key is the resource identifier, the value an `xsd:string` representing the directory name.
For this allows for complex splits like: `rome-23-07-2023`?
Would be a restriction to `xsd:string` that defines a sparql query with format,
that allows only bind and property path starting from ?key.
The query would be executed over all members of the container, and the first result would be for each.
For example
```sparql
PREFIX ex: <http://example.org/>
SELECT ?key ?value where {
    BIND(CONCAT(STR(?name), "-", STR(?date)) as ?value) .
    ?key ex:creationDate ?date;
    ?key ex:location [
        ex:locatedIn* [
            a ex:city ;
            ex:label ?name ;
        ] .
    ] .
}
LIMIT 1
```

Maybe this poses a security issue (execution of queries), and we should also add a description?


### Client Control
`sgo:client-control`  
Client control can be given in certain strength to ensure freedom of clients or prefer more stable pods. 

#### `sgo:free-client`
Client is free to do what they desire


#### `sgo:additional-allowed`
Additional replications are allowed.


#### `sgo:allowed-when-not-preffered`
The client can decide where to store something if no one else explicitly wants it.


#### `sgo:allow-when-not-claimed`
The client can decide where to store something if no one else wants it.

The difference with `sgo:allowed-when-not-preffered` is that here we do not have control over resources matched using
`sgo:only-stored-when-not-redundant`.


#### `sgo:no-control`
The client is not allowed to express any opinion.


### ACID
TODO: We probably need some more complex sync system for this?


### resource materialization 
`sgo:materialization`
#### sgo:one-file-one-resource
Describes that each resource has its own file and no multiple resources reside in one file.
This essentially means that resources in this container are free of
[fragments](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Identifying_resources_on_the_Web#fragment).
As a result, we do not need to duplicate any data, and the notion of storage location fades.
We can use pure linked data to express relations between resources.
This flag is always set in a SPARQL endpoint.

#### sgo:one-file-multiple-resources
States that each file in the subdirectory can contain multiple files.
Forces duplication in many systems, which can cause data quality issues.

## Use cases
### What if no preference matches the new resource?
#### Notification
You would describe a notification container with a `save-condition` as `only-stored-when-not-redundant` with a
shape selector that is empty (matches anything).
`sgo:client-control` would be `sgo:allow-when-not-claimed`.

#### Assume
Same as above but more relaxed client control.

#### Deny
Do not declare a notification container so no one matches the insert and do not allow client opinions by using a
`sgo:client-control` of `sgo:no-control`.

## Shape:
```turtle
@prefix ex: <http://example.org/> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix sgo: <http://www.storage-guidance-ontology.com/>.

sgo:main-shape
    a sh:NodeShape;
    sh:property [
       sh:path ldbc:firstName ;
       sh:minCount 1 ;
       sh:maxCount 1 ;
       sh:datatype xsd:string ;
       sh:name "Given Name" ;
    ] ;
.
```


### Shape descriptions
We decide that the update guidance is not part of the resource for now.
The storage guidance system depends on shape-trees to define itself.

Let's start by adding on the
[physical example of shape trees](https://jitsedesmet.github.io/shape-trees-spec/#shapetree-physical)
working on top of LDP.
```turtle
@prefix ex: <http://example.org/> .
PREFIX st: <http://www.w3.org/ns/shapetrees#>.
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>.
PREFIX ex: <http://www.example.com/ns/ex#>.
PREFIX sgo: <http://www.storage-guidance-ontology.com/>.

<> st:describedBy ex:project-en, ex:project-es, ex:project-nl, ex:project-ko .

<#ProjectTree>
  a st:ShapeTree ;
  st:expectsType st:Container ;
  st:shape ex:ProjectShape;
  sgo:groupByEqualObject ex:project-name; 
  st:contains <#MilestoneTree> .

<#MilestoneTree>
  a st:ShapeTree ;
  st:expectsType st:Container ;
  st:shape ex:MilestoneShape ;
  st:contains <#TaskTree>, <#IssueTree> .

<#TaskTree>
  a st:ShapeTree ;
  st:expectsType st:Container ;
  st:shape ex:TaskShape ;
  st:contains st:NonRDFResourceTree .

<#IssueTree>
  a st:ShapeTree ;
  st:expectsType st:Container ;
  st:shape ex:IssueShape ;
  st:contains st:NonRDFResourceTree .
```


## Ontology Evaluation
In this section,
we evaluate an automated client that uses ACP and our ontology guidance system to the user stories for each storage mechanism.
The ontology we created could work on different storage mechanisms with different effectiveness.
We do not consider data-discovery mechanism as this is actively being researched by query experts,
and we believe an index should provide update mechanism themselves.
In future research, it might be beneficial to also consider updating the index as part of the update query. 
We further assume the use of SPARQL as it allows users to enter broad queries that are in line with our
[data dependence requirements](../../user-stories/stories.md). 

* [LDP](LDP-evaluation.md)
* [SPARQL endpoint](SPARQL-endpoint-evaluation.md)
* [LDES](LDES-evaluation.md)
