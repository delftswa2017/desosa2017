# Contributions for DESOSA 2017

This chapter outlines some of the contributions made by several teams to their open source project. Contributions have been categorized based on their types. At the end, a list of all mentioned Pull Requests is provided for more information. It should be mentioned that much more Pull Requests were filed during the course, this chapter only sketches a broad overview of the diversity.

## Documentation fixes

Several teams proposed changes to the documentation of their projects. This could go as far as fixing typo's or updating the documentation for deprecated / added features.
One of the teams to file such Pull Requests was Kibana ([#10709][KI10709] :white_check_mark:, [#10714][KI10714] :white_check_mark:, [#10715][KI10715] :white_check_mark:). Often, these Pull Requests were merged without much discussion.

[KI10709]: https://github.com/elastic/kibana/pull/10709
[KI10714]: https://github.com/elastic/kibana/pull/10714
[KI10715]: https://github.com/elastic/kibana/pull/10715

## Bug fixes

Several teams went through the issue lists of their projects to find bugs to fix.
An example would be the [bug][VSbug] in the search functionality of Visual Studio Code:
when a user searched for two terms in Visual Studio Code, the 'clear results' button was clicked  and alt+up was used to get the last search item, the second last was shown.

To get the last history item the function `showPreviousSearchTerm()` was called in the file `src\vs\workbench\parts\search\browser\searchWidget.ts`. This function is shown in [Snippet 1](#snippet-1)

<div id="snippet-1"></div>

```typescript
public showPreviousSearchTerm() {
	let previous = this.searchHistory.previous();
	if (previous) {
		this.searchInput.setValue(previous);
	}
}
```
**Snippet 1** - Original method for showing previous search terms

 The problem was however, that this function returns the second last element from an array of previously searched search terms. When a user hits the 'clear results' button, no element is added to this array. This means that after hitting 'clear results' the function `showPreviousSearchTerm()` will return the second last item, which is obviously not the last searched item. First, a solution was created using a flag to indicate that the 'clear results' button was hit, but after looking further into this a new bug was introduced. A better solution was to change the function such that when the search term value is empty the `showPreviousSearchTerm()` should return the current history element instead of the previous. The solution is shown in the [Snippet 2](#snippet-2).

<div id="snippet-2"></div>

```typescript
public showPreviousSearchTerm() {
	let previous;
	if (this.searchInput.getValue().length === 0) {
		previous = this.searchHistory.current();
	} else {
		previous = this.searchHistory.previous();
	}
	if (previous) {
		this.searchInput.setValue(previous);
	}
}
```
**Snippet 2** - `showPreviousSearchTerm` with the fix applied

To propose this solution for Microsoft Visual Studio Code a pull request was filed ([#21859][VS21859] :white_check_mark:). After signing the CLA the Travis build had
to be fixed and some more feedback had to be processed. A maintainer ([@sandy081]) found a
problem with the proposed solution. After resolving this problem the pull request
was accepted by the project.

Another [bug][VSbug2] that has been resolved is a problem with prefix matching within Visual Studio Code. When a user searched for the number '4' in both command palette and the settings editor of Visual Studio Code. The search function did not only match '4', but also matched the letter 'T'. So these search functions matched false positives.

Visual Studio Code calculates the distance between alphanumeric values.
This works nicely for lowercase and uppercase letters.
However, the distance between `4` and `T` happens to be 32 as well.
The original method is shown in [Snippet 3](#snippet-3).

<div id="snippet-3"></div>

```typescript
if (ignoreCase) {
	if (isAlphanumeric(wordChar) && isAlphanumeric(wordToMatchAgainstChar)) {
		const diff = wordChar - wordToMatchAgainstChar;
		if (diff === 32 || diff === -32) {
			// ascii -> equalIgnoreCase
			continue;
	  }

	} else if (word[i].toLowerCase() === wordToMatchAgainst[i].toLowerCase()) {
		// nonAscii -> equalIgnoreCase
		continue;
	}
}
```
**Snippet 3** - Original method `_matchesPrefix`

The pull request that was filed to fix this has been closed ([#22743][VS22743] :x:).
The maintainer pushed a fix for the problem which reused an already-existing method for this comparison. This was a better approach than adding the same functionality again.

[VSbug]: https://github.com/Microsoft/vscode/issues/21600
[VSbug2]: https://github.com/Microsoft/vscode/issues/22401
[VS21859]: https://github.com/Microsoft/vscode/pull/21859
[VS22743]: https://github.com/Microsoft/vscode/pull/22743
[@sandy081]: https://github.com/sandy081

While some teams fixed reported bugs, other teams also discovered bugs themselves.
An example issue was found by team Yarn, where the initial run of the test suite failed on one of the team members computers.
The underlying issue was usage of spaces in the local directory of Yarn.
Based on [a similar issue on the Node repository][YarnNode], the fix was to escape (with quotes), the executing location of Yarn in the test suite.
Consequently, a pull request ([#2700][Yarn2700] :white_check_mark:) was opened and quickly merged thereafter by [@bestander].

A similar issue was found, where running the test suite broke on the initial checkout.
This time, pre-existing usage of Yarn influenced the outcome of the test suite.
The tests were therefore not run in isolation and could be influenced by the configuration of the user.
An initial fix was submitted ([#2725][Yarn2725] :construction:), but was insufficient as [@bestander] pointed out the test suite should use mocks instead.
At the moment of writing, the pull request is still ongoing as mocking the configuration has been unsuccesful thus far.

Several members of team Yarn use Yarn in their daily development toolkit too.
In a different course, they were using Yarn as well and discovered a bug.
Packages which do not supply binaries would be logged by Yarn.
However, the call to the reporter missed an argument of the package name.
As team Yarn was familiar with the architecture of the project, finding the issue took little time and [#2969][Yarn2969] :white_check_mark: was submitted to fix this small issue.

[YarnNode]: https://github.com/nodejs/node/issues/6803
[Yarn2700]: https://github.com/yarnpkg/yarn/pull/2700
[Yarn2725]: https://github.com/yarnpkg/yarn/pull/2725
[Yarn2969]: https://github.com/yarnpkg/yarn/pull/2969
[@bestander]: https://github.com/bestander

## Technical debt

Another popular topic was technical debt. As part of the course the (amount of) technical debt was analysed using tools, such as [SonarQube]. Teams could use their findings to improve the projects that they were analysing.

For instance, the Kibana team tried to remove unnecessary usage of the [Lodash] library ([#10746][KI10746] :white_check_mark:). There are multiple methods in Lodash that can easily be replaced by very similar native ES6 methods. These unnecessary lodash methods have been removed in the contribution. Using different tools to look for technical debt the Kibana team found more issues. Some syntax errors were found in the test code. There was an incorrect `.json` file and a quoting issue with a `.sh` file. This was another possibility for a contribution ([#10747][KI10747] :white_check_mark:).

Besides removing packages, outdated dependencies can also be upgraded.
The Yarn team did a cleanup ([#2812][Yarn2812] :white_check_mark:) to upgrade the old dependencies.
Additionally, several breaking changes of the typechecker [Flow] were fixed.
This pull request was merged within a couple of days by [@bestander].
As a consequence of this pull request, now whenever [Flow] releases a new version, Yarn upgrades within a couple of days in contrast to the months it took before.

While external dependencies can be outdated, internal function calls can be too.
An example is an internal logging call in Yarn, which was using the `console` directly, rather than their new `Reporter` infrastructure.
Team Yarn submitted a simple line change ([#2844][Yarn2844] :construction:), but [@bestander] pointed out that there was an undocumented reason for sticking to `console`.
In fact, [@kittens] pointed out in [a different pull request][Yarn1980] (that is still open) that it would break external tooling integration.
Up to this point, there is no test that verifies this issue to ensure no breaking changes are introduced.
For this reason, [#2844][Yarn2844] is blocked and left open until the underlying issue has been resolved.

## New features and behavioral changes

Besides documentation/bug fixes and resolving technical debt, teams also contributed new features and (potentially breaking) behavioral changes.

The direct competitor and inspiration of Yarn, npm, changed in its latest major version a behavioral change regarding the output of error logs of npm.
Since compatibility with npm is one of the main goals of Yarn, it is important to update the code of Yarn accordingly.
Therefore, [#2870][Yarn2870] :construction: was submitted to fix this.
This pull request also included a brand new test suite to test the entrypoint of Yarn: [`src/cli/index.js`][Yarnindexjs], which was untested up to this point.
Initially, [@bestander] was reluctant to change the behavior, but pointed out a different and more user-friendly solution.
At the moment, the pull request still has to be updated to incorporate the feedback.

An interesting side-note is that in [#2870][Yarn2870] a different bug was found in the `--cache-folder` option on the commandline.
While the pull request is not merged, this particular bug fix was incorporated by [Facebook] employee [@arcanis] in [#3033][Yarn3033].

Measuring and maintaining good code coverage is required to remain with a healthy software project.
Correctly calculating code coverage is therefore crucial, to measure which parts of a project require tests to keep confidence in the product.
While investigating technical debt, team Yarn discovered that the code coverage tool of Yarn was incorrectly configured and did not report completely untested files.
Luckily, [Jest] (the testrunner used by Yarn) incoporates code coverage calculation and has configuration available.
A one-line change pull request ([#2892][Yarn2892] :white_check_mark:) was submitted to fix this inconsistency and sadly point out that the code coverage of Yarn was 20 percent lower than previously reported.
As a consequence, the Yarn core developers shifted more focus on tests and now more strictly enforce tests when integrating pull requests.

[KI10746]: https://github.com/elastic/kibana/pull/10746
[KI10747]: https://github.com/elastic/kibana/pull/10747
[Yarn2812]: https://github.com/yarnpkg/yarn/pull/2812
[Yarn2844]: https://github.com/yarnpkg/yarn/pull/2844
[Yarn1980]: https://github.com/yarnpkg/yarn/pull/1980#discussion_r89621763
[Yarn2870]: https://github.com/yarnpkg/yarn/pull/2870
[Yarn2892]: https://github.com/yarnpkg/yarn/pull/2892
[Yarn3033]: https://github.com/yarnpkg/yarn/pull/3033/files#diff-867becf4a9c2c6c6d4e7c1278750724eR372
[Yarnindexjs]: https://github.com/yarnpkg/yarn/blob/6d8dcec7e84d7271bc3acde2946cfcc5a93b530f/src/cli/commands/index.js
[SonarQube]: https://www.sonarqube.org/
[Lodash]: https://lodash.com
[Flow]: https://flow.org/
[Facebook]: https://facebook.com
[Jest]: https://facebook.github.io/jest/
[@kittens]: https://github.com/kittens
[@arcanis]: https://github.com/arcanis
