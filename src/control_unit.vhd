library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generator_cu is
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
end generator_cu;

architecture Behavioral of generator_cu is

    type state_type is (IDLE, LOAD_DATA, TRANSMIT, WAIT_UNPRESS);
    signal current_state, next_state : state_type;

begin

    process (CLK, RST)
    begin
        if RST = '1' then
            current_state <= IDLE;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    process (current_state, RUN, TRANSMISSION_DONE_EU, MODE)
    begin
        
        ENABLE_COUNT_EU <= '0';
        RESET_COUNT_EU <= '0';
        SHIFT_ENABLE_EU <= '0';
        LOAD_PACKET_EU <= '0';
        MUX_SEL_EU <= MODE;

        case current_state is 
            
            when IDLE =>
                RESET_COUNT_EU <= '1';
                
                if RUN = '1' then
                    next_state <= LOAD_DATA;
                else
                    next_state <= IDLE;
                end if;
                
            when LOAD_DATA =>
            
                LOAD_PACKET_EU <= '1';
                next_state <= TRANSMIT;
                
            when TRANSMIT =>

                SHIFT_ENABLE_EU <= '1';
                ENABLE_COUNT_EU <= '1';
                
                if TRANSMISSION_DONE_EU = '1' then
                    next_state <= WAIT_UNPRESS;
                else
                    next_state <= TRANSMIT;
                end if;
            when WAIT_UNPRESS =>
                if RUN = '0' then
                    next_state <= IDLE;
                else
                    next_state <= WAIT_UNPRESS;
                end if;
            when others =>
                next_state <= IDLE;
                
        end case;
    end process;

end Behavioral;