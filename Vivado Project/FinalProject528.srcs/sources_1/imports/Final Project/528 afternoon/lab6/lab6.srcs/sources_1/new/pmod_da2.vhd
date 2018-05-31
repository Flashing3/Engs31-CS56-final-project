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

ENTITY pmod_da2 IS
PORT (
		sclk2	:	in	STD_Logic;	
        take_sample2 : in STD_LOGIC;    
        
        spi_sdata2	: 	IN STD_LOGIC_vector(11 downto 0);  
        
           spi_sclk2  :	 out STD_LOGIC;
            spi_cs2    :  out STD_LOGIC;   
                  
          da_data_speaker	: 	out STD_LOGIC);
end pmod_da2;


ARCHITECTURE behavior of pmod_da2 is

type state_type is (waiting,load, shift );
signal current_state, next_state : state_type;

signal total_count : STD_LOGIC := '0';
signal count : integer := 15;
signal ser_data_reg : STD_LOGIC_VECTOR(15 downto 0) := (others=>'0');
signal shift_en : STD_LOGIC := '0';
signal load_en : STD_LOGIC := '0';


BEGIN
   spi_sclk2<=sclk2;
    --State update process for the finite state machine
	stateUpdate: process(sclk2)
    begin
  
 		if rising_edge(sclk2) then
        	current_state <= next_state;
        end if;
    end process stateUpdate;


	--Next state logic for the finite state machine
	nextStateLogic: process(current_state, total_count, take_sample2)
    begin
   			shift_en <= '0';
            load_en <= '0';
            next_state <= current_state;
    
		case (current_state) is
        	
            
        	when load => 	
            		     	load_en <= '1';
                             spi_cs2<='1';
                               next_state<=waiting;
                             
                           
                            
            when shift =>	
            				shift_en <= '1';
            				 spi_cs2<='0';
            				if total_count = '1' then
                            	next_state <= load;
                            end if;
                            
            when waiting=>  
            				load_en <='0';
            				shift_en <='0';
            				 spi_cs2<='1';
            			
               				
                            if take_sample2 ='1' then
                               next_state<=shift;
                            end if;
                            
           	when others => next_state <= waiting;
            
        end case;
			
	end process nextStateLogic;
    
    
    --Shift Register datapath component
    shift_register : process(sclk2,shift_en)
    begin
    	--ser_data_reg <= ser_data_reg;
        if rising_edge(sclk2) then
    		if shift_en = '1' then
        		da_data_speaker <=ser_data_reg(count);
        	end if;
        end if;
    
    end process shift_register;
    
    
     load_register : process(sclk2,load_en)
     begin
       -- in this process, output the last 12 bits
       if rising_edge(sclk2) then
      	 if load_en = '1' then
     	 	ser_data_reg(15 downto 0)<= "0000" & spi_sdata2 ;
         end if;
        end if;
      end process load_register;
      
      
    counter : process(sclk2,shift_en,load_en,count)
    begin
    	
    	if rising_edge(sclk2) then
    	
          total_count <= '0';
        	if shift_en = '1' then
              count <= count - 1;
              if count = 0 then
                  total_count <= '1';        --the last bit has been shifted out
                  count <= 15;
      		  end if;
            --elsif load_en = '1' then
            	--count <= 11;                 --next 12 bits loaded in, start from the 12th bit again
            
           end if;
            
        end if;
    end process counter;
    
    --Wire up the output of the least significant bit of the register to the serial out pin
  
    
end behavior;
        
        