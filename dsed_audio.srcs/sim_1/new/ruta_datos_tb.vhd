----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2017 13:41:38
-- Design Name: 
-- Module Name: ruta_datos_tb - Behavioral
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

entity ruta_datos_tb is
--  Port ( );
end ruta_datos_tb;

architecture Behavioral of ruta_datos_tb is

component ruta_datos is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in signed (sample_size - 1 downto 0);
           control : in STD_LOGIC_VECTOR (2 downto 0);
           control_HL : in STD_LOGIC;
           y : out signed (sample_size - 1 downto 0));
end component;

signal clk, reset, control_HL : STD_LOGIC := '0';
signal sample_in, y : signed (sample_size - 1 downto 0) := "00000000";
signal control, control_aux : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal a : signed (sample_size - 1 downto 0) := "01100011";
signal b : signed (sample_size - 1 downto 0) := "10001001";
signal c : signed (sample_size - 1 downto 0) := "00100000";

constant c_period : time := 83 ns;

begin

RUTA: ruta_datos port map (
        clk => clk,
        reset => reset,
        sample_in => sample_in,
        control => control,
        control_HL => control_HL,
        y => y
 );
 
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
        control_HL <= '1';
        wait for 2000 ns;
        control_HL <= '0';
        wait;
        
     end process;   
 
--     process
--     begin
         --        if (control_aux = "100") then 
     --            control_aux <= "000";
     --        end if;
         control_aux <= std_logic_vector(unsigned(control_aux) + '1') after 200 ns;
         control <= control_aux;
--         wait;
--     end process;
        
--    process
--    begin
        a <= not a after 130 ns;
        b <= not b after 210 ns;
        c <= not c after 370 ns;
        
        sample_in <= a xor b xor c;
--        wait;
--    end process;
    
end Behavioral;