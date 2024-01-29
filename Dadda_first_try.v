// 4x4 Dadda multiplier code
module HalfAdder(a1,b1,sum,carry);
  input a1,b1;
  output sum,carry;
  xor xor1(sum,a1,b1);
  and and1(carry,a1,b1);
endmodule

module FullAdder(a,b,cin,sumfa,cout);
  wire s1,c1,c2;
  input a,b,cin;
  output sumfa,cout;
  
  HalfAdder hf1(a,b,s1,c1);
  HalfAdder hf2(s1,cin,sumfa,c2);
  or or1(cout,c1,c2);
endmodule

module RippleCarryAdder(p,q,ans);
  input [6:0] p, q;
  output [7:0] ans;
  wire [5:0] ca;
  FullAdder fa0(p[0],q[0],0,ans[0],ca[0]);
  FullAdder fa1(p[1],q[1],ca[0],ans[1],ca[1]);
  FullAdder fa2(p[2],q[2],ca[1],ans[2],ca[2]);
  FullAdder fa3(p[3],q[3],ca[2],ans[3],ca[3]);
  FullAdder fa4(p[4],q[4],ca[3],ans[4],ca[4]);
  FullAdder fa5(p[5],q[5],ca[4],ans[5],ca[5]);
  FullAdder fa6(p[6],q[6],ca[5],ans[6],ans[7]);
endmodule

module PartialProduct(b2,a2,pp);
  input[3:0]a2,b2;
  output [15:0]pp;
  
  and and1(pp[0],a2[0],b2[0]);
  and and2(pp[1],a2[0],b2[1]);
  and and3(pp[2],a2[0],b2[2]);
  and and4(pp[3],a2[0],b2[3]);
  and and5(pp[4],a2[1],b2[0]);
  and and6(pp[5],a2[1],b2[1]);
  and and7(pp[6],a2[1],b2[2]);
  and and8(pp[7],a2[1],b2[3]);
  and and9(pp[8],a2[2],b2[0]);
  and and10(pp[9],a2[2],b2[1]);
  and and11(pp[10],a2[2],b2[2]);
  and and12(pp[11],a2[2],b2[3]);
  and and13(pp[12],a2[3],b2[0]);
  and and14(pp[13],a2[3],b2[1]);
  and and15(pp[14],a2[3],b2[2]);
  and and16(pp[15],a2[3],b2[3]);
endmodule

module Dadda4x4(b3,a3,prod);
  input[3:0]a3,b3;
  output[7:0]prod;
  wire[15:0]pp1;
  
  PartialProduct Pp1(b3,a3,pp1);
  // Level j=2 d2=3
  wire ps2_1,ps2_2,pc2_1,pc2_2;
  HalfAdder hf7_10(pp1[7],pp1[10],ps2_1,pc2_1);
  HalfAdder hf9_12(pp1[9],pp1[12],ps2_2,pc2_2);
  
  //Level j=1,d1=2
  wire ps1_1,ps1_2,pc1_1,pc1_2,ps1_3,ps1_4,pc1_3,pc1_4,ps1_5,pc1_5;
  HalfAdder hf(pp1[5],pp1[8],ps1_1,pc1_1);
  FullAdder fl0(pp1[3],pp1[6],ps2_2,ps1_2,pc1_2);
  FullAdder fl1(pp1[13],ps2_1,pc2_2,ps1_3,pc1_3);
  FullAdder fl2(pp1[11],pp1[14],pc2_1,ps1_4,pc1_4);
  
  wire [6:0]pq,qq;
  assign pq[2:0] = pp1[2:0]; assign pq[3]=ps1_2; assign pq[4]=ps1_3; assign pq[5]=ps1_4; assign pq[6]=pp1[15];
  assign qq[0]=0; assign qq[1]=pp1[4]; assign qq[2]=ps1_1; assign qq[3]=pc1_1; assign qq[4]=pc1_2; assign qq[5]=pc1_3; assign qq[6]=pc1_4;
  RippleCarryAdder rca(pq,qq,prod);
endmodule
//___________________________________________________________________________________________________________________________________________//
// testbench for the above code
module testbench();
  reg [3:0] a3;
  reg [3:0] b3;
  wire [7:0] prod;
  
  Dadda4x4 dut(.b3(b3), .a3(a3) , .prod(prod));
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);
    
    a3 = 4'b0100;b3 = 4'b0011;
    // 4*3
    #10
    a3 = 4'b0100;b3 = 4'b1001;
    //4*9
    #10
    $finish();
  end
endmodule
