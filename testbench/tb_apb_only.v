`timescale 1ns/1ps

module tb_apb_only;

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


    //====================================================
    // DUT
    //====================================================

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


    //====================================================
    // CLOCK
    //====================================================

    always #5 clk = ~clk;


    //====================================================
    // SOURCE MEMORY
    //====================================================

    always @(posedge clk or negedge reset_n) begin

        if (!reset_n) begin
            src_mem_valid <= 1'b0;
            src_mem_rdata <= 32'b0;
        end

        else begin

            src_mem_valid <= 1'b0;

            if (src_mem_read) begin

                src_mem_valid <= 1'b1;

                case (src_mem_addr)

                    32'd0:
                        src_mem_rdata <= 32'hAAAA1111;

                    default:
                        src_mem_rdata <= 32'h00000000;

                endcase

            end

        end

    end


    //====================================================
    // DESTINATION MEMORY
    //====================================================

    always @(posedge clk or negedge reset_n) begin

        if (!reset_n)
            dst_mem_ready <= 1'b1;
        else
            dst_mem_ready <= 1'b1;

    end


    //====================================================
    // APB WRITE
    //====================================================

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


    //====================================================
    // TEST
    //====================================================

    initial begin

        clk = 1'b0;
        reset_n = 1'b0;

        transfer = 1'b0;
        addr = 32'b0;
        wdata = 32'b0;
        write = 1'b0;

        src_mem_rdata = 32'b0;
        src_mem_valid = 1'b0;

        dst_mem_ready = 1'b1;


        $display("==============================");
        $display("DMA TEST START");
        $display("==============================");

        #20;

        reset_n = 1'b1;

        $display("RESET RELEASED %0t", $time);


        // Source = 0
        apb_write(32'h08, 32'd0);

        $display("SOURCE CONFIGURED %0t", $time);


        // Destination = 100
        apb_write(32'h0C, 32'd100);

        $display("DESTINATION CONFIGURED %0t", $time);


        // Length = 1
        apb_write(32'h10, 32'd1);

        $display("LENGTH CONFIGURED %0t", $time);


        // Start
        apb_write(32'h00, 32'h1);

        $display("DMA STARTED %0t", $time);


        #200;

        $display("DMA TEST FINISHED %0t", $time);

        $finish;

    end


    //====================================================
    // DEBUG MONITOR
    //====================================================

    always @(posedge clk) begin

        if (reset_n) begin

            $display(
                "TIME=%0t STATE=%b start=%b src_read=%b src_valid=%b src_rvalid=%b dst_write=%b dst_ready=%b count=%0d",
                $time,
                dut.u_dma_controller.current_state,
                dut.dma_start,
                dut.src_read,
                src_mem_valid,
                dut.src_rvalid,
                dut.dst_write,
                dut.dst_ready,
                dut.count
            );

        end

    end


    //====================================================
    // WAVEFORM
    //====================================================

    initial begin
        $dumpfile("dma_waveform.vcd");
        $dumpvars(0, tb_apb_only);
    end

endmodule
