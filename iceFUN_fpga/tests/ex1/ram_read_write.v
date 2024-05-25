//////////////////////////////////////////////////////////////////////////////////////////////////////
// Simple block RAM example 1                                                                       //
//                                                                                                  //
// Inputs:                                                                                          //
//      clk             - Input clock                                                               //
//      w_en            - Write enable                                                              //
//      r_en            - Read enable                                                               //
//      w_addr[21:0]     - Write address                                                            //
//      r_addr[21:0]     - Read address                                                             //
//      w_data[15:0]     - Data to be written                                                       //
//                                                                                                  //
// Outputs:                                                                                         //
//      r_data[15:0]     - Data to be read                                                          //
//                                                                                                  //
// Based on: https://github.com/ShawnHymel/introduction-to-fpga/tree/main/08-memory                 //
//                                                                                                  //
// Manuel Jiménez Martínez - University of Málaga                                                    //                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////
 

// Inferred block RAM
module memory (

    // Inputs
    input               clk,
    input               w_en,
    input               r_en,
    input       [21:0]   w_addr,
    input       [21:0]   r_addr,
    input       [15:0]   w_data,
    
    // Outputs
    output  reg [15:0]   r_data
);

    // Declare memory
    reg [15:0]  mem [0:2097151]; // 2^22 words, each word 16 bits
    
    // Interact with the memory block
    always @ (posedge clk) begin
    
        // Write to memory
        if (w_en == 1'b1) begin
            mem[w_addr] <= w_data;
        end
        
        // Read from memory
        if (r_en == 1'b1) begin
            r_data <= mem[r_addr];
        end
    end
    
endmodule