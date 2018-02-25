----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2017 12:37:47
-- Design Name: 
-- Module Name: controlador_fir - Behavioral
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

entity controlador_fir is
    Port (  clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            sample_in_enable : in STD_LOGIC;
            control : out STD_LOGIC_VECTOR (2 downto 0);
            reset_out : out STD_LOGIC;
            sample_out_ready : out STD_LOGIC);
end controlador_fir;

architecture Behavioral of controlador_fir is

type state_type is (S00, S0, S1, S2, S3, S4, S5, S6, S7);
signal state, next_state : state_type;

signal control_aux : STD_LOGIC_VECTOR (2 downto 0);

begin

process (clk, reset)
begin
    if (reset = '1') then
        state <= S00;
    elsif rising_edge (clk) then
        state <= next_state;
    end if;
end process;

process (state, sample_in_enable)
begin
    sample_out_ready <= '0';    
    reset_out <= '0';
    
    case state is
        when S00 =>
            control_aux <= "111";   

        when S0 =>
            control_aux <= "000";  
        
        when S1 =>
            control_aux <= "001";  

        when S2 =>
            control_aux <= "010";    

        when S3 =>
            control_aux <= "011";  
        
        when S4 =>
            control_aux <= "100"; 
       
        when S5 =>
            control_aux <= "111"; 
       
        when S6 =>
            control_aux <= "111"; 
        
        when S7 =>
            control_aux <= "111";
            sample_out_ready <= '1';
            reset_out <= '1'; 
                                                                             
    end case;                     
end process;

process (clk, state, sample_in_enable)
begin
    case state is
    
        when S00 =>
            if(sample_in_enable = '1') then
                next_state <= S0;
            else
                next_state <= S00;
            end if;    
    
        when S0 =>
            next_state <= S1;
            
        when S1 =>
            next_state <= S2;
    
        when S2 =>
            next_state <= S3;  
    
        when S3 =>
            next_state <= S4;
            
        when S4 =>
            next_state <= S5;   
        
        when S5 =>
            next_state <= S6; 
        
        when S6 =>
            next_state <= S7; 
        
        when S7 =>
            next_state <= S00;                                                   
    
    end case;
end process;

control <= control_aux;

end Behavioral;