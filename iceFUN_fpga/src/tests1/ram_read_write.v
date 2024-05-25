module memory #(
    // Parameters
    parameter   INIT_FILE = ""
) (
    // Inputs
    input               clk,
    input               we,
    input               oe,
    input               ce,
    input               ce2,
    input               lb,
    input       [21:0]  addr,
    input       [15:0]  w_data,
    
    // Outputs
    output  reg [15:0]  r_data
);

    // Declare memory
    reg [15:0]  mem [0:2097151]; // 2^22 words, each word 16 bits
    
    // Interact with the memory block
    always @ (posedge clk) begin
        // Check chip enable conditions
        if (ce == 1'b0 && ce2 == 1'b1 && lb == 1'b0) begin
            // Write to memory
            if (we == 1'b0 && oe == 1'b1) begin
                mem[addr] <= w_data;
            end
            
            // Read from memory
            if (we == 1'b1 && oe == 1'b0) begin
                r_data <= mem[addr];
            end
        end
    end
    
    // Initialization (if available)
    initial if (INIT_FILE != "") begin
        $readmemh(INIT_FILE, mem);
    end
    
endmodule
