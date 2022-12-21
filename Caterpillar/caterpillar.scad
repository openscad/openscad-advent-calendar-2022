// Original by Justin Lin, licensed under CC BY-NC-SA 4.0
// https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Modification by Ryan A. Colyer, 2022
// Commemorating Justin Lin, aka JustinSDK, Lin Xinliang, 1975-2022.
// https://www.thingiverse.com/justinsdk/designs
// https://github.com/JustinSDK/dotSCAD

radius = 5;

// Given a `radius` and `angle`, draw an arc from zero degree to `angle` degree. The `angle` ranges from 0 to 90.
// Parameters:
//     radius - the arc radius
//     angle - the arc angle
//     width - the arc width
module a_quarter_arc(radius, angle, width = 1) {
    outer = radius + width;
    intersection() {
        difference() {
            offset(r = width) circle(radius, $fn=48);
            circle(radius, $fn=96);
        }
        polygon([[0, 0], [outer, 0], [outer, outer * sin(angle)], [outer * cos(angle), outer * sin(angle)]]);
    }
}

// Given a `radius` and `angles`, draw an arc from `angles[0]` degree to `angles[1]` degree.
// Parameters:
//     radius - the arc radius
//     angles - the arc angles
//     width - the arc width
module arc(radius, angles, width = 1) {
    angle_from = angles[0];
    angle_to = angles[1];
    angle_difference = angle_to - angle_from;
    outer = radius + width;
    rotate(angle_from)
        if(angle_difference <= 90) {
            a_quarter_arc(radius, angle_difference, width);
        } else if(angle_difference > 90 && angle_difference <= 180) {
            arc(radius, [0, 90], width);
            rotate(90) a_quarter_arc(radius, angle_difference - 90, width);
        } else if(angle_difference > 180 && angle_difference <= 270) {
            arc(radius, [0, 180], width);
            rotate(180) a_quarter_arc(radius, angle_difference - 180, width);
        } else if(angle_difference > 270 && angle_difference <= 360) {
            arc(radius, [0, 270], width);
            rotate(270) a_quarter_arc(radius, angle_difference - 270, width);
       }
}

// Given a `radius` and `angle`, draw a sector from zero degree to `angle` degree. The `angle` ranges from 0 to 90.
// Parameters:
//     radius - the sector radius
//     angle - the sector angle
module a_quarter_sector(radius, angle) {
    intersection() {
        circle(radius, $fn=96);

        polygon([[0, 0], [radius, 0], [radius, radius * sin(angle)], [radius * cos(angle), radius * sin(angle)]]);
    }
}

// Given a `radius` and `angle`, draw a sector from `angles[0]` degree to `angles[1]` degree.
// Parameters:
//     radius - the sector radius
//     angles - the sector angles
module sector(radius, angles) {
    angle_from = angles[0];
    angle_to = angles[1];
    angle_difference = angle_to - angle_from;

    rotate(angle_from)
        if(angle_difference <= 90) {
            a_quarter_sector(radius, angle_difference);
        } else if(angle_difference > 90 && angle_difference <= 180) {
            sector(radius, [0, 90]);
            rotate(90) a_quarter_sector(radius, angle_difference - 90);
        } else if(angle_difference > 180 && angle_difference <= 270) {
            sector(radius, [0, 180]);
            rotate(180) a_quarter_sector(radius, angle_difference - 180);
        } else if(angle_difference > 270 && angle_difference <= 360) {
            sector(radius, [0, 270]);
            rotate(270) a_quarter_sector(radius, angle_difference - 270);
       }
}

module wheel(radius) {
    $fn = 96;
    rotate_extrude() translate([radius, 0, 0]) circle(radius / 2);
}

module wheels(radius) {
    wheel(radius);
    translate([radius * 4, 0, 0]) wheel(radius);
    translate([radius * 8, 0, 0]) wheel(radius);
}

module track(radius) {
    $fn = 96;
    translate([-radius * 4, 0, -radius])
    scale([1, 1, 1.5])  union() {
        color("black") difference() {
            linear_extrude(radius * 1.5) offset(r = radius / 5) hull() {
                circle(1.5 * radius);
                translate([radius * 8, 0, 0]) circle(1.5 * radius);
            }

            translate([0, 0, -radius / 4]) linear_extrude(radius * 2) hull() {
                circle(1.25 * radius);
                translate([radius * 8, 0, 0]) circle(1.25 * radius);
            }
        }
        color("white") translate([0, 0, radius * 0.75]) scale([1, 1, 1.5]) wheels(radius);
    }
}

module eye(radius) {
    $fn = 96;
    translate([-radius / 15, 0, 0])
        rotate([0, 0, 90])
            arc(radius / 2, [0, 180], radius / 5);

    translate([0, radius / 3, 0]) circle(radius / 3);
}

module eyebrow(radius) {
    rotate([0, 0, 90])
        arc(radius / 1.25, [25, 155], radius / 10);
}


module body(radius) {
    $fn = 96;
    scale([1, 1, 0.9]) union() {
        color("yellow") sphere(radius * 4);
        color("Aqua") rotate([85, 0, 90]) intersection() {
            linear_extrude(radius * 4.5) sector(radius * 3.5, [0, 180]);
            difference() {
                sphere(radius * 4 + radius / 5);
                sphere(radius * 4);
            }
        }

        // eyes
        color("black") union() {
            rotate([0, 65, 16])
                linear_extrude(radius * 4.25)
                    eye(radius);

            rotate([0, 65, -16])
                linear_extrude(radius * 4.25)
                    eye(radius);
        }

        // eyebrows
        color("black") union() {
            rotate([0, 55, 20])
                linear_extrude(radius * 4.25)
                      eyebrow(radius);

            rotate([0, 55, -20])
                linear_extrude(radius * 4.25)
                    eyebrow(radius);
        }

    }
}

module arm(radius, d, h, glove_ang) {
    $fn = 96;
    //a1 = -45;
    //a2 = 100;
    //a3 = 55;
    d = d > 18*radius ? 18*radius : d;
    a2 = 180-asin((d/2)/(9*radius))*2;
    glove_h = 4.44*radius - ((glove_ang-15)/(4.2*radius))^2;  // estimate
    d_a = -asin((h+glove_h-4.85*radius)/d);
    end_a = a2/2 * 0.95;
    a1 = d_a - end_a;
    a3 = glove_ang - a1 - a2 + 90;
    union() {
        rotate([-90, 0, 0]) translate([0, 0, -radius])
            color("yellow") linear_extrude(radius * 2) circle(radius);
        rotate([0, a1, 0]) {
            translate([0, -radius * 0.5, -radius * 0.75])
                color("yellow") cube([radius * 9, radius, radius * 1.5]);
            translate([radius * 9, 0, 0]) {
                translate([-radius * 1.6111, 0, radius * 1.9445])
                if ($t < 0.9) {
                    rotate([0, 30, 0])
                        scale(0.8) small_caterpillar(radius);
                }
                else {
                    if ($t < 0.95) {
                        rotate([0, 30, 0])
                            scale(0.8) small_caterpillar(radius);
                        rotate([0, 30, 0])
                            scale(0.82)
                            color("white", ($t-0.90)/0.05)
                            small_caterpillar(radius);
                    }
                    else {
                        translate([1, 0, 1]*20*2*smoother_step(($t-0.95)/0.1))
                        rotate([0, 30, 0])
                            scale(0.82)
                            color("white", smoother_step((1-$t)/0.05))
                            small_caterpillar(radius);
                    }
                }
                rotate([-90, 0, 0]) translate([0, 0, -radius * 0.75])
                color("yellow") linear_extrude(radius * 1.5) circle(radius);
                rotate([0, a2, 0]) {
                    translate([0, -radius * 0.5, -radius * 0.519])
                        color("yellow") cube([radius * 9, radius, radius * 1]);
                    translate([radius * 9, 0, 0]) {
                        translate([-radius * 0.6547, 0, radius * -0.1592])
                        rotate([0, 180-a3, 180]) translate([radius * 2, 0, -radius * 0.815]) glove(radius);
                    }
                }
            }
        }
    }
}


module glove(radius) {
    $fn = 96;
    scale([0.8, 0.8, 1.2]) union() {
        color("white") union() {
            hull() {
                scale([1.1, 1, 0.5]) sphere(radius * 2.5);
                translate([-radius * 1.75, 0, radius / 1.5]) scale([1, 1.75, 0.8]) sphere(radius);
            }

            translate([-radius * 2.5, 0, radius / 1.5]) scale([1.2, 2, 1]) sphere(radius);


            rotate(-10) translate([0, -radius * 2.5, 0])  scale([1.75, 1, 0.8]) sphere(radius / 1.5);

        }
        color("black") intersection() {
            scale([1.1, 1, 0.55]) sphere(radius * 2.5);
            union() {
                translate([0, radius * 0.75, -radius * 2])
                    linear_extrude(radius)
                        square([radius * 2, radius / 4], center = true);
                translate([0, -radius * 0.75, -radius * 2])
                    linear_extrude(radius)
                        square([radius * 2, radius / 4], center = true);
            }
        }
    }
}

module big_caterpillar(radius, d, h, glove_a) {
    translate([0, 0, radius * 1.7]) {
        translate([0, -radius * 4, 0]) rotate([90, 0, 0]) track(radius);
        translate([0, 0, radius * 3]) body(radius);
        translate([0, radius * 4, 0]) rotate([90, 0, 0]) track(radius);

        translate([-radius * 0.35, -radius * 4.5, radius * 3.15])
            arm(radius, d, h, glove_a);
    }
}

module small_caterpillar(radius) {
    $fn = 96;
    color("LimeGreen") union() {
        translate([0, 0, -radius / 3]) sphere(radius);
        translate([radius * 1.5, 0, 0]) sphere(radius);
        translate([radius * 3, 0, radius]) sphere(radius);
        translate([radius * 4.25, 0, radius * 2]) sphere(radius);
    }

    color("white") translate([radius * 4.75, 0, radius * 3]) union() {
        translate([0, radius / 2, 0]) sphere(radius / 1.5);
        translate([0, -radius / 2, 0]) sphere(radius / 1.5);
    }

    color("black") translate([radius * 5.25, radius / 4, radius * 3]) union() {
        translate([0, radius / 2, 0]) sphere(radius / 3);
        translate([0, -radius / 2, 0]) sphere(radius / 3);
    }

    color("white") translate([radius * 5.4, radius / 2.75, radius * 3]) union() {
        translate([0, radius / 2, 0]) sphere(radius / 6);
        translate([0, -radius / 2, 0]) sphere(radius / 6);
    }
}

module caterpillars(radius, d, h, glove_a) {
    rotate([0, 0, 180]) big_caterpillar(radius, d, h, glove_a);
}

//caterpillars(radius, 60, 0, 15);

function strcat(sa, s="", i=0) = i>=len(sa) ? s : strcat(sa,str(s,sa[i]),i+1);
function smoother_step(x) = x<0 ? 0 : x>1 ? 1 : 6*x^5 - 15*x^4 + 10*x^3;

line1 = "1975-2022";
line2 = "JustinSDK";
line1c = $t >= 0.27 ? len(line1) : floor($t*len(line1)/0.27);
line2c = $t >= 0.87 ? len(line2) : floor(($t-0.6)*len(line2)/0.27);
xtrav = 150;
ytrav = 40;

if (line1c > 0) {
  color("Aqua")
    linear_extrude(height=0.2)
    text(strcat([for (i=[0:line1c-1]) line1[i]]), size=20);
}
if (line2c > 0) {
  color("Aqua")
    translate([0, -ytrav, 0])
    linear_extrude(height=0.2)
    text(strcat([for (i=[0:line2c-1]) line2[i]]), size=20);
}

if ($t < 0.3) {
  dig =(len(line1)*($t-0.27)/0.27)%1;
  echo($t, dig);
  translate([radius*10 + xtrav*$t/0.3, -radius*2.5, 0])
    caterpillars(radius, 60+7*sin(dig*360), 5*sqrt(max(cos(dig*360),0)),
                 15-15*sin(dig*360));
}
else if ($t < 0.6) {
  tf = ($t-0.3)/0.3;
  ss = smoother_step(tf);
  dx = 0.001;
  dy = smoother_step(tf+dx)-ss;
  da = atan2(dy*ytrav, dx*xtrav);
  translate([radius*10 + xtrav*(1-tf), -radius*2.5 - ytrav*ss, 0])
    rotate([0, 0, da])
    caterpillars(radius, 60, 5, 15);
}
else if ($t < 0.9) {
  dig=(len(line1)*($t-0.27)/0.27)%1;
  translate([radius*10 + xtrav*($t-0.6)/0.3, -radius*2.5-ytrav, 0])
    caterpillars(radius, 60+7*sin(dig*360), 5*sqrt(max(cos(dig*360),0)),
                 15-15*sin(dig*360));
}
else {
  translate([radius*10 + xtrav, -radius*2.5-ytrav, 0])
    caterpillars(radius, 60, 5, 15);
}

