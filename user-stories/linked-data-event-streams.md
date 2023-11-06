# Linked Data Event Streams

A linked data event stream is a collection of immutable objects.
It seems like the main purposes are:
- Creating views
- Allow efficient caching due to immutability
- "Replicate the history of a dataset." I think this means creating a log over the dataset.
- Event streams allow for real time data. If data does not need to be real time, it might be an overkill (<10s).
- Using TREE, you can specify pagination, 
  and even convey that pages are sorted using a `tree:path` and `tree:GreaterThanOrEqualToRelation`.

A practical implementation can be seen in "Publishing Base Registries as Linked Data Even Streams."
In that paper, they mention that a reason for choosing Event Streams is that:
> Each base registry is obliged to have life-cycle and history management of their objects

Servers can create re-fragmentation of the same stream. One such fragmentation could be geospatial based.

# User stories
## User story collection 1: update data I own
### Insert data

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
