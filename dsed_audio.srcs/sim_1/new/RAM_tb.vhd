----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.12.2017 11:24:52
-- Design Name: 
-- Module Name: RAM_tb - Behavioral
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

entity RAM_tb is
--  Port ( );
end RAM_tb;

architecture Behavioral of RAM_tb is

component RAM IS
  PORT (
    clka : IN STD_LOGIC;
    rsta : IN STD_LOGIC;
    ena : IN STD_LOGIC; -- enable
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);  -- utilizar wea(0), write enable
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);   -- direccion
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);  -- data in
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));  -- data out
END component;

signal clka, ena, rsta : STD_LOGIC := '0';
signal dina : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal douta : STD_LOGIC_VECTOR (7 downto 0);
signal wea : STD_LOGIC_VECTOR (0 downto 0) := (others => '0');
signal addra : STD_LOGIC_VECTOR (18 downto 0) := (others => '0');

constant c_period : time := 83 ns;

begin

MEM_RAM: RAM port map (
        clka => clka,
        rsta => rsta,
        ena => ena,
        wea => wea,
        addra => addra,
        dina => dina,
        douta => douta);

	process
	begin
       clka <= '0';
       wait for c_period/2;  
       clka <= '1';
       wait for c_period/2;  
    end process;

--    process
--    begin
--        ena <= '0';
--        wait for 2 ns;
--        ena <= '1';
--        wait for 2ns;
--        dina <= "11111111";
--        addra <= (others => '0');
--        wea(0) <= '1';
--        wait for 9 * c_period;
--        wea(0) <= '0';
--        wait;
--     end process;  

    process
    begin
--        ena <= '0';
--        wait for 2 ns;
        rsta <= '1';
        ena <= '1';
        wait for c_period;
        ena <= '0';
--        rsta <= '0';
        wea(0) <= '1';
        dina <= "11111111";
        addra <= (others => '0');
        wait for c_period;
        ena <= '1';
        dina <= "10000000";
        addra <= "0000000000000000001";
        wait for c_period;        
        rsta <= '0';
        dina <= "11000000";
        addra <= "0000000000000000010";
        wait for c_period;
        ena <= '0';
        dina <= "11100000";
        addra <= "0000000000000000011";        
        wait for c_period;
        
--        rsta <= '1';
--        wea(0) <= '0';
        ena <= '1';
        wait for 3*c_period;
--        rsta <= '0';
        wea(0) <= '0';
        addra <= (others => '0');
        wait for c_period;        
        addra <= "0000000000000000001";
        wait for c_period;
        ena <= '0';        
        addra <= "0000000000000000010";
        wait for c_period;
        ena <= '1';        
        addra <= "0000000000000000011"; 
        wait for c_period;      
        addra <= "0000000000000000010";
        wait for 2*c_period;
        ena <= '0';
        rsta <= '1';
        addra <= "0000000000000000011"; 
        wait for 2*c_period;
        ena <= '1';
        
        
        
        wait;
     end process;  

end Behavioral;