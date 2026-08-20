library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity detector_top_level is
    Port ( CLK_100MHZ : in STD_LOGIC;
           CLK_1HZ    : in STD_LOGIC;
           RST : in STD_LOGIC;
           DATA_IN : in STD_LOGIC;
           HEADER_FLAG : out STD_LOGIC;
           MESSAGE_FLAG : out STD_LOGIC;
           CHECKSUM_FLAG : out STD_LOGIC;
           CATHODES: out std_logic_vector (7 downto 0);
           ANODES: out std_logic_vector (7 downto 0));
end detector_top_level;

architecture Behavioral of detector_top_level is

component comparator_4bit is
  Port ( a: in std_logic_vector(3 downto 0);
         b: in std_logic_vector(3 downto 0);
         y: out std_logic
  
   );
end component comparator_4bit;

component comparator_6bit is
  Port (a: in std_logic_vector(5 downto 0); 
        y: out std_logic
  );
end component comparator_6bit;

component detector_count is
    Port ( RST         : in STD_LOGIC;
           CLK         : in STD_LOGIC;
           EN          : in STD_LOGIC;
           HEADER_DONE : out STD_LOGIC;
           DATA_DONE   : out STD_LOGIC;
           PACKET_DONE : out STD_LOGIC);
end component detector_count;

component xor_array is
  Port (
        a : in std_logic_vector(3 downto 0);
        b : in std_logic_vector(3 downto 0);
        y : out std_logic_vector(3 downto 0)
   );
end component xor_array;

component xor_register is
  Port (d   : in std_logic_vector(3 downto 0);
        en  : in std_logic;
        q   : out std_logic_vector(3 downto 0);
        rst : in std_logic;
        clk : in std_logic
        
   );
end component xor_register;

component sipo_register is
  Port (mode: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        d: in std_logic;
        q: out std_logic_vector (5 downto 0)
    );
end component sipo_register;

component detector_cu is
    Port (
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_IN : in STD_LOGIC; -- Comes from the Generator E.U.
           HEADER_FLAG : out STD_LOGIC;
           MESSAGE_FLAG : out STD_LOGIC;
           CHECKSUM_FLAG : out STD_LOGIC;
           INVALID_START : out STD_LOGIC;
           INVALID_CHECKSUM : out STD_LOGIC;
           
           -- from Detector E.U.
           HEADER_DONE_EU : in STD_LOGIC;
           DATA_DONE_EU : in STD_LOGIC;
           PACKET_DONE_EU : in STD_LOGIC;
           VALID_START_EU : in STD_LOGIC;
           MATCH_CHECKSUM_EU : in STD_LOGIC;
           
           -- to Detector E.U.
           ENABLE_COUNT_EU : out STD_LOGIC;
           RESET_COUNT_EU : out STD_LOGIC;
           SHIFT_ENABLE_EU : out STD_LOGIC;
           ENABLE_XOR_EU : out STD_LOGIC;
           RESET_XOR_EU : out STD_LOGIC
           
           );
           
end component detector_cu;

component top_7seg is
  Port ( clk : in std_logic ;
         rst: in std_logic;
         cathodes: out std_logic_vector (7 downto 0);
         anodes: out std_logic_vector (7 downto 0);
         header_done: in std_logic;
         checksum_done: in std_logic;
         invalid_header: in std_logic;
         invalid_checksum: in std_logic
   );
end component top_7seg;

-- From CU to EU
signal sig_enable_count: std_logic;
signal sig_reset_count: std_logic;
signal sig_shift_enable: std_logic;
signal sig_enable_xor: std_logic;
signal sig_reset_xor: std_logic;

-- From EU to CU
signal sig_header_done: std_logic;
signal sig_data_done: std_logic;
signal sig_packet_done: std_logic;
signal sig_valid_start: std_logic;
signal sig_match_check: std_logic;
signal sig_invalid_start: std_logic;
signal sig_invalid_checksum: std_logic;

-- Within EU
signal sig_sipo_out: std_logic_vector(5 downto 0);

-- Data buses for the XOR Accumulator
signal sig_xor_math  : STD_LOGIC_VECTOR(3 downto 0); -- Between Array and Register
signal sig_xor_total : STD_LOGIC_VECTOR(3 downto 0); -- Total output

begin

SIPOREGISTER: sipo_register port map (sig_shift_enable, RST, CLK_1HZ, DATA_IN, sig_sipo_out);

COMPARATOR4BIT: comparator_4bit port map (sig_sipo_out(3 downto 0), sig_xor_total, sig_match_check);

COMPARATOR6BIT: comparator_6bit port map (sig_sipo_out, sig_valid_start);

COUNTER: detector_count port map (sig_reset_count, CLK_1HZ, sig_enable_count, sig_header_done, sig_data_done, sig_packet_done);

XORARRAY: xor_array port map (sig_sipo_out(3 downto 0), sig_xor_total, sig_xor_math);

XORREGISTER: xor_register port map (sig_xor_math, sig_enable_xor, sig_xor_total, sig_reset_xor, CLK_1HZ);

SEGMENT: top_7seg port map (CLK_100MHZ, RST, CATHODES, ANODES, sig_header_done, sig_packet_done, sig_invalid_start, sig_invalid_checksum);

CONTROLUNIT: detector_cu port map (RST, CLK_1HZ, DATA_IN, HEADER_FLAG, MESSAGE_FLAG, CHECKSUM_FLAG, sig_invalid_start,
                                    sig_invalid_checksum, sig_header_done, sig_data_done, sig_packet_done, sig_valid_start,
                                    sig_match_check, sig_enable_count, sig_reset_count, sig_shift_enable, sig_enable_xor, sig_reset_xor); 

end Behavioral;