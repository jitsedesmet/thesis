Question to ask people regarding expectations on:
* If you had taken a picture and would ask your smart device to place it somewhere on your computer, what would you expect?

# User story collection 1: update data I own

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


## Context

## Stories

### Insert data

### Delete data

### Non-significant update of subject

### Significant update of data

### Update shape (shape widening)

### Update data


### interact with LDP (containers)

### Interact with shape trees

# User story collection 2: update data I do not own, but can update


# User story collection 3: Update data I can not update

