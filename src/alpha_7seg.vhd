library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alpha_7seg is
    Port ( 
        DataIn : in  STD_LOGIC_VECTOR (5 downto 0);
        SegOut : out STD_LOGIC_VECTOR (7 downto 0)  -- DP, g, f, e, d, c, b, a
    );
end alpha_7seg;

architecture Behavioral of alpha_7seg is

    signal seg_7 : STD_LOGIC_VECTOR(6 downto 0);
    
begin

    process(DataIn)
    
    begin
    
        case DataIn is
        
            -- Digits 0-9
            when "000000" => seg_7 <= "0111111"; -- 0
            when "000001" => seg_7 <= "0000110"; -- 1
            when "000010" => seg_7 <= "1011011"; -- 2
            when "000011" => seg_7 <= "1001111"; -- 3
            when "000100" => seg_7 <= "1100110"; -- 4
            when "000101" => seg_7 <= "1101101"; -- 5
            when "000110" => seg_7 <= "1111101"; -- 6
            when "000111" => seg_7 <= "0000111"; -- 7
            when "001000" => seg_7 <= "1111111"; -- 8
            when "001001" => seg_7 <= "1101111"; -- 9

            -- Letters A-Z
            when "001010" => seg_7 <= "1110111"; -- A
            when "001011" => seg_7 <= "1111100"; -- b
            when "001100" => seg_7 <= "0111001"; -- C
            when "001101" => seg_7 <= "1011110"; -- d
            when "001110" => seg_7 <= "1111001"; -- E
            when "001111" => seg_7 <= "1110001"; -- F
            when "010000" => seg_7 <= "0111101"; -- G
            when "010001" => seg_7 <= "1110110"; -- H
            when "010010" => seg_7 <= "0000110"; -- I
            when "010011" => seg_7 <= "0011110"; -- J
            when "010100" => seg_7 <= "1110101"; -- K
            when "010101" => seg_7 <= "0111000"; -- L
            when "010110" => seg_7 <= "1010101"; -- M
            when "010111" => seg_7 <= "1010100"; -- n
            when "011000" => seg_7 <= "1011100"; -- o
            when "011001" => seg_7 <= "1110011"; -- P
            when "011010" => seg_7 <= "1100111"; -- q
            when "011011" => seg_7 <= "1010000"; -- r
            when "011100" => seg_7 <= "1101101"; -- S
            when "011101" => seg_7 <= "1111000"; -- t
            when "011110" => seg_7 <= "0011100"; -- u
            when "011111" => seg_7 <= "0011100"; -- v
            when "100000" => seg_7 <= "0101010"; -- W
            when "100001" => seg_7 <= "1110110"; -- X
            when "100010" => seg_7 <= "1101110"; -- y
            when "100011" => seg_7 <= "1011011"; -- Z
            
            when others   => seg_7 <= "0000000"; -- Blank
        end case;
    end process;
    
    SegOut(7) <= not seg_7(0); -- a
    SegOut(6) <= not seg_7(1); -- b
    SegOut(5) <= not seg_7(2); -- c
    SegOut(4) <= not seg_7(3); -- d
    SegOut(3) <= not seg_7(4); -- e
    SegOut(2) <= not seg_7(5); -- f
    SegOut(1) <= not seg_7(6); -- g
    SegOut(0) <= '1';          -- dp (Active-low)

end Behavioral;