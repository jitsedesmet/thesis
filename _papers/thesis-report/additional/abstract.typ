#import "../utils/review.typ": *
#import "../raw/consts.typ": *
#import "../utils/general.typ": *

// The abstract is maximum one page and contains at least the following:
// + The information from the title page (in a format of one’s own);
// + A brief description of the dissertation (fifteen to twenty lines);
// + Possibly three to five well-chosen keywords that describe the topic best.


// Context:      Why the need is so pressing or important
// Need:         Why something needed to be done at all
// Task:         What was undertaken to address the need
// Object:       What the present document does or covers
// Findings:     What the work done yielded or revealed
// Conclusion:   What the findings mean for the audience
// Perspectives: What the future holds, beyond this work

#[
  #show heading: set text(size: 15pt)
  = #title <sec:abstract>
]
#[
  #set par(leading: 0.65em)
  #align(center)[
  
  Jitse De Smet\
  #link("mailto:jitse.desmet@ugent.be")[jitse.desmet\@ugent.be]\
  Master's dissertation submitted in order to obtain the academic degree of\
  `Master of Science in Computer Science Engineering`\
  Academic Year 2023-2024\
  Faculty of Engineering and Architecture\
  Ghent University
  #grid(columns: (1fr, 1fr), gutter: 1em,
      [Supervisors:], [Counsellors:],
      ..supervisors.zip(counsellors).flatten()
  )
]
]

#set par(leading: 0.8em)

*Keywords - #keywords.join(", ")*

#abstract-text
