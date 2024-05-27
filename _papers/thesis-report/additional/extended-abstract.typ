#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "../raw/abstract.typ": *

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

#show figure: set figure.caption(position: top)
#show figure.caption: set align(left)
#show figure.where(kind: raw): set figure(kind: image)

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
  Email #link("mailto:jitse.desmet@ugent.be")[jitse.desmet\@ugent.be]
  ]
  #counter(footnote).update(0)

  Supervisors: Dr. ir. Ruben Taelman, Prof. dr. ir. Ruben Verborgh
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


= Storage Guidance Vocabulary


= Evaluation


= Future Work


= Conclusion


= Acknowledgements


= References


#bibliography("../items.bib")

