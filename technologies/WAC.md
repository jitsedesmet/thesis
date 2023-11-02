# [WAC](https://solidproject.org/TR/wac)

You use Linked Data's [acl ontology](http://www.w3.org/ns/auth/acl#).

You have the following modes:

* acl:Read:\
  Allows access to a class of read operations on a resource, e.g., to view the contents of a resource on HTTP GET requests.
* acl:Write \
  Allows access to a class of write operations on a resource, e.g., to create, delete or modify resources on HTTP PUT, POST, PATCH, DELETE requests.
* acl:Append:\
  Allows access to a class of append operations on a resource, e.g., to add information, but not remove, information on HTTP POST, PATCH requests.
* acl:Control:\
  Allows access to a class of read and write operations on an ACL resource associated with a resource. 

Could use `acl:accessToClass` to allow access on a badge of resources.
Could use [Access Mode Extensions](https://solidproject.org/TR/wac#extension-acl-mode)
to allow for example reading, then let the server execute a random function to than retract reading access,
but that's just far-fetched.

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
