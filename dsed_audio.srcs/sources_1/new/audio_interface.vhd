----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2017 11:24:16
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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

entity audio_interface is
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
end audio_interface;

architecture Behavioral of audio_interface is

component pwm is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           enable : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end component;

component en_4_cycles is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end component;

component FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
       reset : in STD_LOGIC;
       enable_4_cycles : in STD_LOGIC;
       enable : in STD_LOGIC;
       micro_data : in STD_LOGIC;
       sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
       sample_out_ready : out STD_LOGIC);
end component;

signal clk_3megas, en_2_cycles, en_4_cycles1, pwm_pulse : STD_LOGIC;

begin

    PWM_P: pwm port map(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => en_2_cycles,
--        enable => record_enable,
        enable => play_enable,
        sample_in => sample_in,
        sample_request => sample_request,
--        pwm_pulse => pwm_pulse);
        pwm_pulse => jack_pwm);

    EN_4: en_4_cycles port map(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => micro_clk,
        en_2_cycles => en_2_cycles,
        en_4_cycles => en_4_cycles1);

    FSMD: FSMD_microphone port map(
        clk_12megas => clk_12megas,
        reset => reset,
        enable_4_cycles => en_4_cycles1,
        enable => record_enable,
        micro_data => micro_data,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready);

jack_sd <= '1';
micro_LR <= '1';

--micro_clk <= clk_3megas;

--jack_pwm <= pwm_pulse when play_enable = '1' else
--            '0';     

end Behavioral;