# LDP-WAC

Here we describe updates as done by most of the
[solid project developer tools](https://solidproject.org/developers/tools/). 

The technology uses HTTP put/ patch updates using LDP and WAC for (basic) access control.

WAC is limited to describing whether a single authenticated user, or everyone can *read/append/write/control* a resource.
LDP is used as a literal translation of a file structure.
Making it equivalent to a basic file-structure hosted on the web. 
If SOLID was to replace classical databases, this is not a great solution.
The foundational paper of relational databases,
["Relational Model of Data Large Shared Data Banks" by E. F. Codd](https://dl.acm.org/doi/pdf/10.1145/362384.362685)
even starts by proclaiming this thought:
> Future users of large data banks must be protected from
having to know how the data is organized in the machine (the
internal representation). A prompting service which supplies
such information is not a satisfactory solution. 

This last sentence is also of interest because he even explains that,
even when providing something like a type index, users should not care about data organization.

We will use
[solid-client library](https://docs.inrupt.com/developer-tools/api/javascript/solid-client/).
As a running example of a tool that is often used is the
Maintained by
[Inrupt](https://www.inrupt.com/), a company co-created by Sir Tim berners-Lee.
The company aims to provide
data infrastructure software that enables enterprises and governments to deploy and manage Solid-compliant solutions.

The library is quite simple. In the [read/write docs](https://docs.inrupt.com/developer-tools/javascript/client-libraries/tutorial/read-write-data/)
We see basic manipulation of files(=SolidDataset), directories(=containers), data entities in a file(=Thing).
The library creates an easy API to manage these resources.

Other interesting alternatives also exist:
* https://github.com/linkeddata/rdflib.js/
* https://github.com/LDflex/Query-Solid


What we have now is basically a Navigational database of Charles Bachman's.
> Navigational database programming thus came to be seen as intrinsically procedural;  
> The declarative nature of relational languages such as SQL offered better programmer productivity and a higher level of data independence

So in principle, we want to get something that's intrinsically procedural to be declarative.
> Languages such as SPARQL used to retrieve Linked Data from the Semantic Web are also simultaneously declarative and navigational.

> Graph databases are similar to 1970s network model databases in that both represent general graphs,
> but network-model databases operate at a lower level of abstraction and lack easy traversal over a chain of edges.

# User stories
## User story collection 1: update data I own
### Insert data
#### Pictures of her clients (paying party can access)

#### Pictures of her kids (kids and husband can access (specific users, depending on the content of the picture))


#### Pictures of company event (users that can prove to be affiliated with the company can access)


#### Medical pictures (her doctor can access, and Florence does not care how they are stored)


#### Blogposts (public)


#### Notes (private)


#### Smartwatch data


### Delete data


### Non-significant update of subject


### Significant update of data



## User story collection 2: update data I do not own, but can update directly
### Insert data


### Delete data


### Non-significant update of subject


### Significant update of data


### Pass the quilt master badge


# User story collection 3: Update data I cannot update directly
### Insert data


### Delete data


### Non-significant update of subject


### Significant update of data


### Pass the runner of the month token

