---
title: Spring Boot Intro
layout: springone13
---
# <i class="icon-off"></i> Spring Boot

Dave Syer, Phil Webb, 2013  
Twitter: `@david_syer`, `@phillip_webb`  
Email: [dsyer, pwebb]@gopivotal.com

(Introduction to Spring Boot)

## 

![Spring IO](images/springio.png)

## Agenda
* Quick overview of goals and high level features
* Getting started demo
* Customization and Configuration
* Behind the scenes
* Adding new features to Spring Boot

## Introduction

<i class="icon-off icon-3x"></i> Spring Boot:

* Focuses attention at a single point (as opposed to large collection
  of `spring-*` projects)
* A tool for getting started very quickly with Spring
* Common non-functional requirements for a "real" application
* Exposes a lot of useful features by default
* Gets out of the way quickly if you want to change defaults

> An opportunity for Spring to be opinionated

## Focus Attention

<img src="images/boot-focus.png" width="30%"></img>

## Spring Boot Goals

* Provide a radically faster and widely accessible getting started experience
* Be opinionated out of the box, but get out of the way quickly as requirements start to
  diverge from the defaults
* Provide a range of non-functional features that are common to large classes of projects
  (e.g. embedded servers, security, metrics, health checks, externalized configuration)
* Absolutely no code generation and no requirement for XML configuration

## Getting Started *Really* Quickly

<div id="center">
Demo of the Spring Command Line Tool
</div>

## What Just Happened?

```groovy
@RestController
class Example {

    @RequestMapping("/")
    public String hello() {
        return "Hello World!";
    }

}
```

## What Just Happened?

```groovy
// import org.springframework.stereotype.Controller
// import org.springframework.context.annotation.Profile
// import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// // other imports ...

@RestController
class Example {

    @RequestMapping("/")
    public String hello() {
        return "Hello World!";
    }

}
```

## What Just Happened?

```groovy
// import org.springframework.stereotype.Controller
// import org.springframework.context.annotation.Profile
// import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// // other imports ...

// @Grab("org.springframework.boot:spring-boot-starter:0.5.0")
// @Grab("org.springframework.boot:spring-boot-web-starter:0.5.0")
@RestController
class Example {

    @RequestMapping("/")
    public String hello() {
        return "Hello World!";
    }

}
```

## What Just Happened?

```groovy
// import org.springframework.stereotype.Controller
// import org.springframework.context.annotation.Profile
// import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// other imports ...

// @Grab("org.springframework.boot:spring-boot-starter:0.5.0")
// @Grab("org.springframework.boot:spring-boot-web-starter:0.5.0")
// @EnableAutoConfiguration
@RestController
class Example {

    @RequestMapping("/")
    public String hello() {
        return "Hello World!";
    }

}
```

## What Just Happened?

```groovy
// import org.springframework.stereotype.Controller
// import org.springframework.context.annotation.Profile
// import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// // other imports ...

// @Grab("org.springframework.boot:spring-boot-starter:0.5.0")
// @Grab("org.springframework.boot:spring-boot-web-starter:0.5.0")
// @EnableAutoConfiguration
@RestController
class Example {

    @RequestMapping("/")
    public String hello() {
        return "Hello World!";
    }

//  public static void main(String[] args) {
//      SpringApplication.run(Example.class, args);
//  }
}
```

## Java Demo

<div class="demo">
Demo of Spring Boot with Java.
</div>


## What Just Happened?

```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.*;

@Configuration
@ComponentScan
@EnableAutoConfiguration
public class MyApplication {

  public static void main(String[] args) {
    SpringApplication.run(MyApplication.class, args);
  }

}
```

## What Just Happened?

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

...
@RestController
public class MyApplication {

  ...

  @RequestMapping
  public String sayHello() {
    return "Hello World!";
  }

}
```

## Starter POMs

* Standard Maven POMs
* Define dependencies that we recommend
* Available for web, batch, integration, data
* e.g. data = hibernate + spring-data + JSR 303

## SpringApplication

* Gets a running Spring `ApplicationContext`
* Uses `EmbeddedWebApplicationContext` for web apps
* Can be a single line: `SpringApplication.run(MyConf.class, args)`
* Or customized

```java
SpringApplication app = new SpringApplication(MyConf.class);
app.setShowBanner(false);
app.run(args);
```

## @EnableAutoConfigured

* Attempts to auto-configure your application
* Backs off as you define your own beans
* Regular `@Configuration` classes
* Usually with `@ConditionalOnClass` and `@ConditionalOnMissingBean`

## Packaging For Production

Maven plugin (using `spring-boot-starter-parent`):

```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
</plugin>
```

```sh
$ mvn package
```

Gradle plugin:

```groovy
apply plugin: 'spring-boot'
```

```sh
$ gradle repackage
```

## Packaging For Production

* Easy to understand structure
* No unpacking or start scripts required
* Typical REST app ~10Mb
* Cloud Foundry friendly (works & fast to upload)

```sh
$ java -jar yourapp.jar
```

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


## Command Line Arguments

* `CommandLineRunner` is a hook to run application-specific code after 
the context is created

* `SpringApplication` adds command line arguments to the Spring 
`Environment` so you can refer inject them into beans:

```java
@Value("${name}")
private String name;
```

```sh
$ java -jar yourapp.jar --name=Dave
```

* You can also configure many aspects of Spring Boot itself:

```sh
$ java -jar target/*.jar --server.port=9000
```



## Externalizing Configuration to Properties

Just put `application.properties` in your classpath or next to you jar, e.g.

`application.properties`

```properties
server.port: 9000
```

Properties can be overridden (`command line arg` > `file` > `classpath`)

## Using YAML

Just include `snake-yaml.jar` put `application.yml` in your classpath

`application.yml`

```yaml        
server:
  port: 9000
```

Both properties and YAML add entries with period-separated paths to
the Spring `Environment`.

## Binding Configuration To Beans

`MyProperties.java`

```java
@ConfigurationProperties(prefix="mine")
public class MyPoperties {
    private Resource location;
    private boolean skip = true;
    // ... getters and setters
}
```

`application.properties`

```properties
mine.location: classpath:mine.xml
mine.skip: false
```

## Customizing Configuration Location

Set 

* `spring.config.name` - default `application`, can be comma-separated
  list
* `spring.config.location` - a `Resource` path, overrides name

e.g.

```sh
$ java -jar target/*.jar --spring.config.name=production
```

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
        
```
spring.profiles.active: default, postgresql
```

## Logging

* Spring Boot provides default configuration files for 3 common logging
frameworks: logback, log4j and `java.util.logging`
* Starters (and Samples) use logback with color output
* External configuration and classpath influence runtime behavior
* `LoggingApplicationContextInitializer` sets it all up

## Adding some Autoconfigured Behavior

Extend the demo and see what we can get by just modifying the
classpath, e.g. 

* Add an in memory database
* Add a Tomcat connection pool

## Adding A UI with Thymeleaf

* Add Thymeleaf to the classpath and see it render a view
* Spring Boot Autoconfigure has added all the boilerplate stuff
* Common configuration options via `spring.thymeleaf.*`, e.g.
    - `spring.thymeleaf.prefix:classpath:/templates/` (location of templates)
    - `spring.tjymeleaf.cache:true` (set to `false` to reload templates
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

_Please open an issue if you want support for something else_

## The Actuator

Adds common non-functional features to your application and exposes
MVC endpoints to interact with them.

* Security
* Secure endpoints: `/metrics`, `/health`, `/trace`, `/dump`, `/shutdown`, `/beans`
* Audit
* `/info`

If embedded in a web app or web service can use the same port or a
different one (and a different network interface).

## Adding Security

* Use the Actuator
* Add Spring Security to classpath

## Customizing the ApplicationContext

* Directly on the `SpringApplication` instance
* Add external configuration (System properties, OS env vars, config
  file, command line arguments)
* Add `ApplicationContextInitializer` implementations and enable in
  `application.properties`

## Customizing @EnableAutoConfiguration

* Disable specific feature `@EnableAutoConfiguration(disable={WebMvcAutoConfiguration.class})
* Write you own...
* Add JAR with `META-INF/spring.factories` entry for `EnableAutoConfiguration`
* All entries from classpath merged and added to context

## Customizing the CLI

Uses standard Java `META-INF/services` scanning

* `CompilerAutoConfiguration`: add dependencies and imports
* `CommandFactory`: add commands via a custom `CommandFactory` in `META-INF/services`

E.g. can add script commands (written in Groovy)

```sh
$ spring foo ...
```

Looks for `foo.groovy` in `${SPRING_HOME}/bin` and
`${SPRING_HOME}/ext` by default

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
`ClassLoader` and `JarFile` implementations that can find resources in 
nested JARs (e.g. `lib/*.jar` or `WEB-INF/lib/*.jar`)

## How We Load Nested Jars

Each regular JAR file is sequence of `JarEntries`

  `yourapp.original.jar`

```
+----+----+----+-------
| A1 | A2 | A3 | ...
+----+----+----+-----
```

  `spring-core.jar`

```
+----+----+----+-------
| S1 | S2 | S3 | ...
+----+----+----+-----
```


## How We Load Nested Jars

With nested JARs entries are contained within entries.

  `yourapp.jar`

```
+----+----+----+-+-------------------------
|    |    |    | +----+----+----+-------
| A1 | A2 | A3 | | S1 | S2 | S3 | ...
|    |    |    | +----+----+----+-------
+----+----+----+-+--------------------
```

## How We Load Nested Jars

We can scan nested JARs and simply seek to the correct part of the outer file
when reading a nested entry.

  `yourapp.jar`

```
+----+----+----+-+-------------------------
|    |    |    | +----+----+----+-------
| A1 | A2 | A3 | | S1 | S2 | S3 | ...
|    |    |    | +----+----+----+-------
+----+----+----+-+--------------------
^    ^    ^      ^    ^    ^
```

> **NOTE:** In order to seek inside the nested JAR, the containing entry cannot be compressed.
    
## Spring Boot Loader Limitations

* Don't create nested JAR from Strings without context `jar:file:/file.jar!/nested.jar!/a/b.txt`
* Always use the context class loader (`ClassLoader.getSystemClassLoader()` will fail)

> You don't need to use it, consider shade or a classic WAR

## Building a WAR

We like launchable JARs, but you can still use WAR format if you
prefer. Spring Boot Tools take care of repackaging a WAR to make it
executable.

If you want a WAR to be deployable (in a "normal" container), then you
need to use `SpringBootServletInitializer` instead of or as well as
`SpringApplication`.

## Testing with Spring Test (MVC)

`SpringApplication` is an opinionated creator of an
`ApplicationContext`, but most of the behaviour is encapsulated in
`ApplicationContextInitializer` implementations. To reproduce the
behaviour of you app in an integration test it is useful to duplicate
those features you can use the corresponding initializers.

Example if you have externalized configuration:

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = IntegrationTestsConfiguration.class, 
    initializers = ConfigFileApplicationContextInitializer.class)
public class IntegrationTests {

  // Normal Spring Test stuff
  
}
```

## Links

* [https://github.com/SpringSource/spring-boot](https://github.com/SpringSource/spring-boot) Spring Boot on Github
* [https://projects.spring.io/spring-boot](https://projects.springframework.io/spring-boot) Documentation
* [http://spring.io/blog]()
* [http://dsyer.com/decks/spring-boot-intro.md.html]()
* Twitter: @david_syer, @phillip_webb  
* Email: dsyer@gopivotal.com, pwebb@gopivotal.com

## 

<div id="center">
<div>Spring Boot Intro - END</div>
</div>










