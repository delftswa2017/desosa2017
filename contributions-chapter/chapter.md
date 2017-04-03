# Contributions for DESOSA 2017

## Team Kibana
Team Kibana was able to make a total of six contributions to the Kibana project. These contributions can be subdivided into three categories:

**1. Language/Typo/Link fixes**
- This [pull request](https://github.com/elastic/kibana/pull/10709) fixes some language mistakes in the `FAQ.md` file of Kibana's documentation.
- This [pull request](https://github.com/elastic/kibana/pull/10714) fixes a typo in the `kbn_server.js` file.
- This [pull request](https://github.com/elastic/kibana/pull/10715) fixes a broken link in Kibana's `CONTRIBUTING.md` file.

**2. Bug fixes**
- This [issue](https://github.com/elastic/kibana/issues/9108) depicts a problem in Safari where exporting data would lead to a display of the JSON in the browser instead of a download action. The issue was labeled P3: nice to have bug-fixes. We investigated the issue and found that it was a [bug](https://bugs.webkit.org/show_bug.cgi?id=102914) in Webkit that has recently been fixed. An upgraded version of Safari (10.1) should thus solve the problem. There were also some workaround possibilities, but these were unreliable. Hence, we commented our analysis in the [issue](https://github.com/elastic/kibana/issues/9108) on Github and suggested that the team would wait for the new version of Safari. For more info on the download library please visit this [link](eligrey/FileSaver.js#12).

**3. Technical debt payoffs**
- the Kibana team is trying to remove unnecessary usage of the [Lodash](https://lodash.com) library. There are multiple methods in Lodash that can easily be replaced by very similar native ES6 methods. This [pull request](https://github.com/elastic/kibana/pull/10746) removes some of the unnecessary lodash methods.
- After analyzing Kibana using tools to look for technical debt, we found some syntax errors in the test code. There was an incorrect `.json` file and a quoting issue with a `.sh` file. This [pull request](https://github.com/elastic/kibana/pull/10747) solved these issues.
