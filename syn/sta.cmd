read_liberty /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog hgcd_gl.v
link_design hgcd
create_clock -name clk -period 5
set_input_delay -clock clk 0 {reset a b clk}
set_output_delay -clock clk 0 {q rdy}
report_checks
report_power
exit
