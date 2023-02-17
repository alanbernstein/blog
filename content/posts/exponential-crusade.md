---
title: "Lies, Damned Lies, and Exponentials"
author: "Alan Bernstein"
date: 2021-02-01
publishdate: 2021-02-01
tags: ["math", "visualization"]
---

An exponentially increasing blog post.

<!--more-->

It bugs me when people misuse the term "exponentially bigger", often just comparing two numbers. To describe the growth of something as exponential, more than two numbers *must* be taken into account (unless you somehow have evidence that the underlying process is itself exponential, which is generally not the case in random charts and quotes found on the internet). Exponential growth is a *trend*, a constant multiplicative factor over the independent variable.

I'm sure this point has been made a million times by other nerds. I noticed a related point recently which is a bit more subtle.


## Example 1: Appropriately emphasizing a true outlier


A coworker shared [this tweet](https://pbs.twimg.com/media/EUm-p1AXkAwHpVs?format=jpg&name=medium):

![Figure 1: Chart of unemployment spike]({{< imgPrefix >}}/exponential-crusade/tweet-1-chart)

Then noted

> maybe they should have used a log chart

Noting the excuse from the article:

> "The linear scale shows the real human impact -- a growth twice the size is twice the number of real people infected.”

I responded

> as a mathy person i scoffed at this, but i guess they have a point

As a technical person, it's easy for me to forget that a log-scale plot might be more difficult to interpret than a linear-scale plot. Particularly with a bar chart, where the filled rectangles make up shapes, which are often interpreted in charts based on their relative area. Showing relative size in an immediately-interpretable way can have its value.

The trend here isn't exponential. It's a true spike, so presenting it in a way that emphasizes that makes sense.

## Example 2: Inappropriately hiding small details

Another time, [this tweet](https://twitter.com/chsrbrts/status/1320012627947540480) was shared: 

![Figure 2: Chart of NLP parameter growth]({{< imgPrefix >}}/exponential-crusade/tweet-2-chart)


"This slide puts into context how big of a step forward GPT-3 is in the field of natural language processing.""


So, I responded:

> my pet peeve: failure to use log scale when appropriate

Then made a log-scale chart and shared it:

![Figure 3: Chart of NLP parameter growth, log scale]({{< imgPrefix >}}/exponential-crusade/nlp-chart-log)

So someone responded:

> that kind of defeats the purpose of the chart which is to show the massive difference. I think it has more impact the other way, though the log scale certainly gives more visual information about the differences between all the others

Which, of course, is the same argument I just explained above. I said:

> Sure, the purpose of the tweet is to point out the difference, which is essentially just saying 175B vs 17B. The chart itself is pointless because you can't get any information from the bars, you have to read the numbers instead. Without a log scale, it's just a very poorly formatted table

But what I should have said was this:

The tweet tries to make a claim with a linear-scale chart of a trend that is fundamentally exponential.

If you look at the record-breaking y-values, excluding the latest one, and extrapolate vs time, the expected y-value is something like 70B, vs actual 175B. This is 2.5X jump over the expected value. Previous high-outliers were something like 8B when 5B was expected, a 1.6X jump. 175B is a LOT of parameters, and a 2.5x jump over the expected value is big, AND it's the biggest jump. But it's not a MIND-BLOWING jump that justifies a chart that totally obscures this historical development by hiding all of the details behind a linear scale.

"Fundamentally exponential" seems reasonable, like many things in the computing world. But is it true? Yes:

![Figure 4: Chart of NLP parameter growth, log scale vs time]({{< imgPrefix >}}/exponential-crusade/nlp-chart-log-time.png)
