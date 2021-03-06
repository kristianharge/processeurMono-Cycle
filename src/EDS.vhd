LIBRARY ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

ENTITY EDS IS
  generic ( N : positive range 1 to 32 );
  
	PORT
	(
		A :  IN  std_logic_vector (N-1 downto 0);
		S :  OUT  std_logic_vector (31 downto 0)
	);
END EDS;

ARCHITECTURE Comportemental of EDS is
  begin
    
    S (N-1 downto 0) <= A;
    S (31 downto N) <= ( others => A(N-1) );
    
    --process (A)
      --begin
        --S <= std_logic_vector(resize(unsigned(A),S'length));
        --for I in N to 31 loop
          --S(I) <= A(N-1);
        --end loop;
      --end process;
        
end Comportemental;