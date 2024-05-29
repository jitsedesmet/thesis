// this is an example. Check https://typst.app/universe/package/glossarium

#let glossary = (
  (key: "sgv", short: "SGV", long: "Storage Guidance Vocabulary", desc: [
    The vocabulary introduced in this document in order to explicetly dezscribe the structure of a Solid pod.
  ]),
  (key: "shex", short: "ShEx", desc: [
    ShEx~@bib:shex is a communty created shape description language.
  ]),
  (key: "shacl", short: "SHACL", desc: [
    SHACL~@bib:shacl is a W3C Recomendation shape description language.
  ]),
  (key: "http", short: "HTTP", long: "Hypertext Transfer Protocol"),
  (key: "rdf", short: "RDF", long: "Resource Description Framework", desc: [@bib:rdf]),
  (key: "ldp", short: "LDP", long: "Linked Data Platform", desc: [@bib:ldp]),
  (key: "uri", short: "URI"),
  (key: "sparql", short: "SPARQL", descr: [@bib:sparql]),
  (key: "ldes", short: "LDES", long: "Linked Data Event Streams", desc: [@bib:ldes]),
  (key: "api", short: "API", long: "Application Programming Interface"),
  (key: "gdpr", short: "GDPR", long: "General Data Protection Regulation"),
  (key: "ccpa", short: "CCPA", long: "California Consumer Privacy Act"),
  (key: "void", short: "VoID", long: "Vocabulary of Interlinked Datasets", desc: [@bib:void]),
  (key: "tree", short: "TREE", desc: [@bib:tree]),
  (key: "w3c", short: "W3C", long: "World Wide Web Consortium"),
  (key: "tpf", short: "TPF", long: "Triple Patter Fragments", desc: [@bib:tpf]),
  (key: "cbd", short: "CBD", long: "Concise Bounded Description", desc: [@bib:concise-bounded-description]),
  (key: "wac", short: "WAC", long: "Web Access Control", desc: [@bib:wac]),
  (key: "acp", short: "ACP", long: "Access Control Policy", desc: [@bib:acp]),
  (key: "acl", short: "ACL", long: "Access Control List"),
  (key: "crdt", short: "CRDT", long: "Conflict-free Replicated Data Type", desc: [@bib:crdt]),
  (key: "cap", short: "CAP", long: "Consistency, Availability, Partition tolerance", desc: [@bib:cap]),
  (key: "acid", short: "ACID", long: "atomicity, consistency, isolation, durability", desc: [@bib:acid]),
  (key: "snb", short: "SNB", long: "Social Network Benchmark", desc: [@bib:ldbc])
)