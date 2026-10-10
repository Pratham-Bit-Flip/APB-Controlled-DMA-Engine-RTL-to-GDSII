module dma_top (input clk,
            input reset_n,

            input transfer,
            input [31:0] addr,
            input [31:0] wdata,
            input write,

            output [31:0] rdata,

            output [31:0] src_mem_addr,
            output src_mem_read,
            input [31:0] src_mem_rdata,
            input src_mem_valid,

            output [31:0] dst_mem_addr,
            output [31:0] dst_mem_wdata,
            output dst_mem_write,
            input dst_mem_ready
            );

    // APB signals
    wire pselx;
    wire penable;
    wire [31:0] paddr;
    wire [31:0] pwdata;
    wire pwrite;
    wire pready;
    wire [31:0] prdata;

    // DMA register signals
    wire dma_start;
    wire [31:0] src_addr_reg;
    wire [31:0] dst_addr_reg;
    wire [31:0] length_reg;

    // DMA status signals
    wire dma_busy;
    wire dma_done;
    wire dma_error;

    // DMA controller signals
    wire load_config;
    wire load_data;
    wire inc_addr;
    wire dec_count;
    wire src_read;
    wire dst_write;

    // DMA datapath signals
    wire [31:0] src_addr;
    wire [31:0] dst_addr;
    wire [31:0] data_buf;
    wire count_last;

    // Memory interface signals
    wire [31:0] src_rdata;
    wire src_rvalid;
    wire dst_ready;


    assign dma_error = 1'b0;


    // APB MASTER

    apb_master u_apb_master (
        .clk(clk),
        .reset_n(reset_n),
        .transfer(transfer),
        .addr(addr),
        .wdata(wdata),
        .write(write),
        .pselx(pselx),
        .penable(penable),
        .paddr(paddr),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .pready(pready),
        .prdata(prdata),
        .rdata(rdata)
    );


    // APB REGISTER BLOCK

    apb_reg u_apb_reg (
        .clk(clk),
        .reset_n(reset_n),
        .pselx(pselx),
        .penable(penable),
        .paddr(paddr),
        .pwdata(pwdata),
        .pwrite(pwrite),
        .prdata(prdata),
        .pready(pready),
        /* verilator lint_off PINCONNECTEMPTY */
        .pslverr(),
        /* verilator lint_on PINCONNECTEMPTY */
        .dma_start(dma_start),
        .src_addr_reg(src_addr_reg),
        .dst_addr_reg(dst_addr_reg),
        .length_reg(length_reg),
        .dma_busy(dma_busy),
        .dma_done(dma_done),
        .dma_error(dma_error)
    );


    // DMA CONTROLLER

    dma_controller u_dma_controller (
        .clk(clk),
        .reset_n(reset_n),
        .start(dma_start),
        .src_rvalid(src_rvalid),
        .dst_ready(dst_ready),
        .count_last(count_last),
        .load_config(load_config),
        .load_data(load_data),
        .inc_addr(inc_addr),
        .dec_count(dec_count),
        .src_read(src_read),
        .dst_write(dst_write),
        .busy(dma_busy),
        .done(dma_done)
    );


    // DMA DATAPATH

    dma_datapath u_dma_datapath (
        .clk(clk),
        .reset_n(reset_n),
        .src_addr_reg(src_addr_reg),
        .dst_addr_reg(dst_addr_reg),
        .length_reg(length_reg),
        .load_config(load_config),
        .load_data(load_data),
        .inc_addr(inc_addr),
        .dec_count(dec_count),
        .src_rdata(src_rdata),
        .src_addr(src_addr),
        .dst_addr(dst_addr),
        .data_buf(data_buf),
        .count_last(count_last)
    );


    // MEMORY INTERFACE

    mem_interface u_mem_interface (
        .src_addr(src_addr),
        .dst_addr(dst_addr),
        .data_buf(data_buf),
        .src_read(src_read),
        .dst_write(dst_write),
        .src_mem_addr(src_mem_addr),
        .src_mem_read(src_mem_read),
        .src_mem_rdata(src_mem_rdata),
        .src_mem_valid(src_mem_valid),
        .dst_mem_addr(dst_mem_addr),
        .dst_mem_wdata(dst_mem_wdata),
        .dst_mem_write(dst_mem_write),
        .dst_mem_ready(dst_mem_ready),
        .src_rdata(src_rdata),
        .src_rvalid(src_rvalid),
        .dst_ready(dst_ready)
    );

endmodule
