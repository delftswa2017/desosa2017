<a name="chapter" ></a>
# JUnit 5: the next generation of testing for the JVM

<img src="https://cloud.githubusercontent.com/assets/5969064/24631944/9f1cba70-18c2-11e7-8076-21fd0549eec0.png" width="500px"/>

By [Liam Clark](https://github.com/LiamClark), [Thomas Overklift](https://github.com/Tarovk) and [Jean de Leeuw](https://github.com/JAdeLeeuw). 

## Abstract
JUnit 5 is the successor of JUnit 4, which is the largest Java testing framework and third most imported Java
package currently in existence.
The vision of JUnit 5 is to provide a versatile testing framework which is not tightly coupled towards several
stakeholders like JUnit 4 is.

This chapter provides different views into the project, creating an overview of the project.
These different perspectives range from an architectural perspective to a developers
perspective and more.
Furthermore, the chapter also describes the internal workings of the system
and highlights the differences between JUnit 5 and its predecessor, JUnit 4.
We conclude the chapter by discussing the success of the vision of JUnit 5.

## Table of contents
 * <a href="#introduction">Introduction</a>
 * <a href="#stakeholders">Stakeholders</a>
 * <a href="#context-view">Context View</a>
 * <a href="#functional-view">Functional View</a>
 * <a href="#development-view">Development View</a>
 * <a href="#evolution-perspective">Evolution Perspective</a>
 * <a href="#conclusion">Conclusion</a>

<a name="introduction" ></a>
## Introduction
Unit testing Java code is traditionally done with JUnit. The fourth iteration of JUnit,
JUnit 4, is at the time of writing the largest and most commonly used Java testing framework.
Unfortunately, JUnit 4 suffers from architectural problems, hampering the development of JUnit 4.

The JUnit team wants to create a solid foundation for the future iterations of JUnit,
extending past JUnit 5, called `junit-platform`.
The foundation should solve some of the architectural problems of JUnit 4 and ease development
of future JUnit versions that can be built on top of the foundation. <br/>
The first new version JUnit team wants to create is JUnit 5, a.k.a. `junit-jupiter`,
containing new features while maintaining most of the core features of JUnit 4.<br/>
JUnit 4 as a whole will still be supported through `junit-vintage`, a version that is put on top
of the foundation just like JUnit 5. This structure with multiple versions eases the transition from one version of 
JUnit to another. 
The foundation combined with different (new) iterations of JUnit forms the vision of the JUnit team: 
a framework that is versatile, able to evolve over time, and loosely coupled towards external stakeholders.
This is what the architects of JUnit ultimately strive to accomplish.

At the time of writing, JUnit 5 is still in development,
with the first official release planned on the 24th of August <a href="#32">[32]</a>.
Even though it is still in development, JUnit 5 is usable and already covers a lot of use cases.

This chapter provides insight into the JUnit 5 project,
giving the readers an understanding of the project as a whole.
The chapter starts by covering  the different stakeholders and explaining their perspectives.
Then, it will put JUnit 5 into context, describing the different relationships JUnit 5 has with other projects.
After that, the chapter will explain the structure of the system.
At the end of the chapter the differences between JUnit 4 and JUnit 5 will be explained, and the reasons for the creation
of JUnit 5.
The chapter concludes with our personal opinion on the JUnit 5 project as a whole, and if, according to us, they succeeded
in their mission.

<a name="stakeholders" ></a>
## Stakeholders
Using the stakeholder analysis categories in the book *Software Systems Architecture: Working with Stakeholders Using
Viewpoints and Perspectives* we have identified several groups of stakeholders in
the JUnit 5 system <a href="#1">[1]</a>.  In the sections below we will identify the stakeholders by category.

<!-- Illity2Stakeholder -->
### Acquirers
Acquirers can be seen as business sponsors and are in of JUnit 5's case mainly external investors.
The development of JUnit 5 has started with the launch of a crowd funding campaign on Indiegogo <a href="#2">[2]</a>.
Therefore all of the companies or individuals that funded the campaign can (to a certain extent) be marked as acquirers.
We would like to name American Express as the main sponsor and Pivotal as the main contributor of the Indiegogo campaign.

### Assessors
Assessors are stakeholders that oversee whether legal constraints are complied with.
We did identify Indiegogo as an assessor because of the crowdfunding campaign. In the campaign JUnit states a certain
vision and several features they want to include in the new version of JUnit. By using Indiegogo in this manner they
are required to actually implement what they promised. <br/>
Another legal constraint that one could think of are the licences that the dependencies of JUnit have. The four
dependencies of JUnit (in production), Java <a href="#3">[3]</a>,
Surefire <a href="#4">[4]</a>, OTA4J <a href="#33">[33]</a> and
Gradle <a href="#5">[5]</a>, luckily have licences that allow free use and
distribution of software.
Finally, there are the licenses <a href="#6">[6]</a> that JUnit
itself uses. These licenses have an effect on the users of JUnit and potentially limit certain usages of the framework.


### Contributors / Developers
In the case of JUnit 5 contributors are more than just developers. Contributors are also testers and
maintainers. When contributing to JUnit a developer has to test his or her own contribution before it is merged
into the code base. A contribution can be the implementation of a new feature, but it can also be a bug fix,
an update to the documentation or a refactor. Therefore it differs per contribution what role a contributor
has. <br />
JUnit has many minor and major contributors but we'd like to identify the five people who have taken on the
lion's share of the development of JUnit 5:
  * @[sbrannen](https://github.com/sbrannen)
  * @[marcphillipp](https://github.com/marcphilipp)
  * @[jlink](https://github.com/jlink)
  * @[mmerdes](https://github.com/mmerdes)
  * @[bechte](https://github.com/bechte)

### Suppliers
We have chosen to divide the suppliers of JUnit 5 into two different subcategories: the first category
consists of the suppliers that are used for the development of JUnit 5; the second category consists of
suppliers that support the end use of JUnit 5 in some way.
  * *Development suppliers*
    * Java 1.8
    * Clover
    * Gradle
    * Jenkins / Travis CI / AppVeyor
  * *End use suppliers*
    * IDEs (e.g. IntelliJ)
    * Maven / Gradle

### Support staff
JUnit 5 has no dedicated support staff. Whenever a user runs into problems they have several options:
 1. **Consult the JUnit 5 user guide** <a href="#7">[7]</a>.
 JUnit 5 has an extensive user guide that is actively maintained by contributors and the main five
 developers identified above.
 2. **Post a question on Stack Overflow** <a href="#8">[8]</a>. Stack Overflow has a very active
 community of developers in general and JUnit 5 contributors. Posting questions here often yields good
 results.
 3. **Open an issue on Github** <a href="#9">[9]</a>. For more complicated problems
 or suggestions for additional functionality a user can open an issue on GitHub, requesting changes
 or features.

### Communicators
Communicators are the experts of the system that explain the system (and its architecture) to others and 
additionally train the support staff of the system. Due to the lack of a dedicated support staff, the training thereof 
is not an applicable task in JUnit 5. Therefore the first place to go to if you want to obtain
information about the system would be the user guide <a href="#7">[7]</a>.
Additionally, if we look at the support options that are provided to end users, we can see that the five
main contributors that we identified play an important role in the provision of support. They work on the
support guide and comment on issues on GitHub. When looking at these five contributors, we can identify
two contributors that are the most pro-active in their communication:
* @[sbrannen](https://github.com/sbrannen)
* @[marcphillipp](https://github.com/marcphilipp)

Additionally we know that these two contributors spread their knowledge by giving lectures at conferences
and institutions. Marc Phillip gave a guest lecture at the TU Delft, and Sam Brannen
has held talks about JUnit <a href="#10">[10]</a> during conferences in the past.

Another type of communicator that is not necessarily directly connected to JUnit is teachers. Teachers can introduce
students to the JUnit testing framework and familiarise them with testing principles. An example in this category
would be Arie van Deursen.

### Users
Users are the end users of JUnit 5 who use JUnit to test their software. According to statistics mined from Github 
<a href="#11">[11]</a>, JUnit 4 has a lot of users, since it is the third most used package in Java applications right 
after Java.util and Java.io.

### Ecosystem enhancers
We define *ecosystem enhancers* as stakeholders that provide additional functionality on top of
the features that JUnit provides. There are quite a few of these ecosystem enhancers. Some examples are:
  * Mockito
  * AssertJ
  * Jukito
  * Cucumber
  * Spring

Especially Spring is an interesting stakeholder here because one of the main developers of JUnit,
@[sbrannen](https://github.com/sbrannen), is also a main contributor of the Spring Framework.

### Competitors
While JUnit is the largest testing framework for the JVM, it is not the only one. There are several other
testing frameworks available for the JVM. Some examples are:
  * Scalatest
  * TestNG
  * Spock

### Power to interest
We have created a power vs. interest grid to show the importance of stakeholders in comparison to their
interest in the development of the JUnit 5 framework. The most important stakeholders we have identified
are 'the big 5'. These are the five main contributors we identified above. You can see the corresponding stakeholder
grid we have created in Fig. 1.

![Power Interest Grid](https://cloud.githubusercontent.com/assets/12841723/24619748/5966a9d6-189b-11e7-851f-a5f01eaccbd5.png)
*Fig. 1: The power to interest grid for JUnit 5 stakeholders*

<a name="context-view" ></a>
## Context view
In the book *Software Systems Architecture* a context view is defined as follows: "Describes the relationships, dependencies, and
interactions between the system and its environment" <a href="#1">[1]</a>. The environment that is mentioned is even further specified: "the
people, systems, and external entities with which it interacts". To place JUnit 5 into proper context, we combine
information from multiple sources: stakeholders that we have identified, together with their representation in both
JUnit 4 and JUnit 5.

### OTA4J
An interesting new development is the creation of the 'Open Test Alliance for the JVM'.
This alliance aims to create a standardised way of test assertion failures and errors. This allows IDEs to improve the
way different testing frameworks are integrated. The alliance was initiated by the architects of JUnit. And there are
already quite some parties on board, apart from JUnit, and the IDEs there are several (competing) testing frameworks
that want to work together to achieve this goal. In Fig. 2 we have visualised the different parties that
are involved. <br/>
<img alt="OTA4J" src="https://cloud.githubusercontent.com/assets/12841723/23342746/31e11e70-fc60-11e6-94fe-89a04d54955f.png" width="300px" />
<br/>
*Fig. 2: All parties that are part of the OTA4J.*

### Context View Visualisation
Taking the issues mentioned above and our initial stakeholder analysis into account, we created a context view of the
system, as is visible in Fig. 3.

![Context View](https://cloud.githubusercontent.com/assets/12841723/25781903/140581ea-3340-11e7-9d7e-64852c82c560.png)
<br/>
*Fig. 3: The context view for  JUnit 5.*

You can see the main contributors of JUnit 5 (and to a certain extent JUnit 4) as the most important stakeholders, 
because they decide which features are included and are not. 
Furthermore we have decided to include American Express as an acquirer because they were one of the main sponsors of the
Indiegogo campaign that initiated the development of JUnit 5 as mentioned before. We have also included Pivotal as 
acquirer because they were one of the main contributors to the Indiegogo campaign; they contributed cash as well as 6 weeks
of developer time for the development of lambda <a href="#35">[35]</a>.

Noteworthy is the relation between JUnit 4 and JUnit 5 as respectively predecessor and successor, we talk about this
in more detail in the evolution perspective. We have tried to
visualise the relation between the two versions of the framework and the IDEs in light of the API that JUnit provides
for them. You can also see there are a great many 'Ecosystem enhancers'. These are frameworks or plug-ins that use
JUnit and provide additional functionality, support or integration options. The relationships between ecosystem enhancers 
themselves shift greatly with the introduction of JUnit 5, allowing them to work together in a better way.
More information on groups of stakeholders can be found in our stakeholder analysis.

<a name="functional-view" ></a>
## Functional View

### Capabilities
From the JUnit 5 user guide three key capabilities can be found <a href="#16">[16]</a>.

1. The JUnit Platform serves as a foundation for launching testing frameworks on the JVM. It also defines the TestEngine API for developing a testing framework that runs on the platform.
2. JUnit Jupiter is the combination of the new programming model and extension model for writing tests and extensions in JUnit 5.
3. JUnit Vintage provides a TestEngine for running JUnit 3 and JUnit 4 based tests on the platform.

JUnit 5 should be able to run all sorts of tests on the JVM,
including those from other frameworks. It also provides its own new test engine
with new features and extension possibilities. JUnit 5's approach must
be able to support the older versions of JUnit as well. We will now introduce architectural principles that we think 
may have driven the design.

1. **Backwards compatibility** and migration are required for JUnit 5's adoption.
2. Any entity integrating with JUnit 5 should do so in a **loosely coupled** manner.
3. Key stakeholders should be provided with a **dedicated interface** for their tasks.
4. **Minimal dependencies** to further drive loose coupling.



### External Interfaces
In Fig. 4 one can identify three external interfaces:

1. jupiter-api
2. junit-4
3. build-tool-plugins

![figure](https://cloud.githubusercontent.com/assets/12841723/24616791/6511e574-1892-11e7-8a48-5e65dfd6d238.png)<br/>
*Fig. 4 External interfaces of JUnit 5.*

We will now discuss the responsibilities and the philosophy underlying the design of each of these interfaces by 
applying the architectural principles we identified.

Firstly we consider the jupiter-api. jupiter-api strictly follows the minimal dependency principle. This interface 
therefore only contains a declarative API without implementation.

Secondly, the JUnit 4 interface violates the minimal dependency principle. JUnit 4 is a rather fat dependency, but it is 
still provided as an external interface due to the backwards compatibility principle. This indicates that the JUnit 
architects consider backwards compatibility to be more important than minimal dependencies.

Lastly, the dedicated interface principle applies when we consider the build-tools. In JUnit 4 build-tool integration 
was not taken into consideration. Because the dedicated interface principle was judiciously applied this 
relationship has now rigorously changed. We highlight here that it is an architectural principle of importance and discuss
the effects in the evolution perspective. <br/>
The build-tools also adhere to the minimal dependency principle; they consist of a different and minimal dependency for 
every build-tool JUnit wishes to integrate with.

There is another external interface that is a bit harder to identify. It currently is not an external interface, but will become 
one in the future. When the build-tool-plugins migrate to their owners, they will depend on the 
launcher module. The launcher module will then become an external interface. <br/>
In this case the loose coupling principle becomes key, this principle has been mainly instated to avoid the situation 
in JUnit 4 (see evolutionary perspective).

<a name="development-view" ></a>
## Development View
This section consists of the development view of the JUnit 5 project. We have divided this
section into several subsections: module structures, development guidelines, and testing approach.


<a name="module-structures" ></a>
### Module Structures
Due to the size of JUnit 5,
the code has been split into four *sub-projects* <a href="#16">[16]</a>
and each of these consists of multiple *modules*.
Modules are parts of the code base that are related to each other and are therefore grouped together.
A sub-project is a group of these modules that are related and are therefore grouped together.

These sub-projects and modules were made to create a (for humans) logical structure of the code base,
granting three benefits:

1. It allows for a better understanding of the code base.
2. It gives better insight into the possible effects changes in one area of the code may have on other areas of the code.
3. It makes the code base easier to maintain.

This section consists out of two subsections, where we identify and classify the sub-projects and identify and discuss 
the module dependencies.

### Sub-projects
#### Open Test for Java (OT4J)
We discuss it as a sub-project, but will not dive deeper into a module analysis.

OT4J is an initiative from the JUnit team to provide a minimal common foundation for all testing frameworks <a href="#17">[17]</a>.
OT4J aims to provide the core abstractions of the testing domain.
For this reason it is a completely separate project from JUnit, but JUnit does depend on it.
The only core abstraction included so far is a common set of exceptions.
Introducing this common point should reduce the workload for integrators with all testing frameworks.

If all test frameworks adopt these exceptions, it should reduce the workload
for build tools that integrate with these test frameworks.

#### junit-platform
JUnit platform is the dedicated API for running and reporting JUnit tests.
It provides a single interface for running both JUnit jupiter and JUnit vintage tests.
It aims to be a more flexible and refined way for test-runners to integrate with JUnit 5 compared to JUnit 4.

#### junit-jupiter
JUnit jupiter is the new end-user facing functionality.
This functionality consists of new features for testers and
a more composition-friendly extension model for the eco-system-enhancers.

#### junit-vintage
JUnit vintage is a reincarnation of JUnit 4,
however its tests are run through a JUnit platform compatible engine allowing it to be executed through the junit-platform.

### Module dependencies
In this section we will view the dependencies between the JUnit model through a more conceptual model that
we created, which allows us to focus more on the key dependencies between the modules,
allowing for a more thorough understanding of the system. The JUnit 5 code base has been split into twelve different 
modules. Detailed information about all different modules in the JUnit 5 framework can be found in the 
user guide <a href="#18">[18]</a>.

Note that there is no layering of different abstraction levels found on the module level in JUnit 5.
Rather, each module contains their own abstraction levels from high to low and as such there
is no real layer system in JUnit 5. This is why there will be no subsection dedicated to the layering.

In Fig. 5 you can see our conceptual module dependency model (the official dependency diagram can be found in the JUnit 
5 user guide <a href="#19">[19]</a>).

![Module layers](https://cloud.githubusercontent.com/assets/12841723/23588659/02ebe170-01c1-11e7-89e1-bb3a6a050e96.png)
<br />
*Fig. 5: The module dependency model for JUnit 5.*

This model illustrates the key dependencies between the modules and organises the modules by the concerns they address.

1. **Testrunner:** Integration of test runners with the JUnit platform.
2. **Engine:** Implementation of these testing features and its integration with the JUnit platform.
3. **User facing:** Provides the API for end users for testing with a particular engine.


<a name="development-guidelines" ></a>
### Development Guidelines, Rules and Releases
In this section we'll zoom in on the policy revolving around the development of JUnit 5. When a contributor wants to
contribute new code to the JUnit 5 project they have to adhere to certain rules. 

#### Source code structure
When looking at the source code structure of the JUnit 5 project you can clearly recognise the same structure that has
been discussed in the section on module structures.
Every module has its own corresponding Gradle <a href="#20">[20]</a> module in the project.


![JUnit project view IntelliJ IDEA](https://cloud.githubusercontent.com/assets/12841723/23587310/954ca0c6-01a9-11e7-8927-9e4322febdb7.png)
*Fig. 6: Project view of JUnit 5 in IntelliJ IDEA.*

In the project view of for instance IntelliJ (see Fig. 6) you can see the module structure of the entire project.
In each module there is a separate `module-name.gradle` file that contains a list of all other modules that your module
depends on. This gives contributors a quick overview of what code the module they want to modify depends on.

#### Coding conventions
The first, most elemental thing you should take into consideration when contributing to JUnit 5, is the way the code
you write is structured. You should make sure that your code is written in the same style as existing code, 
otherwise you will introduce style discrepancies in the project. All the exact style rules are written down in the
`contributions.md` file on the JUnit 5 repository <a href="#21">[21]</a>.
JUnit 5 offers a file with 'formatter settings' that can be used in several IDEs. If the formatter settings are
imported from the file and used for contribution they will automatically be formatted appropriately. Apart from this
formatter, you can locally use `./gradlew check` as well. This check runs the so-called 'spotless' plug-in as well as
checkstyle. The spotless plug-in can also automatically add the correct licences to files with the
`./gradlew spotlessApply` command, this is a separate action though and does not happen during `./gradlew check`.
This takes away some tedious work from the developer as licences can differ per file.

#### The release process
JUnit 5 has no fully automated releases but does feature an automated release process. When looking at the
`gradle.build` file in the root of the JUnit 5 repository, we see that there is a section dedicated to the deployment of
JUnit 5 to the Maven Central Repository <a href="#22">[22]</a>. The deployment sequence has to be initiated
manually though. <br />
In the roadmap document on the repository the JUnit 5 architects
describe several phases in the development of JUnit 5 <a href="#23">[23]</a>. They intend to release a new version of JUnit 5 after each
of these phases has been completed. The project is currently in *phase 5*, which means that an initial Alpha version
of JUnit 5 has been released and more work is being done on additional milestones <a href="#24">[24]</a>. When searching on
Maven Central <a href="#25">[25]</a> there are already three milestone releases to be found. The next milestone release
(Milestone 4) is planned to be completed by March 18th 2017 <a href="#26">[26]</a>.
After this milestone there will at least be one more milestone to be completed. After that the project will be almost
ready for a production release and the architects will prepare for this by releasing one or more so-called
'release candidates' before making a 'GA' release. In Fig. 7 the development and release stages are
illustrated.

<a name="roadmap"></a>
<img alt="Roadmap" src="https://cloud.githubusercontent.com/assets/12841723/23580032/210a5316-00fa-11e7-8253-396d732e2d92.png" width="400px" />
<br/>
*Fig. 7: The roadmap for the development of JUnit 5.*

<!--
#### JUnit 5 configuration management
Configuration management is described in the book 'Software Systems Architecture' as the set of tools and structures 
that are used by a project to have some form of configuration control <a href="#1">[1]</a>. 
The JUnit 5 team uses git <a href="#27">[27]</a>, as their main configuration
manager. Git allows for branching, labels and version control. Typically, new features or fixes are implemented on new
branches that are merged to the master branch after they have been checked by an integrator and once they adhere to the
DoD mentioned above. Releases are typically tagged and deployed from the master branch. Git sees each commit as a
different version (or variant) of the program, so switching between commits and / or branches allows different versions
of the program to exist next to each other.
-->

<a name="test-approach" ></a>
### The JUnit 5 Test Approach ##
The testing approach used in JUnit 5 is peculiar, and therefore has its own section.
This section combines information from the development guidelines and the module structure.
The development guidelines specify that every change needs to be covered by tests.
However, as a developer, finding the correct place in the project to implement these tests is difficult,
and requires technical information about the dependencies between the JUnit 5 modules.

In this section we will first say something about the process that the developers of JUnit 5 used
to improve their testing framework without having to release it first.
The next section clarifies the dependencies between several different modules and explicates why
tests are not always in intuitive places in JUnit 5.

#### Development feedback cycle ###
In order to create useful features, the JUnit 5 team, like every other development team,
needs end-user feedback.
Testing JUnit 5 *with* JUnit 5 allowed the developers to turn themselves into end-users and receive
this feedback early on.
Using their own features gives the developers first-hand experience
and allows them to immediately determine whether their creations are useful and easy to work with,
essentially creating a feedback loop. Of course the early milestone releases also play a key role by providing extra feedback.
Another benefit of this testing approach is that every test case written by the team,
doubles as an end-to-end test for the system, providing extra coverage and confidence in the system.

#### Module dependencies ###
The testing approach also comes with a downside.
It complicates certain dependencies between modules, resulting in the tests for certain modules
ending up in odd locations.

It is the intention of the JUnit 5 team to design the JUnit platform in such a way that
it will be used by many future versions of JUnit.
Testing JUnit platform and JUnit jupiter *with* JUnit jupiter minimises the dependency on JUnit 4,
and would facilitate dropping JUnit 4 in the future (if desired).

First we will take a look at the actual dependency diagram given by JUnit, visible in Fig. 8.
![Dependency Diagram](https://cloud.githubusercontent.com/assets/12841723/24617538/7c1e2712-1894-11e7-9c34-4215cc406eb4.png)
*Fig. 8: The dependency graph of JUnit 5 <a href="#19">[19]</a>*

Testing with JUnit jupiter requires three dependencies:

1. The `junit-jupiter-api`.
2. The `junit-jupiter-engine`.
3. The `junit-gradle-plugin` and its transitive dependencies.

With these dependencies in mind, we will take a look at writing tests for JUnit.

##### JUnit jupiter ####
Test for the `junit-jupiter-api` module do exist, but they are not present in the module itself.
The tests for the `junit-jupiter-api` module reside in the `junit-jupiter-engine` module.
The reasons why these tests are located here rather than in the `junit-jupiter-api` module is that the
`junit-jupiter-engine` depends on the `junit-jupiter-api`.
This means that if the tests for the `junit-jupiter-api` were placed in the `junit-jupiter-api` module itself,
a dependency on the `junit-jupiter-engine` would need to be added in the `junit-jupiter-api` module to be able to run these tests.
This would result in a circular dependency, which can also be seen in the dependency diagram if an arrow
would be added originating from `junit-jupiter-engine` travelling to `junit-jupiter-api`.

The `junit-jupiter-engine` module already depends on the `junit-jupiter-api` module; the same goes for 
`junit-jupiter-params`.
Tests can depend on the production code of their own module satisfying the dependency on the `junit-jupiter-engine`.
The dependency graph shows that nothing in the `junit-platform` sub-project depends on `junit-jupiter sub-project`,
allowing us to depend on `junit-platform` without introducing any cycles.

##### JUnit platform ####
Since JUnit is built using Gradle <a href="#20">[20]</a>, all tests are run through the `junit-gradle-plugin`
(listed as the third dependency required for writing tests).
The dependency diagram shows that every module, with the exception of the `junit-platform-surefire-provider`
and `junit-platform-runner`, are either direct or transitive dependencies of the `junit-platform-gradle-plugin`.
If any of these modules were to contain any tests it would introduce a dependency cycle.

To combat this phenomenon, JUnit has extracted one more module (not present in this diagram); `junit-platform-tests`.
This module has no production code and only contains test code. It contains the tests for the following
junit-platform modules: *commons*, *console*, *engine*, *launcher* and *runner*. Of the two modules that are not dependent on the `junit-gradle-plugin` (*runner* and *surefire-provider*),
the `maven-surefire-provider` module is the only one that hosts its own tests. 
The `junit-suite-api` only contains annotations and has no tests.
This leaves us with two modules in the diagram that still need to be covered:

1. `junit-vintage-engine`
2. `junit-migration-support`

The `junit-vintage-engine` and the `jupiter-migration-support` can both safely depend on the gradle plugin
(just like the `junit-jupiter-engine`) and can host their own tests.
Finally, several modules depend on JUnit 4, but all of JUnit 4's tests are contained in JUnit 4's own project.


<a name="evolution-perspective" ></a>
## Evolution Perspective
JUnit 5 is the next generation of JUnit. The goal is to create an up-to-date foundation for developer-side testing on
the JVM <a href="#28">[28]</a>. Its development can be nicely argued for from an architectural standpoint, it
resolves limitations present in JUnit 4. The architects of JUnit have identified several shortcomings of JUnit 4 over the
years and have tried to address them as best as possible in the new version of JUnit. 

### Problems in JUnit 4
Normally in projects the size of JUnit, technical debt is a key factor inclines developers to rewrite their software
product, but in the case of JUnit there is fairly little internal technical debt. 
The technical debt in the production code, considering the size of the project, is very limited in both JUnit 4 and JUnit 5.
We were unable to discover any major issues on technical debt in the production code.
Both versions of the framework are also very well tested, JUnit 4 has 89% line coverage, and JUnit 5 has an even higher
coverage of 95.5% making the project extremely well tested <a href="#29">[29]</a>.

With technical debt out of the picture the two the key issues in JUnit 4
that are addressed with the development of JUnit 5 are:
 1. IDE integration
 2. Extension Model

#### IDE integration
IDE integration is vital for a testing frameworks survival, however the way in which this integration is achieved in
JUnit 4 leaves a lot to be desired. Many tools reach deeply into JUnit for their functionality, using clever hacks to
get past what little boundaries are present, resulting in an ad hoc, undocumented and brittle API. Keeping this brittle
API intact severely limits any kind of development on JUnit. This situation came to pass because JUnit 4 neglected IDEs
as an important stakeholder for their framework and did not provide proper integration options for the IDEs. Because
of the significant market share JUnit 4 has, this resulted in the IDEs getting the information they desired on their
own. To emphasise this problem we can look at JUnit 4 issue 444 <a href="#31">[31]</a>.
This issue calls for an exhaustive listener framework in JUnit that could be utilised by IDEs. This issue has been
created in 2012 (while JUnit 4 has been around since 2005) and is still opened. Therefore we can conclude that this
issue has not been solved for JUnit 4 as of now (and may never be). <br />
In JUnit 5 this problem has been resolved by loose coupling and dedicated interfaces as is described in the functional
view.

#### Extension model
The most powerful extension possibility present in JUnit 4 is a TestRunner. It gives a lot of control how tests are run
and has been a key to the success for integrating other tools. As can be seen in our stakeholder analysis there is a
vast amount of libraries and, as we call them, 'ecosystem enhancers', providing their functionality by extending JUnit.
These tools are successful in enriching JUnit by providing additional functionality, indicating their individual needs
as stakeholders have been met. Many of these tools use the test runner to achieve their goals. However JUnit 4 comes
with a limitation: each test suite can only utilise a single test runner. This makes different tools that solve
different problems compete for the runner for no reason. This results in tools with completely different goals being
unable to function in combination with each other. JUnit 5 introduces a new extension model that allows tools to work
together and even provide new functionality. Details on how the extension model of JUnit 5 solves the problem
can be found in the user guide <a href="#34">[34]</a>.

### The road from JUnit 4 to JUnit 5
To address the architectural issues in JUnit 4, the JUnit team readjusted their stakeholder priorities.
This can be seen in the JUnit Lambda kickoff  <a href="#12">[12]</a> which had IDE
and build tool owners present to discuss the first start of the work on JUnit 5. Further evidence can be found in the 
communication between the JUnit team and Mockito <a href="#13">[13]</a>, where the JUnit team discusses the concerns 
of Mockito in their new extension models and tries to
incorporate Mockito's needs. While this issue is currently a hot topic, there are issues that date back further where
extension points in JUnit 4 and 5 are discussed <a href="#14">[14]</a>
<a href="#15">[15]</a>.

To further elaborate on the relationship between JUnit 4 and JUnit 5 and the effect this migration will have on the
ecosystem we want to highlight a few important decisions made by the architects.
To limit the impact of the transition from JUnit 4 and JUnit 5 for end user and ecosystem enhancers, the architects of
JUnit have created a dedicated migration support platform. Users are able to use a combination of JUnit 4 and JUnit 5
tests during a transition period using this system. This way they won't have to adjust all of their tests overnight.
JUnit 4 lives on in the JUnit platform as JUnit Vintage.

You can see a flow chart that visualises the transition from JUnit 4 to JUnit 5 in Fig. 9.

![Transition Flow Chart](https://cloud.githubusercontent.com/assets/12841723/24618222/b5fd3ea8-1896-11e7-9388-1389a093761a.png)
<br />
*Fig. 9: A flowchart of the transition from JUnit 4 to JUnit 5 for a typical system.*

JUnit secures its future by upgrading their build dependency from Java 1.5 to Java 1.8 
<a href="#30">[30]</a>. While it is perfectly possible to use JUnit 4 in
combination with Java 1.8, this upgrade allows the JUnit team to use Java 1.8 while developing JUnit 5, thus allowing
them the use of lambdas, optionals and new types in the standard library among other things. <br/>
These new features and solutions ensure that JUnit 5 will become just as versatile and loosely coupled as envisioned by
the JUnit architects.

<a name="conclusion" ></a>
## Conclusion
Even though JUnit 5 is still in development at the time of writing and has yet to see
the first official release, it has already accomplished a lot.
In according with their vision, the JUnit team was able to create a solid
foundation which solves the architectural problems JUnit 4 was facing.
JUnit 5 already supports most of the features of JUnit 4 and has improved and added
features on top of that. The support for JUnit 4 eases the transition from JUnit 4
to JUnit 5 and as a result, we can expect more and more projects to do so.

The JUnit 5 team also managed to keep the code base of the project extremely clean,
accumulating negligible amounts of technical debt and maintaining an extremely high
testing coverage (average of 95.5%).
These high standards reflect their desire to create a lasting foundation,
and shows their perseverance in accomplishing it.

In our opinion, the JUnit 5 team is on the right track towards realising their vision.
We have no doubts that the JUnit 5 team will be successful due to how far they have
managed to come and the quality of work they have been able to maintain during this period.

We look forward towards the official release and public adoption of the JUnit 5 project.

## References
<a name="1" ></a> 
1. Nick Rozanski and Eoin Woods. 2012. 
Software Systems Architecture: Working with Stakeholders Using Viewpoints and Perspectives. Addison-Wesley Professional. <br/>
<a name="2" ></a> 
2. JUnit lambda campaign, 
[http://junit.org/junit4/junit-lambda-campaign.html](http://junit.org/junit4/junit-lambda-campaign.html), access date: 30-03-2017 <br/>
<a name="3" ></a> 
3. The Java programming language licence, 
[http://www.oracle.com/technetwork/java/javase/terms/license/index.html](http://www.oracle.com/technetwork/java/javase/terms/license/index.html), access date: 30-03-2017 <br/>
<a name="4" ></a> 
4. The Apache surefire licence, 
[https://maven.apache.org/surefire/](https://maven.apache.org/surefire/), access date: 30-03-2017 <br/>
<a name="5" ></a> 
5. The Gradle licence, 
[https://github.com/gradle/gradle/blob/master/LICENSE](https://github.com/gradle/gradle/blob/master/LICENSE), access date: 30-03-2017 <br/>
<a name="6" ></a> 
6. The JUnit 5 licences on Github, 
[https://github.com/junit-team/junit5/blob/master/LICENSE.md](https://github.com/junit-team/junit5/blob/master/LICENSE.md), access date: 30-03-2017 <br/>
<a name="7" ></a> 
7. The JUnit 5 user guide, 
[http://junit.org/junit5/docs/current/user-guide/](http://junit.org/junit5/docs/current/user-guide/), access date: 30-03-2017 <br/>
<a name="8" ></a> 
8. Stack Overflow, 
[http://stackoverflow.com/](http://stackoverflow.com/), access date: 30-03-2017 <br/>
<a name="9" ></a> 
9. Issues for JUnit 5 on Github, 
[https://github.com/junit-team/junit5/issues](https://github.com/junit-team/junit5/issues), access date: 30-03-2017 <br/>
<a name="10" ></a> 
10. Sam Brannen pitch about JUnit, 
[https://www.youtube.com/watch?v=UHN_HcjZa7o](https://www.youtube.com/watch?v=UHN_HcjZa7o), access date: 30-03-2017 <br/>
<a name="11" ></a> 
11. Statistics about package use in Java projects on Github, *Google*, 
[https://cloud.google.com/bigquery/public-data/github](https://cloud.google.com/bigquery/public-data/github), access date: 30-03-2017 <br/>
<a name="12" ></a> 
12. JUnit lambda campaign on Indiegogo,
[https://www.indiegogo.com/projects/junit-lambda#/](https://www.indiegogo.com/projects/junit-lambda#/), access date: 30-03-2017 <br/>
<a name="13" ></a> 
13. Issue on Mockitos Github with communication with JUnit 5 stakeholders, 
[https://github.com/mockito/mockito/issues/445](https://github.com/mockito/mockito/issues/445), access date: 30-03-2017 <br/>
<a name="14" ></a> 
14. Pull Request 1158 on the JUnit 4 Github, 
[https://github.com/junit-team/junit4/pull/1158](https://github.com/junit-team/junit4/pull/1158), access date: 30-03-2017 <br/>
<a name="15" ></a> 
15. Issues 1161 on the JUnit 4 Github repository, 
[https://github.com/junit-team/junit4/issues/1161](https://github.com/junit-team/junit4/issues/1161), access date: 30-03-2017<br/>
<a name="16" ></a> 
16. JUnit 5 user guide, JUnit 5 overview, 
[http://junit.org/junit5/docs/current/user-guide/#overview-what-is-junit-5](http://junit.org/junit5/docs/current/user-guide/#overview-what-is-junit-5), access date: 02-04-2017<br/>
<a name="17" ></a> 
17. Open Testing Alliance for the JVM,
[https://github.com/ota4j-team/opentest4j](https://github.com/ota4j-team/opentest4j), access date: 02-04-2017<br/>
<a name="18" ></a> 
18. JUnit 5 user guide, dependency metadata, 
[http://junit.org/junit5/docs/current/user-guide/#dependency-metadata](http://junit.org/junit5/docs/current/user-guide/#dependency-metadata), access date: 02-04-2017<br/>
<a name="19" ></a> 
19. JUnit 5 user guide, dependency diagram, 
[http://junit.org/junit5/docs/current/user-guide/#dependency-diagram](http://junit.org/junit5/docs/current/user-guide/#dependency-diagram), access date: 02-04-2017<br/>
<a name="20" ></a> 
20. Gradle, 
[https://gradle.org/](https://gradle.org/), access date: 02-04-2017<br/>
<a name="21" ></a> 
21. JUnit 5 repository on Github, contributions.md, 
[https://github.com/junit-team/junit5/blob/master/CONTRIBUTING.md](https://github.com/junit-team/junit5/blob/master/CONTRIBUTING.md), access date: 02-04-2017<br/>
<a name="22" ></a> 
22. Maven Central Repository, 
[http://central.sonatype.org/](http://central.sonatype.org/), access date: 02-04-2017<br/>
<a name="23" ></a> 
23. JUnit 5 road map, 
[https://github.com/junit-team/junit5/wiki/Roadmap](https://github.com/junit-team/junit5/wiki/Roadmap), access date: 02-04-2017<br/>
<a name="24" ></a> 
24. JUnit 5 milestones,
[https://github.com/junit-team/junit5/milestones](https://github.com/junit-team/junit5/milestones), access date: 02-04-2017<br/>
<a name="25" ></a> 
25. JUnit 5 milestones released on Maven,
[https://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22org.junit.jupiter%22%20AND%20a%3A%22junit-jupiter-engine%22](https://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22org.junit.jupiter%22%20AND%20a%3A%22junit-jupiter-engine%22), access date: 02-04-2017<br/>
<a name="26" ></a> 
26. JUnit 5 Milestone 4 on Github,
[https://github.com/junit-team/junit5/milestone/7](https://github.com/junit-team/junit5/milestone/7), access date: 16-03-2017<br/>
<a name="27" ></a> 
27. Git,
[https://git-scm.com/](https://git-scm.com/), access date: 02-04-2017<br/>
<a name="28" ></a> 
28. JUnit 5 homepage,
[http://junit.org/junit5/](http://junit.org/junit5/), access date: 02-04-2017<br/>
<a name="29" ></a> 
29. JUnit 5 test coverage by Clover,
[https://junit.ci.cloudbees.com/job/JUnit5/clover/dashboard.html](https://junit.ci.cloudbees.com/job/JUnit5/clover/dashboard.html), access date: 02-04-2017<br/>
<a name="30" ></a> 
30. JUnit 4 dependencies,
[http://junit.org/junit4/dependencies.html](http://junit.org/junit4/dependencies.html), access date: 02-04-2017<br/>
<a name="31" ></a> 
31. JUnit 4 issue 444 on Github,
[https://github.com/junit-team/junit4/issues/444](https://github.com/junit-team/junit4/issues/444), access date: 02-04-2017<br/>
<a name="32" ></a> 
32. JUnit 5 release date,
[https://github.com/junit-team/junit5/milestone/10](https://github.com/junit-team/junit5/milestone/10), access date: 02-04-2017<br/>
<a name="33" ></a> 
33. OTA4J usage licence,
[https://github.com/ota4j-team/opentest4j/blob/master/LICENSE](https://github.com/ota4j-team/opentest4j/blob/master/LICENSE), access date: 03-04-2017<br/>
<a name="34" ></a> 
34. The JUnit 5 user guide, extensions,
[http://junit.org/junit5/docs/current/user-guide/#extensions](http://junit.org/junit5/docs/current/user-guide/#extensions), access date: 03-04-2017<br/>
<a name="35" ></a> 
35. Tweet on Indiegogo sponsoring by Sam Brannen,
[https://twitter.com/sam_brannen/status/861202719293530113](https://twitter.com/sam_brannen/status/861202719293530113), access date: 07-05-2017<br/>



<!--
<a name="x" ></a> 
16. JUnit 5 user guide, launcher API, 
[http://junit.org/junit5/docs/current/user-guide/#launcher-api](http://junit.org/junit5/docs/current/user-guide/#launcher-api), access date: 02-04-2017<br/>
<a name="x" ></a> 
17. The facade design pattern on Source Making, 
[https://sourcemaking.com/design_patterns/facadeg](https://sourcemaking.com/design_patterns/facade), access date: 02-04-2017<br/>
<a name="x" ></a> 
18. The factory pattern, 
[http://my.safaribooksonline.com/book/software-engineering-and-development/patterns/0596007124/4dot-the-factory-pattern-baking-with-oo-goodness/simple_factory_defined_html](http://my.safaribooksonline.com/book/software-engineering-and-development/patterns/0596007124/4dot-the-factory-pattern-baking-with-oo-goodness/simple_factory_defined_html), access date: 02-04-2017<br/>

-->