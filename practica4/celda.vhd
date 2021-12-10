library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity celda is
port (
    x : in std_logic; 
    c_in0 , c_in1 : in std_logic;
    c_out1, c_out0, z: out std_logic
);
end celda;

architecture Behavioral of celda is

begin
    c_out1 <= c_in0 and not(x);
    c_out0 <= x;
    z <= x and c_in1;

end Behavioral;
