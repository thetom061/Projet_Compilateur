--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:20:18 05/12/2021
-- Design Name:   
-- Module Name:   /home/tgiraud/Bureau/4IR/TP_Sys/vhdl/ALU/Test_Processeur.vhd
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Processeur
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
 
ENTITY Test_Processeur IS
END Test_Processeur;
 
ARCHITECTURE behavior OF Test_Processeur IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Processeur
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Processeur PORT MAP (
          CLK => CLK,
          RST => RST
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
      wait for 20 ns;
		rst <= '1';
      wait for 200 ns;

      -- insert stimulus here 
		
      wait;
   end process;

END;
