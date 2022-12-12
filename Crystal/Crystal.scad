// Random crystal clusters, not trying to follow nature
sides = 5;
colorscheme = 0;

rseed = floor(rands(0, 100000, 1)[0]);
//seed = 83102;
eseed = is_undef(seed) ? rseed : seed;
echo(seed = eseed);

module crystal(r, h) {
	rnd = rands(-0.5, 0.5, 2 * sides + 4);
	c = function(i) r/2 * rnd[i]; // randomize the pointy ends to be off center
	h1 = function(i) h/15 + h/20 * rnd[i]; // randomize height of bottom cuts a tiny bit
	h2 = function(i) h - h/5 - h/7 * rnd[i]; // randomize height of top cuts

	rndx = rands(-0.5, 0.5, sides);
	rndy = rands(-0.5, 0.5, sides);
	px = function(i, r, a) (r + r/3 * rndx[i]) * sin(a); // randomize x coordinate of side faces
	py = function(i, r, a) (r + r/3 * rndy[i]) * cos(a); // randomize y coordinate of side faces
	p = function(i, h) let(a = i * 360 / sides) [px(i, r, a), py(i, r, a) , h];

	points = [
		[c(0), c(1), 0],
		[c(2), c(3), h],
		for (i = SIDES) p(i, h1(i + 4)),
		for (i = SIDES) p(i, h2(i + sides + 4)),
	];

	next = function(i) (i + 1) % sides;
	faces = [
		for (i = SIDES) [0, next(i) + 2, i + 2],
		for (i = SIDES) [1, i + sides + 2, next(i) + sides + 2],
		for (i = SIDES) [i + 2, next(i) + 2, next(i) + sides + 2, i + sides + 2]
	];

	polyhedron(points, faces);
}

module cluster(cnt, t, r, d, h) {
	rndv = rands(0, 1, 4 * cnt);

	rnd = function(n, i, s1, s2) s1 * rndv[n * cnt + i];

	for (a = [0:cnt - 1])
		rotate(360 / cnt * a)
			translate([t.x + rnd(0, a, t.y), 0, 0])
				rotate([0, r.x + rnd(1, a, r.y), 0])
					crystal(d.x + rnd(2, a, d.y) , h.x + rnd(3, a, h.y));
}

module clusters() {
	rnd = rands(0, 1, 1, eseed); // just seed
	difference() {
		union() {
			alpha = 0.90;
			c = COLORS[colorscheme];
			color(c[0]) cylinder(r = base_r, h = 2 * base_h, center = true);
			color(c[1], alpha = alpha) cluster(1, [0, 0], [1, 10], [12, 0], [100, 0]);
			color(c[2], alpha = alpha) cluster(8, [6, 10], [4, 20], [6, 2], [50, 20]);
			color(c[3], alpha = alpha) cluster(13, [12, 5], [15, 30], [5, 1], [30, 15]);
			color(c[4], alpha = alpha) cluster(21, [12, 5], [40, 20], [3, 1], [20, 10]);
		}
		translate([0, 0, -base_h]) cylinder(r = base_r + 1, h = 2 * base_h, center = true);
		color("black")
			rotate([180, 0, 0])
				linear_extrude(0.6, center = true, convexity = 3, $fn = 16)
					text(str(eseed), base_r / 5, halign = "center", valign = "center");
	}
}

clusters();

base_r = 50;
base_h = 5;

SIDES = [0 : 1 : sides - 1];
COLORS = [
	[ "White", "LightCyan", "PowderBlue", "LightBlue", "SkyBlue" ],
	[ "White", "Cornsilk", "LightYellow", "LemonChiffon", "LightGoldenrodYellow" ],
	[ "White", "Lavender", "Thistle", "Plum", "Violet" ],
];

$fa = 3; $fs = 0.2;

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
