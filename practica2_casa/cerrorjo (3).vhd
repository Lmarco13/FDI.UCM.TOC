-- Laura Marco Simal
-- Jaime Jacobo Romo González 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cerrojo is
    port(
        button    : IN std_logic;
        key       : IN std_logic_vector (7 downto 0);
        rst       : IN std_logic;
        clk       : IN std_logic;
        seg       : OUT std_logic_vector (6 downto 0);
        led       : OUT std_logic_vector (15 downto 0);
        an        : OUT std_logic_vector (3 downto 0)
    );
end cerrojo;


architecture Behavioral of cerrojo is

    component conv_7seg is
    Port ( 
        x : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0)
    );
    end component;
    
    component debouncer IS
    port (
        rst: IN std_logic;
        clk: IN std_logic;
        x: IN std_logic;
        xDeb: OUT std_logic;
        xDebFallingEdge: OUT std_logic;
        xDebRisingEdge: OUT std_logic
    );
    end component;


    type ESTADOS is (S0, S1, S2, S3,S4);
    signal ESTADO, SIG_ESTADO: ESTADOS;
    signal password : std_logic_vector (7 downto 0);
    signal remaining : std_logic_vector (3 downto 0);
    signal segment_out : std_logic_vector (6 downto 0);
    signal xDeb, xDebFallingEdge, xDebRisingEdge: std_logic;
    signal unlocked: std_logic_vector (15 downto 0);
begin    
    
    
    A: conv_7seg port map(remaining, segment_out);
    B: debouncer port map(rst, clk, button, xDeb, xDebFallingEdge, xDebRisingEdge);
        
    an <= "1110";
    seg <= segment_out;
    led <= unlocked;
        
    SYNC: process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst ='1' then
                ESTADO <= S0;
            else
                ESTADO <= SIG_ESTADO;
                if(ESTADO = S0 AND xDebRisingEdge = '1' ) then
                    password <= key;
                end if;   
            end if;
        end if;
    end process SYNC;
    
    COMB: process (ESTADO, xDebRisingEdge, key)
    begin
        SIG_ESTADO <= ESTADO;
        case ESTADO is
        when S0 =>
            remaining <= "0100";
            unlocked <= (others => '1');
            if (xDebRisingEdge = '1') then  SIG_ESTADO <= S1;
            end if;
        when S1 =>
            remaining <= "0011";
            unlocked <= (others => '0');
            if (xDebRisingEdge = '1') then
                if (key = password) then SIG_ESTADO <= S0;
                else SIG_ESTADO <= S2;
                end if;
            end if;
        when S2 =>
            remaining <= "0010";
            unlocked <= (others => '0');
            if (xDebRisingEdge = '1') then
                if (key = password) then SIG_ESTADO <= S0;
                else SIG_ESTADO <= S3;
                end if;
            end if;
        when S3 =>
            remaining <= "0001";
            unlocked <= (others => '0');
            if (xDebRisingEdge = '1') then
                if (key = password) then SIG_ESTADO <= S0;
                else SIG_ESTADO <= S4;   
                end if;
            end if;
        when S4 => 
            remaining <= "0000";
            unlocked <= (others => '0');
    end case;  
    end process COMB;

    
end Behavioral;