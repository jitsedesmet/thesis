#import "../utils/review.typ": *
#import "../utils/general.typ": *
#import "../utils/ieee.typ": ieee

#[
#show: ieee.with(
  paper-size: "a4",
  title: title,
  abstract: [
    To write an abstract is a delicate art that Jitse will need to master if he wants to get a masters degree.
  ],
  authors: (
    (
      name: "Jitse De Smet",
      // department: [Co-Founder],
      // organization: [Typst GmbH],
      // location: [Berlin, Germany],
      email: "jitse.desmet@ugent.be"
    ),
    // (
    //   name: "Laurenz Mädje",
    //   department: [Co-Founder],
    //   organization: [Typst GmbH],
    //   location: [Berlin, Germany],
    //   email: "maedje@typst.app"
    // ),
  ),
  index-terms: ("Scientific writing", "Typesetting", "Document creation", "Syntax"),
  // bibliography: bibliography("../items.bib"),
)
]