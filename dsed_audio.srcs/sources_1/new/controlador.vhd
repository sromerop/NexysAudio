----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2017 11:31:04
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
    Port ( clk_100MHz : in STD_LOGIC;
           reset : in STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end controlador;

architecture Behavioral of controlador is

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

component clk_12MHz is
    Port ( clk_in1 : in STD_LOGIC;
       clk_out1 : out STD_LOGIC);
end component;

signal clk_12megas, sample_request, sample_out_ready : STD_LOGIC;
signal sample_out_in : STD_LOGIC_VECTOR (sample_size - 1 downto 0);
--signal record_enable, play_enable : STD_LOGIC := '1';

begin

 CLK_12: clk_12MHz port map(
     clk_in1 => clk_100MHz,
     clk_out1 => clk_12megas
 );

 AUD_INT: audio_interface port map(
     clk_12megas => clk_12megas,
     reset => reset,
     record_enable => '1',
     sample_out => sample_out_in,
     sample_out_ready => sample_out_ready,
     micro_clk => micro_clk,
     micro_data => micro_data,
     micro_LR => micro_LR,
     play_enable => '1',
     sample_in => sample_out_in,
     sample_request => sample_request,
     jack_sd => jack_sd,
     jack_pwm => jack_pwm     
 );

end Behavioral;