----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:47:33 05/04/2021 
-- Design Name: 
-- Module Name:    Banc_Mem_Donnee - Behavioral 
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

entity Banc_Mem_Donnee is
    Port ( Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_V : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           OUT_V : out  STD_LOGIC_VECTOR (7 downto 0));
end Banc_Mem_Donnee;

architecture Behavioral of Banc_Mem_Donnee is

	type Memory is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
	signal OUT_DATA: Memory;

begin

	process
		begin
			wait until falling_edge(CLK);
			if (RST = '0') then --Reset - on wipe la memoire
				OUT_DATA <= (others => "00000000");
				OUT_V <= (others => '0');
				
			elsif (RW = '1') then --Read (LOAD)- On copie le contenu de la memoire dans OUT
				OUT_V <= OUT_DATA(to_integer(unsigned(Addr)));
				
			else --Write (STORE)- On copie IN dans la memoire
				OUT_DATA(to_integer(unsigned(Addr))) <= IN_V;
			end if;
	end process;


end Behavioral;

