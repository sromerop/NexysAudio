----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2017 13:18:27
-- Design Name: 
-- Module Name: fir_filter_tb_avanzado - Behavioral
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

use std.textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.package_dsed.all;

entity fir_filter_tb_avanzado is
--  Port ( );
end fir_filter_tb_avanzado;

architecture Behavioral of fir_filter_tb_avanzado is

component fir_filter is
    Port ( clk : in STD_LOGIC;
       Reset : in STD_LOGIC;
       Sample_In : in signed (sample_size - 1 downto 0);
       Sample_In_enable : in STD_LOGIC;
       filter_select : in STD_LOGIC;    -- 0 lowpass, 1 highpass
       Sample_Out : out signed (sample_size - 1 downto 0);
       Sample_Out_ready : out STD_LOGIC);
end component;

signal clk, Reset, Sample_In_enable, filter_select, Sample_Out_ready : STD_LOGIC := '0';
signal Sample_In, Sample_Out : signed (sample_size - 1 downto 0) := (others => '0');

--signal count_aux : integer range 0 to 8 := 0;

constant c_period : time := 83 ns;

begin

FIR: fir_filter port map (
        clk => clk,
        Reset => Reset,
        Sample_In => Sample_In,
        Sample_In_enable => Sample_In_enable,
        filter_select => filter_select,
        Sample_Out => Sample_Out,
        Sample_Out_ready => Sample_Out_ready);

	process
	begin
       clk <= '0';
       wait for c_period/2;  
       clk <= '1';
       wait for c_period/2;  
    end process;

    process
    begin
        Reset <= '1';
        wait for 2 ns;
        Reset <= '0';
        wait for 2ns;
        filter_select <= '1';
--        filter_select <= '0';
--        Sample_In_enable <= '1';
        wait for 2000 ns;
--        filter_select <= '0';
--        wait for 2000 ns;
--        Sample_In_enable <= '0';
        wait;
        
     end process;   

     process
     begin
        wait for c_period;
        Sample_In_enable <= '1';
        wait for c_period;
        Sample_In_enable <= '0';
        wait for 8 * c_period;
     end process;

    process (clk)
        file in_file : text open read_mode is "E:\DSED_Grupo6\Proyecto\sample_in.dat";
        file out_file : text open write_mode is "E:\DSED_Grupo6\Proyecto\sample_out.dat";
        variable in_line, out_line : line;
        variable in_int, out_int : integer;
--        variable in_read_ok, out_read_ok : boolean;
        variable in_read_ok : boolean;
    begin
        if (rising_edge(clk)) then
            if (not endfile(in_file)) then
--                count_aux <= count_aux + 1;
--                if (count_aux = 8) then
--                    count_aux <= 0;
                    if (Sample_In_enable = '1') then
                        ReadLine(in_file, in_line);
                        Read(in_line, in_int, in_read_ok);
                        Sample_In <= to_signed(in_int, 8);
                    end if;
                    
                    if (Sample_Out_ready = '1') then             
                        out_int := to_integer(Sample_Out);
--                      Write(out_line, out_int, out_read_ok);
                        Write(out_line, out_int);
                        WriteLine(out_file, out_line);
                    end if;
            else
                assert false report "Simulation Finished" severity failure;
            end if;
        end if; 
    end process;

end Behavioral;