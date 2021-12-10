
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.std_logic_unsigned.all;

entity contador is
    Port ( x: in std_logic;
            c_in : in std_logic_vector (3 downto 0);
             c_out : out std_logic_vector (3 downto 0));
end contador;

architecture Behavioral of contador is


begin

c_out <=  std_logic_vector(unsigned(c_in) + ("000" & x));

end Behavioral;
