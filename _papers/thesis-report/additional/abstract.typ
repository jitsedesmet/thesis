#import "../utils/review.typ": *
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
      [Supervisors:],
      [Counsellors:],
      [Dr. ir. Ruben Taelman],
      [Dr. ir. Ruben Taelman],
      [Prof. dr. ir. Ruben Verborgh],
      [Bryan-Elliott Tam],
  )
]
]

#set par(leading: 0.9em)

// Context
Data is the new gold, you hear it constantly.
Much of that gold, flows through Web technologies into centralized data stores of massive companies like Amazon, Google, and TikTok.
The Web, however, was envisioned as a decentralized information space to which anyone could read and write information. // Remember good old Wikipedia?
Todays centralization of data causes numerous problems, such as privacy related-issues and the centralization of attention.
The centralization of attention and media control causes social turbulence.
Such as the US ban on TikTok or more recently the ban of TikTok by France in response to protests.
In a response to these crises, various initiatives are working towards re-decentralizing the Web, such as Solid and Mastodon.
// Need
The re-decentralization of the Web comes with various challenges to overcome since the world is not the same as it used to.
These challenges range from efficient and interoperable reading and writing to expressing potentially complex usage/ access policies.
Efficient reading in de context of a decentralized permissioned ecosystem has received some research attention, but writing remains rather unexplored.
// Task
We therefore looked at the current state of the Solid specification to investigate the problems and data dependencies updates currently face.
// Object
The most problematic was access path dependence, where writers of data need to explicitly specify a location to write or update data.
Similar problems are present when reading data in Solid, but are abstracted through the use of a query engine.
We therefore investigate the possibility of a query engine that can create/ update resources without data dependencies. 
// Findings
Our evaluations show that such a query engine can be created by providing a structural description and has limited overhead.
// Conclusion
Having a data dependency free approach to update decentralized data is of huge importance in the adaptation of decentralized systems,
As it allows easier management of data. 
// Perspectives
The current implantation is limited to updating data of one federation, additional research is required to support inter-federation updates. 
