module adder_32bits(a, b, ci, s, co); //module of adder with 32bits
  input [31:0] a;
  input [31:0] b;
  input ci;
  output [31:0] s;
  output co;
  wire [7:0] c; //connections for carries 
  
  adder_4bits  #(4) adder0(.a(a[3:0]), .b(b[3:0]), .s(s[3:0]), .ci(ci), .co(c[0])); //instance of adder_4bits  
  //7 instances of add_unit with 'end to end' structure
  add_unit  #(4)  adder1(.a(a[7:4]), .b(b[7:4]), .s(s[7:4]), .ci(c[0]), .co(c[1])); 
  add_unit  #(4)  adder2(.a(a[11:8]), .b(b[11:8]), .s(s[11:8]), .ci(c[1]), .co(c[2]));
  add_unit  #(4)  adder3(.a(a[15:12]), .b(b[15:12]), .s(s[15:12]), .ci(c[2]), .co(c[3]));
  add_unit  #(4)  adder4(.a(a[19:16]), .b(b[19:16]), .s(s[19:16]), .ci(c[3]), .co(c[4]));
  add_unit  #(4)  adder5(.a(a[23:20]), .b(b[23:20]), .s(s[23:20]), .ci(c[4]), .co(c[5]));
  add_unit  #(4)  adder6(.a(a[27:24]), .b(b[27:24]), .s(s[27:24]), .ci(c[5]), .co(c[6]));
  add_unit  #(4)  adder7(.a(a[31:28]), .b(b[31:28]), .s(s[31:28]), .ci(c[6]), .co(c[7]));
  
  assign co = c[7]; 
endmodule
