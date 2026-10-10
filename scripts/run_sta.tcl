read_liberty $::env(LIB)
read_verilog dma_top_sky130.v
link_design dma_top

read_sdc dma_top.sdc

puts "\n===== DESIGN CHECK ====="
check_setup -verbose

puts "\n===== WORST SETUP PATHS ====="
report_checks -path_delay max -format full_clock_expanded -group_path_count 10

puts "\n===== WORST HOLD PATHS ====="
report_checks -path_delay min -format full_clock_expanded -group_path_count 10

puts "\n===== WORST SETUP SLACK ====="
report_worst_slack -max

puts "\n===== WORST HOLD SLACK ====="
report_worst_slack -min

exit
