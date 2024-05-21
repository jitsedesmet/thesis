#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Conclusion

// Small resume
In this work we precented a vocabulary that allows smart clients to autonimusly discover the location a created or updated resource should be stored.
The vocabulary also introduces checks on whether or not a resource can be created or removed.
Additionally we proved that our vocabulary is indead expressive by implementing a smart client that consumes it.

We hypothezized that such a smart client would be a maximum of four times slower and would ruire a maximum of double the amount of @http requists.
Through theoretical evaluation, we discover that the amound of @http requests is within those bound.
Unfortunatly, the executon time of a single query was slower than four times the execution time of the same query when not consuming the proposed vocabulary.
We concluded that the execution time is less then four times slower in the case that the behaviour of our solution could be moddeled using a @sparql query.

// Questions to myself
In essence, @sgv tries to provide structure to a widly unstructured document store that is @sgv.
It does this by defining a server side description of the structure that should be enforced by clients.
In reality, clients can still interact with the Solid pod however they want since the server is not aware that a structure should be followed.
This lack of server-side verification is perhabs the biggest shortcomming of this work.
That being said, it is entirely possible to extend an existing Solid server with a @sgv varification system.
The downside at that being that both the client and server need to calculate the proposed location of a resource.
Unfortunatly, this is a shortcomming of the @ldp interface itself as it chooses for an easy server.
This choice often comes at the cost of a complex client side.
What's more, since one server interface is used by many clients, it becomes almost impossible to guarantee a system that respects the structure of a permissive interface.

// The definition of a resource.
Throughout this work we often talk about "the @rdf resource", defining it as the @cbd of some named node.
This definition is actualy rather arbitrary.
Another way of defining a resource is by using the shape descriptions.
Though the use of shape descriptions, create an @rdf resource containing multiple named nodes as subjectes. @fig:resouce-with-two-named-nodes.
@sgv will then try to define a base for this query and place the resource there.
When editing the resource, we need to e aware that both named nodes are referencable by others. 
Thus, when we conclude a move is required, we should decide on what named nodes should be moved.

#figure(
text-example[
```turtle
@prefix ex: <http://example.org/> .
<> a ex:Person ;
  ex:address <#myAddress> .

<#myAdress> a ex:Address ;
  ex:street "SesamStreet"@en .
```
], caption: [A resource consisting of two named nodes as subjects.]
) <fig:resouce-with-two-named-nodes>