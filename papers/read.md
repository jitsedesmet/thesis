---
title: Read papers
---


(I have this data in another location. I may or may not move it here)

| paper id | name                                                                                              | database | search item | year | source type | relevance | summary	                  | link |
|----------|---------------------------------------------------------------------------------------------------|----------|-------------|------|-------------|-----------|---------------------------|------|
| 1        | 	A prospective analysis of security vulnerabilities within link traversal-based query processing	 | /        | 	/          |      |             |           |                           |      |
| 2        | 	A prospective analysis of security vulnerabilities within link traversal- based query prosessing | [1]      | 	/          |      |             |           | What is a content policy? |      |






# Interesting papers

## Real-time collaboration in Linked Data Systems

- Use existing CRDT implementations that support JSON. We treat that JSON as JSON-LD.
- Since these implementations use binary formats, we keep both a binary document with the whole change history,
  and a textual representation of the latest state (so we have a view readable by anyone).
- they created an ontology CRDO that, among other things,
  allows you to discover where these two documents are located in a solid pod. 
