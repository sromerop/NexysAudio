----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2017 11:21:28
-- Design Name: 
-- Module Name: package_dsed - Behavioral
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

package package_dsed is
    
    constant sample_size : integer := 8;
    
    constant c0_LP, c4_LP : signed := "00000101";   -- 0.039
    constant c1_LP, c3_LP : signed := "00011111";    -- 0.2422
    constant c2_LP : signed := "00111001";  -- 0.4453
    
    constant c0_HP, c4_HP : signed := "11111111";   -- -0.0078
    constant c1_HP, c3_HP : signed := "11100110";   -- -0.2031
    constant c2_HP : signed := "01001101";  -- 0.6015   
    
--    slv_val <= STD_LOGIC_VECTOR(CONV_SIGNED(INTEGER(r_val*128.0),8)); -- 8 bits, 2^(-7) = 1/128 
--    r_val <= REAL(CONV_INTEGER(SIGNED(slv_val)))/128.0;
    
end package_dsed;