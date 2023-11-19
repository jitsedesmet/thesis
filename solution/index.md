---
title: Solution
---

In our [user stories](../user-stories/index.md) we discussed LDP to not be a well suited technology.
However, LDP is unlikely to disappear from the specification, and thus our solution should also work with it.

There would be two ways of thinking about an insert
1. I have a resource, where should I place it, and how should I change the indices?
2. I have a resource, I store it in the pod,
   what resources should link to my new resources, and how should I change the indices?

The second option allows us to think independently of the resource hierarchy specification.
Specifications like Shape trees have the same kind of limitations stating:
> While [=shape trees=] are intended to adapt to different technology platforms
that support the notion of [=containers=] and [=resources=], examples in this
specification will reflect usage in an [[LDP]] environment.

Having the specification work without many requirements on other specifications allows for a broader implementation.
For example, asking question two could even be used in extracting views in the TREE/ LDES specifications. 
