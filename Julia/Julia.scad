// https://en.wikipedia.org/wiki/Julia_set

iter = 100;
size = [400, 300];

start = [-1.8, -1.2];
end = [1.8, 1.2];

threshold = 1000;
display_limit = 5;

selection = 0;  // [0:11]

/* [Hidden] */
presets = [
	[-0.84, -0.216],
	[-0.162, 1.04],
	[-0.01, -0.801],
	/* Wikipedia examples */
	[-0.4, 0.6],
	[0.285, 0],
	[0.285, 0.01],
	[0.45, 0.1428],
	[-0.70176, -0.3842],
	[-0.835, 0.2321],
	[-0.8, 0.156],
	[-0.7269, 0.1889],
	[0, -0.8]
];

assert(selection >= 0 && selection < len(presets));
c = presets[selection];

cadd = function(a, b) a + b;
cabs = function(a) sqrt(a.x * a.x + a.y * a.y);
cmul = function(a, b) [ a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x ];

julia = function(z, c, n = 0)
	cabs(z) <= threshold && n < iter
	? julia(cadd(cmul(z, z), c), c, n + 1)
	: n;

rms = (end.x - start.x) / size.x;
ims = (end.y - start.y) / size.y;

for (im = [start.y:ims:end.y], re = [start.x:rms:end.x])
	let(j = julia([re, im], c))
		if (j > display_limit)
			color(hsv(j / iter + 0.6, 1, j < iter ? 1 : 0))
				translate(2 * [re / rms, im / ims])
					cube([1.9, 1.9, j < iter ? 10 * ln(j) : 0.01], center = true);

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
