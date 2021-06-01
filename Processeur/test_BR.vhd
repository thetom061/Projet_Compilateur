--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:51:48 05/04/2021
-- Design Name:   
-- Module Name:   /home/tgiraud/Bureau/4IR/TP_Sys/vhdl/ALU/test_BR.vhd
-- Project Name:  ALU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Banc_registres
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
 
ENTITY test_BR IS
END test_BR;
 
ARCHITECTURE behavior OF test_BR IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Banc_registres
    PORT(
         Addr_A : IN  std_logic_vector(3 downto 0);
         Addr_B : IN  std_logic_vector(3 downto 0);
         Addr_W : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Addr_A : std_logic_vector(3 downto 0) := (others => '0');
   signal Addr_B : std_logic_vector(3 downto 0) := (others => '0');
   signal Addr_W : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Banc_registres PORT MAP (
          Addr_A => Addr_A,
          Addr_B => Addr_B,
          Addr_W => Addr_W,
          W => W,
          DATA => DATA,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
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

      -- insert stimulus here 
		RST <= '1';
		Addr_A <= "0111";
		Addr_B <= "0110";
		
		wait for 100 ns;
		W <= '1';
		DATA <= "11111111";
		Addr_W <= "0001";
		
		wait for 100 ns;
		DATA <= "11110000";
		Addr_W <= "1000";
		
		wait for 100 ns;
		RST <= '0';

      wait;
   end process;

END;
