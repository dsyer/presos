---
title: Security for Browser Applications with Spring
layout: spring
---
# Security for Browser Applications with Spring

Dave Syer, 2012  
Twitter: @david_syer  
Email: dsyer@pivotal.io

(Security for Browser Applications with Spring)

## Outline

Imagine several physical implementations of the same system with an
identical Javascript client (single page application) and a secure
back end. Application and security architecture variations:

| Application | Security |
| -------------- | ------------ |
| Single backend with local user login and backend service Standard | JSESSIONID cookie for all authentications after login, optional use of Spring Session to distribute data and/or change cookie name|
| Backend split between UI (with login) and services in separate JVM, client calls services directly | JSESSIONID used for UI as cookie and for backends as custom token|
| Backend split between UI (with login) and services in separate JVM, client calls services through UI acting as proxy| JSESSIONID cookie used for all calls (proxy forwards cookie header), distributed via Spring Session|
| Add OAuth2 SSO with a separate authentication server | JSESSIONID used for UI as cookie and access token for backends|
| Use JWT for OAuth2 token | Show that sessions are still needed for CSRF protection |

[SECOAUTH]: http://github.com/springsource/spring-security-oauth

## Links

* http://github.com/spring-projects/spring-security-oauth[http://github.com/spring-projects/spring-security-oauth]
* http://github.com/spring-projects/spring-security-oauth/tree/master/tests/annotation[http://github.com/spring-projects/spring-security-oauth/tree/master/tests/annotation]
* http://blog.spring.io[http://blog.spring.io]
* http://presos.dsyer.com/decks/microservice-security.html[http://presos.dsyer.com/decks/microservice-security.html]
* Twitter: @david_syer  
* Email: dsyer@pivotal.io
