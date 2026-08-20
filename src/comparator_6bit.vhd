library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparator_6bit is
  Port (a: in std_logic_vector(5 downto 0); 
        y: out std_logic
  );
end comparator_6bit;

architecture Behavioral of comparator_6bit is

begin
y <= '1' when a = "011100" else '0'; 

end Behavioral;