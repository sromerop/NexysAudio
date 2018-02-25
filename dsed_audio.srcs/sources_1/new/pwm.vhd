----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2017 11:31:04
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

signal count_aux, next_count_aux : integer range 0 to 299 := 0;
signal buf_aux, next_buf_aux : STD_LOGIC := '0';

begin

--process (clk_12megas, en_2_cycles, reset)
process (clk_12megas, reset)
begin
    if (reset = '1') then
        count_aux <= 0;
        buf_aux <= '0';
    elsif rising_edge(clk_12megas) then
        if (enable = '1' and en_2_cycles = '1') then
            count_aux <= next_count_aux;
            buf_aux <= next_buf_aux;
        end if;
    end if;
end process;

next_count_aux <= 0 when (count_aux = 299) else
                  count_aux + 1;

--next_buf_aux <= '0' when (count_aux < unsigned(sample_in)) or (next_count_aux = 0) or (sample_in = "00000000") else
next_buf_aux <= '1' when (count_aux < unsigned(sample_in)) or (next_count_aux = 0) else
--next_buf_aux <= '0' when (count_aux < unsigned(sample_in)) or (next_count_aux = 0) else
                '0';

sample_request <= en_2_cycles when (count_aux = 299) else
                '0';
pwm_pulse <= buf_aux;

end Behavioral;