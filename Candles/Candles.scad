$fa = 2; $fs = 0.2;

n = 20;
r = 100;

// calculate single bezier point in 2D
bezierp = function(from, to, c1, c2, a)
    from * pow(1 - a, 3)
    + c1 * 3 * pow(1 - a, 2) * a
    + c2 * 3 * pow(1 - a, 1) * pow(a, 2)
    + to * pow(a, 3);

// calculate points of cubic bezier
bezier = function(p) [
    for (i = [0:n])
       let(a =  i * 1 / n)
           bezierp(p[0], p[1], p[2], p[3], a)
];

poly = function(p) p;

points = [
	[ poly, [ [0, 0], [0, 20] ] ],
    [ bezier, [ [0, 25], [30, 28], [20, 25], [24, 24] ] ],
    [ bezier, [ [30, 28], [30, 20], [37, 32], [35, 20] ] ],
    [ bezier, [ [30, 20], [5, 0], [0, 15], [3, 15] ] ],
];

module pos(r, z = 0) {
	for (a = [0:3])
		rotate(360 / 4 * a)
			translate([0, r, z])
				children();
}

module holder() {
	h = 10;
	color("Burlywood")
	linear_extrude(h) difference() {
		circle(r + 10);
		circle(r - 10);
	}
	color("gold")
		pos(r, h)
			rotate_extrude()
				polygon([each for (p = points) p[0](p[1])]);
}

module candle(h) {
	n = 20;
	rnd = rands(-1, 1, 4 * n);
	color("Crimson")
	difference() {
		cylinder(r = 10, h = h);
		translate([0, 0, h]) scale([1, 1, 0.8]) sphere(r = 8);
	}
	color("Black")
	translate([0, 0, h-4]) cylinder(r = 0.5, h = 6);
	for (a = [0:n-1]) {
		s = sin(90/n * a);
		c = cos(90/n * a);
		x = 1 * rnd[a] * c;
		y = 1 * rnd[n+a] * c;
		color([1, abs(rnd[2 * n + a])/2 + 0.5 / n * a, 0], alpha = 0.6 - a * 0.5 / n)
		translate([x, y, h + 2 + (10 + (a/2 * s * rnd[3 * n + a])) * s]) {
			sphere(6 - 4 * s, $fn = 27);
		}
	}
}

module candles() {
	pos(r, 30)
		candle(100);
}

holder();
%candles();

/*

*union() {
	scale([1,1,0.01]) polygon([each for (p = points) p[0](p[1])]);
	debug_bezier(points[3][1]);
}

module debug_bezierl(p, i) {
    color("black") hull() {
        translate(p[i]) cube(0.1, center = true);
        translate(p[i + 2]) cube(0.1, center = true);
    }
}

module debug_bezier(p) {
    color("blue") translate(p[0]) circle(0.5);
    color("red") translate(p[1]) circle(0.5);
    color("yellow") {
        translate(p[2]) circle(0.3);
        translate(p[3]) circle(0.3);
    }
    debug_bezierl(p, 0);
    debug_bezierl(p, 1);
}

*/

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
