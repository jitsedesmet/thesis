#let smartLink(destination, body) = {
  underline(stroke: (paint: blue, thickness: 1pt, dash: "dashed"), body)
  footnote(destination)
}

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

#let text-example(radius: 5pt, width: auto, body) = {
  set align(center)
  set par(leading: 0.65em)
  
  
  block(breakable: false, width: width,
        fill: rgb("#f4f0ec"),
        inset: 8pt,
        radius: radius, body)
}