# Ideas

This directory contains ideas that would pop up in my head.

* Can document size + shape description give you an indication of how many (relevant) triples are contained within a file?
* It is possible to do static optimizations like dropping a type assertion when you would inference
  that type because your query looks for a certain predicate on a subject.\
  A heuristic could be to try and get as much information possible on the subject by de-referencing the predicates
  before query execution. (You assume users don't query predicates a lot). Example:
   ```
   ?o type apple
   ?o someProperty pear
   someProperty : object is of type apple
   ```
* When inserting data in a pod you can not update in, 
  you can also insert it in your own pod and exclude the original using the [subweb-specification](https://imec-publications.be/bitstream/handle/20.500.12860/38428/DS470_acc.pdf?sequence=1).
* LDP allows you to post on a container to perform an insert.
  maybe you want to be able to call `setContext` = `setThis` = `setSubject` = `setContainer` on a query engine,
  so you need not specify a where.
* Use something like `splitOnPredicate` to create some kind of index. (use virtual containers)\
  Maybe we can determine when to create an index like this based on the #read/#writes on a resource (But what predicate to split on?)
* Define a distance metric between two shapes.
* LDP does not say anything about physical containing. This means we have soft links? Containing is not exclusive, 
  It also allows pagination. We should still be careful!
  If we use this: how do we clarify to views/ indexes will give you the same resources at the bottom?
* If you make your first indexing layer the auth types, you can easily give an accessible view over the pod.
* Wikipedia states: maybe we can look at that to get ACID working?
   > In the 2010s, commercial ACID graph databases that could be scaled horizontally became available.
