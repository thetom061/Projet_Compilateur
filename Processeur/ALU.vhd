----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:33:31 04/27/2021 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0); --comme specifie dans le pdf
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

	--copie des signaux pour manipulation
	signal Entree1: STD_LOGIC_VECTOR(8 downto 0);
	signal Entree2: STD_LOGIC_VECTOR(8 downto 0);
	signal Sortie: STD_LOGIC_VECTOR(7 downto 0);
	signal ADD: STD_LOGIC_VECTOR(8 downto 0);
	signal SUB: STD_LOGIC_VECTOR(8 downto 0);
	signal MUL: STD_LOGIC_VECTOR(15 downto 0); --La multiplication prend 2*taille_max_entrees dans le pire des cas
	
begin

	--Lien entre Entrees et A/B
	Entree1 <= "0"& A;
	Entree2 <= "0"& B;
	
	--Definition des operations
	ADD <= Entree1 + Entree2; 
	SUB <= Entree1 - Entree2;
	MUL <= A * B;
	
	--selection des operations
	Sortie <= ADD(7 downto 0) when Ctrl_Alu = "001" 
	else SUB(7 downto 0) when Ctrl_Alu = "010" 
	else MUL(7 downto 0) when Ctrl_Alu = "011" 
	else (others => '0');
		  
	--Traitement des flags
	N <= '1' when ADD(8) = '1' and Ctrl_Alu = "001"
	else '1' when SUB(8) = '1' and Ctrl_Alu = "010"
	else '0'; --Le flag N s'active quand la valeur de sortie de l'operation est negative c.a.d. le bit de poids fort vaut 1
	
	O <= '1' when MUL(15 downto 8) = "00000000" and Ctrl_Alu = "011"
	else '0'; -- Le flag O s'active quand il y a un debordement ce qui est possible seulement avec la multiplication quand les bits autre que 0 a 7 valent qqch
	
	Z <= '1' when Sortie = "00000000" and Ctrl_Alu /= "000"
	else '0'; --Le flag Z s'active quand la sortie est nulle
	
	C <= '1' when ADD(8) = '1' and Ctrl_Alu = "001" 
	else '0'; -- Le flag C s'active quand il y a une retenue dans l'addition, c.a.d. quand le bit de poids fort vaut 1
		  
	--Lien entre S et Sortie
	S <= Sortie;
	
end Behavioral;