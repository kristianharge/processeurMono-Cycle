library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.std_logic_unsigned.all;

entity mux2TB is
 port( OK: out boolean:=FALSE);
end entity mux2TB;

architecture BENCH of mux2TB is
  constant TN: positive := 32;
  signal TCOM: std_logic;
  signal TA,TB, TS : std_logic_vector(TN-1 downto 0);
  
  component Mux2 is
    generic
	   (
	     N : positive range 1 to 32
	   );
    PORT(
		COM :  IN  std_logic;
		A, B :  IN  std_logic_vector (N-1 downto 0);
		S :  OUT  std_logic_vector (N-1 downto 0)
	);
  end component;
  
begin
  
  UUT: COMPONENT Mux2
  generic map(
    N => TN
    )
  
  PORT MAP(
		  COM => TCOM,
      A => TA,
      B => TB,
      S => TS
      );

  stimulus:process
  begin
        
        wait for 1 ns;
        TCOM <= '0';
        TA <= "00000000000000000000000000000001";
        TB <= "00000000000000000000000000100000";
        wait for 1 ns;
        ASSERT TS = TA REPORT "ERROR: Mux2 TEST 1 FAILED add 2 positives)" -- Mux Test 1
        SEVERITY FAILURE; 
        REPORT "Mux Test 1 passed." SEVERITY note;
        
        wait for 1 ns;
        TCOM <= '0';
        TA <= "00000000000000000000100000000001";
        TB <= "00000000000000000000000000100000";
        wait for 1 ns;
        ASSERT TS = TA REPORT "ERROR: Mux2 TEST 2 FAILED add 2 positives)" -- Mux Test 2
        SEVERITY FAILURE; 
        REPORT "Mux Test 2 passed." SEVERITY note;
        
        wait for 1 ns;
        TCOM <= '1';
        TA <= "00000000000000000000000000000001";
        TB <= "00000000000000000000000000100000";
        wait for 1 ns;
        ASSERT TS = TB REPORT "ERROR: Mux2 TEST 3 FAILED add 2 positives)" -- Mux Test 3
        SEVERITY FAILURE; 
        REPORT "Mux Test 3 passed." SEVERITY note;
        
        wait for 1 ns;
        TCOM <= '1';
        TA <= "00000000000000000000000000000001";
        TB <= "00000000000010000000000000100000";
        wait for 1 ns;
        ASSERT TS = TB REPORT "ERROR: Mux2 TEST 4 FAILED add 2 positives)" -- Mux Test 4
        SEVERITY FAILURE; 
        REPORT "Mux Test 4 passed." SEVERITY note;


        REPORT "Bench test is successfully finished." SEVERITY note;
        OK <= TRUE; -- La fin du banc de teste. Le résultat est bon.
        WAIT; -- Boucle infinie
  end process;

  
end architecture BENCH;

