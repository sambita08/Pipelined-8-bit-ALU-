`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sambita Dutta
// 
// Create Date: 06.01.2026 01:39:47
// Design Name: 
// Module Name: sample
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ADD_SUBstr(
input clk,
input rst,
input [7:0]a,
input [7:0]b,
input [1:0]c,     //c[0] =input mode= 1 for sub,0 for add c[1]=0
output reg [7:0]sum_final,
output reg cout_T,
output reg valid);

   
 // Stage 1 Pipeline Registers
    reg [7:0] reg_a, reg_b;
    reg [1:0] reg_c;
    reg stage1_valid;
   
    


wire [7:0]w; 
wire [7:0]sum;
wire [7:0]cf;    //cf=carry follow in FA,  w=wire from xor to FA
wire [7:0]and_result;
wire [7:0]xor_result; 


// Stage 1: Input Latch
    always @(posedge clk or posedge rst) 
    begin
        if (rst) begin
            reg_a <= 8'b0;  //setting value of a,b =0 i.e. RESET 
            reg_b <= 8'b0;
            reg_c <= 2'b0;
            stage1_valid <= 1'b0;
        end else begin
            reg_a <= a;   //setting value of register a as A at current time
            reg_b <= b;
            reg_c <= c;
            stage1_valid <= 1'b1;
            
        end
    end
    
    

// ADD FOR 00, SUB FOR 01

xor x0(w[0], reg_b[0], reg_c[0]);
xor x1(w[1], reg_b[1], reg_c[0]);
xor x2(w[2], reg_b[2], reg_c[0]);
xor x3(w[3], reg_b[3], reg_c[0]);
xor x4(w[4], reg_b[4], reg_c[0]);
xor x5(w[5], reg_b[5], reg_c[0]);
xor x6(w[6], reg_b[6], reg_c[0]);
xor x7(w[7], reg_b[7], reg_c[0]);

full_adderdf  fa0(.s(sum[0]), .cout(cf[0]), .a(reg_a[0]) ,.b(w[0]), .cin(reg_c[0]));
full_adderdf  fa1(.s(sum[1]), .cout(cf[1]), .a(reg_a[1]) ,.b(w[1]), .cin(cf[0]));
full_adderdf  fa2(.s(sum[2]), .cout(cf[2]), .a(reg_a[2]) ,.b(w[2]), .cin(cf[1]));
full_adderdf  fa3(.s(sum[3]), .cout(cf[3]), .a(reg_a[3]) ,.b(w[3]), .cin(cf[2]));
full_adderdf  fa4(.s(sum[4]), .cout(cf[4]), .a(reg_a[4]) ,.b(w[4]), .cin(cf[3]));
full_adderdf  fa5(.s(sum[5]), .cout(cf[5]), .a(reg_a[5]) ,.b(w[5]), .cin(cf[4]));
full_adderdf  fa6(.s(sum[6]), .cout(cf[6]), .a(reg_a[6]) ,.b(w[6]), .cin(cf[5]));
full_adderdf  fa7(.s(sum[7]), .cout(cf[7]), .a(reg_a[7]) ,.b(w[7]), .cin(cf[6]));  



assign and_result= reg_a & reg_b ;   //AND for 10

assign xor_result=  reg_a ^ reg_b ;   //XOR FOR 11


 //stage 2: OUTPUT REGISTER 
 always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_final <= 8'b0;
            cout_T <= 1'b0;
            valid <= 1'b0;
        end else if (stage1_valid)
 	begin
            case (reg_c)
                2'b00: 
	           begin    // ADD
                    sum_final <= sum;
                    cout_T <= cf[7];
                   end
                2'b01: 
	           begin    // SUB
                    sum_final <= sum;
                    cout_T <= cf[7];
                   end
                2'b10:	
		   begin    // AND 
                    sum_final <= and_result;
                    cout_T <= 1'b0;  
                    end
                2'b11:
                   begin    //XOR
                    sum_final <= xor_result;
                    cout_T <= 1'b0;
                   end   
                default:
                   begin    //FAULTY OPCODE
                    sum_final <= 8'b0;
                    cout_T <= 1'b0;
                   end
            endcase
            valid <= 1'b1;
        end else begin
            valid <= 1'b0;
        end
    end

endmodule
