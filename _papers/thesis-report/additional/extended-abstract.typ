#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "../raw/consts.typ": *

// multiple bibliography issues: https://github.com/typst/typst/issues/1097
// And title scope undesired... would scope titles
// -> We will use a pdf concat :/
// https://github.com/typst/templates/blob/main/charged-ieee/lib.typ

#set document(title: title, author: "Jitse De Smet")
#set text(font: "Times New Roman", size: 10pt)
#set page(paper: "a4", margin: (bottom: 1.78cm, top: 1.78cm, left: 1.3cm, right: 1.3cm))
#set raw(syntaxes: ("../utils/turtle.sublime-syntax", "../utils/sparql.sublime-syntax"))

#show heading: set text(size: 10pt)
#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): set text(features: ("smcp", "c2sc"))
#set heading(numbering: (..numbers) => {
  let level = numbers.pos().len()
  if (level == 1) {
    return numbering("I.", numbers.pos().at(level - 1))
  } else if (level == 2) {
    return numbering("A.", numbers.pos().at(level - 1))
  } else {
    return numbering("1.", numbers.pos().at(level - 1))
  }
})
#show heading.where(level: 1): it => {
  if it.level == 1 {
    if it.body in ([Acknowledgements], [References]) and it.numbering != none {
      heading(numbering: none, it.body)
    } else {
      it
    }
  } else {
    it
  }
}

#show figure.where(kind: "table"): set figure.caption(position: top)
#show figure.caption: set align(left)
#show figure.where(kind: raw): set figure(kind: image)

#import "../glossary.typ": glossary
#import "@preview/glossarium:0.2.6": make-glossary, print-glossary, gls, glspl
#show: make-glossary

// Title
#[
  #set text(size: 24pt)
  #set align(center)
  #title
]

// Authors
#[
  #set align(center)
  Jitse De Smet#footnote(numbering: it => [])[
    #show: columns.with(2, gutter: 12pt)
  J. De Smet is a master student with the KNowledge On Web Scale team within IDLab, Ghent University (UGent), Gent, Belgium.
  Email: #link("mailto:jitse.desmet@ugent.be")[jitse.desmet\@ugent.be]
  ]
  #counter(footnote).update(0)

  Supervisors: #supervisors.join(", ")
]


#show: columns.with(2, gutter: 12pt)
#set par(justify: true, first-line-indent: 1em)
#show par: set block(spacing: 0.65em)

// Abstract

#[
#set text(size: 9pt)
  _Abstract_ - *#abstract-text*

  _Keywords_ - #keywords.join(", ")
]

// The extended abstract has a standard length of minimum 2 and maximum 6 pages.

= Introdution

Data in todays web is increalingy captured in huge data silos.
The extend of these silos is enormous, reaching the limits of what is sociatal and legislative permitted. 
From a socialtal point of view, these silos are a huge tread on the privacy of users.
Beyond the scope of privacy this centralization causes social turbalance since it sentralizes the attention of the masses and thus the media control into a select few.
Luckily, legislative measures have been taken to protect sociaty from this centralization~@bib:gdpr @bib:ccpa.
As a response centralization technologies are being developed, such as Solid~@bib:solid, Bluesky~@bib:bluesky, Mastodon~@bib:mastodon and various blockchain based initiatives~@bib:nakamoto2008bitcoin.

The Solid initiative achieves centralization by creating a standard building on top of existing Web standards.
Achieving decentralization this way allows for interoperability and easier workflow adaptation by utilizing existing expertize.
Nevertheless, the re-decentralization of the Web comes with various challenges ranging from efficient and effective read and write operations, to expressing and enforcing access and usage control policies.
Reading data in this context has already gained some research attention @bib:hartig2016walking @bib:taelman-structure-assumptions, but effectivelly writinging data remains rather unexplored.

Data decentralization initiatives such as Solid and Bluesky dcentralize data by providing each user with a data store governed by the user.
Users are in control of their data store how they interact with the datastore and who they share their data with.  
The effectiveness of reading data in a decentraliced environment has been increased by abstarcting data reads through a query abstraction layer, called the query engine, by using query languages like GraphQL~@bib:graphql and SPARQL~@bib:sparql.
In this work, we will similary resreach how we can abstarct data updates by using a query abstraction layer.
The current (draft) Solid specification~@bib:solid-spec describes each data store, or pod, as a document oriented interface where a user decides, for each document who can access that document.
Our goal is thus to create a query engine that effectivelly desides what document a resource should be stored in, effectivelly eliminating the access-path data dependency.
We hypothesize that such query engine has a 2x overhead in the number of HTTP requests and a 4x overhead in the execution time compared to a query engine that requires the user to configure the document explicitly. Such an overhead is acceptable since write speeds, are in contrast to read speeds, often not critical.  


= Related Work

// Solid uses RDF & LDP 
The Solid specification~@bib:solid-spec builds ontop of existing Semantic Web technologies sush as RDF (Resource Description Framework)~@bib:rdf and LDP (Linked Data Platform)~@bib:ldp.
LDP is a set of rules that is used to create a document oriented interface accecable through HTTP.
Such an interface is essentially exposes a file sytsem over HTTP, it creates directries, called Containers,
that group together data documents and directories.
Each of the exposed HTTP resources has their own access control policy declared through either WAC~@bib:wac or ACP~@bib:acp.

// CBD
In this work, we will try to store RDF resources, defined as the CBD (Consice Bounded Description)~@bib:concise-bounded-description of a Named Node.
The CBD of a resources is defined as the collection of triples that can be accessed by recursivelly following objects, without following named nodes.
As an example, @fig:rdf-example contains some RDF data in turtle~@bib:turtle format, taking the CBD of named node `<me>` resultes in @fig:cbd-example. 

#figure(
text-example(
```turtle
@prefix ex: <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
<me> a foaf:Person ;
  foaf:givenName "Alice" ;
  foaf:knows ex:Bob, ex:Carol ;
  foaf:knows [
      foaf:givenName "Dave"
    ] .
ex:Bob
  foaf:givenName "Bob" ;
  foaf:familyName "Builder" .
```
), caption: [An example RDF file.]
) <fig:rdf-example>
#figure(
text-example(
```turtle
@prefix ex: <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .
<me> a foaf:Person ;
  foaf:givenName "Alice" ;
  foaf:knows ex:Bob, ex:Carol ;
  foaf:knows [
      foaf:givenName "Dave"
    ] .
```
), caption: [The CBD of named node \<me> in @fig:rdf-example.]
) <fig:cbd-example>

// Resource descriptions
RDF datastores, and by extention, Solid pods, are schemaless, meaning data contained does not follow a specific a rigid format like for example a relational database.
In the context of Big Data, this is beneficial because defining a schema that should be followed by all actors that write data, is imposible since both the actors, and their way of working constantly changes.
Data consumers on might expect data they consume to follow a certain format.
Shape descriptions describe the format of data and can be used to validate that data indeed follows the expected format.
Two RDF shape description languages are important, ShEx~@bib:shex and SHACL~@bib:shacl.
A self descriptive decrlaration of ShEX can be found in @fig:shex-example.
We do not prove a similar example for SHACL since it's syntax uses turtle, this is more verbose but the predicate names are self-describing. 

#figure(
  text-example[
```
# our EmployeeShape reuses the FOAF ontology
# An <EmployeeShape> has:
<EmployeeShape> {
# at least one givenName.
  foaf:givenName xsd:string+,
  foaf:familyName xsd:string, # one familyName.
  foaf:phone IRI*, # any number of phone numbers.
  foaf:mbox IRI # one FOAF mbox.
}
```
  ],
  caption: [Self-explanetory example ShEx shape]
) <fig:shex-example>

// Pod descriptions (Type Index & Shape trees) -> Why do we need SGV?
Just like RDF does not define it's data schema, so does LDP not define it's data organization.
As a result, someone reading a pod does not know where it can find the data relevant to them.
However, just like RDF data can be described using a resource description, so can an LDP interface organization be described.
Solid proposes two ways of describing a pod, Type Indexes~@bib:type-index and Shape Trees~@bib:shape-tree.
The Type Indexes specification was a first attempt at describing the resources of a Pod, it describes the use of a public and private index over the `rdf:type` predicate.
The construction of a public and private index is however fundamentally flawed since resources cannot be grouped into either public or private because more complex access control is te norm.

Shape Trees are the proposed replacement of Type Indexes.
Type indexes was limited to creating a indexes based on the type predicate, as an improvement, Shape Trees index based on some Resource Description.
Moreover, Shape Trees are the natural extension of these resource descriptions to resource hyrarchies.

In the context of read queries, it has been proven that using the structure of a pod,
by for example consulting the type indexes can be beneficial~@bib:taelman-structure-assumptions.
It thus makes sense to speculate that a similar structural description can help write queries.

= Storage Guidance Vocabulary


= Evaluation


= Future Work


= Conclusion


= Acknowledgements

#acknowledgements


= References
#bibliography(title: none, "../items.bib")
