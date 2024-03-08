// Code your design here
module PartialProductGen(
    input [3:0] A_in,
    input [3:0] B_in,
    output reg [15:0] PP,
    input clk
    );
    integer i,j;
    always@(posedge clk)begin
      for(i=0;i<4;i = i+1)begin
        for(j=0;j<4;j = j+1)begin
            PP[i*4+j] <= A_in[j] & B_in[i];
         end
      end    
    end
endmodule

module DADDA(
    input [3:0] A,
    input [3:0] B,
    input clk,
    output reg [7:0] prod
    );
    reg[15:0] pp1;
    wire[15:0]pp2;
    PartialProductGen gen1(A,B,pp2,clk);
    always@(posedge clk)begin
        pp1 <= pp2;
    end
    //partial product is formed Now we enter the layer 2 of the Dadda multiplier
    wire[3:0]L2outputs;
    HalfAdder hf1(pp1[7],pp1[10],L2outputs[0],L2outputs[1]);
    HalfAdder hf2(pp1[9],pp1[12],L2outputs[2],L2outputs[3]);
    
    reg[15:0]Layer21;
    always@(posedge clk)begin
        Layer21[6:0] <= pp1[6:0];
        Layer21[8] <= pp1[8];
        Layer21[11] <= pp1[11];
        Layer21[15:13] <= pp1[15:13];
        Layer21[7] <= L2outputs[0]; //layer21[7] has sum of 7+10 S2
        Layer21[10] <= L2outputs[1];//layer21[10] has carry of 7+10 C2
        Layer21[9] <= L2outputs[2];//layer21[9] has sum of 9+12 S1
        Layer21[12] <= L2outputs[3];//layer21[12] has carry of 9+12 C2
    end
    wire[7:0]L1outputs;
    HalfAdder hf3(pp1[5],pp1[8],L1outputs[0],L1outputs[1]);// S1 C1
    FullAdder fa1(pp1[3],pp1[6],Layer21[9],L1outputs[2],L1outputs[3]); // S2 C2
    FullAdder fa2(pp1[13],Layer21[12],Layer21[7],L1outputs[4],L1outputs[5]); // S3 C3
    FullAdder fa3(pp1[11],pp1[14],Layer21[10],L1outputs[6],L1outputs[7]); // S4 C4

    
    reg[13:0]Layer10;
    always@(posedge clk)begin
        Layer10[2:0] <= Layer21[2:0];
        Layer10[6] <= Layer21[15];
        Layer10[7] <= 1'b0;
        Layer10[8] <= Layer21[4];
        Layer10[3] <= L1outputs[2];
        Layer10[4] <= L1outputs[4];
        Layer10[5] <= L1outputs[6];
        Layer10[9] <= L1outputs[0];
        Layer10[10] <= L1outputs[1];
        Layer10[11] <= L1outputs[3];
        Layer10[12] <= L1outputs[5];
        Layer10[13] <= L1outputs[7];
    end
    wire[7:0]prod1;
    RippleCarryAdder rip(Layer10[6:0],Layer10[13:7],prod1[7:0]);
    always@(posedge clk)begin
        prod <= prod1;
    end
endmodule

module FullAdder(
    input a_1,
    input b_1,
    input cin,
    output sumfa,
    output cout
    );
    wire s1,c1,c2;
    HalfAdder hf1(a_1,b_1,s1,c1);
    HalfAdder hf2(s1,cin,sumfa,c2);
    or or1(cout,c1,c2);
endmodule

module HalfAdder(
    input a,
    input b,
    output sum,
    output carry
    );
    xor xor1(sum,a,b);
    and and1(carry,a,b);
endmodule

module RippleCarryAdder(
    input [6:0] RipA,
    input [6:0] RipB,
    output [7:0] RipOut
    );
  wire [5:0] ca;
  FullAdder fa0(RipA[0],RipB[0],0,RipOut[0],ca[0]);
  FullAdder fa1(RipA[1],RipB[1],ca[0],RipOut[1],ca[1]);
  FullAdder fa2(RipA[2],RipB[2],ca[1],RipOut[2],ca[2]);
  FullAdder fa3(RipA[3],RipB[3],ca[2],RipOut[3],ca[3]);
  FullAdder fa4(RipA[4],RipB[4],ca[3],RipOut[4],ca[4]);
  FullAdder fa5(RipA[5],RipB[5],ca[4],RipOut[5],ca[5]);
  FullAdder fa6(RipA[6],RipB[6],ca[5],RipOut[6],RipOut[7]);
endmodule
//--------------------------------------------------------
// testbench
//---------------------------------------------------------

module testbench();
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [7:0] prod;
    
    DADDA dut(.A(A),.B(B),.clk(clk),.prod(prod));
    
        initial
        begin
            clk = 0;
            forever #5 clk <= ~clk;
        end
    
        initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0,testbench);
        
        A = 4'b0100;B = 4'b0011;
        #100
      $finish();
     end
endmodule
