library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity celda2 is
Port ( 
    c, x : in std_logic;
    z : out std_logic
);
end celda2;

architecture Behavioral of celda2 is

begin
    
    z <= x and (not c);

end Behavioral;
