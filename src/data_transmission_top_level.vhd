library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_transmission_top_level is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           RUN : in STD_LOGIC;
           MODE : in STD_LOGIC_VECTOR (1 downto 0);
           HEADER_FLAG : out STD_LOGIC;
           MESSAGE_FLAG : out STD_LOGIC;
           CHECKSUM_FLAG : out STD_LOGIC;
           CATHODES : out STD_LOGIC_VECTOR (7 downto 0);
           ANODES : out STD_LOGIC_VECTOR (7 downto 0));
end data_transmission_top_level;

architecture Behavioral of data_transmission_top_level is

    component detector_top_level is
        Port ( CLK_100MHZ : in STD_LOGIC; 
               CLK_1HZ    : in STD_LOGIC; 
               RST : in STD_LOGIC;
               DATA_IN : in STD_LOGIC;
               HEADER_FLAG : out STD_LOGIC;
               MESSAGE_FLAG : out STD_LOGIC;
               CHECKSUM_FLAG : out STD_LOGIC;
               CATHODES: out std_logic_vector (7 downto 0);
               ANODES: out std_logic_vector (7 downto 0));
    end component detector_top_level;

    -- Generator only needs the slow clock
    component generator_top_level is
        Port ( RUN : in STD_LOGIC;
               MODE : in STD_LOGIC_VECTOR (1 downto 0);
               RST : in STD_LOGIC;
               CLK_1HZ : in STD_LOGIC;
               DATA_OUT : out STD_LOGIC);
    end component generator_top_level;

    signal sig_data: std_logic;
    
    -- Signals for the 1 Hz Clock
    signal slow_clk : std_logic := '0';
    constant MAX_COUNT : integer := 49_999_999; -- 50 million cycles toggles clock = 1 Hz period
    signal count : integer range 0 to MAX_COUNT := 0;

begin

    -- Generates the 1 Hz slow clock
    process(CLK, RST)
    begin
        if RST = '1' then
            count <= 0;
            slow_clk <= '0';
        elsif rising_edge(CLK) then
            if count = MAX_COUNT then
                count <= 0;
                slow_clk <= not slow_clk;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    GENERATOR: generator_top_level port map (
        RUN => RUN, 
        MODE => MODE, 
        RST => RST, 
        CLK_1HZ => slow_clk, 
        DATA_OUT => sig_data
    );

    DETECTOR: detector_top_level port map (
        CLK_100MHZ => CLK,       -- Fast clock for the 7-segment display
        CLK_1HZ => slow_clk,     -- Slow clock for the data
        RST => RST, 
        DATA_IN => sig_data, 
        HEADER_FLAG => HEADER_FLAG, 
        MESSAGE_FLAG => MESSAGE_FLAG, 
        CHECKSUM_FLAG => CHECKSUM_FLAG, 
        CATHODES => CATHODES, 
        ANODES => ANODES
    );

end Behavioral;