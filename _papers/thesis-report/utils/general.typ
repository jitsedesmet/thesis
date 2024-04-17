#let smartLink(destination, body) = {
  underline(stroke: (paint: blue, thickness: 1pt, dash: "dashed"), body)
  footnote(destination)
}