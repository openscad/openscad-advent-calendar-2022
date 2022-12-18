// John Conway's Game of Life
// Mathematical Games. Scientific American. Vol. 223, no. 4. pp. 120–123
// https://web.stanford.edu/class/sts145/Library/life.pdf
// https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
//
// OpenSCAD version
// Jordan Brown, openscad@jordan.maileater.net
//
// I hereby release this OpenSCAD program
// into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/
//
// The Game of Life is a cellular automaton.  Given
// a starting configuration, you follow the rules to
// determine what happens:  a living cell might die, or
// an empty cell might become alive.
//
// The rules are based on the neighbors of the cell in
// question, the eight cells (including diagonals) that
// touch it.  They are:
//
// 1)  A living cell with zero or one neighbors dies.
// 2)  A living cell with two or three neighbors survives.
// 3)  A living cell with four or more neighbors dies.
// 4)  An empty cell with three neighbors becomes alive.
//
// Those simple rules yield startlingly complex behaviors.
// The video that accompanies this program in the 2022
// OpenSCAD Advent Calendar demonstrates a couple of them:
//
// A block.  A two-by-two grid of cells is stable;
// the cells survive forever and no new cells are born.
//
// A blinker.  A one-by-three grid of cells will
// oscillate:  in a horizontal row, the outer two will
// die, the center will survive, and the cells above and
// below will be born.  You now have a vertical row of
// three, which then does the same thing, flipping back
// to being a horizontal row.
//
// A glider.  This pattern has the interesting characteristic
// that every four generations it moves one square
// down and to the right.
//
// The R pentomino.  Most small patterns stabilize quickly,
// but this one survives and grows for a very long time,
// stabilizing only after 1103 generations.
//
// The Gosper Glider Gun.  One of Conway's initial
// hypotheses was that no pattern could grow without
// limit.  Bill Gosper disproved that hypothesis with
// this pattern, which produces a glider every 30
// generations - so, on the average, it produces one
// new cell every five generations.
//
// These are just the start.  Glider guns are like lasers;
// they fire a beam off into the distance.  Glider
// streams can interact in interesting ways, and the net
// is that you can create logic gates using them.
// Yes, logic gates... so you can build computers.
// Here's a Life computer ... that plays Life:
// https://www.youtube.com/watch?v=xP5-iIeKXE8
// 
// For more information, see https://conwaylife.com/ .
//
// But... why would anybody do this in OpenSCAD?
// In the IRC chat, somebody was questioning whether
// OpenSCAD was a programming language, or was something
// less than that.  I opined that it was Turing complete.
// Now, I'm not a computer scientist and I couldn't
// tell you for sure what would make a language Turing
// complete, but I knew that Life was Turing complete,
// and I was pretty sure that I could write Life in
// OpenSCAD.
//
// About the program...
//
// Given one pattern, generating the successor pattern
// is actually pretty easy.  The meat is in the life()
// function, using the "simple" state transition table.
// There's a helper "neighbors" function that counts the
// neighbors of a given cell, and a "get" function that
// retrieves a cell with either a wall-of-death at the
// edges of the array, or with wrap-around edges.
//
// Unfortunately, each run of an OpenSCAD program can
// only yield one image, and so to generate the frames of
// the animations required that each run start at the
// base pattern, process N generations, and then
// generate the resulting OpenSCAD objects.  This
// means that the performance is quadratic:  generating
// N frames requires approximately N^2 processing.
// (Hmm.  But there's no reason it couldn't generate
// images of multiple generations in one run, translated
// across the world.  Next version.)
//
// Also unfortunately, there's no easy way to input an
// initial pattern through the customizer, so you're
// stuck with the patterns that I've included in this
// file.

// Are we animating?
animate = false;
// If animating, how many generations? Must match number of animation frames.
generations = 100;
// If not animating, what generation should we stop at?
runToGen = 1;
// What should happen at the edges?  Should they wrap, or should cells outside the edge be considered dead?
edges = 0;      // [ 0:wrap, 1:cliff ]
// Setting this to "transitions" shows intermediate states, with dying and birthing cells marked.
display = 0;    // [0:simple, 1:transitions]
// Size of one cell, in OpenSCAD units
cellSize = 20;
// Size of the world
worldSize = [5,5];
// Offset the specified pattern this far down and right from the top left corner of the world.
offset = [1,2];
patternName = "blinker";    // [ block, blinker, glider, rpentomino, gosperglidergun ]

module stop() {}

// Some sample Life patterns.
// Notes:
// * These are just the patterns.  They usually require
//   a larger world than this to actually thrive.
// * To add a pattern, you must add it here, and to the
//   list of patterns below, and to the customizer list
//   above.

block = [
    [ 1,1 ],
    [ 1,1 ],
];

blinker = [
    [ 1,1,1 ],
];

glider = [
    [ 0,1,0 ],
    [ 0,0,1 ],
    [ 1,1,1 ],
];

rpentomino = [
    [ 0,1,1 ],
    [ 1,1,0 ],
    [ 0,1,0 ],
];

gosperglidergun = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
];

patterns = [
    [ "block", block ],
    [ "blinker", blinker ],
    [ "glider", glider ],
    [ "rpentomino", rpentomino ],
    [ "gosperglidergun", gosperglidergun ]
];

// Given the name from the customizer, find the matching
// pattern.
patternNumber = search([patternName], patterns)[0];
pattern = patterns[patternNumber][1];

// How big should the circles be?
tokenSize = cellSize*0.95;

// What generation are we stopping at?  When animating,
// this is based on the animation clock and the total
// number of generations.
gen = animate ? round($t*generations) : runToGen;

// How thick should the border be around the world?
border = 5;

// OpenSCAD's modulo operator believes that -1%3 = -1.
// For wrapping, we need a modulo operator where -1%3 = 2.
function mod(a,b) = a - b*floor(a/b);

// We support two kinds of worlds:  one where cells outside
// the edges are dead, and one that wraps around.
// We pick one of two "get" functions based on the
// customizer selection.

// World with cliff around it.
getCliff = function (a, p)
    p.x < 0 ? 0
    : p.y < 0 ? 0
    : p.x >= len(a[0]) ? 0
    : p.y >= len(a) ? 0
    : a[p.y][p.x] ? 1 : 0;

// Wraparound world
getWrap = function (a, p)
    let (x = mod(p.x, len(a[0])))
    let (y = mod(p.y, len(a)))
    a[y][x] ? 1 : 0;

get = [getWrap, getCliff][edges];

// Count the number of neighbors around a particular cell.
function neighbors(a, p) =
    get(a, p+[-1,-1])
    + get(a, p+[0,-1])
    + get(a, p+[1,-1])
    + get(a, p+[-1,0])
    + get(a, p+[1,0])
    + get(a, p+[-1,1])
    + get(a, p+[0,1])
    + get(a, p+[1,1]);

// The straightforward Life state table.
// The first row is, for each number of neighbors, what
// happens to an empty cell.
// The second row is what happens to a living cell.
simple = [
    [ 0, 0, 0, 1, 0, 0, 0, 0, 0 ],  // dead
    [ 0, 0, 1, 1, 0, 0, 0, 0, 0 ],  // alive
];

// This is a more elaborate state machine, that
// transitions from a standard Life state to an
// intermediate state that distinguishes dying,
// surviving, and birthing cells.  That intermediate
// state then unconditionally transitions to the
// next Life state.
intermediate = [
    [ 5, 5, 5, 2, 5, 5, 5, 5, 5 ],  // dead
    [ 3, 3, 4, 4, 3, 3, 3, 3, 3 ],  // alive
    [ 1, 1, 1, 1, 1, 1, 1, 1, 1 ],  // born
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ],  // dying
    [ 1, 1, 1, 1, 1, 1, 1, 1, 1 ],  // surviving
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ],  // still dead
];

// Pick one of the two display modes.
transitions = [simple, intermediate][display];

// The actual state machine engine.
// Given a world, return the next generation.
function life(world) = [
    for (y=[0:len(world)-1]) [
        for (x=[0:len(world[0])-1])
            transitions[world[y][x]][neighbors(world, [x,y])]
    ]
];

// Run the Life algorithm repeatedly:  given a world,
// run it for N generations.
function generate(world, n) =
        assert(n>=0)
        n == 0 ? world
        : generate(life(world), n-1);

// The next few functions aren't actually used, but
// can be useful.  strline() generates a string representing
// a single row of a world, while strworld() generates a string representing the entire world.
// print() prints a world onto the console.

function strline(line, x=0, base="") =
    x >= len(line)
    ? base
    : strline(line, x+1, str(base, ".X"[line[x]]));
function strworld(world, y=0, base="\n") =
    y >= len(world)
    ? base
    : strworld(world, y+1, str(base, strline(world[y]), "\n"));
    
module print(world) {
    echo();
    echo(strworld(world));
}

// Given the state of a cell, generate the OpenSCAD
// object representing that state.
module piece(state) {
    // This is a trick to implement something like a
    // "switch" statement.  Given an index, generate
    // the child corresponding to that index.
    module p(state) {
        children(state);
    }
    p(state) {
        // Empty.
        group();
        // A basic live cell.
        circle(d=tokenSize);
        // The rest are for "intermediate" displays.
        // A birthing cell has a green "+" across it.
        union() {
            circle(d=tokenSize);
            color("lime") translate([0,0,1]) {
                square([tokenSize,tokenSize/5], center=true);
                rotate(90) square([tokenSize,tokenSize/5], center=true);
            }
        }
        // A dying cell has a gray "X" across it.
        union() {
            circle(d=tokenSize);
            color("gray") translate([0,0,1]) {
                rotate(45) square([tokenSize,tokenSize/5], center=true);
                rotate(-45) square([tokenSize,tokenSize/5], center=true);
            }
        }
        // A surviving cell looks like an ordinary cell.
        circle(d=tokenSize);
        // An empty cell looks like... an empty cell.
        group();
    }
}

// Given a world, draw it as OpenSCAD objects.
module draw(world) {
    translate([cellSize,cellSize]/2) {
        for (y=[0:worldSize.y-1]) {
            for (x=[0:worldSize.x-1]) {
                translate([x,worldSize.y-y-1]*cellSize) {
                    piece(world[y][x]);
                }
            }
        }
    }
}

// Given a pattern and an offset, build a world.
world = [
    // The rows above the pattern
    for (i = [1:1:offset.y])
        [ for (i=[1:1:worldSize.x]) 0 ],
    // The pattern
    for (line = pattern) [
        // The columns left of the pattern
        for (i = [1:1:offset.x]) 0,
        // The pattern
        for (v = line) v,
        // The columns right of the pattern
        for (i = [offset.x+len(line)+1:1:worldSize.x]) 0
    ],
    // The rows below the pattern
    for (i = [offset.y+len(pattern)+1:1:worldSize.y])
        [ for (i=[1:1:worldSize.x]) 0 ]
];

// Do it!
draw(generate(world, gen));

// Draw a border around the world.
color("black") render() difference() {
    id = worldSize * cellSize;
    od = id + 2*[border,border];
    translate(-[border,border]) square(od);
    square(id);
}

// Reset the camera to yield a top-down view of the world,
// that fills the display.
$vpr = [0,0,0];
$vpt = [ len(world)*cellSize/2, len(world[0])*cellSize/2, max(len(world),len(world[0]))*cellSize*1.5 ];
$vpd = max(len(world),len(world[0]))*cellSize*1.3;
