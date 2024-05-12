#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Solid
// Introduce
The Solid project develops a specification that lets individuals and groups store their data securely in decentralized data stores called Pods.
Pods are like secure web servers for data.
When data is stored in a Pod, its owners control which people and applications can access it.
#todo[cite: https:\//solidproject.org/]
Solid is a specification that builds on top of exist specification.
The data is stored in @rdf format and the interface is constructed through @ldp.
However, the existing specifications are not enough as solid faces numerous challenges because of its innovative decentralized nature.
These challenges span over multiple domains like interface design, query engine design, access control, usage control, etc.


== Access Control

For each resource, the Access Control describes what actors have access to the resource.
The resource access is often aligned with the CRUD operations, so each operation has their set of actors that can perform the action.

=== WAC

@wac is a decentralized cross-domain access control system, providing a way for Linked Data systems to set authorization conditions on HTTP resources using the @acl model
#todo[cite spec], using the #link("http://www.w3.org/ns/auth/acl#")[@acl ontology].
@wac differentiates four #link("https://solidproject.org/TR/wac##access-modes")[access modes]:
+ `acl:Read`: Allows access to a class of read operations on a resource, e.g.,
  to view the contents of a resource on HTTP GET requests.
+ `acl:Write`: Allows access to a class of write operations on a resource, e.g.,
  to create, delete or modify resources on HTTP PUT, POST, PATCH, DELETE requests.
+ `acl:Append`: Allows access to a class of append operations on a resource, e.g.,
  to add information, but not remove, information on HTTP POST, PATCH requests.
+ `acl:Control`: Allows access to a class of read and write operations on an ACL resource associated with a resource.

@wac was created with some extensibility in mind.
One could use the #link("https://solidproject.org/TR/wac#extension-acl-mode")[Access Mode Extensions] to define a subclass of a default access mode, like for example `acl:read`.

The specification contains an interestingly consideration:
#quote(block: true, quotes: true)[
  Servers are strongly discouraged from trusting the information returned by looking up an agent’s WebID for access control purposes. The server operator can also provide the server with other trusted information to include in the search for a reason to give the requester the access.
]

This is interesting in the context of solid because it means we are discouraged from making access rules like:
"Access is granted when the requestor is older than 21."
This consideration was possibly written down to warn readers that servers cannot validate the data. 
However, verifiable credentials might be able to change this view.
Unfortunately, a @wac GitHub issue about this is open and inactive#footnote[https:\//github.com/solid/authorization-panel/issues/79].

An example @wac description is given below:
#text-example[
```turtle
@prefix acl: <http://www.w3.org/ns/auth/acl#> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
@prefix alice: <https://example.com/Alice#> .
@prefix bob: <https://example.com/Alice#> .

[
  acl:accessTo alice:card ;
  acl:mode acl:Read ;
  acl:agentClass foaf:Agent
] .
[
  acl:accessTo alice:card ;
  acl:mode acl:Read, acl:Write ; 
  acl:agent bob:card
] .
```
]

=== ACP

@acp is an alternative to @wac and serves as the older sibling.
@acp allows you to create matchers over users.
These matchers can return a value true or false based on the agent that requests the resource.
Policies are used to connect matchers to resources.

In our opinion @acp is not powerful enough yet as it lacks the true meaning behind a policy.
@acp requires you to provide a rule for each resource, but has no way to generalize resources.
I might, for example, want to create an access control resource that grands Alice access to the subset of my pictures that they are contained in.
Since rules relate to a specific resource, @acp lacks the ability to express this.

We also provide an @acp example:
#text-example[
```turtle
ex:accessControlResourceA
  acp:resource ex:resourceX ;  
  acp:accessControl [
    acp:deny acl:Read, acl:Write ;  
      acp:anyOf [
        acp:client acp:PublicClient ;    
      ] ;
      acp:noneOf [
        acp:client ex:clientC
      ] ;
  ] .
```
]


=== Conclusion 

We can conclude that both solutions are not perfect and that @acp is the more expressive specification.
Beyond access control, the Solid Community is increasingly investigating usage control solutions.
Usage Control takes access control that decides whether you have access to a resource, and expands on it by describing how you can get access and what that access entails in relation to the deontic concepts: Permission, Prohibition, Obligation and Dispensation.

== Pod Descriptions

A Solid pod following the current specification has an @ldp interface.
Such an interface is unstructured by design, forcing a data consumer to traverse all links in the same pod to get a complete pod overview.
If completeness is of importance, this makes an @ldp interface almost worse than a bulk download.
To avoid this, a pod can have an index that can be used to speed up query execution.

=== Type Index

The first index proposed for Solid was the Type Indexes specification. //https://solid.github.io/type-indexes/
It proposes two indexes, a private and a public index.
Each index contains entries that map a certain @rdf type to a set of @http resources.
The example below shows a type index that states that @rdf resources that have a tupe like `<s rdf:type vcard:AddressBook>` can be found at path `/public/contacts/myPublicAddressBook.ttl`.
#text-example[
```turtle
@prefix solid: <http://www.w3.org/ns/solid/terms#>.
@prefix vcard: <http://www.w3.org/2006/vcard/ns#>.
@prefix bk: <http://www.w3.org/2002/01/bookmark#>.

<>
  a solid:TypeIndex ;
  a solid:ListedDocument.

<#ab09fd> a solid:TypeRegistration;
  solid:forClass vcard:AddressBook;
  solid:instance </public/contacts/myPublicAddressBook.ttl>.
```
]

Besides the low granularity type indexes allow, they are inherently flawed because the access of resources cannot be grouped into "public" and "private" since more complex access control policies are the norm. 

=== Shape Tree

Shape Trees are the proposed replacement to the Type Indexes.
The specification uses shape descriptions like @shex and @shacl to validate @rdf graphs against a set of conditions.
Shape trees can be used in combination with protocols that organize linked data graphs into resource hierarchies, expressing the layout of the resources and associating those resources with their respective shapes.
It is the natural extension of shape descriptions to those resource hierarchies.

The shape tree specification can be used on top of any technology platform that supports the notion of containers and resources, but it is mostly used on top of @ldp.
The shape tree specification defines a predicate `st:contains` that asserts a "physical" hierarchy.
The "physical" containment is defined as @ldp containments.
The shape tree spec also defines virtual containment, this is just another way of realizing directories above the underlying @ldp specification.
It means you don’t need `ldp:contains` for defining containers, but can define another predicate, and use that predicate to create directories.
Essentially it makes you able to view `ex:apple1` and `ex:apple2` as containing resources of `ex:appleTree`:

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  text-example[
```turtle
@prefix ex: <http://example.org/> .
ex:appleTree
  ex:hasFruits ex:apple1, ex:apple2.
```
],
text-example[
```turtle
<#VirtualAppleTree>
  a st:ShapeTree ;
  st:expectsType st:Resource ;
  st:shape ex:AppleTreeShape ;
  st:references [
    st:referencesShapeTree <#VirtualAppel> ;
    st:viaPredicate ex:hasFruits
  ] .

<#VirtualAppel>
  a st:ShapeTree ;
  st:expectsType st:Resource ;
  st:shape ex:AppleShape ;
```
]
)

By creating a graph of shape descriptions, access control becomes finer than the case of the Type Indexes.
Each Subtree can be exposed through its own @http resource and can therefore have its own access control policies.
The privacy of a user can thus be protected by exposing a shape tree in a fine granularity.


== Solid Interoperability

The Solid Interoperability specification is a big specification that essentially ties together the smaller specifications and offers some usage suggestions.
It essentially describes how applications should work together to ensure a coherent data ecosystem.

The specification differentiates social agents (individual, group, or organization) and applications, but considers both to be _agents_.
Social agents choose to use certain applications and register/ manage them and their access rights in a private document.
In considers data to be stored in data registries, each indexed using a shape tree, and describes that resource names should be unpredictable. The unpredictability is important for the privacy of data owners.

The specification also describes how one can request access to a resource and a way of storing what access rights have been granted.


// Do I mention Solid Application Interoperability? It describes things like: Don't go to deep into your container structure. That's a peculiar claim, since SGV does encourage nesting. -> SGV could be used to generate multiple views though (requires top-level SGV) -> That would result in a view a user sees vs a interop compatible view.



// == LDP // (Do I mention Tree/ LDES/ SPARQL endpoint as alternatives?)


// === Restrictions
// What's in a pod? And more
