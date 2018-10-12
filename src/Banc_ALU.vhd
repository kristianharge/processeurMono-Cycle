LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

ENTITY Banc_ALU IS 
	PORT
	(
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
END Banc_ALU;

ARCHITECTURE Structurel of Banc_ALU is

	COMPONENT BancRegistres16_32 IS 
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
	END COMPONENT;
 
	component ALU is 
	PORT(
		OP :  IN  std_logic_vector (1 downto 0);
		A, B :  IN  std_logic_vector (31 downto 0);
		S :  OUT  std_logic_vector (31 downto 0);
		N : OUT std_logic
	);
	end component;
  
	signal A : std_logic_vector (31 downto 0) := (OTHERS => '0');
	signal B : std_logic_vector (31 downto 0) := (OTHERS => '0');
	signal result: std_logic_vector (31 downto 0);
begin
	C0: COMPONENT BancRegistres16_32 PORT MAP(
	Clk	=> Clk,
	Reset => Reset,
	W => W,
	RA => RA,
	RB => RB,
	RW => RW,
	WE => WE,
	A => A,
	B => B);
	
  C1: COMPONENT ALU PORT MAP(
	OP => OP,
  A => A,
  B => B,
  S => result,
  N => N
  );
  S <= result;
	--Overflow
  V <= '1' when OP = "00" and not (result(31) = A(31)) and A(31) = B(31) else '0';
  --Zero
  Z <= '1' when result = X"00000000" else '0';
	--Carry
  C <= '1' when (OP = "00" and A(31) = '1' and B(31) = '0' and result(31) = '0') or
       			      (OP = "10" and A(31) = '0' and B(31) = '0' and result(31) = '1') else '0';	
    
end Structurel;