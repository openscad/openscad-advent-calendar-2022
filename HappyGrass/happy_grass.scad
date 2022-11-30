// Created in 2022 by Ryan A. Colyer.
// This work is released with CC0 into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/

// View, Animate, FPS: 30, Steps: 1500

N=50;
function MakeChain(var=0) = [for (i=[0:N]) [30/N,
  [ i<N/2 ? (90+var)/N*cos(5*360*$t) : (120-var)/N*cos(8*360*$t+45),
    (60+var)/N*cos(11*360*$t+15+5*var),
    (60-var)/N*cos(17*360*$t+85-5*var)]]];

// chain is a list of link elements specified as [length, [rotx, roty, rotz]]
// children(0) is the 2D surface to extrude, and optional children(1) goes at
// the end of the chain.  max_r is the farthest extent of the 2D surface from
// the origin.  $chain_color specifies the chain's color.
module Link(chain, max_r, i=0) {
  $chain_color = is_undef($chain_color) ? "cyan" : $chain_color;
  if (i < len(chain)) {
    a = chain[i][1];
    an = i < len(chain)-1 ? chain[i+1][1] : [0,0,0];
    L = chain[i][0];
    T = [L*sin(a[1])*cos(a[0]), -L*sin(a[0]), L*cos(a[1])*cos(a[0])];
    color($chain_color) {
      ext_h = 2.02*max_r*sqrt(tan(an[0])^2+tan(an[1])^2);
      rotate(a) linear_extrude(height=L+ext_h) children(0);
    }
    translate(T) rotate(a) Link(chain, max_r, i+1) {
      children(0);
      if ($children > 1) {
        children(1);
      }
    }
  }
  else {
    if ($children > 1) {
      children(1);
    }
  }
}

module HappyGrass(var) {
  d = 2;
  $chain_color = "#20e8a0";
  Link(MakeChain(var), d/2) {
    square([d, d/5], center=true);
    union() {
      difference() {
        color($chain_color) sphere(d=2*d, $fn=48);
        color("black") translate([0, -0.5*d, 0.7*d])
          rotate([-30, 0, 0]) scale([4, 2, 0.9])
          sphere(d=0.5*d, $fn=16);
      }
      color("#e0e000") {
        translate([0.4*d, 0.4*d, 0.7*d]) sphere(d=d/2, $fn=16);
        translate([-0.4*d, 0.4*d, 0.7*d]) sphere(d=d/2, $fn=16);
      }
    }
  }
}

translate([-10, 0, 0]) { $t = ($t + 0.003*cos(2*360*$t))%1; HappyGrass(0); }
HappyGrass(1);
translate([10, 0, 0]) { $t = ($t + 0.005*cos(3*360*$t+72))%1; HappyGrass(2); }

