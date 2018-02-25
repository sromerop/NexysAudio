----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2017 13:18:27
-- Design Name: 
-- Module Name: controlador_fir_tb - Behavioral
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

entity controlador_fir_tb is
--  Port ( );
end controlador_fir_tb;

architecture Behavioral of controlador_fir_tb is

component controlador_fir is
    Port (  clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sample_in_enable : in STD_LOGIC;
        control : out STD_LOGIC_VECTOR (2 downto 0);
        sample_out_ready : out STD_LOGIC);
end component;

signal clk, reset, sample_in_enable, sample_out_ready : STD_LOGIC := '0';
signal control : STD_LOGIC_VECTOR(2 downto 0) := "000";

constant c_period : time := 83 ns;

begin

CONTR: controlador_fir port map (
        clk => clk,
        reset => reset,
        sample_in_enable => sample_in_enable,
        control => control,
        sample_out_ready => sample_out_ready);
        
    process
    begin
        clk <= '0';
        wait for c_period/2;  
        clk <= '1';
        wait for c_period/2;  
    end process;
    
    process
    begin
        reset <= '1';
        wait for 2 ns;
        reset <= '0';
        wait for 2ns;
        sample_in_enable <= '1';
        wait for 2000 ns;
        sample_in_enable <= '0';
        wait;   
     end process;   

end Behavioral;