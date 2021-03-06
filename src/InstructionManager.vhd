LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY InstructionManager IS 
	PORT
	(
		Clk		: in STD_LOGIC;
		Reset		: in STD_LOGIC;
		Offset : in std_logic_vector (23 downto 0);
		nPCSel : in std_logic;
		Instruction :  OUT  std_logic_vector (31 downto 0)
	);
END InstructionManager;

ARCHITECTURE Behavioral of InstructionManager is
  --Components are in order
  ------------------------------------------------------------
  --data memory
  component instruction_memory is 
	port(
		PC: in std_logic_vector (31 downto 0);
		Instruction: out std_logic_vector (31 downto 0)
    );
  end component;
  
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
  
  --sign extension
  component EDS IS
  generic ( N : positive range 1 to 32 );
  
	PORT
	(
		A :  IN  std_logic_vector (N-1 downto 0);
		S :  OUT  std_logic_vector (31 downto 0)
	);
  END component;
  --Component end
  ------------------------------------------------------------
  --Signals
  signal EDSSize: integer := 24;
  signal Mux2Size: integer := 32;
  signal Amux, Bmux, Seds, Smux, PC, IMout : std_logic_vector (31 downto 0) := (others => '0');

  begin
    C0: component instruction_memory 
	  port map(
		  PC => PC,
		  Instruction => IMout
    );
    
    C1: component Mux2
    generic map ( N => Mux2Size)
    port map (
      COM => nPCSel,
      A => Amux,
      B => Bmux,
      S => Smux
    );
    C2: component EDS
    generic map ( N => EDSSize )
    port map (
      A => Offset,
      S => Seds
    );
    --Code begins here
    ------------------------------------------------------------
    process (clk, Reset)
      begin
        if Reset = '1' then
          PC <= (others => '0');
        elsif rising_edge(Clk) then
          PC <= Smux;
        end if;
      end process;
      Instruction <= IMout;
      Amux <= PC + 1;
      Bmux <= PC + Seds + 1;
end Behavioral;