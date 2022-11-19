// Hitomezashi Stitch Patterns - Numberphile
// https://www.youtube.com/watch?v=JbfhzlMk2eY

size = 40;
thickness = 2;
ratio = 0.35;
range = [ 0 : 1 : size - 1];

sum = function(v, cnt, r = 0) cnt < 1 ? r % 2: sum(v, cnt - 1, r + v[cnt]);
add = function(s, v, i) i < len(v) ? s + v[i] : s;
rsum = function(v) [for (s = v[0], i = 0;i < len(v);i = i + 1, s = add(s, v, i)) s % 2];

// generate start vectors
xi = [ for (r = rands(0, 1, size)) floor(r + ratio) ];
yi = [ for (r = rands(0, 1, size)) floor(r + ratio) ];

// generate pattern
xx = [ for (x = range) [ for (y = range) (y + yi[x]) % 2 ] ];
yy = [ for (x = range) [ for (y = range) (y + xi[x]) % 2 ] ];

color("black")
difference() {
	s = 10 * size + thickness;
	square(s);
	translate([thickness, thickness]) square(s - 2 * thickness);
}

color("green", alpha = 0.8)
for (y = range, x = range)
	if (xx[y][x])
		translate(10 * [x, y])
			square([10 + thickness, thickness]);

color("blue", alpha = 0.3)
for (x = range, y = range)
	if (yy[x][y])
		translate(10 * [x, y])
			square([thickness, 10 + thickness]);
	
// Written in 2022 by Torsten Paul <Torsten.Paul@gmx.de>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.