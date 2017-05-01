# Delft Students on Software Architecture: DESOSA 2017


**[Arie van Deursen], [Andy Zaidman], [Maurício Aniche], [Valentine Mairet] and [Sander van den Oever].**<br/>
*Delft University of Technology, The Netherlands, April 17, 2017, Version 1.0*

[arie van deursen]: https://avandeursen.com
[Andy Zaidman]: http://www.st.ewi.tudelft.nl/~zaidman/
[maurício aniche]: http://www.mauricioaniche.com
[Valentine Mairet]: https://github.com/valmai
[Sander van den Oever]: https://github.com/sandervdo

We are proud to present
_Delft Students on Software Architecture_, a collection of 27 architectural descriptions of open source software systems written by students from Delft University of Technology during a [master-level course][in4315] taking place in the spring of 2017.

[in4315]: http://www.studiegids.tudelft.nl/a101_displayCourse.do?course_id=38330

In this course, teams of approximately 4 students could adopt a project of choice on GitHub.
The projects selected had to be sufficiently complex and actively maintained (one or more pull requests merged per day).
The systems are from a wide range of domains, including testing frameworks ([Mockito], [JUnit5]), editors ([Neovim], [VSCode]), music ([Beets]), and visualisation ([Kibana]).

[mockito]: http://site.mockito.org/
[junit5]: http://junit.org/junit5/
[neovim]: https://neovim.io/
[vscode]: https://code.visualstudio.com/
[beets]: http://beets.io/
[kibana]: https://www.elastic.co/products/kibana

During an 8-week period, the students spent one third of their time on this course, and engaged with these systems in order to understand and describe their software architecture.

Inspired by Brown and Wilsons' [Architecture of Open Source Applications][aosa], we decided to organize each description as a chapter, resulting in the present online book.

This book is the third in volume the DESOSA series: The [first DESOSA book][desosa2015] resulted from the 2015 edition of the course, and contained architectural descriptions of ten (different) open source systems.
The [second DESOSA book][desosa2016] followed a year later, including 21 architectural descriptions.

[desosa2015]: https://delftswa.github.io/
[desosa2016]: https://delftswa.gitbooks.io/desosa2016/

## Recurring Themes

The chapters share several common themes, which are based on smaller assignments the students conducted as part of the course.
These themes cover different architectural 'theories' as available on the web or in textbooks.
The course used  Rozanski and Woods' [Software Systems Architecture][rw], and therefore several of their architectural [viewpoints] and [perspectives] recur.

[viewpoints]: http://www.viewpoints-and-perspectives.info/home/viewpoints/
[perspectives]: http://www.viewpoints-and-perspectives.info/home/perspectives/

The first theme is outward looking, focusing on the use of the system.
Thus, many of the chapters contain an explicit [stakeholder analysis], as well as a description of the [context] in which the systems operate.
These were based on available online documentation, as well as on an analysis of open and recently closed issues for these systems.

[context]: http://www.viewpoints-and-perspectives.info/home/viewpoints/context/
[stakeholder analysis]: http://www.mindtools.com/pages/article/newPPM_07.htm

A second theme involves the [development viewpoint][development], covering modules, layers, components, and their inter-dependencies.
Furthermore, it addresses integration and testing processes used for the system under analysis.

[development]: http://www.viewpoints-and-perspectives.info/home/viewpoints/

A third recurring theme is _technical debt_. Large and long existing projects are commonly vulnerable to debt.
The students assessed the current debt in the systems and provided proposals on resolving this debt where possible.

## First-Hand Experience

Last but not least, the students tried to make themselves useful by contributing to the actual projects.
Many pull requests have been opened, including documentation improvements ([Scrapy #2636][Scrapy 2636]), bug fixes ([Jupyter #2220][Jupyter 2220]), style / tooling fixes ([yarn #2725][yarn 2725]) or even feature implementations ([JabRef #2610][JabRef 2610], [JUnit5 #723][JUnit5 723]).
With these contributions the students had the ability to interact with the community; they often discussed with other developers and architects of the systems. This provided them insights in the architectural trade-offs made in these systems.

[JabRef 2610]: https://github.com/JabRef/jabref/pull/2610
[JUnit5 723]: https://github.com/junit-team/junit5/pull/723
[Jupyter 2220]: https://github.com/jupyter/notebook/pull/2220
[Scrapy 2636]: https://github.com/scrapy/scrapy/pull/2636
[yarn 2725]: https://github.com/yarnpkg/yarn/pull/2725

The students have written a collaborative chapter on some of the contributions made during the course. It can be found in the dedicated [contributions chapter][contrib-chapter].

[contrib-chapter]: contributions-chapter/chapter.md

## Feedback

While we worked hard on the chapters to the best of our abilities, there might always be omissions and inaccuracies.
We value your feedback on any of the material in the book. For your feedback, you can:

* Open an issue on our [GitHub repository for this book][dswa.io].
* Offer an improvement to a chapter by posting a pull request on our [GitHub repository][dswa.io].
* Contact @[delftswa][dswa.tw] on Twitter.
* Send an email to Arie.vanDeursen at tudelft.nl.

[dswa.io]: https://github.com/delftswa2017/desosa2017
[dswa.tw]: https://twitter.com/delftswa


## Acknowledgments

We would like to thank:

* Our guest speakers: [Nicolas Dintzner], [Maikel Lobbezoo], [Ali Niknam], [Alex Nederlof], [Felienne Hermans], Marcel Bakker and [Marc Philipp].
* [Valentine Mairet] who created the front cover of this book.
* Michael de Jong and Alex Nederlof who were instrumental in the earlier editions of this course.
* All open source developers who helpfully responded to the students' questions and contributions.
* The excellent [gitbook toolset] and [gitbook hosting] service making it easy to publish a collaborative book like this.

[gitbook toolset]: https://github.com/GitbookIO/gitbook-cli
[gitbook hosting]: https://www.gitbook.com/

[Maikel Lobbezoo]: https://www.linkedin.com/in/maikellobbezoo/
[Nicolas Dintzner]: http://swerl.tudelft.nl/bin/view/NicolasDintzner/WebHome
[Valentine Mairet]: https://github.com/valmai
[Ali Niknam]: https://www.linkedin.com/in/ali-niknam-50253913/
[Alex Nederlof]: http://alex.nederlof.com/
[Felienne Hermans]: https://github.com/felienne
[Marc Philipp]: http://www.marcphilipp.de/

## Further Reading

1. Arie van Deursen, Maurício Aniche, Joop Aué, Rogier Slag, Michael de Jong, Alex Nederlof, Eric Bouwers. [A Collaborative Approach to Teach Software Architecture][sigcse]. 48th ACM Technical Symposium on Computer Science Education (SIGCSE), 2017.
2. Arie van Deursen, Alex Nederlof, and Eric Bouwers. Teaching Software Architecture: with GitHub! [avandeursen.com][teaching-swa], December 2013.
3. Arie van Deursen, Maurício Aniche, Joop Aué (editors). Delft Students on Software Architecture: [DESOSA 2016], 2016.
4. Arie van Deursen and Rogier Slag (editors). Delft Students on Software Architecture: DESOSA 2015. [delftswa.github.io][desosa2015], 2015.
5. Amy Brown and Greg Wilson (editors). [The Architecture of Open Source Applications][aosa]. Volumes 1-2, 2012.
6. Nick Rozanski and Eoin Woods. [Software Systems Architecture: Working with Stakeholders Using Viewpoints and Perspectives][rw]. Addison-Wesley, 2012, 2nd edition.


[DESOSA 2016]: https://www.gitbook.com/book/delftswa/desosa2016/details
[sigcse]: https://pure.tudelft.nl/portal/en/publications/a-collaborative-approach-to-teaching-software-architecture(0c7f2aeb-f2d6-4c56-9ab7-5f47f73d133f).html
[teaching-swa]: http://avandeursen.com/2013/12/30/teaching-software-architecture-with-github/
[rw]: http://www.viewpoints-and-perspectives.info/
[aosa]: http://aosabook.org/

## Copyright and License

The copyright of the chapters is with the authors of the chapters. All chapters are licensed under the [Creative Commons Attribution 4.0 International License][cc-by].
Reuse of the material is permitted, provided adequate attribution (such as a link to the corresponding chapter on the [DESOSA book site][desosa]) is included.

Cover image credits:
TU Delft library, TheSpeedX at [Wikimedia](https://commons.wikimedia.org/wiki/File:Library_TUDelft.jpg);
Owl on [Emojipedia Sample Image Collection](http://emojipedia.org/emojipedia/sample-images) at [Emojipedia](http://emojipedia.org/emojipedia/sample-images/owl);
Feathers by [Franco Averta](http://www.flaticon.com/authors/franco-averta) at [Flaticon](http://flaticon.com).


[![Creative Commons](img/cc-by.png)][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[desosa]: https://www.gitbook.com/book/delftswa/desosa2016/details
