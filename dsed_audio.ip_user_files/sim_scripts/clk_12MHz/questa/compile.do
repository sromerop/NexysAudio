vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/xpm

vmap xil_defaultlib msim/xil_defaultlib
vmap xpm msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../dsed_audio.srcs/sources_1/ip/clk_12MHz" "+incdir+../../../../dsed_audio.srcs/sources_1/ip/clk_12MHz" \
"C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2017.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../dsed_audio.srcs/sources_1/ip/clk_12MHz/clk_12MHz_sim_netlist.vhdl" \


vlog -work xil_defaultlib \
"glbl.v"

