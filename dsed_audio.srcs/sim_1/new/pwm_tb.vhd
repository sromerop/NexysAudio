----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2017 12:15:05
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
-- Project Name: 
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.package_dsed.all;

entity pwm_tb is
--  Port ( );
end pwm_tb;

architecture Behavioral of pwm_tb is

component pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end component;

component en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end component;

signal clk_12megas, reset, en_2_cycles, enable, sample_request, pwm_pulse : STD_LOGIC := '0';
signal en_4_cycles1, clk_3megas : STD_LOGIC := '0';
signal a : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "01100011";
signal b : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "10001001";
signal c : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00100000";
signal sample_in : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00000000";

constant c_period : time := 83 ns;
--constant en_period : time := 167 ns;

begin

 PWM_P: pwm port map(
     clk_12megas =>  clk_12megas,
     reset => reset,
     en_2_cycles => en_2_cycles,
     enable => enable,
     sample_in => sample_in,
     sample_request => sample_request,
     pwm_pulse => pwm_pulse
 );

EN_4: en_4_cycles port map(
     clk_12megas =>  clk_12megas,
     reset => reset,
     clk_3megas => clk_3megas,
     en_2_cycles => en_2_cycles,
     en_4_cycles => en_4_cycles1
 );
	process
	
    begin
       clk_12megas <= '0';
       wait for c_period/2;  
       clk_12megas <= '1';
       wait for c_period/2;  
    end process;
    
--    	process
    
--    begin
--       en_2_cycles <= '0';
--       wait for en_period/2;  
--       en_2_cycles <= '1';
--       wait for en_period/2;  
--    end process;
    
        process
    begin
--        reset <= '1';
--        wait for 2 ns;
        reset <= '0';
        enable <= '0';
        wait for 125 ns;
        enable <= '1';
        wait;
     end process;


        process
    begin
--        sample_in <= "11111111";
--        sample_in <= "00000000";
        a <= not a after 1300 ns;
        b <= not b after 2100 ns;
        c <= not c after 3700 ns;
        sample_in <= a xor b xor c;
        wait for 20 ns;        
    end process;
    
end Behavioral;