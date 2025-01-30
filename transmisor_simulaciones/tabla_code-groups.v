// Se definen los Code-Goups Especiales en RD (-)
parameter [9:0] K28_0_RD_Minus_1C = 10'b0011110100;
parameter [9:0] K28_1_RD_Minus_3C = 10'b0011111001;
parameter [9:0] K28_2_RD_Minus_5C = 10'b0011110101;
parameter [9:0] K28_3_RD_Minus_7C = 10'b0011110011;
parameter [9:0] K28_4_RD_Minus_9C = 10'b0011110010;
parameter [9:0] K28_5_RD_Minus_BC = 10'b0011111010;
parameter [9:0] K28_6_RD_Minus_DC = 10'b0011110110;
parameter [9:0] K28_7_RD_Minus_FC = 10'b0011111000;
parameter [9:0] K23_7_RD_Minus_F7 = 10'b1110101000;
parameter [9:0] K27_7_RD_Minus_FB = 10'b1101101000;
parameter [9:0] K29_7_RD_Minus_FD = 10'b1011101000;
parameter [9:0] K30_7_RD_Minus_FE = 10'b0111101000;
// Se definen los Code-Goups Especiales en RD (+)
parameter [9:0] K28_0_RD_Plus_1C = ~K28_0_RD_Minus_1C;
parameter [9:0] K28_1_RD_Plus_3C = ~K28_1_RD_Minus_3C;
parameter [9:0] K28_2_RD_Plus_5C = ~K28_2_RD_Minus_5C;
parameter [9:0] K28_3_RD_Plus_7C = ~K28_3_RD_Minus_7C;
parameter [9:0] K28_4_RD_Plus_9C = ~K28_4_RD_Minus_9C;
parameter [9:0] K28_5_RD_Plus_BC = ~K28_5_RD_Minus_BC;
parameter [9:0] K28_6_RD_Plus_DC = ~K28_6_RD_Minus_DC;
parameter [9:0] K28_7_RD_Plus_FC = ~K28_7_RD_Minus_FC;
parameter [9:0] K23_7_RD_Plus_F7 = ~K23_7_RD_Minus_F7;
parameter [9:0] K27_7_RD_Plus_FB = ~K27_7_RD_Minus_FB;
parameter [9:0] K29_7_RD_Plus_FD = ~K29_7_RD_Minus_FD;
parameter [9:0] K30_7_RD_Plus_FE = ~K30_7_RD_Minus_FE;
// Se define la tabla 36--1e para Code-Groups de Datos Válidos
// RD (-)
parameter [9:0] D16_7_RD_Minus_F0 = 10'b0110110001;
parameter [9:0] D17_7_RD_Minus_F1 = 10'b1000110111;
parameter [9:0] D18_7_RD_Minus_F2 = 10'b0100110111;
parameter [9:0] D19_7_RD_Minus_F3 = 10'b1100101110;
parameter [9:0] D20_7_RD_Minus_F4 = 10'b0010110111;
parameter [9:0] D21_7_RD_Minus_F5 = 10'b1010101110;
parameter [9:0] D22_7_RD_Minus_F6 = 10'b0110101110;
parameter [9:0] D23_7_RD_Minus_F7 = 10'b1110100001;
parameter [9:0] D24_7_RD_Minus_F8 = 10'b1100110001;
parameter [9:0] D25_7_RD_Minus_F9 = 10'b1001101110;
parameter [9:0] D26_7_RD_Minus_FA = 10'b0101101110;
parameter [9:0] D27_7_RD_Minus_FB = 10'b1101100001;
parameter [9:0] D28_7_RD_Minus_FC = 10'b0011101110;
parameter [9:0] D29_7_RD_Minus_FD = 10'b1011100001;
parameter [9:0] D30_7_RD_Minus_FE = 10'b0111100001;
parameter [9:0] D31_7_RD_Minus_FF = 10'b1010110001;
parameter [9:0] D15_7_RD_Minus_EF = 10'b0101110001;
// RD (+)
parameter [9:0] D16_7_RD_Plus_F0 = ~D16_7_RD_Minus_F0;
parameter [9:0] D17_7_RD_Plus_F1 = ~D17_7_RD_Minus_F1;
parameter [9:0] D18_7_RD_Plus_F2 = ~D18_7_RD_Minus_F2;
parameter [9:0] D19_7_RD_Plus_F3 = ~D19_7_RD_Minus_F3;
parameter [9:0] D20_7_RD_Plus_F4 = ~D20_7_RD_Minus_F4;
parameter [9:0] D21_7_RD_Plus_F5 = ~D21_7_RD_Minus_F5;
parameter [9:0] D22_7_RD_Plus_F6 = ~D22_7_RD_Minus_F6;
parameter [9:0] D23_7_RD_Plus_F7 = ~D23_7_RD_Minus_F7;
parameter [9:0] D24_7_RD_Plus_F8 = ~D24_7_RD_Minus_F8;
parameter [9:0] D25_7_RD_Plus_F9 = ~D25_7_RD_Minus_F9;
parameter [9:0] D26_7_RD_Plus_FA = ~D26_7_RD_Minus_FA;
parameter [9:0] D27_7_RD_Plus_FB = ~D27_7_RD_Minus_FB;
parameter [9:0] D28_7_RD_Plus_FC = ~D28_7_RD_Minus_FC;
parameter [9:0] D29_7_RD_Plus_FD = ~D29_7_RD_Minus_FD;
parameter [9:0] D30_7_RD_Plus_FE = ~D30_7_RD_Minus_FE;
parameter [9:0] D31_7_RD_Plus_FF = ~D31_7_RD_Minus_FF;
parameter [9:0] D15_7_RD_Plus_EF = ~D15_7_RD_Minus_EF;

// Códigos para IDLE y LPIDLE
parameter [9:0] D5_6_RD_Minus_C5	= 10'b1010010110;
parameter [9:0] D6_5_RD_Minus_A6	= 10'b0110011010;
parameter [9:0] D16_2_RD_Minus_50	= 10'b0110110101;
parameter [9:0] D26_4_RD_Minus_9A	= 10'b0101100010;

parameter [9:0] D5_6_RD_Plus_C5		= ~D5_6_RD_Minus_C5;
parameter [9:0] D16_2_RD_Plus_50	= ~D16_2_RD_Minus_50;
parameter [9:0] D6_5_RD_Plus_A6		= ~D6_5_RD_Minus_A6;
parameter [9:0] D26_4_RD_Plus_9A	= ~D26_4_RD_Minus_9A;

parameter [9:0] DATO_INVALIDO1 = 10'b1111111111;
parameter [9:0] DATO_INVALIDO2 = 10'b1111101111;

// Códigos para identificar los estados de idle
// Se utilizan números negativos para tener variables
// intermedias que representen los code groups 
// a la hora de enviarlos a través de tx_o_set

//parameter [11:0] I_CG			= -1;
//parameter [11:0] LPI_CG			= -2;
//parameter [11:0] V_CG			= -3;
//parameter [11:0] S_CG			= -4;
//parameter [11:0] T_CG			= -5;
//parameter [11:0] R_CG			= -6;

