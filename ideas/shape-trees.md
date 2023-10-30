# Shape trees

My ideas surrounding shape trees

* Shape trees require you to map out the tree of shapes from the entire solid pod, in this case, 
  multiple leaves can have the same shapes.
* You can use LDP containers + shape trees to have authentication rules.
  (But maybe you just want to have an adaptive resource that is one file? (or find a balance between a big file and potential multiple request))


Interesting predicates:
* st:Resource
* st:Container
* st:NonRDFResource
* st:ShapeTree
* st:expectsType
* st:shape
* st:contains (for physical containment)
* st:references (for virtual hierarchy)\
  you can then use st:viaShapePath or st:viaPredicate to identify with what predicate (done in a st:referencesShapeTree)
  
