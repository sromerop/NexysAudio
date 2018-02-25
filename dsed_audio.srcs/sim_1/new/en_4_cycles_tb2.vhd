----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2017 13:57:26
-- Design Name: 
-- Module Name: en_4_cycles_tb2 - Behavioral
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

entity en_4_cycles_tb2 is
--  Port ( );
end en_4_cycles_tb2;

architecture Behavioral of en_4_cycles_tb2 is

component en_4_cycles is 
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);   
end component; 

--constant c_period : time := (250/3) ns;
constant c_period : time := 83 ns;
signal clk_12megas, reset, clk_3megas, en_2_cycles, en_4_cycles1 : STD_LOGIC;

begin

 EN:  en_4_cycles PORT MAP (
		clk_12megas => clk_12megas,
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

    process
    begin
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait;
    end process;
end Behavioral;