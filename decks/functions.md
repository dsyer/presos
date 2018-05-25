---
title: Functions and Platforms
layout: plain
theme: spring
---
# Functions and Platforms

Dave Syer, 2016  
Twitter: @david_syer  
Email: `dsyer@pivotal.io`

## Agenda

* Platforms and serverless
* Architecture and domain concepts
* Platform convergence

## No Code is an Island

![mixed_arch](images/serverless/burningmonk.png)

Credit: Yan Cui, https://theburningmonk.com

## Serverless

* Dynamic resource utilization, "scale to zero"
* Billing per message
* Focus on business logic
* Easy integration with platform services

## Service Block

![service-block-architecture](images/serverless/sba.png)

## Idealized Serverless Architecture

![mixed_arch](images/mixed_arch.svg)

## What is Missing?

* Architectural cohesion
* Observability
* On premise and BYO services
* Vendor neutrality

## More Often...

![tire-fire](images/serverless/tire-fire.gif)

<div style="text-align:center">What Can We Do?</div>

## Convergence of Platforms

Abstractions are a good thing

But not everything is a function

So platforms adapt to real needs...

## Cloud Abstractions

![cloud_abstractions](images/cloud_abstraction_layers.svg)

## Cloud Abstractions

![cloud_services](images/cloud_service_layers.svg)

## Abstraction Trade Offs

Higher level of abstraction means:

* Higher value line          :-)
* Less control               :-(

But: you need to pick your battles.

Not all abstractions are helpful for all problems.

## A Platform for Devops

![triangle_platform](images/triangle_platform.svg)

N.B. a developer does not care what is in the middle

## A Platform for Devops

<style>
img[alt=triangle_k8s] {
  text-align: center;
  width: 50%;
}
</style>
![triangle_k8s](images/triangle_k8s.svg)

## Riff

<style>
img[alt=riff_function_screenshot] {
  text-align: center;
  width: 70%;
}
</style>
![riff_function_screenshot](images/riff_function_screenshot.png)

## Links

* Spring Cloud Function: https://github.com/spring-cloud/spring-cloud-function
* Riff: https://github.com/projectriff/riff
* Cloud Events: https://github.com/cloudevents/spec
* Spring Tip: https://youtu.be/E55oAtOhWZU
