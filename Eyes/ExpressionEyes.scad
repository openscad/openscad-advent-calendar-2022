/* scADVENT 202x - Expressions  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 */

step= 1/500;

Expression();


module Expression(t=0,old=[[0,-15],[1,1,1,1],[8],[0]],new=[[0,0],[1,1,1,1],[5],[0]],count=2220,seed1=0,blink=0){
  
  ipd=115;
  
  intervall1=round(rands(5,20,1,seed1)[0]);
  intervall2=round(rands(20, 25, 1,seed1)[0]);
  
//echo(focus=old[3]);
  
  function change (old,new)=old+(new-old)*(($t-t)/step);
  
  if($t>t+step)Expression(t=t>1-step?0:t+step,old=new,new=
  [
    concat(// pos 0
  rands(-15, 15, 1,count), // x
  rands(-10-blink/1, 10-blink/3, 1,count) // y
  
  ),   // pos
    count%intervall1?new[1]:rands(0.5, 1.5, 4,count), // scale 1
    count%intervall1?new[2]:rands(5, 12, 1,count),    // p 2
    count%intervall1?new[3]:rands(2, 20, 1,count)    // focus 3
    
  ]  
  ,
  count=count+1,
  seed1=count%intervall1?seed1:seed1+count,
  blink=count%intervall2?blink<15&&blink?blink+.5:0:.1
  );
   else {
     //echo(t,old,new,count);
     translate([ipd/2,0,-1])Scale(  // right
        change (old[1], new[1]) )
          circle(50);
     translate( change(old[0], new[0]) +[ipd/2-change(old[3],new[3])[0],0])
        Eye(change (old[2], new[2])[0] , 13 );

     translate([ipd/2,0,+1]) Blink();
     
     
     
    mirror([1,0]){ // left
     translate([ipd/2,0,+1]) Blink();
     translate([ipd/2,0,-1])Scale(  // white
        change (old[1], new[1]) )
          circle(50);}
     translate( change(old[0], new[0]) -[ipd/2-change(old[3],new[3])[0],0]) // pupil + iris
        Eye(change (old[2], new[2])[0] , 13 );
   }
   
   
   module Blink(blink=blink){
          color("grey")
       difference(){
        offset(2) Scale(  // right blink close
            change (old[1], new[1])+[0, 0, 0.25,blink? -1/blink:0] 
         )
              circle(50);
      if(blink>3||!blink)  offset(3.5) Scale(  // right blink
            change (old[1], new[1]) +[0,0,blink?-1/blink:+0,blink?-1/blink:0])
              circle(50);
       } 
     
   }
   
   
}


module Eye (pup,iris,color="lightblue"){
  translate([0,0,.2])color("black") circle(pup);
  n=60;
  translate([0,0,0.15])for(i=[0:n-1])color("slategrey")rotate(rands(0,3600,1,-5+i)[0])square([0.25,iris/1.1]);
  translate([0,0,.1])color(color) circle(iris);
}

//Scale([3,1,1,1])circle(20);


module Scale(v=[1,1,1,1]){
  
  vi=[
  [v[0],v[2]],
  [v[0],v[3]],
  [v[1],v[3]],
  [v[1],v[2]],
  ];
  
  for(i=[+0:3]) 
    scale([
     max(0.01, v[i>1?1:0]),
     max(0.01, v[i==1||i==2?3:2])
    ])
      intersection(){
        children();
        rotate(i*-90)square(150);
      }
}