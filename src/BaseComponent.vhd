LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;

package BaseComponent is
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
end package BaseComponent;