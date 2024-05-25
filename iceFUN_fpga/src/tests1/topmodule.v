`include "setaddress.v" 
`include "ram_read_write.v" 


module topmodule(
    input wire clk = 0, // Reloj
    output reg [21:0] addr, // Pines de dirección de salida
    output reg [15:0] data, // Pines de data de salida
    output reg ce, // Chip Enable
    output reg ce2, // Chip Enable 2
    output reg oe, // Output Enable
    output reg we, // Write Enable
    output reg lb // Additional enable signal
);

// Dirección proporcionada desde otro módulo (inicializada con un valor específico)
reg [21:0] direccion_input = 22'b0000000000000000000001; // Por ejemplo, una dirección específica

// Variable para datos a escribir
reg [15:0] w_data = 16'h0005;

// Estado actual y próximo estado
    reg [1:0] state, next_state;

// Estados de la máquina de estados
    localparam IDLE       = 2'b00,
               WRITE      = 2'b01,
               WRITE_WAIT = 2'b10,
               READ       = 2'b11;

// Instancia del módulo setaddress 
setaddress uut (
    .clk(clk),
    .direccion_input(direccion_input),
    .addr(addr)
);

// Instancia del módulo memory
memory #(.INIT_FILE("data_init.txt")) memory_uut (
    .clk(clk),
    .we(we),
    .oe(oe),
    .ce(ce),
    .ce2(ce2),
    .lb(lb),
    .addr(direccion_input),
    .w_data(w_data), 
    .r_data(data) 
);


// Asignación de valores constantes a las señales de salida
always @(*) begin
    ce = 1'b0; // Asigna 0 a ce
    ce2 = 1'b1; // Asigna 1 a ce2
    lb = 1'b0; // Asigna 0 a lb
end

// Generar la señal de reloj
always begin
    #41.67 clk = ~clk; // Periodo del reloj 83.34 ns (frecuencia ~12 MHz)
end


always @(*) begin

        case (state)
            IDLE: begin
                // Esperar para escribir o leer
                next_state = WRITE; // O podríamos iniciar con la lectura
            end
            WRITE: begin
                // Escritura en memoria
                we = 0;
                oe = 1;
                next_state = WRITE_WAIT;
            end
            WRITE_WAIT: begin
                // Esperar ciclo de escritura completo
                we = 0;
                oe = 0;
                next_state = READ;
            end
            READ: begin
                // Leer desde la memoria
                we = 1;
                oe = 0;
                next_state = IDLE;
            end
        endcase
    end
    
    // Run simulation (output to .vcd file)
    //initial begin
    
        // Create simulation output file 
      //  $dumpfile("topmodule.vcd");          //iverilog -o topmodule.vvp topmodule.v  //vvp topmodule.vvp
        //$dumpvars(0, topmodule);
        
        // Wait for given amount of time for simulation to complete
        //#(DURATION)
        
        // Notify and end simulation
        //$display("Finished!");
        //$finish;
    //end
    

endmodule