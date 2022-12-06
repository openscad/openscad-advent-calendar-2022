   // SCADvent 2022
  // To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

PHI=(1+sqrt(5))/2;

Tanne();


module Tanne (h=56){
color("ForestGreen")for(i=[0:18:359])rotate(i)rotate_extrude(angle=10)
  for(i=[-50:3:+0])translate([0,i+65])difference(){
    circle(15*abs(i)/50);
    translate([8*-i/50,2.5*-i/50])circle(12*abs(i)/50);
    translate([-500,-250])square(500);// cut - X
    translate([-250,0])square(500); // cut + Y
  }


translate([0,0,-5])color([0.4,.2,0])cylinder(65,d1=7,d2=0.1); // Stem


max=360*30;
for (i=[620:360-360/PHI:max]){
  randomc=rands(0,1,4);
  randomc3=concat(randomc[0],randomc[1],randomc[2],max(randomc[3],0.5));
  randomc2=concat(randomc[0],randomc[1],min(1,(1-randomc[0])+(1-randomc[1])),max(randomc[2],0.4));
    rotate(i)translate([13-12*i/max,0,i/max*h])color(randomc3)sphere(2.0-1*i/max,$fs=.5);
    
    
}

for (i=[620+180:360-360/PHI:max]){
  randomc=rands(0,1,3);
  randomc2=concat(randomc[0],randomc[1],min(1,(1-randomc[0])+(1-randomc[1])),max(randomc[2],0.4));
  rotate(i)translate([14-13.6*i/max,0,i/max*h+7])color(randomc)rotate([20,90]){
    cylinder(.1,r=2.0-1*i/max,$fn=3);
    rotate(60)cylinder(.1,r=2.0-1*i/max,$fn=3);
  }
    
    
}
}
translate([0,0,-150])square(5000,true);
