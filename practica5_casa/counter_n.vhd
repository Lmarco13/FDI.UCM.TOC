
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity counter_n is
  generic (n: natural := 4);
    port (
        clk: in std_logic;
        rst: in std_logic;
        enable_count: in std_logic;
        div : in std_logic;
        dout: out std_logic_vector(n-1 downto 0));
end counter_n;

architecture Behavioral of counter_n is
signal aux_output: unsigned(n-1 downto 0);
begin
    process(clk, rst)
    begin
        if rst ='1' then
            aux_output <= (others => '0');
        elsif clk'event and clk='1' then
            if enable_count = '1' and div = '1' then
                aux_output <= (aux_output + 1) MOD 10;
            end if;
         end if;
    end process;
    
    dout <= std_logic_vector(aux_output);

end Behavioral;
