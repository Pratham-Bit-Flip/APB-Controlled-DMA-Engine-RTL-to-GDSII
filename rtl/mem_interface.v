module mem_interface (
    // From DMA datapath
                input  [31:0] src_addr,
                input  [31:0] dst_addr,
                input  [31:0] data_buf,

    // Control from DMA controller
                input         src_read,
                input         dst_write,

    // Source memory interface
                output reg [31:0] src_mem_addr,
                output reg        src_mem_read,
                input      [31:0] src_mem_rdata,
                input             src_mem_valid,

    // Destination memory interface
                output reg [31:0] dst_mem_addr,
                output reg [31:0] dst_mem_wdata,
                output reg        dst_mem_write,
                input             dst_mem_ready,

    // Back to DMA controller
                output reg [31:0] src_rdata,
                output reg        src_rvalid,
                output reg        dst_ready
                );

    always @(*) begin
        src_mem_addr  = src_read  ? src_addr : 32'b0;
        src_mem_read  = src_read;
        src_rdata     = (src_read && src_mem_valid) ? src_mem_rdata : 32'b0;
        src_rvalid    = src_read && src_mem_valid;

        dst_mem_addr  = dst_write ? dst_addr : 32'b0;
        dst_mem_wdata = dst_write ? data_buf : 32'b0;
        dst_mem_write = dst_write;
        dst_ready     = dst_write && dst_mem_ready;
    end

endmodule
