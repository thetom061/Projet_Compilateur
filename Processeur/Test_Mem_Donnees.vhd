--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:53:49 05/07/2021
-- Design Name:   
-- Module Name:   /home/tgiraud/Bureau/4IR/TP_Sys/vhdl/ALU/Test_Mem_Donnees.vhd
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Banc_Mem_Donnee
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Test_Mem_Donnees IS
END Test_Mem_Donnees;
 
ARCHITECTURE behavior OF Test_Mem_Donnees IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Banc_Mem_Donnee
    PORT(
         Addr : IN  std_logic_vector(7 downto 0);
         IN_V : IN  std_logic_vector(7 downto 0);
         RW : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         OUT_V : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Addr : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_V : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal OUT_V : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Banc_Mem_Donnee PORT MAP (
          Addr => Addr,
          IN_V => IN_V,
          RW => RW,
          RST => RST,
          CLK => CLK,
          OUT_V => OUT_V
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here
		
		RST <= '1';
		IN_V <= "00001111";
		RW <= '0';
		wait for 100 ns;
		
		RW <= '1';
		wait for 100 ns;
		
		RST <= '0';

      wait;
   end process;

END;
