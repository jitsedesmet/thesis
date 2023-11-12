# Shape Trees(http://shapetrees.org/)

Shape trees are the proposed replacement to the original type index.
It uses shape descriptions like
[ShEx](https://shex.io/) or [SHACL](https://www.w3.org/TR/shacl/) 
these shapes can be used to validate RDF graphs against a set of conditions.
Applications can use shapes to validate that a Things of a certain type has the expected properties.
It has a strong set of predicates to model relations and cardinalities between entities.

Shape trees can be used in combination with protocols that organize linked data graphs into resource hierarchies,
expressing the layout of the resources and associating those resources with their respective shapes. 
It is the natural extension of shape descriptions to those resource hierarchies. 
Within the solid specification,
shape trees allow a fast discovery of data that is not restricted to the "rdf:type" predicate unlike the type index.
Shape trees also allow you to discover used predicates.
This could be used in [query optimizations](TODO:reference).
The shape trees could be loaded by a query engine and be used as a guide to navigate the solid pod effectively. 

When a resource hierarchy is consistent, we call this shape tree consistency.
This technology does require another technology to define containers and resources.
It relies on LDP for this; as a consequence, some issues of LDP are also transferred.     

The spec defines a predicate `st:contains` that asserts a "physical" hierarchy.
The "physical" relates to how LDP defines contains, however `ldp:contains` does not need to map a physical file system!
The shape tree spec also defines `virtual containment`, this is just another way of realizing directories above the underlying LDP spec.
It means you don't need `ldp:contains` for defining containers, but can define another predicate, and use that predicate to create directories.
Essentially it makes you able to view `ex:apple1` and `ex:apple2` as containing resources of `ex:appeTree`:

LDP does not state anything about IRI form of subjects.
That means that even though containers often have an IRI in the form of `:parent/child/child` this is not required. 

```turtle
@prefix ex: <http://example.org/> .
ex:appleTree
    ex:hasFruits ex:apple1, ex:apple2.
```

## Stories evaluations
The story evaluation can be ignored since this just allows you to find a resource.
We describe it for completeness. Shape trees do not specify where to write data, only where to find it.
It is still interesting to consider, because we could get ideas from this spec on where to write data.

## Conclusion
We now evaluate what functional requirements are met using:
* :white_check_mark: when the requirement is met
* :x: when the requirement is not met
* :black_square_button: when the requirement is not in the scope of this spec

1. Data should remain consistent with the requirements posed by the **technology** (e.g., solid):
   :white_check_mark: if the server enforces the shape trees.
   :x: if clients still do what they desire.
2. The data should have **easy access control**: :black_square_button:
3. References should remain **consistent/cool**: :black_square_button:
4. The **owner is in control** of the data: :black_square_button:
5. Data in a data storage should be **discoverable**: :white_check_mark:
6. Allow **profiles or strategies**: :black_square_button:
7. Storage ACL should consider **privacy**: :white_check_mark:
   Shape trees can still be static as long as the identifiers are non-meaningful,
   and containing resources correctly use access control to not reveal their content.
8. Good old **ACID**: :x:
9. Storage should avoid **data dependence**: :x:
