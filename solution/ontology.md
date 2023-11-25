---
title: ontology description (WIP)
---

After the [meeting of 21 november 2023](../meetings/meeting_ruben_taelman_21_11_2023.md)
we can start writing an ontology that guides automated clients in performing updates as instructed by pod owners.

Do we save?
* derivedContainer
* canonicalContainer
* onlyStoredWhenNotRedundant
* alwaysStored
* resourceSeperated

Resource description:
* Shape description needs to be able to say both
  1. picture contains son or daughter
  2. picture contains son and daughter

container description:
* groupsBy << ?s ?p ?o >>
* groupByEqualObject somePredicate    
  -> TODO: find a ways to say more complex things like: sort first on predicateX, then predicateY. 
* for time series: can say it has a cutoff just like in LDES?

What if no preference matches the new resource?
* Notification
* Assume
* Deny

ACID:  
We probably need some more complex sync system for this?

### Shape descriptions


## Ontology evaluation
In this section,
we evaluate an automated client that uses ACP and our ontology guidance system to the user stories for each storage mechanism.
The ontology we created could work on different storage mechanisms with different effectiveness.
We do not consider data-discovery mechanism as this is actively being researched by query experts,
and we believe an index should provide update mechanism themselves.
In future research, it might be beneficial to also consider updating the index as part of the update query. 
We further assume the use of SPARQL as it allows users to enter broad queries that are in line with our
[data dependence requirements](../user-stories/stories.md). 


### LDP
Privacy stays hard in this case


### SPARQL endpoint
COOL requirement could be fixed here because resource names are UUIDs as proposed in the interoperability spec.

### Linked Data Event streams (considered in lesser regard)
TODO: is a TREE evaluation still needed? 



