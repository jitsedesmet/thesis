---
title: Meeting Ruben Taelman 7 December 2023
---

## Going into the meeting
The plan is to look at [sgv](../solution/storage-guidance-vocabulary/index.md).
Statements made are applicable to the [archived version of sgv](../archive/sgo-07-12-2023.md).

## During the meeting

The `one-file-one-resource` flag does not need to be developed in the scope of the thesis since it's an edge case.
An alternative to the flag would be to create an ontology used by a derived container 
that contains links to the canonical containers. 


It was pointed out that a SPARQL endpoint does not require an LDP container.
What would be possible is to have an LDP server that is smarter than just being a file system mapping.
This kind of server would have own reasoning allowing, for example,
the [sgo:state-requirements](../archive/sgo-07-12-2023.md#save-condition) to be computed by the server.

When using the [assume use case](../archive/sgo-07-12-2023.md#use-cases),
the client enjoying relaxed client control should always provide an `sgo` description of newly created resources.
Supplying this information should allow other applications to also find the resources.

When a power user, using the [notification use case](../archive/sgo-07-12-2023.md#use-cases)
would use an application generating an `sgo-notification`, it could be nice to resolve it instantly.
The user could be greeted with a user dialog where it should resolve the placement.

Different structured containers exist: links


An additional update condition could be an alternative to `update-keep` using a distance metric.

An alternative to the [SPARQL group strategy](../archive/sgo-07-12-2023.md#group-strategy) would be the use of
something used by [TPF](https://linkeddatafragments.org/specification/triple-pattern-fragments/).
Namely [URI templates](https://datatracker.ietf.org/doc/html/rfc6570).
Both can exist, the benefit of the sparql notation is that you have access to the world,
while using URI templates combined with the shape description has an easier notation.

A sparql endpoint could be viewed as a canonical container,
derived containers could be used to group multiple endpoints, or to get an LDP view over the container.   

A name change of `storage guidance ontology` to `storage guidance vocabulary` was proposed.

## Conclusions

What should be done now is:
1. Apply the comments above
2. Evaluate the vocabulary for `LDP`, `LDES` and `SPARQL-endpoints`. Might not go so smoothly.
3. Decide what would be useful and feasible to implement in the context of a thesis. 
