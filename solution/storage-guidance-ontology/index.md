---
title: Storage Guidance Ontology (SGO) (WIP)
---

After the [meeting of 21 november 2023](../../meetings/meeting_ruben_taelman_21_11_2023.md)
we can start writing an ontology that guides automated clients in performing updates as instructed by pod owners.

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

CHECK: https://link.springer.com/article/10.1007/s41870-023-01583-2

## Visual Representation
<script type="module">
    import mermaid from '/static/mermaid/mermaid.esm.min.mjs';
    mermaid.initialize({ startOnLoad: true, theme: 'forest', securityLevel: 'loose' });
</script>

<pre class="mermaid">
&#45;&#45;&#45;
title: Connection legend
&#45;&#45;&#45;

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
&#45;&#45;&#45;
title: Diagram explaining sgo
&#45;&#45;&#45;
classDiagram
  direction TB
  C ..> UC
  C ..> SC
  class C["Container"] {
    "Super type of all containers"
    + one-file-one-resource
    + Client Control
  }

  UC --> UC
  UC --> SC
  class UC["Unstructured Containers"] {
    "Can link to any where.
    Default LDP"
  }

  SC ..> CC
  SC ..> DC
  SC ..> GC
  class SC["Structured Container"] {
    "Any container that is a tree and not a graph"
    + Materialization
    + Update Condition
    + Retention Policy
  }
 
  CC --> GC
  class CC["Canonical Container"] {
    "Stores data matching the shape"
    + Resource desccription
    + Save Condition
  }

  DC --> GC
  class DC["Derived Container"] {
    "Contains data from one or more Canonical containers"
    + Resource Description
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


  GC --o GS
  class GS["Group Strategy"] {
    + sparql-map
  }

  SC --o M  
  class M["Materialization"] {
    + Default
    + File
    + Container
  }

  CC --o SaveCond
  class SaveCond["Save Condition"] {
    + state-required
    + always-stored
    + prefer-other
    + prefer-most-specifc
    + only-stored-when-not-redunant
    + never
  }

  CC --o RD
  DC --o RD
  class RD["Resource Description"] {
    + shacl-descriptor
  }

  SC --o UCond
  class UCond["Update Condition"] {
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

link C "#containers"
link CControl "#client-control"
link UC "#unstructured-containers"
link SC "#structured-containers"
link CC "#canonical-container"
link DC "#derived-container"
link GC "#grouping-container"

link RP "#retention-policy"
link M "#materialization"
link SaveCond "#save-condition"
link UCond "#update-condition"
link RD "#resource-description"
link GS "#group-strategy"
</pre>


[Multiple pods?](#multiple-pods)


## Containers
We differentiate between different kinds of containers.
Containers are structured or unstructured.
Currently, only unstructured containers exist.
The storage guidance ontology introduces structured containers as a way
for pod owners to opinionate their data storage.  

All containers are able to specify the level of client control,
whether they ensure that each file has only one resource.
After going into detail on those new properties,
we introduce the different kinds of containers and explain them.

### One File One Resource
This is a flag that states that each resource,
recursively contained in this container, is materialized in a single file.
This essentially means that resource identifiers in this container are free of
[fragments](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Identifying_resources_on_the_Web#fragment).

Using LDP as a file system mapping can entail data duplication in case this flag is not set.
When this flag is set, the file system can use hard or soft links to link to resources in derived containers.
Not having data duplication creates higher quality data storage.

This flag is on by default in case a pod uses a sparql endpoint.


### Client Control
Client control can be given in certain strength to ensure freedom of clients or prefer more stable pods.
Following `ldp:contains` predicates should only resolve containers that have a stricter client control.
Note that this can create problems in `ldp:contains` cycles.

We list the different `sgo:client-control` types from least strict to most strict. 

* `sgo:free-client`: Client is free to do what they desire
* `sgo:additional-allowed`: Additional replications are allowed.
* `sgo:allowed-when-not-preffered`: 
   The client can decide where to store something if no one else explicitly wants it
* `sgo:allow-when-not-claimed`: The client can decide where to store something if no one else wants it.
   The difference with `sgo:allowed-when-not-preffered` is that,
   here we do not have control over resources matched using `sgo:only-stored-when-not-redundant`.
* `sgo:no-control`: The client is not allowed to express any opinion.

### Unstructured Containers
Unstructured containers are like the existing LDP containers.
It allows circular containment, something that is not allowed in a structured container.
A container that has a shape tree description is still deemed unstructured.

### Structured containers
Structured containers are newly introduced containers in sgo.
They only allow hierarchical structure and allow pod owners to specify how they want to store data.
A structured container can only contain other structured containers.

Structured containers allow you to specify:
* [Retention Policy](#retention-policy)
* [Materialization](#materialization)
* [Update Conditions](#update-condition)

Different structured containers exist:
* Canonical Container
* Derived Container
* Grouping Container

We start by explaining the different properties available to all structured containers.
After we have gone over the different properties, we dive into the types of structured containers.

#### Retention Policy
OPTIONAL  
A user can define [LDES](https://semiceu.github.io/LinkedDataEventStreams/#retention)
inspired retention policy and warn applications that generate a lot of data (e.g. event streams),
that they should regularly aggregate their data.
This could work just like a garbage collector.
Based on a certain time attribute, a garbage collector cleans the data.
Currently, only DurationAgoPolicy seems like a nice addition.

#### Materialization
A container can specify how the resources it contains are materialized.
The available options are:
* `sgo:materilize-default`: This container contains files and resources.
  If a sub-container is created with only one resource, create a file instead.
* `sgo:materialize-file`: This container contains only files.
   When in a grouping container where the names are not unique, but this is a `one-file-one-resource`-container,
   the operation should error.
* `sgo:materialize-container`: This container contains only containers.

#### Update Condition
In this section, we answer the question "How do we react to the change of a resource?"

Instances of `sgo:update-condition`:
* `sgo:update-keep`: No matter how the resource is updated, leave it where it is.
   As a result, the index and widen the resource selection shapes might need to be updated.
* `sgo:update-prefer-static`: Prefer to keep the resource where it is,
   but change the location in case the shape description does not match anymore. 
   In that case, remove the resource and add it again.
* `sgo:update-best-match`: Move to best matched container.
   Always remove the object and add it again, doing this will make sure the location is optimal.
* `sgo:update-disallow`: Do not allow updates over this container in any case.

#### Canonical Container
A canonical container saves resources, it can only contain grouping containers.
It selects focussed resources using a resource description.
When a resource matches the desired description,
the container can still state that it gives precedence to other containers using save conditions.

##### Resource description
Currently, we only work with a SHACL shape selector, `sgo:shacl-descriptor`.
When working with
[shape trees](https://shapetrees.org/TR/specification/),
the shape selector can either be equal to the shape of the shape tree or can be more loose than it.
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


###### Save Condition
A container might not always want to save a resource,
this section answers the question "When should those resources be stored?"
There are different instantiations of `sgo:save-condition`:
* `sgo:state-requirements`: A SPARQL query that is coerced to boolean and checks if the solid pod is in a correct state.
* `sgo:always-stored`: Store the data in case the description matches.
* `sgo:prefer-other`: Only save when none of the containers found by following
  `sgo:prefer-other` one or more times stores the resource.
* `sgo:prefer-most-specifc`: Dynamic generation of `sgo:prefer-other`.
* `sgo:only-stored-when-not-redundant`: Stores only when no one else stores it,
   a dedicated container could be set up instead of falling back to an exception.
   If multiple containers match using this condition, choose a random one to store it in.
* `sgo:never`: Do not allow storage


#### Derived Container
A derived container without a save condition behaves like a view.
When a container is a view, a query engine can discover this, and optimize its query plan.
When exploring data in this container, the canonical containers need not be checked.



#### Grouping Container
A grouping container allows to group resources selected by container this is in (or is equal to).

##### Group Strategy
Currently, only one instance of `sgo:group-strategy` exist.
It specifies a group strategy using a SPARQL query that acts like a map function.

The object of `sgo:sparql-map` should be a SPARQL select query over the resources in the scoped collection
returning `?key` and `?value`
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

### ACID

MAYBE: https://www.yugabyte.com/blog/yes-we-can-distributed-acid-transactions-with-high-performance/

What follows can be dismmised, CAP theorem tells us we need to choose
what we want. Typical options are either ACID or BASE.
Distributed databases typically choose BASE. I wonder whether solid can go for ACID?  

Requires a smart server and might be out of scope of this thesis work.
Nevertheless, we make the exercise of describing a transactional system using the storage guidance ontology.

ACID can be implemented using the garbage collector and some rules that ACID enabled clients should follow.
An ACID enabled container can proclaim that a transaction can be started and that a transaction can take a certain time.
It can use a `Retention Policy` to enforce the duration.

Two solid pods Alice and Bob: As Alice, move resource from Alice to Bob:
* Create a `sgo:start-transaction` on both alice and bob. the creation of this acts as a lock.
  The lock of Bob point to the lock of Alice, we deem Alice's lock as canonical and interact with it using
  `https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Unmodified-Since`
  A lock has a creation data and a list of containers and resources it locks.
  An agent should request a lock on all resources it wants to access during the transaction,
  this solves death locks, because servers can check whether requesting locks would create circular dependencies.   
* The client waits until both are created, a server can garbage collect the resource.
* The client now creates a new resource in each pod that describes the modifications made.
  The resources have a property `sgo:acid-force-when` that forces the garbage collector
  to finish the resource in case the condition is matched.
  This condition will be: if the changes come through in the other container.
* Again, we wait on the creation of both resources.
* When both are created, now change both resources.
  In case one update fails, the garbage collector will need to materialize the changes because the other update passed.

NOTE: You have a race condition!
Bob's canonical is in the process of being changed, but it has not been changed yet 

More failures: if commit to A and B, and B does not receive, then A commits and dies.
B has no way of knowing whether A committed or not.

Always use `sgo:state-requirements` to validate that locks have not been garbage collected!

ACID support can also be done by a server that allows storage in case some `sgo:state-requirements` match.

It might be better to handle this at a lower level.
Enabling ACID on http2 enabled connections where a transaction needs to happen in a single tls connection.
The server is in those cases sure that a server is still responsive (open connection).
ACID over the web?


## Shape descriptions

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
