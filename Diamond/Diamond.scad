/* scADVENT 202x  -  Diamond  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model a Diamond
 */

/*[Diamond]*/

//name=["height","radius","n-gon","delta"];

top= [50,  15,  8,  0];
l1=  [46,  20,  8,  8];
l2=  [40,  24, 16,  0];
l3=  [10, 6.5,  8,  8];
base=[ 0,   0,  1,  0];


info=true;
preset=0; //[0:None, 1:example, 2:Swiss Cut, 3: Rose Cut, 4: Brilliant, 5:Portuguese]



data=[
["top", "l1", "l2", "l3", "base"],
[[50, 10, 6, 0], [45, 20, 12, 6], [40, 22, 24, 0], [36,  22, 12, 12], [0, 2, 6, 0]], // example
[[50, 12, 8, 0], [45, 22,  8, 8], [40, 22, 16, 0], [36,  22,  8,  8], [0, 2, 8, 0]],  // swiss
[[50,  0, 6, 0], [48, 15,  6, 6], [40, 24, 12, 0], [36,  25,  6,  6], [0, 2, 6, 6]], // rose
[[50, 15, 8, 0], [46, 20,  8, 8], [40, 24, 16, 0], [10, 6.5,  8,  8], [0, 0, 1, 0]], // brilliant
concat([for(i=[1:5])[10-pow(i,2.2)/10,pow(i,1.0) +2,18, i%2?0:18]],[[0, 1, 18, 0]]) // portuguese
];


parameter=preset?data[preset]:[top, l1, l2, l3, base];

echo(current_parameter=parameter);



Level = function (v)
  let(
  n=v[2]?v[2]:1,
  step  = 360/n,
  delta = v[3]?180/v[3]:0
  )
[
for(i=[0:n-1]) [
  sin(i*step+delta) * v[1],
  cos(i*step+delta) * v[1],
  v[0]
 ]
];


points= [
  for(i=[0:len(parameter)-1])
  each Level(parameter[i])
  ];

// background for topview
if($preview&&!$vpr.x&&!$vpr.y)translate([0,0,-50])color("Ivory")intersection(){
  rotate([-35,-45])cube([1500,1500,1],true);
  cylinder(10000,r=parameter[2][1],center=true,$fn=parameter[2][2]);
}

color("silver",alpha=0.45)
rotate(+45)hull()polyhedron(points,[[for(i=[0:len(points)-1])i]]);
 translate([0,0,1]) sphere(.0001);// forcing CGAL for wireframe view F11
  

if(info&&$preview)union(){
  for(i=[0:len(parameter)-1])
   let( rot= -45 + (parameter[i][3]?180/parameter[i][3]:0),
        name= str("   «—",i==0?" top":
                               i==len(parameter)-1?" base":
                                                   str(" l",i))
   )
    rotate(rot)
      translate([parameter[i][1], 0, parameter[i][0] ])
        color(pal[i%len(pal)]){
          rotate([0,45])cylinder($vpd/20,r1=0,r2=0.75,$fn=3);
          rotate($vpr-[0,0,rot])text(name,size=$vpd/60,valign="center");
        }


 pal=[
 "pink",
 "lime",
 "lightblue",
 "maroon",
 "crimson",
 "slategray",
 "Ivory"
 ];
 

}

