//////////////////////////////////////////////////////////////////////////////////////////////////////
// Testbench for memory: Example 1                                                                  //
//                                                                                                  //
// First, read from address in memory (should be garbage or unknown). Next,                         //
// write to that location and read from it again. Output should match input.                        //
//                                                                                                  //
// Based on: https://github.com/ShawnHymel/introduction-to-fpga/tree/main/08-memory                 //
//                                                                                                  //
// Manuel Jiménez Martínez - University of Málaga                                                    //                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////

`include "ram_read_write.v" 

// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module memory_tb();

    // Internal signals
    wire    [15:0]  r_data;
    

    // Storage elements (set initial values to 0)
    reg             clk = 0;
    reg             w_en = 0;
    reg             r_en = 0;
    reg     [21:0]   w_addr;
    reg     [21:0]   r_addr;
    reg     [15:0]   w_data;

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;
    
    // Generate clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 MHz
    always begin
        #41.67
        clk = ~clk;
    end
    
    // Instantiate the unit under test (UUT)
    memory uut (
        .clk(clk),
        .w_en(w_en),
        .r_en(r_en),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .w_data(w_data),
        .r_data(r_data)
    );
    
    // Run test:
    initial begin
    
        // Test 1: read from address 0x10 (should be garbage)
        #(2 * 41.67)
        r_addr = 'h0f;
        r_en = 1;
        #(2 * 41.67)
        r_addr = 0;
        r_en = 0;
        
        // Test 2: Write to address 0x0f and read it back
        #(2 * 41.67)
        w_addr = 'h0f;
        w_data = 'hA5;
        w_en = 1;
        #(2 * 41.67)
        w_addr = 0;
        w_data = 0;
        w_en = 0;
        r_addr = 'h0f;
        r_en = 1;
        #(2 * 41.67)
        r_addr = 0;
        r_en = 0;
    end
    
    // Run simulation (output to .vcd file)
    initial begin
    
        // Create simulation output file 
        $dumpfile("memory_tb.vcd");
        $dumpvars(0, memory_tb);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule