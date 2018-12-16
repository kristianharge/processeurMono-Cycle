library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
use work.common.all;
 
ENTITY MonoProcessor IS 
PORT(
  Clk : IN STD_LOGIC;
  Reset : IN STD_LOGIC;
  BusW : OUT STD_LOGIC_VECTOR(31 downto 0)
);
END MonoProcessor;


ARCHITECTURE Structural OF MonoProcessor IS
	Signal nPCSel: STD_LOGIC;
	Signal RegWr: STD_LOGIC;
	Signal MemWr: STD_LOGIC;
	Signal WrSrc: STD_LOGIC;
	Signal ALUSrc: STD_LOGIC;
	Signal RegSel: STD_LOGIC;
	Signal PSREn: STD_LOGIC;
	Signal flag: STD_LOGIC;
	Signal PSR: STD_LOGIC_VECTOR(31 downto 0);
	Signal ALUCtr: STD_LOGIC_VECTOR(1 downto 0);
	Signal RA: STD_LOGIC_VECTOR(3 downto 0);
	Signal RB: STD_LOGIC_VECTOR(3 downto 0);
	Signal RW: STD_LOGIC_VECTOR(3 downto 0);
	Signal Instruction: STD_LOGIC_VECTOR(31 downto 0);
	Signal DataIn: STD_LOGIC_VECTOR(31 downto 0);
  Signal Offset : STD_LOGIC_VECTOR(23 downto 0);
  Signal Imm : STD_LOGIC_VECTOR(7 downto 0);
	Signal instr_type: enum_instruction;
BEGIN


  UUT0: COMPONENT InstructionManager PORT MAP(
	  Clk => Clk,
      Reset => Reset,
      Offset => Offset,
      nPCSel => nPCSel,
      Instruction => Instruction
    );
  UUT2: COMPONENT Instruction_Decoder PORT MAP(
    Instruction => Instruction,
	  PSR => PSR,
    nPCSEL => nPCSEL,
    RegWr => RegWr,
    ALUSrc => ALUSrc,
    ALUCtr => ALUCtr,
    PSREn => PSREn,
    MemWr => MemWr,
    WrSrc => WrSrc,
    RA => RA,
    RB => RB,
    RW => RW,
    RegSel => RegSel,
    Offset => Offset,
    Imm => Imm,
    instr_type => instr_type);

  UUT3: Component ProcessingUnit PORT MAP(
    CLK=> Clk, --overall
    RESET=> Reset, --overall
    WrEn_Reg=> RegWr, --banc de registres
    RA => RA,
    RB => RB, --banc de registres
    RW => RW, --banc de registres
    busW => busW, --banc de registres
    Imm => Imm, --extension de signe
    SEL1 => ALUSrc, --1er mux2
    SEL2 => WrSrc, --2e mux2
    WrEn_DM => MemWr, --data memory
    OP => ALUCtr, --ALU
    flag => flag --ALU
	);
  
  UUT4: COMPONENT RegistrePSR PORT MAP(
    DataIn => DataIn,
    Reset => Reset,
    Clk => Clk,
    WE => PSREn,
    DataOut => PSR
	);
	DataIn <= Flag & "000" & X"0000000";

END Structural;