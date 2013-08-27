---
title: OAuth REST
layout: spring
---
# When and Why to Use OAuth2

Dave Syer, 2012  
Twitter: @david_syer  
Email: dsyer@vmware.com

(Securing REST-ful Web Services with OAuth2)

## Agenda
* Why would I use [OAuth2][oauth2wiki]?
* If I was going to use Spring how would that look?
* What's the easiest way to get something working?
* Blog: [http://blog.cloudfoundry.org/2012/10/09/oauth-rest/]()

## Introduction
* There is a [strong trend][indeed] distributed systems with
lightweight architectures

![job-trends](images/jobgraph_REST_SOAP.png)

* So what are people doing about security in such systems?

[SECOAUTH]: http://github.com/springsource/spring-security-oauth
[UAA]: http://github.com/cloudfoundry/uaa
[indeed]: http://www.indeed.com/jobtrends?q=JSON+REST%2CSOAP+XML&l=&relative=1#shareCode
[cf]: http://www.cloudfoundry.com
[oauth2wiki]: http://en.wikipedia.org/wiki/OAuth#OAuth_2.0
[intro-uaa-blog]: http://blog.cloudfoundry.com/2012/07/10/intro-uaa/

## What is a Lightweight Service?
* HTTP transport.
* Text-based message content, usually [JSON][JSON].
* Small, compact messages, and quick responses.
* REST-ful, or at least inspired by the [REST][REST]
* Some degree of statelessness
* Interoperability.

[REST]: http://en.wikipedia.org/wiki/Representational_state_transfer
[JSON]: http://en.wikipedia.org/wiki/JSON

## What Are the Security Requirements

Identity and permissions:

* how is identity and permission information conveyed to a service?
* how is it decoded and interpreted?
* what data are needed to make the access decision (user accounts,
  roles, ACLs etc.)?
* how is the data managed: who is responsible for storing and
  retrieving it?

## HTTP Basic Authentication

* something of a lowest common denominator
* supported on practically all servers natively and out of the box
* ubiquitous support on the client side in all languages

Example:

        $ curl "https://$username:$password@myhost/resource"

## So what's wrong with that?

* Nothing, but...
* Where do you get the credentials (the username and password)?
* Fine for systems where all participants can share secrets securely
* In practice that means small systems
* Only supports username/password
* Only covers authentication

## User or Client Permissions

* Finer-grained information about the authenticated party
* Role-based access: very common, sometimes available in
  server/container
* Need to categorize user accounts, e.g. USER and ADMIN
* Often business requirements are more complex

## OAuth2

Centralizing account management and permissions:

* OAuth 2.0 adds an extra dimension - more information for the access
  decision
* Standards always help in security
* Lightweight - easy to `curl`
* Requires HTTPS for secure operation, but you can test with HTTP

## Quick Introduction to OAuth2

> A Client application, often web application, acts on behalf of a
> User, but with the User's approval

* Authorization Server
* Resource Server
* Client application

Common examples of Authorization Servers on the internet:

* [Facebook][] - Graph API
* [Google][] - Google APIs
* [Cloud Foundry][cfuaa] - Cloud Controller

[Facebook]: http://developers.facebook.com
[Google]: http://code.google.com/apis/accounts/docs/OAuth2.html
[cfuaa]: http://uaa.cloudfoundry.com

## OAuth2 and the Lightweight Service

Example command line Client:

    $ curl -H "Authorization: Bearer $TOKEN" https://myhost/resource

* `https://myhost` is a Resource Server
* `TOKEN` is a Bearer Token
* it came from an Authorization Server

## OAuth2 Key Features

* Extremely simple for clients
* Access tokens carry information (beyond identity)
* Resource Servers are free to interpret tokens

* Example token contents:
    * Client id
    * Resource id (audience)
    * User id
    * Role assignments

## UAA Bearer Tokens

* OAuth 2.0 tokens are opaque to clients
* But they carry important information to Resource Servers
* Example of implementation (from Cloud Foundry UAA, JWT = signed,
  base64-encoded, JSON):

        {  "client_id":"vmc",
           "exp":1346325625,
           "scope":["cloud_controller.read","openid","password.write"],
           "aud":["openid","cloud_controller","password"],
           "user_name":"vcap_tester@vmware.com",
           "user_id":"52147673-9d60-4674-a6d9-225b94d7a64e",
           "email":"vcap_tester@vmware.com",
           "jti":"f724ae9a-7c6f-41f2-9c4a-526cea84e614" }

## Obtaining a Client Credentials Token

A client can act in its own right (not on behalf of a user):

    $ curl "https://myclient:mysecret@uaa.cloudfoundry.com/oauth/tokens" 
        -d grant_type=client_credentials -d client_id=myclient

Result:

    {
      access_token: FUYGKRWFG.jhdfgair7fylzshjg.o98q47tgh.fljgh,
      expires_in: 43200,
      client_id: myclient,
      scope: uaa.admin
    }

## Web Application Client

The Client wants to access a Resource on behalf of the User

![oauth-web-client](images/oauth-web-client.png)

## Obtaining a User Token

A client can act on behalf of a user (e.g. `authorization_code` grant):

![auth-code-flow](images/auth-code-flow.png)

## Authorization Code Grant Summary

1. Authorization Server authenticates the User

2. Client starts the authorization flow and obtain User's approval

3. Authorization Server issues an authorization code (opaque one-time
token)

4. Client exchanges the authorization code for an access token.

## Role of Client Application

* Register with Authorization Server (get a `client_id` and maybe a
  `client_secret`)
* Do not collect user credentials
* Obtain a token (opaque) from Authorization Server
    * On its own behalf - `client_credentials`
    * On behalf of a user
* Use it to access Resource Server

## Role of Resource Server

1. Extract token from request and decode it
2. Make access control decision
    * Scope
    * Audience
    * User account information (id, roles etc.)
    * Client information (id, roles etc.)
3. Send 403 (FORBIDDEN) if token not sufficient

## Role of the Authorization Server

1. Grant tokens
2. Interface for users to confirm that they authorize the Client to act
on their behalf
3. Authenticate users (`/authorize`)
4. Authenticate clients (`/token`)

\#1 and \#4 are covered thoroughly by the spec; \#2 and \#3 not (for
good reasons).

## More on Scopes

Per the spec they are arbitrary strings.  The Authorization Server and
the Resource Servers agree on the content and meanings.

Examples:

* Google: `https://www.googleapis.com/auth/userinfo.profile`
* Facebook: `email`, `read_stream`, `write_stream`
* UAA: `cloud_controller.read`, `cloud_controller.write`, `scim.read`,
  `openid`
  
Authorization Server has to decide whether to grant a token to a given
client and user based on the requested scope (if any).

## UAA Scopes

* UAA scopes are actually Groups in the User accounts
* `GET /Groups`, `Get /Users/{id}`

        {
          "id": "73ba999e-fc34-49eb-ac26-dc8be52c1d82",
          "meta": {...},
          "userName": "marissa",
          "groups": [
           ...
           {
              "value": "23a71835-c7ce-43ac-b511-c84d3ae8e788",
              "display": "uaa.user",
              "membershipType": "DIRECT"
            }
          ],
        }

## Special Mention for Vmc

The UAA authenticates requests from `vmc` in a special way:

    $ curl https://uaa.cloudfoundry.com/oauth/authorize
        -d response_type=token -d client_id=vmc
        -d redirect_uri=https:uaa.cloudfoundry.com/redirect/vmc
        -d source=credentials
        -d username=$username -d password=$password

Result:

    302 FOUND
    ...
    Location: https://uaa.cloudfoundry.com/redirect/vmc#access_token=FUYGKRWFG.jhdfgair7fylzshjg.o98q47tgh.fljgh...  

## Authentication and the Authorization Server

* Authentication (checking user credentials) is orthogonal to
  authorization (granting tokens)
* They don't have to be handled in the same component of a large
  system
* Authentication is often deferred to existing systems (SSO)
* Authorization Server has to be able to authenticate the OAuth
  endpoints (`/authorize` and `/token`)
* It _does not_ have to collect credentials (except for
  `grant_type=password`)

## Cloud Foundry UAA Authorization Server

![cf-uaa](images/cf-uaa.png)

## Cloud Foundry UAA as a General Purpose Solution

* [User Account and Authentication Service][UAA] is part of [Cloud
  Foundry][cf]
* open source and fairly generic
* sample apps (including login server)
* wrapper for [Spring Security OAuth][SECOAUTH]
* runs in a servlet container (e.g. tomcat)
* easy for Spring developers to install and customize
* look for UAA blogs at [http://blog.cloudfoundry.org]() (and .com)

## UAA OAuth Implementation

UAA makes some explicit choices where the spec allows it, and also
adds some useful features:

* Client registration validation, e.g. implicit has no secret
* Client has separate allowed scopes for user tokens and client tokens
  (if allowed).
* User account management: groups = scopes, period-separated
* JWT tokens, signed but not encoded, includes audience
  (a.k.a. `resource_id`)
* `/userinfo` endpoint for remote authentication (SSO)
* Auto-approve for client apps that are part of platform
* Special authentication channels for `/authorize`:
    * `source=credentials` - used by vmc
    * `source=login` - used by Login Server
    * (Login Server) autologin via `code=...`

## Alternatives to OAuth2

* OAuth 1.0a
* SAML
* CAS
* Custom solution, e.g. HMAC signed requests
* Extensions to OAuth2

## In Conclusion

* Lightweight services demand lightweight infrastructure
* Security is important, but should be unobtrusive
* OAuth 2.0 is a standard, and has a lot of useful features
* [Spring Security OAuth][SECOAUTH] aims to be a complete solution at
  the framework level
* Cloud Foundry [UAA][] adds some implementation details and makes
  some concrete choices

## Links

* [http://github.com/springsource/spring-security-oauth]()
* [http://github.com/cloudfoundry/uaa]()
* [http://blog.cloudfoundry.org]()
* [http://blog.cloudfoundry.com]()
* [http://blog.springsource.org]()
* [http://dsyerstatic.cloudfoundry.com/preso/decks/oauth-rest.md.html]()
* Testing Web Applications with Spring 3.2  Register: [http://www.springsource.org/node/3800]()
* Twitter: @david_syer  
* Email: dsyer@vmware.com
