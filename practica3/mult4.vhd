-- Laura Marco Simal
-- Jaime Jacobo Romo González
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity mult4 is
    Port ( 
     X : IN std_logic_vector(3 downto 0);
     Y : IN std_logic_vector(3 downto 0);
     Z : OUT std_logic_vector(7 downto 0);
    rst : IN  std_logic;
    clk  : IN  std_logic
     );
end mult4;

architecture Behavioral of mult4 is
component registro is
  Port (
    rst  : IN  std_logic;
    clk  : IN  std_logic;
    load : IN  std_logic;
    E    : IN  std_logic_vector(7 downto 0);
    S    : OUT std_logic_vector(7 downto 0)   
  );
end component;

  signal aux1, aux2, aux3, aux4 : std_logic_vector(3 downto 0);
  signal a , b : std_logic_vector(7 downto 0);
  signal c, d : std_logic_vector(7 downto 0);

begin
u : registro port map(rst, clk, '1' , a , c);
v : registro port map(rst, clk, '1' , b , d);

aux1 <= (others => y(0));
aux2 <= (others => y(1));
aux3 <= (others => y(2));
aux4 <= (others => y(3));

a <= std_logic_vector(unsigned("00" & (x and aux3) &  "00") + unsigned("0" & (x and aux4) &  "000"));
b <= std_logic_vector(unsigned("000" & (x and aux2) &  "0") + unsigned("0000" & (x and aux1)));

Z <= std_logic_vector(unsigned(c)+unsigned(d));


end Behavioral;
