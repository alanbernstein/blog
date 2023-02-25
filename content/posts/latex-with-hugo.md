+++
title = "Setting up LaTeX in Hugo"
author = "Alan Bernstein"
date = 2017-10-26
publishdate = 2017-10-26
tags = [ "latex", "hugo" ]
+++

I want to put equations in my posts. How do you do that in Hugo? It's easy as [$$\prod_{n=1}^{\infty} \left(\frac{2n}{2n-1} \cdot \frac{2n}{2n+1}\right)$$](https://en.wikipedia.org/wiki/Wallis_product).

<!--more-->

Well, a link around an equation in the teaser text screws up the style in the post list page. But that's a minor issue, and hopefully fixed by switching themes.
<!--TODO-->

I started [here](https://gohugo.io/content-management/formats/) and found a hint that using mmark source might be the easiest route. So I followed the link to [this](http://nosubstance.me/post/a-great-toolset-for-static-blogging/) post which, after some helpful explanation, linked to the actual [changeset](https://github.com/oblitum/hugo-theme-slim/commit/2726427d5899720447d90177824ab26996bb0750) used to add [KaTeX](https://khan.github.io/KaTeX/) support.

I'm still figuring out what to do about my theme, so I just modified one file in my test theme (layouts/_default/baseof.html) to try this out. I added four lines - the js and css and includes in `<head>`, and the js function call just before the end of `<body>`. Then I created this post in `mmark` format with a few math blocks, and everything just worked. Update 2017/11/02: updated from Katex v0.6.0 to v0.9.0-alpha1, for `\operatorname` support.

Inline math works: $$F_M(N, N_R) = {N-1 \choose N_R-1}{M-N+1 \choose N_R}$$, and so does display math:

$$F_M(N, N_R) = {N-1 \choose N_R-1}{M-N+1 \choose N_R}$$

Now I have the bare minimum necessary to start converting old mediawiki posts. I picked a smallish one with a decent amount of math in it: The [bell curve integral](../bell-curve).

Great! But I'd love for this to work in org-mode...

## Update 2020/01/24
Notepadium has built-in support that works great for .org files, for latex block mode, not so much for inline mode. 

The only confusion is that the notepadium example page says to "include the partial in your templates like so", which assumes some familiarity with Hugo. I haven't used templates at all, so it wasn't clear where to put this. After some experimentation, seems like it works to call the math.html partial from layouts/partials/header.html (supplements the existing theme's header).

Some links:
- config for math support described at https://themes.gohugo.io/hugo-notepadium/
- example markdown syntax at https://github.com/cntrump/hugo-notepadium/blob/master/exampleSite/content/post/math-typesetting.md (live at https://themes.gohugo.io//theme/hugo-notepadium/post/math-typesetting/)
- https://github.com/cntrump/hugo-notepadium/commit/2452327e2b9b28f208389424d1f27abe12ec1672
- https://github.com/cntrump/hugo-notepadium/issues/68


## Examples

https://katex.org/docs/supported.html

$$ \left( F \right) $$

$$ \lbrack F \rbrack $$

$$ \lbrace F \rbrace $$

$$ \underleftrightarrow{AB} $$

$$\underbrace{AB}$$

$$ \left(\LARGE{AB}\right) $$

$$ \begin{matrix}
   a & b \\\
   c & d
\end{matrix}$$

$$ \begin{array}{ccc}
a & b & c \\\
d & e & f \\\
g & h & i \end{array}$$

$$ \begin{bmatrix}
  1 & 0 \\\
  0 & 1
\end{bmatrix}$$

$$ f\relax{x}
= \int_{-\infty}^\infty
    f\hat\xi\,e^{2 \pi i \xi x}
    d\xi $$

\null\hfill \blacksquare


