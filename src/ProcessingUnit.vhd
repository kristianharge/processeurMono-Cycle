LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY ProcessingUnit IS 
	PORT
	(
		clk		: in STD_LOGIC; --overall
		reset		: in STD_LOGIC; --overall
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
END ProcessingUnit;
ARCHITECTURE Structural of ProcessingUnit is
  --Components are in order
  ------------------------------------------------------------
  --Banc de donees 16 32
  component BancRegistres16_32 IS 
  PORT(
	 Clk		: in STD_LOGIC;
	 Reset		: in STD_LOGIC;
	 W : in STD_LOGIC_VECTOR(31 DOWNTO 0);
	 RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
	 RB : in STD_LOGIC_VECTOR(3 DOWNTO 0);
  	RW : in STD_LOGIC_VECTOR(3 DOWNTO 0);
	 WE : in STD_LOGIC;
  	A : out STD_LOGIC_VECTOR(31 DOWNTO 0);
	 B : out STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
  END component;
  
  --sign extension
  component EDS IS
  generic ( N : positive range 1 to 32 );
  
	PORT
	(
		A :  IN  std_logic_vector (N-1 downto 0);
		S :  OUT  std_logic_vector (31 downto 0)
	);
  END component;
  
  --Multiplexor 2
  component Mux2 IS
  generic (
    N : positive range 1 to 32
    );
    
	PORT
	(
		COM :  IN  std_logic;
		A, B :  IN  std_logic_vector (N - 1 downto 0);
		S :  OUT  std_logic_vector (N - 1 downto 0)
	);
  END component;
  
  --arithmetic and logic unit
  component ALU IS 
	PORT
	(
		OP :  IN  std_logic_vector (1 downto 0);
		A, B :  IN  std_logic_vector (31 downto 0);
		S :  OUT  std_logic_vector (31 downto 0);
		N : OUT std_logic
	);
  END component;
	
	--Data memory
	component DataMemory IS 
	PORT
	(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
	  DataIn : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		DataOut :  OUT  std_logic_vector (31 downto 0);
		Addr : in  STD_LOGIC_VECTOR(5 DOWNTO 0);
    WrEn : in STD_LOGIC
	);
end component;
  --Component end
  ------------------------------------------------------------
  --Signals
  signal A, B, W, ALU_out, EDS_out, Mux2_1_out, Mux2_2_out, DataOut: std_logic_vector(31 downto 0);
  signal immSize: integer := 8;
  
begin
  C0: component BancRegistres16_32
  PORT map(
	 Clk		=> clk,
	 Reset		=> reset,
	 W => Mux2_2_out,
	 RA => RA,
	 RB => RB,
  	RW => RW,
	 WE => WrEn_Reg,
  	A => A,
	 B => B
  );
  
  C1: component EDS
  generic map ( N => immSize )
  
	PORT map
	(
		A => Imm,
		S => EDS_out
	);
	
  C2:component Mux2
  generic map ( N => 32 )
	PORT map
	(
		COM => SEL1,
		A => B,
		B => EDS_out,
		S => Mux2_1_out
	);
	
  C3: COMPONENT ALU PORT MAP(
	 OP => OP,
    A => A,
    B => Mux2_1_out,
    S => ALU_out,
    N => flag
  );

  C4: COMPONENT DataMemory PORT MAP(
		Clk	=> Clk,
		Reset		=> Reset,
	  DataIn => B,
		DataOut => DataOut,
		Addr => ALU_out(5 downto 0),
    WrEn => WrEn_DM);
    
  C5:component Mux2
  generic map ( N => 32 )
	PORT map
	(
		COM => SEL2,
		A => ALU_out,
		B => DataOut,
		S => Mux2_2_out
	);  
	
  --Code begins here
  ------------------------------------------------------------
  immSize <= 8;
  busW <= Mux2_2_out;
end Structural;
