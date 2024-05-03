#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Semantic Web

The Semantic Web is a @w3c initiative that aims to extend the human-readable web to a machine-readable web.
The initiative started in 2001 by the maker of the web and has grown to be a mature technology.
Even though the technology is mature, it is not outdated, with new specifications still being created.
This chapter aims to give a high-level overview that is limited to the technologies used in this work.

== RDF
// Triples
@rdf is a @w3c specification that models graph data using triples.
A triple `<s, p, o>` contains a subject, predicate and object.
Each element of the triple can be a @uri and can thus be dereferenced using an @http GET request.
A dereferenced @uri should contain additional info.
A triple can thus be modelled as an arrow labelled with a predicate from subject to predicate, and each of these is a node that describes itself.
Objects can also be literal values like strings, integers, etc.

// Blank node
Subjects and objects can be blank nodes, these nodes are only addressable in the context of the same file.
This means that a triple can contain a blank node, which is not dereference using @http, and the info related to that blank node is contained within the same document the triple resides in.

// Graph
A triple exists in the context of a graph, and when no graph is provided, the triple exists in the `defaultgraph`.
When adding a graph to each triple, we define an @rdf entry as a quad: `<s, p, o, g>`.
In this work, we will always work in the default graph as a simplification.
We make this simplification because Solid does not rely on graphs, and adding them would be a nuance.

=== Serializations

@rdf can be serialized using different formats.
The formats used in this work are the machine format n-triples and the human format turtle.

==== N-Triples

The N-Triples format is an unordered serialization, serializing each triple separated by a dot.
The symbols `<>` are used to denote a @uri.
Values not contained within `<>` are considered either blank nodes or literal values.
Blank nodes are represented by a "`_:`" prefix followed by an identifier.
The format of a literal is first the value of the literal between double quotation marks (`""`), followed by "`^^`" and then the data type.
When no data type is given, the string data type (`<http://www.w3.org/2001/XMLSchema#string>`) is used.
@fig:example-n-triples shows an example N-Triples serialization.
#figure(
text-example[
```
<http://base.example.com/me> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://xmlns.com/foaf/0.1/Person> .
<http://base.example.com/me> <http://xmlns.com/foaf/0.1/givenName> "Alice" .
<http://base.example.com/me> <http://xmlns.com/foaf/0.1/familyName> "Rabit"^^<http://www.w3.org/2001/XMLSchema#string> .
<http://base.example.com/me> <http://xmlns.com/foaf/0.1/knows> <http://example.org/Bob> .
<http://base.example.com/me> <http://xmlns.com/foaf/0.1/knows> <http://example.org/Carol> .
<http://base.example.com/me> <http://xmlns.com/foaf/0.1/knows> _:ub2bL9C5 .
_:ub2bL9C5 <http://xmlns.com/foaf/0.1/givenName> "Dave" .

<http://example.org/Bob> <http://xmlns.com/foaf/0.1/givenName> "Bob" .
<http://example.org/Bob> <http://xmlns.com/foaf/0.1/familyName> "Builder" .
```
],
  caption: [An example N-Triples document]
) <fig:example-n-triples>

==== Turtle

The turtle file format is an extension to N-triples, specifically designed to be easier to read for humans.
It introduces prefixes to reduce the size of each triple, increasing readability.
Each turtle triple is ended using either "`;`", "`,`" or "`.`",
depending on the chosen character, your triple shares respectively, the object, the object and predicate, or nothing with the previous triple.
Blank nodes have some additional syntactic sugar and can be created using brackets ("`[]`") in which the predicate and object belonging to the blank node are contained.
An additional feature is the use of a "base".
Turtle allows you to specify named nodes (@uri[s]) in relation to a base by using the `<>` containing a path instead of a whole @uri.
The base @uri should be provided when parsing the turtle file. 
@fig:example-turtle is a turtle serialization of @fig:example-n-triples when using the base @uri "http:\//base.example.com/".

#figure(
text-example[
```turtle
@prefix ex: <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
<me> a foaf:Person ;
  foaf:givenName "Alice" ;
  foaf:familyName "Rabit" ;
# Two triples sharing the same subject and predicate
  foaf:knows ex:Bob, ex:Carol ;
# A blank node
  foaf:knows
    [
      foaf:givenName "Dave"
    ] .

ex:Bob
  foaf:givenName "Bob" ;
  foaf:familyName "Builder" .
```
],
  caption: [An example Turtle document]
) <fig:example-turtle>


== SPARQL

== Shape Descriptions
// talk about ShEx and more extensively about SHACL. Mention history shortly


== Interfaces


== Endpoints

== Query Engines