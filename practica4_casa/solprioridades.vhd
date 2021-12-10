library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity red is
generic (n: natural := 15);
port (
    X: in std_logic_vector(n-1 downto 0);
    led: out std_logic_vector(n-1 downto 0)
);
end red;

architecture Behavioral of red is
signal C: std_logic_vector(n downto 0);

component celda
    port(x, c_in: in std_logic;
        c_out, z: out std_logic);
end component;

begin
c(0) <= '0';

gen1: for i in 0 to n-1 generate
    u: celda port map(X(i),C(i+1),C(i),led(i));
end generate gen1;
c(n) <= '0';

end Behavioral;
