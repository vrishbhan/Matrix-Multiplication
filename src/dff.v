//*****************************************************************//
// Parameterizable D register with asynchronous clear input
// Created By - Vrishbhan Singh Sisodia
//	San Jose State University
//	EE 278
//*****************************************************************//
`timescale 1ns/100ps
module d_ff ( clk_80, rst_80, d_80, q_80 );
        parameter REG_SIZE = 4;
        input   clk_80, rst_80;
        input   [(REG_SIZE - 1) :0] d_80;
        output  [(REG_SIZE - 1) :0] q_80;

        wire    clk_80, rst_80;
        wire    [(REG_SIZE - 1) :0] d_80;
        reg     [(REG_SIZE - 1) :0] q_80;

        always @ ( posedge clk_80 or posedge rst_80 )
        begin
                if (rst_80)
                        q_80 <= 0;
                else
                        q_80 <= d_80;
        end
endmodule

