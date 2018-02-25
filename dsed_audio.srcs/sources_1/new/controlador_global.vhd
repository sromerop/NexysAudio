----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2017 12:05:16
-- Design Name: 
-- Module Name: controlador_global - Behavioral
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

entity controlador_global is
    
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

end controlador_global;

architecture Behavioral of controlador_global is
	
    type state_type is (REPOSO, GRABACION1, GRABACION2, BORRADO, NORMAL1, NORMAL2, NORMAL3, REVES1, REVES2, REVES3, 
            BAJO1, BAJO2, BAJO3, BAJO4, ALTO1, ALTO2, ALTO3, ALTO4);

	signal state, next_state : state_type;

	signal direccion_RAM, direccion_RAM_next : integer range 0 to 524287 := 0; -- la direccion actual
	signal direccion_max, direccion_max_next : integer range 0 to 524287 := 0; -- tamaño ocupado
	constant rango_RAM : integer := 524288;    -- tamaño máximo

    signal cnt_b, cnt_b_next, cnt_a, cnt_a_next : integer range 0 to 2 := 0;

begin
	
    process (clk_12megas, reset)
    begin
    
	   if (reset = '1') then
            state <= REPOSO;
            direccion_RAM <= 0;
--            direccion_max <= 0;
            cnt_b <= 0;
            cnt_a <= 0;            
       elsif rising_edge (clk_12megas) then
            state <= next_state;
            direccion_RAM <= direccion_RAM_next;
            direccion_max <= direccion_max_next;
            cnt_b <= cnt_b_next;
            cnt_a <= cnt_a_next;
       end if;
	
    end process;

	process (state, sample_out_ready_audioint, sample_out_ready_filtrofir, sample_request_audioint, direccion_RAM, direccion_max, cnt_b, cnt_a)
	begin
    
		record_enable <= '0';
		play_enable <= '0';
--		delete_RAM <= '0';           
		enable_RAM <= '0';
		read_write_RAM(0) <= '0';
--		normal_reves <= '0';    -- 0 normal, 1 revés
        filtro_BA <= '0';   -- 0 bajo, 1 alto
        enable_fir <= '0';  
        direccion_RAM_next <= direccion_RAM;
        direccion_max_next <= direccion_max;
        cnt_b_next <= cnt_b;
        cnt_a_next <= cnt_a;
        
		case state is
        
			when REPOSO =>  
				record_enable <= '0';
                play_enable <= '0';
--                delete_RAM <= '0';           
				enable_RAM <= '0';
                enable_fir <= '0';    
					
			when BORRADO =>              
--                delete_RAM <= '1';
                direccion_RAM_next <= 0;
                direccion_max_next <= 0;
			
			when GRABACION1 =>              
				record_enable <= '1';
				
			when GRABACION2 =>  
				record_enable <= '1';
                read_write_RAM(0) <= '1';
                enable_RAM <= '1';
                direccion_RAM_next <= direccion_RAM + 1;
                direccion_max_next <= direccion_max + 1;
					
			when NORMAL1 =>              
				read_write_RAM(0) <= '0';
			    enable_RAM <= '1';
        		direccion_RAM_next <= 0;
				play_enable <= '1';
					
			when NORMAL2 =>  
				read_write_RAM(0) <= '0';
				enable_RAM <= '1';
        		direccion_RAM_next <= direccion_RAM + 1;
				play_enable <= '1';
				
			when NORMAL3 =>  
--                read_write_RAM <= '0';
--                enable_RAM <= '1';
--                direccion_RAM <= direccion_RAM + 1;
                play_enable <= '1';				
					
			when REVES1 =>              
			     read_write_RAM(0) <= '0';
				 enable_RAM <= '1';
                 direccion_RAM_next <= direccion_max;
				 play_enable <= '1';
				
			when REVES2 =>  
				read_write_RAM(0) <= '0';
				enable_RAM <= '1';
                direccion_RAM_next <= direccion_RAM - 1;
				play_enable <= '1'; 

			when REVES3 =>  
--                read_write_RAM <= '0';
--                enable_RAM <= '1';
--                direccion_RAM <= direccion_RAM + 1;
                play_enable <= '1';
				
			when BAJO1 =>              
				read_write_RAM(0) <= '0';
				enable_RAM <= '1';
          		direccion_RAM_next <= 0;
--				enable_fir <= '1';
				filtro_BA <= '0';
				cnt_b_next <= cnt_b + 1;
				if (cnt_b = 2) then
                    enable_fir <= '1';
                else 
                    enable_fir <= '0';
                end if;    
				
			when BAJO2 =>  
				read_write_RAM(0) <= '0';
				enable_RAM <= '1';
--        		direccion_RAM_next <= direccion_RAM + 1;
--        		enable_fir <= '1';
                filtro_BA <= '0';
--				play_enable <= '1';
                cnt_b_next <= cnt_b + 1;
				if (cnt_b = 2) then
                    enable_fir <= '1';
                elsif (cnt_b = 0) then
                    direccion_RAM_next <= direccion_RAM + 1;
                else 
                    enable_fir <= '0';
                end if;                           

			when BAJO3 =>  
				play_enable <= '1';
				filtro_BA <= '0';   

			when BAJO4 =>  
				enable_fir <= '0';
                filtro_BA <= '0';
                enable_RAM <= '1';
--                play_enable <= '1';
                cnt_b_next <= 0;  
			
			when ALTO1 =>              
				read_write_RAM(0) <= '0';
                enable_RAM <= '1';
                direccion_RAM_next <= 0;
--                enable_fir <= '1';
                filtro_BA <= '1';
                cnt_a_next <= cnt_a + 1;
                if (cnt_a = 2) then
                    enable_fir <= '1';
                else 
                    enable_fir <= '0';
                end if;  
				
			when ALTO2 =>  
				read_write_RAM(0) <= '0';
                enable_RAM <= '1';
--                direccion_RAM_next <= direccion_RAM + 1;
--                enable_fir <= '1';
                filtro_BA <= '1';
--                play_enable <= '1';
                cnt_a_next <= cnt_a + 1;
                if (cnt_a = 2) then
                    enable_fir <= '1';
                elsif (cnt_a = 0) then
                    direccion_RAM_next <= direccion_RAM + 1;
                else 
                    enable_fir <= '0';
                end if;           

			when ALTO3 =>  
				play_enable <= '1';
				filtro_BA <= '1';   

			when ALTO4 =>  
				enable_fir <= '0';
                filtro_BA <= '1';
                enable_RAM <= '1';
--                play_enable <= '1';
                cnt_a_next <= 0; 
    
			end case;                     

	end process;
		

    process (state, SW0, SW1, BTNL, BTNC, BTNR, sample_out_ready_audioint, sample_out_ready_filtrofir, sample_request_audioint, direccion_RAM, direccion_max, cnt_b, cnt_a)
	begin
    
	   case state is
        
	       when REPOSO =>  
                    
                if(BTNL = '1') then
                    next_state <= GRABACION1;
                elsif(BTNC = '1') then
                    next_state <= BORRADO;
                elsif(BTNR = '1') then
                    if(SW0 = '0' and SW1 = '0') then
                        next_state <= NORMAL1;
					elsif(SW0 = '1' and SW1 = '0') then
                        next_state <= REVES1;
                    elsif(SW0 = '0' and SW1 = '1') then
					    next_state <= BAJO1;
--				    elsif(SW0 = '1' and SW1 = '1') then
				    else                
					    next_state <= ALTO1;
				    end if;
				else 
					next_state <= REPOSO;
				end if;

			when BORRADO =>  
                if(BTNC = '1') then
                    next_state <= BORRADO;                                
--                elsif(BTNC = '0') then
                else
                    next_state <= REPOSO;
                end if;

			when GRABACION1 =>  
				
				if(BTNL = '1') then
				    if(direccion_RAM >= rango_RAM) then
                        next_state <= REPOSO;
				    elsif(sample_out_ready_audioint = '0') then
                        next_state <= GRABACION1;
                    elsif(sample_out_ready_audioint = '1') and (direccion_RAM < rango_RAM) then
                        next_state <= GRABACION2;
				    end if;            
--				elsif(BTNL = '0') then
				else
                    next_state <= REPOSO;
                end if;
					
			when GRABACION2 =>  
				if(BTNL = '1') then
				    if(sample_out_ready_audioint = '1') then
                        next_state <= GRABACION2;
--                    elsif(sample_out_ready_audioint = '0') then
                    else
                        next_state <= GRABACION1;
                    end if;
--                elsif(BTNL = '0') then
                else
                    next_state <= REPOSO;
                end if;	
										
			when NORMAL1 =>  
				if(sample_request_audioint = '0') then
                    next_state <= NORMAL1;
--                elsif(sample_request_audioint = '1') then
                else
                    next_state <= NORMAL2;
                end if;            
										
			when NORMAL2 =>  
				if(direccion_RAM < direccion_max) then
				    if(sample_request_audioint = '1') then
                        next_state <= NORMAL2;
--                    elsif(sample_request_audioint = '0') then
                    else
                        next_state <= NORMAL3;
                    end if;
--                elsif(direccion_RAM >= direccion_max) then
                else
                    next_state <= REPOSO;
                end if; 

			when NORMAL3 =>  
				if(sample_request_audioint = '1') then
                    next_state <= NORMAL2;
--                elsif(sample_request_audioint = '0') then
                else
                    next_state <= NORMAL3;
                end if; 
					
			when REVES1 =>  
				if(sample_request_audioint = '0') then
                    next_state <= REVES1;
--                elsif(sample_request_audioint = '1') then
                else
                    next_state <= REVES2;
                end if;  
					
			when REVES2 =>  
				if(direccion_RAM > 0) then
                    if(sample_request_audioint = '1') then
                        next_state <= REVES2;
                    elsif(sample_request_audioint = '0') then
                        next_state <= REVES3;
                    end if;
--                elsif(direccion_RAM <= 0) then
                else
                    next_state <= REPOSO;
                end if;       	

			when REVES3 =>  
				if(sample_request_audioint = '1') then
                    next_state <= REVES2;
--                elsif(sample_request_audioint = '0') then
                else
                    next_state <= REVES3;
                end if; 

			when BAJO1 =>  
--				if(sample_out_ready_filtrofir = '0') then
--                    next_state <= BAJO1;
----                elsif(sample_out_ready_filtrofir = '1') then
--                else
--                    next_state <= BAJO3;
--                end if;            
				if (cnt_b = 2) then
				    next_state <= BAJO4;
				else 
				    next_state <= BAJO1;
				end if;						
			
			when BAJO2 =>  
				if(direccion_RAM < direccion_max) then
--				    if(sample_out_ready_filtrofir = '1') then
--                        next_state <= BAJO3;
----                    elsif(sample_out_ready_filtrofir = '0') then
--                    else
--                        next_state <= BAJO4;
--                    end if;
----                elsif(direccion_RAM >= direccion_max) then
                    if (cnt_b = 2) then
                        next_state <= BAJO4;
				    else 
                        next_state <= BAJO2;
                    end if;                        
                else
                    next_state <= REPOSO;
                end if; 

			when BAJO3 =>  
				if(sample_request_audioint = '1') then
                    next_state <= BAJO2;
--                elsif(sample_request_audioint = '0') then
                else
                    next_state <= BAJO3;
                end if; 
--                next_state <= BAJO5;
			
			when BAJO4 =>  
				if(sample_out_ready_filtrofir = '1') then
                    next_state <= BAJO3;
--                elsif(sample_out_ready_filtrofir = '0') then
                else
                    next_state <= BAJO4;
                end if;
			
			when ALTO1 =>  
				if (cnt_a = 2) then
                    next_state <= ALTO4;
                else 
                    next_state <= ALTO1;
                end if;           
										
			when ALTO2 =>  
				if(direccion_RAM < direccion_max) then
--                    if(sample_out_ready_filtrofir = '1') then
--                        next_state <= ALTO3;
----                    elsif(sample_out_ready_filtrofir = '0') then
--                    else
--                        next_state <= ALTO4;
--                    end if;
----                elsif(direccion_RAM >= direccion_max) then
                    if (cnt_a = 2) then
                        next_state <= ALTO4;
                    else 
                        next_state <= ALTO2;
                    end if;                        
                else
                    next_state <= REPOSO;
                end if;  

			when ALTO3 =>  
				if(sample_request_audioint = '1') then
                    next_state <= ALTO2;
--                elsif(sample_request_audioint = '0') then
                else
                    next_state <= ALTO3;
                end if;

			when ALTO4 =>  
				if(sample_out_ready_filtrofir = '1') then
                    next_state <= ALTO3;
--                elsif(sample_out_ready_filtrofir = '0') then
                else
                    next_state <= ALTO4;
                end if;              
            end case;
end process;

dir_RAM <= std_logic_vector(to_unsigned(direccion_RAM, 19));

end Behavioral;