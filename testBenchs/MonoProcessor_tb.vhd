--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
use work.common.all;

entity MonoProcessor_tb is
 port( Done: out boolean:=FALSE);
end entity MonoProcessor_tb;

architecture BENCH of MonoProcessor_tb is
SIGNAL TClk	: STD_LOGIC := '0';
SIGNAL TReset : STD_LOGIC := '1';
SIGNAL TBusW :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL TDone	: boolean;
SIGNAL R0_Value :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL R2_Value :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	Tinstr_type:  enum_instruction;
--SIGNAL OPERAND1 :  UNSIGNED(31 DOWNTO 0);
--SIGNAL OPERAND2 :  UNSIGNED(31 DOWNTO 0);
--SIGNAL RESULT :  UNSIGNED(31 DOWNTO 0);
 

begin
  Done <= TDone;
  UUT: COMPONENT MonoProcessor PORT MAP(
    Clk	=> TClk,
    Reset => TReset,
    BusW => TBusW,
    instr_type => Tinstr_type);
  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 25 ns;
  -- Generation d'un reset au début
  TReset <= '1', '0' after 10 ns;
        
  stimulus : process
  begin
    wait until TReset = '0';
    
    for i in 0 to 1 loop    
    Assert TBusW = x"00000020" Report "Instruction mov failed. BusW =/= 32." 
    Severity Failure;
    R0_Value <= TBusW;
    wait until TClk = '1';
    wait for 1 ps;
    Assert TBusW = x"00000000" Report "Instruction mov failed. BusW =/= 0." 
    Severity Failure;
    R2_Value <= TBusW;
    for i in 0 to 9 loop    
      wait until TClk = '1';
      wait for 1 ps;
      Assert TBusW = STD_LOGIC_VECTOR(to_unsigned(32 + i, 32))
      Report "Instruction LDR failed. BusW =/= 32 + i." 
      Severity Failure;
      R0_Value <= TBusW;
           
      wait until TClk = '1';      
      R2_Value <= STD_LOGIC_VECTOR(unsigned(R2_Value) + unsigned(R0_Value));
      wait for 1 ps;
      Assert TBusW = R2_Value Report "Instruction ADDr failed. BusW =/= (R2 + R0)." 
      Severity Failure;

      wait until TClk = '1';
      wait for 1 ps;
      Assert TBusW = STD_LOGIC_VECTOR(to_unsigned(32 + i + 1, 32))
      Report "Instruction ADDi failed. BusW =/= 32 + i" 
      Severity Failure;
      
      wait until TClk = '1';
      wait for 1 ps;
      Report "Instruction comparison executed" 
      Severity note;
      
      wait until TClk = '1';
      wait for 1 ps;
      Report "Instruction branch_less_than executed" 
      Severity note;
    end loop;
    
    wait until TClk = '1';      
    wait for 1 ps;
    Report "Instruction executed. BusW =/= R2." 
    Severity note;
      
    wait until TClk = '1';      
    wait for 1 ps;
    Assert TBusW = R2_Value Report "Instruction STR failed. R2 =/= R3." 
    Severity Failure;
    
    
    wait until TClk = '1';      
    wait for 1 ps;
    Report "Instruction branch_always executed" 
    Severity note;
    
    
    wait until TClk = '1';      
    wait for 1 ps;
    end loop;
    
    Report "Ran 2 cycles of program counters (2 iterations of whiles)." 
    Severity Note;
    Report "Testbench finished. Monocycle processor works correctly." 
    Severity Note;
    TDone <= true;
    
  end process;
  
end architecture BENCH;

