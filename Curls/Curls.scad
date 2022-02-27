    // License: CC0 (aka CC Zero) - To the extent possible under law,
   // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
  // https://creativecommons.org/publicdomain/zero/1.0/
  
  /*[Curls]*/
  $fn=36;
  //seed=42;
  d=3;
  rangeAngle=[-300,1,300];
  rangeRadius=[7,1,20];
  maxAngleY=180;
  maxSegments=50;
  number=20;
  
  seed=rands(0,99999,1)[0];
  echo(seed=seed);
  

  
  seeds=rands(0,99999,number,seed);
  
  color("wheat") // comment for individual color
  for(i=[0:number-1])rotate(rands(-180,180,3,seeds[i]))
    K(maxCount=round(rands(20,maxSegments,1,seeds[i])[0]),part=i,random=seeds[i],d=rands(3,3,1,seeds[i])[0]);

    
module K(rec=1,maxCount=5,angle=rangeAngle[0],radius=rangeRadius[2],d=d,part=0,random=1){
  rand=rands(0,1,3,random*rec); // random Values for rotation arc angle and radius
  randColor=rands(0,1,3,random);  // create a random Color
  maxColor=randColor*min(1/randColor); // scale randColor so one Value is 1
  dir=angle>0?0:180;
  angle=abs(angle);
  
  if(rec<maxCount)translate([-radius,0]) rotate(angle) translate([radius,0]) rotate([0,rand[0]*maxAngleY+dir])
  K(rec=rec +1, maxCount=maxCount,
    angle=rangeAngle[0]+rand[1]*(rangeAngle[2]-rangeAngle[0]),
    radius=max(rangeRadius[0]+rand[2]*(rangeRadius[2]-rangeRadius[0]),d),
    part=part,random=random,d=d);
  
  color(maxColor*max(rec/maxCount,.5))if(rec==maxCount)sphere(d=d);
  else translate([-radius,0])rotate_extrude(angle=angle)translate([radius,0])circle(d=d);
  if(rec==1)echo(part=part,color=maxColor,segments=maxCount-1);
}