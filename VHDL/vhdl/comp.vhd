----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:36:59 05/18/2024 
-- Design Name: 
-- Module Name:    comp - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comp is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           equal : out  STD_LOGIC;
           greater : out  STD_LOGIC;
           less : out  STD_LOGIC);
end comp;

architecture Behavioral of comp is

begin
 -- Processus pour la comparaison
    process (A, B)
    begin
        if A = B then
            equal <= '1';       -- Si A est égal à B
            greater <= '0';
            less <= '0';
        elsif A > B then
            equal <= '0';
            greater <= '1';     -- Si A est supérieur à B
            less <= '0';
        else
            equal <= '0';
            greater <= '0';
            less <= '1';        -- Si A est inférieur à B
        end if;

    end process;

end Behavioral;

