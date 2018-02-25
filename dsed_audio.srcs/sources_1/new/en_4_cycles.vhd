----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2017 11:26:25
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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

entity en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end en_4_cycles;

architecture Behavioral of en_4_cycles is

signal clk_3megas_aux, en_2_cycles_aux, en_4_cycles_aux : std_logic := '0';
signal counter : integer range 0 to 3 := 0;

begin

process (clk_12megas, reset)
begin

if (reset = '1') then
    counter <= 0;
    clk_3megas_aux <= '0';
    en_2_cycles_aux <= '0';
    en_4_cycles_aux <= '0';
elsif rising_edge(clk_12megas) then
    if (counter = 3) then
        counter <= 0;
        en_2_cycles_aux <= '1';
        en_4_cycles_aux <= '0';
    elsif (counter = 2) then 
        en_2_cycles_aux <= '0';
        en_4_cycles_aux <= '1';
        clk_3megas_aux <= '1';        
        counter <= counter + 1;
    elsif (counter = 1) then   
        en_2_cycles_aux <= '1';
        counter <= counter + 1;
    else
        en_2_cycles_aux <= '0';
        en_4_cycles_aux <= '0';
        clk_3megas_aux <= '0';  
        counter <= counter + 1;
    end if;
end if;
end process;

clk_3megas <= clk_3megas_aux;
en_2_cycles <= en_2_cycles_aux;
en_4_cycles <= en_4_cycles_aux;

end Behavioral;