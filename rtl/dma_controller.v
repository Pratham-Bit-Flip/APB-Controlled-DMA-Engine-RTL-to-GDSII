module dma_controller ( input clk,
                input reset_n,
                input start,
                input src_rvalid,
                input dst_ready,
                input count_last,

                output reg load_config,
                output reg load_data,
                output reg inc_addr,
                output reg dec_count,
                output reg src_read,
                output reg dst_write,
                output reg busy,
                output reg done
                );


    parameter IDLE   = 3'b000;
    parameter READ   = 3'b001;
    parameter WRITE  = 3'b010;
    parameter UPDATE = 3'b011;
    parameter DONE   = 3'b100;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // State register

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state logic

    always @(*) begin

        next_state = current_state;

        case (current_state)

            IDLE: begin
                if (start)
                    next_state = READ;
                else
                    next_state = IDLE;
            end

            READ: begin
                if (src_rvalid)
                    next_state = WRITE;
                else
                    next_state = READ;
            end

            WRITE: begin
                if (dst_ready)
                    next_state = UPDATE;
                else
                    next_state = WRITE;
            end

            UPDATE: begin
                if (count_last)
                    next_state = DONE;
                else
                    next_state = READ;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end

    // Output/control logic

    always @(*) begin

    //Initial

        load_config = 1'b0;
        load_data   = 1'b0;
        inc_addr    = 1'b0;
        dec_count   = 1'b0;

        src_read    = 1'b0;
        dst_write   = 1'b0;

        busy        = 1'b0;
        done        = 1'b0;

        case (current_state)

            IDLE: begin
                busy = 1'b0;
                if (start)
                    load_config = 1'b1;
            end

            READ: begin
                busy     = 1'b1;
                src_read = 1'b1;
                if (src_rvalid)
                    load_data = 1'b1;
            end

            WRITE: begin
                busy      = 1'b1;
                dst_write = 1'b1;
            end

            UPDATE: begin
                busy     = 1'b1;
                inc_addr = 1'b1;
                dec_count = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

            default: begin
                busy = 1'b0;
                done = 1'b0;
            end
        endcase
    end

endmodule
