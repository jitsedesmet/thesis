---
title: Read papers
---


(I have this data in another location. I may or may not move it here)

| paper id | name                                                                                                  | database | search item | year | source type | relevance | summary	                                                                                                                                                                                                    | link |
|----------|-------------------------------------------------------------------------------------------------------|----------|-------------|------|-------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|
| 1        | 	A prospective analysis of security vulnerabilities within link traversal-based query processing	     | /        | 	/          |      |             |           |                                                                                                                                                                                                             |      |
| 2        | 	A prospective analysis of security vulnerabilities within link traversal- based query prosessing     | [1]      | 	/          |      |             |           | What is a content policy?                                                                                                                                                                                   |      |
| 2        | [What's in a Pod? A Knowledge Graph Interpretation For the Solid Ecosystem](what-is-in-a-pod) | /        | /           | 2022 |             |           | Very interesting view on how to store data, viewing LDP as a view over the graph storage. Nice to reference to since the view on "resources" that I have has significant overlap |      |






# Interesting papers

## Real-time collaboration in Linked Data Systems

- Use existing CRDT implementations that support JSON. We treat that JSON as JSON-LD.
- Since these implementations use binary formats, we keep both a binary document with the whole change history,
  and a textual representation of the latest state (so we have a view readable by anyone).
- they created an ontology CRDO that, among other things,
  allows you to discover where these two documents are located in a solid pod. 
