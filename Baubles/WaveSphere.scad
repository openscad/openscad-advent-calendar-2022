/* scADVENT 202x - Baubles  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 */
 
 /*[Baubles]*/
kugel=1;//[1:positivKnurl, 2:negative Knurl, 5:twisted, 6:waves, 3:Hearts impressed, 4:Hearts embossed ]
all=false;
dia=20;

Color(){
if(kugel==2||all)translate(kugel==2?[0,0,dia/2-1]:[25,0])
  Nubsi(dia/2-2)
  Dual(isect=0,sr=dia/2+.2,sr2=dia/2-.35)
  Sphere(r=dia/2,rz=dia/2,az=+0,twist=+1.00,a=0.5,centerDia=.01,f=20,f2=20.0,grad=360,grad2=180,fn=40,fny=20);
  
if(kugel==1||all)translate(kugel==1?[0,0,dia/2-1]:[25,0,30])
  Nubsi(dia/2-2)
  Dual(isect=1,sr=dia/2+.2,sr2=dia/2-.35)
  Sphere(r=dia/2,rz=dia/2,az=+0,twist=+1.00,a=0.5,centerDia=.01,f=20,f2=20.0,grad=360,grad2=180,fn=40,fny=20);    


if(kugel==4||all)translate([-25,0])
  Nubsi()
  Dual(isect=0,rot=0*4.5,sr=10.4,sr2=9.7,fn=360)
  Sphere(r=10,rz=10,az=+0,twist=+0.50,a=0.5,centerDia=.05,f=20,f2=20.0,grad=360,grad2=180,fn=360,fny=120);
  
if(kugel==3||all)translate([-25,0,30])
  Nubsi()
  Dual(isect=1,rot=-2*4.5,sr=10.2,sr2=9.6,fn=360)
  Sphere(r=10,rz=10,az=+0,twist=+0.50,a=0.5,centerDia=.05,f=20,f2=20.0,grad=360,grad2=180,fn=360,fny=120);
    
if(kugel==5||all) translate([0,0])
  Nubsi(z=8.2)
  Sphere(r=10,rz=10,az=0.3,twist=+2,a=0.35,centerDia=.01,f=20,f2=20.0,grad=360,grad2=180,fn=360,fny=180);
  
if(kugel==6||all)translate([0,0,30])
  Nubsi(z=8.2)
  Sphere(r=10,rz=10,az=0.3,twist=0,a=0.35,centerDia=.01,f=20,f2=40.0,grad=360,grad2=180,fn=360,fny=180);    

}


function RotLangL(rot=0,l=10,lz,e)=[sin(rot)*cos(e)*l,cos(rot)*cos(e)*l,sin(e)*(is_undef(lz)?l:lz)];


module Sphere(r=10,rz=10,az=+0.3,twist=+1.00,a=0.5,centerDia=0.01,f=20,f2=20.0,grad=360,grad2=179,fn=40,fny=20){
rz=is_undef(rz)?r:rz;
  
points=[for(e=[0:fny+0],rot=[0:fn+0])
  RotLangL(rot=grad/(fn+0)*rot+twist*e*grad2/fny,
    l=r+a*(sin(e*grad2/fny*f2)+cos((rot)*grad/(fn+0)*f)),
    e=-grad2/2+grad2/fny*e,lz=rz+az*cos(rot*grad/(fn+0)*f))//
+RotLangL(rot=grad/(fn+0)*rot+grad2/fny*twist*e,l=centerDia/2,e=0)
];

faces=[for(i=[0:len(points)-fn -3])[i,i+1,i+2+fn,i+fn+1]];
    faces2=[[for(i=[fn-1:-1:+0])i],[for(i=[len(points)-fn:len(points)-1])i]];

polyhedron(points,concat(faces2,faces),convexity=15);
}


module Dual(isect=0,sr,sr2,rot=0,fn=60){
    
 if (isect){ intersection(){
  children();
  rotate(rot) mirror([1,0,0])children();
 if(sr)  sphere(sr,$fn=fn);
  }
 if(sr2) sphere(sr2,$fn=fn);   
 }
else intersection(){
    union(){
      children();
      rotate(rot) mirror([1,0,0])children();  
      if(sr2)sphere(sr2,$fn=fn);  
    }
  if(sr)sphere(sr,$fn=fn);
}

 
}


module Color(){
  
  for(i=[0:$children-1])
    color(palette[i%len(palette)])
       children(i);
    
  palette=[
  "ForestGreen",
  "red",
  "lime",
  "orange",
  "orangeRed",
  "green"
  ];

}

//!Nubsi(10)sphere(1);

module Nubsi(z=7.9){//Hanger
  $fn=36;
    children();
    translate([0,0,-z -2.5])cylinder(15,d=5);//Base
    translate([0,0,z])rotate(-90) difference(){
        rotate_extrude()intersection(){
          offset(.5)offset(-.5)offset(-1.5)offset(1.5)union(){
            square([1.5,5]);
            translate([0,5])scale([1,0.5])circle(2);
            square([5,4],center=true);
          }
          translate([0, -50])square(100);
        }
    hull(){
      translate([1.5,0,3.5]) cube([3,1,1.5],true);
      translate([0,0,2.9])rotate([0,95])cylinder(10,d=1);
    }
        
    cylinder(20,d=1,$fn=24);
    translate([0,0,5.8])cylinder(5,d=10,$fn=6);    
    }
}