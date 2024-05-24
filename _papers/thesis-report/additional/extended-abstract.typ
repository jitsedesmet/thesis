#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "../raw/abstract.typ": *

// multiple bibliography issues: https://github.com/typst/typst/issues/1097
// And title scope undesired... would scope titles
// -> We will use a pdf concat :/
// https://github.com/typst/templates/blob/main/charged-ieee/lib.typ

#set document(title: title, author: "Jitse De Smet")
#set text(font: "Times New Roman", size: 10pt)
#set page(paper: "a4")
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
  J. De Smet is with the KNowledge On Web Scale team within IDLab, Ghent University (UGent), Gent, Belgium.
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

= Related Work

= Storage Guidance Vocabulary

= Evaluation

= Future Work

= Conclusion

= Acknowledgements

= References
