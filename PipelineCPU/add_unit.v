module add_unit(a, b, ci, co, s); //module unit of adder with carry-in selection
  parameter N = 4;  
  input [N-1:0] a;  
  input [N-1:0] b;
  input ci;
  output co;
  output [N-1:0] s;
    
  wire [N-1:0] out0; //define two outputs with different carry-ins
  wire [N-1:0] out1;
  wire co0, co1, temp;  //define two carry-outs with different carry-ins
   
  mux_2to1  #(N)  mux(.out(s), .in0(out0), .in1(out1), .sel(ci)); //instance of mux_2to1
  adder_4bits  #(N)  adder_0(.a(a), .b(b), .s(out0), .ci(1'b0), .co(co0)); //two instances of adder_4bits 
  adder_4bits  #(N)  adder_1(.a(a), .b(b), .s(out1), .ci(1'b1), .co(co1));
  and(temp, ci, co1); //instance of 'and' logic
  or(co, co0, temp);  //instance of 'or' logic
  
endmodule