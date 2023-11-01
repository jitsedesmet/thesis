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
   Strategies should allow users to opinionated their data storage.
   For example, if a user wants to store pictures by date, this decision should be respected.
5. Data in a data storage should be **discoverable**:
   When inserting data, there should be a way to discover this data, 
   preferably without scanning through the whole dataset.
   As of the time of writing solid uses, for example, the type index and LDP. 
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

When just inserting, where to insert?
When updating, where to update if variables/ subjects span multiple documents?

* Determine the scope given the type you have? `Medical pictures` vs `personal pictures`.\
  -> Virtual container? -> GroupedBy

# User stories
We will use a single, slightly complex example of a fictional person that has different, complex ways of handling data.

## Context

Let's consider the story of a photographer named Florence and her husband Wally.
Because of her profession, she wants fine-grained control over pictures she took.
For each photo shoot, she wants to share some pictures with the paying party, but likes to keep the bad ones hidden.
Pictures containing her children are always accessible to her wife and children.
Pictures of company events are accessible by everyone currently employed by that company.
Pictures that are hers, but are not taken by her (e.g. medical pictures) are not of interest to her.
As a photographer, she creates blogposts that are for the world to see.
To create those blogposts, she sketches a lot in her notepad, this is obviously private.

One day she buys a smartwatch, this produces data unlike any the pod has ever seen.

Clients refer to his pictures. When she moves things, it shouldn't break.

Florence and Wally like to play [Calico](https://www.flatout.games/#/calico/),
a friendly board game where the winner gets to keep the "Quilt master" token.
They like to brag around who has this token to friends and family.
When a game is played, the token is to be passed around in a way that conforms to ACID.   

// TODO: maybe this is not the best? Should I remove it? 
With her friends, Florence organizes a monthly competition, "runner of the month."
They pass this token around based on who wins the competition.
Notice that apposed to with her husband, the friends do not share some kind of update rights on their solid pod.


## User story collection 1: update data I own

### Insert data
As mentioned in the context, Florence wants to insert different kinds of data.

1. Pictures of her clients (paying party can access)
2. Pictures of her kids (kids and husband can access (specific users, depending on the content of the picture))
3. Pictures of company event (users that can prove to be affiliated with the company can access)
4. Medical pictures (her doctor can access, and Florence does not care how they are stored)
5. Blogposts (public)
6. Notes (private)
7. Smartwatch data
   (never seen by the pod.
   Maybe a good default is needed, maybe a notification, or an explicit location needs to be defined)

### Delete data

Florence can delete whatever she wants.
But for each technology, the question is: How does she do it?
Does she want some kind of protection to not accidentally delete his medical pictures? 

### Non-significant update of subject

This category means Florence wants to edit a simple predicate in her data.
For example, the label of a picture. 

### Significant update of data

Technology dependent:
look for an update that would change where a resource is virtually located/ how it is indexed.
For example, Florence decides she wants to convert a note to a blogpost.


## User story collection 2: update data I do not own, but can update directly

### Insert data

Florence helps copy the pictures from her husband's phone to his solid pod, she has permission to add pictures.
Her husband's solid pod can either be opinionated or not.

### Delete data

Florence deletes a picture owned by her husband. (Assume she has authority to do so)

### Non-significant update of subject

Florence changes the label of her husband's pictures.

### Significant update of data

Florence edits her husband's pictures in a way that the picture needs to change indexed location.

### Pass the quilt master badge

Florence manages the passing around of "quilt master" badge.
She can take or give the badge; it should, however, abide to the rules of ACID.

# User story collection 3: Update data I cannot update directly

### Insert data

If a client pays enough,
Florence is willing to change ownership of the pictures and wants to insert pictures in a company's pod.

### Delete data

Florence is not allowed to remove someone else's data.
She can either request the removal, or use something like subweb spec to change her view on the data.
(Maybe she does want to change her view over this data. Not to see it presented anymore? (Subweb?))

### Non-significant update of subject

Florence notices a typo in the label of a picture she gave to a company. 

### Significant update of data

Florence wants to change a picture she sold to a company, but this would change the indexed location of that picture.  

### Pass the runner of the month token

When Florence has the token, she needs to pass it one to the new "runner of the month."
Again abiding to the rules of ACID.
 
