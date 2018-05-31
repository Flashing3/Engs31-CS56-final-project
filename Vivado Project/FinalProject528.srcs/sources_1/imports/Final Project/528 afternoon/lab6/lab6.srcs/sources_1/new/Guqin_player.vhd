----------------------------------------------------------------------------------
-- Company: ENGS31
-- Engineer: Suchen Shi& Junfei Yu
-- 
-- Create Date: 05/02/2018 06:18:04 PM
-- Design Name: 
-- Module Name: pmod_ad1 - Behavioral
-- Project Name: SPI Bus
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY Guqin_player IS
PORT (
		clk	:	in	STD_Logic;	
        enable : in STD_LOGIC;                             
        guqin_rom_addr : out std_logic_vector(16 downto 0));
       
end Guqin_player;


ARCHITECTURE behavior of Guqin_player is

signal rom_addr : unsigned(16 downto 0) :=  "00" & "100111000100001";
signal guqin_start :unsigned:= "00" & "100111000100001";         --20001
signal frequencycounter : UNSIGNED(9 downto 0) := "0000000000";
signal guqin_sig: std_logic := '0';  


BEGIN
   Read_counter: process(clk, enable)
begin
    if rising_edge(clk) then    
       if(enable = '1') then
  
                if rom_addr=40001 then
                          rom_addr<=guqin_start;                                                                               
                 end if;  
                               
                      frequencycounter<= frequencycounter + 1;           
                      if frequencycounter = 10 then                      --20M(20kk)-200khz, here divided to 20khz
                       rom_addr <= rom_addr + 1;
                        guqin_rom_addr <= std_logic_vector(rom_addr);           
                        frequencycounter <="0000000000";                      
                      end if; 
            elsif enable='0' then
                rom_addr<=guqin_start;
                               
     end if;
  end if;
 end process read_counter;
    
end behavior;
        
        