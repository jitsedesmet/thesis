#let keywords = ("Semantic Web", "Update Queries", "Solid")

#let supervisors = ("Dr. ir. Ruben Taelman", "Prof. dr. ir. Ruben Verborgh")
#let counsellors = ("Dr. ir. Ruben Taelman", "Bryan-Elliott Tam")

#let abstract-text = [
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
]

#let acknowledgements = [
I would like to acknowledge everyone who accompanied me during my Bachelor and Master.
Through my devotion, and their support during both my Master's and Bachelor's education, I have been able to expand my knowledge.
Allowing me to grow both individually and academically.
Reducing the scope to this Master dissertation, I would specifically like to thank
my promotors #supervisors.join(" and ") for expecting the best in me and supporting me academically.
Beyond their academic support, they have gone beyond what was expected from them and also allowed me to talk to them about life.
In my personal spheres, I would like to explicitly thank my parents and my girlfriend, as well as my friends.
]