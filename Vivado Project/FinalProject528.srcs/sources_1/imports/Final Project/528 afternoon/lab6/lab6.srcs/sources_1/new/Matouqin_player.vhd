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

ENTITY Matouqin_player IS
PORT (
		clk	:	in	STD_Logic;	
        enable : in STD_LOGIC;                             
        matouqin_rom_addr : out std_logic_vector(16 downto 0));
       
end Matouqin_player;


ARCHITECTURE behavior of Matouqin_player is

signal rom_addr : unsigned(16 downto 0) := "0" & "1001110001000010";
signal matouqin_start :unsigned:= "0" & "1001110001000010";         --40002
signal frequencycounter : UNSIGNED(9 downto 0) := "0000000000";



BEGIN
   Read_counter: process(clk, enable)
begin
    if rising_edge(clk) then    
       if(enable = '1') then
  
                if rom_addr=60002 then
                          rom_addr<=matouqin_start;                                                                                 
                 end if;  
                               
                      frequencycounter<= frequencycounter + 1;           
                      if frequencycounter = 10 then                      --20M(20kk)-200khz, here divided to 20khz
                       rom_addr <= rom_addr + 1;
                        matouqin_rom_addr <= std_logic_vector(rom_addr);           
                        frequencycounter <="0000000000";                      
                      end if; 
          elsif enable='0' then
                     rom_addr<=matouqin_start;
                               
     end if;
  end if;
 end process read_counter;
    
end behavior;
        
        