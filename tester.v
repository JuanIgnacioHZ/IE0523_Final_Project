// Actual test code for the adder module
module tester
		(
		RESET,
		TXD,
		TX_EN,
		TX_ER,
		GTX_CLK,
		tx_code_group
			);

//`include "tabla_code-groups.v"	// Tabla de equivalencias para
				// los code groups y variables 
				// intermedias

// Declaración de entradas, salidas y sus roles
input wire [9:0] tx_code_group;

output reg
		RESET,
		TX_EN,
		TX_ER,
		GTX_CLK;
output reg [7:0] TXD;


// Half frecuency declaration for clock creating
parameter h_freq=10;

// Main clock signal
always begin
	#h_freq GTX_CLK = !GTX_CLK;
end

// Testing code begins here
initial begin
	// Acá inicia el setup
	#0	RESET	=	0;
		TX_EN	=	0;
		TX_ER	=	0;
		GTX_CLK	=	0;
		TXD	=	0;

	#30	RESET	=	1;
	#130	TX_EN	=	1;
		TX_ER	=	0;
		TXD	=	'hF0;
	// Acá termina el setup
	// Acá empiezan las pruebas
	
	#110	TXD	=	'hF1;	// Prueba
	#40	TXD	=	'hF2;	// Prueba
	#40	TXD	=	'hF3;	// Prueba
	#40	TXD	=	'hF4;	// Prueba
	#40	TXD	=	'hFD;	// Prueba
	#40	TXD	=	'hFE;	// Prueba

	// Acá terminan las pruebas

	#200	TX_EN	=	0;
		TXD	=	'h0;

	// Final de la simulación
	#200	$finish;
end


endmodule

