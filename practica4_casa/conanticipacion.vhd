
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity conanticipacion is
generic (n: natural := 15);
port (X: in std_logic_vector(n-1 downto 0);
        led: out std_logic_vector(n-1 downto 0));
end conanticipacion;

architecture Behavioral of conanticipacion is

begin


end Behavioral;
