library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_7seg is
  Port ( clk : in std_logic ;
         rst: in std_logic;
         cathodes: out std_logic_vector (7 downto 0);
         anodes: out std_logic_vector (7 downto 0);
         header_done: in std_logic;
         checksum_done: in std_logic;
         invalid_header: in std_logic;
         invalid_checksum: in std_logic
   );
end top_7seg;

architecture Behavioral of top_7seg is

component ssd_driver is
    Port ( Rst : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Data: in STD_LOGIC_VECTOR (47 downto 0);
           Cathodes : out STD_LOGIC_VECTOR (7 downto 0);
           Anodes : out STD_LOGIC_VECTOR (7 downto 0));
end component;


signal data: std_logic_vector (47 downto 0);

constant header_done_msg : std_logic_vector(47 downto 0) :=
        "010001" & "001110" & "001010" & "001101" & "001101" & "011000" & "010111" & "001110";
constant checksum_done_msg: std_logic_vector(47 downto 0) :=
        "001100" & "011100" & "011110" & "010110" & "001101" & "011000" & "010111" & "001110";
constant header_fail_msg: std_logic_vector(47 downto 0) :=
        "010001" & "001110" & "001010" & "001101" & "001111" & "001010" & "010010" & "010101";
constant checksum_fail_msg : std_logic_vector(47 downto 0) :=
        "001100" & "011100" & "011110" & "010110" & "001111" & "001010" & "010010" & "010101";
constant blank : std_logic_vector(47 downto 0) :=
        "111111111111111111111111111111111111111111111111";
begin

c1: ssd_driver port map (rst, clk, data, cathodes, anodes);

process (clk, rst)

begin

    if rst = '1' then
        data <= blank;
    
    elsif rising_edge(clk) then
        if header_done = '1' then
            data <= header_done_msg;
        elsif checksum_done = '1' then
            data <= checksum_done_msg;
        elsif invalid_header = '1' then
            data <= header_fail_msg;
        elsif invalid_checksum = '1' then
            data <= checksum_fail_msg;
        end if;
    end if;
end process;
end Behavioral;