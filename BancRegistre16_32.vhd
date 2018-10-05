
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
 
ENTITY BancRegistres16_32 IS 
PORT(
	Clk		: in STD_LOGIC;
	Reset		: in STD_LOGIC;
	W : in STD_LOGIC_VECTOR(31 DOWNTO 0);
	RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
	RB : in STD_LOGIC_VECTOR(3 DOWNTO 0);
	RW : in STD_LOGIC_VECTOR(3 DOWNTO 0);
	WE : in STD_LOGIC;
	A : out STD_LOGIC_VECTOR(31 DOWNTO 0);
	B : out STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END BancRegistres16_32;


ARCHITECTURE Comportemental OF BancRegistres16_32 IS

TYPE table IS ARRAY (15 DOWNTO 0) OF
std_logic_vector(31 DOWNTO 0);

FUNCTION init_banc RETURN table IS 
VARIABLE result : table;
  BEGIN 
    FOR i IN 14 DOWNTO 0 loop
        result(i) := (others =>'0');
    END LOOP;
    result(15) := X"00000030";
    RETURN result;
  END init_banc;
SIGNAL Banc : table :=init_banc;
BEGIN
  A <= Banc(to_integer(unsigned(RA)));
  B <= Banc(to_integer(unsigned(RB)));
  REG_ACC : PROCESS(CLK, RA, RB, RW)
  BEGIN
    
    IF RISING_EDGE(CLK) THEN
      IF RESET = '1' THEN
        Banc <= init_banc;
      ELSE        
        IF WE = '1' THEN
              Banc(to_integer(unsigned(RW))) <= W;
        end if;
      END IF;
    END IF;
  END PROCESS;
END Comportemental;