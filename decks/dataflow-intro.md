---
title: Spring Cloud Data Flow
layout: plain
---
# Spring Cloud Data Flow

Dave Syer, 2016  
Twitter: @david_syer  
Email: dsyer@pivotal.io

## Agenda

* What is a Messaging Microservice?
* Why do I care?
* How do I make them and deploy them?
* What about Streaming and Batch Processing?

## Messaging

*Patterns:*

* spatial decoupling (aka communication)
* temporal decoupling (aka buffering)
* logical decoupling (aka routing)

> *Conclusion:* There is a range of applications and problems to
> which messaging is an effective solution.

## Philosophy

> *Simple things should be easy, and*
> *complex things should be possible.*

---
Alan Kay

## A Simple Streaming Application

```java
@EnableBinding(Source.class)
@SpringBootApplication
public class Application {

  @Autowired
  Source source;

  @RequestMapping(value="/", method=POST)
  public String send() {
    source.output()
      .send(MessageBuilder.withPayload("Hello World").build);
    return "OK";
  }

}
```

## What's a Source?

*Answer:* it's an interface...

```java
public interface Source {
	
  String OUTPUT = "output";
	
  @Output(Source.OUTPUT)
  MessageChannel output();

}
```

## Enable All the Things

```java
@EnableBinding(Source.class)
...
@EnableBinding(Sink.class)
...
@EnableBinding(Processor.class)
...
@EnableBinding(MyCoffeeShop.class)
...
```

also

```
@EnableRxJavaProcessor
...
```

## Tasks as Well

```
@SpringBootApplication
public class Task {

  @Bean
  public ApplicationRunner(Source source) {
    return app -> { System.out.println("Hello World"); };
  }
  
  ...
}
```

## Enable that Task!

```
@EnableTask
@SpringBootApplication
public class Task {

  @Bean
  public ApplicationRunner(Source source) {
    return app -> { System.out.println("Hello World"); };
  }
  
  ...
}
```

## Spring Cloud Data Flow

> *A programming and operating model for*
> *streams and tasks on a structured platform.*

_Components:_ server (REST and UI), store (RDBMS and redis), shell, apps (streams and tasks), platform

---
"Structured platform" is an SPI. Examples:
* local (in or out of process)
* cloud foundry
* YARN
* kubernetes
* mesos

## Architecture

```

  +---------------------------------+
  |            Client               | (shell or browser)
  +---------------------------------+
                |^
  Platform      v|                    (cf, k8s, mesos, etc.)
  +---------------------------------+
  |       +------+ +------+         |
  |       |Server| |  DB  |         |
  |       +------+ +------+         |
  | +----+----+----+----+----+----+ |
  | |    |    |Apps|    |    |    | | (streams and tasks)
  | +-----------------------------+ |
  | |         Transport           | | (rabbit, redis, kafka)
  +---------------------------------+

```

## Streams and Tasks

Streams have a DSL, e.g. `http | transform | hdfs`, but fundamentally
they are just apps sending each other messages. Each node in the
pipeline is a Spring Boot app.

Tasks are short- (or finite-) lived apps. Data flow orchestrates them
and records their exit status.

## EOF

* http://github.com/spring-cloud/spring-cloud-stream
* http://github.com/spring-cloud/spring-cloud-task
* http://github.com/spring-cloud/spring-cloud-dataflow
* dsyer@pivotal.io
* @david_syer
