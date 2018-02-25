----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.11.2017 14:23:42
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

use work.package_dsed.all;

entity audio_interface_tb is
--  Port ( );
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

component audio_interface is
    Port ( clk_12megas : in STD_LOGIC;
       reset : in STD_LOGIC;
       record_enable : in STD_LOGIC;
       sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
       sample_out_ready : out STD_LOGIC;
       micro_clk : out STD_LOGIC;
       micro_data : in STD_LOGIC;
       micro_LR : out STD_LOGIC;
       play_enable : in STD_LOGIC;
       sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
       sample_request : out STD_LOGIC;
       jack_sd : out STD_LOGIC;
       jack_pwm : out STD_LOGIC);
end component;

signal clk_12megas, reset, record_enable, sample_out_ready, micro_clk, micro_data,
         micro_LR, play_enable, sample_request, jack_sd, jack_pwm : STD_LOGIC := '0';
signal sample_out, sample_in : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00000000";

signal a, b, c : STD_LOGIC := '0';
signal d : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "01100011";
signal e : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "10001001";
signal f : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00100000";

constant c_period : time := 83 ns;

begin

 AUD_INT: audio_interface port map(
     clk_12megas =>  clk_12megas,
     reset => reset,
     record_enable => record_enable,
     sample_out => sample_out,
     sample_out_ready => sample_out_ready,
     micro_clk => micro_clk,
     micro_data => micro_data,
     micro_LR => micro_LR,
     play_enable => play_enable,
     sample_in => sample_in,
     sample_request => sample_request,
     jack_sd => jack_sd,
     jack_pwm => jack_pwm     
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
        wait for 10 ns;
        reset <= '0';
        wait;
    end process;

        process
    begin
        record_enable <= '1';
        play_enable <= '1';
        a <= not a after 1300 ns;
        d <= not d after 1300 ns;
        b <= not b after 2100 ns;
        e <= not e after 2100 ns;
        c <= not c after 3700 ns;
        f <= not f after 3700 ns;
        micro_data <= a xor b xor c;
        sample_in <= d xor e xor f;
        wait for 20 ns; 
    end process;

end Behavioral;