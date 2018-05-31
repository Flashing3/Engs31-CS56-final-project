-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.3.1 (win64) Build 2035080 Fri Oct 20 14:20:01 MDT 2017
-- Date        : Sat May 26 13:47:46 2018
-- Host        : MECHA-7 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               O:/ENGS31/Demo/lab6/lab6.srcs/sources_1/ip/Chinese_music/Chinese_music_stub.vhdl
-- Design      : Chinese_music
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Chinese_music is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 16 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end Chinese_music;

architecture stub of Chinese_music is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,addra[16:0],douta[15:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_0,Vivado 2017.3.1";
begin
end;
