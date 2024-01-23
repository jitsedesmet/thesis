---
title: Thesis Jitse De Smet
---

Repo for my thesis work. (Don't expect this to be too organized. It's just a way of sharing thoughts + backups)

## Intro

Right now research surrounding Solid focuses on the Read part of 
[CRUD](https://en.wikipedia.org/wiki/Create%2C_read%2C_update_and_delete).
The other components are, however, also vital for the effectiveness of the 
[Solid specification](https://solidproject.org/).
The question we ask ourselves in this thesis is:
> How to abstract data updates in a permissioned decentralized environment behind a query abstraction layer?

## Qualitative study

Since no well-established technology exists,
a quantitative study is not possible because there is no baseline to compare our solution against.
Instead, we will [construct user stories](/user-stories) and evaluate whether current technologies satisfy the requirements.

## Metrics

If the qualitative study shows that no existing solution is sufficient,
we plan on researching a way to effectively satisfy the requirement of our user stories.
We can measure the performance of our alternative based on how well it satisfies the requirements.

The solution we suggest is described in a [solution section](solution/index.md)

## Hypotheses

I think we should construct these right before looking into an own alternative? (If we need it) 

## Using shapes

To test our implementation, we will use [SolidBench.js](https://github.com/SolidBench/SolidBench.js).
Shape descriptions for each object can be found [here](https://github.com/jitsedesmet/SolidBench.js/blob/feat/add-shapes/shape-descriptions.ttl).


## Out of scope

Some research questions regarding updates will not be touched upon in this thesis, but might still be interesting:
* Conflicts (multiple people fail at the same time)? (Can use https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Unmodified-Since like a semafoor?)
* Unstable internet
* When to flush? (regarding CRDTs)
* Local cache?
* What about doubles?
