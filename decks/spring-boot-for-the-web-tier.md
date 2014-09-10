---
title: Spring Boot for the Web Tier
layout: springone14
---
# Spring Boot for the Web Tier

Phillip Webb  
twiiter: [@phillip_webb](http://twitter.com/phillip_webb)    
email: pwebb@pivotal.io   

Dave Syer   
twitter: [@david_syer](http://twitter.com/david_syer)   
email: dsyer@pivotal.io   


## Presentation Overview
* Part 1 - Static Content
* Part 2 - Dynamic Content
* Part 3 - Embedded Server
* Part 4 - Other Stacks

## Static Content - Serving Files
* Can't use `/src/main/webapp` for jar deployments
* Put static files from `src/main/resources/static`
* or `.../public` or `.../resources` or `.../META-INF/resources`

## Static Content - Conventions
* `src/main/resources/static/index.html` is mapped to `/index.html` & `/`
* Add a `src/main/resources/favicon.ico` to replace the Spring Leaf
* Imported "webjars" are automatically mapped

## Demo - Static Content

<!---
Demo here will show a simple index.html file being added
the mapping to '/' and an alternative favicon.ico. It will
also add show a webjar import. 
-->

## Static Content: Grunt Toolchain
For serious front end developers the best choice is a Javascript
toolchain.

* Good community, lots of tools
* Package static assets into a jar
* And/or build them as part of a very thin back end
* Spring Boot CLI makes a great lightweight back end in production or for Java devs

<!--
Demo NPM toolchain. Show Spring Boot CLI app for backend.
-->

## Static Content - wro4j
* Great for Java developers
* Often good enough
  * JsHint
  * CssLint
  * JsMin
  * Google Closure compressor
  * UglifyJs
  * Less
  * Sass

## Static Content - Wro4j with Maven

```xml
<plugin>
    <groupId>ro.isdc.wro4j</groupId>
    <artifactId>wro4j-maven-plugin</artifactId>
    <version>${wro4j.version}</version>
    <executions><execution>
      <phase>generate-resources</phase>
      <goals><goal>run</goal></goals>
    </execution></executions>
    <configuration>
        <wroManagerFactory>ro.isdc.wro.maven.plugin.manager.factory.ConfigurableWroManagerFactory</wroManagerFactory>
        <destinationFolder>${basedir}/target/generated-resources/static/</destinationFolder>
        <wroFile>${basedir}/src/main/wro/wro.xml</wroFile>
        <extraConfigFile>${basedir}/src/main/wro/wro.properties</extraConfigFile>
    </configuration>
</plugin>
```

## Static Content - Wro4j with Maven

`src/main/wro/wro.xml`

```xml
<groups xmlns="http://www.isdc.ro/wro">
  <group name="wro">
    <css>file:./src/main/wro/main.less</css>
  </group>
</groups>
```

<p/>

`src/main/wro/wro.properties`

```
postProcessors=less4j
```

<!---
We can jump to a wro4j demo here 
-->



## Dynamic Content - Templating Support
* Thymeleaf
* Groovy Template Language
* Freemarker
* Velocity
* JSP (not recommended)

## Dynamic Content - Template Conventions
* Templates live in `src/main/resources/templates`
* and are accessed via `classpath:/templates/`
* Default Extensions are:
  * `*.html` - Thymeleaf
  * `*.tpl` - Groovy
  * `*.ftl` - Freemarker
  * `*.vm` - Velocity

## Dynamic Content - Template Customization
* User `spring.xxx.prefix` and `spring.xxx.suffix`
* eg. `spring.freemarker.suffix=fm`

## Demo - Templating

<!--
Demo Groovy templates. Showing groovy code in-line.
-->

## Dynamic Content - Custom Support
* Add a `ViewResolver`
* Optionally add a `TemplateAvailabilityProvider`

```java
public class GroovyTemplateAvailabilityProvider implements TemplateAvailabilityProvider {

  @Override
  public boolean isTemplateAvailable(String view, Environment environment,
      ClassLoader classLoader, ResourceLoader resourceLoader) {
    if (ClassUtils.isPresent("groovy.text.TemplateEngine", classLoader)) {
      String prefix = environment.getProperty("spring.groovy.template.prefix",
          GroovyTemplateProperties.DEFAULT_PREFIX);
      String suffix = environment.getProperty("spring.groovy.template.suffix",
          GroovyTemplateProperties.DEFAULT_SUFFIX);
      return resourceLoader.getResource(prefix + view + suffix).exists();
    }
    return false;
  }

}
```

## Dynamic Content - Internationalization
* A `MessageSource` bean is added when `src/main/resources/messages.properties` exists
* Use `messages_LOCALE.properties` to add additional locales
  * e.g. `messages_FR.properties`
* Choose a specific locale using the `spring.mvc.locale` property
* Choose a specific date format using the `spring.mvc.date-format` property

<!-- We can demo adding messages to the template here -->

## Dynamic Content - HttpMessageConverter
* Add `HttpMessageConverter` beans and Spring Boot will try to do the right thing
* It tries to be intelligent about the order
* Add a `HttpMessageConverters` bean if you need more control

## Dynamic Content - Rest
* Use the `@RestContoller` annotation
* Use ResponseEntity builder methods with Spring Framework 4.1

```
ResponseEntity.
    accepted().
    contentLength(3).
    contentType(MediaType.TEXT_PLAIN).
    body("Yo!");
```

## Demo - HttpMessageConverter

<!-- 
  Here we will demo a simple rest service then show adding a HtmlMessageConverter 
-->

## Dynamic Content - Hidden Gems
* You can get the `RequestContext` from `RequestContextHolder` anywhere
* The request has some useful things in it (from Spring), e.g. `HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE`
* All `Converter`, `Formatter`, `GenericConverter` beans are automatically added
* Use `spring.mvc.message-codes-resolver-format` to add a `MessageCodesResolver`
  * `prefix_error_code` or `postfix_error_code` 

```
# prefix_error_code
empty.customer.name=Customer name is required
```

<br/>

```
# postfix_error_code
customer.name.empty=Customer name is required
```

## Embedded Server
* When using WARs a `ServletContainerInitializer` creates the Spring `ApplicationContext`
* When running embedded the `ApplicationContext` creates the Server
* Expects a single `EmbeddedServletContainerFactory` bean
* Odd dance for `WebApplicationContext.getServletContext()` and `ServletConfigAware`

## Embedded Server - Initialization
* The following beans are used to configure the server:
  * `Servlet`
  * `Filter`
  * `ServletRequestListener`
  * `ServletRequestAttributeListener`
  * `HttpSessionAttributeListener`
  * `HttpSessionListener`
  * `ServletContextListener`

## Embedded Server - Initialization
* For more control use 
  * `ServletRegistrationBean`
  * `FilterRegistrationBean`
  * `ServletListenerRegistrationBean`

```java
@Bean
public ServletRegistrationBean myServlet() {
    ServletRegistrationBean bean = 
        new ServletRegistrationBean(new MyServlet(), "/mine");
    bean.setAsyncSupported(false);
    bean.setInitParameters(Collections.singletonMap("debug", "true"));
    return bean;
}

@Bean
public FilterRegistrationBean myFilter() {
    return new FilterRegistrationBean(new MyFilter(), myServlet());
}
```

## Embedded Server - Initialization
* By design the following are not called with embedded servers:
  * `javax.servlet.ServletContainerInitializer`
  * `org.springframework.web.WebApplicationInitializer`
* Use `o.s.boot.context.embedded.ServletContextInitializer`

```java
  /**
   * Configure the given {@link ServletContext} with any servlets, filters, listeners
   * context-params and attributes necessary for initialization.
   * @param servletContext the {@code ServletContext} to initialize
   * @throws ServletException if any call against the given {@code ServletContext}
   * throws a {@code ServletException}
   */
  void onStartup(ServletContext servletContext) throws ServletException;
```

## Embedded Server - Customization
* Use `ServerProperties` (e.g. `server.port=8080`)
* `EmbeddedServletContainerCustomizer`
  * Customize common things (e.g. the `port`, `error-pages`, `context-path`)
* Tomcat Specific
  * `TomcatConnectorCustomizer`
  * `TomcatContextCustomizer`
* Jetty Specific
  * `JettyServerCustomizer`

## Embedded Server - Customization
* If all else fails subclass `EmbeddedServletContainerFactory`
* Lots of protected methods to override
* `TomcatEmbeddedServletContainerFactory`
* `JettyEmbeddedServletContainerFactory`

```java
@Bean
public TomcatEmbeddedServletContainerFactory tomcatFactory() {
    return new TomcatEmbeddedServletContainerFactory(7070) {
        @Override
        protected void customizeConnector(Connector connector) {
          // Something with the connector
        }

        @Override
        protected void configureSsl(AbstractHttp11JsseProtocol<?> 
              protocol, Ssl ssl) {
          // Something with ssl
        }
    };
}
```

## Embedded Server - Tomcat Behind HTTPD
* Running behind Apache HTTPD is a common option
* Especially useful with SSL termination
* Real IP and SSL information is passed in headers

```
server.tomcat.protocol-header=x-forwarded-proto
server.tomcat.remote-ip-header=x-forwarded-for
```

## Embedded Server - Tomcat Behind HTTPD

```
<VirtualHost *:80>
  ServerName example.spring.io
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
  ProxyPass / http://${TOMCAT_IP}:8080/
  ProxyPassReverse / http://${TOMCAT_IP}:8080/
</VirtualHost>

<VirtualHost *:443>
  SSLEngine on
  SSLCertificateFile /etc/apache2/ssl/apache.crt
  SSLCertificateKeyFile /etc/apache2/ssl/apache.key
  ProxyPass / http://${TOMCAT_IP}:8080/
  ProxyPassReverse / http://${TOMCAT_IP}:8080/
  RequestHeader set X-Forwarded-Proto "https"
  RequestHeader set X-Forwarded-Port "443"
</VirtualHost>

```

## Demo - Running Behind HTTPS

<!-- Here we demo HTTPD running in docker -->

## Other Stacks

* JAX-RS: Jersey 1.x, Jersey 2.x [dsyer/spring-boot-jersey](https://github.com/dsyer/spring-boot-jersey), CXF (allegedly works)
* Netty and NIO: Ratpack [dsyer/spring-boot-ratpack](https://github.com/dsyer/spring-boot-ratpack)
* Servlet 2.5 [scratches/spring-boot-legacy](https://github.com/scratches/spring-boot-legacy)
* Vaadin [peholmst/vaadin4spring](https://github.com/peholmst/vaadin4spring/tree/master/spring-boot-vaadin)

## Jersey 1.x

Easy to integrate with Spring Boot using `Filter` (or `Servlet`), e.g.

```java
@Configuration
@EnableAutoConfiguration
@Path("/")
public class Application {

    @GET
    @Produces("text/plain")
    public String hello() {
        return "Hello World";
    }

    @Bean
    public FilterRegistrationBean jersey() {
        FilterRegistrationBean bean = new FilterRegistrationBean();
        bean.setFilter(new ServletContainer());
        bean.addInitParameter("com.sun.jersey.config.property.packages",
      "com.mycompany.myapp");
        return bean;
    }

}
```

(N.B. with fat jar you need to explicitly list the nested jars that have JAX-RS resources in them.)

## Jersey 2.x

Spring integration is provided out of the box, but a little bit tricky
to use with Spring Boot, so some autoconfiguration is useful. Example
app:

```java
@Configuration
@Path("/")
public class Application extends ResourceConfig {

    @GET
    public String message() {
        return "Hello";
    }

    public Application() {
        register(Application.class);
    }

}
```

## Ratpack

> Originally inspired by Sinatra, but now pretty much
> diverged. Provides a nice programming model on top of Netty
> (potentially taking advantage of non-blocking IO).

2 approaches:

* Ratpack embeds Spring (and uses it as a `Registry`), supported natively in Ratpack 0.9.9
* Spring embeds Ratpack (and uses it as an HTTP listener) = spring-boot-ratpack

## Spring Boot embedding Ratpack

Trivial example (single `Handler`):

```java
@Bean
public Handler handler() {
    return (context) -> {
        context.render("Hello World");
    };
}
```

## Spring Boot embedding Ratpack

More interesting example (`Action<Chain>` registers `Handlers`):

```java
@Bean
public Handler hello() {
    return (context) -> {
        context.render("Hello World");
    };
}

@Bean
public Action<Chain> handlers() {
    return (chain) -> {
        chain.get(hello());
    };
}
```

## Spring Boot Ratpack DSL

A valid Ratpack Groovy application:

```groovy
ratpack {
  handlers {
    get {
      render "Hello World"
    }
  }
}
```

launched with Spring Boot:

```
$ spring run app.groovy
```


## Questions?

* http://projects.spring.io/spring-boot/
* https://github.com/SpringOne2GX-2014/spring-boot-for-the-web-tier