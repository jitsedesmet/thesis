#import "@preview/drafting:0.2.0" // https://typst.app/universe/package/drafting
// #import "@preview/exzellenz-tum-thesis:0.1.0": exzellenz-tum-thesis


#import "glossary.typ": glossary
#import "@preview/glossarium:0.2.6": make-glossary, print-glossary, gls, glspl
#show: make-glossary


// Global Settings //
#set text(lang: "en", size: 12pt)
#set text(ligatures: false)
#set text(font: "New Computer Modern Sans")

// Settings for Body


// Set numbering mode
#set page(numbering: "1", margin: 2.5cm)
#set math.equation(numbering: "(1)")
#set heading(numbering: "1.1")


// Set fonts
#set text(font: "New Computer Modern")
#show raw: set text(font: "New Computer Modern Mono")
#show math.equation: set text(font: "New Computer Modern Math")


// Set font size
#show heading.where(level: 3): set text(size: 1.05em)
#show heading.where(level: 4): set text(size: 1.0em)
#show figure: set text(size: 0.9em)


// Set spacing
#set par(leading: 0.9em, first-line-indent: 1.8em, justify: true)
#show par: set block(spacing: 1em)
#set table(inset: 6.5pt)
#show table: set par(justify: false)
#show figure: it => [#v(1em) #it #v(1em)]

#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): set block(above: 1.95em, below: 1em)
#show heading.where(level: 2): set block(above: 1.85em, below: 1em)
#show heading.where(level: 3): set block(above: 1.75em, below: 1em)
#show heading.where(level: 4): set block(above: 1.55em, below: 1em)


// Pagebreak after level 1 headings
#show heading.where(level: 1): it => [
  #pagebreak(weak: true)
  #it
]

// Names for headings
#set heading(supplement: it => {
  // [#json.encode(it)]
  if (it.has("depth")) {
    if it.depth == 1 [Part]
    else if it.depth == 2 [Chapter]
    else [Section]
  } else {
    [ERROR, this should not happen]
  }
})


// Set citation style
#set cite(style: "alphanumeric")


// Table stroke
#set table(stroke: 0.5pt + black)


// show reference targets in brackets
// #show ref: it => {
//   let el = it.element
//   if el != none and el.func() == heading {

//     [#it (#el.body)]
//   } else [#it]
// }

// color links and references
// #show ref: set text(fill: color.olive)
#show link: set text(fill: blue)


// ------- Preface -----
#set page(numbering: "i")


#heading(numbering: none)[Preface]
#pagebreak(weak: false)

#heading(numbering: none)[Remark on the master’s dissertation and the oral presentation]
This master's dissertation is part of an exam. Any comments formulated by the
assessment committee during the oral presentation of the master's dissertation are
not included in this text.
#pagebreak(weak: false)


#heading(numbering: none)[Abstract]
#include "additional/abstract.typ"
#pagebreak(weak: false)

#heading(numbering: none)[Extended Abstract]

#pagebreak(weak: false)


// ------ Content ------

// Set defaults
#set par(leading: 0.65em, first-line-indent: 0pt, justify: false)

// style table-of-contents
#show outline.entry.where(
  level: 1
): it => {
  v(1em, weak: true)
  strong(it)
}


// Table of contents.
#outline(
  title: {
    text(1.3em, weight: 700, "Contents")
    v(10mm)
  },
  indent: 2em,
  depth: 3
)
#pagebreak(weak: false)

// List of figures.
#heading(numbering: none, level: 1)[List of Figures]
#outline(
  title: none,
  target: figure.where(kind: image),
)

// List of tables.
#heading(numbering: none, level: 1)[List of Tables]
#outline(
  title: none,
  target: figure.where(kind: table)
)  


// List of Acronyms.
#heading(numbering: none)[List of Acronyms]
#print-glossary(glossary)


// --- Main Chapters ---
#set par(leading: 0.9em, first-line-indent: 1.8em, justify: true)
#set page(numbering: "1.")
#counter(page).update(1)


#include "chapters/Chapter_Introduction.typ"

#include "chapters/storage-guidance-vocab.typ"

//#include "Chapter_Background.typ"

//#include "Chapter_RelatedWork.typ"

//#include "Chapter_Methodology.typ"

//#include "Chapter_Experiments.typ"

//#include "Chapter_Discussion.typ"

//#include "Chapter_FutureResearch.typ"


// --- Bibliography ---

// If ideas, words, sentences or charts are taken from someone else’s work and used or
// paraphrased in the master’s dissertation, it is obliged by law to mention the original author: in
// the text itself, immediately after the passage concerned, and in the reference list at the back
// of the master’s dissertation.
// Correct and complete references are extremely important and this should be taken into
// account at the start of the implementation of the dissertation work. In doing so it can be
// avoided that extra time and research is needed in order to complete the references when
// finishing the dissertation.


// As there are several styles for references (courantly used are APA and IEEE), each student
// is advised to enquire with his/her supervisor which style is usual within the own discipline.
// Online applications are often used such as My EndNote Web, LaTeX of BibTeX. Students
// should choose a uniform style of reference.

// Ordering the list of references can be done
// - either in chronological order (the order as used in the text);
// - or in alphabetical order by name of author.

#set par(leading: 0.7em, first-line-indent: 0em, justify: true)
#bibliography("items.bib", style: "apa")


// --- Appendixes ---

// restart page numbering using roman numbers
// #set page(numbering: "i")
// #counter(page).update(1)


// #include("Chapter_Appendix.typ")