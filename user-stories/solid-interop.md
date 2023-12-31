---
title: Solid Application Interoperability
---

[spec](https://solid.github.io/data-interoperability-panel/specification/)

Differentiate `social agents` (individual, group, or organization) and `applications` both are `agents`.
Social agents choose to use certain applications and register/ manage them and their Access in a private document.

Data is stored in data registrations, each indexed using a shape tree; resource names should be unpredictable.
The unpredictability is important for privacy.

Authorization flows:
1. Application Requests Access
2. Another social agent requests access
3. Social agent shares access -> generates Access receipt

Agents can describe their [Access needs](https://solid.github.io/data-interoperability-panel/specification/#needs).

Access authorization records that you have given grant access to an agent, these are not shared, you share an Access grant.

In the end, this spec allows applications to request/grant access to shape tree instances. 
