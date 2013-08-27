---
title: Spring Security Javaconfig
layout: default
---
# Spring Security Javaconfig

Dave Syer, 2013  
Twitter: @david_syer  
Email: dsyer@gopivotal.com

## Agenda
* What's happening in Spring Security?
* How do I get started with the `@Configuration`?
* Demo / live coding session

## What's Happening

* `@rob_winch` project lead (2012)
* GA: Spring Security 3.1.4 -> Spring 3.0.*
* In the pipeline Spring Security 3.2.0 -> Spring 3.2.*
    * Servlet 3.0 and Spring MVC async
    * Servlet 3.0 API
    * Concurrency
    * Javaconfig, a.k.a. `@Configuration`
* Spring Security Javaconfig is standalone at 1.0.0.CI-SNAPSHOT, but
  intended to be part of 3.2.*
* Spring 4 is coming!

## Getting Started 1

    :::java
    @Configuration
    @EnableWebSecurity
    public class SecurityConfiguration {

    }    

## Getting Started 2

    :::java
    @Configuration
    @EnableWebSecurity
    public class SecurityConfiguration {
    
       @Bean
        public AuthenticationManager authenticationManager() throws Exception {
            return new AuthenticationBuilder().inMemoryAuthentication().withUser("user")
                .password("password").roles("USER").and().and().build();
        }

    }

## Getting Started 3

    :::java
    @Configuration
    @EnableWebSecurity
    public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
    
       @Bean
        public AuthenticationManager authenticationManager() throws Exception {
            return new AuthenticationBuilder().inMemoryAuthentication().withUser("user")
                .password("password").roles("USER").and().and().build();
        }

        @Override
        protected void configure(HttpConfigurator http) throws Exception {
            http.authorizeUrls()
                  .antMatchers("/**").authenticated()
              .and()
                  .formLogin().permitAll();
        }

    }
    
## Demo

<div id="center">
<div>XML -> <code>@Configuration</code></div>
</div>

## Links

* [http://github.com/SpringSource/spring-security-javaconfig]()
* [Spring Security 3.2.0.M1 Blog](http://blog.springsource.org/2012/12/17/spring-security-3-2-m1-highlights-servlet-3-api-support/)
* [http://blog.springsource.org]()
* [https://springone2gx.com/conference/santa_clara]()
* [Spring eXchange 2013/11/15](http://skillsmatter.com/event/java-jee/spring-exchange-1724)
