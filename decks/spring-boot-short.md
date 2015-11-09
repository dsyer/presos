---
title: Spring Boot Intro
layout: spring
---

# Spring Boot Intro

## Overview

> Spring Boot makes it easy to create Spring-powered, production-grade applications and services with absolute 
> minimum fuss. It takes an opinionated view of the Spring platform so that new and existing users can quickly 
> get to the bits they need.

## Groovy Spring Script

```groovy
@RestController
class Example {

    @RequestMapping('/')
    String hello() {
        'Hello World!'
    }

}
```

## Groovy Spring Script

```groovy
import org.springframework.stereotype.Controller
import org.springframework.context.annotation.Profile
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// other imports ...

@Controller
@RestController
class Example {

    @RequestMapping('/')
    String hello() {
        'Hello World!'
    }

}
```

## Groovy Spring Script

```groovy
import org.springframework.stereotype.Controller
import org.springframework.context.annotation.Profile
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// other imports ...

@Grab('spring-boot-web-starter')
@RestController
class Example {

    @RequestMapping('/')
    String hello() {
        'Hello World!'
    }

}
```

## Groovy Spring Script

```groovy
import org.springframework.stereotype.Controller
import org.springframework.context.annotation.Profile
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// other imports ...

@Grab('org.springframework.boot:spring-boot-web-starter:1.3.0.RELEASE')
@RestController
class Example {

    @RequestMapping('/')
    String hello() {
        'Hello World!'
    }

}
```

## Groovy Spring Script

```groovy
import org.springframework.stereotype.Controller
import org.springframework.context.annotation.Profile
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// other imports ...

@Grab('org.springframework.boot:spring-boot-web-starter:1.3.0.RELEASE')
@SpringBootApplication
@RestController
class Example {

    @RequestMapping('/')
    String hello() {
        'Hello World!'
    }

}
```

## Groovy Spring Script

```groovy
import org.springframework.stereotype.Controller
import org.springframework.context.annotation.Profile
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
// other imports ...

@Grab('org.springframework.boot:spring-boot-web-starter:1.3.0.RELEASE')
@SpringBootApplication
@RestController
class Example {

    @RequestMapping('/')
    String hello() {
        'Hello World!'
    }

    static void main(String[] args) {
        SpringApplication.run(Example.class, args)
    }
}
```

## Starter POMs

* Standard Maven POMs
* Define dependencies that we recommend
* Available for web, batch, integration, data, etc.
* e.g. data-jpa = hibernate + spring-data + JSR 303

## SpringApplication

* Gets a running Spring `ApplicationContext`
* Uses `EmbeddedWebApplicationContext` for web apps
* Can be a single line: `SpringApplication.run(MyConf.class, args)`
* Or customized

```java
SpringApplication app = new SpringApplication(MyConf.class);
app.setBannerMode(Mode.OFF);
app.run(args);
```

## @SpringBootApplication

* Attempts to auto-configure your application
* Backs off as you define your own beans
* Support for foundation spring-* projects (Web, Batch, Integration, etc)
* Regular `@Configuration` classes
* Usually with `@ConditionalOnClass` and `@ConditionalOnMissingBean`

## Embedded Servlet Container

* Tomcat, Jetty, Undertow
* Executable jar
* Abstraction over common configurations (e.g. SSL)
* Full access to platform APIs

## Packaging for production

* Encourages Coud Native (12 Factor Apps)
* Easy to understand structure
* No unpacking or start scripts required
* Create using the Maven or Gradle plugins
* Cloud friendly (works & fast to upload)

## Properties

* Externalize configuration
* Defined override order `command line arg` > `file` > `classpath`
* Can be used to configure Spring Boot itself
* Support for YAML

## Binding To Beans

```java
@ConfigurationProperties(prefix="mine")
public class MyPoperties {

    private Resource location;
    private boolean skip = true;

    // ... getters and setters
}
```

<br/>

```properties
mine.location: classpath:mine.xml
mine.skip: false
```

## Actuator

* Production-ready features
* Common useful endpoints
* Can be secured using Spring Security
* Can run on different port to main application

## Conclusion

* Quicker Spring (getting started guides use Boot)
* Easy stand-alone applications
* Production ready (properties, actuator, logs)
* Cloud ready

## Questions?

https://github.com/spring-projects/spring-boot

dsyer@pivotal.io


