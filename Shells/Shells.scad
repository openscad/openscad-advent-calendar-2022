
  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

/*[Hidden]*/
$fs=.25;
$fa=1;

/*[Shells]*/
//thickness of shells
wall=.65;//[.45,.65,.85,1.25]

// center hole
socketHole=5.35;//[5.35:LED,12,28:E14,42:E27]
socketRingHole=0;//[0:auto,5.35]

// distance between shell segments
shellDist=1.25;

shells=20;

// fragmented shells LED
if(socketHole<10){
union()for(i=[+0:shells-1])rotate(i*137.5)rotate_extrude(angle=50-i*.5)
   Shell(13-i*0.25,i*0.75+12,10+i*1.25,info=i);
   
   }
   
   
// fragmented shells E14
if(socketHole>10)union()for(i=[+0:shells-1])rotate(i*137.5)rotate_extrude(angle=50-i*.5)
   Shell(socketHole +50-i*shellDist,i*0.75+socketHole +100,h=50+i*4,info=i);


// LED shells
  *union()for(i=[+0:shells-1])rotate_extrude(angle=360)
     Shell(socketHole+7-i*shellDist,i*2+socketHole+5,8+i*6,info=i);
   
// single test shell
  *Shell(r=5,rad=10,h=17,rand=1,hole=5);

   
/** \name Shell
Shell() creates a 2D shell 

\param r distance from center
\param rad radius of the shell
\param h  height of the shell
\param rand wall thickness
\param hole center diameter
\param hole2 walled center hole (bulb space)

*/

module Shell(r=5,rad=10,h=20,rand=wall,hole2=socketRingHole,hole=socketHole,info=0){

hole2=is_undef(hole2)||!hole2?hole^1.13:hole2;
holeH=hole>10?3:1;// base ring h

if(!info){
  echo();
  echo(SocketMaxDiameter =hole2,socketThreadDia=hole);
  echo();
}
rad2=rad-rand;


h3=sqrt(rad^2-max(0,rad-r)^2);

hole2H=rad2-sqrt(rad2^2-(rad-r+hole2/2)^2)-rad2+h3;
round=hole2H;

  offset(delta=rand*0.29,chamfer=true)offset(-rand*0.29){
    offset(-round)offset(round){
      if(is_num(h3))translate([r-rad,h3])
      difference(){
       circle(rad);
       circle(rad2); // lower half
       translate([-rand,0])intersection(){ // upper half
        circle(rad);
        square(500);
       }
       translate([-250,h-h3])square(500); // top cut
       translate([-249.99+rad-r,0])square(500,true);  // cut -x
       translate([-250+rad-r+hole2/2,-rad])square([500,rad*2],true); // hole 
      }
      if(is_num(hole2H)&&hole2H>0)translate([hole2/2,0])square([rand,hole2H]);// hole wall
    }// end concave round
    if(hole<hole2&&hole)translate([hole/2,0])square([(hole2-hole)/2+rand,holeH]);// base ring
  }// end convex round
}