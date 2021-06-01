----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:08 04/29/2021 
-- Design Name: 
-- Module Name:    Banc_registres - Behavioral 
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

entity Banc_registres is
    Port ( Addr_A : in  STD_LOGIC_VECTOR (3 downto 0);
           Addr_B : in  STD_LOGIC_VECTOR (3 downto 0);
           Addr_W : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
end Banc_registres;

architecture Behavioral of Banc_registres is
	--Definition du banc de registres
	type registres is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
	signal Banc_reg: registres;
	
begin

	process
		begin
			wait until rising_edge(CLK);
			if (RST = '0') then --Reset - on wipe
				Banc_reg <= (others => (others => '0'));
			elsif (W = '1') then --Write - On copie DATA dans le BR
				Banc_reg(to_integer(unsigned(Addr_W))) <= DATA;
			end if;
	end process;
	
	--Lien entre BR, QA et QB en traitant alea lecture/ecriture en meme temps
	QA <= Banc_reg(to_integer(unsigned(Addr_A))) when W = '0' or Addr_W /= Addr_A 
		else DATA;
	QB <= Banc_reg(to_integer(unsigned(Addr_B))) when W = '0' or Addr_W /= Addr_B 
		else DATA;

end Behavioral;

