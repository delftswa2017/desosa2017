# Contributions for DESOSA 2017

This chapter outlines some of the contributions made by several teams to their open-source project. Contributions have been categorized based on their types. At the end a list of all mentioned Pull Requests will be provided for more information. It should be mentioned that much more Pull Requests were filed during the course, this chapter only sketches a broad overview of the diversity.

## Documentation fixes
Several teams proposed changes to the documentation of their projects. This could go as far as fixing typo's or updating the documentation for deprecated / added features.
One of the teams to file such Pull Requests was Kibana ([#10709][KI10709] :white_check_mark:, [#10714][KI10714] :white_check_mark:, [#10715][KI10715] :white_check_mark:). Often, these Pull Requests were merged without much discussion.

[KI10709]: https://github.com/elastic/kibana/pull/10709
[KI10714]: https://github.com/elastic/kibana/pull/10714
[KI10715]: https://github.com/elastic/kibana/pull/10715

## Bug fixes


## Technical debt

Another popular topic was technical debt. As part of the course the (amount of) technical debt was analysed using tools like [SonarQube]. Teams could use their findings to improve the projects that they were analysing.

For instance, the Kibana team is trying to remove unnecessary usage of the [Lodash](https://lodash.com) library ([#10746][KI10746] :white_check_mark:). There are multiple methods in Lodash that can easily be replaced by very similar native ES6 methods. These unnecessary lodash methods have been removed in the contribution. Using different tools to look for technical debt the Kibana team found more issues. Some syntax errors were found in the test code. There was an incorrect `.json` file and a quoting issue with a `.sh` file. This was another possibility for a contribution ([#10747][KI10747] :white_check_mark:).

[KI10746]: https://github.com/elastic/kibana/pull/10746
[KI10747]: https://github.com/elastic/kibana/pull/10747
[SonarQube]: https://www.sonarqube.org/
