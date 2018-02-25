----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2017 11:38:29
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Sample_In : in signed (sample_size - 1 downto 0);
           Sample_In_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC;    -- 0 lowpass, 1 highpass
           Sample_Out : out signed (sample_size - 1 downto 0);
           Sample_Out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is

component ruta_datos is
    Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       sample_in : in signed (sample_size - 1 downto 0);
       sample_in_enable : in STD_LOGIC;
       control : in STD_LOGIC_VECTOR (2 downto 0);
       control_HL : in STD_LOGIC;
       reset_out : in STD_LOGIC;
       y : out signed (sample_size - 1 downto 0));
end component;

component controlador_fir is
    Port (  clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sample_in_enable : in STD_LOGIC;
        control : out STD_LOGIC_VECTOR (2 downto 0);
        reset_out : out STD_LOGIC;
        sample_out_ready : out STD_LOGIC);
end component;

signal control_aux : STD_LOGIC_VECTOR (2 downto 0);
signal reset_out_aux : STD_LOGIC;

begin

RUTA: ruta_datos port map (
        clk => clk,
        reset => Reset,
        sample_in => Sample_In,
        sample_in_enable => Sample_In_enable,
        control => control_aux,
        control_HL => filter_select,
        reset_out => reset_out_aux,
        y => Sample_Out);
        
CONTR: controlador_fir port map (
        clk => clk,
        reset => Reset,
        sample_in_enable => Sample_In_enable,
        control => control_aux,
        reset_out => reset_out_aux,
        sample_out_ready => Sample_Out_ready);

end Behavioral;