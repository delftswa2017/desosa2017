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

## Technical debt

Another popular topic was technical debt. As part of the course the (amount of) technical debt was analysed using tools, such as [SonarQube]. Teams could use their findings to improve the projects that they were analysing.

For instance, the Kibana team tried to remove unnecessary usage of the [Lodash] library ([#10746][KI10746] :white_check_mark:). There are multiple methods in Lodash that can easily be replaced by very similar native ES6 methods. These unnecessary lodash methods have been removed in the contribution. Using different tools to look for technical debt the Kibana team found more issues. Some syntax errors were found in the test code. There was an incorrect `.json` file and a quoting issue with a `.sh` file. This was another possibility for a contribution ([#10747][KI10747] :white_check_mark:).

[KI10746]: https://github.com/elastic/kibana/pull/10746
[KI10747]: https://github.com/elastic/kibana/pull/10747
[SonarQube]: https://www.sonarqube.org/
[Lodash]: https://lodash.com
