//////////////////////////////////////////////////////////////////////////////////////////////////////
// Simple block RAM example 3                                                                       //
//                                                                                                  //
// Inputs:                                                                                          //
//      clk             - Input clock                                                               //
//      w_en            - Write enable                                                              //
//      r_en            - Read enable                                                               //
//      ce              - Chip enable 1                                                             //
//      ce2             - Chip enable 2                                                             //
//      lb              - Additional enable signal                                                  //
//      w_addr[21:0]    - Write address                                                             //
//      r_addr[21:0]    - Read address                                                              //
//      w_data[15:0]    - Data to be written                                                        //
//                                                                                                  //
// Outputs:                                                                                         //
//      r_data[15:0]    - Data to be read                                                           //
//                                                                                                  //
// Based on: https://github.com/ShawnHymel/introduction-to-fpga/tree/main/08-memory                 //
//                                                                                                  //
// Manuel Jiménez Martínez - University of Málaga                                                    //                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////

// Inferred block RAM
module memory #(

    // Parameters
    parameter   INIT_FILE = ""
) (

    // Inputs
    input               clk,
    input               w_en,
    input               r_en,
    input               ce,
    input               ce2,
    input               lb,
    input       [21:0]  w_addr,
    input       [21:0]  r_addr,
    input       [15:0]  w_data,
    
    // Outputs
    output  reg [15:0]  r_data
);

    // Declare memory
    reg [15:0]  mem [0:2097151]; // 2^22 words, each word 16 bits
    
    // Interact with the memory block
    always @ (posedge clk) begin
    
        // Check chip enable conditions
        if (!(ce == 1'b0 && ce2 == 1'b1 && lb == 1'b0)) begin
            // Write to memory
            if (w_en == 1'b1) begin
                mem[w_addr] <= w_data;
            end
            
            // Read from memory
            if (r_en == 1'b1) begin
                r_data <= mem[r_addr];
            end
        end
    end
    
    // Initialization (if available)
    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end
    
endmodule
