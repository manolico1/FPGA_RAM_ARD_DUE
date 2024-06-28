/* module prueba (
    // Inputs
    input               clk,
    input               we,
    input               oe,
    input               ce,
    input               ce2,
    input               lb,
    input               fpga_enable,
    input       [21:0]  addr,
    
    // Outputs
    output  reg [15:0]  data
);

    // States
    localparam  STATE_WAIT  = 2'd0;
    localparam  STATE_READ  = 2'd1;
    localparam  STATE_SUM   = 2'd2;
    localparam  STATE_WRITE = 2'd3;

    reg [1:0] state;
    reg [15:0] temporal_data;

    // Declare memory 
    reg [15:0]  mem [0:2097151]; // 2^22 words, each word 16 bits

    // State transition logic
    always @ (posedge clk) begin
        if (fpga_enable == 1'b0) begin
            state <= STATE_WAIT;
        end else begin
            case (state)
                // Wait for fpga_enable to be enabled
                STATE_WAIT: begin
                    if (fpga_enable == 1'b1) begin
                        state <= STATE_READ;
                    end
                end
                
                // Read state logic
                STATE_READ: begin
                    if (we == 1'b1 && oe == 1'b0) begin
                        temporal_data <= mem[addr]; // Read memory
                        state <= STATE_SUM;
                    end
                end
                
                // Sum state logic
                STATE_SUM: begin
                    temporal_data <= temporal_data + 1; // Increment the read value
                    state <= STATE_WRITE;
                end
                
                // Write state logic
                STATE_WRITE: begin
                    if (we == 1'b0 && oe == 1'b1) begin
                        mem[addr] <= temporal_data; // Write back to memory
                        //data <= temp_data; // Output the written data
                        state <= STATE_WAIT; // Return to WAIT state
                    end
                end
                
                // Default state transition
                default: state <= STATE_WAIT;
            endcase
        end
    end

endmodule */ 



/*
module prueba (
    // Inputs
    input               clk,
    input               we,
    input               oe,
    input               ce,
    input               ce2,
    input               lb,
    input               fpga_enable,
    input       [21:0]  addr,
    
    // Bidirectional data bus
    inout  [15:0]  data
);
    parameter INIT_FILE = "mem_init.txt";

    // States
    localparam  STATE_WAIT  = 2'd0;
    localparam  STATE_READ  = 2'd1;
    localparam  STATE_SUM   = 2'd2;
    localparam  STATE_WRITE = 2'd3;

    reg [1:0] state;
    reg [15:0] temporal_data;
    reg [15:0] data_out;
    reg data_out_enable;

    // Declare memory 
    reg [15:0] mem [0:2097151]; // 2^21 words, each word 16 bits

    // Tri-state buffer control for data bus
    assign data = data_out_enable ? data_out : 16'bz;

    // State transition logic
    always @ (posedge clk) begin
        if (fpga_enable == 1'b0) begin
            state <= STATE_WAIT;
            data_out_enable <= 0;
        end else begin
            case (state)
                // Wait for fpga_enable to be enabled
                STATE_WAIT: begin
                    if (fpga_enable == 1'b1) begin
                        state <= STATE_READ;
                    end
                    data_out_enable <= 0;
                end
                
                // Read state logic
                STATE_READ: begin
                    if (we == 1'b1 && oe == 1'b0) begin
                        temporal_data <= mem[addr]; // Read memory
                        state <= STATE_SUM;
                    end
                end
                
                // Sum state logic
                STATE_SUM: begin
                    temporal_data <= temporal_data + 1; // Increment the read value
                    state <= STATE_WRITE;
                end
                
                // Write state logic
                STATE_WRITE: begin
                    if (we == 1'b0 && oe == 1'b1) begin
                        mem[addr] <= temporal_data; // Write back to memory
                        data_out_enable <= 1; // Enable data output
                        data_out <= temporal_data; // Output the written data
                        state <= STATE_WAIT; // Return to WAIT state after writing
                    end
                end
                
                // Default state transition
                default: state <= STATE_WAIT;
            endcase
        end
    end

    // Control data_out_enable to disable output after writing
    always @ (posedge clk) begin
        if (state != STATE_WRITE) begin
            data_out_enable <= 0;
        end
    end

    // Initialization (if available)
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end
    end

endmodule

*/


/*module prueba (
    // Inputs
    input               clk,
    input               we,
    input               oe,
    input               ce,
    input               ce2,
    input               lb,
    input               fpga_enable,
    input       [21:0]  addr,
    
    // Bidirectional data bus
    inout  [15:0]  data
);
    parameter INIT_FILE = "mem_init.txt";

    // States
    localparam  STATE_WAIT  = 2'd0;
    localparam  STATE_READ  = 2'd1;
    localparam  STATE_SUM   = 2'd2;
    localparam  STATE_WRITE = 2'd3;

    reg [1:0] state;
    reg [15:0] temporal_data;
    reg [15:0] data_out;
    reg data_out_enable;

    // Declare memory 
    reg [15:0] mem [0:255]; // 2^21 words, each word 16 bits

    // Tri-state buffer control for data bus
    assign data = data_out_enable ? data_out : 16'bz;

    // State transition logic
    always @ (posedge clk) begin
        if (fpga_enable == 1'b0) begin
            state <= STATE_WAIT;
        end else begin
            case (state)
                // Wait for fpga_enable to be enabled
                STATE_WAIT: begin
                    if (fpga_enable == 1'b1) begin
                        state <= STATE_READ;
                    end
                    data_out_enable <= 0; // Ensure data_out_enable is 0 in STATE_WAIT
                end
                
                // Read state logic
                STATE_READ: begin
                    if (we == 1'b1 && oe == 1'b0) begin
                        temporal_data <= mem[addr]; // Read memory
                        state <= STATE_SUM;
                    end
                end
                
                // Sum state logic
                STATE_SUM: begin
                    temporal_data <= temporal_data + 1; // Increment the read value
                    state <= STATE_WRITE;
                end
                
                // Write state logic
                STATE_WRITE: begin
                    if (we == 1'b0 && oe == 1'b1) begin
                        data_out_enable <= 1; // Enable data output
                        mem[addr] <= temporal_data; // Write back to memory
                        data_out <= temporal_data; // Output the written data
                        state <= STATE_WAIT; // Return to WAIT state after writing
                    end
                end
                
                // Default state transition
                default: state <= STATE_WAIT;
            endcase
        end
    end

    // Ensure data_out_enable is 0 when not in STATE_WRITE
    always @ (posedge clk) begin
        if (state != STATE_WRITE) begin
            data_out_enable <= 0;            
        end
    end


    // Initialization (if available)
    //initial begin
      //  if (INIT_FILE != "") begin
         //   $readmemh(INIT_FILE, mem);
       // end
    //end

endmodule */


module prueba (
    // Inputs
    input               clk,
    input               we,
    input               oe,
    input               ce,
    input               ce2,
    input               lb,
    input               fpga_enable,
    input       [21:0]  addr,
    
    // Bidirectional data bus
    inout  [15:0]  data
);
    parameter INIT_FILE = "mem_init.txt";

    // States
    localparam  STATE_WAIT  = 2'd0;
    localparam  STATE_READ  = 2'd1;
    localparam  STATE_SUM   = 2'd2;
    localparam  STATE_WRITE = 2'd3;

    reg [1:0] state;
    reg [15:0] temporal_data;
    reg [15:0] data_out;
    reg data_out_enable;

    // Declare memory 
    reg [15:0] mem [0:255]; // 2^21 words, each word 16 bits

    // Tri-state buffer control for data bus
    assign data = data_out_enable ? data_out : 16'bz;

    // State transition logic
    always @ (*) begin
        // Default state is STATE_WAIT
        state = STATE_WAIT;
        data_out_enable = 0;

        if (fpga_enable == 1'b1) begin
            case (state)
                STATE_WAIT: begin
                    if (fpga_enable == 1'b1) begin
                        state = STATE_READ;
                    end
                end
                
                STATE_READ: begin
                    if (we == 1'b1 && oe == 1'b0) begin
                        temporal_data = mem[addr]; // Read memory
                        state = STATE_SUM;
                    end
                end
                
                STATE_SUM: begin
                    temporal_data = temporal_data + 1; // Increment the read value
                    state = STATE_WRITE;
                end
                
                STATE_WRITE: begin
                    if (we == 1'b0 && oe == 1'b1) begin
                        data_out_enable = 1; // Enable data output
                        mem[addr] = temporal_data; // Write back to memory
                        data_out = temporal_data; // Output the written data
                        state = STATE_WAIT; // Return to WAIT state after writing
                    end
                end
            endcase
        end
    end

    // Ensure data_out_enable is 0 when not in STATE_WRITE
    always @ (*) begin
        if (state != STATE_WRITE) begin
            data_out_enable = 0;
        end
    end

    // Initialization (if available)
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end
    end
endmodule
