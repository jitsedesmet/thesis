// this is an example. Check https://typst.app/universe/package/glossarium

#let glossary = (
  // minimal term
  (key: "kuleuven", short: "KU Leuven"),
  // a term with a long form
  (key: "unamur", short: "UNamur", long: "Université de Namur"),
  // no long form here
  (key: "kdecom", short: "KDE Community", desc:"An international team developing and distributing Open Source software."),
  // a full term with description containing markup
  (
    key: "oidc", 
    short: "OIDC", 
    long: "OpenID Connect", 
    desc: [OpenID is an open standard and decentralized authentication protocol promoted by the non-profit
     #link("https://en.wikipedia.org/wiki/OpenID#OpenID_Foundation")[OpenID Foundation].]),
  (key: "sgv", short: "SGV", long: "Storage Guidance Vocabulary"),
  (key: "shex", short: "ShEx"),
  (key: "shacl", short: "SHACL"),
  (key: "http", short: "HTTP", long: "Hypertext Transfer Protocol"),
  (key: "rdf", short: "RDF", long: "Resource Description Framework"),
  (key: "ldp", short: "LDP", long: "Linked Data Platform"),
  (key: "uri", short: "URI"),
  (key: "sparql", short: "SPARQL")
)