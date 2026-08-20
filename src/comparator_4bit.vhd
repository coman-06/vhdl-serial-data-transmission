library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_4bit is
  Port ( a: in std_logic_vector(3 downto 0);
         b: in std_logic_vector(3 downto 0);
         y: out std_logic := 'Z'
  
   );
end comparator_4bit;

architecture Behavioral of comparator_4bit is

begin
y <= '1' when a = b else '0';

end Behavioral;