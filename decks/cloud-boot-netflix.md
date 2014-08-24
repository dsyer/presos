---
title: Cloud, Boot, Netflix
layout: springone14
---
# Spring Boot and Netflix OSS

Spencer Gibb   
email: sgibb@pivotal.io   

Dave Syer   
twitter: @david_syer   
email: dsyer@pivotal.io   

(Spring Boot and Netflix OSS   
or Spring Cloud Components)

## Outline
* Define Microservices
* Define distributed system problems
* Introduce Netflix OSS and how we have integrated it into Spring Boot

## What are micro-services?
* Not monolithic :-)
* Smaller units of a larger system
* Runs in its own process
* Lightweight communication protocols
* Single Responsibility Principle
* The UNIX way

[http://martinfowler.com/articles/microservices.html](http://martinfowler.com/articles/microservices.html)
[http://davidmorgantini.blogspot.com/2013/08/micro-services-what-are-micro-services.html](http://davidmorgantini.blogspot.com/2013/08/micro-services-what-are-micro-services.html)

## Problems in micro-services systems
* Distributed/versioned configuration
* Service registration and discovery
* Routing
* Service-to-service calls
* Load balancing
* Circuit Breaker
* Asynchronous
* Distributed messaging

## Spring Boot

```groovy
@RestController
class ThisWillActuallyRun {
    @RequestMapping("/")
    String home() {
        return "Hello World!"
    }
}
```

## Bootification

How to bring the ease of Spring Boot to an micro-services platform?

* Netflix OSS
* Consul
* etcd
* zookeeper
* custom
* doozerd
* ha proxy
* nginx
* Typesafe Config

and many more... What to choose?

## Netflix OSS

* Eureka
* Hystrix & Turbine
* Ribbon
* Feign
* Zuul
* Archaius

* Curator
* Asgaard
* ...


## Configuration Server
* Pluggable source
* Git implementation
* Versioned
* Rollback-able
* Configuration client auto-configured via starter

## Configuration Server
* Supports applications `<appname>.properties`
* Supports environments `<appname>-<envname>.yml`
* Default environment `application.properties` applies to all applications and environments

DEMO

## Config Client
Consumers of config server can use client library as Spring Boot plugin

Features:

* Bootstrap `Environment` from server
* POST to /env to change `Environment`
* `@RefreshScope` for atomic changes to beans via Spring lifecycle
* POST to /refresh
* POST to /restart

## Environment Endpoint
* POST to /env
* Re-binds `@ConfigurationProperties`
* Resets loggers if any logging.level changes are detected
* Sends `EnvironmentChangeEvent` with list of properties that changed

## Refresh Endpoint
* POST to /refresh
* Re-loads configuration including remote config server
* Re-binds @ConfigurationProperties
* Resets @RefreshScope cache

## RefreshScope
* Annotate @Beans
* Atomic updates during /refresh

DEMO

```groovy
@RefreshScope
@ConfigurationProperties
public class MyProps {
  @RefreshScope
  private String myProp;
  public String getMyProp(){return myProp;}
}
//later
myMethod(myProps.getMyProp())
```

## Encrypted Properties
* Authenticated clients have access to unencrypted data.
* Only encrypted data is stored in git.

DEMO

## Eureka
* Service Registration Server
* Highly Available
* In AWS terms, multi Availability Zone and Region aware

## Eureka Client
* Register service instances with Eureka Server 
* `@EnableEurekaClient` auto registers instance in server
* Eureka Server DEMO
* Eureka Client DEMO

```groovy
@Configuration
@ComponentScan
@EnableAutoConfiguration
@EnableEurekaClient
public class Application {
  public static void main(String[] args) {
    SpringApplication.run(Application.class,
       args);
	}
}
```

## Hystrix
* latency and fault tolerance
* isolates access to other services
* stops cascading failures
* enables resilience
* circuit breaker pattern
* dashboard

## Declarative Hystrix
* Programmatic access is cumbersome
* `@HystrixCommand` to the rescue
* `@EnableHystrix` via starter pom
* wires up spring aop aspect

DEMO

## Hystrix Synchronous

```groovy
@HystrixCommand
private String getDefaultMessage() {
  return "World Default";
}

@HystrixCommand(fallbackMethod="getDefaultMessage")
public String getMessage() {
  return restTemplate.getForObject(/*...*/);
}
```

## Hystrix Future

```groovy
@HystrixCommand
@HystrixCommand(fallbackMethod="getDefaultMessage")
public Future<String> getMessageFuture() {
  return new AsyncResult<String>() {
    public String invoke() {
      return restTemplate.getForObject(/*...*/);
    }
  };
}
```

## Hystrix Observable

```groovy
@HystrixCommand
@HystrixCommand(fallbackMethod="getDefaultMessage")
public Observable<String> getMessageFuture() {
  return new ObservableResult<String>() {
    public String invoke() {
      return restTemplate.getForObject(/*...*/);
    }
  };
}
```

## Turbine
* Aggregator for Hystrix data
* Pluggable locator
* static list
* Eureka

DEMO

## Ribbon
* Client side load balancer
* Pluggable transport
* http, tcp, udp
* Pluggable load balancing algorithms
* round robin, “best available”, random, response time based
* Pluggable source for server list
* static list, Eureka!

## Feign
* Declarative web service client definition
* Annotate an interface
* Highly customizable
* encoders/decoders
* annotation processors (Feign, JAX-RS)
* logging
* Supports Ribbon and therefore Eureka

## Feign cont.
* Auto-configuration
* Support for Spring MVC annotations
* Uses Spring MessageConverter’s for decoder/encoder

DEMO

## Feign cont.

```java
public interface HelloClient {
  @RequestMapping(method = RequestMethod.GET,
                  value = "/hello")
  Message hello();

  @RequestMapping(method = RequestMethod.POST,
                  value = "/hello",
                  consumes = "application/json")
  Message hello(Message message);
}
```

## Zuul
* JVM based router and filter
* Similar routing role as httpd, nginx, or CF go router
* Fully programmable rules and filters
* Groovy
* Java
* any JVM language

## Zuul cont.
* Store routing rules in config server
* uses `Hystrix->Ribbon->Eureka` to forward requests to appropriate service

DEMO

## Archaius
* Client side configuration library
* extends apache commons config
* extendible sources
* Polling or push updates

```java
DynamicStringProperty myprop = DynamicPropertyFactory.getInstance()
      .getStringProperty("my.prop");
someMethod(myprop.get());
```


## Archaius - Spring Environment Bridge
* Auto-configured
* Existing Netflix libraries configured via application.{properties,yml}
* /refresh actuator endpoint

DEMO

## Platform Bus
* lightweight messaging bus using spring integration abstractions
* Simple implementation using spring-amqp and rabbitmq
* send messages to all services
* send messages to just one applications nodes
* Translate messages to actuator endpoint calls

DEMO
