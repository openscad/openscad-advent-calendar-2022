  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/
$fn=150;


function scene(scenes=10,t=$t)=[for(i=[0:scenes-1])min(max(t*scenes-i,0),1)];

for(i=[1:5])
  color([0.3,0.4,0.7]+[0.5,0.4,0.3]*i/6)
    C4(s=i*15, rot=(270+360)*$t, fn=i+2,
      angleA=min(scene(2,$t)[0]*180*1.1*i,180),
      angleB=max(scene(2,$t)[1]*-180*1.1*i,-180)+180
    );

$vpr=[-180,90,360]*$t;


module C4(
s=15,
r=+6,
fn=6,
rot=0,
angleA=+180,
angleB=+180
){

rotate([ (angleA/2-90),0,0])translate([ 0, 0, -s ])A(rot,angleB);
rotate([-(angleA/2-90),0,0])translate([ 0, 0,  s ])A(-rot,angleB);
rotate([0, 90,-angleB/2-90])translate([ 0, 0, -s ])A(-90-rot,angleA);
rotate([0,-90,angleB/2-270])translate([ 0, 0, -s ])A(-90-rot,angleA);

module A(rot=0,angle=180)
  rotate((180-angle)/2)rotate_extrude(angle=angle)translate([s,0])rotate(rot)circle(r,$fn=fn);    
    
}

