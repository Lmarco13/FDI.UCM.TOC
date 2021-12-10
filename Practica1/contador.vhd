-- 3º DG 
-- Laura Marco Simal 
-- Jaime Jacobo Romo González

--Librerias necesarias
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
 
entity contador is 
    PORT(
        clk    : in std_logic;
        rst    : in std_logic;
        cuenta : in std_logic;
        salida : out std_logic_vector(3 downto 0)
    );
 end contador; 
 
ARCHITECTURE behavioral OF contador IS 
 
-- Declaraci?n del componente que vamos a simular
 
    COMPONENT registro
    PORT(
        rst   : IN   std_logic;
        clk   : IN   std_logic;
		load  : IN   std_logic;
        E     : IN   std_logic_vector(3 downto 0);
        S     : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
    component sumador
    port(
      a : in  std_logic_vector(3 downto 0);
      b : in  std_logic_vector(3 downto 0);
      c : out std_logic_vector(3 downto 0)
      );
    end component;  
   
    component divisor is
    port (
        rst: in STD_LOGIC;
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
    );
    end component;
    
       
-- Señales intermedias

    signal salida_divisor : std_logic;
    signal salida_sumador : std_logic_vector(3 downto 0);
    signal salida_registro : std_logic_vector(3 downto 0);
    

 
-- Instanciacion de la unidad a simular 
BEGIN
   sum: sumador PORT MAP (
        A => "0001",
        B => salida_registro,
        C => salida_sumador  
   );

   reg: registro PORT MAP (
         rst => rst,
         clk => salida_divisor,
		 load => cuenta,
         E => salida_sumador,
         S => salida_registro
   );
   
   
   div: divisor PORT MAP(
        rst => rst,
        clk_entrada => clk,
        clk_salida => salida_divisor
   );

   salida <= salida_registro;

end behavioral;