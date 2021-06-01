----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:09:30 05/07/2021 
-- Design Name: 
-- Module Name:    Banc_Mem_Instr - Behavioral 
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

entity Banc_Mem_Instr is
    Port ( Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           OUT_V : out  STD_LOGIC_VECTOR (31 downto 0));
end Banc_Mem_Instr;

architecture Behavioral of Banc_Mem_Instr is

	type Memory is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
	signal OUT_DATA: Memory := ( --Ordre: Operation, Registre, Valeur, Valeur
		0  => "00000110" & "00000001" & "00000010" & "00000000", -- r1 = 2
		5  => "00000101" & "00000011" & "00000001" & "00000000", -- r3 = r1
		10 => "00000001" & "00000100" & "00000001" & "00000011", -- r4 = 1+3
		15 => "00000011" & "00000101" & "00000100" & "00000001", -- r5 = 4*2
		20 => "00000010" & "00000010" & "00000101" & "00000100", -- r2 = 8-4
		25 => "00001000" & "00001000" & "00000010" & "00000000", -- store r2 @8
		30 => "00001000" & "00010100" & "00000101" & "00000000", -- store r5 @20
		35 => "00000111" & "00000111" & "00001000" & "00000000", -- load mem@8  dans r7
		40 => "00000111" & "00001000" & "00010100" & "00000000", -- load mem@20 dans r8
		others => (others => '0')
	);

begin

	OUT_V <= OUT_DATA(to_integer(unsigned(Addr)));

end Behavioral;

