--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.common.all;

entity ProcessingUnit_tb is
 port( Done: out boolean:=FALSE);
end entity ProcessingUnit_tb;


Architecture bench of ProcessingUnit_tb is
	Signal TClk		: STD_LOGIC := '0'; --overall
	Signal Treset	: STD_LOGIC := '1'; --overall
	Signal TWrEn_Reg : STD_LOGIC; --banc de registres
	Signal TRA : STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
	Signal TRB : STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
	Signal TRW : STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
	Signal TBusW : STD_LOGIC_VECTOR(31 DOWNTO 0); --banc de registres
	Signal TImm : STD_LOGIC_VECTOR(7 DOWNTO 0); --extension de signe
	Signal TSEL1: Std_logic; --1er mux2
	Signal TSEL2 : Std_logic; --2e mux2
	Signal TWrEn_DM : Std_logic; --data memory
	Signal TOP : Std_logic_vector (1 downto 0); --ALU
	Signal Tflag: Std_logic; --ALU
	Signal TDone: boolean := false; 
Begin
  UUT : Component ProcessingUnit PORT MAP
	(
		Clk => TClk,
		Reset	=> TReset,
		WrEn_Reg => TWrEn_Reg,
		RA => TRA,
		RB => TRB,
		RW => TRW,
		busW => TBusw,
		Imm => TImm,
		SEL1 => TSel1,
		SEL2 => TSel2,
		WrEn_DM => TWrEn_DM,
		OP => TOP,
		flag => TFlag);
	Done <= TDone;
  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 25 ns;
  -- Generation d'un reset au debut
  TReset <= '1', '0' after 1 ns;

  test_bench : process
  begin
  TRA <= "0000"; -- Banc_Reg 16x32bits => Default assignment
  TRB <= "0000"; -- Banc_Reg 16x32bits => Default assignment 
  TWrEn_DM <= '0'; -- Data Memory => Disable write.
  TSel2 <= '0'; -- Mux2 => Choose ALU output.
  
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRW <= "0000"; -- Banc_Reg 16x32bits => Write in Reg(0)
  TImm <= "00001111"; -- Sign Extender => 15
  TSel1 <= '1'; -- Mux 1 => Choose Sign Extender.
  TOP <= "01"; --ALU => output is Sign Extender.  
  wait until TClk = '0';
  wait until TClk = '1';
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.
  assert TBusW = X"0000000F" report "Writing to Register(0) failed." severity failure;
  report "Writing to Register(0) passed." severity note;
  
  wait until TClk = '0';
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRW <= "0001"; -- Banc_Reg 16x32bits => Write in Reg(1)
  TImm <= "00000001"; -- Sign Extender => 1
  TSel1 <= '1'; -- Mux 1 => Choose Sign Extender.
  TOP <= "01"; --ALU => output is Sign Extender.  
  wait until TClk = '1';
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  assert TBusW = X"00000001" report "Writing to Register(1) failed." severity failure;
  report "Writing to Register(1) passed." severity note;
  
  Report "Test : Add => begin." severity note;
  wait until TClk = '0';
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRA <= "0000"; -- Banc_Reg 16x32bits => Read Reg(0) and load it into bus A
  TRB <= "0001"; -- Banc_Reg 16x32bits => Read Reg(1) and load it into bus B
  TRW <= "0010"; -- Banc_Reg 16x32bits => Write result in Reg(2)
  TSel1 <= '0'; -- Mux 1 => Choose Bus B.
  TOP <= "00"; -- ALU => Bus A + Bus B
  TSel2 <= '0'; -- Mux2 => Choose ALU output.
  wait until TClk = '1';    
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  TRA <= "1011"; -- Banc_Reg 16x32bits => Read Reg(11) and load it into bus A
  TOP <= "11"; -- ALU => Bus A
  wait for 1 ps;
  assert TBusW = X"00000000" report "Register(11) doesn't have the right value." severity failure;
  TRA <= "0010"; -- Banc_Reg 16x32bits => Read Reg(2) and load it into bus A
  wait for 1 ps;
  assert TBusW = X"00000010" report "Add test failed." severity failure;
  report "Add test passed." severity note;
  
  Report "Test : Sub => begin." severity note;
  wait until TClk = '0';
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRA <= "0010"; -- Banc_Reg 16x32bits => Read Reg(2) and load it into bus A
  TRB <= "0001"; -- Banc_Reg 16x32bits => Read Reg(1) and load it into bus B
  TRW <= "0100"; -- Banc_Reg 16x32bits => Write result in Reg(4)
  TSel1 <= '0'; -- Mux 1 => Choose Bus B.
  TOP <= "10"; -- ALU => Bus A - Bus B
  TSel2 <= '0'; -- Mux2 => Choose ALU output.
  wait until TClk = '1';    
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  TRA <= "1011"; -- Banc_Reg 16x32bits => Read Reg(11) and load it into bus A
  TOP <= "11"; -- ALU => Bus A
  wait for 1 ps;
  assert TBusW = X"00000000" report "Register(11) doesn't have the right value." severity failure;
  TRA <= "0100"; -- Banc_Reg 16x32bits => Read Reg(4) and load it into bus A
  wait for 1 ps;
  assert TBusW = X"0000000F" report "Sub test failed." severity failure;
  report "Sub test passed." severity note;
  
   
  Report "Test : Add immediate => begin." severity note;
  wait until TClk = '0';
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRA <= "0000"; -- Banc_Reg 16x32bits => Read Reg(0) and load it into bus A
  TImm <= "00000001"; -- Sign Extender => 1
  TRW <= "0011"; -- Banc_Reg 16x32bits => Write result in Reg(3)
  TSel1 <= '1'; -- Mux 1 => Choose Sign Extender.
  TOP <= "00"; -- ALU => Bus A + Sign Extender
  TSel2 <= '0'; -- Mux2 => Choose ALU output.
  wait until TClk = '1';    
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  TRA <= "1011"; -- Banc_Reg 16x32bits => Read Reg(11) and load it into bus A
  TOP <= "11"; -- ALU => Bus A
  wait for 1 ps;
  assert TBusW = X"00000000" report "Register(11) doesn't have the right value." severity failure;
  TRA <= "0011"; -- Banc_Reg 16x32bits => Read Reg(3) and load it into bus A
  wait for 1 ps; 
  assert TBusW = X"00000010" report "Add test immediate failed." severity failure;
  report "Add test immediate passed." severity note;
  


  Report "Test : Sub immediate => begin." severity note;
  wait until TClk = '0';
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRA <= "0011"; -- Banc_Reg 16x32bits => Read Reg(1) and load it into bus A
  TImm <= "00000001"; -- Sign Extender => 1
  TRW <= "0011"; -- Banc_Reg 16x32bits => Write result in Reg(3)
  TSel1 <= '1'; -- Mux 1 => Choose Sign Extender.
  TOP <= "10"; -- ALU => Bus A + Sign Extender
  TSel2 <= '0'; -- Mux2 => Choose ALU output.
  wait until TClk = '1';    
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  wait until TClk = '0';  
  TRA <= "1011"; -- Banc_Reg 16x32bits => Read Reg(11) and load it into bus A
  TOP <= "11"; -- ALU => Bus A
  wait until TClk = '1';  
  assert TBusW = X"00000000" report "Register(11) doesn't have the right value." severity failure;
  wait until TClk = '0';  
  TRA <= "0011"; -- Banc_Reg 16x32bits => Read Reg(3) and load it into bus A
  wait until TClk = '1';  
  assert TBusW = X"0000000F" report "Sub test immediate failed." severity failure;
  report "Sub test immediate passed." severity note;
  
  Report "Test : Copy of a register into another register => begin" severity note;
  wait until TClk = '0';
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRA <= "1111"; -- Banc_Reg 16x32bits => Read Reg(15) and load it into bus A
  TRW <= "0000"; -- Banc_Reg 16x32bits => Write result in Reg(4)
  TOP <= "11"; -- ALU => Choose Bus A
  TSel2 <= '0'; -- Mux2 => Choose ALU output.
  wait until TClk = '1';    
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  TRA <= "1011"; -- Banc_Reg 16x32bits => Read Reg(11) and load it into bus A
  TOP <= "11"; -- ALU => Bus A
  wait for 1 ps;
  assert TBusW = X"00000000" report "Register(11) doesn't have the right value." severity failure;
  TRA <= "0000"; -- Banc_Reg 16x32bits => Read Reg(0) and load it into bus A
  wait for 1 ps; 
  assert TBusW = X"00000030" report "Copy test failed." severity failure;
  report "Copy test passed." severity note;

  Report "Test : Writing a word to a registre from the memoiry => begin" severity note;
  TWrEn_DM <= '1'; -- Data Memory => Enable write.
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Enable write.
  TRA <= "0011"; -- Banc_Reg 16x32bits => Read Reg(3) and load it into bus A 
  TRB <= "1111"; -- Banc_Reg 16x32bits => Read Reg(15) and load it into bus B
  TOP <= "11"; -- ALU => Choose Bus A => ADDR of Data Memory
  TSel2 <= '1'; -- Mux2 => Choose Data Memory
  wait until TClk = '1';     
  TWrEn_DM <= '0'; -- Data Memory => Disable write.
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  wait for 1 ps;
  assert TBusW = X"00000030" report "BusW doesn't have the right value." severity failure;
  TRA <= "1011"; -- Banc_Reg 16x32bits => Read Reg(11) and load it into bus A
  TOP <= "11"; -- ALU => Bus A
  wait for 1 ps;
  assert TBusW = X"00000000" report "Register(11) doesn't have the right value." severity failure;
 
  Report "Test : Loading a word from the memory to a register => begin" severity note;
  wait until TClk = '0';
  TWrEn_DM <= '0'; -- Data Memory => Disable write.
  TWrEn_Reg <= '1'; -- Banc_Reg 16x32bits => Enable write.
  TRA <= "0011"; -- Banc_Reg 16x32bits => Read Reg(3) and load it into bus A 
  TRW <= "1010"; -- Banc_Reg 16x32bits => Read Reg(10) and load it into bus B
  TOP <= "11"; -- ALU => Choose Bus A => ADDR of Data Memory
  TSel2 <= '1'; -- Mux2 => Choose Data Memory output
  wait until TClk = '1';
  TWrEn_Reg <= '0'; -- Banc_Reg 16x32bits => Disable write.  
  TRA <= "1011"; -- Banc_Reg 16x32bits => Read Reg(11) and load it into bus A
  TOP <= "11"; -- ALU => Bus A
  TSel2 <= '0'; -- Mux2 => Choose ALUoutput
  wait for 1 ps;
  assert TBusW = X"00000000" report "Register(11) doesn't have the right value." severity failure;
  TRA <= "1010"; -- Banc_Reg 16x32bits => Read Reg(0) and load it into bus A
  wait for 1 ps; 
  assert TBusW = X"00000030" report "Write / Load test failed." severity failure;
  report "Write/Load test passed." severity note;
   

  TDone <= TRUE;
  Wait;
  end process;
  
End BENCH;
