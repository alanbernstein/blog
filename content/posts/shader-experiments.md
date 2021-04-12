+++
title = "A webgl shader experiment"
author = "Alan Bernstein"
date = 2018-01-11
publishdate = 2018-01-27
tags = [ "math", "web", "javascript", "graphics", "webgl", "latex"]
+++

How to create real fast demo animations with webgl. [EPILEPSY WARNING]

<!--more-->

Once in a while, I'll see this [gif posted to reddit](https://www.reddit.com/r/gifs/comments/7p4eo8/blink_fast/), and I am briefly mesmerized as I try to understand what I'm looking at. It seems like some relatively simple sum of sinusoids, but the combination of parameters and coloring creates a really neat optical illusion effect. Last time it came up, I tracked down the source ([youtube](https://www.youtube.com/watch?v=0SWRcH9p4Uo), [chinese blog post](https://txyyss.wordpress.com/2016/06/14/plane-wave/)) and [recreated](http://alanbernstein.net/wave-shader.html) it for fun. Here's a simplified embedded version:

<canvas id="shader-canvas" width=640 height=480>
</canvas>

<span style="color:lime">order:</span> <span id="label-order" style="color:lime"></span>
<input type="range" min="3.0" max="10.0" value="5.0" id="slider-order">

<script id="vertex-shader" type="glsl">
attribute vec2 coord;
void main() {
    gl_Position = vec4(coord, 0, 1);
}
</script>

<script id="fragment-shader" type="glsl">
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define W 640.0  // canvas dimensions TODO get as uniform
#define H 480.0

uniform float millisecs, order, width, scale, speed;

float fmod(float x, float y) {
    return (x - y * floor(x / y));
}

float wrap(float x) {
    return abs(fmod(x+1.0,2.0)-1.0);
}

void main() {
    float phase = speed * millisecs/1000.0;
    float t;
    float A = width/W;
    float x = A*(gl_FragCoord.x - W/2.0);
    float y = A*(gl_FragCoord.y - H/2.0);
    float z = 0.0;
    for(int n=0; n<10; n++) {
        t = float(n) * 3.14159 / order;
        z += cos(x*cos(t) + y*sin(t) + phase);
        if(n == int(order)) {
            break;
        }
    }
    z = wrap(scale * z / order);
    gl_FragColor = vec4(z, z, z, 1);
}
</script>


<script type="text/javascript" src="/js/wave-shader-embedded.js"></script>

With that blog post available, and a loose grasp of Mathematica syntax, it was easy enough to understand what's going on. It's a bit easier for me to grok in traditional notation:

![Equation]({{< imgPrefix >}}/shader-experiments/planewave-math-white.png)
<!-- 

can't figure out how to use colors in katex+hugo

$$ \htmlStyle{color: lime;}{x} $$
$$c = \abs{\mod\(\frac{Sz}{N}+1, 2\)-1}$$
$$c = \mod\left(\frac{\htmlStyle{color:purple;}{S}z}{N}+1,2\right)$$

-->


In short, the thing is just a heightfield (z) created by summing <span style="color:lime">N</span> simple waves of equal magnitude, and distributed with rotational symmetry about the origin (the cos and sin terms are a rotation). <span style="color:blue">R</span> is a spatial zoom factor, and <span style="color:red">V</span> is animation speed. It's the <span style="color:purple">S</span> term in the "wrapping" step of computing the color \(c\) that really makes it interesting.

The most direct way to map heightfield values to color is to map min->0, max->255 (which is more or less what happens when S=1). You can think of this coloring method as using a colormap that's a single gradient from black to white. If, instead, the color map "wraps around" a few times, so it goes black-white-black-white-black-white-..., then we get a much more interesting result, where the weird banding leads to those intricate patterns.

An earlier iteration, in python/numpy:

```python
import numpy as np

def directional_wave(x, y, t=0, p=0):
    return np.cos(x * np.cos(t) - y * np.sin(t) + p)


def wrap(z):
    return np.abs(np.mod(z + 1, 2) - 1)


# generate one frame
xvec = np.linspace(-25*np.pi, 25*np.pi, 1000)  # approximate range used in the blog post
x, y = np.meshgrid(xvec, xvec)
z = sum([directional_wave(x, y, i*np.pi/N) for i in range(N)])
z = wrap(z)
```

I could render individual frames like this, but what I really wanted was a real-time animation with interactive control of some parameters. I don't know of a great way to do that in Python, plus it's almost certainly not fast enough to run at, say, 10+ frames per second. I figured I'd try it out in Javascript (easy to render animations) and Go (fast), and in Go I got as far as implementing the math, including a well-behaved mod function:

```go
func mod(x, y float64) float64 {
	return math.Mod(math.Mod(x, y)+y, y)
}

func wrap(x float64) float64 {
	return math.Abs(mod(x+1, 2) - 1)
}

func getFrame(frame [][]uint8, p float64) {
	c, s := make([]float64, N), make([]float64, N)
	for n := 0; n < N; n++ {
		t := float64(n) * 3.1415 / N
		c[n], s[n] = math.Cos(t), math.Sin(t)
	}
	for px := 0; px < FW; px++ {
		x := W * (float64(px)/FW - 0.5)
		for py := 0; py < FH; py++ {
			y := H * (float64(py)/FH - 0.5)
			z := float64(0)
			for n := 0; n < N; n++ {
				z += math.Cos(x*c[n] - y*s[n] + p)
			}
			frame[py][px] = uint8(256 * wrap(z))
		}
	}
}
```

But then I decided that [graphics support in Go](https://github.com/go-gl) would be a pain. In Javascript, I redid it all again using `fillRect` for each pixel on a canvas, and found it to be too slow, as expected. Somewhere in the course of researching Javascript animation and performance profiling (it might have been [this article](https://modernweb.com/frame-by-frame-animation-with-html-and-javascript/)), I hit upon the idea of using shaders. I completely ignored the idea at first, assuming it would be too complicated, or just wouldn't work. When I found myself considering a trig lookup table in Javascript, I decided shaders were probably a better approach.

So I found some references, and a few minimal shader examples, and tinkered with them until I got something that looked pretty. The code that does the work looks like this:

```c
float fmod(float x, float y) {
    return (x - y * floor(x / y));
}

float wrap(float x) {
    return abs(fmod(x+1.0,2.0)-1.0);
}

void main() {
    float phase = speed * millisecs/1000.0;
    float t;
    float A = width/W;
    float x = A*(gl_FragCoord.x - W/2.0);
    float y = A*(gl_FragCoord.y - H/2.0);
    float z = 0.0;
    for(int n=0; n<10; n++) {
        t = float(n) * 3.14159 / order;
        z += cos(x*cos(t) + y*sin(t) + phase);
        if(n == int(order)) {
            break;
        }
    }
    z = wrap(scale * z / order);
    gl_FragColor = vec4(z, z, z, 1);
}
```

Here's the [rest of it](http://alanbernstein.net/wave-shader.html) (I wish I knew how to use CSS properly)

I had some problems along the way, not helped by a complete lack of shader error messages. At some point I realized that `<script type="glsl">` produces error messages, while `<script type="x-shader/fragment-shader">` doesn't - though I'm still unsure of any other difference between these.

Other lessons learned:

- Interactivity parameters can be implemented with "uniform" variables passed in from Javascript.
- `0` isn't a float, `0.0` is. Shader language is not C.
- Standard C functions you might expect might not be available (`mod`).
- Unbounded loops aren't allowed, but breaking out of a long for-loop is fine.

I don't know what I'm doing with WebGL - I just know enough to cobble together some stuff that more or less works. Now that I have some functioning boilerplate, I'll probably ignore it as much as I can, and just create more pretty animations.


Some helpful references:

- https://blog.mayflower.de/4584-Playing-around-with-pixel-shaders-in-WebGL.html
- https://jameshfisher.com/2017/10/05/webgl-fragment-shader-animation.html
- https://webglfundamentals.org/webgl/lessons/webgl-animation.html
- https://stackoverflow.com/questions/28290044/webgl-how-to-get-colour-in-fragment-shader-to-change-over-time
- http://glslsandbox.com/e#44636.0
- http://glslsandbox.com/e#44667.1
