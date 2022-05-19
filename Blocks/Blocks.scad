  // License: CC0 (aka CC Zero) - To the extent possible under law,
 // Ulrich Bär has waived all copyright and related or neighboring rights to this work.
// https://creativecommons.org/publicdomain/zero/1.0/


Blocks();

module Blocks(rec=8,size=[500,500],level=50,seed=62,lRange=[-1,2]*10,div=1.01){

randomLevel=rands(lRange[0],lRange[1],4,seed);

div=pow(div,1.8);

if (rec){
translate([size.x/4,size.y/4])Blocks(rec=rec-1,size=size/2,level=level+randomLevel[0],seed=seed+1,lRange=lRange/div,div=div);
translate([size.x/4,-size.y/4])Blocks(rec=rec-1,size=size/2,level=level+randomLevel[1],seed=seed+pow(2,rec+1),lRange=lRange/div,div=div);
translate([-size.x/4,-size.y/4])Blocks(rec=rec-1,size=size/2,level=level+randomLevel[2],seed=seed+pow(3,rec+1),lRange=lRange/div,div=div);
translate([-size.x/4,size.y/4])Blocks(rec=rec-1,size=size/2,level=level+randomLevel[3],seed=seed+pow(4,rec+1),lRange=lRange/div,div=div);
} 



if(!rec){
color([1,1,1]*min(1,max(0,level/120) ) )translate([0,0,level/2]) cube(concat(size*1.001,level),true);
//translate([0,0,level+.1])color("black")text(str(seed),halign="center",valign="center",size=size.x/3);
}

}