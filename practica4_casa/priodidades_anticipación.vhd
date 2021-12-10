library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.unsigned;


entity red2 is
generic (n: natural := 15);
port (
    X: in std_logic_vector(n-1 downto 0);
    led: out std_logic_vector(n-1 downto 0)
);
end red2;

architecture Behavioral of red2 is

signal C: std_logic_vector(n downto 0);
component celda2 is
Port ( 
    c, x : in std_logic;
    z : out std_logic
);
end component;

component H is 
port(
    cn, xn1, xn2, xn3 : in std_logic;
    cn1, cn2, cn3 : out std_logic
);
end component;

begin
    C(n) <= '0';
    gen2: for i in 0 to n-1 generate
        u_i : celda2 port map(C(i+1), X(i), led(i));
    end generate gen2;
    ant: for i in 0 to (n-1)/3 generate
        h_i : H port map(
                C(3*i+3), X(3*i+2), X(3*i+1), X(3*i),
                C(3*i+2), C(3*i+1), C(3*i)
                );
    end generate ant;

end Behavioral;
