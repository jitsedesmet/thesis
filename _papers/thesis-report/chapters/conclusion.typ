#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Conclusion

// Small resume
In this work, we presented a vocabulary that allows smart clients to autonomously discover the location a created or updated resource should be stored.
The vocabulary also introduces checks on whether a resource can be created or removed.
Additionally, we proved that our vocabulary is indeed expressive by implementing a smart client that consumes it.

We hypothesized that such a smart client would be a maximum of four times slower and would require a maximum of double the amount of @http requests.
Through theoretical evaluation, we discover that the amount of @http requests is within those bound.
Unfortunately, the execution time of a single query was slower than four times the execution time of the same query when not consuming the proposed vocabulary.
We concluded that the execution time is less than four times slower in the case that the behavior of our solution could be modeled using a @sparql query.

// Questions to myself
In essence, @sgv tries to provide structure to a widely unstructured document store that is @ldp.
It does this by defining a server-side description of the structure that should be enforced by clients.
In reality, clients can still interact with the Solid pod however they want since the server is not aware that a structure should be followed.
This lack of server-side verification is perhaps the biggest shortcoming of this work.
That being said, it is entirely possible to extend an existing Solid server with a @sgv verification system.
The downside at that being that both the client and server need to calculate the proposed location of a resource.
Unfortunately, this is a shortcoming of the @ldp interface itself, as it chooses for an low-complexity server.
This choice often comes at the cost of a complex client side.
What's more, since one server interface is used by many clients, it becomes almost impossible to guarantee a system that respects the structure of a permissive interface.

// The definition of a resource.
Throughout this work, we frequently talk about "the @rdf resource", defining it as the @cbd of some named node.
This definition is actually rather arbitrary.
Another way of defining a resource is by using the shape descriptions.
Though the use of shape descriptions, create an @rdf resource containing multiple named nodes as subjects.
@fig:resouce-with-two-named-nodes shows a description with multiple named nodes.
@sgv will then try to define a base for this query and place the resource there.
When editing the resource, we need to be aware that both named nodes are referable by others. 
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

