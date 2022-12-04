// 2.5D Waving Santa
// Jordan Brown openscad at jordan.maileater.net
//
// Derived from line art by Gordon Dylan Johnson at
// https://openclipart.org/detail/308933/santa-waving
// Original clip art is public domain per https://openclipart.org/share
//
// Caucasian skin tone from https://www.color-hex.com/color-palette/737
// by Lilybug97.
//
// I hereby release this OpenSCAD program and my modifications to the SVG
// into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/

// Note that this OpenSCAD progam depends on the "import SVG by id"
// feature, pull request #4042, available only in the development
// snapshots.

// How I did this:
//
// I started with GDJ's line art and used Inkscape to simplify
// it considerably. This is a 3D (well, 2.5D) object and so will
// cast its own shadows, so did not need shadows in the image.
// Many of the components were slightly disconnected from one
// another - e.g. the boots and legs - and I brought them together.
// I also rebuilt components that physically would be one object
// so that they are single objects in the image - for instance,
// the belt was originally three objects broken up by the buckle;
// I made it be one continuous object with the buckle on top of it.
// I combined related objects (e.g. the eyebrows) into single objects
// so that I could manage them together. The original is about 60
// objects; I simplified it to about 20. I similarly simplified
// most of the curves, both to avoid self-intersections that OpenSCAD
// is allergic to and to suit my own design sense.
//
// I used Inkscape's Object Properties dialog to give each component
// a distinct human-friendly ID.
//
// This OpenSCAD program is then fairly simple - for each component,
// by name, I import the component and assign it a height and color.
//
// This basic technique can be used to take any 2D image and turn it
// into a 2.5D model.

// How much to put underneath the entire model
base = 0.1;
// How big each Z step should be
zstep = 1;
// Overall height (in Y) of the model
height = 100;

module stop() {}    // End customizer parameters.

svg = "openclipart.org-308933-santa-waving-jb.svg";
svgHeight = 100;
xyscale = height/svgHeight;

parts = [
    [ "tassel", 1, "white" ],
    [ "ears", 2, "#efd0ad" ],
    [ "arms", 2, "red" ],
    [ "mouth", 2, "darkred" ],
    [ "pants", 2, "red" ],
    [ "hat", 2, "red" ],
    [ "arm_cuffs", 3, "white" ],
    [ "boot2", 3, "SaddleBrown" ],
    [ "head", 3, "#ffe0bd" ],
    [ "lips", 3, "red" ],
    [ "body", 3, "red" ],
    [ "hat_cuff", 4, "white" ],
    [ "boots", 4, "sienna" ],
    [ "eyebrows", 4, "white" ],
    [ "eyes", 4, "black" ],
    [ "beard", 4, "white" ],
    [ "belt", 4, "black" ],
    [ "jacket_cuff", 4, "white" ],
    [ "buckle", 5, "gold" ],
    [ "moustache", 5, "lightgray" ],
    [ "nose", 6, "#ffc09d" ],
];

scale([xyscale, xyscale, 1]) {
    color("red") linear_extrude(height=base) import(svg);

    translate([0,0,base]) scale([1,1,zstep]) for (part = parts) {
        color(part[2])
            linear_extrude(height=part[1]+base)
            import(svg, id=part[0]);
    }
}
