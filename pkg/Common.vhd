LIBRARY ieee;
use IEEE.STD_LOGIC_1164.all;
package Common is 

  type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, ERR);
  TYPE table IS ARRAY (0 to 63) OF std_logic_vector(31 DOWNTO 0);

  constant muxsel_mov : STD_LOGIC_VECTOR(7 downto 0) := "01101000"; 
  constant muxsel_addr : STD_LOGIC_VECTOR(7 downto 0) := "01000000";
  constant muxsel_addi : STD_LOGIC_VECTOR(7 downto 0) := "01100000";
  constant muxsel_comp : STD_LOGIC_VECTOR(7 downto 0) := "00110100";
  constant muxsel_ldr : STD_LOGIC_VECTOR(7 downto 0) := "01111001";
  constant muxsel_str : STD_LOGIC_VECTOR(7 downto 0) := "00111011";
  constant muxsel_blt : STD_LOGIC_VECTOR(7 downto 0) := "10000000";
  constant muxsel_bal : STD_LOGIC_VECTOR(7 downto 0) := "10000000";

component MonoProcessor IS 
PORT(
  Clk : IN STD_LOGIC;
  Reset : IN STD_LOGIC;
  BusW : OUT STD_LOGIC_VECTOR(31 downto 0);
	instr_type: out enum_instruction
);
END component;

component InstructionManager IS 
PORT(
  Clk : in STD_LOGIC;
  Reset : in STD_LOGIC;
  Offset : in std_logic_vector (23 downto 0);
  nPCSel : in std_logic;
  Instruction :  OUT  std_logic_vector (31 downto 0)
);
END component;
  
COMPONENT Instruction_Decoder IS 
PORT(
  Instruction : IN STD_LOGIC_VECTOR(31 downto 0);
  PSR : IN STD_LOGIC_VECTOR(31 downto 0);
  nPCSEL : out  std_logic;
  RegWr : out STD_LOGIC  ;
  ALUSrc : out STD_LOGIC;
  ALUCtr : out STD_LOGIC_VECTOR(1 downto 0);
  PSREn : out STD_LOGIC;
  MemWr : out STD_LOGIC;
  WrSrc : out STD_LOGIC;
  RA,RB,RW : out STD_LOGIC_VECTOR(3 DOWNTO 0);
  RegSel : out STD_LOGIC;
  Offset : out STD_LOGIC_VECTOR(23 DOWNTO 0);
  Imm : out STD_LOGIC_VECTOR(7 DOWNTO 0);
  instr_type : out enum_instruction
);
END COMPONENT;

COMPONENT instruction_memory is 
port(
  PC: in std_logic_vector (31 downto 0);
  Instruction: out std_logic_vector (31 downto 0)
);
end COMPONENT;

COMPONENT RegistrePSR IS 
PORT(
  DataIn: in STD_LOGIC_VECTOR(31 DOWNTO 0);
  Reset: in STD_LOGIC;
  Clk: in STD_LOGIC;
  WE : in  STD_LOGIC;
  DataOut : out STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT;

Component ProcessingUnit IS 
PORT(
  CLK: in STD_LOGIC; --overall
  RESET: in STD_LOGIC; --overall
  WrEn_Reg : in STD_LOGIC; --banc de registres
  RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
  RB : in STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
  RW : in STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
  busW : out STD_LOGIC_VECTOR(31 DOWNTO 0); --banc de registres
  Imm : in STD_LOGIC_VECTOR(7 DOWNTO 0); --extension de signe
  SEL1: in std_logic; --1er mux2
  SEL2: in std_logic; --2e mux2
  WrEn_DM : in std_logic; --data memory
  OP :  IN  std_logic_vector (1 downto 0); --ALU
  flag: out std_logic --ALU
  );
END Component;

  Component ProcessingUnit_RegSel IS 
	PORT
	(
		clk		: in STD_LOGIC; --overall
		reset		: in STD_LOGIC; --overall
		RegWr : in STD_LOGIC; --banc de registres
		RegSel : in STD_LOGIC; --banc de registres
		RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
		RB : in STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
		RW : in STD_LOGIC_VECTOR(3 DOWNTO 0); --banc de registres
		busW : out STD_LOGIC_VECTOR(31 DOWNTO 0); --banc de registres
		Imm : in STD_LOGIC_VECTOR(7 DOWNTO 0); --extension de signe
		ALUsrc: in std_logic; --1er mux2
		WrSrc: in std_logic; --2e mux2
		MemWr : in std_logic; --data memory
		ALUctr :  IN  std_logic_vector (1 downto 0); --ALU
		flag: out std_logic --ALU
		
	);
END Component;

component Mux2 is
generic(N : positive range 1 to 32);
PORT(
  COM :  IN  std_logic;
  A, B :  IN  std_logic_vector (N-1 downto 0);
  S :  OUT  std_logic_vector (N-1 downto 0)
);
end component;
 
component EDS is
generic ( N: positive range 1 to 32);
PORT(
  A :  IN  std_logic_vector (N-1 downto 0);
  S :  OUT  std_logic_vector (31 downto 0)
);
end component;
   
COMPONENT DataMemory IS 
PORT(
  Clk: in STD_LOGIC;
  Reset: in STD_LOGIC;
  DataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  DataOut :  OUT  std_logic_vector (31 downto 0);
  Addr : in  STD_LOGIC_VECTOR(5 DOWNTO 0);
  WrEn : in STD_LOGIC
);
END COMPONENT;
component ALU is 
PORT(
  OP :  IN  std_logic_vector (1 downto 0);
  A, B :  IN  std_logic_vector (31 downto 0);
  S :  OUT  std_logic_vector (31 downto 0);
  N : OUT std_logic
);
end component;

COMPONENT BancRegistres16_32 IS PORT(
  Clk: in STD_LOGIC;
  Reset: in STD_LOGIC;
  W : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
  RB : in STD_LOGIC_VECTOR(3 DOWNTO 0);
  RW : in STD_LOGIC_VECTOR(3 DOWNTO 0);
  WE : in STD_LOGIC;
  A : out STD_LOGIC_VECTOR(31 DOWNTO 0);
  B : out STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END COMPONENT;

COMPONENT Banc_ALU IS 
PORT(
  Clk: in STD_LOGIC;
  Reset: in STD_LOGIC;
  WE : in STD_LOGIC;
  RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
  RB : in STD_LOGIC_VECTOR(3 DOWNTO 0);
  RW : in STD_LOGIC_VECTOR(3 DOWNTO 0);
  W :  IN  std_logic_vector (31 downto 0);
  OP :  IN  std_logic_vector (1 downto 0);
  S :  OUT  std_logic_vector (31 downto 0);
  N,Z,C,V : OUT std_logic
);
END COMPONENT;


end Common;