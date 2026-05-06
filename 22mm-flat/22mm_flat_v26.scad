// Baby Boss v25
// Fix: mink_r matched to round_r so front edge rounds
// the same as rear interior corners
// Walls bumped to compensate: round_r + mink_r = 6mm per side

edge_depth=22; edge_width=115;
slot_height=25; wall_side=6; wall_tb=10;
body_depth=32;      // back wall = 32-22 = 10mm
round_r=3;
mink_r=3;           // MATCHED to round_r
tab_width=26; tab_height=18; tab_thickness=14;
tab_hole_dia=7; tab_round=3; tab_hole_chamfer=1;
$fn=60;

slot_width=edge_width-2*wall_side;
body_height=wall_tb+slot_height+wall_tb;

module body_profile(){
    r=round_r;
    offset(r=-r) offset(r=2*r) offset(r=-r)
    difference(){
        square([body_depth, body_height]);
        translate([-1, wall_tb])
            square([edge_depth+1, slot_height]);
    }
}
module solid_profile(){
    r=round_r;
    offset(r=-r) offset(r=2*r) offset(r=-r)
        square([body_depth, body_height]);
}
module main_body(){
    r=mink_r;
    translate([r, r, r])
    minkowski(){
        rotate([90, 0, 90])
            linear_extrude(height=edge_width - 2*r)
                offset(r=-r) body_profile();
        sphere(r=r);
    }
}
module side_caps(){
    r=mink_r;
    cap_w = wall_side + round_r + mink_r;
    translate([r, r, r])
    minkowski(){
        rotate([90, 0, 90])
            linear_extrude(height=cap_w)
                offset(r=-r) solid_profile();
        sphere(r=r);
    }
    translate([edge_width - cap_w - r, r, r])
    minkowski(){
        rotate([90, 0, 90])
            linear_extrude(height=cap_w)
                offset(r=-r) solid_profile();
        sphere(r=r);
    }
}
module d_ring_tab(){
    r=tab_round; tx=(edge_width-tab_width)/2;
    ty=mink_r; ol=0; e=0.01;
    translate([tx, ty, body_height-ol])
    difference(){
        hull(){
            for(x=[r, tab_width-r])
                for(y=[r, tab_thickness-r]) {
                    translate([x,y,0]) cylinder(r=r,h=0.1);
                    translate([x,y,tab_height+ol-r]) sphere(r=r);
                }
        }
        hz=(tab_height+ol)/2+1;
        translate([tab_width/2,-e,hz]) rotate([-90,0,0])
            cylinder(d=tab_hole_dia,h=tab_thickness+2*e);
        translate([tab_width/2,tab_thickness-tab_hole_chamfer,hz]) rotate([-90,0,0])
            cylinder(d1=tab_hole_dia,d2=tab_hole_dia+2*tab_hole_chamfer,h=tab_hole_chamfer+e);
    }
}
union(){ main_body(); side_caps(); d_ring_tab(); }
