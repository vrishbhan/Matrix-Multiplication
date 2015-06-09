//*****************************************************************//
// Rounding Logic for the Multipliers
// Created By - Vrishbhan Singh Sisodia
//	Student ID - 009300980
//	San Jose State University
//	EE 278
//*****************************************************************//
`timescale 1ns/100ps
module rounding_logic ( prod_rounded_80, prod_80 );

parameter WIDTH_PROD = 8;
parameter WIDTH_PROD_ROUNDED = 4;

input    [ WIDTH_PROD - 1:0 ]           prod_80;
output   [ WIDTH_PROD_ROUNDED - 1:0 ]   prod_rounded_80;

wire     [ WIDTH_PROD - 1:0 ]           prod_80;
reg      [ WIDTH_PROD_ROUNDED - 1:0 ]   prod_rounded_80;

// Truncation and Rounding logic
// -----------------------------
        // 1. throw away the MSB (redundant sign bit)
        // 2. check for the possibility of the illegal number
        //              * if the product is positive
        //         and if the to-be-rounded bits are 0111, and the next bit is 1,
        //                 don't add 1. Just truncate it to 0111
        //              * if the product is negative
        //            if the to-be-rounded bits are 1000, add 1 to make it 1001
        // 3. add rounding logic for both positive and negative products
        //              * If the next bit is 1, add 1 to the to-be-rounded bits
        //              * If the next bit is 0, just truncate
always @ (prod_80)
begin
        if ( prod_80[WIDTH_PROD-1] == 1'b0 )
        begin
                if ( & prod_80[(WIDTH_PROD-2-1):(WIDTH_PROD_ROUNDED-1)] )
                        prod_rounded_80 <=
                          prod_80[(WIDTH_PROD-2):(WIDTH_PROD-WIDTH_PROD_ROUNDED-1)];
                else
                begin
                   if ( prod_80[WIDTH_PROD-WIDTH_PROD_ROUNDED-2] == 1'b1 )
                      prod_rounded_80 <= prod_80[(WIDTH_PROD-2):(WIDTH_PROD-2-(WIDTH_PROD_ROUNDED-1))]+1;
                   else
                      prod_rounded_80 <= prod_80[(WIDTH_PROD-2):(WIDTH_PROD-2-(WIDTH_PROD_ROUNDED-1))];
                end
        end
        else
        begin
                if( prod_80[(WIDTH_PROD-2-1):(WIDTH_PROD-WIDTH_PROD_ROUNDED-1)] == 0 )
                   prod_rounded_80 <= prod_80[(WIDTH_PROD-2):(WIDTH_PROD-WIDTH_PROD_ROUNDED-1)]+1;
                else
                begin
                   if ( prod_80[WIDTH_PROD-WIDTH_PROD_ROUNDED-2] == 1'b1 )
                      prod_rounded_80 <= prod_80[(WIDTH_PROD-2):(WIDTH_PROD-2-(WIDTH_PROD_ROUNDED-1))]+1;
                   else
                      prod_rounded_80 <= prod_80[(WIDTH_PROD-2):(WIDTH_PROD-2-(WIDTH_PROD_ROUNDED-1))];
                end
        end
end

endmodule