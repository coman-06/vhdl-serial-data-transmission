library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity generator_count is
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           TRANSMISSION_DONE : out STD_LOGIC);
end generator_count;

architecture Behavioral of generator_count is

    signal count: std_logic_vector(5 downto 0) := (others => '0');

begin

    process(RST, CLK)
    begin
    
        if RST = '1' then
            count <= (others => '0');
            
        elsif rising_edge(CLK) then
        
            if EN = '1' then

                if count = "100010" then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
        
    end process;

    TRANSMISSION_DONE <= '1' when count = "100001" else '0';
    
end Behavioral;