----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2017 12:11:42
-- Design Name: 
-- Module Name: mux_5in - Behavioral
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

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.package_dsed.all;

entity mux_5in is
    Port ( input0 : in signed (sample_size - 1 downto 0);
           input1 : in signed (sample_size - 1 downto 0);
           input2 : in signed (sample_size - 1 downto 0);
           input3 : in signed (sample_size - 1 downto 0);
           input4 : in signed (sample_size - 1 downto 0);
           control : in STD_LOGIC_VECTOR (2 downto 0);
           output : out signed (sample_size - 1 downto 0));
end mux_5in;

architecture Behavioral of mux_5in is

begin

with control select 
    output <= 
        input0 when "000",
        input1 when "001",
        input2 when "010",
        input3 when "011",
        input4 when "100",
        (others => '0') when others;

end Behavioral;