----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2017 11:31:04
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           enable : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is

type state_type is (S0, S1, S2, S3);
signal state, next_state : state_type;

signal count_aux, next_count_aux : integer range 0 to 299 := 0;
signal count_may_ig_0, count_men_ig_105 : STD_LOGIC := '0';
signal count_may_ig_150, count_men_ig_255 : STD_LOGIC := '0';
signal count_may_ig_106, count_men_ig_149 : STD_LOGIC := '0';
signal count_may_ig_256, count_men_ig_299 : STD_LOGIC := '0';

signal dato1, dato1_next : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00000000";
signal dato2, dato2_next : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00000000";

signal fin_ciclo, fin_ciclo_next : STD_LOGIC := '0';

signal sample_out_aux, sample_out_aux_next : STD_LOGIC_VECTOR (sample_size - 1 downto 0) := "00000000";
signal sample_out_ready_aux : STD_LOGIC := '0';
begin

process (clk_12megas, enable_4_cycles, reset, enable)
--process (clk_12megas, reset, enable)
begin
    if (reset = '1') then
        state <= S0;
        count_aux <= 0;
        dato1 <= "00000000";
        dato2 <= "00000000";
        fin_ciclo <= '0';
        sample_out_aux <= (others => '0');
      elsif rising_edge(clk_12megas) then
        if (enable_4_cycles = '1' and enable = '1') then
            state <= next_state;
            count_aux <= next_count_aux;
            dato1 <= dato1_next;
            dato2 <= dato2_next;
            sample_out_aux <= sample_out_aux_next;
            fin_ciclo <= fin_ciclo_next;
        end if;
    end if;
end process;

process (enable_4_cycles, state, micro_data, count_aux, fin_ciclo, dato1, dato2, sample_out_aux)
begin
    sample_out_ready_aux <= '0';
    fin_ciclo_next <= fin_ciclo;
    dato1_next <= dato1;
    dato2_next <= dato2;
    sample_out_aux_next <= sample_out_aux;   
    
    case state is
        when S0 =>  -- de 0 a 105
           next_count_aux <= count_aux + 1;
           if (micro_data = '1') then
                dato1_next <= std_logic_vector(unsigned(dato1) + 1);
                if (dato2 = "11111111") then
                    dato2_next <= "11111111";
                else
                    dato2_next <= std_logic_vector(unsigned(dato2) + 1);
                end if;
            end if;
            if (fin_ciclo = '1' and count_aux = 105) then
                sample_out_aux_next <= dato2;
                dato2_next <= "00000000";
                sample_out_ready_aux <= enable_4_cycles;
            end if;
        when S1 =>  -- de 106 a 149
            next_count_aux <= count_aux + 1;
            if (micro_data = '1') then
                 dato1_next <= std_logic_vector(unsigned(dato1) + 1);
            end if;
--            if (fin_ciclo = '1' and count_aux = 106) then
--                 sample_out_aux_next <= dato2;
--                 dato2_next <= "00000000";
--                 sample_out_ready_aux <= enable_4_cycles;
--            end if;               
        
        when S2 =>  -- de 150 a 255 (igual que S0)
            next_count_aux <= count_aux + 1;
            if (micro_data = '1') then
                if (dato1 = "11111111") then
                    dato1_next <= "11111111";
                else
                    dato1_next <= std_logic_vector(unsigned(dato1) + 1);
                end if;
                dato2_next <= std_logic_vector(unsigned(dato2) + 1);
            end if;                 
            if (count_aux = 255) then
                sample_out_aux_next <= dato1;
                dato1_next <= "00000000";
                sample_out_ready_aux <= enable_4_cycles;
            end if; 
            
        when S3 =>  -- de 256 a 299 (análogo a S1)
            next_count_aux <= count_aux + 1;
            if (micro_data = '1') then
                dato2_next <= std_logic_vector(unsigned(dato2) + 1);
            end if;
--            if (count_aux = 256) then
--                sample_out_aux_next <= dato1;
--                dato1_next <= "00000000";
--                sample_out_ready_aux <= enable_4_cycles;
--            end if;         
            if (count_aux = 299) then
                next_count_aux <= 0;
                fin_ciclo_next <= '1';
            end if;             
    end case;                     
end process;


process (state, micro_data, count_may_ig_0, count_men_ig_105, count_may_ig_150, 
            count_men_ig_255, count_may_ig_106, count_men_ig_149, count_may_ig_256, count_men_ig_299)

begin
next_state <= S0;
    case state is
        when S0 =>  -- de 0 a 105
            if(count_may_ig_0 = '1' and count_men_ig_105 = '1') then
                next_state <= S0;
            elsif (count_men_ig_105 = '0') then
                next_state <= S1;
            end if;
            
        when S1 =>  -- de 106 a 149
            if(count_may_ig_106 = '1' and count_men_ig_149 = '1') then
                next_state <= S1;
            elsif (count_men_ig_149 = '0') then
                next_state <= S2;
            end if;
    
        when S2 =>  -- de 150 a 255
            if(count_may_ig_150 = '1' and count_men_ig_255 = '1') then
                next_state <= S2;
            elsif (count_men_ig_255 = '0') then
                next_state <= S3;
            end if;    
    
        when S3 =>  -- de 256 a 299
            if(count_may_ig_256 = '1' and count_men_ig_299 = '1') then
                next_state <= S3;
            elsif (count_may_ig_0 = '1') then
                next_state <= S0;
            end if;     
    end case;
end process;


count_may_ig_0 <= '1' when (next_count_aux >= 0) else '0';
count_men_ig_105 <= '1' when (next_count_aux <= 105) else '0';

count_may_ig_150 <= '1' when (next_count_aux >= 150) else '0';
count_men_ig_255 <= '1' when (next_count_aux <= 255) else '0';

count_may_ig_106 <= '1' when (next_count_aux >= 106) else '0';
count_men_ig_149 <= '1' when (next_count_aux <= 149) else '0';

count_may_ig_256 <= '1' when (next_count_aux >= 256) else '0';
count_men_ig_299 <= '1' when (next_count_aux <= 299) else '0';

sample_out <= sample_out_aux;
sample_out_ready <= sample_out_ready_aux;

end Behavioral;