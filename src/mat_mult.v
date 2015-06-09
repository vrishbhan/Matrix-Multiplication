//*****************************************************************//
//	Row and Column Multiplication 
//  Created By - Vrishbhan Singh Sisodia
//	Student ID - 009300980
//	San Jose State University
//	EE 278
//*****************************************************************//
`timescale 1ns/100ps
module mat_mult (A00_80, A01_80, A02_80, A03_80, B00_80, B01_80, B02_80, B03_80, 
clk_80, rst_80, AB00_80);
        // Parameterizable with respect to bit widths
        // WIDTH_SUM is separately declared for the case in which A00_80 and B00_80 have
        // different widths, to specify the number of bits to which the product has to be
        // rounded

        parameter       WIDTH_A_80 = 9;
        parameter       WIDTH_B_80 = 8;
        parameter       WIDTH_PROD  = WIDTH_A_80 + WIDTH_B_80;
        parameter       WIDTH_PROD_ROUNDED   = 9;
        parameter       WIDTH_SUM   = 11;

        // Input ports
        input           clk_80, rst_80;
        input            [(WIDTH_A_80 - 1) : 0] A00_80, A01_80, A02_80, A03_80;
        input            [(WIDTH_B_80 - 1) : 0] B00_80, B01_80, B02_80, B03_80;

        // Output ports
        output           [(WIDTH_SUM - 1) : 0] AB00_80;

        wire    	       clk_80, rst_80;
        wire             [(WIDTH_A_80 - 1) : 0] A00_80, A01_80, A02_80, A03_80;
        wire             [(WIDTH_B_80 - 1) : 0] B00_80, B01_80, B02_80, B03_80;
        reg              [(WIDTH_A_80 - 1) :0] A00_80_corrected, A01_80_corrected, A02_80_corrected, A03_80_corrected;
        reg              [(WIDTH_B_80 - 1) :0] B00_80_corrected, B01_80_corrected, B02_80_corrected, B03_80_corrected;
        wire             [(WIDTH_PROD -1) : 0] product0_80, product1_80, product2_80, product3_80;
        wire             [(WIDTH_PROD_ROUNDED -1) : 0] product0_rounded_80, product1_rounded_80, product2_rounded_80, product3_rounded_80;
        wire             [(WIDTH_SUM-1) : 0] adder0_sum_80, adder1_sum_80, adder2_sum_80;
        wire             c_out0_80, c_out1_80, c_out2_80, o_flow0_80, o_flow1_80, o_flow2_80;
        wire             [(WIDTH_SUM-1) : 0] a0_in_80, a1_in_80, a2_in_80;
        wire             [(WIDTH_SUM - 1) : 0]   AB00_80;


        // Illegal Number Detection Logic
        // --------------------------------------------
        // In case of 4 bits, if data = -1 = 1000 (illegal in case of fractional numbers),
        // make it the least negative fractional number that can be represented by 4 bits.
        // Therefore, add 1 and make it 1001 = -0.875

        always @ (A00_80  or B00_80)
        begin

                if ((A00_80[WIDTH_A_80-1] == 1'b1) && (A00_80[WIDTH_A_80-2 : 0] == 0))
                        A00_80_corrected = A00_80 + 1;

                else
                        A00_80_corrected = A00_80;
                if ((B00_80[WIDTH_B_80-1] == 1'b1) && (B00_80[WIDTH_B_80-2 : 0] == 0))
                        B00_80_corrected = B00_80 + 1;

                else
                        B00_80_corrected = B00_80;
        end
		  
		  always @ (A01_80  or B01_80)
        begin

                if ((A01_80[WIDTH_A_80-1] == 1'b1) && (A01_80[WIDTH_A_80-2 : 0] == 0))
                        A01_80_corrected = A01_80 + 1;

                else
                        A01_80_corrected = A01_80;
                if ((B01_80[WIDTH_B_80-1] == 1'b1) && (B01_80[WIDTH_B_80-2 : 0] == 0))
                        B01_80_corrected = B01_80 + 1;

                else
                        B01_80_corrected = B01_80;
        end
		  
		  always @ (A02_80  or B02_80)
        begin

                if ((A02_80[WIDTH_A_80-1] == 1'b1) && (A02_80[WIDTH_A_80-2 : 0] == 0))
                        A02_80_corrected = A02_80 + 1;

                else
                        A02_80_corrected = A02_80;
                if ((B02_80[WIDTH_B_80-1] == 1'b1) && (B02_80[WIDTH_B_80-2 : 0] == 0))
                        B02_80_corrected = B02_80 + 1;

                else
                        B02_80_corrected = B02_80;
        end
		  
		  always @ (A03_80  or B03_80)
        begin

                if ((A03_80[WIDTH_A_80-1] == 1'b1) && (A03_80[WIDTH_A_80-2 : 0] == 0))
                        A03_80_corrected = A03_80 + 1;

                else
                        A03_80_corrected = A03_80;
                if ((B03_80[WIDTH_B_80-1] == 1'b1) && (B03_80[WIDTH_B_80-2 : 0] == 0))
                        B03_80_corrected = B03_80 + 1;

                else
                        B03_80_corrected = B03_80;
        end

        // MULTIPLIER
        // ==========
        // Instantiating LPM mult module

		  mult m0 (.dataa(A00_80_corrected),.datab(B00_80_corrected),.result(product0_80));
		  mult m1 (.dataa(A01_80_corrected),.datab(B01_80_corrected),.result(product1_80));
		  mult m2 (.dataa(A02_80_corrected),.datab(B02_80_corrected),.result(product2_80));
		  mult m3 (.dataa(A03_80_corrected),.datab(B03_80_corrected),.result(product3_80));
        /*defparam
                mult.WIDTH_A     = WIDTH_A_80,
                mult.WIDTH_B     = WIDTH_B_80,
                mult.WIDTH_PROD  = WIDTH_PROD;
			*/
        // Truncation and Rounding logic

        rounding_logic r0 ( product0_rounded_80, product0_80 );
        rounding_logic r1 ( product1_rounded_80, product1_80 );
        rounding_logic r2 ( product2_rounded_80, product2_80 );
        rounding_logic r3 ( product3_rounded_80, product3_80 );
        defparam
                r0.WIDTH_PROD         = WIDTH_PROD,
                r0.WIDTH_PROD_ROUNDED = WIDTH_PROD_ROUNDED;
        defparam
                r1.WIDTH_PROD         = WIDTH_PROD,
                r1.WIDTH_PROD_ROUNDED = WIDTH_PROD_ROUNDED;
        defparam
                r2.WIDTH_PROD         = WIDTH_PROD,
                r2.WIDTH_PROD_ROUNDED = WIDTH_PROD_ROUNDED;
        defparam
                r3.WIDTH_PROD         = WIDTH_PROD,
                r3.WIDTH_PROD_ROUNDED = WIDTH_PROD_ROUNDED;

        // Adder
        // --------
        // Instantiating an adder module
        // This adder has carry out and overflow bits for calculations in the saturation logic

        add a0 ( .dataa({{(WIDTH_SUM - WIDTH_PROD_ROUNDED){product0_rounded_80[WIDTH_PROD_ROUNDED-1]}},{product0_rounded_80}}), .datab({{(WIDTH_SUM - WIDTH_PROD_ROUNDED){product1_rounded_80[WIDTH_PROD_ROUNDED-1]}},{product1_rounded_80}}), .result(adder0_sum_80), .cout(c_out0_80),.overflow(o_flow0_80) );
        add a1 ( .dataa({{(WIDTH_SUM - WIDTH_PROD_ROUNDED){product2_rounded_80[WIDTH_PROD_ROUNDED-1]}},{product2_rounded_80}}), .datab({{(WIDTH_SUM - WIDTH_PROD_ROUNDED){product3_rounded_80[WIDTH_PROD_ROUNDED-1]}},{product3_rounded_80}}), .result(adder1_sum_80), .cout(c_out1_80),.overflow(o_flow1_80) );
        add a2 ( .dataa(a0_in_80), .datab(a1_in_80), .result(adder2_sum_80), .cout(c_out2_80),.overflow(o_flow2_80) );
		  
        // Saturation logic
        saturation_logic sat_sum0 ( a0_in_80, adder0_sum_80, c_out0_80, o_flow0_80 );
        saturation_logic sat_sum1 ( a1_in_80, adder1_sum_80, c_out1_80, o_flow1_80 );
        saturation_logic sat_sum2 ( a2_in_80, adder2_sum_80, c_out2_80, o_flow2_80 );

        defparam
                sat_sum0.WIDTH_SUM  = WIDTH_SUM;
        defparam
                sat_sum1.WIDTH_SUM  = WIDTH_SUM;
        defparam
                sat_sum2.WIDTH_SUM  = WIDTH_SUM;
        // D Register
        // ---------------

        d_ff D0 ( .clk_80(clk_80), .rst_80(rst_80), .d_80(a2_in_80), .q_80(AB00_80) );


        defparam
                D0.REG_SIZE = WIDTH_SUM;

endmodule