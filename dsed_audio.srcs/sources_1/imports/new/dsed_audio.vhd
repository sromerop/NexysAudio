----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2017 11:18:30
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

entity dsed_audio is
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
end dsed_audio;

architecture Behavioral of dsed_audio is

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

component fir_filter is
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Sample_In : in signed (sample_size - 1 downto 0);
           Sample_In_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC;    -- 0 lowpass, 1 highpass
           Sample_Out : out signed (sample_size - 1 downto 0);
           Sample_Out_ready : out STD_LOGIC);
end component;

component controlador_global is    
	Port ( clk_12megas : in STD_LOGIC;
	       reset : in STD_LOGIC;
           SW0 : in STD_LOGIC;
           SW1 : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           
           sample_out_ready_audioint : in STD_LOGIC;
           sample_out_ready_filtrofir : in STD_LOGIC;
           sample_request_audioint : in STD_LOGIC;
           
           record_enable : out STD_LOGIC;
           play_enable : out STD_LOGIC;
--           delete_RAM : out STD_LOGIC;
           read_write_RAM : out STD_LOGIC_VECTOR(0 downto 0);
           enable_RAM : out STD_LOGIC;
           dir_RAM : out STD_LOGIC_VECTOR(18 downto 0);          
--           normal_reves : out STD_LOGIC;    -- 0 normal, 1 revés
           filtro_BA : out STD_LOGIC;   -- 0 bajo, 1 alto
           enable_fir : out STD_LOGIC);
end component;

component RAM is
  PORT (
    clka : in STD_LOGIC;
    rsta : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : in STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : in STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : out STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
end component;

signal clk_12megas, record_enable, play_enable, sample_out_ready_audioint, sample_request : STD_LOGIC := '0';
signal sample_in_audioint : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := (others => '0');

signal Sample_In_enable, filter_select, sample_out_ready_fir : STD_LOGIC := '0';
signal sample_in_fir, sample_out_fir : signed (sample_size - 1 downto 0) := (others => '0');
signal sample_out_fir_vec, sample_out_fir_vec_next : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := (others => '0');

signal enable_RAM : STD_LOGIC := '0';
signal read_write_RAM : STD_LOGIC_VECTOR (0 downto 0) := (others => '0');
signal sample_in_ram, sample_out_ram : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal dir_RAM : STD_LOGIC_VECTOR (18 downto 0) := (others => '0');

begin

 CLK_12: clk_12MHz port map(
     clk_in1 => clk_100MHz,
     clk_out1 => clk_12megas
 );

 AUD_INT: audio_interface port map(
     clk_12megas => clk_12megas,
     reset => reset,
     record_enable => record_enable,
     sample_out => sample_in_ram,
     sample_out_ready => sample_out_ready_audioint,
     micro_clk => micro_clk,
     micro_data => micro_data,
     micro_LR => micro_LR,
     play_enable => play_enable,
     sample_in => sample_in_audioint,
     sample_request => sample_request,
     jack_sd => jack_sd,
     jack_pwm => jack_pwm);

 FIR: fir_filter port map(
     clk => clk_12megas,
     Reset => reset,
     Sample_In => sample_in_fir,
     Sample_In_enable => Sample_In_enable,
     filter_select => filter_select,
     Sample_Out => sample_out_fir,     
     Sample_Out_ready => sample_out_ready_fir);

 MEM: RAM port map(
     clka => clk_12megas,
     rsta => reset,
     ena => enable_RAM,
     wea => read_write_RAM,
     addra => dir_RAM,
     dina => sample_in_ram,     
     douta => sample_out_ram);

 CONTR: controlador_global port map(
     clk_12megas => clk_12megas,
     reset => reset,
     SW0 => SW0,
     SW1 => SW1,
     BTNL => BTNL,
     BTNC => BTNC,
     BTNR => BTNR,
     sample_out_ready_audioint => sample_out_ready_audioint,
     sample_out_ready_filtrofir => sample_out_ready_fir,
     sample_request_audioint => sample_request,
     record_enable => record_enable,
     play_enable => play_enable,
     read_write_RAM => read_write_RAM,
     enable_RAM => enable_RAM,
     dir_RAM => dir_RAM,
     filtro_BA => filter_select,     
     enable_fir => Sample_In_enable);

    process (clk_12megas, reset)
    begin
    
	   if (reset = '1') then
           sample_out_fir_vec <= (others => '0');  
       elsif rising_edge (clk_12megas) then
            if (sample_out_ready_fir = '1') then
                sample_out_fir_vec <= sample_out_fir_vec_next;
            end if;  
       end if;	
    end process;

sample_in_fir <= signed((not sample_out_ram(7)) & sample_out_ram(6 downto 0));
sample_out_fir_vec_next <= STD_LOGIC_VECTOR((not sample_out_fir(7)) & sample_out_fir(6 downto 0));
sample_in_audioint <= sample_out_fir_vec when SW1 = '1' else
                    sample_out_ram;

end Behavioral;