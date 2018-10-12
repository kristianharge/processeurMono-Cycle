--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity DataMemory_tb is
 port( Done: out boolean:=FALSE);
end entity DataMemory_tb;

architecture BENCH of DataMemory_tb is
SIGNAL TClk		: STD_LOGIC := '0';
SIGNAL TReset		: STD_LOGIC;
SIGNAL TDataIn : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TDataOut : std_logic_vector (31 downto 0);
SIGNAL TAddr :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL TWrEn : STD_LOGIC;
SIGNAL TDone : boolean;
  
COMPONENT DataMemory IS 
PORT(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
	  DataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		DataOut :  OUT  std_logic_vector (31 downto 0);
		Addr : in  STD_LOGIC_VECTOR(5 DOWNTO 0);
    WrEn : in STD_LOGIC
);
END COMPONENT;

begin
  Done <= TDone;
  UUT: COMPONENT DataMemory PORT MAP(
		Clk	=> TClk,
		Reset		=> TReset,
	  DataIn => TDataIn,
		DataOut => TDataOut,
		Addr => TAddr,
    WrEn => TWrEn);
  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 25 ns;
  -- Generation d'un reset au début
  TReset <= '1', '0' after 1 ns;
        
  stimulus:process
  begin
    wait until TReset = '0';
    TAddr <= (others=> '0');
    TDataIn <= (others=> '0');
    TWrEn <= '0';
    --Verifier si les registres sont bien initialises.
    for i in 0 to 63 loop
      TADDR <= conv_std_logic_vector(i, TADDR'length);
      wait for 1 ps;
      ASSERT TDataOut = "0" REPORT "Initialization failed"  -- Initialization test.
      SEVERITY FAILURE; 
    end loop;
    REPORT "Initialization Test 1 passed." SEVERITY note;
        
    -- Tester l'ecriture 
    TWrEn <= '1';
    for i in 0 to 63 loop
      wait until TClk = '0';
      TADDR <= conv_std_logic_vector(i, TADDR'length);
      TDataIn <= conv_std_logic_vector(i, TDataIn'length);
      wait until TClk = '1';
      ASSERT TDataOut = conv_std_logic_vector(i, TDataIn'length) REPORT "write/read failed"  -- Initialization test.
      SEVERITY FAILURE; 
      
    end loop;    
    REPORT "Write/Read Test passed." SEVERITY note;
    TDone <= TRUE; -- La fin du banc de teste. Le résultat est bon.
    WAIT; -- Boucle infinie
  end process;

  
end architecture BENCH;

