--JAIME JACOBO ROMO GONZÁLEZ
--LAURA MARCO SIMAL

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
--use IEEE.std_logic_unsigned.all;



entity mult8b is
    port(
    X : in std_logic_vector(3 downto 0);
    Y : in std_logic_vector(3 downto 0);
    Z : out std_logic_vector(7 downto 0)
    );
end mult8b;

architecture Mult of mult8b is 
begin
    Z <= std_logic_vector(unsigned(X) * unsigned(Y));
end Mult;

architecture Sumadores of mult8b is
   signal a , b : std_logic_vector(7 downto 0);
   signal aux1, aux2, aux3, aux4 : std_logic_vector(3 downto 0);
   
begin
    aux1 <= (others => y(0));
    aux2 <= (others => y(1));
    aux3 <= (others => y(2));
    aux4 <= (others => y(3));
    a <= std_logic_vector(unsigned("000" & (x and aux2) &  "0") + unsigned("0000" & (x and aux1)));
    b <= std_logic_vector(unsigned("00" & (x and aux3) &  "00") + unsigned(a));
    Z <= std_logic_vector(unsigned("0" & (x and aux4) &  "000") + unsigned(b));

end Sumadores;
