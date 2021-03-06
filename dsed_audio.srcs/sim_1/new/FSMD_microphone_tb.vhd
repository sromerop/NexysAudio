----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2017 13:12:50
-- Design Name: 
-- Module Name: FSMD_microphone_tb - Behavioral
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

entity FSMD_microphone_tb is
--  Port ( );
end FSMD_microphone_tb;

architecture Behavioral of FSMD_microphone_tb is
component FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           enable : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_out_ready : out STD_LOGIC);
end component;

component en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end component;

signal clk_12megas, reset, enable_4_cycles, enable, micro_data, sample_out_ready, clk_3megas, en_2_cycles : STD_LOGIC := '0';
signal a, b, c : STD_LOGIC := '0';
signal sample_out : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00000000";

constant c_period : time := 83 ns;
--constant en_period : time := 333 ns;

begin

 FSMD: FSMD_microphone port map(
     clk_12megas =>  clk_12megas,
     reset => reset,
     enable_4_cycles => enable_4_cycles,
     enable => enable,
     micro_data => micro_data,
     sample_out => sample_out,
     sample_out_ready => sample_out_ready
 );

EN_4: en_4_cycles port map(
     clk_12megas =>  clk_12megas,
     reset => reset,
     clk_3megas => clk_3megas,
     en_2_cycles => en_2_cycles,
     en_4_cycles => enable_4_cycles
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
--       enable_4_cycles <= '0';
--       wait for en_period/2;  
--       enable_4_cycles <= '1';
--       wait for en_period/2;  
--    end process;
    
        process
    begin
--        reset <= '1';
--        wait for 2 ns;
        reset <= '0';
        enable <= '1';
        wait for 2ns;
        a <= not a after 1300 ns;
        b <= not b after 2100 ns;
        c <= not c after 3700 ns;
        micro_data <= a xor b xor c;
    end process;
    
end Behavioral;