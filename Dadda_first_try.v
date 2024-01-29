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

module DFF(d,clk,clear,q); 
  input d, clk, clear;
  output reg q;
  always@(posedge clk)
    begin
      if (clear == 1)
        q <= 0;
      else
        q<= d;
    end
endmodule
  
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

module Dadda4x4(b3,a3,prod,clk);
  input[3:0]a3,b3;
  output[7:0]prod;
  wire[15:0]pp1;
  
  PartialProduct Pp1(b3,a3,pp1);
  // Level j=2 d2=3
  wire ps2_1,ps2_2,pc2_1,pc2_2
  HalfAdder hf7_10(pp[7],pp[10],ps2_1,pc2_1);
  HalfAdder hf9_12(pp[9],pp[12],ps2_2,pc2_2);
  
  //Level j=1,d1=2
  wire ps1_1,ps1_2,pc1_1,pc1_2,ps1_3,ps1_4,pc1_3,pc1_4,ps1_5,pc1_5
  HalfAdder hf7_10();
