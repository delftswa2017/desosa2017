# Contributions for DESOSA 2017

This chapter outlines the conributions that each of the teams in the course were able to make to their open-source project. Contributions have been categorized and are presented below:

## Language/Typo/Link fixes
- This [pull request](https://github.com/elastic/kibana/pull/10709) fixes some language mistakes in the `FAQ.md` file of Kibana's documentation.
- This [pull request](https://github.com/elastic/kibana/pull/10714) fixes a typo in the `kbn_server.js` file in the Kibana project.
- This [pull request](https://github.com/elastic/kibana/pull/10715) fixes a broken link in Kibana's `CONTRIBUTING.md` file.

## Bug fixes
- This Kibana [issue](https://github.com/elastic/kibana/issues/9108) depicts a problem in Safari where exporting data would lead to a display of the JSON in the browser instead of a download action (labeled P3: nice to have bug-fixes). Investigation led to finding out it was a [bug](https://bugs.webkit.org/show_bug.cgi?id=102914) in Webkit that has recently been fixed. An upgraded version of Safari (10.1) should thus solve the problem. Workaround possibilities exist, but these are unreliable. Hence, this analysis was posted in the [issue](https://github.com/elastic/kibana/issues/9108) on Github along with a suggesion for the Kibana team to wait for the new version of Safari. For more info on the download library please visit this [link](eligrey/FileSaver.js#12).

## Technical debt
- the Kibana team is trying to remove unnecessary usage of the [Lodash](https://lodash.com) library. There are multiple methods in Lodash that can easily be replaced by very similar native ES6 methods. This [pull request](https://github.com/elastic/kibana/pull/10746) removes some of the unnecessary lodash methods.
- After analyzing Kibana using tools to look for technical debt, some syntax errors were found in the test code. There was an incorrect `.json` file and a quoting issue with a `.sh` file. This [pull request](https://github.com/elastic/kibana/pull/10747) solved these issues.

## Contributions for team-scikit-learn

### IRC URL link points to default apache page
irc.freenode.net (referred as contact point for scikit-learn at bottom of readme.rst) pointed to default new apache server page. It seems wechat.freenode.net, which is provided by freenode.net main page, aloows access to #scikit-learn irc. It needs replacement to prevent people being pointed to empty pages.

The provided solution had a small impact on documentation debt	

### Using sigmoid for normalizing scores in calibration_curve
In the plot_calibration_curve.py [\example](http://scikit-learn.org/stable/auto_examples/calibration/plot_calibration_curve.html#sphx-glr-auto-examples-calibration-plot-calibration-curve-py), it uses normalize argument for calibration_curve. Somehow, normalize argument of the calibration_curve then sets a bad example as it uses the same normalization.

 The solution should either deprecate the "normalize" option or replace it with a sigmoid, because currently it can look really bad when in reality it's not as bad, just because the zero point of the decision function is moved arbitrarily.

The provided solution addresses a small bit of technical debt, fixing a function working in unexpected ways.

### TODO/FIXME comments in the code
 When doing analysis of TODO/FIXME comments currently present in the Scikit-learn repository, there are files in which the comments were and at the age of the comments. This gives 76 TODO comments in 48 files and 20 FIXME comments in 16 files. The comments have an average age of 1390 days. With one striking example being a "FIX ME SOON!" comment added on Jan 3, 2013 (`30045e1`). Which is still present in the current code (but in a different file). This shows that this might not be the best way to track these issues (and since there aren't many recent TODO/FIXME comments it seems like a practice that is no longer that acceptable in Scikit-learn). To avoid technical debt which contributors might not be aware of, it seems to me that it would be better to have these among the issues on GitHub to keep everything in a central location

Proposed workflow:
* Create an issue on GitHub for each file (python file, above table also contains a few /doc/ files were it might be acceptable to keep the TODOs) still containing TODOs/FIXMEs
* File by file create issues for each TODO/FIXME comment
* Either remove the comments in a new PR linking the newly created issues or if it is preferable to keep the comments in the code as well, instead of removing the comment add a link to the issue in the comment.

The provided solution would have had a measurable effect on the technical debt, fixing a great many old problems that are currently being ignored. However the team chose to close the issue, and ignore it, meaning it did not have any impact.

### Metric invariance tests for multiclass and multilabel
There are different metrics to rank the results of multiclass and multilabel classifiers. But there are no tests to check if the results of these remain the same if the labels/classes are permutated.

We added tests for all the multiclass and multilabel metrics which test whether the score remains the same after a permutation. These were added in /sklearn/metrics/tests/test_common.py, which is a file where all tests common to the metrics are stored.

The provided solution improves the already existing tests, to cover a less evident use case that is still realistic to happen.

