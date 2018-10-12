LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY ProcessingUnit IS 
	PORT
	(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
		WE : in STD_LOGIC;
		RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
		RB : in STD_LOGIC_VECTOR(3 DOWNTO 0);
		RW : in STD_LOGIC_VECTOR(3 DOWNTO 0);
		W : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		Im : in STD_LOGIC_VECTOR(8 DOWNTO 0);
		OP :  IN  std_logic_vector (1 downto 0);
	);
END ProcessingUnit;

ARCHITECTURE Structurel of ProcessingUnit is

	COMPONENT Banc_ALU IS 
	PORT(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
		WE : in STD_LOGIC;
		RA : in  STD_LOGIC_VECTOR(3 DOWNTO 0);
		RB : in STD_LOGIC_VECTOR(3 DOWNTO 0);
		RW : in STD_LOGIC_VECTOR(3 DOWNTO 0);
		W : in STD_LOGIC_VECTOR(31 DOWNTO 0);
		OP :  IN  std_logic_vector (1 downto 0);
		S :  OUT  std_logic_vector (31 downto 0);
		N,Z,C,V : OUT std_logic
	);
	END COMPONENT;
 
	end component;
  
	signal A : std_logic_vector (31 downto 0) := (OTHERS => '0');
	signal B : std_logic_vector (31 downto 0) := (OTHERS => '0');
	signal result: std_logic_vector (31 downto 0);
begin
	C0: COMPONENT Banc_ALU PORT MAP(
	Clk	=> Clk,
	Reset => Reset,
	W => W,
	RA => RA,
	RB => RB,
	RW => RW,
	WE => WE,
	A => A,
	B => B);
	
  
end Structurel;
