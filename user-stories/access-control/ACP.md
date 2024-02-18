---
title: Access Control Policy
---

[spec](https://solidproject.org/TR/acp)

* The [Solid Application Interoperability](../solid-interop.md) spec enhances this with ways of requesting access.
* Also explained by Inrupt: https://docs.inrupt.com/developer-tools/javascript/client-libraries/tutorial/manage-acp/
* Seems to be the bigger sibling of WAC.
* Policies are themselves LD (Idea: we only need to evaluate it once?).
* Has Verifiable Credentials Matcher statements

The problem is currently is that not all servers support it.

Question: Can ACL decide what verifiable credential it requests based on the content of a thing
ANSWER: NO: for each picture we would need a matcher that matches all users in it. But matchers are independent of data content.
It is thus NOT possible to define something like:
> Allow Boby and Freya to access resources that matches `?resource contains ex:Boby, ex:Freya`.

ACP thus lacks access control based on triple content.
This shortcoming has been noticed by Thomas Bergwinkl, who described 
[Universal Access Control (UAC)](https://www.bergnet.org/people/bergi/files/documents/2014-02-14/index.html#/).


## Stories evaluations

### As a pod owner, I want to insert a picture that is **accessible by other pod** owners designed by me, so these people can access the pictures I took for them.
:white_check_mark:, ACP allows you to say something is accessible by a list of users.

### As a pod owner, I want to insert a picture that **no one else can see**, so that I can keep backups, but hide bad results.
:white_check_mark:, ACP allows you to say something is inaccessible by anyone.

### As a pod owner, I want to **transfer** pictures I have to someone else, so they now own that picture. Note that I do not have write permissions in the other solid pod!
:black_square_button:, ACP does not care about storage of data.

### As a pod owner, I want to insert a picture with `ex:contains ex:child1` that is **accessible by my children** (`ex:child1` and `ex:child2`), so we can all look back at old times.
:white_check_mark:, ACP allows you to add a matcher that matches any resource having the predicate-object `ex:contains ex:child1`.
That matcher would than allow access to both `ex:child1` and `ex:child2`.
If this behavior is not always desired, we could add a predicate to the matcher that specifies the case when it is.

### As a pod owner, I want to insert a picture that is **accessible by anyone that can prove** to be working at a certain company, so that they have something to talk about at the coffee machine.
:white_check_mark:, ACP allows you to ask for a certain Verifiable Credential.

### As a medical professional, I want to **insert a picture in someone else's pod** abiding by the access control preferences they have, so they own their medical picture and other professionals they contact can access it.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to have an **opinionated view** over my data, so I can easily access it and feel in control.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to create blog posts that **anyone can access**, so I get cloud.
:white_check_mark:, ACP allows you to say something is accessible by anyone.


### As a pod owner, I want to create **private notes**, so I can order my private thoughts before I launch them into the world.
:white_check_mark:, ACP allows you to say something is inaccessible by anyone.


### As a pod owner, I want to **reorganize the way I view** my data without breaking references made by other people, so I can view my data from different angles, but not disturb the cloud I made.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **transfer a token** to a pod I have **full access** to; the transfer should confirm to **ACID**, so that there is always one person holding the token, and everyone can see who has it.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to upload **new kinds of data** (e.g. smartwatch), so I can always stay up to date with the latest technology.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to transfer a token to a pod I have **no access** to; the transfer should confirm to **ACID**, so that there is always one person holding the token, and everyone can see who has it.
:black_square_button:, ACP does not care about storage of data.


### As a smartwatch, I want to **upload time series data** to the solid pod, so the user can view their activities
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to have **control over how much data I keep** from my smartwatch and when to aggregate, so my pod's memory is not entirely consumed by a single aspect of my life.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **insert an additional** property to an existing resource, so it becomes more self-descriptive.
:black_square_button:, ACP does not care about storage of data.
It could, however, interfere with the ACP matchers, it might be worth pointing out what matchers would be affected? 


### As a pod owner, I want to **modify a property** of an existing resource, so I can fix my mistakes.
:black_square_button:, ACP does not care about storage of data.
It could, however, interfere with the ACP matchers, it might be worth pointing out what matchers would be affected?

### As a pod owner, I want to **delete a property** of an existing resource, so I can fix my mistakes.
:black_square_button:, ACP does not care about storage of data.
It could, however, interfere with the ACP matchers, it might be worth pointing out what matchers would be affected?

### As a pod owner, I want to **remove an entire resource**, so I can clear space. Does she want some kind of protection to not accidentally delete his medical pictures?
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **modify a resource** in a way that alters the location of that resource in my current view, so I don't need to be cautious when modifying resources.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **insert an additional** property to an existing resource in **someone else's pod**, so it becomes more self-descriptive.
:black_square_button:, ACP does not care about storage of data.
What might be interesting to point out is that the user loses control over the access control of that resource.
This can be interesting when a user expects a certain resource to be private, but turns out to be public.
This case should not matter since it is easily solvable by carefully considering what you keep in your own pod.

### As a pod owner, I want to **modify a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **delete a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **modify a resource** in **someone else's pod**, in a way that alters the location of that resource in a view present, so I don't need to be cautious when modifying resources.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **remove** a resource in **someone else's pod**, so I don't see it anymore.
:black_square_button:, ACP does not care about storage of data.


### As a pod owner, I want to **remove** a resource in **someone else's pod**, so no one can see it. I might want to send a suggestion.
:black_square_button:, ACP does not care about storage of data.

---

## Conclusion
We now evaluate what functional requirements are met using:
* :white_check_mark: when the requirement is met
* :x: when the requirement is not met
* :black_square_button: when the requirement is not in the scope of this spec

1. Data should remain consistent with the requirements posed by the **technology** (e.g., solid):
   :white_check_mark:, unless you remove your own access to a resource.
2. The data should have **easy access control**: :white_check_mark:
3. References should remain **consistent/cool**: :black_square_button:
4. The **owner is in control** of the data: :black_square_button:
5. Data in a data storage should be **discoverable**: :black_square_button:
6. Allow **profiles or strategies**: :black_square_button:
7. Storage ACL should consider **privacy**: :white_check_mark:
   resource binds access control, or the server checks the private matchers.
   This spec on its own allows privacy. 
8. Good old **ACID**: :black_square_button:
9. Storage should avoid **data dependence**: :black_square_button:

