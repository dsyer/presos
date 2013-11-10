---
title: Spring 4.0
layout: springlarge
---
# Spring 4.0

Dave Syer, Josh Long, 2013  
Twitter: @david_syer, @starbuxman,   
Email: [dsyer, jlong]@gopivotal.com

(Introduction to Spring 4.0, originally by Oliver Gierke)

## Sample code

* [https://github.com/olivergierke/spring4-guided-tour](https://github.com/olivergierke/spring4-guided-tour)
* JDK: [https://jdk8.java.net/download.html](https://jdk8.java.net/download.html)
* Maven: [http://maven.apache.org/download.cgi](http://maven.apache.org/download.cgi)

## Where we Came From: Spring 3.x

* Annotation based component model
* Java `@Configuration`
* Composable Annotations
* SpEL
* REST @ MVC, Async
* ...

##  Where we Came From: Spring 3.x

* Declarative validation, formatting,
* caching and scheduling
* Spring MVC integration tests
* JSR-330, JSR-303
* JPA 2.0, Servlet 3.0


## Spring 4: Pruning

Removed deprecated packages and methods

## Spring 4: Spec upgrades

* JMS 2.0
* JTA 1.2
* JPA 2.1
* Bean Validation 1.1
* JSR-236 Concurrency

## Spring 4: Get groovy

* Groovy `BeanBuilder`
* `GenericGroovyApplicationContext`

## Spring 4: Conditional bean definitions

* `@Conditional`
* More generalized version of @Profile
* Spring Boot makes heavy use of that

## Spring 4

* Composable annotations
* Autowiring with Generics
* Hypermedia

## Spring 4: Messaging and WebSockets

* Messaging abstraction from SI
* JSR-356 (+SockJS, Stomp etc.)
* Highly recommended talk by Rossen Stoyanchev
  [http://bit.ly/spring4-websockets](http://bit.ly/spring4-websockets)
  
## The state of Java8

* Current OpenJDK 8 works for us
* Best IDE support: IntelliJ 12
* STS has Java 8 support preview

## Spring 4: JDK 8 Support

* Lambda expressions
* Method references
* JSR-310 DateTime
* Repeatable annotations
* Parameter name discovery

## Lambda expressions

* SAM types
* Works with previously existing callbacks
  `JdbcTemplate`, `JmsTemplate`, `TransactionTemplate` etc.

## Parameter names

* Advanced reflection support
* Parameter names on interfaces

##

<div class="demo"></div>
> Should I upgrade to Spring 4.0 already?

## Upgrade

* We strongly recommend to upgrade
* RC November, GA December
* Fully compatible with Java 6 and 7
* Spring 3.2 in maintenance mode

## Links

* [http://projects.spring.io/spring-framework](http://projects.spring.io/spring-framework) Documentation
* [https://github.com/spring-projects/spring-framework](https://github.com/spring-projects/spring-framework) Spring Framework on Github
* [http://spring.io/blog](http://spring.io/blog)
* [http://dsyer.com/presos/decks/spring4.html](http://dsyer.com/presos/decks/spring4.html)
* Twitter: `@david_syer`, `@starbuxman`
* Email: dsyer@gopivotal.com, jlong@gopivotal.com

## 

<div id="center">
<div><i class="icon-smile icon-4x"></i> Spring 4.0 - END</i></div>
</div>
