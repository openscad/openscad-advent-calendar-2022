// Based on example 006 from OpenSCAD "Old" example library
// Jesse Campbell, Dec. 11, 2022

// Number of dice
dice = 2;

module rounded_cube(size,r,center=false)
{
  s = is_list(size) ? size : [size,size,size];
  translate(center ? -s/2 : [0,0,0])
    hull() {
      translate([    r,    r,    r]) sphere(r=r);
      translate([    r,    r,s.z-r]) sphere(r=r);
      translate([    r,s.y-r,    r]) sphere(r=r);
      translate([    r,s.y-r,s.z-r]) sphere(r=r);
      translate([s.x-r,    r,    r]) sphere(r=r);
      translate([s.x-r,    r,s.z-r]) sphere(r=r);
      translate([s.x-r,s.y-r,    r]) sphere(r=r);
      translate([s.x-r,s.y-r,s.z-r]) sphere(r=r);
    }
}

module example006(col, dots = "white")
{
  difference() {
	color(col)
    rounded_cube(100, 10, center=true);
	color(dots)
    union() {
      for (i = [
        [ 0, 0, [ [0, 0] ] ],
        [ 90, 0, [ [-20, -20], [+20, +20] ] ],
        [ 180, 0, [ [-20, -25], [-20, 0], [-20, +25], [+20, -25], [+20, 0], [+20, +25] ] ],
        [ 270, 0, [ [0, 0], [-25, -25], [+25, -25], [-25, +25], [+25, +25] ] ],
        [ 0, 90, [ [-25, -25], [0, 0], [+25, +25] ] ],
        [ 0, -90, [ [-25, -25], [+25, -25], [-25, +25], [+25, +25] ] ]
      ]) {
      rotate(i[0], [0, 0, 1])
        rotate(i[1], [1, 0, 0])
          translate([0, -50, 0])
            for (j = i[2])
              translate([j[0], 0, j[1]])
				sphere(10);
      }
    }
  }
}

echo(version=version());

// rotate dice to show number on top face
function showRoll(x) =
(x==1) ? [270,0,0] :
(x==2) ? [180, 270, 0] :
(x==3) ? [0, 180, 0] :
(x==4) ? [0, 0, 180] :
(x==5) ? [0, 90, 0] :
(x==6) ? [90, 0, 0] :
[0,0,0];

// generate array of 2 random numbers between 2 and 6 inclusive using random seed
rseed1 = floor(rands(0, 10000, 1)[0]);
eseed1 = is_undef(seed1) ? rseed1 : seed1;
rnd = rands(1, 7, dice, eseed1);

// rotate the dice
for (a = [0:dice - 1])
translate([(a - (dice - 1) / 2) * 125,0,0])
let(value = floor(rnd[a]))
echo(str("dice ", a+1, " = ", value))
rotate(showRoll(value))
example006(colors[a % len(colors)]);

$fa = 5; $fs = 2;
colors = [ "red", "green", "cyan", "yellow", "darkslategray", "blue" ];

// Modified by Jesse Campbell, Dec. 11 2022
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
