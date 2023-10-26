Question to ask people regarding expectations on:
* If you had taken a picture and would ask your smart device to place it somewhere on your computer, what would you expect?

# User story collection 1: update data I own

We construct the following requirements:
1. Data should remain consistent with the requirements posed by the **technology** (e.g., solid).
   An update should not be able to break your data storage or at least give you a warning before doing so.
2. The data should be **interoperable with LDP**.\
   We think data should always be browsable with LDP, because this allows users to truly own their data and understand it.
   If data is not interoperable with LDP, a user would require knowledge of data-science/ database technology.
   Making them not own the data anymore because of a knowledge gap.
   You can see this as a sort of anti-data-obfuscation technique.
3. Data should remain **consistent**.\
   Careful considerations should be made when, for example, moving data, you, or someone else, might still reference it.
4. The user data **owner is in control**.\
   Strategies should allow user to opinionated their data storage.
   For example, if a user wants to store pictures by data, this decision should be respected.
5. Data in a data storage should be **discoverable**:
   When inserting data, there should be a way to discover this data, preferably without scanning through the whole dataset.
6. Allow **profiles**:\
   Some users are not opinionated about where their data is stored and don't want to be bothered explaining a hierarchy.
   Different profiles might be:
   * Good defaults:
     * Shape based?
     * Type based?
     * Value based?
   * Request using notifications and a temporary storage mechanism.
   * Don't allow


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

