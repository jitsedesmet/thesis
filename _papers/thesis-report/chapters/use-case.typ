#import "../utils/review.typ": *
#import "../utils/general.typ": *

= Use Case
// explain why industry needs this - stay critical: is this part of problem statement or not?

In this work we will work with a social media use case where a pod contains the social media data of a single user.
This use case follows the LDBC @snb~@bib:ldbc use case.
Every Person has information about themselves, can create posts or comments.
Both posts and comments are messages, and a comment is a reply on some message.
Messages have an id, a browser, a locationIP, content, tags and a creator.
@fig:schema-snb shows the schema used within this use case as copied from the
#link("https://github.com/ldbc/ldbc_snb_datagen_hadoop#graph-schema")[LDBC @snb] GitHub. 

#figure(
  image("../static/schema-snb.png", width: 90%),
  caption: [Social Network Benchmark data schema],
) <fig:schema-snb>
