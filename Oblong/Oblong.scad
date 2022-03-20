  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/

//https://en.wikipedia.org/wiki/Piet_Mondrian
seed=round(rands(0,9999,1)[0]);
echo(seed=seed);

Oblong(rec=4,size=[80,80*3/4],color=["white","Navy","white","red","white","gold","lightgrey","black","white"],border=[1,1],seed=seed);
color("black")cube([80,80*3/4,.5]);
text(str(seed),size=3,valign="top");
//Oblong(div=[1,1]*2,size=[841,1189],border=[1,1]*10);

module Oblong(rec=5,size=[50,50],border=[.5,1],div=[1.3,2.6],seed=41,h=[+5,10], minSize=7,color){

divR=rands(div[0],div[1],1,seed)[0];//[sqrt(2),1.618033];
borderR=rands(border[0],border[1],1,seed)[0];

case=size.x>size.y?1:0;


newA=case?[size.x/divR,size.y]:[size.x,size.y/divR];
newB=case?[size.x-newA.x,newA.y]:[newA.x,size.y-newA.y];

if(rec){ // recursive process
 Oblong(rec=min(size)-borderR>minSize?rec-1:0, size=newA, border=border, div=div, seed=seed*1.1, h=h, minSize=minSize,color=color);
 translate(case?[newA.x,0]:[0,newA.y])
  Oblong(rec=min(size)-borderR>minSize?rec-1:0, size=newB, border=border, div=div, seed=seed*1.2, h=h, minSize=minSize,color=color);
 }

if(!rec){ // only draw latest

cA=is_undef(color)?rands(0,1,3,seed*1.5):color[floor(rands(0,len(color)-.0001,1,seed*1.5)[0])];
cB=is_undef(color)?rands(0,1,3,seed*1.1):color[floor(rands(0,len(color)-.0001,1,seed*1.1)[0])];

color(cA)linear_extrude(rands(h[0],h[1],1,seed*1.6)[0])square(newA-borderR*[1,1]);
color(cB)translate(case?[newA.x,0]:[0,newA.y])linear_extrude(rands(h[0],h[1],1,seed*1.2)[0])square(newB-borderR*[1,1]);

}
}


