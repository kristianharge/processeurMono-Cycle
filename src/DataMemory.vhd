LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
USE work.common.all;

ENTITY DataMemory IS 
	PORT
	(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
		DataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		DataOut :  OUT  std_logic_vector (31 downto 0);
		Addr : in  STD_LOGIC_VECTOR(5 DOWNTO 0);
    WrEn : in STD_LOGIC
	);
END DataMemory;

ARCHITECTURE Behavioral of DataMemory is  

FUNCTION init_banc RETURN table IS 
VARIABLE result : table;
  BEGIN 
    FOR i IN 0 to 63 loop
      --  result(i) := (others =>'0');
		    result(i) := STD_LOGIC_VECTOR(TO_UNSIGNED(i,32));
    END LOOP;
    RETURN result;
  END init_banc;
SIGNAL Banc : table :=init_banc;
begin
  stimulus : process (Clk)
  begin
      if reset = '1' then
        Banc <= init_banc;
      elsif rising_edge(Clk) then
        if WrEn = '1' then
          Banc(to_integer(Unsigned(Addr))) <= DataIn;
        end if;
      end if;
  end process;
  DataOut <= Banc(to_integer(Unsigned(Addr)));
end Behavioral;

