one_inch = 25.4; // for converting inches to mm

// parameters of the corner bearing
bearing_diameter = one_inch * .4; 

// parameters of the dowel holder
d_holder_outer = .75 * one_inch;
d_holder_hole = .5 * one_inch;
d_holder_length = one_inch * 2; 

// parameter of the shelf plane holder
plane_thickness = one_inch *.1;
plane_gap = one_inch * .25;

// screw hole size for all stabilizer scres
screw_hole_diameter = one_inch * .1;

// derived parameters
translation = d_holder_length/2;
vertical_translation=d_holder_outer/2;
subtract_cube_size = bearing_diameter * 2;

// plane_clamp();
corner_assembly_trimmed();


module plane_clamp(ratio) {
	bottom_plane_x = d_holder_length * ratio ;
	bottom_plane_y = d_holder_length * ratio ;

	top_plane_x = bottom_plane_x - d_holder_outer/2;
	top_plane_x_translation = d_holder_outer/2;
	top_plane_y = bottom_plane_y - d_holder_outer/2;
	top_plane_y_translation = d_holder_outer/2;

	difference () {
		translate([0,0,0])
			cube([bottom_plane_x,bottom_plane_y,plane_thickness]);
	}

	vertical_translation = plane_thickness + plane_gap;

	difference () {
		translate([top_plane_x_translation,top_plane_x_translation,vertical_translation])
			cube([top_plane_x,top_plane_y,plane_thickness]);
		//cylinder([plane_thickness * 1.5,
	}
} 

module corner_assembly_trimmed() {
	difference() {
		translate([0,0,vertical_translation])
			corner_assembly();
		translate([-subtract_cube_size/2,-subtract_cube_size/2,-subtract_cube_size])
			cube([subtract_cube_size,subtract_cube_size,subtract_cube_size]);
	}
	plane_clamp(.75);
}
	
module corner_assembly() {
	translate([0,0,translation])
	rotate([0,0,-45]) 
		cylinder_w_hole(d_holder_length,d_holder_outer,d_holder_hole); //z-axis cylinder
	translate([0,translation,0])
	mirror([0,1,0])
	rotate([90,90,0])
		cylinder_w_hole(d_holder_length,d_holder_outer,d_holder_hole); //y-axis cylinder
	translate([translation,0,0])
	rotate([0,90,0])
		cylinder_w_hole(d_holder_length,d_holder_outer,d_holder_hole); //x-axis cylinder
	sphere(bearing_diameter,$fn=20,center =true);
}
	
module cylinder_w_hole(height, outer_diameter, hole_diameter) {
	difference() {
		cylinder(h = height,d1 = outer_diameter, d2 = outer_diameter , center = true, $fn = 20);
		cylinder(h = height*1.5, d1 = hole_diameter, d2 = hole_diameter, center = true, $fn = 20);
		rotate([90,0,0])
		translate([0,height/3,hole_diameter/2])
			cylinder(h = outer_diameter - hole_diameter, d1 = screw_hole_diameter, d2 = screw_hole_diameter, center = true, $fn =20);
	}
}

