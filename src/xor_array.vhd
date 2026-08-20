library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_array is
  Port (a: in std_logic_vector(3 downto 0);
        b: in std_logic_vector(3 downto 0);
        y: out std_logic_vector(3 downto 0)
   );
end xor_array;

architecture Behavioral of xor_array is

begin

y <= a xor b;

end Behavioral;