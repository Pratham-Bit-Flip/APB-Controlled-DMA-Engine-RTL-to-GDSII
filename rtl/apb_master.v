module apb_master(input clk,
            input reset_n,
            input transfer,
            input [31:0]addr,
            input [31:0]wdata,
            input write,
            output reg pselx,
            output reg penable,
            output reg [31:0]paddr,
            output reg [31:0]pwdata,
            output reg pwrite,
            input pready,
            input [31:0]prdata,
            output reg [31:0]rdata);

        parameter IDLE   = 2'b00;
        parameter SETUP  = 2'b01;
        parameter ACCESS = 2'b10;

        reg [1:0] prnt_state,nxt_state;

        always @(posedge clk or negedge reset_n) begin
             if(!reset_n)
                prnt_state <= IDLE;
             else
                prnt_state <= nxt_state;
            end

        always @(*) begin

    nxt_state = prnt_state;

    case (prnt_state)

        IDLE: begin
            if (transfer)
                nxt_state = SETUP;
            else
                nxt_state = IDLE;
        end

        SETUP: begin
            nxt_state = ACCESS;
        end

        ACCESS: begin
            if (pready == 1'b1) begin
                if (transfer)
                    nxt_state = SETUP;
                else
                    nxt_state = IDLE;
            end
            else begin
                nxt_state = ACCESS;
            end
        end

        default: begin
            nxt_state = IDLE;
        end

    endcase

end

        always @(posedge clk or negedge reset_n)
            begin
            if(!reset_n)
                begin
                    pselx <= 0;
                    penable <= 0;
                    paddr <= 0;
                    pwdata <= 0;
                    pwrite <= 0;
                    rdata <= 0;
                end

            else
                begin
                    case(prnt_state)

                        IDLE :begin
                            pselx <= 1'b0;
                            penable <= 1'b0;

                            end

                        SETUP : begin
                            pselx <= 1'b1;
                            penable <= 1'b0;
                            paddr <= addr;
                            pwdata <= wdata;
                            pwrite <= write;

                            end

                        ACCESS :begin
                            pselx <= 1'b1;
                            penable <= 1'b1;

                            if(pready && !pwrite)
                                rdata <= prdata;

                            end
                        default: begin
                            pselx <= 1'b0;
                            penable <= 1'b0;
end
                    endcase

                    end
                    end
endmodule
