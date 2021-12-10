library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity maqtp is 
    Port ( 
        pulsadores : in std_logic_vector(1 downto 0); -- pulsadores(0) es el bot�n de inicio y pulsadores(1) el de fin
        clk        : in std_logic;
        rst        : in std_logic;
        led        : out std_logic_vector(15 downto 0);
        seg        : out std_logic_vector (6 downto 0);
        an         : out std_logic_vector (3 downto 0)
     );
end maqtp;

architecture Behavioral of maqtp is

component debouncer IS
  PORT (
    rst: IN std_logic;
    clk: IN std_logic;
    x: IN std_logic;
    xDeb: OUT std_logic;
    xDebFallingEdge: OUT std_logic;
    xDebRisingEdge: OUT std_logic
  );
END component;

component efectosLEDs is
    Port (
        rst             : IN  std_logic;
        clk             : IN  std_logic;
        opCode          : IN  std_logic_vector(2 downto 0);
        lEDs            : OUT std_logic_vector(15 downto 0)   
    );
    end component;
    
    
component counter_n is
    generic (n: natural := 4);
    port (
        clk: in std_logic;
        rst: in std_logic;
        enable_count: in std_logic;
        div : in std_logic;
        dout: out std_logic_vector(n-1 downto 0));
end component;

component divisor is
    port (
        rst: in STD_LOGIC;
        clk: in STD_LOGIC; -- reloj de entrada de la entity superior
        cuenta_medio_segundo: out STD_LOGIC;
        cuenta_display1: out STD_LOGIC;
        cuenta_display2: out STD_LOGIC
    );
end component;


component displays is
    Port ( 
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;       
        digito_0 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_1 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_2 : in  STD_LOGIC_VECTOR (3 downto 0);
        digito_3 : in  STD_LOGIC_VECTOR (3 downto 0);
        display : out  STD_LOGIC_VECTOR (6 downto 0);
        display_enable : out  STD_LOGIC_VECTOR (3 downto 0)
     );
end component;
    


    type ESTADOS is (S0,S1,S2,S3,S4);
    signal ESTADO, SIG_ESTADO : ESTADOS;
    signal xDeb, xDebFallingEdge, startButton: std_logic;
    signal xDeb1, xDebFallingEdge1, endButton: std_logic;
    signal opCode: std_logic_vector (2 downto 0);
    signal cont1out , cont2out, cont3out: std_Logic_vector (3 downto 0);
    signal cuentams,cuentadis1,cuentadis2 : std_logic;
    signal encount1, encount2 : std_logic; -- Con dos se�ales de contadores es suficiente (los contadores de los displays se activan a la vez)
    signal rstcont: std_logic; -- rst de los contadores
    
    signal dinero: unsigned(3 downto 0);
begin

    A : debouncer port map(rst,clk,pulsadores(0),xDeb1, xDebFallingEdge1, startButton);
    B : debouncer port map(rst,clk,pulsadores(1),xDeb, xDebFallingEdge, endButton);
    C : efectosLEDs port map(rst,clk,opCode,led);
    DISPLAY: displays port map(rst, clk, cont1out, cont2out, "1111", "1111", seg, an);
    DIV  : divisor port map (rst, clk, cuentams, cuentadis1, cuentadis2);
    CONTADOR1 : counter_n port map(clk, rstcont, encount1, cuentadis1, cont1out);
    CONTADOR2 : counter_n port map(clk, rstcont, encount1,cuentadis2, cont2out);
    CONTADOR3 : counter_n port map(clk,   rstcont, encount2,cuentams, cont3out);
    
    
   
    
    SYNC: process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst ='1' then
                ESTADO <= S0;
            else
                ESTADO <= SIG_ESTADO;   
            end if;
        end if;
    end process SYNC;
    
    COMB2: process (ESTADO, startButton, endButton)
        begin
        SIG_ESTADO <= ESTADO;
        rstcont <= '0';
        case ESTADO is
        when S0 =>
            encount1 <= '0';  encount2 <= '0';
            rstcont <= '1';
            opCode <= "100";
            if (startButton = '1') then  SIG_ESTADO <= S1;
            end if;
        when S1 =>
            opCode <= "000";
            --CONTADORES CONTANDO
            encount1 <= '1'; encount2 <= '0';
            if (endButton = '1') then SIG_ESTADO <= S2;
            end if;
        when S2 =>   
            encount1 <= '0';  encount2 <= '0';       
            if (cont1out = cont2out) then SIG_ESTADO <= S3;
            else SIG_ESTADO <= S4;
            end if;
            SIG_ESTADO <= S3;
        when S3 =>
            opCode <= "011";
            encount1 <= '0'; encount2 <= '1';
            if (unsigned(cont3out) = 9) then SIG_ESTADO <= S0;      
            end if;
        when S4 =>
            opCode <= "010";
            encount1 <= '0'; encount2 <= '1';
            if (unsigned(cont3out) = 9) then SIG_ESTADO <= S0;      
            end if;
        end case;  
    end process COMB2;
end Behavioral;
