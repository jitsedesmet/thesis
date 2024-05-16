#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Semantic Web

The Semantic Web is a @w3c initiative that aims to extend the human-readable web to a machine-readable web.
The initiative started in 2001 by the maker of the web, Sir Tim Berners-Lee, and has grown to be a mature technology.
Even though the technology is mature, it is not outdated, with new specifications still being created to keep the syste up to date with todays requirements.
This chapter aims to give a high-level overview that is limited to the technologies used in this work.

== RDF
// Triples
@rdf~@bib:rdf is a @w3c specification that models graph data using triples.
A triple `<s, p, o>` contains a subject, predicate, and object.
Each element of the triple can be a @uri and can thus be dereferenced using an @http GET request.
A dereferenced @uri should contain additional info about that subject.
A triple can thus be modelled as an arrow labelled with a predicate from subject to predicate, and each of these is a node that describes itself.
Objects can also be literal values like strings, integers, etc.

// Blank node
Subjects and objects can be blank nodes, these nodes are only addressable in the context of the same file.
This means that a triple can contain a blank node, which cannot be dereferenced using @http.
The info related to that blank node is contained within the same document the triple resides in.

// Graph
A triple exists in the context of a named graph, and when no graph is provided, the triple exists in the `defaultgraph`.
When adding a graph to each triple, we define an @rdf entry as a quad: `<s, p, o, g>`.
In this work, we will always work in the default graph as a simplification.
We can make this simplification because Solid does not rely on graphs, and adding them would be a nuance.

=== Consise Bouneded Description

The @cbd~@bib:concise-bounded-description of an @rdf resource is the set of tuples that can be created as follows:
+ Create a `to-visit` set equal to the set of triples that has the focussed resource as a subject
+ Iterate over the triples in the `to-visit` set and:
  + Add the curent triple to the result set.
  + In case the object of the current triple is not a named node: add all triples with that object as a subject to the `to-visit` set.
  + Remove the current triple from the `to-vist` set.

In this work we often use "the @rdf resource" to refer to the @cbd.

=== Serializations

@rdf can be serialized using different formats.
The formats used in this work are the machine format n-triples and the human format turtle, but many more exist.

==== N-Triples

The N-Triples format is an unordered serialization, serializing each triple separated by a dot~@bib:n-triples.
The symbols `<>` are used to denote a @uri.
Values not contained within `<>` are considered either blank nodes or literal values.
Blank nodes are represented by a "`_:`" prefix followed by an identifier.
The format of a literal is first the value of the literal between double quotation marks (`""`), followed by "`^^`" and then the data type.
When no data type is given, the string data type (`<http://www.w3.org/2001/XMLSchema#string>`) is assumed.
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

The turtle file format is an extension to N-triples, specifically designed to be easier to read for humans~@bib:turtle.
It introduces prefixes to reduce the size of each triple, increasing readability.
Each turtle triple is ended using either "`;`", "`,`" or "`.`",
depending on the chosen character, your triple shares, respectively, the object, the object and predicate, or nothing with the previous triple.
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


== SPARQL <sec:sparql>

The @sparql query language is a declarative query language like, for example, SQL, but specifically designed for RDF~@bib:sparql.
The query language is very extensive, in this section we explain what is needed to understand this work.

@sparql and turtle share a lot of syntax, with a minor nuance in prefix declaration. Turtle uses `@PREFIX` to define a prefix, while @sparql just uses `PREFIX`. Turtle also expects a dot at the end of a prefix declaration, while @sparql does not.

=== Variable

To select a part of a triple, you use a new variable, denoted by a `?` or `$` prefix. The variable "id" would be referenced using `?id`. The variable can then be used in a where clause. The result of a @sparql select query is a list of bindings that satisfy the projection of the data through the query.

=== Functions

Within a query, functions can be used to transform data. We mention the functions used in this work.

==== Bind

Binds a certain value, or variable, to a variable. To bind the value "apple" to the variable "pear", you would use: `BIND ("apple" as ?pear)`.

==== STR

The STR function gets the raw string representation of a value, for example when we have a date: `"2024-05-08T23:23:56.83Z"^^xsd:dateTime` we can get the value between double quotation marks by using the STR function. `STR("2024-05-08T23:23:56.83Z"^^xsd:dateTime)` would evaluate to `"2024-05-08T23:23:56.83Z"`.

=== Property Paths

Property paths allow you to describe a route between two nodes.
In this work, we use the `*` property path, which means, following a property zero or more times.
To express that we want to bind the variable "location" to each geographic location in which our variable "city" is located, we could use: `?city ex:locatedIn* ?location`.

=== Different kind of queries <sec:sparql-query-types>

Until now, we kept it easy by focussing on read queries. Since this work focuses on write queries, we quickly go over all the different syntaxes @sparql provides to update a resource.

==== Insert Data

An insert data query adds some triples listed to a data source.

==== Delete Data

A delete data query simply removes the triples listed from a data source.
If a triple that should be deleted is not present, it is ignored.

==== Delete / Insert Where

A delete insert query consists of an optional delete clause followed by an optional insert clause, followed by a where clause.
Either the delete or insert clause, or both, need to be present.
Unlike the "insert data" and "delete data" queries, these queries can contain variables.
Important to note is that the where clause is evaluated only once.
The resulting binding are then substituted in both delete and insert clauses, and afterwards the delete clause is executed followed by the insert clause.

==== Delete Where

A "delete where" query is an abbreviated form of the above query.
The query `DELETE WHERE { content }` is equivalent to `DELETE { content } where { content }`.


== Shape Descriptions
// talk about ShEx and more extensively about SHACL. Mention history shortly.

@rdf is what they call a schemaless data format, meaning it does not a priori require a format in which the data will be stored.
Other examples of schemaless data are a #link("https://www.mongodb.com/")[MongoDB] and #link("https://redis.io/")[Redis].
Data with a schema are, for example, your traditional relational databases.
An in-depth comparison between schema and schemaless data storage is beyond the scope of this work.

Schemaless data can after the creation still be validated against some *schema*, this is useful for application developers that expect the data they consume to be in a specific format.
In this work, we will use schemas to group similar data together.
Within the @rdf ecosystem, two schema descriptions are important, @shex and @shacl.
@shex was created out of a community need to describe shapes and has a compact syntax. @shacl was created later as a @w3c recommendation. This work primarily uses @shacl because it is a @w3c recommendation, we assume it will be more future-proof. We will sporadically use @shex in this text for its compressed format.

=== ShEx

A @shex~@bib:shex shape essentially lists properties and their accompanying object type, as well as the cardinality of that property in relation to the focussed subject.
@fig:shex-example shows a self-explanatory shape example taken from the @shex website.

#figure(
  text-example[
```
# our EmployeeShape reuses the FOAF ontology
<EmployeeShape> {                # An <EmployeeShape> has:
    foaf:givenName  xsd:string+,   # at least one givenName.
    foaf:familyName xsd:string,    # one familyName.
    foaf:phone      IRI*,          # any number of phone numbers.
    foaf:mbox       IRI            # one FOAF mbox.
}
```
  ],
  caption: [Example ShEx shape taken from their website]
) <fig:shex-example>


=== SHACL

@shacl~@bib:shacl is extensively used in this work, yet because the different @shacl properties are rater self-explanatory, we do not give an in-depth explanation on @shacl.

== Interfaces

An interface is the shared boundary between two systems.
We are interested in the boundary between a data owner and a data consumer.
In other words, say a data owner has some @rdf data, how does a data consumer gain access to that data.
In this work, we will focus on web interfaces.
Numerous @rdf interfaces exist, a data owner could choose to expose all data in a compressed format, use a @sparql endpoint, use @tpf~@bib:tpf, etc.
Another possibility, is to group @rdf triples together in different @http documents and provide an interface that links those documents together accordingly.
This essentially created an endpoint following the REST architecture. //cite REST

// Interfaces differentiate in more areas than just client/ server load.
// Each interface can be classified as either a domain-specific interface or a domain-agnostic interface.

=== SPARQL endpoint

A @sparql endpoint is a conceptually simple interface.
You ask a @sparql query to the interface and you get the result.
As an example, @fig:sparql-all-triples shows how to get all data behind a @sparql endpoint.

#figure(
text-example[
```sparql
SELECT ?s ?p ?o WHERE {
  ?s ?p ?o
}
```
],
caption: [SPARQL query to select all triples]
) <fig:sparql-all-triples>

Behind the conceptually simple interface is a huge amount of technical complexity.
This technical complexity together with potential computational cost of a @sparql endpoint makes it unfit for some use cases.

=== LDP

#MJDS[I don't think LDP under interfaces makes sence, because it is not an interface. better header?]
@ldp isn't an interface itself /* It's domain agnostic - so each domain has own interface */, but rather a set of rules that allow you to create a simple RESTful interface mimicing an operating systems file structure.
Within an @ldp interface, each @http resource returns @rdf triples that either describe some resource, or describe some collection that contains other @rdf resources.
@fig:ldp-container-example shows an example @ldp container.
An @ldp interface allows CRUD operations through the @http methods.

#figure(
  text-example[
```turtle
@prefix dcterms: <http://purl.org/dc/terms/>.
@prefix ldp: <http://www.w3.org/ns/ldp#>.
<http://example.org/c1/>
   a ldp:BasicContainer;
   dcterms:title "A very simple container";
   ldp:contains <r1>, <r2>, <r3>.
```
  ],
  caption: [LDP container example]
) <fig:ldp-container-example>


== Query Engines

Query engines are complex pieces of software that answer queries, like for example the @sparql queries seen in @sec:sparql.
The features supported by the engine are engine-dependent, but they can be extensive.
Besides feature support, they can also perform query optimizations based on things like cardinalities that are either known from the start, or are discovered during the query process /* CITE: adaptive query processing? (relevant?) */.
A query engine aims to shield the developers from the complexities that are omnipresent when querying data.
// Homogeneous APIs
These complexities range from different data formats, to different interfaces, to possible optimizations.

The Comunica query engine~@bib:comunica has been especially designed to be modular, allowing easy extensibility in the different areas mentioned above. This work will use that engine because of its modular design, existing feature richness and free software nature.
