module And_Gate(
    //output
    output out,
    //input
    input Src1,
    input Src2
);
assign out = Src1 && Src2;
endmodule