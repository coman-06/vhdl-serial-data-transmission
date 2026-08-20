library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity piso_reg is
    Port ( D     : in  STD_LOGIC_VECTOR (34 downto 0);
           RST   : in  STD_LOGIC;
           CLK   : in  STD_LOGIC;
           LOAD  : in  STD_LOGIC;
           SHIFT : in  STD_LOGIC;
           Q     : out STD_LOGIC);
end piso_reg;

architecture Behavioral of piso_reg is

    signal packet : STD_LOGIC_VECTOR(34 downto 0) := (others => '1');  

begin

    process(CLK, RST)
    begin
        if RST = '1' then 
            packet <= (others => '1');  

        elsif rising_edge(CLK) then
            if LOAD = '1' then
                packet <= D;

            elsif SHIFT = '1' then
                packet <= packet(33 downto 0) & '0';
            end if;

        end if;
    end process;

    Q <= packet(34);

end Behavioral;
