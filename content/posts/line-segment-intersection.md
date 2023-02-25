+++
title = "Line Segment Intersection"
author = "Alan Bernstein"
date = 2023-02-23
publishdate = 2023-02-23
draft = true
tags = [ "latex", "math", "derivation", "geometry" ]
+++

Reviving the line-segment intersection derivation by Simon Walton, posted originally [here](https://www.cs.swan.ac.uk/~cssimon/line_intersection.html), archived [here](https://web.archive.org/web/20200204013057/https://www.cs.swan.ac.uk/~cssimon/line_intersection.html).

Copied in full below, with some added whitespace and typo fixes.

<!--more-->

# Finding the intersection point of two line segments in $$\mathbf{R}^2.$$

Simon Walton, Dept of Computer Science, Swansea

Not long ago, I wanted a quick solution to the problem of finding the intersection point (if any) of two line segments in two-dimensional space. I found a solution somewhere on the web but was a little bothered by the lack of steps for the reader to derive it themselves. So, I figured someone out there would find my derivation and solution useful. Plus, I wanted to play with [MathJax](https://www.mathjax.org/) and this seemed like a decent starting point.

I'm going to assume the reader is familiar with matrices. 

## Deriving a solution
Line segment implies finite portion of a line between two points. We can define our two lines to begin with as being connected between points $$p_1, p_2$$ for the first line and $$p_3, p_4$$ for the second. The equations of these lines are defined simply as:

$$p_1 + t(p_2 - p_1)$$

$$p_3 + t(p_4 - p_3)$$ 

where $$0 \leq t \leq 1$$ in each case defines a point along the line. At $$t=0$$ for our first line segment for example, we simply get $$p_1$$ back as the zero $$t$$ removes the latter half of the equation. 

Now we need to find the point (if it indeed exists) where the two lines overlap. Mathematically, this can be expressed simply as: 

$$p_1 + t_a(p_2 - p_1) = p_3 + t_b(p_4 - p_3)$$ 

where $$t_a$$ is the offset of the intersection on the first line, and $$t_b$$ is the offset of the same intersection on the second line. We now need to break this into its $$xy$$ components to work on it further: 

$$x_1 + t_a(x_2 - x_1) = x_3 + t_b(x_4 - x_3)$$ 

$$y_1 + t_a(y_2 - y_1) = y_3 + t_b(y_4 - y_3)$$

We can rearrange these equations into a system of two linear equations with two unknowns:

$$(x_1 - x_3) = t_b(x_4 - x_3) - t_a(x_2 - x_1)$$

$$(y_1 - y_3) = t_b(y_4 - y_3) - t_a(y_2 - y_1)$$

A nice way to solve such a system algebraically is using matrices. We can define our system like so: 

$$\left[ \begin{array}{cc} x_4 - x_3 & -(x_2 - x_1) \\\ y_4 - y_3 & -(y_2 - y_1)\end{array} \right] 
\left[ \begin{array}{cc} t_b \\\ t_a \end{array} \right] = 
\left[ \begin{array}{cc} x_1 - x_3 \\\ y_1 - y_3 \end{array} \right] $$ 

If you multiply the matrix and vector on the left hand side of the equation, you'll see that you just get the left hand side of the linear system above. Now, in order to solve for our unknowns $$t_a$$ and $$t_b$$, we need to rearrange again so that these components appear on their own, which means moving its neighbour to the other side of the equation. In order to move the 2x2 matrix to the other side, we need to invert it. If we have a 2x2 matrix: 

$$\mathbf{A} = \left[ \begin{array}{cc} a & b \\\ c & d\end{array} \right]$$ 

then the inverse, $$\mathbf{A}^{-1}$$, is defined as: 

$$\mathbf{A}^{-1} = {1 \over | \mathbf{A} |} \left[ \begin{array}{cc}d & -b \\\ -c & a\end{array} \right] $$ 

where $$|A|$$ is the *determinant* of the matrix, defined simply as $$ad - bc$$. We now have the tools required to solve our equation. By inverting our 2x2 matrix and moving it across, we get: 

<!--
$$ \left[ \begin{array}{cc} t_b \\ t_a \end{array} \right] = \underbrace{\frac{1}{(x_4 - x_3)(y_1 - y_2) - (x_1 - x_2)(y_4 - y_3)}}_{a} \underbrace{ \left[ \begin{array}{cc} y_1 - y_2 & x_1 - x_2 \\ y_3 - y_4 & x_4 - x_3\end{array} \right] }_{b} \underbrace{ \left[ \begin{array}{cc} x_1 - x_3 \\ y_1 - y_3 \end{array} \right] }_{c} $$ 
-->

<!-- only works if it's split up? -->

$$ \left[ \begin{array}{cc} t_b \\\ t_a \end{array} \right]$$ 

$$ = \underbrace{\frac{1}{(x_4 - x_3)(y_1 - y_2) - (x_1 - x_2)(y_4 - y_3)}}_{a} \cdot$$ 

$$\underbrace{ \left[ \begin{array}{cc} y_1 - y_2 & x_1 - x_2 \\\ y_3 - y_4 & x_4 - x_3 \end{array} \right] }_{b} \cdot $$

$$\underbrace{ \left[ \begin{array}{cc} x_1 - x_3 \\\ y_1 - y_3 \end{array} \right] }_{c} $$ 

The matrix in the right hand side ($$b$$) can be divided now by the first expression in the right hand side ($$a$$) to obtain a rather large matrix which we will omit here for clarity (and sanity). Once this final matrix is multiplied by vector $$c$$, we obtain our final solution for both the $$t_a$$ and the $$t_b$$ scalars: 

$$t_a = \frac{(y_3 - y_4)(x_1 - x_3) + (x_4 - x_3)(y_1 - y_3)}{(x_4 - x_3)(y_1 - y_2) - (x_1 - x_2)(y_4 - y_3)}$$

$$t_b = \frac{(y_1 - y_2)(x_1 - x_3) + (x_2 - x_1)(y_1 - y_3)}{(x_4 - x_3)(y_1 - y_2) - (x_1 - x_2)(y_4 - y_3)}$$ 

So there we have it. Wasn't too difficult was it? If you're like me, you'll want to see if you can reproduce the equations yourself. You may very well end up with a different result, but remember that doesn't necessarily mean it's wrong; algebraically it could be equal to the solution here.

## Interpreting the results
So, how do we interpret the results of plugging in the $x$ and $y$ values of our lines into the above equations?

- Segment intersection: If $$0 \leq t_a \leq 1$$ and $$0 \leq t_b \leq 1$$ then the line segments intersect. The point of intersection can be found by simply plugging either of the resulting $$t$$-values into its associated line equation.
- General intersection: If the values of either $$t$$ fall outside of $$[0,1]$$ then they represent the intersection point of the infinite representation of the lines (that is, not between their defined points).
- Colinear lines: You may have noticed that there is a division involved, the denominator of which may of course be zero. If this is the case, then this implies that there is no solution for the system, which in our line intersection analogue implies that the lines are in fact colinear or equal (that is, they either intersect at no point whatsoever or intersect at infinitely many points). If you are implementing these equations in code then you'll want to check for zero before dividing and return some sort of status indicating colinearity.
