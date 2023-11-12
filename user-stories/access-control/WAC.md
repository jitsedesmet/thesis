# [WAC](https://solidproject.org/TR/wac)

You use Linked Data's [acl ontology](http://www.w3.org/ns/auth/acl#).

Allows use of `acl:accessToClass` to allow access on a badge of resources.

You have the following [access modes](https://solidproject.org/TR/wac##access-modes):
* `acl:Read`:\
  Allows access to a class of read operations on a resource, e.g.,
  to view the contents of a resource on HTTP GET requests.
* `acl:Write` \
  Allows access to a class of write operations on a resource, e.g.,
  to create, delete or modify resources on HTTP PUT, POST, PATCH, DELETE requests.
* `acl:Append`:\
  Allows access to a class of append operations on a resource, e.g.,
  to add information, but not remove, information on HTTP POST, PATCH requests.
* `acl:Control`:\
  Allows access to a class of read and write operations on an ACL resource associated with a resource.

Could use [Access Mode Extensions](https://solidproject.org/TR/wac#extension-acl-mode)
to define a subclass of a default access mode, like for example `acl:read`,
defining that the server should execute a random function that would than limit read access. 
This is included in the spec, but far-fetched.

Interesting considerations:
> Servers are strongly discouraged from trusting the information returned by looking up an agent’s WebID for access control purposes.
> The server operator can also provide the server with other trusted information to include in the search for
> a reason to give the requester the access.

Last part is interesting, there is a search mechanic? This "function" is not serialized?
Also why discourage? Just know what you are doing? We have VC now.
WAC+VC: https://github.com/solid/authorization-panel/issues/79

## Limitations with regard to user stories:
WAC is limited to describing whether a single authenticated user, or everyone can *read/append/write/control* a resource.
This already causes some user stories not to work:
* Partly broken: Pictures containing her children are always accessible to her husband and children.
  Broken because it needs to be managed per picture and cannot be inferred.
* Pictures of company events are accessible by everyone currently employed by that company.
  Broken because VC are not supported. (although there are efforts to add support)


## Stories evaluations
### As a pod owner, I want to insert a picture that is **accessible by other pod** owners designed by me, so these people can access the pictures I took for them.
:white_check_mark:, WAC allows you to give a list of users read access.

### As a pod owner, I want to insert a picture that **no one else can see**, so that I can keep backups, but hide bad results.
:white_check_mark:, WAC allows you to give no one read access.

### As a pod owner, I want to **transfer** pictures I have to someone else, so they now own that picture. Note that I do not have write permissions in the other solid pod!
:black_square_button:, WAC does not care about storage of data.

### As a pod owner, I want to insert a picture with `ex:contains ex:child1` that is **accessible by my children** (`ex:child1` and `ex:child2`), so we can all look back at old times.
:x:, Partly broken, because it needs to be managed per picture and cannot be inferred.

### As a pod owner, I want to insert a picture that is **accessible by anyone that can prove** to be working at a certain company, so that they have something to talk about at the coffee machine.
:x:, broken because WAC does not support Verifiable Credentials.

### As a medical professional, I want to **insert a picture in someone else's pod** abiding by the access control preferences they have, so they own their medical picture and other professionals they contact can access it.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to have an **opinionated view** over my data, so I can easily access it and feel in control.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to create blog posts that **anyone can access**, so I get cloud.
:white_check_mark:, WAC allows you to give everyone read access.


### As a pod owner, I want to create **private notes**, so I can order my private thoughts before I launch them into the world.
:white_check_mark:, WAC allows you to give no one read access.


### As a pod owner, I want to **reorganize the way I view** my data without breaking references made by other people, so I can view my data from different angles, but not disturb the cloud I made.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **transfer a token** to a pod I have **full access** to; the transfer should confirm to **ACID**, so that there is always one person holding the token, and everyone can see who has it.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to upload **new kinds of data** (e.g. smartwatch), so I can always stay up to date with the latest technology.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to transfer a token to a pod I have **no access** to; the transfer should confirm to **ACID**, so that there is always one person holding the token, and everyone can see who has it.
:black_square_button:, WAC does not care about storage of data.


### As a smartwatch, I want to **upload time series data** to the solid pod, so the user can view their activities
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to have **control over how much data I keep** from my smartwatch and when to aggregate, so my pod's memory is not entirely consumed by a single aspect of my life.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **insert an additional** property to an existing resource, so it becomes more self-descriptive.
:black_square_button:, WAC does not care about storage of data.
As opposed to 
[ACP](ACP.md#as-a-pod-owner-i-want-to-insert-an-additional-property-to-an-existing-resource-so-it-becomes-more-self-descriptive)
here the access control cannot be dependent on the properties, so it cannot cause a change in access.


### As a pod owner, I want to **modify a property** of an existing resource, so I can fix my mistakes.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **delete a property** of an existing resource, so I can fix my mistakes.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **remove an entire resource**, so I can clear space. Does she want some kind of protection to not accidentally delete his medical pictures?
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **modify a resource** in a way that alters the location of that resource in my current view, so I don't need to be cautious when modifying resources.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **insert an additional** property to an existing resource in **someone else's pod**, so it becomes more self-descriptive.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **modify a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **delete a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **modify a resource** in **someone else's pod**, in a way that alters the location of that resource in a view present, so I don't need to be cautious when modifying resources.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **remove** a resource in **someone else's pod**, so I don't see it anymore.
:black_square_button:, WAC does not care about storage of data.


### As a pod owner, I want to **remove** a resource in **someone else's pod**, so no one can see it. I might want to send a suggestion.
:black_square_button:, WAC does not care about storage of data.


## Conclusion
We now evaluate what functional requirements are met using:
* :white_check_mark: when the requirement is met
* :x: when the requirement is not met
* :black_square_button: when the requirement is not in the scope of this spec

1. Data should remain consistent with the requirements posed by the **technology** (e.g., solid):
   :white_check_mark:, unless you remove your own access to a resource.
2. The data should have **easy access control**: :x:, no, since we fail in some of our user stories.
3. References should remain **consistent/cool**: :black_square_button:
4. The **owner is in control** of the data: :black_square_button:
5. Data in a data storage should be **discoverable**: :black_square_button:
6. Allow **profiles or strategies**: :black_square_button:
7. Storage ACL should consider **privacy**: :white_check_mark:
   resource binds access control, or the server checks the private matchers.
   This spec on its own allows privacy.
   However, when combined with LDP, as it often does, this becomes :x:.
   It fails in that case because the existence of a non-accessible resource can be a privacy concern.
8. Good old **ACID**: :black_square_button:
9. Storage should avoid **data dependence**: :black_square_button:

