  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

$fs=.5;
$fa=1;

/*[Twister]*/
profil=1;
ngon=5;
h=50;
d=20;
wall=1.5;
twist=10; // twist per mm
round=10;
sliderH=10;
clearance=.3;

sliderDist=5;
support=false;

if(!support||$preview)color(echo(col[ngon-2])col[ngon-2])translate([0,0,2])union(){
  union(){
    intersection(){
      linear_extrude(h,twist= twist*h,convexity=5)Profil();
      linear_extrude(h,twist=-twist*h,convexity=5)Profil();
    }
                      hull()rotate_extrude()translate([d/2,0])circle(2);
    translate([0,0,h])hull()rotate_extrude()translate([d/2,0])circle(2);
  }

  translate([0,0,sliderDist])        rotate(-twist*sliderDist)          Slider();
  translate([0,0,sliderH+sliderDist*2])rotate(twist*(sliderH+sliderDist*2))Slider(-twist);
}

//support
if (support)color("orange",.5)difference(){union(){
diffTwist=(-twist*(sliderH+sliderDist)%(360/ngon)-twist*(sliderH+sliderDist*2)%(360/ngon))+360/ngon;
translate([0,0,+2.0])Slider(h=sliderDist,twist=twist);//linear_extrude(sliderDist,twist=twist*sliderDist)offset(wall+clearance)Profil();
translate([0,0,+2.0+sliderH+sliderDist])rotate(-twist*(sliderH+sliderDist))Slider(h=sliderDist,twist=diffTwist/sliderDist);
// linear_extrude(sliderDist,twist=diffTwist)offset(wall+clearance)Profil();
}
translate([0,-2/2])cube([d,2,h]);
}
module Slider (twist=twist,h=sliderH,clearance=clearance,wall=wall){
  linear_extrude(h,twist=twist*h,convexity=5)difference(){
    offset (wall+clearance) Profil();
    offset (clearance )     Profil();
  }
}

module Profil(round=round,d=d,ngon=ngon,profil=profil){
if(profil) offset(-round) offset(+round) for(i=[0:ngon-1])let(deg=360/ngon*i) rotate(deg)translate([d/4,0])circle(d/4);

else offset(+round) offset(-round) circle(d=d,$fn=ngon);

}

col=[
"PowderBlue",
"LightSteelBlue",
"Skyblue",
"LightSkyblue",
"DeepSkyblue",
"DodgerBlue",
"CornflowerBlue",
"SteelBlue",
"RoyalBlue",
"DarkBlue"

];