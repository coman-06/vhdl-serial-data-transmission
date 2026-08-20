library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to1 is
    Port ( A   : in STD_LOGIC_VECTOR (34 downto 0);
           B   : in STD_LOGIC_VECTOR (34 downto 0);
           C   : in STD_LOGIC_VECTOR (34 downto 0);
           D   : in STD_LOGIC_VECTOR (34 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           Y   : out STD_LOGIC_VECTOR (34 downto 0));
end mux_4to1;

architecture Dataflow of mux_4to1 is
begin

    with SEL select
        Y <= A when "00",
             B when "01",
             C when "10",
             D when "11",
             (others => '0') when others;

end Dataflow;