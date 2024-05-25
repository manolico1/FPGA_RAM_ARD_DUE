module setaddress(
    input wire clk, // Reloj
    input wire [21:0] direccion_input, // Dirección proporcionada desde otro módulo
    output reg [21:0] addr // Pines de dirección de salida
);

// Proceso activo en el flanco de subida del reloj
always @(posedge clk) begin
    // Asigna la dirección proporcionada a addr
    addr <= direccion_input;
end

endmodule