// Created in 2022 by Ryan A. Colyer.
// This work is released with CC0 into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/

// View, Animate, FPS: 30, Steps: 400

$fa=1; $fs=0.2;

module Bubble(d, asym=1.5) {
  asym = asym > 20 ? 20 : asym < -20 ? -20 : asym;
  asym_fact = 1+exp(asym);
  nas_adj = asym > -3 ? 1 : 1/(-2-asym)^0.3;
  xscale = 0.5/sqrt(0.5-0.5^asym_fact)^nas_adj;
  resize([d, d, d])
    rotate_extrude()
    polygon(
      [for (a=[-90:90]) let(
          y = (sin(a)+1)/2,
          x = sqrt(y-y^asym_fact)^nas_adj
        )
      10*[x*xscale, asym>0 ? 1-y : y]]
    );
}

t2 = ($t*4)%1;
asymmetry = 2.5*(4*(t2<0.5?t2:1-t2)-1)-1;

rotate([3*360*$t, 5*360*$t, 2*360*$t]) {
  translate([0, 0, 2.9])
    color([0, 0, 1])
    sphere(2);
  translate([0, 0, -5])
    color([0.0078, 0.85, 0.96, 0.5])
    Bubble(10, asymmetry);
}

