`include "transmisor.v"
`include "tester.v"

module transmisor_tb;

wire		RESET,
		TX_EN,
		TX_ER,
		GTX_CLK;
wire [7:0]	TXD;
wire [9:0]	tx_code_group;



// Monitoring code
initial begin
	$dumpfile("transmisor_output.vcd");
	$dumpvars(-1, TX0);
	$dumpvars(-1, TST0);
end


// Instance creation for DUT and tester modules
transmisor TX0 (
	.RESET (RESET),
	.TXD (TXD),
	.TX_EN (TX_EN),
	.TX_ER (TX_ER),
	.GTX_CLK (GTX_CLK),
	.tx_code_group (tx_code_group)
);

tester TST0 (
	.RESET (RESET),
	.TXD (TXD),
	.TX_EN (TX_EN),
	.TX_ER (TX_ER),
	.GTX_CLK (GTX_CLK),
	.tx_code_group (tx_code_group)
);

endmodule
