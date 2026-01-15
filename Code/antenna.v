`timescale 1ns/1ps

//============================================================
// Antenna abstraction module
//============================================================
module antenna (
    input  in,                 // Antenna excitation input
    output out                 // Aggregated antenna response
);

// Number of replicated conductive segments
localparam antenna_loop = 1000;

// Internal signal paths (preserved during synthesis)
(*dont_touch="yes"*) wire stem_start, stem_end;
(*dont_touch="yes"*) wire [antenna_loop-1:0] lines1, lines2, lines3, lines4;

// Feed point
(*dont_touch="yes"*) assign stem_start = in;

// Signal replication along antenna loop
(*dont_touch="yes"*) assign lines1 = {antenna_loop{stem_start}};
(*dont_touch="yes"*) assign lines2 = lines1;
(*dont_touch="yes"*) assign lines3 = lines2;
(*dont_touch="yes"*) assign lines4 = lines3;

// Aggregate loop response
(*dont_touch="yes"*) assign stem_end = |lines4;

// Output
(*dont_touch="yes"*) assign out = stem_end;

endmodule
