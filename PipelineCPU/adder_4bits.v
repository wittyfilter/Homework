module adder_4bits(a, b, s, ci, co);  //module of adder with 4bits(carry lookahead)
  parameter N = 4;
  input [N-1:0] a;
  input [N-1:0] b;
  output [N-1:0] s;
  input ci;
  output co;
  
  wire [N-1:0] g;  //two auxiliary variables  
  wire [N-1:0] p;
	wire [N:0] c;  //carries
	
 	assign co = c[N]; //carry lookahead
	assign c[0] = ci;
	assign g[0] = a[0] && b[0];
	assign p[0] = a[0] + b[0];
	assign c[1] = g[0] + (p[0] && c[0]);
	assign s[0] = (p[0] && (~g[0])) ^ c[0];
	assign g[1] = a[1] && b[1];
	assign p[1] = a[1] + b[1];
	assign c[2] = g[1] + (p[1] && c[1]);
	assign s[1] = (p[1] && (~g[1])) ^ c[1];
	assign g[2] = a[2] && b[2];
	assign p[2] = a[2] + b[2];
	assign c[3] = g[2] + (p[2] && c[2]);
	assign s[2] = (p[2] && (~g[2])) ^ c[2];
	assign g[3] = a[3] && b[3];
	assign p[3] = a[3] + b[3];
	assign c[4] = g[3] + (p[3] && c[3]);
	assign s[3] = (p[3] && (~g[3])) ^ c[3];
	assign co = c[4];
endmodule
