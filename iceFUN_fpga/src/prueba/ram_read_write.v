module ram_read_write (
    // Inputs
    input               clk,
    input               we,
    input               oe,
    input               ce,
    input               ce2,
    input               lb,
    input       [21:0]  addr,
    
    
    // Outputs
    output  reg [15:0]  data
);

    // Declare memory (not used in this test module)
    reg [15:0]  mem [0:2097151]; // 2^22 words, each word 16 bits
    
    // No operations performed in this test module
    always @ (posedge clk) begin
        // Do nothing
    end

endmodule
