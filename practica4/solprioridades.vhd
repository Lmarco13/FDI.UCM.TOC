library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity red is
generic (n: natural := 15);
port (
    X: in std_logic_vector(n-1 downto 0);
    led: out std_logic_vector(n-1 downto 0);
    seg : out std_logic_vector (6 downto 0);
    an : out std_logic_vector(3 downto 0)
);
end red;

architecture Behavioral of red is
signal C0 , C1: std_logic_vector(n downto 0);


type cont_type is array (n downto 0) of std_logic_vector(3 downto 0);
signal C : cont_type;

component celda is
port (
    x : in std_logic; 
    c_in0 , c_in1 : in std_logic;
    c_out0, c_out1, z: out std_logic
);
end component;

component contador is
    Port ( x: in std_logic;
            c_in : in std_logic_vector (3 downto 0);
             c_out : out std_logic_vector (3 downto 0));
end component ; 


component conv_7seg is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           display : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

begin

an <= "1110";
C0(0) <= '0';
C1(0) <= '0';
C(0) <= "0000";

d : conv_7seg port map( C(n) , seg);

gen1: for i in 0 to n-1 generate
    u: celda port map(X(i),C0(i),C1(i),C0(i+1), C1(i+1),led(i));
end generate gen1;
gen2: for i in 0 to n-1 generate
    u: contador port map(X(i), C(i) ,C(i+1));
end generate gen2;

end Behavioral;
