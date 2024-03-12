---
title: Intermediate Defence 15 February 2024
---

## Going into the meeting
I have prepared a [presentation](/presentation/intermediate-presentation.html).

## During the meeting
Questions:
* Are you dependent on SPARQL?
* You cannot see the smaller letters on screen. -> Maybe use vh instead of pt.
* RESTful (One l).
* The hypothesis on additional requests should compare itself with a client that walks through the container structure.
It should thus read the ShapeTree interface.
If not, your additional is dependent on the structure of the data. How deep do directories run?
* It would be interesting to see how good/ bad certain interfaces are.
For example, if you want to update some data that is duplicated a lot (like someone's name),
An LDP interface will be bad requiring a multitude of http requests.
It might be that an interface that has something like an inbox is much more performance.

## Conclusions
Contact Brian and Jonni to see how I can use the SolidBench type index abstraction layer to also add sgo.

Start by fining which concrete queries I should evaluate?
Find a few good update queries to start with.

Benchmarks are developed based on checkpoints.
Analyze existing benchmarks and find the bottleneck.
https://github.com/SolidBench/SolidBench.js/blob/master/docs/choke-points.md