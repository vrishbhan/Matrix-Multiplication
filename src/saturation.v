//*****************************************************************//
// Saturation Logic for the Adders
// Created By - Vrishbhan Singh Sisodia
//	San Jose State University
//	EE 278
//*****************************************************************//
`timescale 1ns/100ps
module saturation_logic ( sum_saturated_80, sum_80, carry_80, oflow_80 );
parameter       WIDTH_SUM = 4;
output  [ WIDTH_SUM - 1:0 ] sum_saturated_80;
input   [ WIDTH_SUM - 1:0 ] sum_80;
input   carry_80, oflow_80;

reg     [ WIDTH_SUM - 1:0 ] sum_saturated_80;
wire    [ WIDTH_SUM - 1:0 ] sum_80;
wire    carry_80, oflow_80;
        // **** Saturation logic ****
        // if there is no overflow, no saturation is necessary
        //              * check and correct for illegal number (1000)
        // if there is overflow, check for the carry out
        // * carry out = 0 => MSB of the sum = 1
        //   ( 2 +ve numbers were added & sum has become a -ve number )
        //   saturate sum to the highest positive number = 0111 (+7)
        // * carry out = 1 => MSB of the sum = 0
        //   ( 2 -ve numbers were added & sum has become a +ve number )
        //   saturate sum to the lowest negative number = 1001 (-7)
        always @ ( carry_80 or oflow_80 or sum_80 )
        begin
                case ( {carry_80,oflow_80} )
                2'b00 : begin
                                if ((sum_80[WIDTH_SUM-1]==1'b1) && (sum_80[WIDTH_SUM-2:0]==0))
                                        sum_saturated_80 = sum_80 + 1;
                                else
                                        sum_saturated_80 = sum_80;
                                end

                2'b10 : begin
                                if ((sum_80[WIDTH_SUM-1]==1'b1) && (sum_80[WIDTH_SUM-2:0]==0))
                                        sum_saturated_80 = sum_80 + 1;
                                else
                                        sum_saturated_80 = sum_80;
                                end

                2'b01 : sum_saturated_80 = { 1'b0, { (WIDTH_SUM-1) {1'b1} } };

                2'b11 : sum_saturated_80 = { 1'b1, { (WIDTH_SUM-2) {1'b0} }, 1'b1 };
                endcase
        end
endmodule