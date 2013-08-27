---
title: Data Modelling for OAuth2
layout: springone13
---
# Data Modelling for OAuth2

Dave Syer, 2013  
Twitter: @david_syer  
Email: dsyer@gopivotal.com

## 

![Spring IO](images/springio.png)

## Agenda
* Quick overview of [OAuth2][oauth2wiki]?
* Data Modelling for OAuth2
* Spring OAuth
* Cloud Foundry [UAA]
[oauth2wiki]: http://en.wikipedia.org/wiki/OAuth#OAuth_2.0
[UAA]: http://github.com/cloudfoundry/uaa

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
[cfuaa]: http://uaa.run.pivotal.io

## OAuth2 Key Features

* Extremely simple for clients
* Access tokens carry information (beyond identity)
* Resource Servers are free to interpret tokens

* Example token contents:
    * Client id
    * Resource id (audience)
    * User id
    * Role assignments

## Obtaining a Client Token

A client can act its own behalf (`client_credentials` grant):

![auth-code-flow](images/client-credentials-flow.png)

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

## OAuth2 Bearer Tokens

Bearer tokens are authentication tokens for client applications. Once
you have one you can act on behalf of a user, accessing resources:

```
$ curl -H "Authorization: Bearer <token>" resource.server.com/stuff
```

<br/>

The resource server treats the request as if it came from an
authenticated user.

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

1. Compute token content and grant tokens
2. Interface for users to confirm that they authorize the Client to act
on their behalf
3. Authenticate users (`/authorize`)
4. Authenticate clients (`/token`)

\#1 and \#4 are covered thoroughly by the spec; \#2 and \#3 not (for
good reasons).

## Spring Security OAuth2

> *Goal:* implement Resource Server, Authorization Server, and Client
> Application with sensible defaults and plenty of customization
> choices. Provides features for implementing both consumers and
> providers of the OAuth protocols using standard Spring and Spring
> Security programming models and configuration idioms.

* 1.0 = Nov 2012
* 1.0.5 = Aug 2013
* 1.1.0 = soon

## OAuth2 Data Modelling

* Token format
* Token contents
* Client registrations
* Computing permissions
* User approvals

## Token Format

* OAuth 2.0 tokens are opaque to clients (so might be simple keys to a backend store)
* But they carry important information to Resource Servers
* Example implementation (from Cloud Foundry UAA, JWT = signed,
  base64-encoded, JSON):

```json
{  "client_id":"vmc",
   "exp":1346325625,
   "scope":["cloud_controller.read","openid","password.write"],
   "aud":["openid","cloud_controller","password"],
   "user_name":"vcap_tester@vmware.com",
   "user_id":"52147673-9d60-4674-a6d9-225b94d7a64e",
   "email":"vcap_tester@vmware.com",
 "jti":"f724ae9a-7c6f-41f2-9c4a-526cea84e614" }
 ```
 
## Token Format Choices

Resources decode through:

1. Shared storage -> opaque
2. Remote service (e.g. `/check_token`) -> opaque
3. Resources decode locally -> encoded + signed ( + possibly encrypted)

\#2 and \#3 require key management infrastructure - resource server
and authorization server need to agree on signing (and possibly
encryption). Can be as simple as shared configuration file.

## Token Contents

* Audience
* Scope
* Expiry
* Client details
* Other...

## Token Audience

Resource Servers should check if they are the intended recipient of a
token. No specific mechanism in OAuth2 spec.

In Spring OAuth every resource optionally has a "resource ID". It is
copmared with the token in an authentication filter.

> For encoded tokens, e.g. JWT has a standard field `aud` for the
> audience of the token.

## Client Registration Data

Minimum

* Client id
* Secret
* Redirect URIs
* Authorized grant types

Desirable

* Authorities -> scope for client token
* Default scopes -> scope for user token
* Resource ids -> audience
* Owner of registration (e.g. a user)

## More on Scopes

Per the spec scopes are arbitrary strings.  The Authorization Server and
the Resource Servers agree on the content and meanings.

Examples:

* Google: `https://www.googleapis.com/auth/userinfo.profile`
* Facebook: `email`, `read_stream`, `write_stream`
* UAA: `cloud_controller.read`, `cloud_controller.write`, `scim.read`,
  `openid`
  
Authorization Server has to decide whether to grant a token to a given
client and user based on the requested scope (if any).

## Simple Example of Computed Scopes

* Client requests `scope=read,write`
* Auth server compares client `authorities=read`
* Grants token with narrower scope

> Uses Spring Security concept of "authorities" attached to a client

> Not implemented out of the box in Spring OAuth 1.0 (might be in 1.1)

## Cloud Foundry Scope Computation

_Client Token_

* If client requests no explicit scope: set to default value per client
* Restrict to intersection with default scopes (per client)


_User Token_

* If client requests no explicit scope: set to default value per client
* Restrict to intersection with default scopes (per client)
* Further restrict to intersection with user groups (same as scope names)

## Separate Data for User and Client Grants

Clients often act on their own behalf (`client_credentials` grant),
and then the available scopes might be different.  In Cloud Foundry we
find it useful to distinguish between client scopes (for user tokens)
and authorities (for client tokens).

## User Approvals

An access token represents a user approval:


## Other Token Types

...

## Links

* [http://github.com/springsource/spring-security-oauth]()
* [http://github.com/cloudfoundry/uaa]()
* [http://blog.cloudfoundry.org]()
* [http://spring.io/blog]()
* [http://dsyer.com/decks/oauth-model-s2gx.md.html]()
* Twitter: @david_syer  
* Email: dsyer@vmware.com
