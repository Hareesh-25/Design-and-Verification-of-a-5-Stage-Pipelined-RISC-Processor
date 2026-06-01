// Code your testbench here
// or browse Examples
module tb_processor;

reg clk;
reg reset;

processor_top DUT(
    .clk(clk),
    .reset(reset)
);

always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;

    #20;
    reset = 0;

    #300;
    $finish;
end

initial
begin
    $dumpfile("pipeline.vcd");
    $dumpvars(0,tb_processor);
end

endmodule