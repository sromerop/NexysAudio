----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2017 13:18:27
-- Design Name: 
-- Module Name: fir_filter_tb_1 - Behavioral
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

entity fir_filter_tb_1 is
--  Port ( );
end fir_filter_tb_1;

architecture Behavioral of fir_filter_tb_1 is

component fir_filter is
    Port ( clk : in STD_LOGIC;
       Reset : in STD_LOGIC;
       Sample_In : in signed (sample_size - 1 downto 0);
       Sample_In_enable : in STD_LOGIC;
       filter_select : in STD_LOGIC;    -- 0 lowpass, 1 highpass
       Sample_Out : out signed (sample_size - 1 downto 0);
       Sample_Out_ready : out STD_LOGIC);
end component;

signal clk, Reset, filter_select, Sample_In_enable, Sample_Out_ready : STD_LOGIC := '0';
signal Sample_In, Sample_Out : signed (sample_size - 1 downto 0) := "00000000";
signal a : signed (sample_size - 1 downto 0) := "01100011";
signal b : signed (sample_size - 1 downto 0) := "10001001";
signal c : signed (sample_size - 1 downto 0) := "00100000";

constant c_period : time := 83 ns;

begin

FIR: fir_filter port map (
        clk => clk,
        Reset => Reset,
        Sample_In => Sample_In,
        Sample_In_enable => Sample_In_enable,
        filter_select => filter_select,
        Sample_Out => Sample_Out,
        Sample_Out_ready => Sample_Out_ready);

	process
    begin
       clk <= '0';
       wait for c_period/2;  
       clk <= '1';
       wait for c_period/2;  
    end process;
    
    process
    begin
        Reset <= '1';
        wait for 2 ns;
        Reset <= '0';
        wait for 2ns;
        filter_select <= '1';
        Sample_In_enable <= '1';
        wait for 2000 ns;
        filter_select <= '0';
        wait for 2000 ns;
        Sample_In_enable <= '0';
        wait;
        
     end process;   
        
--    process
--    begin
        a <= not a after 130 ns;
        b <= not b after 210 ns;
        c <= not c after 370 ns;
        
        Sample_In <= a xor b xor c;
--        wait;
--    end process;

end Behavioral;