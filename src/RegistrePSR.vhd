
library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
 
ENTITY RegistrePSR IS 
PORT(
	DataIn: in STD_LOGIC_VECTOR(31 DOWNTO 0);
	Reset		: in STD_LOGIC;
	Clk		: in STD_LOGIC;
	WE : in  STD_LOGIC;
	DataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END RegistrePSR;


ARCHITECTURE Comportemental OF RegistrePSR IS

SIGNAL InternalData : STD_LOGIC_VECTOR(31 downto 0);

BEGIN

  REG_ACC : PROCESS(CLK, Reset)
  BEGIN
    IF Reset = '1' THEN
      InternalData <= (others => '0');
    ELSE 
      IF RISING_EDGE(CLK) THEN
          IF WE = '1' THEN
            InternalData <= DataIn;
          END IF;
      END IF;
    END IF;
  END PROCESS;
  DataOut <= InternalData; 
END Comportemental;
