--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.common.all;

entity MonoProcessor_tb is
 port( Done: out boolean:=FALSE);
end entity MonoProcessor_tb;

architecture BENCH of MonoProcessor_tb is
SIGNAL TClk	: STD_LOGIC := '0';
SIGNAL TReset : STD_LOGIC;
SIGNAL TBusW :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TDone	: boolean;
 

begin
  Done <= TDone;
  UUT: COMPONENT MonoProcessor PORT MAP(
    Clk	=> TClk,
    Reset => TReset,
    BusW => TBusW);
  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 25 ns;
  -- Generation d'un reset au début
  TReset <= '1', '0' after 1 ns;
        

  
end architecture BENCH;

