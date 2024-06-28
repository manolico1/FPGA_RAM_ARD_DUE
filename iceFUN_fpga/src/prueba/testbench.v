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

`include "prueba.v" 

// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module testbench;
    // Inputs
    reg clk;
    reg we;
    reg oe;
    reg ce;
    reg ce2;
    reg lb;
    reg fpga_enable;
    reg [21:0] addr;

    // Bidirectional data bus
    wire [15:0] data;


    // Instantiate the module
    prueba uut (
        .clk(clk),
        .we(we),
        .oe(oe),
        .ce(ce),
        .ce2(ce2),
        .lb(lb),
        .fpga_enable(fpga_enable),
        .addr(addr),
        .data(data)
    );

    
    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000000;
    
    // Generate clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 MHz
    always begin
        #41.67 clk = ~clk;
    end
    
    // Run test:
    initial begin    
        // Initialize inputs
        clk = 0;
        we = 0;
        oe = 0;
        ce = 0;
        ce2 = 0;
        lb = 0;
        fpga_enable = 0;
        addr = 0;
    
        #(2 * 41.67);

        // STATE_READ
        fpga_enable = 1;
        addr = 3;
        #(2 * 41.67);

        // Read initial data from address 0 (should be 0 from mem_init.txt)
        
        we=1;
        oe = 0;

        // STATE_SUM
        #83.34; // wait for 2 clock cycles
        
        //STATE_WRITE
        we = 0;
        oe=1;
        
        #83.34; // wait for 2 clock cycles
        #83.34;

        fpga_enable = 0;

        #83.34;
        #83.34;
        #83.34;
        #83.34;
        
        $finish;
    end

    // Run simulation (output to .vcd file)
    initial begin
        // Create simulation output file 
        $dumpfile("memory_tb.vcd");
        $dumpvars(0, testbench);
        
        // Wait for given amount of time for simulation to complete
        #(DURATION)
        
        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
    
endmodule
