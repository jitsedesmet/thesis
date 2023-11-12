# [Type Index](https://solid.github.io/type-indexes/)

The type index specification was a way of discovering data within a solid pod.
Now it has been replaced by [shape trees](shape-trees.md).

The type index spec surrounds a public and a private type index.
The private index is accessible only by the owner of that pod, while the public is accessible by anyone.
The split between public and private is in the context quite arbitrary and caused privacy issues.
Types would be present in the public type index, but inaccessible by certain agents.
This meant that user would know the pod contained certain types of data, but they could not access it.
This is a privacy concern.

Since the type index clearly has privacy issues and is being replaced by [shape trees](shape-trees.md),
we will not go into detail.
