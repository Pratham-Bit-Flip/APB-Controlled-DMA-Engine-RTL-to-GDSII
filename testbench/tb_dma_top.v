`timescale 1ns/1ps

module tb_dma_top;

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

    wire dst_mem_ready;

    assign dst_mem_ready = 1'b1;

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

    always @(*) begin

        src_mem_valid = src_mem_read;

        case (src_mem_addr)

            32'd0:
                src_mem_rdata = src_mem_read ? 32'hAAAA1111 : 32'h0;

            32'd4:
                src_mem_rdata = src_mem_read ? 32'hBBBB2222 : 32'h0;

            32'd8:
                src_mem_rdata = src_mem_read ? 32'hCCCC3333 : 32'h0;

            32'd12:
                src_mem_rdata = src_mem_read ? 32'hDDDD4444 : 32'h0;

            default:
                src_mem_rdata = 32'h0;

        endcase

    end

    always @(posedge clk) begin

        if (dst_mem_write) begin

            $display(
                "DMA WRITE : addr = %h, data = %h, time = %0t",
                dst_mem_addr,
                dst_mem_wdata,
                $time
            );

        end

    end

    task apb_write;

        input [31:0] write_addr;
        input [31:0] write_data;

        begin

            @(negedge clk);

            addr     = write_addr;
            wdata    = write_data;
            write    = 1'b1;
            transfer = 1'b1;

            @(negedge clk);
            @(negedge clk);
            @(negedge clk);

            transfer = 1'b0;
            write    = 1'b0;

            addr  = 32'b0;
            wdata = 32'b0;

            @(negedge clk);

        end

    endtask

    initial begin

        clk = 1'b0;
        reset_n = 1'b0;

        transfer = 1'b0;
        addr = 32'b0;
        wdata = 32'b0;
        write = 1'b0;

        $display("==============================");
        $display("DMA TEST START");
        $display("==============================");

        #20;

        reset_n = 1'b1;

        $display("RESET RELEASED : %0t", $time);

        apb_write(32'h00000008, 32'd0);

        $display(
            "SOURCE ADDRESS CONFIGURED : %0t",
            $time
        );

        apb_write(32'h0000000C, 32'd100);

        $display(
            "DESTINATION ADDRESS CONFIGURED : %0t",
            $time
        );

        apb_write(32'h00000010, 32'd4);

        $display(
            "LENGTH CONFIGURED : %0t",
            $time
        );

        apb_write(32'h00000000, 32'h00000001);

        $display(
            "DMA STARTED : %0t",
            $time
        );

        #300;

        $display("==============================");
        $display("DMA TEST FINISHED : %0t", $time);
        $display("==============================");

        $finish;

    end

    initial begin

        $dumpfile("dma_waveform.vcd");
        $dumpvars(0, tb_dma_top);

    end

endmodule
