library IEEE;
use IEEE.std_logic_1164.ALL;


entity H is 
port(
    cn, xn1, xn2, xn3 : in std_logic;
    cn1, cn2, cn3 : out std_logic
);
end H;

architecture Behavioral of H is
begin

    cn1 <= cn or xn1;
    cn2 <= cn or xn1 or xn2;
    cn3 <= cn or xn1 or xn2 or xn3;
    
end Behavioral;