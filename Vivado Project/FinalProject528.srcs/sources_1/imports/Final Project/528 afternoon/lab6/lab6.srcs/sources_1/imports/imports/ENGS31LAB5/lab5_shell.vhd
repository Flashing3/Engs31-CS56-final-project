----------------------------------------------------------------------------------
-- Company: 			Engs 31 16X
-- Engineer: 			Eric Hansen
-- Edited by            Suchen Shi & Junfei Yu  5/11/2018
-- Create Date:    	 	07/22/2016
-- Design Name: 		
-- Module Name:    		lab6_top 
-- Project Name: 		Lab6
-- Target Devices: 		Digilent Basys3 (Artix 7)
-- Tool versions: 		Vivado 2016.1
-- Description: 		SPI Bus lab
--				
-- Dependencies: 		mux7seg, multiplexed 7 segment display
--						pmod_ad1, SPI bus interface to Pmod AD1
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;			-- needed for arithmetic

library UNISIM;						-- needed for the BUFG component
use UNISIM.Vcomponents.ALL;

entity Lab5 is
port (
      mclk		: in std_logic;	    -- FPGA board master clock (100 MHz)
	                                  -- SPI bus interface to Pmod_DA2    
      spi_sdata                 : in std_logic;
      
      button_dizi               : in std_logic;              -- monopulsed inputs
      button_guqin              : in std_logic;
      button_matouqin           : in std_logic;
      button_drum               : in std_logic;
      button_wood               : in std_logic;
      
      record_switch             : in std_logic;
      clear_switch              : in std_logic;           -- switch for clearing data in register  
      play_switch               : in std_logic;
                
      spi_sclk2                 : out std_logic;
      spi_cs2                   : out std_logic;
      da_data_speaker	        : out STD_LOGIC);
      
end Lab5; 

architecture Behavioral of Lab5 is

-- COMPONENT DECLARATIONS


component pmod_da2 is
PORT (
		sclk2	        : in STD_Logic;	
        take_sample2    : in STD_LOGIC;    
        spi_sdata2	    : in STD_LOGIC_vector(11 downto 0);  
        spi_sclk2       : out STD_LOGIC;
        spi_cs2         : out STD_LOGIC;         
        da_data_speaker	: out STD_LOGIC);
end component;


component Chinese_music is
PORT (
        clka            : in STD_LOGIC;
        ena             : in STD_LOGIC;
        addra           : in STD_LOGIC_VECTOR(16 DOWNTO 0);
        douta           : out STD_LOGIC_VECTOR(15 DOWNTO 0));
end component;

component Dizi_player is
PORT (
		clk	            : in STD_Logic;	
        enable          : in STD_LOGIC;                             
        dizi_rom_addr   : out std_logic_vector(16 downto 0));
       
end component;

component Guqin_player is
PORT (
		clk           	: in STD_Logic;	
        enable          : in STD_LOGIC;                             
        guqin_rom_addr  : out std_logic_vector(16 downto 0));
       
end component;

component Matouqin_player is
PORT (
		clk	            : in STD_Logic;	
        enable          : in STD_LOGIC;                             
        matouqin_rom_addr : out std_logic_vector(16 downto 0));
       
end component;

component Drum_player is
PORT (
		clk	            : in STD_Logic;	
        enable          : in STD_LOGIC;                             
        drum_rom_addr   : out std_logic_vector(16 downto 0));
       
end component;

component Wood_player is
PORT (
		clk	            : in STD_Logic;	
        enable          : in STD_LOGIC;                             
        wood_rom_addr   : out std_logic_vector(16 downto 0));
       
end component;


-------------------------------------------------
-- SIGNAL DECLARATIONS 
-- Signals for the serial clock divider, which divides the 100 MHz clock down to 1 MHz
constant SCLK_DIVIDER_VALUE: integer := 100 ;   --change from 100/2  
constant COUNT_LEN: integer := 50;
signal sclkdiv: unsigned(COUNT_LEN-1 downto 0) := (others => '0');  -- clock divider counter
signal sclk_unbuf: std_logic := '0';    -- unbuffered serial clock 
signal sclk: std_logic := '0';          -- internal serial clock
signal sclk2: std_logic := '0'; 

signal samplecounter : UNSIGNED(19 downto 0) := "00000000000000000000";

-- SIGNAL DECLARATIONS FOR YOUR CODE GO HERE
signal ad_data: std_logic_vector(11 downto 0) := (others => '0');	-- A/D output

signal rom_out : std_logic_vector(15 downto 0) := (others => '0');

-- Signals for the sampling clock, which ticks at 10 Hz
signal take_sample : std_logic := '0';

--Signals for rom
signal rom_en: std_logic := '0';   
signal out_data : std_logic_vector(16 downto 0) := (others => '0');	
signal out_data_dizi : std_logic_vector(16 downto 0) := (others => '0');
signal out_data_guqin : std_logic_vector(16 downto 0) := "00" & "100111000100001";	
signal out_data_matouqin : std_logic_vector(16 downto 0) :="0" & "1001110001000010";
signal out_data_drum : std_logic_vector(16 downto 0) := "0" & "1110101001100011";
signal out_data_wood : std_logic_vector(16 downto 0) := "10011100010000100";


--Signals for pmod_da2
signal take_sample2 : std_logic := '0';
--unsiged value for rom address
signal rom_addr : unsigned(16 downto 0) := "00000000000000000";
signal ena: std_logic := '1'; 
signal frequencycounter : UNSIGNED(9 downto 0) := "0000000000";

--enable signals
signal dizi_enable: std_logic := '0'; 
signal guqin_enable: std_logic := '0'; 
signal matouqin_enable: std_logic := '0'; 
signal drum_enable: std_logic := '0'; 
signal wood_enable: std_logic := '0'; 


signal player_counter: integer := 0;

constant array_size: integer :=10;
type regfile is array(0 to array_size) of STD_LOGIC_VECTOR(2 downto 0);
signal recorder_reg: regfile;

signal w_addr: integer :=0;
signal r_addr: integer :=0;
signal record_counter: integer :=0;
signal play_counter: integer :=0;

signal play_en: std_logic := '0'; 
                                     
                                        
-------------------------------------------------
          
begin

ad_data <= "000" & rom_out(11 downto 3); 
 
 
uut2: pmod_da2 port map( 
                             sclk2 =>sclk,
                             take_sample2=> take_sample,               
                             spi_sdata2=> ad_data,    
                             spi_sclk2 => spi_sclk2,
                             spi_cs2 => spi_cs2,                              
                             da_data_speaker => da_data_speaker);    
         
Rom: Chinese_music port map(
                             clka =>sclk,
                             ena =>take_sample,        
                             addra => out_data,
                             douta  => rom_out);        
            
Dizi: Dizi_player port map(
                             clk =>sclk,
                             enable =>dizi_enable,        
                             dizi_rom_addr => out_data_dizi);
                                  
Guqin: Guqin_player port map(
                             clk =>sclk,
                             enable =>guqin_enable,        
                             guqin_rom_addr => out_data_guqin);   
                                 
Matouqin: Matouqin_player port map(
                             clk =>sclk,
                             enable =>matouqin_enable,        
                             matouqin_rom_addr => out_data_matouqin); 
                                  
Drum: Drum_player port map(
                             clk =>sclk,
                             enable =>drum_enable,        
                             drum_rom_addr => out_data_drum);                            
          
Wood: Wood_player port map(
                             clk =>sclk,
                             enable => wood_enable,        
                             wood_rom_addr => out_data_wood); 
                             
                             
AddressUpdataLogic: process(sclk,record_switch,play_switch)
begin
if rising_edge(sclk) then
        if record_switch='1' then
                record_counter<=record_counter+1;
                if record_counter=180000 then   
                        w_addr<=w_addr+1;
                        record_counter<=0;
                end if;
                       
                if w_addr=array_size then
                        w_addr<=0;
                end if;
              
        elsif play_switch='1' then        
                play_counter<=play_counter+1;
                if play_counter=180000 then   
                        r_addr<=r_addr+1;                     
                        play_counter<=0;                    
                end if;   
                               
                if r_addr=array_size then
                        r_addr<=0;
                end if;                              
                                                           
        end if;
end if;
end process AddressUpdataLogic;



Controller: process (sclk,button_dizi,button_guqin, button_matouqin, button_drum, button_wood,record_switch,clear_switch,play_switch)
begin
if rising_edge(sclk) then      
        if button_dizi ='1' then
                dizi_enable <='1';        
                guqin_enable<='0';
                matouqin_enable<='0';
                drum_enable<='0';
                wood_enable<='0';
                
        elsif button_guqin ='1' then
                guqin_enable <='1';
                dizi_enable<='0';               
                matouqin_enable<='0';
                drum_enable<='0';
                wood_enable<='0';
                
        elsif button_matouqin ='1' then
                matouqin_enable <='1';
                dizi_enable<='0';
                guqin_enable<='0';             
                drum_enable<='0';
                wood_enable<='0';
        
        elsif button_drum ='1' then
                drum_enable <='1'; 
                dizi_enable<='0';
                guqin_enable<='0';
                matouqin_enable<='0';                 
                wood_enable<='0';
        elsif button_wood ='1' then
                wood_enable <='1';   
                dizi_enable<='0';
                guqin_enable<='0';
                matouqin_enable<='0';
                drum_enable<='0';
                
        end if;
                                          
        if clear_switch = '1' then --this is used to reset the mixer. When this is on, all the data clear to 0.
            recorder_reg(0)<= "000";
            recorder_reg(1)<= "000";
            recorder_reg(2) <= "000";
            recorder_reg(3) <= "000";   -- testing
            recorder_reg(4) <= "000";
            recorder_reg(5) <= "000";
            recorder_reg(6) <= "000";
            recorder_reg(7) <= "000";
            recorder_reg(8) <= "000";
            recorder_reg(9) <= "000";
            recorder_reg(10) <= "000";
            
--            w_addr<=0;
--            r_addr<=0;
            
        elsif play_switch='1' then      
                if recorder_reg(r_addr)= "001"  then
                        dizi_enable<='1';
                        guqin_enable<='0';
                        matouqin_enable<='0';
                        drum_enable<='0';
                        wood_enable<='0';
                                                   
                elsif recorder_reg(r_addr)= "010" then
                        guqin_enable<='1';             
                        dizi_enable<='0';         
                        matouqin_enable<='0';
                        drum_enable<='0';
                        wood_enable<='0';
                                            
                elsif recorder_reg(r_addr)= "011" then
                        matouqin_enable<='1';
                        dizi_enable<='0';
                        guqin_enable<='0';                            
                        drum_enable<='0';
                        wood_enable<='0';
                                                     
                elsif recorder_reg(r_addr)= "100" then
                        drum_enable<='1';
                        dizi_enable<='0';
                        guqin_enable<='0';
                        matouqin_enable<='0';                                 
                        wood_enable<='0';
                                                          
                elsif recorder_reg(r_addr)= "101" then
                        wood_enable<='1';
                        dizi_enable<='0';
                        guqin_enable<='0';
                        matouqin_enable<='0';
                        drum_enable<='0';                                   
                      
                end if;
    
        elsif record_switch='1' then     
                if dizi_enable ='1' then
                        recorder_reg(w_addr)<="001";
   
                elsif guqin_enable ='1' then        
                        recorder_reg(w_addr)<="010";
                
                elsif matouqin_enable ='1' then        
                        recorder_reg(w_addr)<="011";
             
                elsif drum_enable ='1' then                  
                        recorder_reg(w_addr)<="100";
              
                elsif wood_enable ='1' then
                        recorder_reg(w_addr)<="101";
                
                else
                        recorder_reg(w_addr)<="000";

                end if;   
        
        end if;
    
    
    
        if dizi_enable ='1' or guqin_enable='1' or matouqin_enable='1' or drum_enable='1' or wood_enable='1' then
                player_counter<=player_counter+1;   
            
                if player_counter=180000 then
                        dizi_enable <='0';
                        guqin_enable <='0';
                        matouqin_enable <='0';
                        drum_enable <='0';
                        wood_enable <='0';
                        player_counter<=0;                              
                end if;
        
        end if;

end if;
end process Controller;


Playing: process( dizi_enable, guqin_enable, matouqin_enable, drum_enable, wood_enable)
begin 
        
    if dizi_enable='1' then           
            out_data<=out_data_dizi; 
         
    elsif guqin_enable ='1' then   
            out_data<=out_data_guqin;
          
    elsif matouqin_enable ='1' then
            out_data<=out_data_matouqin;
          
    elsif drum_enable ='1' then
            out_data<=out_data_drum;
        
    elsif wood_enable ='1' then
            out_data<=out_data_wood;
                                   
    end if;       
end process Playing;


Slow_clock_buffer: BUFG
	port map (I => sclk_unbuf,
		      O => sclk );
    
-- Divide the 100 MHz clock down to 2 MHz, then toggling a flip flop gives the final 
-- 1 MHz system clock
Serial_clock_divider: process(mclk)
begin
if rising_edge(mclk) then
        if sclkdiv = SCLK_DIVIDER_VALUE-1 then 
			sclkdiv <= (others => '0');
			sclk_unbuf <= NOT(sclk_unbuf);
		
		else
			sclkdiv <= sclkdiv + 1;
		
		end if;
end if;
end process Serial_clock_divider;
          
-- Further divide the 1 MHz clock down to a 10 Hz take_sample tick
Sample_counter: process(sclk,samplecounter)
begin
          
	if rising_edge(sclk) then
	    take_sample<='0'; 
	   	samplecounter<= samplecounter + 1;
	   	if samplecounter = 5 then
	   	       take_sample <= '1';
	   	       samplecounter <="00000000000000000000";
	   	end if;
	 	   	 
	end if;
end process Sample_counter;
		
end Behavioral; 