#let keywords = ("Semantic Web", "Update Queries", "Solid")

#let supervisors = ("Dr. ir. Ruben Taelman", "Prof. dr. ir. Ruben Verborgh")
#let counsellors = ("Dr. ir. Ruben Taelman", "Bryan-Elliott Tam")

#let abstract-text = [
// Context
Data is the new gold; you hear it constantly.
Much of that gold flows through Web technologies into the centralized data stores of massive companies such as Amazon, Google, and TikTok.
The Web, however, was envisioned as a decentralized information space to which anyone could read and write information. // Remember good old Wikipedia?
Today's centralization of data causes numerous problems, such as privacy-related issues and the centralization of attention.
This centralization of attention and media control causes social turbulence.
For example, the US ban on TikTok or, more recently, the ban of TikTok by France in response to protests.
In response to these crises, various initiatives, such as Solid and Mastodon, are working towards re-decentralizing the Web.
// Need
The re-decentralization of the Web comes with various challenges to overcome, since the world is not the same as it used to be.
These challenges range from efficient and interoperable reading and writing to expressing potentially complex usage/ access policies.
Efficient reading in the context of a decentralized, permissioned ecosystem has received some research attention, but writing remains rather unexplored.
// Task
Therefore, we examined the current state of the Solid specification to investigate the problems and data dependencies updates currently face.
// Object
The most challenging problem is access path dependence, where writers of data need to explicitly specify a location to write or update data.
Similar issues are present when reading data in Solid, but they are abstracted through the use of a query engine.
We therefore investigate the possibility of a query engine that can create and update resources without data dependencies. 
// Findings
Our evaluations show that such a query engine can be created by providing a structural description and has limited overhead.
// Conclusion
Having a data dependency free approach to update decentralized data is of massive importance in the adaptation of decentralized systems, as it allows easier management of data. 
// Perspectives
The current implementation is limited to updating data of one federation, additional research is required to support inter-federation updates. 
]

#let acknowledgements = [
I would like to acknowledge everyone who accompanied me during my Bachelor and Master.
My dedication and their help during my master’s and bachelor’s degrees allowed me to expand my knowledge. Allowing me to grow both individually and academically.
Reducing the scope to this Master dissertation, I would specifically like to thank
my promotors #supervisors.join(" and ") for expecting the best in me and supporting me academically.
Beyond their academic support, they have gone beyond what was expected of them and also allowed me to talk to them about life in general.
In my personal spheres, I would like to explicitly thank my parents and my girlfriend, as well as my friends.
]

#let thesis-code = "https://github.com/jitsedesmet/sgv-update-engine/releases/tag/v0.0.1"

