# TREE

The tree spec seems quite interesting. It is a way of describing views over a collection of resources.
Each view allows you to access the whole collection.
TREE also describes pagination and search queries.

`sh:NodeShape` allaws you to describe the members in a collection.

A `tree:node` is a page that allows to navigate through its `tree:relation` predicates.

It can be used as an alternative to LDP when you view a solid pod as a single collection and describe views over a whole pod.
It also allows you to have notes split using the `tree:EqualToRelation` to for example express you want your pictures grouped by date.

A TREE view does not have a description.
This means that the entire tree needs to be traversed before you find an answer.  
