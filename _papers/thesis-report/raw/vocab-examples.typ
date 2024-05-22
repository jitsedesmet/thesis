#import "../utils/review.typ": *
#import "../utils/general.typ": *

#let vocab-excample = text-example[
```turtle
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix ex: <http://example.org/> .
@prefix sgv: <https://example.org/storage-guidance-vocabulary#> .
@prefix ldp: <http://www.w3.org/ns/ldp#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix ldbc: <http://www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/> .
@prefix dbo: <https://dbpedia.org/ontology> .

<> a ldp:Container, sgv:unstructured-collection ;
  sgv:client-control [
      a sgv:allow-when-not-claimed ;
    ] ;
  sgv:one-file-one-resource "false"^^xsd:boolean .

# An unstructured collection contains a structured collection "posts"
<posts/> a ldp:Container, sgv:structured-collection, sgv:canonical-collection ;
  sgv:one-file-one-resource "false"^^xsd:boolean ;
  sgv:save-condition [
      a sgv:always-stored ;
      sgv:update-condition [
          a sgv:update-prefer-static ;
          sgv:resource-description [
            a sgv:shacl-descriptor ;
            sgv:shacl-shape <sgv#postShape> ;
          ] ;
        ] ;
    ] ;
  sgv:group-strategy [
      a sgv:group-strategty-uri-template ;
      sgv:uri-template
  '{http%3A%2F%2Fwww.ldbc.eu%2Fldbc_socialnet%2F1.0%2Fvocabulary%2FisLocatedIn}#{::UUID_V4}' ;
      sgv:regexMatch '([^/]+)#([^#]+)$' ;
      sgv:regexReplace '$1/$2' ;
    ] .

<sgv#postShape>
  a sh:NodeShape ;
  sh:property [
      sh:path rdf:type ;
      sh:hasValue ldbc:Post ;
    ] ;
  sh:property [
      sh:path ldbc:creationDate ;
      sh:datatype xsd:dateTime ;
      sh:minCount 1 ;
      sh:maxCount 1 ;
    ] ;
  sh:property [
      sh:path ldbc:id ;
      sh:datatype xsd:long ;
      sh:minCount 1 ;
      sh:maxCount 1 ;
    ] .
```
] 

#let vocab-shex = grid(
  columns: (1fr, 1fr),
text-example[
```
PREFIX sgv: <https://thesis.jitsedesmet.be/solution/storage-guidance-vocabulary/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX ldes: <https://w3id.org/ldes#>
PREFIX tree: <https://w3id.org/tree#>

<ResourceCollectionShape> {
   rdf:type [ sgv:resource-collection ] ;
   sgv:client-control {
      rdf:type [
      sgv:free-client sgv:additional-allowed
      sgv:allowed-when-not-preffered
      sgv:allow-when-not-claimed sgv:no-control
      ] ;
   } ? ;
   sgv:one-file-one-resource xsd:boolean ? ;
}

<StructuredCollectionShape> {
  &<ResourceCollectionShape> ;
  rdf:type [ sgv:structured-collection ] ;
  sgv:group-strategy <GroupStrategyShape> ;
# Copied from the LDES vocabulary, fan of the idea!
  sgv:retention-policy {
    rdf:type ldes:DurationAgoPolicy ;
    tree:value xsd:duration ;
  } ?
}

<CanonicalCollectionShape> {
  &<StructuredCollectionShape> ;
  sgv:save-condition {
    rdf:type [
      sgv:state-required sgv:always-stored
      sgv:prefer-other sgv:prefer-most-specific
      sgv:only-stored-when-not-redundant sgv:store-never
    ] ;
    sgv:update-condition <UpdateConditionShape>
  } + ;
}
```
],
text-example[
```
<DerivedCollectionShape> {
  &<CanonicalCollectionShape> ;
  sgv:derived-from {
    sgv:resource-descripion <ResourceDescriptionShape> ;
    sgv:source IRI ;
    sgv:filter xsd:string ;
  } +
}

# Any ldp:Container in a structured collection is a GroupedCollection
<GroupedCollection> {
  &<GroupStrategy>
}

<GroupStrategyShape> {
    rdf:type sgv:group-strategty-uri-template ;
    sgv:uri-template xsd:string ;
    sgv:regexMatch xsd:string ;
    sgv:refexReplace xsd:string ;
  |
    rdf:type sgv:group-strategy-sparql ;
    sgv:sparql-query xsd:string ;
}

<UpdateConditionShape> {
  (
    rdf:type [
      sgv:update-keep-always sgv:prefer-static sgv:best-matched
      sgv:update-disallow sgv:removal-only sgv:state-dependent
    ] ;
  |
    rdf:type [ sgv:keep-distance ] ;
    sgv:distance xsd:decimal ;
  ) ;
  sgv:resource-descripion <ResourceDescriptionShape> ;
}

<ResourceDescriptionShape> {
  rdf:type sgv:shacl-descriptor ;
  sgv:shacl-shape IRI ;
}
```
]
)