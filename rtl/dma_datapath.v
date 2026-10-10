module dma_datapath (input clk,
                    input reset_n,

                    input [31:0] src_addr_reg,
                    input [31:0] dst_addr_reg,
                    input [31:0] length_reg,
                    input load_config,
                    input load_data,
                    input inc_addr,
                    input dec_count,
                    input [31:0] src_rdata,

                    output reg [31:0] src_addr,
                    output reg [31:0] dst_addr,
                    output reg [31:0] data_buf,

                    output count_last
);

    reg [31:0] count;

    always @(posedge clk or negedge reset_n) begin

        if (!reset_n) begin

            src_addr <= 32'b0;
            dst_addr <= 32'b0;
            count    <= 32'b0;
            data_buf <= 32'b0;

        end

        else begin

            if (load_config) begin
                src_addr <= src_addr_reg;
                dst_addr <= dst_addr_reg;
                count    <= length_reg;
            end

            if (load_data) begin
                data_buf <= src_rdata;
            end

            if (inc_addr) begin
                src_addr <= src_addr + 32'd4;
                dst_addr <= dst_addr + 32'd4;
            end

            if (dec_count) begin
                count <= count - 32'd1;
            end

        end
    end

    assign count_last = (count == 32'd1);

endmodule
