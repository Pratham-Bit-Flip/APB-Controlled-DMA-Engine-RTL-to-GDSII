module apb_reg (input clk,
            input reset_n,
            input pselx,
            input penable,
            input [31:0] paddr,
            input [31:0] pwdata,
            input pwrite,

            output pready,
            output reg [31:0] prdata,
            output pslverr,

            output reg dma_start,
            output reg [31:0] src_addr_reg,
            output reg [31:0] dst_addr_reg,
            output reg [31:0] length_reg,

            input dma_busy,
            input dma_done,
            input dma_error
);

    reg [31:0] ctrl_reg;

    assign pready  = 1'b1;
    assign pslverr = 1'b0;

// APB WRITE
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ctrl_reg     <= 32'b0;
            dma_start    <= 1'b0;
            src_addr_reg <= 32'b0;
            dst_addr_reg <= 32'b0;
            length_reg   <= 32'b0;
        end

        else begin

// START -> 1 clk pulse

            dma_start <= 1'b0;

            if (pselx && penable && pwrite) begin
                case (paddr)

                    32'h00000000:
                        begin
                            ctrl_reg <= pwdata;
                            if (pwdata[0])
                                dma_start <= 1'b1;
                        end
                    32'h00000008:
                        src_addr_reg <= pwdata;
                    32'h0000000C:
                        dst_addr_reg <= pwdata;
                    32'h00000010:
                        length_reg <= pwdata;
                    default:
                        begin
                        end

                endcase
            end
        end
    end

// APB READ
    always @(*) begin
        prdata = 32'b0;

        if (pselx && penable && !pwrite) begin
            case (paddr)

                32'h00000000:
                    prdata = ctrl_reg;
                32'h00000004:
                    prdata = {29'b0, dma_error, dma_done, dma_busy};
                32'h00000008:
                    prdata = src_addr_reg;
                32'h0000000C:
                    prdata = dst_addr_reg;
                32'h00000010:
                    prdata = length_reg;

                default:
                    prdata = 32'b0;

            endcase
        end
    end

endmodule
