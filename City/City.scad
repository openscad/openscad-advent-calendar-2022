  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

// City

carnvas=[1000/3,1000/4];
$vpt=carnvas/2;
$vpr=[0,0,0];
$vpd=750;


module block (size=[10,20],grid=[4,5],frame=[0.5,1.2],color="slategrey",window=[[0.82,0.82,0.75],[0.4,0.3,0.3]]){
  color(color)translate([-size.x/2,0])square (size);
  for(x=[0:grid.x-1],y=[0:grid.y-1])
    translate([x*size.x/grid.x-size.x/2+ frame.x,
               y*size.y/grid.y + frame.y,
               .01
              ])
      color(window[floor(rands(0,2,1)[0])]*rands(0.6,1.0,1)[0])square([
                                                    size.x/(grid.x),
                                                    size.y/(grid.y)
                                                  ]-frame*2,false);
}

//stars
for(i=[0:100])
color("ivory")
translate([rands(0,carnvas.x,1)[0],
           rands(0,carnvas.y,1)[0],
          -5])circle(rands(0.3,1,1)[0],$fn=12);

// blocks
intersection(){
  union()for(i=[0:round(rands(20,75,1)[0])])
    let(pos=rands(0,carnvas.y/3,1)[0])
    translate([rands(0,carnvas.x,1)[0],
               pos,
               50-pos/(carnvas.y/3)*50
              ])block(
    size=[ rands(10,25,2)[0], rands(20,50,2)[0] ],
    grid=[ round(rands(2,5,1)[0]), round(rands(5,10,1)[0]) ],
    frame=rands(0.1,1,2),
    window=[ rands(0.15,0.20,3) *rands(2.6,2.2,1)[0],
             rands(0.15,0.20,3) *rands(0.6,1.4,1)[0]
           ],
    color=rands(0.27,0.30,3)*rands(0.6,1.4,1)[0]
  );
  cube(concat(carnvas,55));
}


//moon
translate([0,0,-1])union(){
phase=rands(0.2,2,1)[0];
s=rands(5,20,1)[0];
moonPos=[rands(0,carnvas.x,1)[0],
         rands(0,carnvas.y*2/3,1)[0]+carnvas.y/3
          ];
  
  color([1,1,1]*0.13) translate([0,0,-2])intersection(){// moon
    translate(moonPos)circle(s,$fn=60);
    square(carnvas);
  }
  
  color("wheat")intersection(){ // sun moon
    union(){
      translate(moonPos)rotate(rands(-30,30,1)[0]){
              
              if(phase>1)scale([phase-1,1])circle(s,$fn=60);
              difference(){
                circle(s,$fn=60);
                translate([0,-25])square(50);
                if(phase<1)scale([phase,1])circle(s,$fn=60);
              }
            }
    }
  square(carnvas);
  }
}


//background
color("black")translate([0,0,-10])square(carnvas);

//landscape
color([0.2,0.23,0.2])
polygon([[0,0],[0,carnvas.y/3],
        for(i=[0:29])[
          i*carnvas.x/30+rands(-1,1,1)[0]*carnvas.x/60,
          carnvas.y/3+rands(-1,1,1)[0]*carnvas.y/20
        ],
        [carnvas.x,carnvas.y/3],
        [carnvas.x,0]]
        );

