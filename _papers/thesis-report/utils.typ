#import "@preview/drafting:0.2.0": set-page-properties, margin-note, inline-note // https://typst.app/universe/package/drafting

#let todo(body) = {
  text(fill: red)[TODO: #body]
}

#let MRT(body) = {
  margin-note[RT: #body]
}

#let IRT(body) = {
  inline-note[RT: #body]
}

#let delete(body) = {
  text(fill: rgb("#FF8C19"), strike(body))
}

#let add(body) = {
  text(fill: green, body)
}