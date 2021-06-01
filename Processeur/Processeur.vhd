----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:59:46 05/11/2021 
-- Design Name: 
-- Module Name:    Processeur - Behavioral 
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

entity Processeur is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
end Processeur;

architecture Behavioral of Processeur is

	--La on declare tous nos autres .vhd avec leurs ports
	
	COMPONENT Banc_Mem_Instr
	Port (  Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           OUT_V : out  STD_LOGIC_VECTOR (31 downto 0));
	end COMPONENT;
	
	COMPONENT Banc_registres
	Port (  Addr_A : in  STD_LOGIC_VECTOR (3 downto 0);
           Addr_B : in  STD_LOGIC_VECTOR (3 downto 0);
           Addr_W : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
	end COMPONENT;
	
	COMPONENT ALU
	Port (  A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC);
	end COMPONENT;
	
	COMPONENT Banc_Mem_Donnee
	Port (  Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_V : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           OUT_V : out  STD_LOGIC_VECTOR (7 downto 0));
	end COMPONENT;
	
	--Et la on declare tous les trucs du schema du processeur du pdf
	
	signal LIDI_A: std_logic_vector(7 downto 0);
	signal LIDI_OP: std_logic_vector(7 downto 0); --Ca ca vient du truc de 32 bits
	signal LIDI_B: std_logic_vector(7 downto 0);  --qui sort de Banc_Mem_Instr
	signal LIDI_C: std_logic_vector(7 downto 0);
	------------------------------------------------------------
	signal DIEX_A: std_logic_vector(7 downto 0);
	signal DIEX_OP: std_logic_vector(7 downto 0);
	signal DIEX_B: std_logic_vector(7 downto 0);
	signal DIEX_C: std_logic_vector(7 downto 0);
	------------------------------------------------------------
	signal ExMem_A: std_logic_vector(7 downto 0);
	signal ExMem_OP: std_logic_vector(7 downto 0);
	signal ExMem_B: std_logic_vector(7 downto 0);
	------------------------------------------------------------
	signal MemRe_A: std_logic_vector(7 downto 0);
	signal MemRe_OP: std_logic_vector(7 downto 0);
	signal MemRe_B: std_logic_vector(7 downto 0);
	
	--Et ici on declare les signaux pour faire le lien avec les components
	
	signal IP: std_logic_vector (7 downto 0) := "00000000";
	signal LIDI: std_logic_vector (31 downto 0);
	
	signal LC1: std_logic_vector(2 downto 0);
	signal LC2: std_logic;
	signal LC3: std_logic;
	
	signal S_OUT: std_logic_vector(7 downto 0);
	signal N: std_logic;
	signal O: std_logic;
	signal Z: std_logic;
	signal C: std_logic;
	
	signal Q_A: std_logic_vector(7 downto 0);
	signal Q_B: std_logic_vector(7 downto 0);
	signal Mem_OUT: std_logic_vector(7 downto 0);
	signal Mux_Mem_Don: std_logic_vector(7 downto 0);

begin
	
	--On instancie les composants avec les signaux correspondants
	
	mem_instr: Banc_Mem_Instr PORT MAP (
		Addr => IP, 
		CLK => CLK, 
		OUT_V => LIDI
	);
	
	---------------------------------------------------
	banc_reg: Banc_registres PORT MAP (
		Addr_A => LIDI_B(3 downto 0),
		Addr_B => LIDI_C(3 downto 0),
		Addr_W => MemRe_A(3 downto 0),
		W => LC3,
		DATA => MemRe_B,
		RST => RST,
		CLK => CLK,
		QA => Q_A,
		QB => Q_B
	);
	---------------------------------------------------
	LC1 <= "001" when DIEX_OP(2 downto 0) = "001"
		else "010" when DIEX_OP(2 downto 0) = "010"
		else "011" when DIEX_OP(2 downto 0) = "011" 
		else (others => '0'); --Propagation des operations
	
	my_alu : ALU PORT MAP (
		A => DIEX_B,
		B => DIEX_C,
		Ctrl_Alu => LC1,
		S => S_OUT,
		N => N,
		O => O,
		Z => Z,
		C => C
	);
	---------------------------------------------------
	LC2 <= '1' when ExMem_OP = "00000111"
	else '0' when ExMem_OP = "00001000"
	else '0'; --TRaitement LOAD ou STORE x7 et x8
	
	Mux_Mem_Don <= ExMem_A when ExMem_OP = "00001000"
	else ExMem_B;
	
	mem_don : Banc_Mem_Donnee PORT MAP (
		Addr => Mux_Mem_Don,
		IN_V => ExMem_B,
		RW => LC2,
		RST => RST,
		CLK => CLK,
		OUT_V => Mem_OUT
	);
	---------------------------------------------------
	LC3 <= '0' when MemRe_OP = "00001000" 
	else '1'; --On ecrit tout le temps sauf pour l'instruction store
	
	
	process
		begin
			wait until rising_edge(CLK);
			
			if RST = '0' then
				IP <= "00000000";
			else
				IP <= IP + 1;
				--On "connecte" les signaux en affectant les valeurs d'un etage au suivant
				--comme specifie sur le schema
				
				LIDI_A <= LIDI(23 downto 16);
				LIDI_OP <= LIDI(31 downto 24);
				LIDI_B <= LIDI(15 downto 8);
				LIDI_C <= LIDI(7 downto 0);
				---------------------------------------------------
				DIEX_A <= LIDI_A;
				DIEX_OP <= LIDI_OP;
				--Traitement du MUX COP
				if LIDI_OP = "00000101" or LIDI_OP(2 downto 0) = "001" or LIDI_OP(2 downto 0) = "010" or LIDI_OP(2 downto 0) = "011" then
					DIEX_B <= Q_A;
				else
					DIEX_B <= LIDI_B;
				end if;
				DIEX_C <= Q_B;
				---------------------------------------------------
				ExMem_A <= DIEX_A;
				ExMem_OP <= DIEX_OP;
				--MUX Operations
				if DIEX_OP(2 downto 0) = "001" or DIEX_OP(2 downto 0) = "010" or DIEX_OP(2 downto 0) = "011" then
					ExMem_B <= S_OUT; 
				else 
					ExMem_B <= DIEX_B;
				end if;
				---------------------------------------------------
				--MUX @Memoire Donnees
--				if ExMem_OP = "00001000" then
--					Mux_Mem_Don <= ExMem_A;
--				else
--					Mux_Mem_Don <= ExMem_B;
--				end if;
				
				MemRe_A <= ExMem_A;
				MemRe_OP <= ExMem_OP;
				--MUX LOAD/STORE
				if ExMem_OP = "00000111" or ExMem_OP = "00001000" then
					MemRe_B <= Mem_OUT;
				else
					MemRe_B <= ExMem_B;
				end if;
			end if;
			
	end process;
	
end Behavioral;

