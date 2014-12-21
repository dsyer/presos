---
title: Security for Microservices with Spring
layout: pivotal
---
# Security for Microservices with Spring

Dave Syer, 2014  
Twitter: @david_syer  
Email: dsyer@pivotal.io

(Security for Microservices with Spring)

## Agenda
* What is a Microservice?
* How would it be secure?
* If I was going to use Spring how would that look?
* What's the easiest way to get something working?

## Introduction
* There is a [strong trend][indeed] in distributed systems with
lightweight architectures
* People have started to call them "microservices"

![job-trends](images/jobgraph_REST_SOAP_2014.png)

* So what are people doing about security in such systems?

[SECOAUTH]: http://github.com/springsource/spring-security-oauth
[UAA]: http://github.com/cloudfoundry/uaa
[indeed]: http://www.indeed.com/jobtrends?q=JSON+REST%2CSOAP+XML&l=&relative=1#shareCode
[cf]: http://www.cloudfoundry.com
[oauth2wiki]: http://en.wikipedia.org/wiki/OAuth#OAuth_2.0
[intro-uaa-blog]: http://blog.cloudfoundry.com/2012/07/10/intro-uaa/

## What Are the Security Requirements

> Stop bad guys from accessing your resources

Identity and permissions:

* How is identity and permission information conveyed to a service?
* How is it decoded and interpreted?
* What data are needed to make the access decision (user accounts,
  roles, ACLs etc.)?
* How is the data managed: who is responsible for storing and
  retrieving it?
* How can you verify that the request hasn't been tampered with?

## HTTP Basic Authentication

* Something of a lowest common denominator
* Supported on practically all servers natively and out of the box
* Ubiquitous support on the client side in all languages
* Good support in Spring Security
* Spring Boot autoconfigures it out of the box

Example:

        $ curl "https://$username:$password@myhost/resource"

## Simple Service

```groovy
@Grab('spring-boot-starter-security')
@RestController
class Application {

   @RequestMapping("/")
   def home() {
      [status: 'OK']
   }

}
```

## So what's wrong with that?

* Nothing, but...
* Where do you get the credentials (the username and password)?
* Fine for systems where all participants can share secrets securely
* In practice that means small systems
* Only supports username/password
* Only covers authentication
* No distinction between users and machines

## Certificate Based Security

* Set up SSL on server so that request has to contain certificate
* Spring Security (X.509) can turn that into an `Authentication`
* If SSL is in the service layer (i.e. not at the router/loadbalancer)
  then you have a keystore anyway
  
Example:

```
$ curl -k --cert rod.pem:password https://localhost:8443/hello
```

<br/>
[https://github.com/SpringOne2GX-2014/microservice-security/tree/master/certs](https://github.com/SpringOne2GX-2014/microservice-security/tree/master/certs)
  
## So what's wrong with that?

* Nothing, but...
* There's no user identity (only at most the machine) unless browsers
  have certificates installed
* Requires keystores and certificates in all applications and services
  (significantly non-trivial if done properly, but some organizations
  require it anyway)
* No fine distinction between users and machines
  
## Custom Authentication Token

* Random identifier per authentication
* Grant them from a central service and/or store in a central database
* Can be exposed directly via developer UI
* Re-hydrate authentication in service
* Spring Security `AbstractPreAuthenticatedProcessingFilter` and friends
* Even easier: Spring Session identifier
* Github example: token is temporary password in HTTP Basic

[https://github.com/SpringOne2GX-2014/microservice-security/tree/master/pairs/spring-session](https://github.com/SpringOne2GX-2014/microservice-security/tree/master/pairs/spring-session)

## So what's wrong with that?

* Nothing, but...
* No separation of client app from user authentication
* Coarse grained authorization (all tokens activate all resources)
* It's not a "standard" (but there are ready made implementations)
* For user authentication, need to collect user credentials in app

## OAuth2 Key Features

* IETF standard
* Extremely simple for clients (and developers)
* Access tokens carry information (beyond identity)
* Clear separation between users and machines
* Strong emphasis on not collecting user credentials in client app
* Machines act on their own or on behalf of users
* Resources are free to interpret token content

## So what's wrong with that?

* Nothing, but...
* No standard (yet) for request signing

## OAuth2 and the Microservice

Example command line Client:

    $ curl -H "Authorization: Bearer $TOKEN" https://myhost/resource

* `https://myhost` is a Resource Server
* `TOKEN` is a Bearer Token
* it came from an Authorization Server

## Simple Resource Server

```groovy
@EnableResourceServer
class ResourceServer {
	@Bean
	JwtTokenStore tokenStore() throws Exception {
		JwtAccessTokenConverter enhancer = 
            new JwtAccessTokenConverter()
		enhancer.afterPropertiesSet()
		new JwtTokenStore(enhancer)
	}
}
```

> N.B. in a real system you would have to configure the verifierKey
> (or use JdbcTokenStore)

## Simple Authorization Server

```groovy
@EnableAuthorizationServer
class AuthorizationServer extends AuthorizationServerConfigurerAdapter {

   @Override
   void configure(ClientDetailsServiceConfigurer clients) throws Exception {
      clients.inMemory()
         .withClient("my-client-with-secret")...
   }

}
```

## Example token contents

* Client id
* Resource id (audience)
* Issuer
* User id
* Role assignments

## JWT Bearer Tokens

* OAuth 2.0 tokens are opaque to clients
* But they carry important information to Resource Servers
* Example of implementation (from Cloud Foundry UAA, JWT = signed,
  base64-encoded, JSON):

        {  "client_id":"cf",
           "exp":1346325625,
           "scope":["cloud_controller.read","openid","password.write"],
           "aud":["openid","cloud_controller","password"],
           "iss": "https://login.run.pivotal.io",
           "user_name":"tester@vmware.com",
           "user_id":"52147673-9d60-4674-a6d9-225b94d7a64e",
           "email":"tester@vmware.com",
           "jti":"f724ae9a-7c6f-41f2-9c4a-526cea84e614" }
           
## OAuth2 and the Microservice

* Resource Servers might be microservices
* Web app clients: authorization code grant
* Browser clients (single page app): authorization code grant (better) or implicit grant
* Mobile and non-browser clients: password grant (maybe with mods for multifactor etc.)
* Service clients (intra-system): client credentials or relay user token

## Spring Cloud Security

> A further level of abstraction to make common microservice security
> use cases really easy to implement

* Convention over configuration
* UX for deployment on Cloud Foundry very smooth

## Simple SSO Client

```groovy
@EnableOAuth2Sso
@Controller
class Demo {
}
```

```
$ spring jar app.jar app.groovy
$ cf push -p app.jar
```

(That's it.)

## How Does that Work?

Answer: configuration conventions. The app was bound to a service

```
$ cf bind-service app sso
```

and the service provides credentials.

To create the same bindings manually (e.g. in `application.yml`):

```yaml
oauth2:
  client:
    tokenUri: https://login.run.pivotal.io/oauth/token
    authorizationUri: https://login.run.pivotal.io/oauth/authorize
    clientId: acme
    clientSecret: ${CLIENT_SECRET}
  resource:
    tokenInfoUri: http://uaa.run.pivotal.io/check_token
    id: openid
    serviceId: ${PREFIX:}resource
```

## Resource Server with Spring Cloud

```groovy
@EnableOAuth2Resource
@EnableEurekaClient
@RestController
class Demo {
  @RequestMapping("/")
  def home() { [id: UUID.randomUUID().toString(), content: "Hello Remote"] }
}
```

How does it work? Same as `@EnableOAuth2Sso` (bind to service
providing credentials for conventional external configuration).

## Single Page Apps

With backend services CORS restrictions make reverse proxy useful (`@EnableZuulProxy`).
Then you can acquire tokens in the client app and relay them to back end.

With no backend services, don't be shy, **use the session** (authorization code flow is vastly
superior).

[Spring Session](https://github.com/spring-projects/spring-session) helps a lot too.

## Relaying User Tokens

> Front end app sends SSO token with user credentials to authenticate
> back end requests, back ends just relay it to each other as
> necessary.

Simple but possibly flawed: the front end only needs access to user
details to authenticate, but you need to give it permission to do
other things to allow it access to the back ends.

Idea: exchange (with full authentication) the incoming token for an
outgoing one with different permissions (client but not scope). Can
use password grant (e.g. with the incoming token as a password).

## Token Relay with Spring Cloud

```groovy
@EnableOAuth2Sso
@EnableZuulProxy
@Controller
class Demo {
}
```

* Autoconfiguration for `@EnableZuulProxy` combined with `@EnableOAuth2Sso`
* Adds `ZuulFilter` that attaches the current user token to downstream requests

## Other Options

* OAuth 1.0
* SAML assertions
* Physical network security IP tables etc.
* Kerberos
* Combinations of the above (including OAuth 2.0)

## In Conclusion

* Lightweight services demand lightweight infrastructure
* Security is important, but should be unobtrusive
* Spring Security and Spring Cloud make it all easier
* Special mention for Spring Session
* OAuth 2.0 is a standard, and has a lot of useful features
* [Spring Security OAuth][SECOAUTH] aims to be a complete OAuth2
  solution at the framework level
* Cloudfoundry has an open source, OAuth2 identity service (UAA)

[SECOAUTH]: http://github.com/springsource/spring-security-oauth

## Links

* [https://github.com/spring-projects/spring-security-oauth](https://github.com/spring-projects/spring-security-oauth)
* [https://github.com/spring-projects/spring-security-oauth/tree/master/tests/annotation](https://github.com/spring-projects/spring-security-oauth/tree/master/tests/annotation)
* [https://github.com/spring-cloud/spring-cloud-security](https://github.com/spring-cloud/spring-cloud-security)
* [http://github.com/spring-cloud-samples/scripts](https://github.com/spring-cloud-samples/scripts)
* [https://github.com/SpringOne2GX-2014/microservice-security](https://github.com/SpringOne2GX-2014/microservice-security)
* [https://github.com/cloudfoundry/uaa](https://github.com/cloudfoundry/uaa)
* [http://blog.spring.io](http://blog.spring.io)
* [http://blog.cloudfoundry.org](http://blog.cloudfoundry.org)
* [http://presos.dsyer.com/decks/microservice-security.html](http://presos.dsyer.com/decks/microservice-security.html)
* Twitter: @david_syer  
* Email: dsyer@pivotal.io
