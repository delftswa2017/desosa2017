# Mapbox GL JS

![](images-team-mapbox-gl-js/Mapbox-Logo.png)

By [Yoeri Appel](https://github.com/yappel), [Lars Krombeen](https://github.com/lkrombeen), [Remco de Vos](https://github.com/RemcodeVos) and [Jos Winter](https://github.com/joswinter).

## Abstract
Mapbox GL JS is a JavaScript rendering library used to create interactive maps using WebGL.
It is part of a large collection of open source tools created by Mapbox to design, develop and show (interactive) maps that are completely customised to suit the needs of the user.
This chapter analyses the architecture of Mapbox GL JS using the context, stakeholders, development and information viewpoints, and could be used by future developers as reference to get started.
Furthermore it provides an analysis of the technical debt present in the project.


## Introduction
Human kind has been making maps for a extensive amount of time, with the first map dating back over 16500 years [[2](#old-map)].
The way maps are made and viewed has changed a lot since then and is still changing today.
Nowadays almost everyone has the possibility of accessing maps of anything anywhere over the Internet using computers or smart devices.
As a consequence several companies and organisations have been formed around the services of providing maps and map data.

One of these companies is Mapbox which provides both geographic data, rendering clients, and other services related to maps.
Mapbox GL JS is one of their open source client libraries for rendering and interacting with maps for websites.
As part of the Mapbox ecosystem it of course integrates with the other services Mapbox provides.

As the Mapbox GL JS client is part of a much larger ecosystem this chapter first looks at the Mapbox and the relation between Mapbox and Mapbox GL JS.
This is done by describing the context of Mapbox GL JS and its primary stakeholders.
Furthermore Mapbox GL JS’s architecture is discussed by describing its module structure, standardisation of design and testing, and build approach.
Additionally, as maps are data heavy the flow of this data will be discussed in the information view as well as the usability for both developers and users.
Lastly, the technical debt for the Mapbox GL JS library will be discussed to see what the quality of the project is.

## About Mapbox and Mapbox GL JS
### The Founding of Mapbox
Mapbox was founded in 2010 with the goal to provide an alternative to the popular Google Maps.
In Google Maps little to no customisation was possible and there were barely any tools for cartographers to create maps how they envisioned it.
Mapbox was founded with the goal to change that and provide (open source) tools for cartographers and developers to create the maps they desired.

All tools Mapbox develops are open source and free to use.
Their core business is hosting services (such as storing and providing the user's custom geo-data) on their servers.
Their goal is to ensure that software exists which supports the digital cartographers in the best way possible, but they do understand that not everybody needs and likes the same and that alternatives to their tools do exists.
Since it is not their goal to make the best or most popular tools themselves, they learn from and work together with these alternatives to improve their own tools and let the users use, for example another data renderer, while still using the other Mapbox tools and services.
This is the reason that there is not one Mapbox repository or project but every tool/library/specification is developed separately to keep everything modular.
Mapbox GL JS is one of these modules and is one of the renderers developed by Mapbox that visualise your geo-data.

### Mapbox GL JS and the Mapbox Architecture
An important part of Mapbox GL JS' context is its position and role in all the other Mapbox components.
This section will give a general explanation of all relevant Mapbox components in order to better understand the role of the Mapbox-gl-js repository.

Mapbox's system revolves around [Styles](https://www.mapbox.com/help/define-style/), [tilesets](https://www.mapbox.com/help/define-tileset/) and [data sources](https://en.wikipedia.org/wiki/List_of_GIS_data_sources). The relation between these components can be viewed in figure [1](#mapbox-architecture).

<div id="mapbox-architecture"/>

![](images-team-mapbox-gl-js/Mapbox_style.png)

*Figure 1. Diagram showing relation between Data sources, tilesets and styles in the Mapbox architecture*

A tileset is an optimised way to save and transport data by splitting it in tiles.
A Mapbox style defines where to find the data sources (in raw form or the optimised tilesets) and how to display this data.
This allows the user to visualise every bit of data exactly the way they want (or not visualise it: hiding certain parts).
Mapbox created tools to both create these styles and to render them with different methods.
The most basic rendering tool is the [static API](https://www.mapbox.com/api-documentation/#static) which converts the style into a static image by running an algorithm on their server.
Another way is to use the [Mapbox plugin](https://www.mapbox.com/mapbox.js/api/v3.0.1/) for [Leaflet](http://leafletjs.com/), which uses the basic browser techniques like svg and canvas to render the data.
Furthermore, there is the [Mapbox-gl-native](https://github.com/mapbox/mapbox-gl-native) repository which uses OpenGL to render the map and contains SDKs for Android, iOS, macOS, NodeJS and Qt.
The last method is using WebGL inside a web browser and is developed in Mapbox GL JS repository.

<div id="api-explanation"/>

Mapbox GL JS itself is a map interaction and rendering client for websites and web applications and thus does not provide the map data for rendering [[3](#gl-js)].
Within the Mapbox ecosystem the Maps API and Styles API provide respectively the raster and vector tilesets, and the Mapbox GL styles needed for the web rendering client [[4](#define-tileset)].
When the Mapbox GL JS client is used completely within the Mapbox ecosystem it has a dependency on the Maps and Styles APIs.
However, this is not necessary, as long as the data sources follow the specifications it is also possible to use other external or private sources [[5](#external-vector-tiles)].
However, since they earn their money with their servers, Mapbox promotes the use of the data they are providing on their services, which can be complemented with data the users uploads to the server on their accounts, and can be accessed simultaneously with the Mapbox data via the APIs mentioned before.
The data Mapbox provides is gathered from both the leading open source and largest commercial providers, like OpenStreetMap, NASA and DigitalGlobe, as can been seen on their [website](https://www.mapbox.com/data-platform/).
Figure [2](#mapbox-global) gives a graphical overview of the these relations.

<div id="mapbox-global"/>

![](images-team-mapbox-gl-js/Mapbox_global.png)

*Figure 2. Simplified overview of the major parts of the Mapbox architecture related to Mapbox GL JS*

### Context View
![](images-team-mapbox-gl-js/Context_view.png)

*Figure 3. Diagram of the context view*

As mentioned before, Mapbox develops as much as possible in open source projects and therefore the mapbox-gl-js repository is one of 500+ repositories in the [Mapbox organisation](https://github.com/mapbox?utf8=%E2%9C%93&q=&type=source&language=).
Consequently Mapbox GL JS is developed by both developers from Mapbox and people from the Github community who want to contribute.
More information about which Mapbox employees are working on Mapbox GL JS can be found in the Stakeholders section. Github as the host for the code, forms a medium for people to contribute to the code and is used to track issues as well.

Just as all other Mapbox projects, Mapbox GL JS is developed by and developed for other developers.
Mapbox GL JS is structured in such a way that plugins can be created to extend the default functionalities.
Both Mapbox themselves and people from the Github community have created these plugins and they are promoted on their [website](https://www.mapbox.com/mapbox-gl-js/plugins/).

The programming language used to build Mapbox GL JS is JavaScript and WebGL (the web version of OpenGL) is used to render the map inside the client's browser.
Mapbox's Styles API and Maps API are used to determine what should be rendered, how it should be rendered and retrieve the data that needs to be rendered, as described in [the previous section](#api-explanation).
This impacts the architecture heavily, because the architecture of a large JavaScript system is different than a strongly typed language like Java and the architecture is designed around the APIs and WebGL.

Mapbox' documentation is hosted on their [site](https://www.mapbox.com/mapbox-gl-js/api/) and Coveralls and CircleCI are used for continuous integration, the use of these specific tools does not impact the architecture, but using continuous integration in general helps to make sure that the quality of the code is at a certain level.

Due to Mapbox philosophy of creating open source tools that can be used by anyone, the Mapbox GL JS project does not have many competitors.
When there is a tool that is an alternative to one of the Mapbox tools, this is not seen as a threat.
This is shown by the fact that Mapbox collaborates with multiple companies that provide these tools in order to improve their own tools and/or create plugins for these tools so people can still use other parts of Mapbox with the alternative tools.
In some extreme cases they even drop their own project and hire the developer of the alternative tool, like they did with Leaflet [[9](#mapbox-joins-leaflet), [10](#leafletdev-joins-mapbox)].
Google is the only company that was found that has tools alternative to the Mapbox tools, but does not support anything of Mapbox, since Google Maps is not modular and Google wants people to only use their product.
This is why we consider Google Maps as the only real competitor of Mapbox GL JS.

Mapbox GL JS is making use of a package manager (Yarn right now, npm in the past) to track dependencies and allow developers to easily install and test the code.
Yarn and some other development dependencies (which are small and not really impactful to the architecture and therefore left out of this section) depend on NodeJS and Mapbox GL JS also uses some features of NodeJS during the development.
This is why Mapbox GL JS also has a strong dependency on NodeJS.



### Stakeholders of Mapbox and Mapbox GL JS
This section describes the relevant stakeholders of Mapbox GL JS.
According to Rozanski and Woods  [[1](#rw)] there are 10 different types of stakeholders.
The most important types indentified for Mapbox GL JS are the developers and users.
However, since Mapbox GL JS is part of the larger organisation Mapbox the stakeholders of Mapbox will be briefly mentioned, but the main focus will be on the Mapbox GL JS project.
An overview of all the stakeholders can be seen in figure [4](#stakeholders-overview).
Most stakeholders are within the organisation: e.g. Mapbox employs a team for the support of users.
The teams as mentioned in figure [4](#stakeholders-overview) can be found on the [Mapbox team page](https://www.mapbox.com/about/team/).
Other relevant stakeholders of Mapbox which are important for Mapbox GL JS are the investors, grouped under the acquirers type together with the CEO of Mapbox.

<div id="stakeholders-overview"/>

![](images-team-mapbox-gl-js/stakeholders.png)

*Figure 4. Stakeholders of Mapbox*

The rest of the section focusses on Mapbox GL JS. The users of Mapbox GL JS are JavaScript developers that want to use the Mapbox plugin on their website.
The [gallery](https://www.mapbox.com/gallery/#) shows some usage examples.
Their [showcase](https://www.mapbox.com/showcase/) includes some Mapbox customers and which industries Mapbox is powering.

Within the Mapbox GL JS project there is a hierarchy between the developers.
Firstly, there is the open-source community that can create issues, making Mapbox aware of problems, and can propose pull request to fix issues.
The open-source community has made significant contributions to the project.
Secondly, there are the developers that pick up issues or work on existing projects and create pull requests when they finished their task.
Lastly, there are the integrators: the developers that review and merge pull requests.
These integrators are responsible that the code works and that the changes in the pull request are in compliance with the project standards.
The integrators are the assessors of the team.

A summary of the identified stakeholders for Mapbox GL JS in addition to the stakeholders of Mapbox can be found in table [1](#stakeholders-table).

<div id="stakeholders-table"/>

Type                   | Stakeholders     
---------------------- | ------------
Developers             | Github open-source community, @[jfirebaugh](https://github.com/jfirebaugh), @[lucaswoj](https://github.com/lucaswoj/), @[mourner](https://github.com/mourner), @[anandthakker](https://github.com/anandthakker), @[mollymerp](https://github.com/mollymerp), @[tmcw](https://github.com/tmcw), @[ChrisLoer](https://github.com/ChrisLoer)
Assessors/Integrators  | @[jfirebaugh](https://github.com/jfirebaugh), @[lucaswoj](https://github.com/lucaswoj/), @[mourner](https://github.com/mourner), @[anandthakker](https://github.com/anandthakker), @[mollymerp](https://github.com/mollymerp)
Users                  | Thousands of users world-wide ([showcase](https://www.mapbox.com/gallery/)) e.g. IBM, Twitter, MasterCard, The World Bank, Runkeeper, The Guardian, Airbnb

*Table 1. The main stakeholders of Mapbox GL JS*

## The Architecture of Mapbox GL JS
### Development View

An important part of a software system is the software development environment as this has influence on the design, build and testing. Especially, for complex systems it is important that this has been set up correctly to maintain and guarantee productivity and quality. The development view studies code structure and dependencies, test and build and deployment management, design constraints, and code conventions. This section will take a look at these aspects for Mapbox GL JS.

#### Module structure model and organisation
In this section the different modules and their dependencies of the mapbox-gl-js repository will be discussed.

[Madge](https://github.com/pahen/madge), a developer tool for generating a visual graph of your module dependencies, was used to help determine the dependencies between the different modules.
Since Mapbox GL JS is build on NodeJS, technically every file is a module, but the resulting graph was too big be displayed on one screen.
Modules in different layers with similar abstraction layers were grouped together to generate a more comprehensible graph.
The layers are largely based on the folders in which the source files are grouped.

- **User Interface** This layer is on top and contains all classes that interact with the user of the map, e.g. the code to zoom in or rotate the map.
- **Style** The style layer contains all classes that represent and process the Mapbox stylesheets.
- **Render** The render layer contains all classes that are responsible for rendering the geo-data on the screen using WebGL.
- **Mapdata** The mapdata layer contains all classes for representing the data that needs to be rendered.
- **Data types** The datatypes layer contains classes that are specialised datatypes that are used in the other parts of the system.
- **Style-spec** The style-spec layer was originally a separate repository but was merged into mapbox-gl-js. It defines the specifications that the Mapbox style created by the user has to satisfy to be considered valid.
- **Utility** The Utility layer contains all classes that provide general utility to the other parts of the system.


An overview of the layers and its dependencies can be found in figure [5](#module-structure).

<div id="module-structure"/>

![](images-team-mapbox-gl-js/modules_layered.png)

*Figure 5. The module structure of Mapbox GL JS*

#### Standardisation of Design

Because multiple software developers are influencing the Mapbox GL JS system it is important to standardise the key aspects of the design of the software to make it as maintainable, reliable and technical cohesive as possible.
In the long run this decreases the technical debt and therefore the development time of future features and bug fixes in the system.
Design standardisation can be achieved by using design patterns in the software and by standardising the process and communication around the software development.

##### Code Contribution Conventions

Not all Mapbox design standards are directly described.
There are some design standardisation rules concerning the software mentioned in the contributions guide [[6](#contributions)].
These design standards provided in the contributions guide mostly define functional standards which influence the functionality of the system for its users and these rules can be found in table [2](#table-conventions).
Furthermore there are conventions documenting the contributed code [[7](#documentation)] and these rules are also displayed in table [2](#table-conventions).

<div id='table-conventions'/>

|  Specified in |  rule  |
|---------------|--------|
| [CONTRIBUTION.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md) | `error` events are used to report user errors instead of the standard `Error` class. However, the `Error` class is used to indicate non-user errors. |
| [CONTRIBUTION.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md)  |  `assert` statements are used to check for invariants that are not likely to be caused by a user error. These `assert` statements are automatically stripped out of production builds. |
| [CONTRIBUTION.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md)  |  A certain set of ES6 features are used so the system is functional on all the predefined platforms/browsers. The most notable used features which are important to the design standard are usage of classes and usage of computed and shorthand object properties (A detailed list of these features is described in the contributions guide). |
| [CONTRIBUTION.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md)  |  Another set of ES6 features are not to be used, in order to maintain support for the predefined platforms/browser which also consists of older browsers. This may change in the future. Some notable features that may not be used are default parameters, REST parameters and iterators (A detailed list of these features is described in the contributions guide). |
| [CONTRIBUTION.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md)  | The Mapbox GL JS developer should use rebase merging as opposed to basic merging to merge branches |
| [CONTRIBUTION.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md)  | Use the Github label labeling system as specified in [CONTRIBUTION.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md) |
| [docs/README.md](https://github.com/mapbox/mapbox-gl-js/blob/master/docs/README.md) | PRs only only containing documentation improvement should be made towards the special mb-pages branch instead of master |
| [docs/README.md](https://github.com/mapbox/mapbox-gl-js/blob/master/docs/README.md) | The documentation should follow the JSDoc rules [[11](#jsdoc)] |

*Table 2. Overview of the rules regarding code contribution conventions*

##### Architectural- and Design Patterns

Due to the dynamic typed nature of JavaScript and the absence of a standard way to implement interfaces and abstract classes a lot of design patterns cannot be used.
The most central architectural pattern used in the system is the model-view-controller pattern which divides the application into three interconnected parts.
The system is divided in the following parts:

1. The `Map` instance which contains information about the camera position and the data that has been loaded into the map. (Model)
2. The UI handlers which update the map based on its functionality and the actions of the user. (Controller)
3. The active html canvas and css code active in the browser of the user. (View)

The observer design pattern is being used in the `Dispatcher` class, an instance of this class can broadcast to all subscribed `WorkerSource` instances in its pool.
There also has been some [discussion in the Mapbox repo](https://github.com/mapbox/mapbox-gl-js/issues/2506) about using the factory design pattern to create new objects which makes it easier for beginners, less prone to errors, and less verbose.
To decrease the amount of duplicated code a lot of standard functionality is being reused and has been implemented in several utility classes which can be found in the util folder but also in the symbols folder.

Most of the SOLID principles cannot be used due to the absence of interfaces and abstract classes. The one principle that can be used is the single responsibility principle. The single responsibility principle is being used in the `Map` class which extends the `Camera` class which extends the `Transform` class.
These classes inherit from each other to divide the functionality and the responsibilities between the classes.
The `Map` class is responsible for the functionality which makes it possible to programmatically change the map and firing event when users interact with it.
The `Camera` class is responsible for managing the animations and movement which are called by the user and the system.
The `Transform` class is responsible for managing the position and the other camera options such as the pitch, the zoom and the bearing of the map.

#### Standardisation of Testing
<div id='section-testing'/>

The Mapbox GL JS repository contains several different and important test suites to ensure consistency and quality.
This section will discuss the different tests, data and tools used by the team.
The tests can be found in the folder tests which contains subfolders for different groups and types of tests.
Furthermore there are several conventions tests must cohere with, which can be found in the [test readme](https://github.com/mapbox/mapbox-gl-js/tree/master/test "README").

##### Test Suites

There are two different test suites associated with the project which are both run with yarn. The first one is `yarn test` which runs the quick unit tests, the second is `yarn run test-suite` which runs the integration tests. These two test suites consist of running several other more specific test suites. Tables [3](#table-test) and [4](#table-test-script) illustrate the different test suites in the mapbox-gl-js repository, their purpose and their dependencies on other test suites.

<div id="table-test"/>

| Test Suite | Purpose | Dependencies |
|------------|---------|--------------|
| test | Quick unit tests as well as syntax checking using lint and type checking using Flow. | test-unit, test-plugin, test-flow |
| test-suite | Integration tests for testing and validating the output of combined functionality: e.g. validate that a specified style generates a correct static image map. | test-render, test-query |

*Table 3. Mapbox GL JS test suites*


All the test suite scripts are defined in the scripts section of the `package.json` and can be run with yarn.

<div id="table-test-script"/>

| Test Suite | Purpose | Tested Source |
|------------|---------|---------------|
| test-plugin | Runs the test in the test/plugins folder using the Tap framework. | The test verifies that the `docs/_data/plugins.json` is valid JSON. |
| test-unit | Runs all the tests in the test/unit folder using the Tap framework. The tests are unit tests which test functionality of the tested classes. | Individual classes in the src/data/, src/geo/, src/source/, src/style/, src/style-spec/, src/symbol/, src/ui/ and src/util/ folders. |
| test-render | Runs the `test/render.test.js` which runs `test/integration/lib/render.js`. Renders PNG's from the input and compares these to an expected PNG. | Different combinations of source files for combined behaviour. |
| test-query | Runs the `test/query.test.js` which runs `test/integration/lib/query.js`. Generates JSON based on the input and compares these to an expected JSON. | Different combinations of source files for combined behaviour. |
| test-flow | Runs the Flow to check for type mismatches. | All the files which are marked as needed to be type checked. |
| test-cov | Uses the nyc framework(#test-nyc) to create a test coverage report of the test-unit, test-render and test-query test suites. | See the individual test suites. |

*Table 4. Mapbox GL JS test scripts*

##### Test Data

The test/integration/ folder contains all the data and information for the render and query integration tests. In integration/lib/ the files `render.js` and `query.js` can be found. These classes take all the subfolders in the integration/render-test/ and integration/query-test/ folders respectively and use these to create the tests and input data for testing, and obtain the expected result for comparison. Each subfolder is a specific group of tests which relate to each other or a function. Each of these groups again has subfolders for the specific test input data and expected results.

The other folders in the test/integration/ folder form the data input for some of tests as well as return data for created mocks.

#### Testing Tools and Infrastructure
Mapbox GL  JS makes use of several testing tools for performing their tests. These include libraries for checking the code, providing functionality for mocking, testing framework and external infrastructure as part of continuous integration.


##### Testing Tools

The team uses several different testing tools to ensure code quality and correct functionality.
In table [5](#test-tools-used) below the different testing tools and their purpose are further described.
A distinction between two categories can be made for the used testing tools: testing libraries and code quality libraries.
The libraries Tap, nyc, and Sinon.js are included and used for testing purposes and expanding the functionality of testing.
Additionally, the static code analysis tools Flow and node-lint are included for checking and enforcing code quality.

<div id="test-tools-used"/>

| Testing Tool | Testing Purpose | Tool  Information |
|--------------|-----------------|-------------------|
| Tap | Tap is the Test-Anything-Protocol library for Node.js and provides a framework for writing and running tests. | [www.node-tap.org](http://www.node-tap.org/ "tap") |
| Sinon.js | Sinon.js is a library used to augment the standard testing object with the use of spies, stubs and mocks. At the end of each tests the spies, stubs and mocks on global objects are restored in the way the testing framework is setup [[5](#test-readme-sinon)]. | [www.sinonjs.org](http://sinonjs.org/ "Sinon.js") |
| Flow | Flow is a static type checker for JavaScript which uses type interference and type annotations. | [www.flowtype.org](https://flowtype.org/ "flow: static type checker") |
| node-lint | Node-lint is a Node.js package which makes it possible to run [JSLint](http://www.jslint.com/ "JSLint") from the command-line and is used for syntax validation. | [www.github.com/jpolo/node-lint](https://github.com/jpolo/node-lint "node-lint") |
| nyc | nyc is [Istanbul](https://istanbul.js.org/ "Istanbul")'s command-line interface and is used for generating test coverage reports. | [www.github.com/istanbuljs/nyc](https://github.com/istanbuljs/nyc "nyc") |

*Table 5. The testing tools used by the Mapbox GL JS team*

##### Continuous Integration

[CircleCI](https://circleci.com/gh/mapbox/mapbox-gl-js "CircleCI") is the platform used for continuous integration. Each pull request triggers a minified and development build, and the `test-flow` and `test-cov` test suites are run. These tests also generate a test coverage report. As part of the checks of a pull request, passing all tests on CircleCI is a requirement for the pull request to be merged. The coverage report is send to [Coveralls](https://coveralls.io/github/mapbox/mapbox-gl-js "Coveralls"), a platform used for keeping track of test coverage statistics relating to the repository, files, lines of code, and coverage statistics over time. Each pull request thus results in a code coverage report, however, this is not required for a pull request to be approved.
Because the developers are actively following their testing standards we can observe in [Coveralls](https://coveralls.io/github/mapbox/mapbox-gl-js "Coveralls") that the already high testing coverage has been slowly increasing from 85% to 89% in 2015 and 2016.

#### Build Approach

There are two build approaches provided for Mapbox GL JS: running the local build scripts with yarn or npm, and automated builds based on tagged releases.

##### Build Scripts
There are several different build scripts defined in the mapbox-gl-js repository. The build-dev and build-min build the application from the source files. Table [6](#build-script) illustrates the different build scripts, their purpose and their output.

<div id="build-script"/>

| Build Script | Purpose | Output |
|--------------|---------|--------|
| build-dev | Builds a development version of the repository from src/index.js | dist/mapbox-gl-dev.js |
| build-min | Builds a minified version of the repository from src/index.js | dist/mapbox-gl.js |
| build-benchmarks | Builds the benchmarks in the repository bench/benchmarks.js | bench/benchmarks.js |
| build-docs | Generates the documentation of the repository. | Outputs to the docs/ directory. |
| build | Runs the build-docs build script. | |

*Table 6. Mapbox GL JS build scripts*

The builds for the code use [browserify](http://browserify.org/ "browserify") to bundle all the single Node.js files working with require into one single file which can be used by webbrowsers. Additionally, the build-dev and build-min scripts run a test script with Tap to validate that the files have actually been build.

##### Automated Build and Deployment

The CircleCI configuration file is setup to trigger a deployment script, `ci-scripts/deploy.sh`, when there is a tagged release in the GitHub repository. The script is triggered when there is a passing build on CircleCI, which in turn requires the build and all tests to pass.

The deployment script in turn runs the build-dev and build-min scripts which create respectively the development and minified build of the repository. In turn these are uploaded to Amazon Web Services in a folder for that release and are available on the Mapbox website. In total four different files are uploaded: the minified mapbox-gl.js, mapbox-gl.js.map, the development build mapbox-gl-dev.js and mapbox-gl.css.

### Information View
Rozanski and Woods define the information view as a description of the way that an architecture stores, manipulates, manages and distributes the data of the system.
This section will target how data is stored, accessed and eventually how the data flows through the Mapbox GL JS plugin.
The focus will mainly be on the flow of the geo-data and stylesheet in the system and until they are rendered as the entire system revolves around this data.

Mapbox GL JS is executed on the clients website.
The JavaScript developer can add data like vector tiles to the map or change the style of the map by changing the stylesheet.
If the JavaScript developer does not want to use a custom style they can use a default one.
This data and other data is defined and stored on the client's website.
The data that is eventually used depends on two API calls from the Mapbox servers.
The APIs provide the data of the map that is to be rendered and it contains stylesheet templates that the JavaScript developer can use if he defined the use a default style.
Figure [6](#code-overview) shows an overview of the main flow of data.
The flow starts when the JavaScript developer makes the call to Mapbox GL JS and ends when the map has been created and is returned.
It shows where the data is stored, retrieved, manipulated and managed.

<div id="code-overview"/>

![](images-team-mapbox-gl-js/information-view-2.png)

*Figure 6. Overview of the flow of data in the Mapbox GL JS code. Yellow cylinders indicate local data storage, blue boxes indicate classes that are used and green clouds indicate external data which is fetched using an API call.*

The flow makes clear that the data is stored at two local places and on the Mapbox server, and is manipulated using a simple flow.
The progam configuration handles that the tiles and style layers are applied to the map.
This way the data that the JavaScript developer defined is added to the map using a custom defined style if the JavaScript developer defined it.

The initial call is made from the page which instantiates a Mapbox object after which two flows are created which are combined at the rendering steps and are as follows.
The first flow is responsible for fetching the geo-data.
This is done by making a call to the Mapbox Map API.
The API call is different based on the defined style.
Once the tiles are loaded the tiles and the style which the developer defined are added to the vector tiles.
The vector tile data is modified in different classes as can be seen in figure [6](#code-overview).
The classes are part of the Mapbox GL JS plugin and should not be modified by the JavaScript developer.
The results that are passed to the layer responsible for rendering consists of vector tiles which are grouped by their program configuration.
The second flow fetches a stylesheet from the Mapbox Style API and communicates it with the first flow to make the proper API calls for the map data.
If the user indicated that he wants to use a stylesheet the flow fetches the style and passes it to the renderer.
Once the flows are combined the rendering layer renders the vector tiles group by group and applies the fetched and defined styles to the map.
Additionally, the renderer uses shaders which are locally stored but the shaders should not be modified by the JavaScript developer.
The map is now rendered and is returned to the client web page which displays the map.

#### Usability Perspective
Applying the usability perspective on the information view ensures that the system allows the users that interact with it do so effectively [[1](#rw)].
The usability perspective focuses on the end users of the system and thus addresses the concerns of JavaScript developers that have to work with the Mapbox GL JS plugin.
The usability perspective can be applied on the information view by looking at the quality of the information e.g. the provision of accurate, relevant, consistent and timely data [[1](#rw)].

The developers are only concerned with the stylesheet for their website.
The website can use a default style sheet which is given by Mapbox or add their own data sources which can be called using `style: 'mapbox://styles/mapbox/light-v9'`.
Adding own data or changing the style can easily be done by following the API or examples provided on the Mapbox website.
Once instantiated the map will be fetched automatically for the website using an API call.

The developers that make use of Mapbox GL JS are also concerned with the concerns of their website users.
The website users are the people that can interact with the rendered map. The website user requires that the map is rendered quickly when he interacts with the map.
Additionally, the map should be a correct representation of the real world.
The website users are not concerned with the style since the website provides this.
They are, however, concerned with the geo-data which is retrieved from OSM.
The data from OSM can be modified by anyone and therefore erroneous data can slip in.
This is a similar feature that Wikipedia has and has minimal wrong data since people correct each other and prevent people from changing data to something that is incorrect.

Figure [6](#code-overview) has shown that the data is going through a channel where it is transformed or used and passed to the next class.
This makes it easy for a Mapbox GL JS developer to see what happens where and what he has to change if he wants to add new functionality or debug the program.
However, the JavaScript developer is not concerned with which classes are called since he only calls the constructor of the map.

The way the information is sent through the code makes it usable for the JavaScript developers and the website users.
The only downside for the website user is that the data can be incorrect.
The performance is determined by the website which can add as much data as required.
When the JavaScript developer adds too much custom data the rendering can become slow which lowers the usability.

## Technical Debt

<!-- Introduction -->

In this section the technical debt of the mapbox-gl-js repository is discussed. The technical debt was determined using both software tools and inspecting files manually. Additionally, the documentation and testing debt will be covered. Lastly, the pull requests and issues on Github will be analysed to see if the developers are recognising, discussing and managing the technical debt in the repository.

### SonarQube Results

The SonarQube tool estimated the technical debt to be 7 days.
The technical debt is defined as the amount of development hours it will take to fix all the found issues related to security, reliability and maintenance.
However, the measure of time is not the best way to define the technical debt since 7 days is relatively low if the project contains 500k lines of code.
An other metric called technical debt ratio is defined as the ratio between the actual technical debt and the effort it would take to rewrite the whole source code from scratch [[8](#sonarqube)].
The technical debt ratio for Mapbox GL JS is 0.8% which indicates that the technical debt is relatively low and managed properly.

### Documentation Debt

The API documentation consists of all the documentation, specifications and examples necessary for developers to start using Mapbox GL JS and can be found on the [website](https://www.mapbox.com/mapbox-gl-js/api/ "Mapbox GL JS API documentation").
In contrast to the API documentation, the documentation for the rest of the source code seems to be rather lacking.
Although most of the classes have documentation for the class definition (although for some this is also missing), a lot of methods have little to no documentation.
For new developers trying to contribute to the project itself this is an issue as it takes a lot of time to figure out how the code works, what it does, and what it is supposed to do.
However, the developers of Mapbox GL JS are planning on writing about their [architecture](https://github.com/mapbox/mapbox-gl-js/blob/master/ARCHITECTURE.md).

### Testing Debt

Using the already active code coverage tools in the repository the code coverage for the Mapbox GL JS code was evaluated.
The testing efforts are prioritised and focused on testing the most important and core classes.
Examples of these important classes are the `Camera` and `Map` class which are vital to the functionality of the system and which are frequently changed.
Some less important parts of the code aren't well tested which increases the testing debt of the system.
Some code is less important because hardly any issues and bugs are detected and fixed in it and therefore the code doesn't change frequently.
However, the testing debt on this less important code is mitigated because of the unimportance of those classes and methods.
The developers and testers of Mapbox GL JS prioritise their testing efforts on the most important classes and methods of the system and regression testing when fixing bugs.
The testing debt in the Mapbox GL JS project can be decreased by creating more tests for uncovered parts of the code.
In the Mapbox GL JS project there is already an existing restriction that when new functionality is added the developer should also create accompanying tests.

### Evolution of Technical Debt

Using the same tools used in the SonarQube Tool Analysis section, technical debt can also be measured by analysing the separate releases of Mapbox GL JS.

There have been 33 major releases of Mapbox GL JS before March 2017.
The technical debt grew gradually over time, but this is expected since the repository grew as well.
The maintainability rating was always rated with an A, therefore it can be concluded that the technical debt grew proportionally with the code.

### Discussion about Technical Debt

Technical debt is not necessarily a bad thing as long as the developers are aware and it is managed.
After looking at the discussions in some of the Github issues/pull requests and searching the source code for certain keywords that would indicate unfinished or bad code, it can be concluded that the developers of Mapbox GL JS are discussing technical debt and leave little to none unfinished/bad code behind.
However, not all the technical debt that was found is discussed and the debt that is discussed was discovered using SonarQube.
Of course, technical debt is not an exact measure and there might be more discussion on technical debt outside GitHub, which cannot be seen.
However, from the things which could be seen, it can be concluded that the technical debt is managed well and they especially focus on keeping the code/variable names consistent and clear.

## Conclusion and Recommendations
In this chapter the mapbox-gl-js repository and its architecture were analysed. Firstly, the philosophy of Mapbox, the purpose of Mapbox GL JS, its context view and the stakeholders are discussed. After that architecture of mapbox-gl-js is discussed with analyses of the modules, testing methods, build approach and the information flow through the system. Lastly, the amount of technical depth was analysed. Based on all the analyses we have the following recommendations for the Mapbox GL JS developers concerning their project:


- Better documentation of the architecture and code should be added to the repository to ensure that new developers easily understand the architecture and how they could best contribute.
The developers recently started on an [architecture document](https://github.com/mapbox/mapbox-gl-js/blob/master/ARCHITECTURE.md) which they should keep refining.
- Continue with prioritising the testing efforts to manage the testing debt. Any time that is left could be used to test the less important untested or badly tested code. If the testing standards are being following the coverage will improve over time similar to the past few years.

## References
1. <div id="rw"/>Nick Rozanski and Eoin Woods. Software Systems Architecture: Working with Stakeholders using Viewpoints and Perspectives. Addison-Wesley, 2012.
2. <div id="old-map"/>Ice Age star map discovered: [http://news.bbc.co.uk/2/hi/science/nature/871930.stm](http://news.bbc.co.uk/2/hi/science/nature/871930.stm) (Visited: Februari 2017)
3. <div id="gl-js"/>Mapbox GL JS fundamentals: [https://www.mapbox.com/help/mapbox-gl-js-fundamentals/](https://www.mapbox.com/help/mapbox-gl-js-fundamentals/) (Visited: March 2017)
4. <div id="define-tileset"/>Glossary: tileset: [https://www.mapbox.com/help/define-tileset/](https://www.mapbox.com/help/define-tileset/) (Visited: March 2017)
5. <div id="external-vector-tiles"/>Mapbox awesome-vector-tiles: [https://github.com/mapbox/awesome-vector-tiles](https://github.com/mapbox/awesome-vector-tiles) (Visited: March 2017)
6. <div id="contributions"/>mapbox-gl-js contributing: [https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md](https://github.com/mapbox/mapbox-gl-js/blob/master/CONTRIBUTING.md) (Visited: March 2017)
7. <div id="documentation"/>mapbox-gl-js readme: [https://github.com/mapbox/mapbox-gl-js/blob/master/docs/README.md](https://github.com/mapbox/mapbox-gl-js/blob/master/docs/README.md) (Visited: March 2017)
8. <div id="sonarqube"/>SonarQube Documentation: [https://docs.sonarqube.org/display/SONAR/Documentation](https://docs.sonarqube.org/display/SONAR/Documentation) (Visited: March 2017)
9. <div id="mapbox-joins-leaflet"/> Leaflet Creator Vladimir Agafonkin Joins MapBox [https://www.mapbox.com/blog/vladimir-agafonkin-joins-mapbox/](https://www.mapbox.com/blog/vladimir-agafonkin-joins-mapbox/) (Visited: April 2017)
10. <div id="leafletdev-joins-mapbox"/> Announcing MapBox.js 1.0 with Leaflet  [https://www.mapbox.com/blog/mapbox-js-with-leaflet/](https://www.mapbox.com/blog/mapbox-js-with-leaflet/) (Visited: April 2017)
