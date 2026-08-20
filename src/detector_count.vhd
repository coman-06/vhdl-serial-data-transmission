library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity detector_count is
    Port ( RST         : in STD_LOGIC;
           CLK         : in STD_LOGIC;
           EN          : in STD_LOGIC;
           HEADER_DONE : out STD_LOGIC;
           DATA_DONE   : out STD_LOGIC;
           PACKET_DONE : out STD_LOGIC);
end detector_count;

architecture Behavioral of detector_count is

    signal count: std_logic_vector(5 downto 0) := (others => '0');

begin

    process(RST, CLK)
    begin
    
        if RST = '1' then
            count <= (others => '0');
            HEADER_DONE <= '0';
            DATA_DONE <= '0';
            PACKET_DONE <= '0';
            
        elsif rising_edge(CLK) then
        
            HEADER_DONE <= '0';
            DATA_DONE <= '0';
            PACKET_DONE <= '0';
            
            if EN = '1' then
                
                if count = "000101" then
                    HEADER_DONE <= '1';
                end if;
                    
                if count = "011101" then
                    DATA_DONE <= '1';
                end if;
                
                if count = "100001" then
                    PACKET_DONE <= '1';
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
           
            end if;
        end if;
    end process;

end Behavioral;