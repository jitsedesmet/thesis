# LDP-(WAC/ACP)

Here we describe updates as done by most of the
[solid project developer tools](https://solidproject.org/developers/tools/). 

The technology uses HTTP put/ patch updates using LDP and WAC or ACP for access control.
[WAC already cannot support some user stories](../access-control/WAC.md#limitations-with-regard-to-user-stories)

On the other hand, ACP is really strong.

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

We will use
[solid-client library](https://docs.inrupt.com/developer-tools/api/javascript/solid-client/)
as a running example of a tool that is often used.
It is maintained by
[Inrupt](https://www.inrupt.com/), a company co-created by Sir Tim berners-Lee.
The company aims to provide
data infrastructure software that enables enterprises and governments to deploy and manage Solid-compliant solutions.

The library is quite simple. In the [read/write docs](https://docs.inrupt.com/developer-tools/javascript/client-libraries/tutorial/read-write-data/)
We see basic manipulation of files(=SolidDataset), directories(=containers), data entities in a file(=Thing).
The library creates an easy API to manage these resources.

Other interesting alternatives also exist:
* https://github.com/linkeddata/rdflib.js/
* https://github.com/LDflex/Query-Solid

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
