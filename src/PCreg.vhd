LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY PCreg IS   
	PORT
	(
		clk: in std_logic;
		rst: in std_logic;
		E: in std_logic_vector (31 downto 0);
		S: out std_logic_vector (31 downto 0)
	);
END PCreg;

ARCHITECTURE Comportemental of PCreg is
  begin
  process(clk, rst)
  begin
    if rst = '0' then
            S <= (others => '0');
		elsif rising_edge(clk) then
          S <= E;
    end if;
  end process;
          
end Comportemental;

