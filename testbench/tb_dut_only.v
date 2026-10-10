`timescale 1ns/1ps

module tb_dut_only;

    reg clk;
    reg reset_n;

    reg        transfer;
    reg [31:0] addr;
    reg [31:0] wdata;
    reg        write;

    wire [31:0] rdata;

    wire [31:0] src_mem_addr;
    wire        src_mem_read;
    reg  [31:0] src_mem_rdata;
    reg         src_mem_valid;

    wire [31:0] dst_mem_addr;
    wire [31:0] dst_mem_wdata;
    wire        dst_mem_write;
    reg         dst_mem_ready;


    dma_top dut (
        .clk(clk),
        .reset_n(reset_n),

        .transfer(transfer),
        .addr(addr),
        .wdata(wdata),
        .write(write),

        .rdata(rdata),

        .src_mem_addr(src_mem_addr),
        .src_mem_read(src_mem_read),
        .src_mem_rdata(src_mem_rdata),
        .src_mem_valid(src_mem_valid),

        .dst_mem_addr(dst_mem_addr),
        .dst_mem_wdata(dst_mem_wdata),
        .dst_mem_write(dst_mem_write),
        .dst_mem_ready(dst_mem_ready)
    );


    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset_n = 0;

        transfer = 0;
        addr = 0;
        wdata = 0;
        write = 0;

        src_mem_rdata = 0;
        src_mem_valid = 0;

        dst_mem_ready = 1;

        $display("DUT TEST START %0t", $time);

        #20;

        reset_n = 1;

        $display("RESET RELEASED %0t", $time);

        #100;

        $display("DUT TEST FINISHED %0t", $time);

        $finish;

    end

endmodule
