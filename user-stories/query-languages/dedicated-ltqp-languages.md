---
title: Dedicated LTQP languages (WIP)
---

When reading this: note that sparql updates git introduces only in SPARQL 1.1 in mar.2013

## The linked media framework: Integrating and interlinking enterprise media content and data
The paper was written in 2012; at that time, SPARQL did not support updates.

(LDP) exists since 2007

The Paper proposes to use REST principles in LD (natural extension).
They say three ways of querying already exist:
1. Central index that can be queried (languages like SPARQL assume you know the world)
2. Federated querying, where you send sub-queries to different (few) known datasets that make up the world for you.
3. Accepting the incompleteness of results and working, embracing it (Hartig, later wrote Link Traversal)

The writers then go on to introduce a Linked Data Path query language.
This is a resource-centric query language.
You start with one or more resources, and construct a path from that resource to resources you are interested in.
SPARQL also has a path language aspect in the form of
[Property Paths](https://www.w3.org/TR/sparql11-query/#propertypaths).
LDPath and Sparql still differ in several aspects, the most important one for us being:  
LDPath restricts expressiveness, sparql allows you to start from any resource and assumes you know the world. 
Using LDPath you can close the world around the query you wrote.

Having the notion of focused resources also creates easier updates,
since the language allows you to focus on, for example, a LDP container you could post to create a new resource.  

The problem with property path querying we face is that it breaks the `Access path dependence` by design.


## LDQL: A query language for the web of linked data. Journal of Web Semantics

## NautiLOD: A formal language for the web of data graph

## SPARQL with property paths on the Web
Already mentioned above.
In this context, it would be used more for querying.
In regard to updates, it has the same issues as normal SPARQL, which has a [dedicated page](SPARQL.md). 
