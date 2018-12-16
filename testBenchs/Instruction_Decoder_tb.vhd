--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use work.common.all;

entity Instruction_Decoder_tb is
 port( Done: out boolean:=FALSE);
end entity Instruction_Decoder_tb;

architecture BENCH of Instruction_Decoder_tb is
  SIGNAL TDone : boolean := FALSE;
  signal Tinstr_type: enum_instruction; 
  SIGNAL TnPCSEL : std_logic;
  SIGNAL TRegWr : STD_LOGIC  ;
  SIGNAL TALUSrc : STD_LOGIC;
  SIGNAL TALUCtr : STD_LOGIC_VECTOR(1 downto 0);
  SIGNAL TPSREn : STD_LOGIC;
  SIGNAL TMemWr : STD_LOGIC;
  SIGNAL TWrSrc : STD_LOGIC;
  SIGNAL TRA,TRB,TRW : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL TRegSel : STD_LOGIC;
  SIGNAL TPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PSR : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL TInstruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
  Signal TOffset : STD_LOGIC_VECTOR(23 downto 0);
  Signal TImm : STD_LOGIC_VECTOR(7 downto 0);
  

begin
  Done <= TDone;
  
  UUT0: COMPONENT instruction_memory PORT MAP(
    PC => TPC,
    Instruction => TInstruction);
  
  UUT1: COMPONENT Instruction_Decoder PORT MAP(
    Instruction => TInstruction,
	PSR => PSR,
    nPCSEL => TnPCSEL,
    RegWr => TRegWr,
    ALUSrc => TALUSrc,
    ALUCtr => TALUCtr,
    PSREn => TPSREn,
    MemWr => TMemWr,
    WrSrc => TWrSrc,
    RA => TRA,
    RB => TRB,
    RW => TRW,
    RegSel => TRegSel,
    Offset => TOffset,
    Imm => TImm,
    instr_type => Tinstr_type);
  
  stimulus:process
  begin
	TPC <= X"00000000";
    wait for 1 ps;
	ASSERT Tinstr_type = MOV REPORT "Decoding instruction(0) / MOV failed"
	SEVERITY FAILURE;
	
	TPC <= X"00000001";
    wait for 1 ps;
	ASSERT Tinstr_type = MOV REPORT "Decoding instruction(1) / MOV failed"
	SEVERITY FAILURE;
	
	TPC <= X"00000002";
    wait for 1 ps;  
	ASSERT Tinstr_type = LDR REPORT "Decoding instruction(2) / LDR failed"
	SEVERITY FAILURE;
	
	TPC <= X"00000003";
    wait for 1 ps;
	ASSERT Tinstr_type = ADDr REPORT "Decoding instruction(3) / ADDr failed"
	SEVERITY FAILURE;
    
	TPC <= X"00000004";
    wait for 1 ps;
	ASSERT Tinstr_type = ADDi REPORT "Decoding instruction(4) / ADDi failed"
	SEVERITY FAILURE;
	
	TPC <= X"00000005";
    wait for 1 ps;
	ASSERT Tinstr_type = CMP REPORT "Decoding instruction(5) / CMP failed"
	SEVERITY FAILURE;
    
	TPC <= X"00000006";
    wait for 1 ps;
	ASSERT Tinstr_type = BLT REPORT "Decoding instruction(6) / BLT failed"
	SEVERITY FAILURE;
    
	TPC <= X"00000007";
    wait for 1 ps;
	ASSERT Tinstr_type = STR REPORT "Decoding instruction(7) / STR failed"
	SEVERITY FAILURE;
  
	TPC <= X"00000008";
    wait for 1 ps;	
	ASSERT Tinstr_type = LDR REPORT "Decoding instruction(8) / LDR failed"
	SEVERITY FAILURE;
	
	TPC <= X"00000009";
    wait for 1 ps;	
	ASSERT Tinstr_type = BAL REPORT "Decoding instruction(9) / BAL failed"
	SEVERITY FAILURE;
    
	
    
    TDone <= TRUE; -- La fin du banc de teste. Le résultat est bon.
    WAIT; -- Boucle infinie
  end process;

  
end architecture BENCH;

