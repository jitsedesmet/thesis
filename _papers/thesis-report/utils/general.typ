#let title = "Abstracting Data Updates over a Document-oriented interface of a Permissioned Decentralized Environment"

#let inline-enum(body) = {
  show enum: it => {
    let i = 0
    for item in it.children {
      i = i + 1
      if (i == 1) [#i. #item.body] else [ #i. #item.body]
    }
  }
  body
}

#let text-example(radius: 5pt, width: auto, inset: 8pt, body) = {
  set align(center)
  set par(leading: 0.65em, justify: false)


  block(breakable: false, width: width,
        fill: rgb("#f4f0ec"),
        inset: inset,
        radius: radius, body)
}

#let wrapped-in-home-style(body) = {
  set text(ligatures: false, font: "New Computer Modern")
  show raw: set text(font: "New Computer Modern Mono")
  show math.equation: set text(font: "New Computer Modern Math")
  // Set numbering mode
  set page(margin: 2.5cm)
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1")
  show heading.where(level: 4): it =>[
    #block(it.body)
  ]

  // From: https://github.com/abcoates/sublime-text-turtle-sparql
  set raw(syntaxes: ("./turtle.sublime-syntax", "./sparql.sublime-syntax"))


  // Set font size
  show heading.where(level: 3): set text(size: 1.05em)
  show heading.where(level: 4): set text(size: 1.0em)
  show figure: set text(size: 0.9em)

  // Set spacing
  set par(leading: 16pt, first-line-indent: 1.8em, justify: true)
  show par: set block(spacing: 1em)
  set table(inset: 6.5pt)
  show table: set par(justify: false)
  show figure: it => [#v(1em) #it #v(1em)]

  show heading.where(level: 1): set align(center)
  show heading.where(level: 1): set block(above: 1.95em, below: 1em)
  show heading.where(level: 2): set block(above: 1.85em, below: 1em)
  show heading.where(level: 3): set block(above: 1.75em, below: 1em)
  show heading.where(level: 4): set block(above: 1.55em, below: 1em)

  set figure(placement: auto)
  set enum(numbering: "1.i.")

  // Names for headings
  set heading(supplement: it => {
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
  set cite(style: "institute-of-electrical-and-electronics-engineers")

  // Table stroke
  set table(stroke: 0.5pt + black)

  // show reference targets in brackets
  // #show ref: it => {
  //   let el = it.element
  //   if el != none and el.func() == heading {

  //     [#it (#el.body)]
  //   } else [#it]
  // }

  // color links and references
  // #show ref: set text(fill: color.olive)
  // #show link: set text(fill: blue)
  show link: it => {
    if type(it.dest) == "string" and (it.dest.starts-with("http")) {
      underline(stroke: (paint: blue, thickness: 1pt, dash: "dashed"), it)
      footnote(it.dest)
    } else {
      it
    }
  }

  // Set table style
  show table.cell.where(y: 0): set text(weight: "bold")
  show figure: set block(breakable: true)
  // See the strokes section for details on this!
  let frame(stroke) = (x, y) => (
    left: if x > 0 { 0pt } else { stroke },
    right: stroke,
    top: if y < 2 { stroke } else { 0pt },
    bottom: stroke,
  )
  set table(
    fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },
    stroke: frame(rgb("21222C")),
  )


  body
}
