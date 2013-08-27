---
title: Spring Boot Intro
layout: springone13
---
# Spring Boot

Dave Syer, Phil Webb, 2013  
Twitter: `@david_syer`, `@phillip_webb`  
Email: [dsyer, pwebb]@gopivotal.com

(Introduction to Spring Boot)

## 

![Spring IO](images/springio.png)

## Agenda
* Quick overview of goals and high level features
* Getting started demo
* Behind the scenes of `@EnableAutoConfiguration`
* Adding new features to Spring Boot

## Introduction

Spring Boot:

* Focuses attention at a single point (as opposed to large collection
  of `spring-*` projects)
* A tool for getting started very quickly with Spring
* Common non-functional requirements for a "real" application
* Exposes a lot of useful features by default
* Gets out of the way quickly if you want to change defaults

> An opportunity for Spring to be opinionated

## Focus Attention

![Spring Boot in Context](images/boot-focus.png)

## Spring Boot Overview

> Spring Boot makes it easy to create Spring-powered, production-grade
> applications and services with absolute minimum fuss. It takes an
> opinionated view of the Spring platform so that new and existing
> users can quickly get to the bits they need.

## Spring Boot Goals

* Provide a radically faster and widely accessible getting started experience
* Be opinionated out of the box, but get out of the way quickly as requirements start to
  diverge from the defaults
* Provide a range of non-functional features that are common to large classes of projects
  (e.g. embedded servers, security, metrics, health checks, externalized configuration)
* Absolutely no code generation and no requirement for XML configuration

## Getting Started *Really* Quickly

`app.groovy`:

    @Controller
    class Application {
        @RequestMapping('/')
        @ResponseBody
        String home() {
            'Hello World!'
        }
    }

<br/>then

    $ spring run app.groovy

## Getting Started

<div id="center">
<div>DEMO</div>
</div>

## Getting Started In Java

`Application.java`:

    ...
    @Controller
    public class Application {

        @RequestMapping("/")
        @ResponseBody
        public String home() {
            "Hello World!";
        }
        
        public static main(String[] args) {
            SpringApplication.run(Application.class, args);
        }
        
    }

<br/>then

    $ mvn package
    $ java -jar target/*.jar

## Getting Started

<div id="center">
<div>DEMO</div>
</div>

## What Just Happened?

* `SpringApplication`: convenient way to write a `main()` method that loads a Spring context
* `@EnableAutoConfiguration`: optional annotation that adds stuff to your context, including...
* `EmbeddedServletContainerFactory`: added to your context if a server is available on the classpath
* `CommandLineRunner`: a hook to run application-specific code after the context is created

## Spring Boot Modules

* Spring Boot - main library supporting the other parts of Spring Boot
* Spring Boot Autoconfigure - single `@EnableAutoConfiguration`
  annotation creates a whole Spring context
* Spring Boot Starters - a set of convenient dependency descriptors
  that you can include in your application.
* Spring Boot CLI - compiles and runs Groovy source as a Spring
  application
* Spring Boot Actuator - comman non-functional features that make an
  app instantly deployable and supportable in production
* Spring Boot Tools - for building and executing self-contained JAR
  and WAR archives
* Spring Boot Samples - a wide range of sample apps

## Spring Boot Module Relations

![Spring Boot Modules](images/boot-modules.png)

## Binding to Command Line Arguments

`SpringApplication` binds its own bean properties to command line
arguments, and then adds them to the Spring `Environment`, e.g.

    $ java -jar target/*.jar --server.port=9000

## Externalizing Configuration to Properties

Just put `application.properties` in your classpath, e.g.

`application.properties`
        
    server.port: 9000

## Using YAML

Just put `application.yml` in your classpath

`application.yml`
        
    server:
      port: 9000

Both properties and YAML add entries with period-separated paths to
the Spring `Environment`.

## Binding External Configuration To Beans

`MineProperties.java`

    @ConfigurationProperties(prefix="mine")
    public class MinePoperties {
        private Resource location;
        private boolean skip = true;
        // ... getters and setters
    }

<br/>
`application.properties`
        
    mine.location: classpath:mine.xml
    mine.skip: false

## Customizing Configuration Location

Set 

* `spring.config.name` - default `application`, can be comma-separated
  list
* `spring.config.location` - a `Resource` path, overrides name

e.g.

    $ java -jar target/*.jar --spring.config.name=sagan

## Spring Profiles

* Activate external configuration with a Spring profile

    - file name convention e.g. `application-development.properties`
    - or nested documents:

    `application.yml`
        
        defaults: etc...
        ---
        spring:
          profiles: development,postgresql
        other:
          stuff: more stuff...

* Set the default spring profile in external configuration, e.g:

    `application.properties`
        
        spring.profiles.active: default,postgresql

## Adding some Autoconfigured Behaviour

Extend the demo and see what we can get by just modifying the
classpath, e.g. 

* Add an in memory database
* Add a Tomcat connection pool

## Adding A UI with Thymeleaf

* Add Thymeleaf to the classpath and see it render a view
* Spring Boot Autoconfigure has added all the boilerplate stuff
* Common configuration options via `spring.template.*`, e.g.
    - `spring.template.prefix:classpath:/templates/` (location of templates)
    - `spring.template.cache:true` (set to `false` to reload templates
      when changed)
* Extend and override:
    - add Thymeleaf `IDialect` beans
    - add `thymeleafViewResolver`
    - add `SpringTemplateEngine`
    - add `defaultTemplateResolver`

## Currently Available Autoconfigured Behaviour

* Embedded servlet container (Tomcat or Jetty)
* `DataSource` and `JdbcTemplate`
* JPA
* Spring Data JPA (scan for repositories)
* Thymeleaf
* Batch processing
* Reactor for events and async processing
* Actuator features (Security, Audit, Metrics, Trace)

## Building a WAR

We like launchable JARs, but you can still use WAR format if you
prefer. Spring Boot Tools take care of repackaging a WAR to make it
executable.

If you want a WAR to be deployable (in a "normal" container) too, then
you need to use `SpringServletInitializer` instead of
`SpringApplication`.

## The Actuator

Adds common non-functional features to your application and exposes
MVC endpoints to interact with them.

* Security
* Secure endpoints: `/metrics`, `/health`, `/trace`, `/dump`, `/shutdown`
* Audit
* `/info`

If embedded in a web app or web service can use the same port or a
different one (and a different network interface).

## Adding Security

* Use the Actuator
* Add Spring Security to classpath

## Logging

* Spring Boot provides default configuration files for 3 common logging
frameworks: logback, log4j and `java.util.logging`
* Starters (and Samples) use logback
* External configuration and classpath influence runtime behaviour
* `LoggingApplicationContextInitializer` sets it all up

## Customizing the `ApplicationContext` Creation

* Add external configuration (System properties, OS env vars, config
  file, command line arguments)
* Add `ApplicationContextInitializer` implementations

## Customizing the `@EnableAutoConfiguration` Behaviour

* Add JAR with `META-INF/spring.factories` entry for
  `EnableAutoConfiguration`
* All entries from classpath merged and added to context

## Customizing the CLI

Uses standard Java `META-INF/services` scanning

* `CompilerAutoConfiguration`: add dependencies and imports
* `CommandFactory`: add commands

Can also add script commands (written in Groovy)

    $ spring script foo ...
    
looks for `foo.groovy` in `${SPRING_HOME}/bin` and
`${SPRING_HOME}/ext` by default.

## Customizing Servlet Container Properties

* Some common features exposed with external configuration,
  e.g. `server.port` (see `ServerProperties` bean)
* Add bean of type `EmbeddedServletContainerCustomizer` - all
  instances get a callback
* Add bean of type `EmbeddedServletContainerFactory` (replacing
  auto-configured one)

## Spring Boot Loader

**Motivation**: existing solutions for executable JAR are not very robust;
executable WAR is very tricky to create.

**Response**: `JarLauncher` and `WarLauncher` with specialized
  `ClassLoader` implementations that can find resources in nested JARs
  (e.g. `lib/*.jar` or `WEB-INF/lib/*.jar`)

## Maven and Gradle Tooling

Create an executable archive (JAR or WAR)

* Maven plugin (using `spring-boot-starter-parent`):

    <plugin>
        <groupId>${project.groupId}</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
    </plugin>
    
    $ mvn package

* Gradle plugin:

    apply plugin: 'spring-boot'

    $ gradle repackage
    
## Testing with `Spring Test` and `Spring Test MVC`

`SpringApplication` is an opinionated creator of an
`ApplicationContext`, but most of the behaviour is encapsulated in
`ApplicationContextInitializer` implementations. To reproduce the
behaviour of you app in an integration test it is useful to duplicate
those features you can use the corresponding initializers.

Example if you have externalized configuration:

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(classes = IntegrationTestsConfiguration.class, 
        initializers = ConfigFileApplicationContextInitializer.class)
    public class IntegrationTests {
    
      // Normal Spring Test stuff
      
    }


## Links

* [https://github.com/SpringSource/spring-boot](https://github.com/SpringSource/spring-boot) Spring Boot on Github
* [https://projects.spring.io/spring-boot](https://projects.springframework.io/spring-boot) Documentation
* [http://spring.io/blog]()
* [http://dsyer.com/decks/spring-boot-intro.md.html]()
* Twitter: @david_syer  
* Email: dsyer@vmware.com

## 

<div id="center">
<div>Spring Boot Intro - END</div>
</div>
