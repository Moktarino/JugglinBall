//$fn=64;

$fa = 1;
$fs = 0.25;
 
inner_radius = 28;
wall_thickness = 6;
cyl1_radius = 5.5;
cyl1_depth = 1;
cyl2_depth = 1.5;
cyl2_radius = 3;
dome_recess = 0.5;
dome_squash = 0.75;
dome_shrink = 0.2;
tilt = 22.5;
strut_width = 5;
strut_depth = 4;
peg_height = 5;
peg_width = 2;
peg_slop = 0.2;


cyl1_height = inner_radius*2 + cyl1_depth*2;
cyl2_height = cyl1_height + cyl2_depth*2;
dome_depth = inner_radius + cyl2_depth*2;
outer_radius = inner_radius + wall_thickness;
cut_cube_size = outer_radius*2;

translate([ 0, 0, wall_thickness + inner_radius])
difference(){
    // Inner and outer spheres
    sphere(outer_radius);
    sphere(inner_radius);
    
    // Slice off the top half
    translate([ 0, 0, outer_radius/2]) 
    linear_extrude(height = outer_radius, center = true) 
    square(size = [cut_cube_size, cut_cube_size], center = true);
    
    // Add the LED sockets, tilted so that only 2 LEDs are on the rim itself
    rotate( tilt, [0,1,0])
    for (j = [ 0 : 3], i = [0 : 3] )  {
        rotate (j * 45, [0, 0, 1])
        rotate (i * 45, [1, 0, 0]) 
        // LED sockets, outer diameter for PCB
        linear_extrude(height = cyl1_height, center = true) circle(cyl1_radius);
        rotate (j * 45, [0, 0, 1])
        rotate (i * 45, [1, 0, 0]) 
        // LED sockets, to accommodate the actual LED
        linear_extrude(height = cyl2_height, center = true) circle(cyl2_radius);
        rotate  (j * 45, [0, 0, 1])
        rotate  (i * 45, [1, 0, 0]) 
        // Add little half-domes at the bottoms of the LED sockets for flair
        group(){
            rotate (i * 45, [ 1, 0, 0])
            translate([0, 0, dome_depth - dome_recess])
            scale([1.0, 1.0, dome_squash])
            sphere(cyl2_radius - dome_shrink);
            rotate (i * 45 + 45, [1, 0, 0])
            translate([0, 0, dome_recess - dome_depth])
            scale([1.0, 1.0, dome_squash])
            sphere(cyl2_radius - dome_shrink);
        }
    };
    
    // Add the recesses for the sensor carriage
    for (i = [ 22.5, 112.5 ])
    rotate ( 90, [1, 0, 0])
    rotate ( i, [0, 1, 0])
    linear_extrude(height = inner_radius*2 + strut_depth*2, center = true) 
    square(size = [strut_width, strut_width], center = true);
    
    // Add the negative peg
    rotate ( 90, [0, 0, 1])
    translate([0, dome_depth, -peg_height + peg_slop])
    linear_extrude(height = peg_height + peg_slop, center = false) 
    circle(peg_width + peg_slop);
};

// Add the positive peg
rotate (270, [0, 0, 1])
translate([0, dome_depth, outer_radius - peg_slop])
linear_extrude(height = peg_height, center = false) 
circle(peg_width);
    
