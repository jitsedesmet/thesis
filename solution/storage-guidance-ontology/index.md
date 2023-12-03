---
title: Storage Guidance Ontology (SGO) (WIP)
---

After the [meeting of 21 november 2023](../../meetings/meeting_ruben_taelman_21_11_2023.md)
we can start writing an ontology that guides automated clients in performing updates as instructed by pod owners.

## Visual Representation
<script type="module">
    import mermaid from '/static/mermaid/mermaid.esm.min.mjs';
    mermaid.initialize({ startOnLoad: true, theme: 'forest', securityLevel: 'loose' });
</script>

Legend
<pre class="mermaid">
classDiagram
  A --> B
  class A {
    A ldp:contains B
  }

  AA ..> BB
  class AA {
    Type AA is supertype of type BB 
  }

  AAA --o BBB
  class AAA {
    Type AAA has property of type BBB
  }
</pre>

<pre class="mermaid">
classDiagram
  C ..> MC
  C ..> SC
  class C["Container"] {
    "Super type of all containers"
    + one-file-one-resource
    + Client Control
  }

  MC --> MC
  MC --> SC
  class MC["Mixed Containers"] {
    "Can link to any where"
  }

  SC ..> CC
  SC ..> DC
  SC ..> View
  SC ..> GC
  class SC["Structured Container"] {
    "Any container that is a tree and not a graph"
    + Materialization
    + Update Condition
    + Retention Policy
  }

  CC --> CC
  CC --> GC
  class CC["Canonical Container"] {
    "Stores data matching the shape"
    + Resource desccription
    + Save Condition
  }

  DC --> GC
  class DC["Derived Container"] {
    "Contains data from one or more Canonical containers"
    + Save Condition
  }

  View --> GC
  class View {
    "Contains all data from in one or more containers"
  }

  GC --> GC
  class GC["Grouping Container"] {
    "Groups data in different containers"
    + Group strategy
  }

  SC --o RP
  class RP["Retention Policy"] {
    + duration ago 
  }

  CC --o RD
  class RD["Resource Description"] {
    + shacl-descriptor
  }

  GC --> GS
  class GS["Group Strategy"] {
    + sparql-map
  }

  SC --o M  
  class M["Materialization"] {
    + file
    + container
    + force container
  }

  CC --o SaveCond
  DC --o SaveCond
  class SaveCond["Save Condition"] {
    + state-required
    + always-stored
    + prefer-other
    + only-stored-when-not-redunant
    + never
  }

  SC --o UC
  class UC["Update Condition"] {
    + Always keep & widen index
    + Prefer static
    + Move to best matched
    + Disallow
  }

  C --o CControl
  class CControl["Client Control"] {
    "From least to most restricted,
    can only become more restricted":
    + Free Client
    + Additional Allowed
    + Allow when not preffered
    + Allow when not claimed
    + No control
  }

link SG "#"
link SC "#save-condition"
link RD "#resource-description"
link GS "#group-strategy"
link CC "#client-control"
link M "#resource-materialization"
link RP "#retention-policy"
</pre>

[Multiple pods?](#multiple-pods)

## Reusing Existing Ontologies
When writing a new ontology, it is important to use existing ontologies as much as possible,
or express the relation of your ontology to existing ones as much as possible.

### LDP
LDP containers allow any graph-linking structure of containers.

### Shape trees
This spec can be seen as an extension to [shape trees](https://shapetrees.org/TR/specification/),
but is not limited to it.
Implements are free to link the guidance system on index leven, like on shape trees, or on data level like with LDP.

The examples provided will start from shape trees,
because I like the idea of shape trees and still want to provide context.
I think coupling storage guidance with shape trees allows for clearer management since it reduces the user complexity.
Additionally, it allows users to use the shape descriptions created for shape trees to inspire
resource descriptors for the storage guidance system.


### Retention Policy
OPTIONAL  
A user can define [LDES](https://semiceu.github.io/LinkedDataEventStreams/#retention)
inspired retention policy and warn applications that generate a lot of data (e.g. event streams),
that they should regularly aggregate their data.
This could work just like a garbage collector.
Based on a certain time attribute, a garbage collector cleans the data.
Currently, only DurationAgoPolicy seems like a nice addition.


## Adding New Components
The storage guidance ontology should enclose all information
needed by client and automated agents to correctly store new resources or update existing resources.
Updating existing resources could semantically be done by first removing the triples that need to be removed,
and then revalidating where the resource should be stored.

What follows is an in depth explanation of the different decisions one can make grouped by their theme.
We will ask ourselves different questions and provide answers to them.
1. What resources are of interest to us?
2. How should those resources be grouped?
3. How should those resources be stored/ materialized?
4. When should those resources be stored?
5. How do we react to the change of a resource?
6. How much control do client applications have in regard to storing resources?
7. How do we handle ACID requirements?

### Resource Description
This section answers the question "What resources are of interest to us?"
We therefore introduce a type: `sgo:resource-description`

#### [SHACL](https://www.w3.org/TR/shacl/)
`sgo:shacl-descriptor`
The shape selector can either be equal to the shape of the shape tree or can be more loose than it.
This allows containers to dynamically allow for stretching the shape description.
Both SHACL and SHEX are viable options, but we focus on SHACL since it is a W3C recommendation.

Shape description allows saying both.
  1. The Picture contains son or daughter. 
  2. The picture contains son and daughter

Using [logical constraint components](https://www.w3.org/TR/shacl/#core-components-logical).

Should be able to state dates after x
-> You can use 
[Property Pair Constraint Components](https://www.w3.org/TR/shacl/#core-components-property-pairs)
more precisely the [lessThan rule](https://www.w3.org/TR/shacl/#LessThanConstraintComponent).


### Group Strategy
In this second section, we provide an answer to the question "How should those resources be grouped?"
The predicate we use is:`sgo:group-strategy`.

#### sgo:groupsBy ?GroupDescription
`sgo:sparql-map`
`?GroupDescription` should be a SPARQL select query over the resources in the scoped collection returning `?key` and `?value`
The key is the resource identifier, the value an `xsd:string` representing the directory name.
This construction, mimicking a map function, allows for complex splits like: `rome-23-07-2023`?
The value would is a restriction on `xsd:string` that defines a sparql query with format,
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

### Resource Materialization
Now that we know what resources we are interested in, and how they should be grouped,
we can specify how the next depth should be materialized.
We use the predicate: `sgo:materialization`.

Containers that are derived from containers that all have the sgo:one-file-one-resource materialization constraint are higher quality.
Forces duplication in many systems, which can cause data quality issues.
The reason for this is that they do not require duplication on the materialization side.
Instead, they can use linked data in the case of SPARQL endpoint (all containers are of this kind),
or hard/soft links in the case of LDP.

The basic container is a one-file-multiple resources container.
At chosen depth, you may switch to the `one-file-one-resource` container, all children are the same kind.
This essentially means that resources in this container are free of
[fragments](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Identifying_resources_on_the_Web#fragment).

Materialization can be
1. As file
2. As container
3. Force container


### Save Condition
A container might not always want to save a resource,
this section answers the question "When should those resources be stored?"
We use the `sgo:save-condition` predicate for this.

#### sgo:state-requirements
A SPARQL query that is coerced to boolean and checks if the solid pod is in a correct state.

#### sgo:always-stored
Store the data in case the description matches.

#### sgo:derived-container
A derived container saves the data in case one of the containers it is derived from also saves the data.
In case all canonical containers are `one-file-one-resource` containers, links can be hence duplication is prevented.  
A query engine can see this container as a view over the different containers.
When exploring data in this container, the canonical containers need not be checked.


#### sgo:prefer-other
Only save when none of the containers found by following `sgo:prefer-other` one or more times stores the resource.

Could dynamically be constructed using shape containment and `sgo:prefer-most-specifc`. 

#### sgo:only-stored-when-not-redundant
Stores only when no one else stores it, a dedicated container could be set up instead of falling back to an exception.

Q: What if multiple containers say this about a resource?  
A: Pick a random container, the user does not care.

#### sgo:never
Do not allow storage

### Dynamic Resource Behavior
In this section, we answer the question "How do we react to the change of a resource?"
We use the predicate `sgo:update-condition`.

#### Always keep/ widen current
No matter how the resource is updated, leave it where it is.
As a result, the index and widen the resource selection shapes might need to be updated.  

#### Prefer static
Prefer to keep the resource where it is, but change the location in case the shape description does not match any more.
In that case, remove the resource and add it again.

#### move to best matched
Always remove the object and add it again, doing this will make sure the location is optimal.

#### Disallow
Do not allow updates over this container in any case.

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
Requires a smart server and might be out of scope of this thesis work.
Nevertheless, we make the exercise of describing a transactional system using the storage guidance ontology.

ACID can be implemented using the garbage collector and some rules that ACID enabled clients should follow.
An ACID enabled container can proclaim that a transaction can be started and that a transaction can take a certain time.
It can use a `Retention Policy` to enforce the duration.

Two solid pods Alice and Bob: As Alice, move resource from Alice to Bob:
* Create a `sgo:start-transaction` on both alice and bob. the creation of this acts as a lock.
  A lock has a creation data and a list of containers and resources it locks.
  An agent should request a lock on all resources it wants to access during the transaction,
  this solves death locks, because servers can check whether requesting locks would create circular dependencies.   
* The client waits until both are created, a server can garbage collect the resource.
* The client now creates a new resource in each pod that is used to add describes the modifications made.
  The resources have a property `sgo:acid-force-when` that forces the garbage collector
  to finish the resource in case the condition is matched.
  This condition will be: if the changes come through in the other container.
* Again, we wait on the creation of both resources.
* When both are created, now change both resources.
  In case one update fails, the garbage collector will need to materialize the changes because the other update passed.

Always use `sgo:state-requirements` to validate that locks have not been garbage collected!

ACID support can also be done by a server that allows storage in case some `sgo:state-requirements` match.

It might be better to handle this at a lower level.
Enabling ACID on http2 enabled connections where a transaction needs to happen in a single tls connection.
The server is in those cases sure that a server is still responsive (open connection).
ACID over the web?


### Multiple Pods
Multiple pods can work just like with a single pod.
When you have some kinds of modifying permissions, you should be able to request the storage guidance description.


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
