
----------- Squelette du Banc de Test pour l'exercice MinMax -------------
--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;
use work.common.all;

entity RegistrePSR_tb is
 port(Done: out boolean:=FALSE);
end entity RegistrePSR_tb;

architecture BENCH of RegistrePSR_tb is
	SIGNAL TDataIn: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL TReset		:STD_LOGIC;
	SIGNAL TClk		: STD_LOGIC := '0';
	SIGNAL TWE :  STD_LOGIC;
	SIGNAL TDataOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL TDone : boolean := false;
  
begin
  Done <= TDone;
  UUT: COMPONENT RegistrePSR PORT MAP(
	DataIn => TDataIn,
	Reset => TReset,
	Clk => TClk,
	WE => TWE,
	DataOut => TDataOut);
	
  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 1 ns;
  -- Generation d'un reset au d?ut
  TReset <= '1', '0' after 1 ns;
        
  stimulus:process
  begin
    TWE <= '0';
    TDataIn <= X"FFFFFFFF";
    
    wait until TReset = '1';
    wait for 1 ps;
    assert TDataOut = X"0" report "Reset failed"
		SEVERITY failure;
    wait until TReset = '0';
    
		wait until TClk = '0';
    wait until TClk = '1';
    assert TDataOut = X"0" report "Write disable failed"
		SEVERITY failure;
  		wait until TClk = '0';
    TWE <= '1';
    TDataIn <= X"00000001";
    wait until TClk = '1';
    wait for 1 ps;
    assert TDataOut = X"00000001" report "Write failed"
		SEVERITY failure;

  		wait until TClk = '0';
    TWE <= '1';
    TDataIn <= X"000000F0";
  		wait until TClk = '1';
    wait for 1 ps;
    assert TDataOut = X"000000F0" report "Write failed"
		SEVERITY failure;
		REPORT "Register PSR testbench passed.";
		
        
    TDone <= TRUE; -- La fin du banc de teste. Le résultat est bon.
    WAIT; -- Boucle infinie
  end process;
end architecture BENCH;

