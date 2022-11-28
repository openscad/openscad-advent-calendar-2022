  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/
$fa=1;
//resolution size
$fs=.75;//[.2:1]


// single
CF(25*[1,2,3],rad=6,wall=5); 

// linear
*union()for(i=[0:4])translate([0,i*10,-1.5])rotate([atan(sqrt(2))])rotate(45)CF(15);

// polar
*intersection(){
  union()for(i=[0:5])rotate(i*60)
   translate([11.5,0, -2.5])rotate([atan(sqrt(2)),0,i%2?30:-30])rotate(45)CF(15);
   cylinder(1000,d=1000);
}


module CF(size=[20,20,20],wall=2.5,rad=1,irad=2,rad3=.75){
wall=max(1,wall-rad3*2);
rad2=max(irad,rad-wall+.1); // window cut radius
irad2=rad2*sqrt(2); // inner cube radius

size=(is_num(size)?size*[1,1,1]:size)-rad3*[2,2,2];

  minkowski(convexity=5){
    translate(size/2+[1,1,1]*(rad3))
      difference(){
        minkowski(){cube(size-[2,2,2]*rad,true);if(rad)sphere(rad,);};
        union(){
           if(irad2)minkowski(){cube(size-[2,2,2]*(wall+irad2/sqrt(2)-0.1),true);if(irad2>0)sphere(irad2);}
           minkowski(){cube(size-[-5,2,2]*(wall+rad2),true);if(rad2)sphere(rad2);}
           minkowski(){cube(size-[2,-5,2]*(wall+rad2),true);if(rad2)sphere(rad2);}
           minkowski(){cube(size-[2,2,-5]*(wall+rad2),true);if(rad2)sphere(rad2);}
        }
      }
    if(rad3)sphere(rad3);
  }
  
}