// Declaración del módulo y parámetros
module transmisor
		(
		RESET,
		TXD,
		TX_EN,
		TX_ER,
		GTX_CLK,
		tx_code_group
    	    );

`include "tabla_code-groups.v"	// Tabla de equivalencias para
				// los code groups y variables 
				// intermedias

// Declaración de entradas, salidas y sus roles
input wire
		RESET,
		TX_EN,
		TX_ER,
		GTX_CLK;
input wire [7:0] TXD;

output reg [9:0] tx_code_group;

// Declaración de variables internas
reg	xmit;
reg	assert_lpidle;
reg	TX_OSET_indicate;
reg	tx_disparity;	// Rnning disparity
			// TODO implementar RD de verdad
reg	tx_even;
reg [11:0] TX_OSET;	// Vairable interna para enviar los
			// símbolos a los estados que generan los
			// code groups
reg	PUDR;
reg	seg_CG_I;	// Para poder enviar el segundo
			// code group de idle y lpidle
reg	transmitting;	// Señal que se activa cuando PCS
			// está enviando códigos


// Declaración de vectores de estados
reg [16:0] estado_actual;	// Estados para el transmisor
reg [16:0] prox_estado;
reg [16:0] estado_retorno_cg_idle;

// Declaración de los nombres de los estados
localparam IDLE			=	17'b00000000000000001;
localparam XMIT_DATA		=	17'b00000000000000010;
localparam XMIT_LPIDLE		=	17'b00000000000000100;
localparam START_OF_PACKET	=	17'b00000000000001000;
localparam TX_DATA		=	17'b00000000000010000;
localparam TX_PACKET		=	17'b00000000000100000;
localparam EPD2_NOEXT		=	17'b00000000001000000;
localparam END_OF_PACKET_NOEXT	=	17'b00000000010000000;
localparam EPD3			=	17'b00000000100000000;
localparam GENERATE_CODE_GROUPS	=	17'b00000001000000000;
localparam SPECIAL_GO		=	17'b00000010000000000;
localparam DATA_GO		=	17'b00000100000000000;
localparam IDLE_DISPARITY_TEST	=	17'b00001000000000000;
localparam IDLE_DISPARITY_WRONG	=	17'b00010000000000000;
localparam IDLE_I1B		=	17'b00100000000000000;
localparam IDLE_DISPARITY_OK	=	17'b01000000000000000; // TODO opc
localparam IDLE_I2B		=	17'b10000000000000000; // TODO opc

// Definir todos los flip flops
// Se encarga de pasar del estado actual al estado siguiente
always @(posedge GTX_CLK) begin
	// La señal de reinicio funciona invertida, si RESET == 1,
	// el transmisor funciona bien, caso contrario pasa al estado
	// XMIT_DATA
	if (~RESET) begin
		estado_actual		=	IDLE;
		tx_even			=	0;
		xmit			=	0;
		assert_lpidle		=	0;
		TX_OSET_indicate	=	0;
		tx_disparity		=	0;
		tx_even			=	0;
		TX_OSET			=	'0;
		PUDR			=	0;
		seg_CG_I		=	0;
		tx_code_group		=	'0;
		transmitting		=	0;
	end else begin
		estado_actual  		<=	prox_estado;
		tx_disparity		<=	!tx_disparity;
	end
end

// Lógica combinacional que se encarga
// de la transición de estados
always @(*) begin
	case (estado_actual)

		// Estado: IDLE
		// Envía los caracteres K28.5 seguido de D5.6 y luego pasa
		// al estado XMIT_DATA
		IDLE:
		begin

			// Antes que nada, establece el punto de retorno para
			// enviar el segundo caracter del code-group IDLE
			estado_retorno_cg_idle		=	XMIT_DATA;

//			TX_OSET		=	I_CG;
			// Se verifica la disparidad
			if (tx_disparity) begin


				if (tx_even) begin
					tx_code_group	=	K28_5_RD_Plus_BC;
				end else begin
					tx_code_group	=	K28_5_RD_Minus_BC;
				end

				// Se activa la señal de indicate
				// luego de enviar un code-group

				// Pasa a enviar el segundo code group para idle
				prox_estado	=	IDLE_I1B;

			end else begin

				if (tx_even) begin
					tx_code_group	=	K28_5_RD_Plus_BC;
				end else begin
					tx_code_group	=	K28_5_RD_Minus_BC;
				end

				// Se activa la señal de indicate
				// luego de enviar un code-group

				// Pasa a enviar el segundo code group para idle
				prox_estado	=	IDLE_I2B;

			end

			// Se setea tx_even
			tx_even		=	1;
	
		end

		// Estado: XMIT_DATA
		// Este estado envía una señal de idle y después puede
		// regresar a sí mismo, pasar al inicio de una traba o
		// entrar en low power idle dependiendo de las entradas
		XMIT_DATA:
		begin

			// Con el retorno definido, se envía el la señal de
			// IDLE
			// Se verifica la disparidad, y todo sigue según el
			// diagrama ASM:
			// Verificación de disparidad -> Disparidad escogida
			// y envía K28.5 -> Envía D5.6 ó D26.4
			if (tx_disparity) begin
				if (tx_even) begin
					tx_code_group	=	K28_5_RD_Plus_BC;
				end else begin
					tx_code_group	=	K28_5_RD_Minus_BC;
				end

				// Se activa la señal de indicate
				// luego de enviar un code-group
				TX_OSET_indicate	=	1;

				// Pasa a enviar el segundo code group para idle
				prox_estado	=	IDLE_I1B;

			end else begin

				if (tx_even) begin
					tx_code_group	=	K28_5_RD_Plus_BC;
				end else begin
					tx_code_group	=	K28_5_RD_Minus_BC;
				end

				// Se activa la señal de indicate
				// luego de enviar un code-group
				TX_OSET_indicate	=	1;

				// Pasa a enviar el segundo code group para idle
				prox_estado	=	IDLE_I2B;

			end

			// Se setea tx_even
			tx_even		<=	1;


			// Empieza por detectar a cuál estado debe pasar
			// después de enviar el D5.6 ó D26.4 del IDLE normal
			if (TX_EN /*&& !TX_ER*/) begin
				// Si se va a realizar una transmisión
				estado_retorno_cg_idle	=	START_OF_PACKET;
			end /* else if (assert_lpidle && TX_OSET_indicate) begin
				// OPC, low power idle
		       		estado_retorno_cg_idle	=	XMIT_LPIDLE;
			end */ else begin
				// Si no ocurre nada diferente, se mantiene
				// enviando IDLE
		       		estado_retorno_cg_idle	=	XMIT_DATA;
//				TX_OSET			=	I_CG;
			end

		end

		// Estado: XMIT_LPIDLE
//		XMIT_LPIDLE:
//		begin
//			TX_OSET = I_CG;
//			if(!assert_lpidle && TX_OSET_indicate) begin
//				prox_estado = XMIT_LPIDLE;

//			end if (assert_lpidle && TX_OSET_indicate) begin
//				TX_OSET = I_CG;
//				prox_estado = XMIT_DATA;
//			end

//		end

		// Estado: START_OF_PACKET
		START_OF_PACKET:
		begin
	                //completar este estado
			transmitting	=	1;
			// COL		=	Nada;	// Señal de colisión no especificada
							// para transmisión full duplex
			// Se evnía el caracter /S/
//			TX_OSET = S_CG;

			if (tx_disparity) begin
				tx_code_group	=	K27_7_RD_Plus_FB;
			end else begin
				tx_code_group	=	K27_7_RD_Minus_FB;
			end

			// Luego de enviar el /S/, se pasa a TX_PACKET
			prox_estado	=	TX_PACKET;

			// Se alterna tx_even
			tx_even		=	!tx_even;

			// Se envía la indicación PUDR
			PUDR		=	1;

		end

		// Estado: TX_DATA
		// TODO si sirve a como está, probablemente se puede 
		// se pueda eliminar este estado también :)
		//este es el estado que se encicla con TX_PACKET
//		TX_DATA:
//		begin
//              COL = recieving; //revisar acá también
//              TX_OSET = V_CG;

//			if(TX_OSET_indicate) begin
//			       prox_estado = TX_PACKET;	
//			end
//		end

		// Estado: TX_PACKET
		// Este estado se  encarga de enviar los code-groups
		// que corresponden a los octetos recibidos a través
		// de TXD
		TX_PACKET:
		begin
			// Toma el octeto a codificar de la entrada TXD
//			TX_OSET = TXD;

			// Se asume que una vez se activa TX_EN,
			// se envía el octeto por TXD
			// Mientras se mantenga TX_EN activado, se
			// codificará y enviará lo que se reciba
			// a través de TXD
			case (TXD)
				'hF0:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D16_7_RD_Plus_F0;
					end else begin
						tx_code_group	=	D16_7_RD_Minus_F0;
					end
				end

				'hF1:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D17_7_RD_Plus_F1;
					end else begin
						tx_code_group	=	D17_7_RD_Minus_F1;
					end
				end
				'hF2:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D18_7_RD_Plus_F2;
					end else begin
						tx_code_group	=	D18_7_RD_Minus_F2;
					end
				end
				'hF3:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D19_7_RD_Plus_F3;
					end else begin
						tx_code_group	=	D19_7_RD_Minus_F3;
					end
				end
				'hF4:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D20_7_RD_Plus_F4;
					end else begin
						tx_code_group	=	D20_7_RD_Minus_F4;
					end
				end
				'hF5:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D21_7_RD_Plus_F5;
					end else begin
						tx_code_group	=	D21_7_RD_Minus_F5;
					end
				end
				'hF6:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D22_7_RD_Plus_F6;
					end else begin
						tx_code_group	=	D22_7_RD_Minus_F6;
					end
				end
				'hF7:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D23_7_RD_Plus_F7;
					end else begin
						tx_code_group	=	D23_7_RD_Minus_F7;
					end
				end
				'hF8:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D24_7_RD_Plus_F8;
					end else begin
						tx_code_group	=	D24_7_RD_Minus_F8;
					end
				end
				'hF9:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D25_7_RD_Plus_F9;
					end else begin
						tx_code_group	=	D25_7_RD_Minus_F9;
					end
				end
				'hFA:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D26_7_RD_Plus_FA;
					end else begin
						tx_code_group	=	D26_7_RD_Minus_FA;
					end
				end
				'hFB:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D27_7_RD_Plus_FB;
					end else begin
						tx_code_group	=	D27_7_RD_Minus_FB;
					end
				end
				'hFC:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D28_7_RD_Plus_FC;
					end else begin
						tx_code_group	=	D28_7_RD_Minus_FC;
					end
				end
				'hFD:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D29_7_RD_Plus_FD;
					end else begin
						tx_code_group	=	D29_7_RD_Minus_FD;
					end
				end
				'hFE:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D30_7_RD_Plus_FE;
					end else begin
						tx_code_group	=	D30_7_RD_Minus_FE;
					end
				end
				'hFF:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D31_7_RD_Plus_FF;
					end else begin
						tx_code_group	=	D31_7_RD_Minus_FF;
					end
				end
				'hEF:
				begin
					if (tx_disparity) begin
						tx_code_group	=	D15_7_RD_Plus_EF;
					end else begin
						tx_code_group	=	D15_7_RD_Minus_EF;
					end
				end

			endcase

			// Se alterna tx_even
			tx_even		=	!tx_even;

			// Se envía la indicación PUDR
			PUDR		=	1;

			// Después de enviar un código, se decide si se envía
			// el siguiente o si se pasa a terminar la trama
			if (TX_EN)  begin
				prox_estado	=	TX_PACKET;
			end else if (!TX_ER && !TX_EN)  begin
				prox_estado	=	END_OF_PACKET_NOEXT;
			end


		end

		// Estado: EPD2_NOEXT
		EPD2_NOEXT:
		begin
			transmitting = 0;
//			TX_OSET = R_CG;
			// Caracter /R/
			if (tx_disparity) begin
				tx_code_group	=	K23_7_RD_Plus_F7;
			end else begin
				tx_code_group	=	K23_7_RD_Minus_F7;
			end

			// Se alterna tx_even
			tx_even		=	!tx_even;

			// Se envía la indicación PUDR
			PUDR		=	1;
		
			if(!tx_even && TX_OSET_indicate) begin
			       prox_estado	=	XMIT_DATA;	
			end else begin
				prox_estado	=	EPD3;
			end
		end

		// Estado: END_OF_PACKET_NOEXT
		END_OF_PACKET_NOEXT:
		begin

			if(!tx_even) begin
			       transmitting = 0;
			end

//			COL <= 0;	// Señal no especificada
//			TX_OSET = T_CG;
			// Caracter /T/
			if (tx_disparity) begin
				tx_code_group	=	K29_7_RD_Plus_FD;
			end else begin
				tx_code_group	=	K29_7_RD_Minus_FD;
			end

			// Se alterna tx_even
			tx_even		=	!tx_even;

			// Se envía la indicación PUDR
			PUDR		=	1;

			/// Se sigue con la terminación de la trama
			prox_estado	=	EPD2_NOEXT;


		end

		// Estado: EPD3
		EPD3:
		begin
//			TX_OSET = R_CG;
			// Caracter /R/
			if (tx_disparity) begin
				tx_code_group	=	K23_7_RD_Plus_F7;
			end else begin
				tx_code_group	=	K23_7_RD_Minus_F7;
			end

			// Se alterna tx_even
			tx_even		=	!tx_even;

			// Se envía la indicación PUDR
			PUDR		=	1;
			
			if(TX_OSET_indicate) begin
			       prox_estado = XMIT_DATA;	
			end
		end


		//buscar documentación de esto para completar
		// Estado: GENERATE_CODE_GROUPS
//		GENERATE_CODE_GROUPS:
//		begin

//		end

		// Estado: SPECIAL_GO
//		SPECIAL_GO:
//		begin

//		end

		// Estado: DATA_GO
//		DATA_GO:
//		begin

//		end

		// Estado: IDLE_DISPARITY_TEST
		// TODO Eliminar este estado

		// Estado: IDLE_DISPARITY_WRONG
		// TODO Eliminar este estado

		// Estado: IDLE_I1B
		// Envía el segundo code group de idle
		IDLE_I1B:
		begin

			if (assert_lpidle) begin	// TODO Poner TX_OSET = LPIDLE
				tx_code_group	=	D5_6_RD_Plus_C5;
			end else begin
				tx_code_group	=	D6_5_RD_Plus_A6;
			end

			tx_even			=	0;
			TX_OSET_indicate	=	1;

			// Luego de enviar el IDLE completo, se sigue con el
			// estado de retorno
			prox_estado	=	estado_retorno_cg_idle;

			// Se setea tx_even
			tx_even		=	0;

			// Se envía la indicación PUDR
			PUDR		=	1;

		end

		// Estado: IDLE_DISPARITY_OK
		// TODO Eliminar este estado

		// Estado: IDLE_I2B
		IDLE_I2B:
		begin

			if (assert_lpidle) begin	// TODO Poner TX_OSET = LPIDLE
				tx_code_group	=	D26_4_RD_Plus_9A;
			end else begin
				tx_code_group	=	D16_2_RD_Plus_50;
			end

			tx_even			=	0;
			TX_OSET_indicate	=	1;
			// TODO poner la señal PUDR

			// Luego de enviar el IDLE completo, se sigue con el
			// estado de retorno
			prox_estado	=	estado_retorno_cg_idle;

			// Se setea tx_even
			tx_even		=	0;

			// Se envía la indicación PUDR
			PUDR		=	1;

		end


	endcase
end

endmodule
