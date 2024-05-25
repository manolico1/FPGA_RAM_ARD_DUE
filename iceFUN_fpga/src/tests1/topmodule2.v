`include "ram_read_write.v"

// Defines timescale for simulation: <time_unit> / <time_precision>
`timescale 1 ns / 10 ps

// Define our testbench
module memory_tb();

    // Internal signals
    wire    [15:0]  r_data;
    
    // Storage elements (set initial values to 0)
    reg             clk = 0;
    reg             we = 0;
    reg             oe = 0;
    reg             ce = 1;
    reg             ce2 = 0;
    reg             lb = 1;
    reg     [21:0]  addr = 0;
    reg     [15:0]  w_data = 0;
    integer         i;

    // Simulation time: 100000 * 1 ns = 100 us
    localparam DURATION = 100000;
    
    // Generate clock signal: 1 / ((2 * 41.67) * 1 ns) = 11,999,040.08 MHz
    always begin
        #41.67
        clk = ~clk;
    end
    
    // Instantiate the unit under test (UUT)
    memory #(.INIT_FILE("data_init.txt")) uut (
        .clk(clk),
        .we(we),
        .oe(oe),
        .ce(ce),
        .ce2(ce2),
        .lb(lb),
        .addr(addr),
        .w_data(w_data),
        .r_data(r_data)
    );
    
    // Run test: write to location and read value back
    initial begin
        // Enable chip
        ce = 0;
        ce2 = 1;
        lb = 0;

        // Test 1: read initial values
        for (i = 0; i < 256; i = i + 1) begin
            #(2 * 41.67);
            addr = i;
            we = 1;
            oe = 0;
            #(2 * 41.67);
            addr = 0;
            oe = 0;
        end
        
        // Test 2: Write to address 0x0f and read it back
        #(2 * 41.67);
        addr = 'h0f;
        w_data = 'hA5A5;
        we = 0;
        oe = 1;
        #(2 * 41.67);
        addr = 'h0f;
        we = 1;
        
        oe = 0;
        #(2 * 41.67);
        
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
