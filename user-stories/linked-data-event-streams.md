# Linked Data Event Streams (WIP)

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

Might be able to handle time series, in combination with the retentionPolicy?
