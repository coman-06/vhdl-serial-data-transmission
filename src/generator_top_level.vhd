library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity generator_top_level is
    Port ( RUN : in STD_LOGIC;
           MODE : in STD_LOGIC_VECTOR (1 downto 0);
           RST : in STD_LOGIC;
           CLK_1HZ : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC);
end generator_top_level;

architecture Behavioral of generator_top_level is

component mux_4to1 is
    Port ( A   : in STD_LOGIC_VECTOR (34 downto 0);
           B   : in STD_LOGIC_VECTOR (34 downto 0);
           C   : in STD_LOGIC_VECTOR (34 downto 0);
           D   : in STD_LOGIC_VECTOR (34 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           Y   : out STD_LOGIC_VECTOR (34 downto 0));
end component mux_4to1;

component piso_reg is
    Port ( D     : in STD_LOGIC_VECTOR (34 downto 0);
           RST   : in STD_LOGIC;
           CLK   : in STD_LOGIC;
           LOAD  : in STD_LOGIC;
           SHIFT : in STD_LOGIC;
           Q     : out STD_LOGIC);
end component piso_reg;

component generator_count is
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           EN : in STD_LOGIC;
           TRANSMISSION_DONE : out STD_LOGIC);
end component generator_count;

component generator_cu is
    Port (
           RUN : in STD_LOGIC;
           MODE : in STD_LOGIC_VECTOR(1 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           
           -- from Generator E.U.
           TRANSMISSION_DONE_EU : in STD_LOGIC;
           
           -- to Generator E.U.
           ENABLE_COUNT_EU : out STD_LOGIC;
           RESET_COUNT_EU : out STD_LOGIC;
           SHIFT_ENABLE_EU : out STD_LOGIC;
           LOAD_PACKET_EU : out STD_LOGIC;
           MUX_SEL_EU : out STD_LOGIC_VECTOR(1 downto 0)
           );
end component generator_cu;

signal A: std_logic_vector (34 downto 0) := "00111001110000001111010001011101111";
signal B: std_logic_vector (34 downto 0) := "00111000110101110011111000101011111" ;
signal C: std_logic_vector (34 downto 0) := "01101001001010100110000010111110000";
signal D: std_logic_vector (34 downto 0) := "00111001001010110010101111100110001";

-- Signals from C.U. to E.U.

signal sig_enable_count : STD_LOGIC;
signal sig_reset_count  : STD_LOGIC;
signal sig_shift_enable : STD_LOGIC;
signal sig_load_packet  : STD_LOGIC;
signal sig_mux_sel      : STD_LOGIC_VECTOR(1 downto 0);

-- Signals from E.U. to C.U.

signal sig_trans_done : STD_LOGIC;
    
-- Data bus strictly inside the E.U.

signal sig_packet_data : STD_LOGIC_VECTOR(34 downto 0);

begin

MUX: mux_4to1 port map (A, B, C, D, sig_mux_sel, sig_packet_data);

PISOREG: piso_reg port map (sig_packet_data, RST, CLK_1HZ, sig_load_packet, sig_shift_enable, DATA_OUT);

COUNTER: generator_count port map (sig_reset_count, CLK_1HZ, sig_enable_count, sig_trans_done);

CONTROLUNIT: generator_cu port map (RUN, MODE, RST, CLK_1HZ, sig_trans_done, sig_enable_count, sig_reset_count, sig_shift_enable, sig_load_packet, sig_mux_sel);

end Behavioral;