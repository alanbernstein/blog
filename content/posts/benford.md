---
title: "Why Benford's Law is Obvious"
date: 2020-11-28
draft: false
tags: ["math", "counter-intuitive"]
---

[Benford's Law](https://en.wikipedia.org/wiki/Benford%27s_law) states that in many naturally occurring collections of numbers, the leading digit is likely to be small. I love math factoids like this, and I remember how deeply unintuitive this seemed when I first learned it. Now, I find myself looking for a way to explain how intuitive it really is.

<!--more-->

## TL;DR

Ok, Benford's law isn't obvious. But what would the world look like if it were?

Benford's law follows unavoidably from a certain type of probability distribution (uniform in the logarithmic domain), which happens to be common in real-world data. I can draw some charts that -- to me -- make this perfectly clear. Somehow, that doesn't make it any less surprising to learn. Go figure.

I contend that the surprise comes from a lack of familiarity with the log-uniform distribution. What if we, as a society, internalized that distribution *instead* of the "usual" linear-uniform one? In this post, I explain what the counterpart of Benford's law would be in that case. It turns out, it's almost too obvious to mention. Which is the point.


## Benford's Law

When you first hear of it, the thinking might go something like this: if you choose a number randomly, shouldn't the first digit be uniformly distributed? Even if the original distribution isn't uniform, as long as it covers a wide enough range, why would the *first digit* have any bias?

Explanations abound, but I find that they often miss the crucial point (like this otherwise fantastic [video](https://youtu.be/etx0k1nLn78) for example). Simply put, it is a direct consequence of the [log-uniform distribution](https://en.wikipedia.org/wiki/Reciprocal_distribution), which governs these "naturally occurring collections of numbers", e.g. measurements, population counts, etc. If you can accept that these natural collections tend to be log-normal distributed, Benford's Law is "obvious", that is, an unavoidable consequence. Some simply explain this empirically, giving examples. But I think there is more to it.

Why do some collections of numbers have this tendency? I like to think of it like this:
- The logarithmic scale is *at least* as natural a way to look at the world as the linear scale is.
- In a given scale (linear, log, or otherwise), a uniform distribution is the "simplest" option. It's sort of a default distribution, perhaps in part due to being the maximum entropy distribution for a bounded domain.

I'm aware that this is an academic viewpoint - I'm using "obvious" facetiously here. While the log-uniform distribution may be more "natural" in some sense, the linear-uniform distribution is certainly not unusual. Roll a die, draw a card, pick a ball from an urn - these are all basic processes, easily understood, and obviously uniform. While they may be more common in the built environment rather than in nature, they are still regular occurrences to a human child living in society, helping to reify the linear scale in her mind.

The linked video also presents a counterexample to Benford's law, plus a counterpart law with its corresponding counterexample. Paraphrased:

> Benford's Law: most-significant digits are expected to be biased toward lower values with a logarithmic trend, *if* the range of values spans multiple orders of magnitude. 
>> Benford Counterexample (Biden votes): If the data spans just a single order of magnitude (specifically [10^n, 10^(n+1)) so the number of digits is constant, then the first-digit distribution just reflects the data distribution itself. Benford's law is not *violated*, it is rather *not applicable*.

> Last-digit test: least-significant digits are expected to be distributed uniformly, *if* the range of values is wide enough, relative to the precision of the values. 
>>Last-digit counterexample (incumbent votes): If the data spans just a single, **low**, order of magnitude, e.g. [10, 100), then the last two digits are just *the digits*, so the last-digits distribution just reflects the data distribution itself. The last-digit test is not *violated*, it is rather *not applicable*.

There's a pleasing sort of duality here, and illustrating each of these with the two political parties' vote counts is pretty cute.


## Another counterpart

Although these are interesting lines of thought, they prompted another question, the real motivation for writing this: is there *another* counterpart to Benford's Law, which might be equally surprising to a culture that thinks in the logarithmic scale by default? Of course, human sensory perception is logarithmic, as is our natural perception of integers. But early education beats that out of us, and our culture generally encourages us to consider the linear scale as the default way of thinking about numbers - the Way Numbers Really Are.

If, instead, we were trained from a young age to think about the logarithmic scale as the default, then what sort of distribution would lead to a similarly surprising result, and what would that result be?

After ruminating on this topic over the years, and a concerted hour or two of trying to answer this question, I found a candidate. I'll restate Benford's again for comparison:

> Benford's Law: When accustomed to the linear scale, a log-uniform distribution results in a suprising bias in first-digits, logarithmically decreasing from 1 to 9.

And the linear counterpart:

> Drofben's Law: When accustomed to the logarithmic scale, a linear-uniform distribution results in a surprising bias in number-of-digits, exponentially increasing from 1 (to N).

These charts illustrate both laws, as described above -- but I'll elaborate.

### Graphical explanation, Benford's Law

![Figure 1: Log-uniform random data]({{< imgPrefix >}}/benford/figure1.png)
_Figure 1: Log-uniform random data_

This is a set of three views of the same random data set, following a log-uniform distribution.

- 1a shows that log-uniform data follows a logarithmically-decreasing trend, *when viewed in the linear domain*.
- 1b shows that log-uniform data follows a constant trend, when viewed in the (arguably more appropriate) logarithmic domain.
- 1c shows Benford's law directly, with bar heights corresponding to first-digit bias. Note that this shape closely resembles the shape of the distribution in 1a -- it isn't identical, because 1c kind of "layers" the histograms from each level of magnitude in 1a, into a new form that examines only first digits instead of all values.
- 1d (aside from being kind of busy because I'm a bad graphic designer) shows where these "layers" come from. The black trace represents the determinstic values of the function first_digit(x) for all values of x in [1, 10000]. The green regions cover all numbers that start with 1, and they're widest -- that cumulatve width corresponds to the height of the bar for digit 1 in figure 1c. Red regions correspond to numbers that start with 2, with a more moderate cumulative width. Purple corresponds to 5, with a much smaller width, and similarly for all other digits.


**This figure explains why Benford's Law is "obvious". It may be more clear to explain the logical progression of thought:**
1. **This data follows a natural distribution -- log-uniform -- illustrated by the constant trend in the logarithmic domain (1b).**
2. **This necessitates a logarithmic-decreasing trend in the linear domain (1a).**
3. **This necessitates a logarithmic-decreasing trend in the first digits (1c, 1d).**

### Graphical explanation, Drofben's Law

And here are the corresponding charts for Drofben's law:

![Figure 2: Linear-uniform random data]({{< imgPrefix >}}/benford/figure2.png)
_Figure 2: Linear-uniform random data_

This is a set of three views of another random data set, following a linear-uniform distribution.

- 2a shows that linear-uniform data follows a constant trend, when viewed in the linear domain.
- 2b shows that linear-uniform data follows an exponentially-increasing trend, when viewed in the logarithmic domain.
- 2c shows Drofben's law directly, with bar heights corresponding to number-of-digits bias. Note that this shape closely resembles the shape of the distribution in 2b.
- 2d shows the analogous "layers" of Drofben's law -- these layers just represent magnitude. The gray region, representing numbers with five digits, takes up 90% of the total width. Pink, for four digits, takes 9%, and so on.


In the second case, these layers just reflect the counts of integers in ranges: |[1, 10)| = 9, |[10, 100)| = 90, |[100, 1000)| = 900, etc -- this seems almost too obvious to mention. But, that's what I was looking for -- a result that's surprising to an alien, logarithmic culture *should* be obvious to our linear minds.

([code for charts](https://gist.github.com/alanbernstein/39cc97fc582cbb2cd30df59c40853129))

## The digits are not the value

![The treachery of digits: an homage to Magritte's The Treachery of Images, with "This is not a number" as a caption for the hexadecimal representation of the floating-point value NaN, "Not a Number"]({{< imgPrefix >}}/benford/treachery-of-digits-hex.png)
_The treachery of digits, with apologies to [Magritte](https://en.wikipedia.org/wiki/The_Treachery_of_Images)... and [IEEE](https://en.wikipedia.org/wiki/NaN)_


{{< warning >}}
Philosophical rambling ahead
{{< /warning >}}

All of this might seem silly. Consider a linear-uniform distribution over [1, 100). Of course the range [10, 99] is 10x as likely as the range [1, 9] -- that's just the relative size of the intervals. But it's the *arithmetic size*, the linear size. If you were conditioned to think first of the *geometric size*, the logarithmic size, you would instinctively see these two intervals as having (nearly) the same size. You wouldn't expect the linear-uniform distribution, and this behavior would indeed be surprising. Perhaps it's hard to imagine this, because *the digits themselves* make it obvious: for Benford's Law, it is not obvious that 1234 is any more likely to occur than 5678. In contrast, you can't help but notice that 5 has only one digit, while 5678 has four digits. However, considering non-integer values allows us to make a more illustrative comparison between 5.678 and 5678. Try to imagine perceiving numbers through their *magnitude* instead of their *digits*. Perhaps growing up using a slide rule is the best way to internalize the logarithmic scale. I missed that boat by a few years.

My point is, the digits are only a representation of the number's value. Despite being a perfectly complete representation, the *digit string* is not an innate property of the *value*, but rather an artifact of the representation system. It's like looking for information in the pixel boundaries of a photograph: anything you find might be explained by the sampling grid, and disappear under a different sampling. Any properties of the digit string of a number might be explained by the choice of base, and disappear under a different base.

Of course, the number of digits is a crude approximation of the magnitude (regardless of the choice of base), whereas the first digit is more reasonably described as a "random" artifact of the representation. I'll concede that the number of digits is not *just* an artifact, and therefore Drofben's Law is more obvious -- *if* you think about numbers primarily in terms of their non-fractional digits.

{{< note title="Tangent">}}
I'm a former mathlete, I love recreational math problems/puzzles. These sometimes concern properties of the base-10 representation of numbers (Project Euler often uses the [digit sum](https://projecteuler.net/problem=20), etc., similarly, the Putnam exam usually includes a problem where the current year is used as an [upper limit](https://kskedlaya.org/putnam-archive/2019.pdf) or the like), and I've always thought of these as sort of "impure" problems which aren't as deeply interesting. On the other hand, there is some deep math involved in [Goodstein sequences](https://en.wikipedia.org/wiki/Goodstein%27s_theorem), based on fiddling around with hereditary base-N notation. Although, it comes specifically from *not* constraining N.
{{< /note >}}

### Base effects

When working with numbers, we have to pick some representation system; base 10 is fine, but it might be interesting to think about how these artifacts change when using different systems. While Benford's Law occurs regardless of the base, there is some interesting behavior at the extremes:

- base 2: Benford's Law doesn't mean as much in this case -- all first bits are 1! The generalization still applies to first-N-bits, but this is still an interesting comparison. In contrast, number-of-bits is now a closer approximation to the magnitude of the number.
- base infinity: each numeral is represented by a different symbol. Now, number-of-digits is always 1! Most of the questions become meaningless, because we've abandoned the concept of place-value digits, without abandoning the values. The concept of "first digit bias" isn't even tautological as in the base-2 case. The distribution of digit occurrences still contains some information, however.

Aside from these extremes, there is the zero-padded representation of base-N. Now, regardless of the the value of N, first-digit is uniform, and number-of-digits is constant. As lazy humans, we don't bother writing out all these leading zeros, but that's how computers work! I suppose a child raised by computers would think all of the zero-pad-counterparts of these laws are perfectly obvious and devoid of value.
