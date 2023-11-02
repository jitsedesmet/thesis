# [Access Control Policy](https://solidproject.org/TR/acp)

* Also explained by Inrupt: https://docs.inrupt.com/developer-tools/javascript/client-libraries/tutorial/manage-acp/
* Seems to be the big brother of WAC.
* Policies are themselves LD (Idea: maybe it can be cached).
* Has Verifiable Credentials Matcher statements

the problem is: not all servers support it.

Question is: Can ACL decide what verifiable credential it requests based on the content of a thing
ANSWER: YES: for each picture we need a matcher that matches all users in it.
 This might seem inefficient since we would need a lot of matchers.
It does, however, create the opportunity for matchers to be shared,
these shared matchers are not content dependent,
and therefore need only to be evaluated once,
and you can have a list of accessible resources.
The matchers also allow specifying the resources, so you would say:
Bob and Freya can read when they are proven to be them by an issuer,
and this rule counts for all pictures containing them.

// TODO: might be wrong
```turtle
@prefix ex: <http://example.org/> .
@prefix acp: <http://www.w3.org/ns/solid/acp#> .
@prefix acl: <http://www.w3.org/ns/auth/acl#> .

ex:policy1
    acp:allow acl:Read ;
    acp:agent ex:Boby, ex:Freya ;
    acp:issuer ex:IdentityProviderB ;
    acp:anyOf [
       ex:contains ex:Boby, ex:Freya ;
    ] .
```
