vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vcom -work xil_defaultlib -64 -93 \
"../../../../dsed_audio.srcs/sources_1/ip/RAM/RAM_sim_netlist.vhdl" \


