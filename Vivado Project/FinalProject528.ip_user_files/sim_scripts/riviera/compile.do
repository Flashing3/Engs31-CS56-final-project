vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 \
"C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"//thayerfs/f00372q/Desktop/Final Project/528 afternoon/lab6/lab6.srcs/sources_1/ip/Chinese_music/Chinese_music_sim_netlist.vhdl" \


vlog -work xil_defaultlib \
"glbl.v"

