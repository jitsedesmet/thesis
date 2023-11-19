---
title: SPARQL (WIP)
---

[SPEC](https://www.w3.org/TR/2013/REC-sparql11-overview-20130321/)

SPARQL is an important Linked Data query language.
The specification is currently at version 1.1 and a version [1.2 is being developed](https://github.com/w3c/sparql-dev).
SPARQL 1.0 will not be referred to in this document since SPARQL updates were only introduced in version 1.1.

SPARQL even has support for federated querying,
where you can specify a sub-query that will be answered by the described remote.

The querying part:
> SPARQL contains capabilities for querying required and
> optional graph patterns along with their conjunctions and disjunctions.
> SPARQL also supports aggregation, subqueries, negation, creating values by expressions, extensible value testing,
> and constraining queries by source RDF graph.


The update part:
> It uses a syntax derived from the SPARQL Query Language for RDF.
> Update operations are performed on a collection of graphs in a Graph Store.
> Operations are provided to update, create, and remove RDF graphs in a Graph Store.

Updates are performed on a Graph Store.
An insert query is defined to just insert the triple in the store (without the notion of location).

SPARQL assumes that all data comes from some store it knows upfront.
Although there are ways to dynamically find data, like, for example, Link Traversal Query Processing.
In LTQP you start from a starting point and start differencing URIs you find.
This process needs to be stopped at some point since traversing the whole web would not be possible.
When performing LTQP, the user should be comfortable with not having completeness guarantees.



