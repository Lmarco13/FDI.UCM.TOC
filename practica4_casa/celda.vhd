library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity celda is
port (
    x, c_in: in std_logic; 
    c_out, z: out std_logic
);
end celda;

architecture Behavioral of celda is

begin
    c_out <= c_in or x;
    z <= x and (not(c_in));

end Behavioral;
