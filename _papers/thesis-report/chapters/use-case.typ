#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Use Case
// explain why the industry needs this - stay critical: is this part of problem statement or not?

In this work, we will work with a social media use case where a pod contains the social media data of a single user.
This use case follows the LDBC @snb~@bib:ldbc use case.
Every person has information about themselves and can create _posts_ and _comments_.
Both posts and comments are _messages_, and a comment is a reply to some message.
Messages have an ID, a browser, a location IP, content, tags, and a creator.
@fig:schema-snb shows the schema used within this use case as copied from the
#link("https://github.com/ldbc/ldbc_snb_datagen_hadoop#graph-schema")[LDBC @snb] GitHub. 
@fig:snb-read and @fig:snb-write show two example queries over the @snb data that respectively read, and write data.

#figure(
  image("../static/schema-snb.png", width: 90%),
  caption: [Social Network Benchmark data schema],
) <fig:schema-snb>

#figure(
text-example[
```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX snvoc: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
SELECT ?firstName ?lastName ?birthday ?locationIP ?browserUsed ?cityId ?gender ?creationDate
WHERE {
  <https://example.com/Alice/profile/card#me> rdf:type snvoc:Person;
    snvoc:id ?personId;
    snvoc:firstName ?firstName;
    snvoc:lastName ?lastName;
    snvoc:gender ?gender;
    snvoc:birthday ?birthday;
    snvoc:creationDate ?creationDate;
    snvoc:locationIP ?locationIP;
    snvoc:isLocatedIn ?city.
  ?city snvoc:id ?cityId.
  <https://example.com/Alice/profile/card#me> snvoc:browserUsed ?browserUsed.
}
```
], caption: [Example LDBC SNB read query]
) <fig:snb-read>

#figure(
text-example[
```sparql
prefix ns1: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/vocabulary/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
prefix tag: <http://localhost:3000/www.ldbc.eu/ldbc_socialnet/1.0/tag/>
prefix resource: <http://localhost:3000/dbpedia.org/resource/>

INSERT DATA {
  <http://example.com/Alice/Posts#416608218494388> a ns1:Post ;
    ns1:browserUsed "Chrome" ;
    ns1:content
      "I want to eat an apple while scavenging for mushrooms in the forest." ;
    ns1:creationDate "2024-05-08T23:23:56.830000+00:00"^^xsd:dateTime ;
    ns1:id "416608218494388"^^xsd:long ;
    ns1:hasCreator <http://example.com/Alice/profile/card#me> ;
    ns1:hasTag tag:Alanis_Morissette, tag:Austria ;
    ns1:isLocatedIn resource:China ;
    ns1:locationIP "1.83.28.23" .
}
```
], caption: [Example LDBC SNB write query]
) <fig:snb-write>



