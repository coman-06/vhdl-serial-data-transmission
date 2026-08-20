library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sipo_register is
  Port (mode: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        d: in std_logic;
        q: out std_logic_vector (5 downto 0)
    );
end sipo_register;

architecture Behavioral of sipo_register is

signal aux: std_logic_vector(5 downto 0) := "000000";

begin

process (clk, rst)

begin
    if rst = '1' then
        aux <= "000000";    
    elsif rising_edge(clk) then
        if mode = '1' then
            aux(5 downto 1) <= aux(4 downto 0);
            aux(0) <= d;
        end if;
    end if;
end process;
q <= aux;
end Behavioral;