library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.std_logic_unsigned.all;

entity ALU_TB is
 port( OK: out boolean:=FALSE);
end entity ALU_TB;

architecture BENCH of ALU_TB is
  signal TOP: std_logic_vector (1 downto 0);
  signal TA,TB, TS : std_logic_vector(31 downto 0);
  signal TN: std_logic;
  
  component ALU is 
    PORT(
		OP :  IN  std_logic_vector (1 downto 0);
		A, B :  IN  std_logic_vector (31 downto 0);
		S :  OUT  std_logic_vector (31 downto 0);
		N : OUT std_logic
	);
  end component;
  
begin
  
  UUT: COMPONENT ALU PORT MAP(
	  OP => TOP,
      A => TA,
      B => TB,
      S => TS,
      N => TN
      );

  stimulus:process
  begin
        
        wait for 1 ns;
        TOP <= "00";
        TA <= "00000000000000000000000000000001";
        TB <= "00000000000000000000000000100000";
        wait for 1 ns;
        ASSERT TS = TA + TB and TN = '0' REPORT "ERROR: ALU TEST 1 FAILED add 2 positives)" -- ALU Test 1
        SEVERITY FAILURE; 
        REPORT "ALU Test 1 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "00";
        TA <= "00000000000000000000000000000001";
        TB <= "10000000000000000000000000100000";
        wait for 1 ns;
        ASSERT TS = TA + TB and TN = '1' REPORT "ERROR: ALU TEST 2 FAILED add a positive & a negative)" -- ALU Test 2
        SEVERITY FAILURE; 
        REPORT "ALU Test 2 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "00";
        TA <= "11111111111111111111111111111111";
        TB <= "11111111111111111111111111100000";
        wait for 1 ns;
        ASSERT TS = TA + TB and TN = '1' REPORT "ERROR: ALU TEST 3 FAILED add 2 negatives)" -- ALU Test 3
        SEVERITY FAILURE; 
        REPORT "ALU Test 3 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "01";
        TA <= "00000000000000000000000000001001";
        TB <= "00000000000000000000000000100010";
        wait for 1 ns;
        ASSERT TS = TB and TN = '0' REPORT "ERROR: ALU TEST 4 FAILED take positive B" -- ALU Test 4
        SEVERITY FAILURE; 
        REPORT "ALU Test 4 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "01";
        TA <= "00000000000000000000000000001001";
        TB <= "10000000000000000000000000100010";
        wait for 1 ns;
        ASSERT TS = TB and TN = '1' REPORT "ERROR: ALU TEST 5 FAILED take negative B" -- ALU Test 5
        SEVERITY FAILURE; 
        REPORT "ALU Test 5 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "10";
        TA <= "00000000000000000010000000000001";
        TB <= "00000000000000000000000100100001";
        wait for 1 ns;
        ASSERT TS = TA - TB and TN = '0' REPORT "ERROR: ALU TEST 6 FAILED positive sub" -- ALU Test 6
        SEVERITY FAILURE; 
        REPORT "ALU Test 6 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "10";
        TA <= "00000000000000000000000000000001";
        TB <= "00000000000000000000000100100001";
        wait for 1 ns;
        ASSERT TS = TA - TB and TN = '1' REPORT "ERROR: ALU TEST 7 FAILED positive sub, negative result" -- ALU Test 7
        SEVERITY FAILURE; 
        REPORT "ALU Test 7 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "10";
        TA <= "00000000000000000000000000000001";
        TB <= "10000000000000000000000100100001";
        wait for 1 ns;
        ASSERT TS = TA - TB and TN = '0' REPORT "ERROR: ALU TEST 8 FAILED positive & negative sub, positive result" -- ALU Test 8
        SEVERITY FAILURE; 
        REPORT "ALU Test 8 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "10";
        TA <= "11111111111111111111111111111110";
        TB <= "00000000000000000000000000100001";
        wait for 1 ns;
        ASSERT TS = TA - TB and TN = '1' REPORT "ERROR: ALU TEST 9 FAILED positive & negative sub, negative result" -- ALU Test 9
        SEVERITY FAILURE; 
        REPORT "ALU Test 9 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "10";
        TA <= "11111111111111111111111111111111";
        TB <= "11111111111111111111111111110001";
        wait for 1 ns;
        ASSERT TS = TA - TB and TN = '0' REPORT "ERROR: ALU TEST 10 FAILED negative sub, positive result" -- ALU Test 10
        SEVERITY FAILURE; 
        REPORT "ALU Test 10 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "11";
        TA <= "00000000000000000000000000000001";
        TB <= "00000000000000000000000000100000";
        wait for 1 ns;
        ASSERT TS = TA and TN = '0' REPORT "ERROR: ALU TEST 11 FAILED take positive A" -- ALU Test 11
        SEVERITY FAILURE; 
        REPORT "ALU Test 11 passed." SEVERITY note;
        
        wait for 1 ns;
        TOP <= "11";
        TA <= "10000000000000000000000000000001";
        TB <= "00000000000000000000000000100000";
        wait for 1 ns;
        ASSERT TS = TA and TN = '1' REPORT "ERROR: ALU TEST 12 FAILED take negative A" -- ALU Test 12
        SEVERITY FAILURE; 
        REPORT "ALU Test 12 passed." SEVERITY note;


        REPORT "Bench test is successfully finished." SEVERITY note;
        OK <= TRUE; -- La fin du banc de teste. Le résultat est bon.
        WAIT; -- Boucle infinie
  end process;

  
end architecture BENCH;