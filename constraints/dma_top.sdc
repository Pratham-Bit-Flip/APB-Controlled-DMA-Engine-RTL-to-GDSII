create_clock -name clk -period 20.000 [get_ports clk]

# External input timing assumptions
set_input_delay 2.000 -clock clk [get_ports {transfer write}]
set_input_delay 2.000 -clock clk [get_ports {addr[*] wdata[*]}]
set_input_delay 2.000 -clock clk [get_ports {src_mem_rdata[*] src_mem_valid dst_mem_ready}]

# External output timing assumptions
set_output_delay 2.000 -clock clk [get_ports {rdata[*]}]
set_output_delay 2.000 -clock clk [get_ports {src_mem_addr[*] src_mem_read}]
set_output_delay 2.000 -clock clk [get_ports {dst_mem_addr[*] dst_mem_wdata[*] dst_mem_write}]

# Asynchronous reset is not ordinary clocked data
set_false_path -from [get_ports reset_n]
