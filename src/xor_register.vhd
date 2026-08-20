----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2026 04:42:23 PM
-- Design Name: 
-- Module Name: xor_register - Behavioral
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

entity xor_register is
  Port (d: in std_logic_vector(3 downto 0);
        en: in std_logic;
        q: out std_logic_vector(3 downto 0) := "0000";
        rst: in std_logic;
        clk: in std_logic
   );
end xor_register;

architecture Behavioral of xor_register is
signal aux: std_logic_vector(3 downto 0);
begin

process (clk,rst)

begin

    if rst = '1' then
        aux <= "0000";
    elsif rising_edge(clk) then
        if en ='1' then
            aux <= d;
        end if;
    end if;
end process;

q <= aux;

end Behavioral;