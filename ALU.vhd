LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY ALU IS 
	PORT
	(
		OP :  IN  std_logic_vector (1 downto 0);
		A, B :  IN  std_logic_vector (31 downto 0);
		S :  OUT  std_logic_vector (31 downto 0);
		N : OUT std_logic
	);
END ALU;

ARCHITECTURE Comportemental of ALU is
  signal result: signed (31 downto 0);
  begin
    
    S <= std_logic_vector(result);
    N <= result(31);
    
    process (OP, A, B)
      begin
        result <= (others => '0');
        
        if OP = "00" then
          result <= signed(A) + signed(B);
          
        elsif OP = "01" then
          result <= signed(B);
          
        elsif OP = "10" then
          result <= signed(A) - signed(B);
          
        elsif OP = "11" then
          result <= signed(A);
          
        end if;
      end process;


end Comportemental;