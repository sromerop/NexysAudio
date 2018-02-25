----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2018 17:33:24
-- Design Name: 
-- Module Name: dsed_audio_tb_FIR - Behavioral
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

entity dsed_audio_tb_FIR is
--  Port ( );
end dsed_audio_tb_FIR;

architecture Behavioral of dsed_audio_tb_FIR is

component dsed_audio is
    Port ( clk_100MHz : in STD_LOGIC;
           reset : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           SW0 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           micro_clk : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           micro_LR : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           jack_pwm : out STD_LOGIC);
end component;

signal clk_100MHz, reset, BTNL, BTNC, BTNR, SW0, SW1, micro_clk, micro_data, micro_LR, jack_sd, jack_pwm : std_logic := '0';
constant c_period : time := 10 ns;


constant c_period : time := 83 ns;

begin

DSED: dsed_audio port map(
     clk_100MHz =>  clk_100MHz,
     reset => reset,
     BTNL => BTNL,
     BTNC => BTNC,
     BTNR => BTNR,
     SW0 => SW0,
     SW1 => SW1,
     micro_clk => micro_clk,
     micro_data => micro_data,
     micro_LR => micro_LR,
     jack_sd => jack_sd,
     jack_pwm => jack_pwm     
 );
 
process
      begin
        clk_100MHz <= '0';
        wait for c_period/2;  
        clk_100MHz <= '1';
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
    wait for c_period;
    micro_data <= '0';
    wait for c_period;
    micro_data <= '1';
    wait for c_period;
    micro_data <= '0';
    wait for c_period;
    micro_data <= '0';
    wait for c_period;
    micro_data <= '0';
    wait for c_period;
    micro_data <= '0';
    wait for c_period;
    micro_data <= '0';
    wait for c_period;
    micro_data <= '0';
    wait for c_period;
    wait for 9 * c_period;
    micro_data <= "00000000";
    wait;
 end process; 
 
 process
     begin
 --        reset <= '1';
 --        wait for 10 ns;
 --        reset <= '0';        
         wait for 40 ns;
         BTNL <= '1';
         wait for 600us;
         BTNL <= '0';
         wait for 10us;
         BTNR <= '1';
         SW1 <= '1';
         wait for 100ns;
         BTNR <= '0';
         wait for 700us;
 --        BTNC <= '1';
 --        reset <= '1';
         wait for 100ns;
 --        BTNC <= '0';
 --        reset <= '0';                                
         wait;
 end process;

end Behavioral;