library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity detector_cu is
    Port (
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DATA_IN : in STD_LOGIC; 
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
end detector_cu;

architecture Behavioral of detector_cu is

    type state_type is (IDLE, READ_HEADER, READ_DATA, READ_CHECKSUM, VALIDATE, FLUSH_PACKET);
    signal current_state, next_state : state_type;

    signal sig_checksum_flag : STD_LOGIC := '0';
    signal sig_invalid_checksum: STD_LOGIC := '0';
    signal sig_invalid_start: std_logic := '0';
    signal bit_cnt : STD_LOGIC_VECTOR(1 downto 0) := "00";

begin

    process (CLK, RST)
    begin
        if RST = '1' then
            current_state <= IDLE;
            sig_checksum_flag <= '0';
            sig_invalid_checksum <= '0';
            sig_invalid_start <= '0';
            bit_cnt <= "00";
            
        elsif rising_edge(CLK) then
        
            current_state <= next_state;
            
            -- Reset flags when a new transmission starts
            if current_state = IDLE and DATA_IN = '0' then
                sig_checksum_flag <= '0';
                sig_invalid_checksum <= '0';
                sig_invalid_start <= '0';
            end if;
            
            -- Checksum validation
            if current_state = VALIDATE then
                if MATCH_CHECKSUM_EU = '1' then
                    sig_checksum_flag <= '1';
                    sig_invalid_checksum <= '0';
                else
                    sig_checksum_flag <= '0';
                    sig_invalid_checksum <= '1';
                end if;
            end if;
            
            -- Header validation when the header finishes
            if current_state = READ_HEADER and HEADER_DONE_EU = '1' then
                if VALID_START_EU = '1' then
                    sig_invalid_start <= '0';
                else
                    sig_invalid_start <= '1';
                end if;
            end if;

            if current_state = READ_DATA then
                bit_cnt <= bit_cnt + 1;
            else
                bit_cnt <= "00";
            end if;
            
        end if;
    end process;

    CHECKSUM_FLAG <= sig_checksum_flag;
    INVALID_CHECKSUM <= sig_invalid_checksum;
    INVALID_START <= sig_invalid_start;
    
    ENABLE_XOR_EU <= '1' when (current_state = READ_DATA and bit_cnt = "11") else '0';


    process (current_state, DATA_IN, HEADER_DONE_EU, VALID_START_EU, DATA_DONE_EU, PACKET_DONE_EU)
    begin
        
        ENABLE_COUNT_EU <= '0';
        RESET_COUNT_EU <= '0';
        SHIFT_ENABLE_EU <= '0';
        RESET_XOR_EU <= '0';
        HEADER_FLAG <= '0';
        MESSAGE_FLAG <= '0';
        
        case current_state is 
            
            when IDLE =>
                RESET_COUNT_EU <= '1';
                RESET_XOR_EU <= '1';
                
                if DATA_IN = '0' then
                    next_state <= READ_HEADER;
                else
                    next_state <= IDLE;
                end if;
                
            when READ_HEADER =>
                HEADER_FLAG <= '1';
                SHIFT_ENABLE_EU <= '1';
                ENABLE_COUNT_EU <= '1';
                
                if HEADER_DONE_EU = '1' then
                    if VALID_START_EU = '1' then
                        next_state <= READ_DATA;
                    else
                        next_state <= FLUSH_PACKET;
                    end if;
                else
                    next_state <= READ_HEADER;
                end if;

            when FLUSH_PACKET =>
                ENABLE_COUNT_EU <= '1';
                SHIFT_ENABLE_EU <= '1'; 
                
                if PACKET_DONE_EU = '1' then
                    next_state <= IDLE;
                else
                    next_state <= FLUSH_PACKET;
                end if;

            when READ_DATA =>
                HEADER_FLAG <= '1';
                MESSAGE_FLAG <= '1';
                SHIFT_ENABLE_EU <= '1';
                ENABLE_COUNT_EU <= '1';
                
                if DATA_DONE_EU = '1' then
                    next_state <= READ_CHECKSUM;
                else
                    next_state <= READ_DATA;
                end if;
                
            when READ_CHECKSUM =>
                HEADER_FLAG <= '1';
                MESSAGE_FLAG <= '1';
                SHIFT_ENABLE_EU <= '1';
                ENABLE_COUNT_EU <= '1';
                
                if PACKET_DONE_EU = '1' then
                    next_state <= VALIDATE;
                else
                    next_state <= READ_CHECKSUM;
                end if;
                
            when VALIDATE =>
                next_state <= IDLE;
                
            when others =>
                next_state <= IDLE;
                
        end case;
    end process;

end Behavioral;