---
title: "Ruler and compass construction of a heart"
author: "Alan Bernstein"
date: 2023-02-14
publishdate: 2023-02-14
tags: ["math", "geometry", "graphics", "python"]
plotly: true
---

My take on the parametric heart shape concept.

<!-- more -->

<div class="menubar" id="menubar" style="margin: 0 auto; width: 90% ">
<span class="slider-container">
<span class="slider-name">A</span>:
<span id="a-label" class="slider-label" style="display:inline-block; width:2em">90</span>
<input type="range" min="60" max="120" step="1" value="90" class="slider" id="a-slider" onchange="updateSliders('a');" autocomplete='off'>
</span>

<span class="slider-container">
<span class="slider-name">B</span>:
<span id="b-label" class="slider-label" style="display:inline-block; width:2em">90</span>
<input type="range" min="60" max="120" step="1" value="90" class="slider" id="b-slider" onchange="updateSliders('b');" autocomplete='off'>
</span>
</div>

<canvas id="c1" width=640 height=480></canvas>

<script id="canvas-animator" type="text/javascript">
      // TODO: move this to js folder
     let canvas = document.getElementById("c1")
     let ctx = canvas.getContext("2d")

     menubar = document.getElementById("menubar");
     slider_a = document.getElementById("a-slider");
     slider_b = document.getElementById("b-slider");
     label_a = document.getElementById("a-label");
     label_b = document.getElementById("b-label");

     function updateSliders(idx) {
	   label_a.innerHTML = slider_a.value;
       label_b.innerHTML = slider_b.value;
     }

     function draw()
     {
         canvas.width = canvas.width;
         //canvas.height = window.innerHeight - 100;
	       menubar.style.width = canvas.width;

         tx = canvas.width/2;
         ty = canvas.height-100;
         s = canvas.width/2;
         
         console.log(slider_a.value, slider_b.value);

         path = heart(parseInt(slider_a.value), parseInt(slider_b.value));

         ctx.beginPath();
         ctx.moveTo(tx+s*path[0][0], ty-s*path[0][1]);
	       for(n=1; n<path.length; n++) {
             ctx.lineTo(tx+s*path[n][0], ty-s*path[n][1]);
	       }
               ctx.fillStyle = '#ff0000';

         ctx.fill();
         ctx.closePath();

         requestAnimationFrame(draw)
     }

     function heart(a, b) {
         a2 = a*Math.PI/180/2;
         b2 = b*Math.PI/180/2;

         r = 1/((Math.cos(b2)+Math.cos(a2))/Math.tan(a2) + Math.sin(b2)+Math.sin(a2))
         w = r * (Math.cos(b2) + Math.cos(a2))
         h = w / Math.tan(a2)
         cx = w - r*Math.cos(a2)
         cy = h + r*Math.sin(a2)

	       path = [[0, 0]];

	       N = 32;
	       t = -a2;
	       dt = (Math.PI-b2+a2)/N;
	       for(n=0; n<N; n++) {
	           t += dt;
	           path.push([cx + r*Math.cos(t), cy + r*Math.sin(t)])
	       }

	       t = b2;
	       dt = (Math.PI+a2-b2)/N;
	       for(n=0; n<N; n++) {
	           t += dt;
	           path.push([-cx + r*Math.cos(t), cy + r*Math.sin(t)])
	       }

	       path.push([0, 0]);
	       return path;
     }

     draw();


</script>



There are many ways to use math to define a [heart curve](https://mathworld.wolfram.com/HeartCurve.html). The second one on that page, a sextic algebraic equation, $$(x^2+y^2-1)^3 + x^2y^3 = 0$$, strikes me as one of the most elegant, but it's not very... adjustable.

Rather than using a single polar/parametric/algebraic equation to define a curve, I imagined a different approach: a heart shape composed only of two circular arcs and two straight line segments. I designed something like this years ago. It sort of worked, but the parameterization was awkward, in terms of both interpretability, and anchoring points for comparisons.

(The single parameter: angular length of one of the circular lobes, constrained to [180°, 225°]. The circles were centered symmetrically on the x-axis, and everything else was defined with respect to those circle centers)

I wanted to revisit this concept. I like it because it is one obvious way to generalize the "simplest" heart shape that can be constructed from geometric primitives, a square and two semicircles.

## New idea: parameterize the two acute vertex angles

I considered how to represent, and construct, a two-circle-two-line heart shape for a while. What are the input parameters? Where is the shape relative to the origin? What are the base points, which I can use to define other geometric objects?

I thought about this in UX terms: what are the most useful, descriptive parameters to describe such a shape? In retrospect, the answer seems obvious, at least for the constraints that I've imposed. The answer: specify the acute, interior angle at the bottom vertex ($$\alpha$$), and the acute, exterior angle at the top vertex ($$\beta$$). Since the two vertices are the salient points on the curve, for simplicity, just put the bottom one at (0, 0), and the top one at (0, 1).

![]({{< imgPrefix >}}/heart-curve/heart-notebook-23.jpg)


Next, I had to take those input parameters, and transform them into some intermediate variables that I could use to draw the arcs and line segments. For geometry problems like this, I tend to define geometric objects in algebraic terms (but not geometric algebraic! though that is on my todo list). Then, I'll find analytic solutions for key parameters, like circle centers or line endpoints. So this is what my first few attempts looked like.

Long story short, those ideas led to overly-complicated formulas. I could have brute forced my way through them, but that felt wrong. I considered using a [DDA algorithm](https://en.wikipedia.org/wiki/Digital_differential_analyzer_(graphics_algorithm)), but that seemed worse. Instead, I tried a couple of [geometric construction](https://en.wikipedia.org/wiki/Straightedge_and_compass_construction) approaches.

![]({{< imgPrefix >}}/heart-curve/heart-notebook-1.jpg)

These also seemed overly complicated, with too many variables and sub-figures. So, I took a nap. I woke up with one of my favorite feelings in life, the realization that a simple solution had appeared in my mind while I slept.

## Construction

 Pick angles $$\red\alpha, \color{blue}\beta$$ for the bottom vertex and top vertex.

Compute $$\red a = 90\degree - \red\alpha/2$$, where <span style="color:red">a</span> is the angular direction from the bottom vertex to the lower end of the right circular lobe.

Similarly, $${\color{blue}b} = 90\degree - {\color{blue}\beta}/2$$ is the angular direction from the top vertex to the upper end of the right circular lobe.

![]({{< imgPrefix >}}/heart-curve/heart-step-1.png)

Extend the lines <span style="color:red">L1</span>, <span style="color:blue">L2</span> defined by those directions.

Find their intersection <span style="color:magenta">P1</span>.

![]({{< imgPrefix >}}/heart-curve/heart-stage-1.png)

Find the [angle bisector](https://en.wikipedia.org/wiki/Bisection#Angle_bisector) <span style="color:magenta">L3</span> between <span style="color:red">L1</span> and <span style="color:blue">L2</span>.

![]({{< imgPrefix >}}/heart-curve/heart-stage-2.png)

The right circle is tangent to both <span style="color:red">L1</span> and <span style="color:blue">L2</span>, so its center must lie somewhere on <span style="color:magenta">L3</span>.

The right circle must be tangent to <span style="color:blue">L2</span> at the top vertex , so its center must lie on the line extending perpendicularly from $$\color{blue}(0, 1)$$, <span style="color:green">L4</span>.

The center must then lie at the intersection of <span style="color:magenta">L3</span> and <span style="color:green">L4</span>, <span style="color:black">P2</span>.

![]({{< imgPrefix >}}/heart-curve/heart-stage-3.png)

The radius is the distance between <span style="color:black">P2</span> and $$\color{blue}(0, 1)$$, so now we know where the circle is, as well as the angle around the circle at which the arc stops at the top.

![]({{< imgPrefix >}}/heart-curve/heart-stage-4.png)

We also need to know the angle around the circle at which the arc stops at the bottom. This corresponds to the line <span style="color:cyan">L5</span> along the radius that intersects with <span style="color:red">L1</span> at the tangent point, <span style="color:cyan">P3</span>

![]({{< imgPrefix >}}/heart-curve/heart-stage-5.png)

The other side of the heart is just a mirror image.

![]({{< imgPrefix >}}/heart-curve/heart-stage-6.png)

Then we just need to construct the path that follows these objects:

![]({{< imgPrefix >}}/heart-curve/heart-stage-7.png)

And then remove all the math:

![]({{< imgPrefix >}}/heart-curve/heart-final.png)

## Implementation

I had a python library containing an assortment of geometry utility functions. I don't recall using it for ruler-and-compass-style constructions previously, but it turned out to work pretty well for this. It's not what I would normally seek in an analytical solution, with the final variables written in closed form relative to the input parameters. But every intermediate step is closed-form, so it could be simplified to that, if I were a mathsochist.

Concisely:

```python
def circle_construction_heart(alpha_degrees=90, beta_degrees=90):
    a = np.pi/2 - (alpha_degrees * np.pi/180)/2  # angle from x-axis to bottom direction
    b = np.pi/2 - (beta_degrees * np.pi/180)/2   # angle from x-axis to top direction

    # intermediate objects
    L1 = Line(p1=[0, 0], angle=a)          # line through bottom vertex
    L2 = Line(p1=[0, 1], angle=b)          # line through top vertex
    P1 = L1.intersect(L2)                  # auxiliary point
    c = (a+b)/2                            # direction angle of angle bisector
    L3 = Line(p1=P1, angle=c)              # angle bisector
    L4 = Line(p1=[0, 1], angle=b-np.pi/2)  # upper radius line
    P2 = L3.intersect(L4)                  # circle center
    r = np.sqrt(P2[0]**2 + (P2[1]-1)**2)   # circle radius
    L5 = Line(p1=P2, angle=a-np.pi/2)      # lower radius line
    P3 = L5.intersect(P1)                  # bottom circle tangent point

    # arc paths
    phi0 = a-np.pi/2
    phi1 = b+np.pi/2
    arc_r = (P2[0]+1j*P2[1]) + r*np.exp(1j*np.linspace(phi0, phi1, 32))
    phi2 = np.pi/2-b
    phi3 = 3*np.pi/2-a
    arc_l = (-P2[0]+1j*P2[1]) + r*np.exp(1j*np.linspace(phi2, phi3, 32))

    path = np.hstack((
        0,
        arc_r,
        arc_l[1:],  # deduplicate the top vertex point
        0,
    ))
    return path
```

A few notes:
- [`Line`](https://github.com/alanbernstein/geometry/blob/master/line.py) is doing most of the work here, but the `intersect` method is quite simple.
- I like to use complex numbers to draw shapes. It is a concise way to define 2D points and curves, including circular arcs, which are just complex exponentials with offset and scale. `Line` just uses numpy arrays, so translating those to complex numbers is a tiny bit awkward.
- This excludes the alpha=beta case, but that's simpler.
- I love descriptive variable names in code. Just not in this case.



## Some parameter variations

What's the point of all this? No point. I just like creating toy math problems to solve.

It does allow me to make fine adjustments to the shape, and overlay them for comparison.

Same angle on top and bottom vertices:
![]({{< imgPrefix >}}/heart-curve/heart-demo1.png)

Supplementary angles:
![]({{< imgPrefix >}}/heart-curve/heart-demo2.png)

Square bottom, varied angles on top:
![]({{< imgPrefix >}}/heart-curve/heart-demo3.png)

Having perfect knowledge of these "control points" also enables other things, like defining a constant-distance offset curve. This was the original motivation for revisiting this idea, for cutting out heart outlines on a laser cutter. This solution may have been overkill, oops.


## Addendum
Shortly after writing the above, I figured out the analytical solution. This is cool, because it means I can implement it in any other language with just trig functions. I'm still glad I figured out the geometric construction, because it's quite elegant, the diagrams are pretty, the process is more accessible, and it was a great opportunity to try out using [color](https://betterexplained.com/articles/colorized-math-equations/) to enhance a math explanation.

Anyway, it turns out I can just do this:

```python
def analytical_heart(alpha_degrees=90, beta_degrees=84):
    a2 = alpha_degrees * np.pi/180 / 2
    b2 = beta_degrees * np.pi/180 / 2

    r = 1/((np.cos(b2)+np.cos(a2))/np.tan(a2) + np.sin(b2)+np.sin(a2))  # radius
    w = r * (np.cos(b2) + np.cos(a2))
    h = w / np.tan(a2)
    cr = w-r*np.cos(a2) + 1j*(h + r*np.sin(a2))   # center of right circle
    cl = -np.conj(cr)                             # center of left circle

    ar = cr + r*np.exp(1j*np.linspace(-a2, np.pi-b2, 32))
    al = cl + r*np.exp(1j*np.linspace(b2, np.pi+a2, 32))

    path = np.hstack((
        0,
        ar,
        al[1:],
        0,
    ))
    return path
```

This even seems to work for the $$\alpha = \beta$$ case without branching.

I got this by figuring out a simple system of three equations to solve:
- $$1 = h + r (\sin(\alpha/2) + \sin(\beta/2))$$
- $$w = r (\cos(\alpha/2) + \cos(\beta/2))$$
- $$ w = \tan(\alpha/2)$$

Need to include the diagram, but in short:
- diagram consists of three axis-aligned right triangles with all known angles (plus two more non-axis-aligned)
- r is the circle radius
- (w, h) is the coordinates of the bottom endpoint of the right circle
- this is just a linear system with trig functions in the constants, easy to solve


<!-- TODO: include the diagram -->
