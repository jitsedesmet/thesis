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

Let's consider the story of a photographer named Arthur and his wife Billie.
Because of his profession, he wants fine-grained control over pictures he took.
For each photo shoot, he wants to share some pictures with the paying party, but likes to keep the bad ones hidden.
Pictures containing his children are always accessible to his wife and children.
Pictures of company events are accessible by everyone currently employed by that company.
Pictures that are his, but are not taken by him (e.g. medical pictures) are not of interest to him.
As a photographer, he creates blogposts that are for the world to see.
To create those blogposts, he sketches a lot in his notepad, this is obviously private.

One day he buys a smartwatch, this produces data unlike any the pod has ever seen.

Clients refer to his pictures. When he moves things, it shouldn't break.

Arthur and Billie like to play [Calico](https://www.flatout.games/#/calico/),
a friendly board game where the winner gets to keep the "Quilt master" token.
They like to brag around who has this token to friends and family.
When a game is played, the token is to be passed around in a way that conforms to ACID.   

// TODO: maybe this is not the best? Should I remove it? 
With his friends, Arthur organizes a monthly competition, "best runner of the month."
They pass this token around based on who wins the competition.
Notice that apposed to with his wife, the friend do not share some kind of update rights on their solid pod.


## User story collection 1: update data I own

### Insert data
As mentioned in the context, Arthur wants to insert different kinds of data.

1. Pictures of his clients (paying party can access)
2. Pictures of his kids (kids and wife can access (specific users, depending on the content of the picture))
3. Pictures of company event (users that can prove to be affiliated with the company can access)
4. Medical pictures (his doctor can access, and Arthur does not care how they are stored)
5. Blogposts (public)
6. Notes (private)
7. Smartwatch data
   (never seen by the pod.
   Maybe a good default is needed, maybe a notification, or an explicit location needs to be defined)

### Delete data

Arthur can delete whatever he wants.
But for each technology, the question is: How does he do it?
Does he want some kind of protection to not accidentally delete his medical pictures? 

### Non-significant update of subject

This category means Arthur wants to edit a simple predicate in his data.
For example, the label of a picture. 

### Significant update of data

Technology dependent:
look for an update that would change where a resource is virtually located/ how it is indexed.
For example, Arthur decides he wants to convert a note to a blogpost.


## User story collection 2: update data I do not own, but can update directly

### Insert data

Arthur helps copy the pictures from his wife's phone to her solid pod, he has permission to add pictures.
His wife's solid pod can either be opinionated or not.

### Delete data

Arthur deletes a picture owned by his wife. (Assume he has authority to do so)

### Non-significant update of subject

Arthur changes the label of his wife's pictures.

### Significant update of data

Arthur edits his wife's pictures in a way that the picture needs to change indexed location.

### Pass the quilt master badge

Arthur manages the passing around of "quilt master" badge.
He can take or give the badge; it should, however, abide to the rules of ACID.

# User story collection 3: Update data I cannot update directly

### Insert data

If a client pays enough,
Arthur is willing to change ownership of the pictures and wants to insert pictures in a company's pod.

### Delete data

Arthur is not allowed to remove someone else's data.

He can either request the removal, or use something like subweb spec to change his view on the data.

(Maybe he does want to change his view over this data. Not to see it presented anymore? (Subweb?))

### Non-significant update of subject

Arthur notices a typo in the label of a picture he gave to a company. 

### Significant update of data

Arthur wants to change a picture he sold to a company, but this would change the indexed location of that picture.  

### Pass the runner of the month token

When Arthur has the token, he needs to pass it one to the new "runner of the month."
Again abiding to the rules of ACID.
 
