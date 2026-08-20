library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ssd_driver is
    Port ( Rst      : in  STD_LOGIC;
           Clk      : in  STD_LOGIC;
           Data     : in  STD_LOGIC_VECTOR (47 downto 0); 
           Cathodes : out STD_LOGIC_VECTOR (7 downto 0);
           Anodes   : out STD_LOGIC_VECTOR (7 downto 0));
end ssd_driver;

architecture Behavioral of ssd_driver is

    component alpha_7seg is
        Port ( DataIn : in  STD_LOGIC_VECTOR (5 downto 0);
               SegOut : out STD_LOGIC_VECTOR (7 downto 0)); 
    end component;

    signal refresh_cnt   : integer range 0 to 100000 := 0;
    signal counter       : integer range 1 to 8 := 1;
    
    signal cathodes_data : STD_LOGIC_VECTOR (5 downto 0);
    signal cathodes_wire : STD_LOGIC_VECTOR (7 downto 0);
    signal anode_wire    : STD_LOGIC_VECTOR (7 downto 0);

begin

    converter: alpha_7seg port map (cathodes_data, cathodes_wire);

    -- Which Anode to turn ON
    anode_wire <= not x"80" when counter = 1 else
                  not x"40" when counter = 2 else
                  not x"20" when counter = 3 else
                  not x"10" when counter = 4 else
                  not x"08" when counter = 5 else
                  not x"04" when counter = 6 else
                  not x"02" when counter = 7 else
                  not x"01" when counter = 8 else
                  x"FF";
                  
    -- Which Data chunk to read
    cathodes_data <= Data(47 downto 42) when counter = 1 else
                     Data(41 downto 36) when counter = 2 else
                     Data(35 downto 30) when counter = 3 else
                     Data(29 downto 24) when counter = 4 else
                     Data(23 downto 18) when counter = 5 else
                     Data(17 downto 12) when counter = 6 else
                     Data(11 downto 6)  when counter = 7 else
                     Data(5 downto 0)   when counter = 8 else
                     "000000";
                     
    process (Rst, Clk)
    begin
        if Rst = '1' then
            refresh_cnt <= 0;
            counter <= 1;
            Anodes <= x"FF";
            Cathodes <= x"FF";
            
        elsif rising_edge(Clk) then
            
            if refresh_cnt = 100000 then
                refresh_cnt <= 0;
                if counter < 8 then
                    counter <= counter + 1;
                else
                    counter <= 1;
                end if;
            else
                refresh_cnt <= refresh_cnt + 1;
            end if;

            if refresh_cnt < 1000 then
                Anodes <= x"FF";
                Cathodes <= x"FF";
            else
                Anodes <= anode_wire;
                Cathodes <= cathodes_wire;
            end if;
            
        end if;
    end process;

end Behavioral;