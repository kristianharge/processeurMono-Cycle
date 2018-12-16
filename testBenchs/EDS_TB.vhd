library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.common.all;

entity EDS_TB is
 port( OK: out boolean:=FALSE);
end entity EDS_TB;

architecture BENCH of EDS_TB is
  constant TN: positive := 16;
  signal TA: std_logic_vector (TN-1 downto 0);
  signal TS: std_logic_vector(31 downto 0);
  
  
begin
  
  UUT: COMPONENT EDS
  generic map(
    N => TN
    )
    
  PORT MAP(
	  A => TA,
    S => TS
  );

  stimulus:process
  begin
        
        wait for 1 ns;
        TA <= "0000000000000001";
        wait for 1 ns;

        wait for 1 ns;
        TA <= "1111111111111001";
        wait for 1 ns;

        OK <= TRUE; -- La fin du banc de teste. Le résultat est bon.
        WAIT; -- Boucle infinie
  end process;

  
end architecture BENCH;

