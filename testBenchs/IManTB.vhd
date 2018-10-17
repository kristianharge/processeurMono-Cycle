library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity IManTB is
 port(Done: out boolean:=FALSE);
end entity IManTB;


Architecture bench of IManTB is
  
  signal TClk, TReset, TnPCSel: std_logic;
  signal TInstruc : std_logic_vector (31 downto 0);
  signal TOff : std_logic_vector (23 downto 0);
  signal Start : boolean := false;
  
  component InstructionManager IS 
	PORT
	(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
		Offset : in std_logic_vector (23 downto 0);
		nPCSel : in std_logic;
		Instruction :  OUT  std_logic_vector (31 downto 0)
	);
  END component;
  
  begin
    UUT: COMPONENT InstructionManager PORT MAP(
	    Clk => TClk,
      Reset => TReset,
      Offset => TOff,
      nPCSel => TnPCSel,
      Instruction => TInstruc
    );
    

  -- Generation d'une horloge
  TClk <= '0' when not Start else not TClk after 2 ns;
  -- Generation d'un reset au debut
  TReset <= '1', '0' after 5 ns;

  test_bench : process
  begin
   
   wait for 1 ns;
        Start <= true;
        TOff <= "000000000000000000000001";
        TnPCSel <= '0';
        wait for 10 ns;
        ASSERT signed(TInstruc) = signed(TOff) + 1 REPORT "ERROR: InstructionManager TEST 1 FAILED)" -- InstructionManager Test 1
        SEVERITY FAILURE; 
        REPORT "InstructionManager Test 1 passed." SEVERITY note;
        

  Done <= TRUE;
  Wait;
  end process;
  
End BENCH;