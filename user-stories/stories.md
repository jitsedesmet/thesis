Question to ask people regarding expectations on:
* If you had taken a picture and would ask your smart device to place it somewhere on your computer, what would you expect?

# Functional requirements
We construct the following requirements:
1. Data should remain consistent with the requirements posed by the **technology** (e.g., solid).
   An update should not be able to break your data storage or at least give you a warning before doing so.
2. The data should have **easy access control**.
   SOLID currently provides this functionality using a combination of LDP and WAC.
   If a technology decides not to use a directory structure, the notion of 'location to save to' does not exist.
   Instead, we use 'permissions to save with.'
   In principle, access control is a function over the document and the user requesting access.
   Complex statements could be made: "all my descents can read this data."
3. References should remain consistent/ [**cool**](https://www.w3.org/Provider/Style/URI).\
   Careful considerations should be made when, for example, moving data, you, or someone else, might still reference it.
4. The **owner is in control** of the data.\
   Strategies should allow users to opinionate their data storage.
   For example, if a user wants to store pictures by date, this decision should be respected.
5. Data in a data storage should be **discoverable**:
   When inserting data, there should be a way to discover this data, 
   preferably without scanning through the whole dataset.
   For example, as of the time of writing, solid uses the type index and LDP. 
6. Allow **profiles or strategies**:\
   Some users are not opinionated about where their data is stored and don't want to be bothered explaining a hierarchy.
   This preference can differ regarding the data.
   A photographer might have strong opinions on where to store a picture, but relies on defaults for their medical data.  
   Different profiles might be:
   * Good defaults:
     * Shape-based? What if a shape is not known? Create it? request it?
     * Type based?
     * Value based?
   * Request using notifications and a temporary storage mechanism.
   * Don't allow
7. Storage ACL should consider **privacy**.\
   Even knowing a resource exists, whether you can access it or not, can be a privacy concern.
8. Good old **ACID**
   1. Atomicity
   2. Consistency
   3. Isolation
   4. Durability
9. Storage should avoid **data dependence**
   If developers are to create interoperable applications using solid, we should make sure that this can be done easily. 
   1. Ordering dependence: Applications should not rely on the order of subjects in a file.
   2. Indexing dependence: Applications should not rely on a certain index to be present, user patterns change, and so do indexes.
   3. Access path dependence: Applications should not rely on taking a certain path to discover data.
      An application should never browse files itself.

   These data independence requirements are what caused Codd to invent relational databases, and caused the creation of SQL.
   A query abstraction layer might help to relieve developers from this complexity.
   An example query engine currently developed for solid is
   [comunica-solid](https://comunica.dev/docs/query/advanced/solid/).
   Users can just write declarative sparql queries, and the query engine takes care of the rest.

   

When just inserting, where to insert?
When updating, where to update if variables/ subjects span multiple documents?

* Determine the scope given the type you have? `Medical pictures` vs `personal pictures`.\
  -> Virtual container? -> GroupedBy

# User stories
We will use a single, slightly complex example of a fictional person that has different, complex ways of handling data.

## Context

Let's consider the story of a photographer named Florence and her husband Wally.
Because of her profession, Florence wants fine-grained control over the pictures she took.
For each photo shoot, she wants to share some pictures with the clients of that photo shoot, but likes to keep bad pictures hidden.
When clients of a photo shoot pay enough, Florance is willing to transfer the owner rights of the pictures from that photo shoot to these clients.
Pictures containing her children are always accessible to her husband and children.
Pictures of company events are accessible by everyone currently employed by that company.
Pictures that are hers, but are not taken by her (e.g. medical pictures) are not of interest to her.
As a photographer, she creates blogposts that are for the world to see.
To create those blogposts, she sketches a lot in her notepad, this is obviously private.
Florence likes to reorganize her pictures from time to time in a quest to find the ideal organization structure for her.
When she reorganizes, clients should stay unaffected, meaning they should still find the pictures they paid for.

Florence and Wally like to play [Calico](https://www.flatout.games/#/calico/),
a family-friendly board game where the winner gets to keep the "Quilt master" token.
They like to brag around about who has this token to friends and family.
When a game is played, the token is to be passed around in a way that conforms to ACID.   

One day, Florence and her friends decided to start running. 
She buys a smartwatch to track her running performance. 
The smartwatch produces data unlike the storage space has ever seen, it should still handle the data according to the functional requirements.
The friend group organizes a monthly competition which they call "runner of the month."
The winner of last month gets to keep a token, which they pass around based on who wins the competition.
Notice that apposed to with her husband, the friends do not share update rights on their storage space.

## Extracted stories (As an X, I want Y, so that Z, …)


1. As a pod owner, I want to insert a picture that is **accessible by other pod** owners designed by me,
   so these people can access the pictures I took for them. 
2. As a pod owner, I want to insert a picture that **no one else can see**, so that I can keep backups, but hide bad results.
3. As a pod owner, I want to **transfer** pictures I have to someone else, so they now own that picture.\
   Note that I do not have write permissions in the other solid pod!
4. As a pod owner, I want to insert a picture with `ex:contains ex:child1` that is **accessible by my children** (`ex:child1` and `ex:child2`),
   so we can all look back at old times.
5. As a pod owner, I want to insert a picture that is **accessible by anyone that can prove** to be working at a certain company,
   so that they have something to talk about at the coffee machine.
6. As a medical professional, I want to **insert a picture in someone else's pod** abiding by the access control preferences they have,
   so they own their medical picture and other professionals they contact can access it.
7. As a pod owner, I want to have an **opinionated view** over my data, so I can easily access it and feel in control.
8. As a pod owner, I want to create blog posts that **anyone can access**, so I get cloud.
9. As a pod owner, I want to create **private notes**, so I can order my private thoughts before I launch them into the world.
10. As a pod owner, I want to **reorganize the way I view** my data without breaking references made by other people,
    so I can view my data from different angles, but not disturb the cloud I made.
11. As a pod owner, I want to **transfer a token** to a pod I have **full access** to; the transfer should confirm to **ACID**,
    so that there is always one person holding the token, and everyone can see who has it.
12. As a pod owner, I want to upload **new kinds of data** (e.g. smartwatch),
    so I can always stay up to date with the latest technology.  
13. As a pod owner, I want to transfer a token to a pod I have **no access** to; the transfer should confirm to **ACID**,
    so that there is always one person holding the token, and everyone can see who has it.
14. As a smartwatch, I want to **upload time series data** to the solid pod, so the user can view their activities
15. As a pod owner, I want to have **control over how much data I keep** from my smartwatch and when to aggregate,
    so my pod's memory is not entirely consumed by a single aspect of my life.
16. As a pod owner, I want to **insert an additional** property to an existing resource, so it becomes more self-descriptive.
17. As a pod owner, I want to **modify a property** of an existing resource, so I can fix my mistakes.
18. As a pod owner, I want to **delete a property** of an existing resource, so I can fix my mistakes.
19. As a pod owner, I want to **remove an entire resource**, so I can clear space.\
    Does she want some kind of protection to not accidentally delete his medical pictures?
20. As a pod owner, I want to **modify a resource** in a way that alters the location of that resource in my current view,
    so I don't need to be cautious when modifying resources.
21. As a pod owner, I want to **insert an additional** property to an existing resource in **someone else's pod**,
    so it becomes more self-descriptive.  
    For example, I transferred a picture and forgot to add a description.
22. As a pod owner, I want to **modify a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.
23. As a pod owner, I want to **delete a property** of an existing resource in **someone else's pod**, so I can fix my mistakes.
24. As a pod owner, I want to **modify a resource** in **someone else's pod**,
    in a way that alters the location of that resource in a view present,
    so I don't need to be cautious when modifying resources.
25. As a pod owner, I want to **remove** a resource in **someone else's pod**, so I don't see it anymore.
26. As a pod owner, I want to **remove** a resource in **someone else's pod**, so no one can see it.\
    I might want to send a suggestion.

User stories can be constructed where instead of inserting in my own pod, I insert in a pod I have full access to, 
but no new cases will come out of it.
A pod owner in these scenarios is either the person/ company, or an application working for them.
