
<div id="figure1"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/syncthinglogo.png" alt="Syncthing" width="650"/>
</p>

# Syncthing: Open Source Continuous File Synchronisation
By Jayachithra Kumar, Lidia Fernandez, Robert Carosi, Sacheendra Talluri

# Abstract

Syncthing is an application that enables users to synchronise files across different devices. The application is actively maintained and developed by a relatively small group of developers. The foci of the application are preventing data loss, security from attackers and ease of use. Through our analysis, we found that the simplicity of the architecture, consisting of three major layers, allows for easy addition of features while still maintaining the robustness of the core layer consisting of the synchronisation logic. In general, we observe that Syncthing is a well engineered project without glaring technical holes or major debt. 

# Table of Content

* [Introduction](#intro)
* [Views](#views)
	* [Stakeholders View](#stake)
	* [Context View](#conte)
	* [Information Viewpoint](#info)
* [Models](#model)
	* [Module Structure Model](#modul)
	* [Common Design Model](#commo)
	* [Codeline Model](#codel)
	* [Usability Perspective](#usabi)
* [Technical Debt](#techni)
	* [Identifying Technical Debt](#ident)
	* [Identifying Testing Debt](#identt)
	* [Evolution of Technical Debt](#evolu)
* [Conclusion](#conclu)
* [References](#refer)

# Chapter - Syncthing

<div id="intro"></div>

## Introduction

Syncthing is a software application used for synchronising files across devices. As its major purpose is reliable transport of information, we considered it to be a software worth studying. In our study, we document and analyse the engineering process of Syncthing. We hope it will provide the readers a resource to look at while building a software of similar nature. That is, software which deals with user data of utmost importance and is responsible for tasks critical for the safety of the data such as backups. 

Our analysis consists primarily of three parts. The first part deals with the different views of the system. The views give an understanding of the socio-technical environment the system operates in. They also give an understanding of the basic principles the system is organised around. The second part gives a more technical description of the system. It consists of different models and a perspective which show the technical design of the system and the decisions that went into that design. The last section is about technical debt. Any software which has been around for sometime builds up technical debt. How the debt is managed is what makes this section interesting. 

<div id="views"></div>

## Views

<div id="stake"></div>

### Stakeholder View

**Users** use Syncthing to synchronise their files across different devices. We believe it has a significant amount of users. We extrapolate this from the data found here[[1](#userdata)] and also from the number of stars on the Github repository. When last checked, Syncthing had 22919 daily active users with reporting enabled and 15106 stars. 

**Developers** contribute code to the project. The most active developers to the project are @[calmh](https://github.com/calmh) and @[AudriusButkevicius](https://github.com/AudriusButkevicius). @[calmh](https://github.com/calmh) is also the **founder**. Occasionally, other developers contribute big features but are not really active after that. The whole list of current developers can be found in this file[[3](#authors)]. 

@[calmh](https://github.com/calmh) and @[AudriusButkevicius](https://github.com/AudriusButkevicius) also have the **maintainer** status. So, they are responsible for the direction the software is going to evolve in. They would also be the de facto **assessors** and **integrators** as they are responsible for any pull request being merged and the overall quality. Specifically, the challenges faced by the **integrators** and how they assess the pull requests is covered in the `Contributions` section of the `Codeline Model`. 

The **testers** category is an interesting category as the **developers** themselves are the testers in most cases. The maintainers don't accept code without any associated tests[[4](#notests)]. There are also a group of beta testers composed of users and developers. The list can be found here[[5](#betatesters)]. 

The **communicators** category primarily consists of the 2 maintainers and a user named @[rumpelsepp](https://github.com/rumpelsepp). They maintain the documentation up-to-date. There are also several others[[6](#scribes)] who have contributed to the documentation who can be grouped under this category. 

The **support staff** consists of people who answer questions in the support section of the forum and on the IRC channel. It consists of the maintainers and a few others active on the forum[[7](#support)]. Other members of the community, like users, help each other using the forum. 

@[calmh](https://github.com/calmh) is a de facto **system administrator** for Syncthing instances that use the public discovery server. It is also possible to use Syncthing without using the public discovery server. In that case, whoever is hosting the discovery server used by that Syncthing instance becomes the **system administrator**. As Syncthing is a low level long running system service. All **users** also share the role of **system administrator** in some capacity. 

Kastelo is the official corporate **sponsor** of Syncthing. It is a company founded by the maintainer of Syncthing, @[calmh](https://github.com/calmh). It offers consultancy services and trainings related to Syncthing. 

The Syncthing community provides public relay servers so that people behind firewalls can use Syncthing. These servers can be found here[[8](#relays)]. The operators of these servers are **suppliers** who supply the infrastructure required for the people behind firewalls to use Syncthing. 

Syncthing is built using the Go programming language. It uses AngularJS for its default front-end and Jenkins for continuous integration. It also uses several major and minor libraries[[9](manifest)]. The communities and companies behind all these projects can be considered software **suppliers** in a loose sense. 

There are also applications **dependent** on Syncthing for their own functionality. The developers and users of these applications depend on Syncthing to provide the required functionality. Examples include [syncthing-inotify](https://github.com/syncthing/syncthing-inotify), developed by @[Zillode](https://github.com/Zillode)  and [SyncTrayzor](https://github.com/canton7/SyncTrayzor), developed by @[canton7](https://github.com/canton7). 

Syncthing has several **competitors**. Its open source competitors include [Librevault](https://github.com/Librevault/librevault) and several [rsync](https://rsync.samba.org/) based solutions. A popular closed source but distributed file syncronisation service is [BTSync/Resilio](https://www.resilio.com/). Its most popular **competitors** would be [Dropbox](https://www.dropbox.com/), [Google Drive](https://www.google.com/drive/) and others. 

The influence various stakeholders have on the project can be seen in [Figure 1](#figure1).

<div id="figure1"></div>

![](/syncthing/images-syncthing/power-interest.png)

*Figure 1: Power interest diagram*

<div id="conte"></div>

### Context View
The context view describes the relationships, dependencies, and interactions between the system and its environment. For this purpose, we will determine the scope of Syncthing and we will analyse the external entities and services that interact with it. In Figure 3 we provide a visual overview of the different entities that we are going to describe in this section.

<div id="figure2"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/context-view.jpg" alt="Context View" width="650"/>
</p>

*Figure 2: Visual representation of Syncthing’s context view*

There are multiple external entities that Syncthing interacts with. Analysing its dependencies, we find that Syncthing’s core is written in [Go](https://github.com/syncthing/syncthing/blob/master/GOALS.md), while its frontend is written in [Angular](https://angularjs.org). In addition, they have used [Ginkgo](https://onsi.github.io/ginkgo/) as Go testing framework. As for the database, Syncthing uses [LevelDB](https://github.com/google/leveldb), which provides key-value storage. Syncthing also makes use of certain tools for Continuous Integration. Among them, the most important are Jenkins to perform test and MergeBot for automatic merging of Pull Requests. Syncthing community is mainly active in Github, where they organise the work and milestones and publish bugs and features. In addition, they actively use a forum to discuss the project further and a [freenode](http://freenode.net) IRC channel.

<div id="info"></div>

### Information View

The information view tracks the flow of information through the system. In this view, the flow of data during different stages of operation of Syncthing is explained.

<p align="center">
	<img src="/syncthing/images-syncthing/information-flow.png" alt="Information Flow" width="650"/>
</p>

*Figure 3: Information Flow diagram with 2 devices*

#### Setup
When started for the first time on a device, Syncthing generates a Device ID. This is used to uniquely identify devices across the network. This network could be over the internet or a local network. It then broadcasts these IDs on the local network and also registers itself with a discovery server which is generally on the internet. This process is called announcing. Then it makes an index of all the files which are selected to be synchronized. 

#### Adding a device
As Syncthing is a synchronization tool, adding another device to which files are to be synchronized is an important part of operation. This can be done when the user informs the Syncthing instances on each device of the Device ID of the other device. The Syncthing instances then contact the Discovery server to identify the location of the other device. This is called Querying. Location of the other device can also be obtained by listening for the announcements from that device if both are on the same local network. After obtaining the location of the other device, the Syncthing instances are ready to synchronize. 

#### Synchronization
This stage is when the exchange of data takes place between the devices. The devices which are to be synchronized exchange the index of files they have. The index on each device is called the local model. The local models of the devices are exchanged and a global model is obtained at each device. This model is then used to synchronize files or updates to files using the Block Exchange Protocol. If possible, this takes place directly between the devices with the devices communicating and exchanging packets directly. But if the devices are not directly reachable (Possible if they are behind a NAT for example), Relay servers are used. When a relay server is in use, packets are first sent to the relay server which pushes them to the destination.

<div id="model"></div>

## Models

<div id="modul"></div>

### Module Structure Model

<div id="figure4"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/module_structure_model.png" alt="Structure Model" width="650"/>
</p> 

*Figure 4: Syncthing's directory structure*

The module structure model describes how the project is organised. [Figure 4](#figure4) is a high level UML component diagram of Syncthing. The project is organised into clearly identifiable layers with somewhat clear dependencies. Generally, the layer depicted above depends on the one depicted below it, but there are some dependencies which don't respect this boundary. 

The outer boxes represent layers. The inner boxes represent the individual components that form those layers. The arrows represent that the component at the tail of the arrow depends on the component at the head of the arrow. The Platform corresponds to the Go standard library and other external dependencies. The Library is where the major logic of Syncthing like the Block Exchange Protocol, used for exchanging data related to file changes, is implemented. The Command Line Tools are a collection of tools the users actually use to interact with the Syncthing library. The GUI consists of the web based GUI and the command line based GUI. 

The Syncthing server, discovery server, relay server and other miscellaneous components in the command line tools layer are the components users of Syncthing use to synchronise their files across devices. The Syncthing server is the one responsible for synchronising files across the user's devices in a peer to peer manner using the Block Exchange Protocol. The discovery server helps Syncthing servers find other Syncthing servers to synchronise with. The relay servers help Syncthing servers behind firewalls and NAT (Network Address Translation) enabled networks connect to each other. Other miscellaneous components are used to register a relay server with the Syncthing network, get information on files being synchronised by Syncthing and other purposes. 

The sync, discovery, protocol and database components in the library layer contain the core logic of Syncthing. The sync component calculates hashes of blocks of files and finds which ones to synchronise. The discovery component uses discovery servers to discover other Syncthing servers and also contains logic for creating a discovery server. The protocol component implements the Block Exchange Protocol which takes care of the key exchange for authorisation and encryption between Syncthing servers and also communicating information about which files need to be synchronised. The database component is used for interacting with the LevelDB database so that Syncthing can store information about other Syncthing servers, synchronised and unsynchronised files, block hashes and user preferences. 

The Go standard library, LevelDB and other miscellaneous libraries form the platform layer. These are used for encrypting network connections, calculating hashes, storing data and several other functions. 

<div id="commo"></div>

### Common Design Model

The common design model will cover aspects of the software where common design approaches and common software components were used. As Syncthing is written in Go (also referred to as golang), all practices in Effective Go[[11](#effgo)] are enforced. 

**Initialisation:** It refers to the steps a component is required to take before becoming fully functional[[12](#init)].

In Syncthing, all components are required to do the following during initialisation.
 
- Instantiate a logger object. This is done inside the `debug.go` which is present in every component. 
- `main.go` files are used as entry points for command line applications. In these files, the init function is used to store the build date, architecture of the system and golang version to be used for debugging. 
- In components with `main.go` files, the logger is initialised in the main function. 

**Termination and restart of operation:** It refers to the conventions to be followed when the program terminates either properly or due to an error. It also includes the subsequent steps taken for recovery during a restart. In golang, concurrency is handled through lightweight threads called goroutines. Each goroutine has its own stack trace. When a component exits due to an error, care is taken to ensure that the stacktraces of all the running goroutines are printed. If an issue such as database corruption is detected during restart the user is notified instead of silently logging to a file. 

**Message Logging and Instrumentation:** For the command line applications, the `log` package available in the golang standard library is used. For the main library, a custom logging package is implemented and this is imported and used by every package. The custom logger supports setting the name of the calling component during initialisation, printing it along with the error message. The [go-metrics](https://github.com/rcrowley/go-metrics) third party package is used for collecting performance metrics. [StatHat](https://www.stathat.com/) is used for collecting metrics such as daily active users. 

**Internationalisation:** It refers to the process of allowing the software to support artefacts for different locales. Multi language support was added to Syncthing in v9.0. Syncthing uses Transifex[[17](#transifex)] for internationalisation. Transifex generates JSON formatted files containing the available strings in the languages specified by the person building Syncthing. The Syncthing GUI dynamically loads these translations and uses string interpolation to insert them in the right places. The language can be configured in the configuration UI. 

**Processing configuration parameters:** In the Syncthing library, all configuration is passed through the universal configuration object. This object is passed to all components which can be configured and the components read what they require. They also subscribe to future changes in the object. In the command line application, configuration options are passed through command line flags using the `flags` package found in the golang standard library. Configuration can be passed to the library using JSON or XML config files. When configuration is changed using the GUI or command line tools, these files are also changed. 

**Database interaction:** The database used by Syncthing to store local data is LevelDB. LevelDB unlike SQL databases is a low level storage engine with a key-value interface. Concurrency primitives and other facilities such as transactions are implemented in the `db` component. So, any interaction with the database should go through the `db` component.

**Pull Requests and Issues:** Pull requests and issues follow specific formats defined in the files `PULL_REQUEST_TEMPLATE.md` and `ISSUE_TEMPLATE.md`. When a person either makes a pull request or opens an issue, GitHub displays these templates in the description to be filled[[13](#issuetempl)]. 

<div id="codel"></div>

### Codeline Model

Codeline Model is used to keep an order when it comes to the organization of the system code. In order to describe Syncthing’s Codeline Model, we will provide an overview of the source code structure and the contribution process, based in the information given in [[1]](#docs).

#### Source code structure

<p align="center">
	<img src="/syncthing/images-syncthing/directory-structure.jpg" alt="Directory Structure" width="650"/>
</p>

*Figure 5: Syncthing's directory structure*

In the source repository[[16]](#src) we can find a tree of various packages and directories. The actual code lives in the `cmd/syncthing`. `lib` directories -contains all packages that make up the parts of syncthing. The web GUI lives in `gui`. A detailed description of the structure can be found in [[15]](#docs).

#### Contributions 

In order to contribute to the project, developers should submit a pull request in the GitHub project. This pull request can belong to three different categories[[15]](#docs)- Trivial, Minor or Major- following semantic versioning[[2]](#semver). Depending on these categories, the pull request will follow different requisites before being accepted:
* Trivial: These may be merged without review by any member of the core team. 
* Minor: It can be merged on approval by any other developer on the core or maintainers team. 
* Major: It must be reviewed by a member of the maintainers team.

When tests are passed and the pull request is approved, it will be committed into the main code. After a commit, the next step is the launch of a release, which are again classified into three types[15]](#docs):
* A new patch release is made each Sunday, although serious bugs, that would crash the client or corrupt data, cause an immediate patch release.
* Minor releases are made when new functionality is ready for release. This happens approximately once every few weeks.
* A new major release happens when a whole product is ready. At the time of writing this book, it has not yet happened: the project hasn’t reached yet the 1.0.0 version.

During the whole contribution process, the project uses Github issues to track bugs, feature requests or any other requirements needed [[15]](#docs). Some issues are assigned to milestones, which are associated with future releases.

<div id="usabi"></div>

### Usability Perspective

The usability perspective aims to comprehend the ease with which people who interact with the system can work effectively[[14]](#book). This perspective addresses a wide range of loosely connected concerns such as the usability of User Interface, process flow around the system, information quality and architecture of the system. Usability perspective focuses on the end-users of the system, but also addresses the concerns of any others who interact with it directly or indirectly, such as developers, maintainers and support panel. In case of Syncthing, the success of the system depends on the effectiveness with which files can be shared and synchronised between devices on local network or between remote devices over the internet. By analysing the system usability we get an impression of what a Syncthing instance looks like and how it facilitates high usability. In this section we analyse the usability of Syncthing by identifying the users, touch points and the interaction between both.

#### Identifying Users
As the purpose of Syncthing is quite general, the user base of Syncthing cannot be narrowed down to a specific group of people. However, Syncthing has a large user base. From the latest information collected from [Syncthing usage data](https://data.syncthing.net/) we can see that Syncthing currently has 22919 users. Apart from regular users, Syncthing is also used by developers and maintainers for testing and providing support.

##### Identifying Touch points
Touch points are defined as places where a user may interact with the system. A Syncthing instance can be generally accessed through a web interface as shown in [Figure 6](#figure6). Since Syncthing has such a broad and diverse level of user base, Syncthing's user interface is kept simple to use and easy to navigate through.  

<div id="figure6"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/UI_syncthing.PNG" alt="Syncthing UI" width="650"/>
</p> 

*Figure 6: Syncthing home screen*

Syncthing developers divide the web UI into two main groups: folder view and device view.

#### Folder View
This is the left side of the interface shown in [Figure 6](#figure6), that shows the ID and the current state of all configured folders. Clicking on the folder name causes the section to expand to show more detailed folder information like its folder path and the devices that the folder is shared with. It also shows two buttons **Rescan** - for forcing a rescan, and **Edit** - for editing the configuration. Furthermore, a folder can be in any one of the following states: 
+ **Unknown** - while GUI is loading,
      
+ **Unshared** - when you have not shared this folder,
      
+ **Stopped** - when the folder has experienced an error,
      
+ **Scanning** - while Syncthing is looking in the folder for local changes,
      
+ **Up to Date** - when the folder is in sync with the rest of the cluster,

+ **Syncing** - when the device is downloading changes from network.

Among these folder details you can see the current "Global State" and "Local State" summaries as well as the amount of "Out of Sync" data if the folder state is not up to date. 

**Global State** 
This indicates how much data the fully up to date folder contains. This is basically the sum of the newest versions of all files from all connected devices. 

**Local State** 
This shows how much data the folder actually contains right now. This can be either more or less than the global state, if the folder is currently synchronising with other devices. 

**Out of Sync**
This shows how much data needs to be synchronized from other devices. This is basically the sum of all out of sync files - if you already have parts of such a file, or an older version of the file, less data than this will need to be transferred over the network.

#### Device View
This is the right side of the interface shown in [Figure 6](#figure6), that shows the overall state of all configured devices. The local device is always at the top with the remote devices in alphabetical order below. For each device you see its current state and when expanded, more detailed information. In the detailed information it shows the "Download Rate" and "Upload Rate". These transfer states are from the perspective of a local device, even those shown for remote devices. The rates for the local devices are the sum of those for the remote devices.

Apart from the different UI groups, since Syncthing is an open source platform that is used throughout the world, it should be able to provide support in different languages. Currently Syncthing provides translations in 35 different languages and developers are working to add more languages to the list. The preferred language can be chosen from the drop-down menu on the top right corner of the window.  

<div id="techni"></div>

## Technical Debt

<div id="ident"></div>

### Identifying Technical Debt

In this section we will provide an analysis of the technical debt of Syncthing. For this purpose, we will use an automatic tool for code quality analysis. We will describe in detail the most relevant issues and we will also indicate which parts of the project present high-priority technical debt that should be tackled.

#### Automated code quality analysis - Codebeat

[Codebeat](http://codebeat.co) is a tool for automatic code review. It gathers the result of code analysis into a single, real-time report that gives all project stakeholders the information required to improve code quality. Codebeat analysis is very thorough and it can be consulted at [https://codebeat.co/projects/github-com-syncthing-syncthing]. We won't include a complete description of the report in this document, but we will analyze some of the most representative results that may be of interest to assess the technical debt.

Codebeat organizes its reports in three sections: Complexity, Code Issues and Duplication.

* **Complexity**: In Codebeat, high complexity indicates part of code that contains too much logic and should be broken down into smaller pieces. It can also indicate that the few existing functions are each too busy and they need to be individually refactored. Namespaces with scores over 250 are considered to be high complexity. In [Figure 7](#figure7), we can observe that several namespaces have a high complexity, some of them even ten times over the minimum threshold. All of this issues should be urgently addressed.

<div id="figure7"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/technical-debt-complexity.png" alt="Technical Debt Complexity" width="650"/>
</p> 

*Figure 7: Fragment of namespaces ordered by complexity*

* **Code Issues**: In Codebeat, code issues analysis contains pieces of code that present several issues that can be improved. In this case, the number does not represent a score: it represents the number of issues found in the code. These issues can be related to too many lines of codes, too high number of functions, too many instance variables or too much block nesting. However, this metric does not represent necessarily a problem that needs to be addressed: it only indicates pieces of code that are not ideal, and that may need to be analysed. In [Figure 8](#figure8), we can see that `main` package and `model` library present several issues. These pieces of code would certainly need a revision to estimate how important are these issues and if they indeed pose a problem.

<div id="figure8"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/technical-debt-code-issues.png" alt="Technical Debt Code Issues" width="650"/>
</p>

*Figure 8: Fragment of namespaces ordered by code issues*

* **Duplication**: In Codebeat, this metric gives suggestions of duplicated pieces of code that should be redesigned to avoid this issue. Although we can see several cases in [Figure 9](#figure9), if we dive deeper in the [Codebeat full analysis](https://codebeat.co/projects/github-com-syncthing-syncthing), we can see that none of the detected duplication is considered critical: they are just warnings. These issues are most likely small duplications difficult to avoid, and as so they are not urgent issues that should be tackled immediately. 

<div id="figure9"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/technical-debt-duplication.png" alt="Technical Debt Duplication" width="650"/>
</p>

*Figure 9: Fragment of namespaces ordered by duplication level*

<div id="identt"></div>

### Identifying Testing Debt

Testing debt measures the extent to which an application is tested properly, in order to ensure that the application keeps functioning even after changes are made.

Syncthing requires every contributor to include tests for both Minor commits - which includes adding a simple new feature, bugfix or refactoring, and Major commits - that include adding new complex feature, large refactorings or changing the underlying architecture of (parts of) the system. These tests can be run using the "go run build.go test" command. When it comes to code coverage, Syncthing maintains an extensive coverage report for each build. Syncthing uses [cobertura](https://wiki.jenkins-ci.org/display/JENKINS/Cobertura+Plugin), an open source code coverage tool and a plug-in of Jenkins that generates code coverage metrics to record and display. The extensive code coverage results for Syncthing can be found [here](https://build.syncthing.net/job/syncthing/lastSuccessfulBuild/cobertura/). These metrics are generated not only for the latest build but the coverage results of the previous builds are also kept track of, and are used to verify how these results evolve over time. [Figure 10](#figure10) shows these code coverage results for each package, class, and files, and as we can see the package-wise coverage results for Syncthing remain a constant 93% throughout several builds. However, by checking the coverage results for objects, we notice that there is a minor drop in coverage after build 2688. The current coverage is 65% and hence it is safe to conclude that there is still some room for improvement.

<div id="figure10"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/coverage.PNG" alt="Code Coverage" width="650"/>
</p>

*Figure 10: Code coverage results*

Furthermore Jenkins provides the code coverage results for each package in the application as shown in [Figure 11](#figure11). As we can see, several packages under 'lib' directory have a 100% coverage. However, there are also few packages like 'lib/relay/protocol' with 0% code coverage and this is because the test files in these directories are empty. Writing tests for these directories would increase the overall code coverage of the application to a great extent. 

<div id="figure11"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/package-coverage.PNG" alt="Package Coverage" width="650"/>
</p>

*Figure 11: Package-wise coverage results*

By drilling down further, we were able to analyse the code coverage results for each file in a package and each class in a file. When we get to this level, Jenkins displays both the overall coverage statistics for the class and also highlights the lines that were covered in green, and those that weren't in red. For example, in 'cmd/syncthing' package, certain files like 'gui.go' have much less code coverage as shown in [Figure 12](#figure12) and thus reduces the overall coverage of the package.

<div id="figure12"></div>

<p align="center">
	<img src="/syncthing/images-syncthing/file-coverage.PNG" alt="File Coverage" width="650"/>
</p>

*Figure 12: Coverage results for files*

By studying the lines denoted by the red highlights, we can see that methods dealing with Database connections are not covered properly and by fixing this, a potential technical debt could be avoided.  

### Suggestions to reduce the project debt

Technical debt is quite low in Syncthing. In the collaboration guidelines it is specified that, before merging a Pull Request, the proposed code should pass with 0 errors several linters regarding style and syntax, so the project does not present these kind of issues. Also, they have been very careful with their interfaces, and the duplicates are not high priority issues since they usually have strong reasons to repeat some code. The technical debt in this project lays in its complexity: high cyclomatic complexity, too many lines of codes, too many functions or too deep block nesting. Our suggestion will be to redesign the most complex packages (such as `main`, `protocol` library or `model` library) in order to reduce its complexity and improve its performance.

As for testing debt, from the analysis it is evident that even though the project on a whole has a very good code coverage, there is still some room for improvement. However, in general all source files are tested and a number of automatic tests are run on the code when a pull request is triggered and hence there is no major testing debt here. Another potential testing debt that is evident from the analysis is that the framework consists of a large number of css files which are relatively harder to test. But one could easily automate the testing of certain UI features like proper scaling of GUI elements when resizing a webpage, verification of navigations etc. Finally, we also noticed that apart from testing Syncthing at a unit level, the developers have also included few integration tests. However, these tests are mostly aimed at System Integration testing (SIT). The other aspects of the system like security and performance are neither tested nor scheduled for later testing, thereby posing another potential testing debt. 

<div id="evolu"></div>

### Evolution of Technical Debt

In order to research the evolution of technical debt within the Syncthing project, we will look at how the code evolved over time. The releases along with the changelog will help us understand what happened when and why. Finally, we will look at several issues and pull requests that pay technical debt and discuss them in more detail.

The first release of the Syncthing project was v0.1.0 in December 2013. In the first months, the release cycle was extremely short, sometimes releasing twice in a single day. Four months later, in March 2014, after over 30 releases v0.7.0 was released. The code at the time, as with many new projects was changing a lot. The general architecture was constantly evolving, requiring short release cycles to keep up. Many of the changes were to the documentation in order to keep it in sync with the code itself.

Towards the end of 2014 the code started to stabilize with release cycles slowing down to about once a week. As the codebase grew more stable and many of the basic features had been implemented, it took more and more time to make a meaningful contribution. Contributions became more structured as more contributors joined the project.

#### Platforms

Since v0.9.6 the `build.sh` script was replaced by `build.go` script for better cross platform support. In the beginning this caused a lot of cross platform issues because no matter how hard they tried to abstract away the operating system, there were differences that turned out problematic. A good example is the allowed characters in filenames which are different on Windows and Linux. This led the maintainers to drop support for Linux specific filenames in favour of portability.

External projects making use of syncthing such as [syncthing-inotify](https://github.com/syncthing/syncthing-inotify), [syncthing-gtk](https://github.com/syncthing/syncthing-gtk), and [syncthing-android](https://github.com/syncthing/syncthing-android) started cropping up in early 2014 and complicated matters. Changes made to the core now needed to properly reflect in the dependent packages. This was a source of much frustration as it took cross platform to a new level. Users expected these implementations to work even on Android TV. These projects were deliberately placed in separate GitHub projects, to separate concerns of the core project from different frontend implementations.

#### Releases

Looking at the different releases we can see many bugs are introduced when a protocol version is upgraded. Aside from backwards incompatibility, the protocol is often unstable until it is tested by the public in different scenarios, configurations, operating systems etc. Furthermore, v0.13.3, v0.13.4, and v0.13.5 are interesting releases as they followed shortly after the major release v0.13.0 and were labelled as 'bug-fix release'. They fixed about 10 bugs that were introduced and discovered only after the major release. The distributed nature of the Syncthing project makes it prone to concurrency bugs that are hard to detect by developers.

v0.13.6 was the first release that explicitly mentioned cleaning up code. This so called 'cleanup-release' was first introduced in the section about discussing technical debt. It shows Syncthing's efforts to keep the codebase clean and prevent accumulating interest on technical debt.

Some of the releases are labelled as bug fixes or security fixes, but it is unclear if these problems were introduced as a result of accumulated technical debt. In a complicated distributed system, it is always difficult to cover all possible scenarios, inevitably exposing attack vectors to malicious users. Having an active and engaged community helps fixing these issues as soon as they are detected.

<div id="conclu"></div>

## Conclusion

In this chapter we have analysed Synchting by first using different views and models, and finally by looking at the technical debt within the project. We have seen how Syncthing is able to synchronize files between devices, while giving guarantees regarding data loss, security, and ease of use. The organization of the code in layers allows for separation of concerns, and provides a decoupled architecture. This, along with good code quality and collaboration practices results in a healthy codebase, with minimal technical debt. Syncthing is an open source project with a strong core team that provides a suitable alternative to proprietary synchronization technologies.

<div id="refer"></div>

## References

1. <div id="userdata"/>Syncthing User Data. https://data.syncthing.net/ </div>
2. <div id="semver"/>Semantic versioning. http://semver.org</div>
3. <div id="authors"/>Syncthing Authors. https://github.com/syncthing/syncthing/blob/master/AUTHORS </div>
4. <div id="notests"/>@calmh's comment on tests. https://github.com/syncthing/syncthing/pull/3780#issuecomment-268509136 </div>
5. <div id="betatesters"/>Syncthing Beta Testers. https://forum.syncthing.net/badges/131/beta-tester </div>
6. <div id="scribes"/>Syncthing Scribes. https://forum.syncthing.net/badges/121/scribe </div>
7. <div id="support"/>Syncthing Helpful Members. https://forum.syncthing.net/badges/126/very-helpful </div>
8. <div id="relays"/>Syncthing Relays. http://relays.syncthing.net/ </div>
9. <div id="manifest"/>Syncthing Manifest. https://github.com/syncthing/syncthing/blob/master/vendor/manifest </div>
10. <div id="goals"/>Syncthing. The Syncthing Goals. https://github.com/syncthing/syncthing/blob/master/GOALS.md. 
11. <div id="effgo"/>Effective Go. https://golang.org/doc/effective_go.html </div>
12. <div id="init"/>Separation of Initialization and Construction. Stack Overflow. http://softwareengineering.stackexchange.com/questions/206086/separation-of-construction-and-initialization. </div>
13. <div id="issuetempl"/>Issue Templates. https://help.github.com/articles/creating-an-issue-template-for-your-repository/ </div>
14. <div id="book"/>	Nick	Rozanski	and	Eoin	Woods.	2012.	Software	Systems	Architecture:	Working	with Stakeholders	Using	Viewpoints	and	Perspectives.	Addison-Wesley	Professional. </div>
15. <div id="docs"/>Syncthing Docs. https://docs.syncthing.net/. </div>
16. <div id="src"/>Syncthing. Source Code. https://github.com/syncthing/syncthing. </div>
17. <div id="transifex"/>Transifex. https://www.transifex.com/syncthing/syncthing</div>
