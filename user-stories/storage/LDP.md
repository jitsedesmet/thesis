---
title: LDP (WIP)
---

[spec](https://www.w3.org/TR/ldp/)

LDP is used either explicitly, e.g. in 
[SOLID Interoperability](https://solid.github.io/data-interoperability-panel/specification/#data-registration)
or implicitly by many specifications in the solid spec.
This makes it hard to solid not having LDP, I will however make a strong case as to why not to use it.

Here most, if not all, tools of the [solid project developer tools](https://solidproject.org/developers/tools/) depend on LDP.

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

At the time of writing,
[solid-client library](https://docs.inrupt.com/developer-tools/api/javascript/solid-client/)
is a crucial API to interact with solid servers.
It is maintained by
[Inrupt](https://www.inrupt.com/), a company co-created by Sir Tim berners-Lee.
The company aims to provide
data infrastructure software that enables enterprises and governments to deploy and manage Solid-compliant solutions.

The library is quite simple.
In the [read/write docs](https://docs.inrupt.com/developer-tools/javascript/client-libraries/tutorial/read-write-data/)
We see basic manipulation of files(=SolidDataset), directories(=containers), data entities in a file(=Thing).
The library creates an easy API to manage these resources.

Other interesting alternatives also exist:
* https://github.com/linkeddata/rdflib.js/
* https://github.com/LDflex/Query-Solid

## Stories evaluations
When a pod owner wants to insert pictures, we assume that they are marked using the appropriate metadata.
That means the picture contains metadata like:
* `ex:forClient ex:clientId`
* `ex:containing ex:Alice, ex:Bob`

### As a pod owner, I want to insert a picture that is **accessible by other pod** owners designed by me, so these people can access the pictures I took for them.


### As a pod owner, I want to insert a picture that **no one else can see**, so that I can keep backups, but hide bad results.


### As a pod owner, I want to **transfer** pictures I have to someone else, so they now own that picture. Note that I do not have write permissions in the other solid pod!


### As a pod owner, I want to insert a picture with `ex:contains ex:child1` that is **accessible by my children** (`ex:child1` and `ex:child2`), so we can all look back at old times.


### As a pod owner, I want to insert a picture that is **accessible by anyone that can prove** to be working at a certain company, so that they have something to talk about at the coffee machine.


### As a medical professional, I want to **insert a picture in someone else's pod** abiding by the access control preferences they have, so they own their medical picture and other professionals they contact can access it.


### As a pod owner, I want to have an **opinionated view** over my data, so I can easily access it and feel in control.


### As a pod owner, I want to create blog posts that **anyone can access**, so I get cloud.


### As a pod owner, I want to create **private notes**, so I can order my private thoughts before I launch them into the world.


### As a pod owner, I want to **reorganize the way I view** my data without breaking references made by other people, so I can view my data from different angles, but not disturb the cloud I made.


### As a pod owner, I want to **transfer a token** to a pod I have **full access** to; the transfer should confirm to **ACID**, so that there is always one person holding the token, and everyone can see who has it.


### As a pod owner, I want to upload **new kinds of data** (e.g. smartwatch), so I can always stay up to date with the latest technology.


### As a pod owner, I want to transfer a token to a pod I have **no access** to; the transfer should confirm to **ACID**, so that there is always one person holding the token, and everyone can see who has it.


### As a smartwatch, I want to **upload time series data** to the solid pod, so the user can view their activities


### As a pod owner, I want to have **control over how much data I keep** from my smartwatch and when to aggregate, so my pod's memory is not entirely consumed by a single aspect of my life.


### As a pod owner, I want to **insert an additional** property to an existing resource, so it becomes more self-descriptive.


### As a pod owner, I want to **modify a property** of an existing resource, so I can fix my mistakes.


### As a pod owner, I want to **delete a property** of an existing resource, so I can fix my mistakes.


### As a pod owner, I want to **remove an entire resource**, so I can clear space. Does she want some kind of protection to not accidentally delete his medical pictures?


### As a pod owner, I want to **modify a resource** in a way that alters the location of that resource in my current view, so I don't need to be cautious when modifying resources.


### As a pod owner, I want to **insert an additional** property to an existing resource in **someone else's pod**, so it becomes more self-descriptive.


### As a pod owner, I want to **modify a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.


### As a pod owner, I want to **delete a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.


### As a pod owner, I want to **modify a resource** in **someone else's pod**, in a way that alters the location of that resource in a view present, so I don't need to be cautious when modifying resources.


### As a pod owner, I want to **remove** a resource in **someone else's pod**, so I don't see it anymore.


### As a pod owner, I want to **remove** a resource in **someone else's pod**, so no one can see it. I might want to send a suggestion.



# User stories
## User story collection 1: update data I own
### Insert data
When Florence loads the pictures onto her computer, we assume that they are marked using the appropriate metadata.
That means the picture contains metadata like:
* forClient: clientId
* containing: ex:Alice, ex:Bob, ...

#### Pictures of her clients (paying party can access)
Assuming the `ClientPictures` have their own class, we could use the `type index` to find the appropriate container.
Now we still have an issue.
We do not know whether Florance wants her pictures to further be split into subContainers by date.
All we can conclude is: we perform a post on this container.

More problems arise when the type index contains multiple containers for `ClientPicture`.

Or when the type index does not contain a match, now the application needs to decide where the picture goes.
And as a result, florance is not really in control.

Access control can be easy here given that we know who the client is, a picture can just have access.

The type-index issues mentioned here are also applicable for the shape tree.

#### Pictures of her kids (kids and husband can access (specific users, depending on the content of the picture))

With LDP, the same problems as before arise.

As for Access control, WAC would need explicit definition and could not be inferred, using ACP it could be inferred.

#### Pictures of company event (users that can prove to be affiliated with the company can access)

With LDP, the same problems as before arise.

As for access control, only ACP can validate this.

#### Medical pictures (her doctor can access, and Florence does not care how they are stored)

With LDP, the same problems as before arise, but now we don't really care.

As for access control, no new problems arise.

#### Blogposts (public)
No new problems.

#### Notes (private)
No new problems.

#### Smartwatch data
No new problems, Florance just has no control.

### Delete data
if you can find the data, you can delete it, no real issue here.

### Non-significant update of subject
As soon as you've found it, you can update it.

### Significant update of data
Since we do not care for indexes, or Florance's opinion, this is inapplicable.


## User story collection 2: update data I do not own, but can update directly
### Insert data
To inset a picture into her husband's pod, she needs to find his webId, this she either knows of finds using her vcard.
This process breaks Access path dependence.
Once the webId is found, the problems are just the same.

### Delete data
No new problem.

### Non-significant update of subject
No new problem.

### Significant update of data
No new problem.

### Pass the quilt master badge
There is no real way of doing this with conformance to ACID.

# User story collection 3: Update data I cannot update directly
### Insert data
Not possible. Would need [Solid Notifications Protocol](https://solidproject.org/TR/notifications-protocol)

### Delete data
Same as above.

### Non-significant update of subject
Same as above.

### Significant update of data
Same as above.

### Pass the runner of the month token
Same as above. Not possible in ACID way.

# Conclusion
We now evaluate what functional requirements are met using :white_check_mark: and :x:.
1. Data should remain consistent with the requirements posed by the **technology** (e.g., solid):
   :x:
2. The data should have **easy access control**: :white_check_mark:
3. References should remain consistent/ [**cool**](https://www.w3.org/Provider/Style/URI): :x:
4. The **owner is in control** of the data: :x:
5. Data in a data storage should be **discoverable**:
   :white_check_mark:/:x:, type index is not the best, shape tree is better.
6. Allow **profiles or strategies**: :x:
7. Storage ACL should consider **privacy**: :x:
   if the type index is a static resource, knowing the pod contains certain types can be a privacy invasion.
8. Good old **ACID**: :x:
9. Storage should avoid **data dependence**: :x:
