---
title: UAA Project
layout: plain
---
# Cloud Foundry UAA and Identity Management

Dave Syer, 2013  
Twitter: @david_syer  
Email: dsyer@vmware.com

## Agenda

* Why does Cloud Foundry need a [UAA][]?
* Who else needs it?
* Status and what's missing?

More Information:

* Introductory: [basic level](http://blog.cloudfoundry.org/2012/07/23/uaa-intro/) article, and one with [more detail on features](http://blog.cloudfoundry.org/2012/07/24/high-level-features-of-the-uaa/)
* Slides from [SpringOne](http://www.slideshare.net/DaveSyer/when-and-why-would-i-use-oauth2), and blog on [OAuth2 and REST](http://blog.cloudfoundry.org/2012/10/09/oauth-rest/)
* Blog: [How to Integrate your Application](http://blog.cloudfoundry.org/2012/11/05/how-to-integrate-an-application-with-cloud-foundry-using-oauth2/), with samples

[UAA]: http://github.com/cloudfoundry/uaa

## Why Does Cloud Foundry Need a UAA?

* One place where a user knows he can authenticate safely
* Authentication mechanism decided centrally (e.g. username/password
  or LDAP/AD)
* Flexible access decisions and permissions (e.g. used in dashboard,
  support apps as well as cloud controller)
* Standards-based implementation ([OAuth2][oauth2wiki], [SCIM][],
  [OpenID Connect][OIDC])

[OIDC]: http://openid.net/connect/

## Who Else Needs a UAA?

* Anyone with lightweight HTTP services and mixture of user and
  machine access
* Plays nicely in polyglot environment
* Examples
    * vFabric. Clients ask about an Identity Management solution.
    * Cloud Fabric.  Lots of things already just work so we can get
      started on prototypes with "real" demos.
    
## Status

Almost complete solution for Cloud Foundry requirements as of today
(if you include work in progress).

* open source and fairly generic standards implementation for
  [OAuth2][oauth2wiki] and [SCIM][]
* sample apps (including login server)
* runs in a standard servlet container (e.g. tomcat)
* easy for developers to install and customize

What's missing?

* Not as deeply integrated with core platform as it could be
* Single Sign Off
* Heavy emphasis on REST endpoints, so UI could be developed
* More Enterprise features...

## What's Missing: Features?

Taking UAA beyond existing Cloud Foundry requirements:

* Complete OpenID Connect implementation

* Strategies for account management. Native works fine already for
  `cloudfoundry.com`.  Others:
    - SAML integration for a project at EMC
    - Spring Security makes LDAP/AD etc. just a configuration change
    - Not tested in the wild or packaged up for ease of use

* More granular permissions and ACL-like access decisions (cloud
  controller handles this internally, but if VCAP API is to be used
  more widely it could be abstracted).

* Maybe some more high-end security features for enterprise use cases
  (e.g. encryption of tokens and protection against replay attacks).

## Appendix: Existing UAA (and Login) Features

* Delegating access to services ([OAuth2][oauth2wiki])
* Secure access for machines (e.g. admin access inside platform) and
  users (`vmc` or browser)
* Single sign on
* User account management (including groups) - [SCIM][]

[SCIM]: www.simplecloud.info/specs/draft-scim-rest-api-01.html
[oauth2wiki]: http://en.wikipedia.org/wiki/OAuth#OAuth_2.0

