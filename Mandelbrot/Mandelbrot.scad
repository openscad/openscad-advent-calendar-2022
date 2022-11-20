// https://en.wikipedia.org/wiki/Mandelbrot_set

iter = 75;
size = [300, 200];

start = [-2.4, -1.2];
end = [0.8, 1.2];

cadd = function(a, b) a + b;
cabs = function(a) sqrt(a.x * a.x + a.y * a.y);
cmul = function(a, b) [ a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x ];

mandelbrot = function(c, z = [0, 0], n = 0)
	cabs(z) <= 2 && n < iter
	? mandelbrot(c, cadd(cmul(z, z), c), n + 1)
	: n;

rms = (end.x - start.x) / size.x;
ims = (end.y - start.y) / size.y;

for (im = [start.y:ims:end.y], re = [start.x:rms:end.x])
	let(m = mandelbrot([re, im]))
		color(hsv(m / iter, 1, m < iter ? 1 : 0))
			translate(2 * [re / rms, im / ims])
				cube([2, 2, m < iter ? 6 * log(m) : 0.01]);

// HSV to RGB conversion
function doHsvMatrix(h,s,v,p,q,t,a=1)=[h<1?v:h<2?q:h<3?p:h<4?p:h<5?t:v,h<1?t:h<2?v:h<3?v:h<4?q:h<5?p:p,h<1?p:h<2?p:h<3?t:h<4?v:h<5?v:q,a];
function hsv(h,s=1,v=1,a=1)=doHsvMatrix((h%1)*6,s<0?0:s>1?1:s,v<0?0:v>1?1:v,v*(1-s),v*(1-s*((h%1)*6-floor((h%1)*6))),v*(1-s*(1-((h%1)*6-floor((h%1)*6)))),a);

// Written in 2022 by Torsten Paul <Torsten.Paul@gmx.de>
// HSV color conversion functions by Yona Appletree (Hypher)
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
