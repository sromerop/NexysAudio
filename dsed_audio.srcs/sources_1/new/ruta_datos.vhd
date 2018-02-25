----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2017 12:37:47
-- Design Name: 
-- Module Name: ruta_datos - Behavioral
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

entity ruta_datos is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sample_in : in signed (sample_size - 1 downto 0);
           sample_in_enable : in STD_LOGIC;
           control : in STD_LOGIC_VECTOR (2 downto 0);
           control_HL : in STD_LOGIC;
           reset_out : in STD_LOGIC;
           y : out signed (sample_size - 1 downto 0));
end ruta_datos;

architecture Behavioral of ruta_datos is

component mux_5in is
    Port ( input0 : in signed (sample_size - 1 downto 0);
           input1 : in signed (sample_size - 1 downto 0);
           input2 : in signed (sample_size - 1 downto 0);
           input3 : in signed (sample_size - 1 downto 0);
           input4 : in signed (sample_size - 1 downto 0);
           control : in STD_LOGIC_VECTOR (2 downto 0);
           output : out signed (sample_size - 1 downto 0));
end component;

signal r1, r2, r3: signed (sample_size - 1 downto 0) := "00000000";
signal c0, c1, c2, c3, c4, multc : signed (sample_size - 1 downto 0);
signal x0, x1, x2, x3, x4, multx : signed (sample_size - 1 downto 0);
signal mult : signed (2 * sample_size - 1 downto 0);

begin

MUXC: mux_5in port map (
        input0 => c0,
        input1 => c1,
        input2 => c2,
        input3 => c3,
        input4 => c4,
        control => control,
        output => multc);

MUXX: mux_5in port map (
        input0 => x0,
        input1 => x1,
        input2 => x2,
        input3 => x3,
        input4 => x4,
        control => control,
        output => multx);

with control_HL select 
    c0 <= 
        c0_LP when '0',
        c0_HP when others;

with control_HL select 
    c1 <= 
        c1_LP when '0',
        c1_HP when others;

with control_HL select 
    c2 <= 
        c2_LP when '0',
        c2_HP when others;

with control_HL select 
    c3 <= 
        c3_LP when '0',
        c3_HP when others;

with control_HL select 
    c4 <= 
        c4_LP when '0',
        c4_HP when others;

process (clk, reset)
begin
    if (reset = '1') then
--        multx <= (others => '0');
        mult <= (others => '0'); 
        r1 <=  (others => '0');
        r2 <=  (others => '0');
        r3 <=  (others => '0');
        
        x0 <=  (others => '0');
        x1 <=  (others => '0');
        x2 <=  (others => '0');
        x3 <=  (others => '0');
        x4 <=  (others => '0');
        
    elsif rising_edge (clk) then
--        r1 <= std_logic_vector(unsigned(multc) * unsigned(multx));
        if (reset_out = '0') then
            
            if (sample_in_enable = '1') then
                x0 <= sample_in;
                x1 <= x0;
                x2 <= x1;
                x3 <= x2;
                x4 <= x3;
            end if;
            
            mult <= multx * multc;
            
            r1 <= mult(2 * (sample_size - 1) downto sample_size - 1);
            r2 <= r1;
            r3 <= r2 + r3;
        
        else 
--            multx <= (others => '0');
            mult <= (others => '0');
            r1 <= (others => '0');
            r2 <= (others => '0');
            r3 <= (others => '0');
            
--            x0 <= (others => '0');
--            x1 <= (others => '0');
--            x2 <= (others => '0');
--            x3 <= (others => '0');
--            x4 <= (others => '0');
            
        end if;
    end if;
end process;

y <= r3;

end Behavioral;