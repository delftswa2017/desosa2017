# Contributions for DESOSA 2017

This chapter outlines the conributions that each of the teams in the course were able to make to their open-source project. Contributions have been categorized and are presented below:

## Language/Typo/Link fixes
- This [pull request](https://github.com/elastic/kibana/pull/10709) fixes some language mistakes in the `FAQ.md` file of Kibana's documentation.
- This [pull request](https://github.com/elastic/kibana/pull/10714) fixes a typo in the `kbn_server.js` file in the Kibana project.
- This [pull request](https://github.com/elastic/kibana/pull/10715) fixes a broken link in Kibana's `CONTRIBUTING.md` file.

## Bug fixes

### Kibana - Export bug

This Kibana [issue](https://github.com/elastic/kibana/issues/9108) depicts a problem in Safari where exporting data would lead to a display of the JSON in the browser instead of a download action (labeled P3: nice to have bug-fixes). Investigation led to finding out it was a [bug](https://bugs.webkit.org/show_bug.cgi?id=102914) in Webkit that has recently been fixed. An upgraded version of Safari (10.1) should thus solve the problem. Workaround possibilities exist, but these are unreliable. Hence, this analysis was posted in the [issue](https://github.com/elastic/kibana/issues/9108) on Github along with a suggesion for the Kibana team to wait for the new version of Safari. For more info on the download library please visit this [link](eligrey/FileSaver.js#12)

### Visual Studio Code - Search history bug

The search function of Visual Studio Code contained a [bug](https://github.com/Microsoft/vscode/issues/21600). When a user searched for two terms in Visual Studio Code, the 'clear results' button was clicked  and alt+up was used to get the last search item, the second last was shown. 

To get the last history item the function `showPreviousSearchTerm()` was called in the file `src\vs\workbench\parts\search\browser\searchWidget.ts`. This function looked as follows:

```javascript
	public showPreviousSearchTerm() {
		let previous = this.searchHistory.previous();
		if (previous) {
			this.searchInput.setValue(previous);
		}
	}
```
 The problem was however, that this function returns the second last element from an array of previously searched search terms. When a user hits the 'clear results' button, no element is added to this array. This means that after hitting 'clear results' the function `showPreviousSearchTerm()` will return the second last item, which is obviously not the last searched item. First, a solution was created using a flag to indicate that the 'clear results' button was hit, but after looking further into this a new bug was introduced. A better solution was to change the function such that when the search term value is empty the `showPreviousSearchTerm()` should return the current history element instead of the previous. The solution is shown in the code snippet below:

```javascript
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
To propose this solution for Microsoft Visual Studio Code a [pull request](https://github.com/Microsoft/vscode/pull/21859) was created. The Microsoft bots detected that a Contribution License Agreement was not required for the pull request. [@sandy081](https://github.com/sandy081) then replied stating he will take a look at it and get back, but the Travis build failed, which needed to get fixed first. Some styling issues were present in the code, which were resolved by installing [TSLint](https://github.com/Microsoft/vscode-tslint), a Visual Studio Code plugin.

After the weekend, [@sandy081](https://github.com/sandy081) reacted on the pull request again and stated that the new approach looks good, but that the approach made him think about a related case. If a user types some text after clearing the search result and try to get the previous term, the search term was not stored in the `searchHistory`. 

To solve the new problem, the function `showPreviousSearchTerm` needed to be updated further. When the `searchInput` was not empty the `searchInput` needed to be added to the history. The problem was, however, if this was added every time a user asks for the previous search term, the search terms will keep toggling between the last two search terms. This is due to the fact that when a search term is added to the `searchHistory`, this newly added search term is on top of the other elements. An extra function needed to be added to the `HistoryNavigator`, namely when a search term which is present in the `searchInput` is not yet stored, only then the search term needs to be added to the `searchHistory`. This function is given below.

```javascript
    public addIfNotPresent(t: T) {
        if (!this._history.contains(t)) {
            this.add(t);
        }
    }
```  

This function is now called from the function `showPreviousSearchTerm`. When the `searchInput` is not empty as shown below.

```javascript
    if (this.searchInput.getValue().length === 0) {
            previous = this.searchHistory.current();
    } else {
            this.searchHistory.addIfNotPresent(this.searchInput.getValue());
            previous = this.searchHistory.previous();
    }
```

Upon completing, the changes were pushed and an explanation was given to [@sandy081](https://github.com/sandy081). After pushing it however the Travis build failed on a test. However [@sandy081](https://github.com/sandy081) replied that the test failing in Travis build was due to other changes in the stream. Furthermore, he replied that the changes were indeed what he had mentioned and he merged the pull request to the master.

### Visual Studio Code - Prefix matching bug

Issue [#22401](https://github.com/Microsoft/vscode/issues/22401) appeared when a user searched for the number '4' in both command pallete and the settings editor of Visual Studio Code. The search function did not only match '4', but also matched the letter 'T'. So these search functions matched false positives.

[@sandy081](https://github.com/sandy081) commented on the issue where he stated that it looks like a bug in the `prefixMatching` of Visual Studio Code. 
After finding out what functions were called when a user searches in for example command pallete, it was found that functions in the file `base\common\filter.ts` were called. 
Since the `prefixMatching` was mentioned in the Github issue, we started looking at the function `_matchesPrefix`. 
The code from this function is shown in the figure below. 

```javascript
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
At this point it was found that this piece of code returns, when the number '4' was matched versus the capital letter 'T'. 
Though it was not immediately clear what this piece of code should do. 
In the comment in the figure above, is stated `ascii -> equalIgnoreCase`. Therefore google was used to search for javascript ascii and the w3school page about [HTML ascii reference](https://www.w3schools.com/charsets/ref_html_ascii.asp) was found. 
At this page characters are mapped as integers. From this page it became clear that the distance between a lower case letter and an upper case letter was 32, which is why `if (diff === 32 || diff === -32)` is checked. 
By using this if statement, letters can be matched regardless if a letter is written as a capital or a lower case. 
The problem however is the if statement before this one. Here it is checked if the character is alphanumeric. 
The problem with this however, is that the distance between a capital 'T' and the number '4' was also 32. 
So it was decided that the `isAlphanumeric` function had to be replaced by the function `isAsciiLetter`, because this only matches letters. When it was clear this fixed the bug, a [pull request](https://github.com/Microsoft/vscode/pull/22743) was created by [@rpjproost](https://github.com/rpjproost). 
After that [@wimspaargaren](https://github.com/wimspaargaren) posted a comment in the issue to explain the problem of this function, such that it was clear what the problem was.
After the pull request was created, [@bpasero](https://github.com/bpasero) created [another commit](https://github.com/Microsoft/vscode/commit/08b14f723067b729ab4b952c30cdc976242e2100) with a different solution to resolve the issue. 
[@bpasero](https://github.com/bpasero) reused a function in the file `strings.ts`. 
In this file the same check is carried out, so a better solution was to use the same piece of code already written in `strings.ts`. 
[@bpasero]https://github.com/bpasero() also added a test for the issue in this commit, such that this issue will not appear again.
After that [@bpasero](https://github.com/bpasero) closed the [pull request](https://github.com/Microsoft/vscode/pull/22743) which was created and reacted on the issue. 
Here [@bpasero](https://github.com/bpasero) thanked us, because the right problem was pointed out, which led to a proper fix for the issue.

## Technical debt
- the Kibana team is trying to remove unnecessary usage of the [Lodash](https://lodash.com) library. There are multiple methods in Lodash that can easily be replaced by very similar native ES6 methods. This [pull request](https://github.com/elastic/kibana/pull/10746) removes some of the unnecessary lodash methods.
- After analyzing Kibana using tools to look for technical debt, some syntax errors were found in the test code. There was an incorrect `.json` file and a quoting issue with a `.sh` file. This [pull request](https://github.com/elastic/kibana/pull/10747) solved these issues.

