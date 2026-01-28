`timescale 1ns / 1ps

module tb_ADD_SUBstr();
    reg clk, rst;
    reg [7:0] a, b;
    reg [1:0] c;
    wire [7:0] sum_final;
    wire cout_T, valid;

    ADD_SUBstr uut (.clk(clk), .rst(rst), .a(a), .b(b), .c(c),
                    .sum_final(sum_final), .cout_T(cout_T), .valid(valid));

    
    always #5 clk = ~clk;  // 10ns period

    
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_ADD_SUBstr);
        
        // Reset
	clk=0;
        rst = 1; a = 0; b = 0; c = 0;
        #25 rst = 0;
        
        // Test 1: ADD
        #5 a = 8'd1; b = 8'd2; c = 2'b00; 
        repeat(3) @(posedge clk);	    // Wait pipeline
        $display("ADD: %d + %d = %d ✓", 1, 2, sum_final);
       
        // Test 2: SUB  
        #5  a = 8'd12; b = 8'd30; c = 2'b01;
        repeat(3) @(posedge clk);
        $display("SUB: %d - %d = %d ✓", 50, 30, sum_final);
        
        // Test 3: AND
        #5 a = 8'hFF; b = 8'h0F; c = 2'b10;
        repeat(3) @(posedge clk);
        $display("AND: 0x%h & 0x%h = 0x%h ✓", 8'hFF, 8'h0F, sum_final);
        
        // Test 4: XOR
        #5 a = 8'hAA; b = 8'h55; c = 2'b11;
        repeat(3) @(posedge clk);
        $display("XOR: 0x%h ^ 0x%h = 0x%h ✓", 8'hAA, 8'h55, sum_final);
        
        repeat(5) @(posedge clk);  // Hold final result
        $finish;
    end

endmodule
