`timescale 1ns/1ps

module tb_clock_only;

    reg clk;

    always #5 clk = ~clk;

    initial begin
        clk = 0;

        $display("START %0t", $time);

        #20;

        $display("20ns %0t", $time);

        #100;

        $display("DONE %0t", $time);

        $finish;
    end

endmodule
