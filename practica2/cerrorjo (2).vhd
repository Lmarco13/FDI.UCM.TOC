-- Laura Marco Simal
-- Jaime Jacobo Romo Gonz�lez 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cerrojo is
    port(
        button    : IN std_logic;
        key       : IN std_logic_vector (7 downto 0);
        at        : IN std_logic_vector (3 downto 0);
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
    
    component efectosLEDs is
    Port (
        rst             : IN  std_logic;
        clk             : IN  std_logic;
        opCode          : IN  std_logic_vector(2 downto 0);
        LEDs            : OUT std_logic_vector(15 downto 0)   
    );
    end component;


    type ESTADOS is (S0, S1, S2, S3);
    signal ESTADO, SIG_ESTADO: ESTADOS;
    signal password : std_logic_vector (7 downto 0);
    signal remaining : std_logic_vector (3 downto 0);
    signal attempts : std_logic_vector (3 downto 0);
    signal intentosRegistro : std_logic_vector (3 downto 0);
    signal segment_out : std_logic_vector (6 downto 0);
    signal xDeb, xDebFallingEdge, xDebRisingEdge: std_logic;
   
    signal opCode: std_logic_vector (2 downto 0);
begin    
    
    
    A: conv_7seg port map(remaining, segment_out);
    B: debouncer port map(rst, clk, button, xDeb, xDebFallingEdge, xDebRisingEdge);
    C: efectosLEDs port map(rst, clk, opCode, led);
        
    an <= "1110";
    seg <= segment_out;
    
        
    SYNC: process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst ='1' then
                ESTADO <= S0;
            else
                ESTADO <= SIG_ESTADO;
                if(ESTADO = S0 AND xDebRisingEdge = '1' ) then
                    password <= key;
                elsif (ESTADO = S1 and xDebRisingEdge = '1') then
                    attempts <= at;
                    if (attempts = "0000") then ESTADO <= S0;
                    end if;
                end if;   
            end if;
        end if;
    end process SYNC;
    
    COMB2: process (ESTADO, xDebRisingEdge, key, intentosRegistro)
    begin

        SIG_ESTADO <= ESTADO;
        case ESTADO is
        when S0 =>
            remaining <= "1111";
            opCode <= "001";
            if (xDebRisingEdge = '1') then  SIG_ESTADO <= S1;
            end if;
        when S1 =>
            remaining <= "1111";
            opCode <= "000";
            intentosRegistro <= attempts;
            if (xDebRisingEdge = '1') then SIG_ESTADO <= S2;
            end if;
        when S2 =>
            remaining <= intentosRegistro;
            opCode <= "000";
            if (xDebRisingEdge = '1') then
                if (key = password) then SIG_ESTADO <= S0;
                else intentosRegistro <= std_logic_vector(unsigned(intentosRegistro) - 1);
                end if;
                if (intentosRegistro = "0000") then SIG_ESTADO <= S3; 
                end if;
            end if;
        when S3 =>
            opCode <= "010";
            remaining <= "0000";
    
    end case;  
    end process COMB2;
    
   
end Behavioral;