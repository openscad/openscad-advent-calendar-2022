  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/


// Racer : https://en.wikibooks.org/wiki/OpenSCAD_Tutorial/Chapter_9

$fs=0.3;
$fa=5;

b=10;// width of track
union(){
translate([-100,0])Track(max=20,seed=11){
   difference(){
    square([b,1],true);
    translate([0,1.5])scale([1.0,0.5])offset(delta=1.5,chamfer=true)square([b -3.75,3],true);
   }
   for(i=[0,1])mirror([i,0]){
      translate([b/2,1])circle(0.15,$fn=8);
      translate([b/2+.5,1.5])circle(0.15,$fn=8);
      }

   }
   %translate([0,0,-10.25])color("forestgreen")linear_extrude(10)circle(800,$fn=12);
 }
 
 
  module Track(i=0,max=10,t=100,a=15,seed=1,b=b,lastA=0){

  maxRad=45; // radius increase for easy turns
//next Segment values
  a2=rands(10,190,1,i*seed/PI)[0];
  t2=a2+abs(lastA+a)>130?rands(5,maxRad,1,i*seed*PI)[0]*sign(-a):rands(-maxRad,maxRad,1,i*seed*PI)[0];
  t22=abs(t2)<b*.75?b*.75*sign(t2):t2;


// next segment
    if(i<max)rotate(a)translate([t-t22,0])
      Track(i=i+1,t=t22,a=a2*sign(t22),seed=seed+1,max=max,lastA=a){
    children(0);
    children(1);
    
    }
    
   // echo(i=i,angle=a,radius=t);// track data

// current track segment
    color(a>0?"Grey":"DimGrey")rotate_extrude(angle=a*1.001,convexity=5)translate([t,0])children(0);
    color(abs(t)<35?[1-abs(t)/35,abs(t)/35,0]:"skyblue")rotate_extrude(angle=a,convexity=5)translate([t,0])children(1);
    
    //tunnel
    color("LightSlateGrey")if(floor(rands(0,1.35,1)[0])) rotate_extrude(angle=a*1.001,convexity=5)translate([t,0]) difference(){
    circle(b*0.75);
    circle(b*0.75-1);
    translate(-b*2*[0.5,1])square(b*2.0);
    }
    
// marking
    color("silver")for(i=[0:400/abs(t):abs(a)])rotate(a<0?i+a:i)translate([t,0,0])cube([1,3,0.1],true);    
    
    // gates
    if(!(i%3))color(rands(0,1,4))rotate(a/2.0)translate([t,0,0])rotate([90])rotate_extrude(angle=180,convexity=5)translate([b,0])square([1,5],true);

// delineator
    color("navy")rotate(a)translate([t,0,0]){
       translate([b/2+0.2,0,1])cube([1,1,2],true);
       translate([-b/2-0.2,0,1])cube([1,1,2],true);
       }
    

// Start
    if(i==0) translate([t,0,0]){
      color("chartreuse")translate([0,-6,1.2])difference(){
        cube([b,12,3.4],true);
        translate([0,0.25,0.5])cube([b-1,11.51,3.0],true);
       }
       color("orange"){
        translate([ b/2-.25,0,-0.5])rotate(90)cylinder(3.5,d1=2,d2=0.6,$fn=6);
        translate([-b/2+.25,0,-0.5])rotate(90)cylinder(3.5,d1=2,d2=0.6,$fn=6);
        }
       translate([0,3,b*.75-0.3]){
        color("red") for(i=[-1.3,-0.2])translate([0,0,i])for(i=[-2:2])translate([i*1.3,0])rotate([90])cylinder(1.5,d=1,center=true);
        color([1,1,1]*0.3)translate([0,0,-b*0.74/2])difference(){
          cube([b*1.5,1,b*.75],true);
          translate([0,0,-1])cube([b*1.5-1,2,b*.75],true);
          }
        }
       //translate([0,-.5,-0.175])rotate([10,0])cube([b,1,.5],true);
     }
// Finish
    if(i==max){
    size=b/5;
      rotate(a)translate([t,0,0])
        translate([-b/2-size/2,0,-size])for(x=[0:5],y=[0:15])
          color((x+y)%2?"DimGray":"Gainsboro")
            translate([x,y]*size)translate((x+y)%2?[0,0,0]:[0,0,-.1])cube(size*1.00001);
    }
     
  }