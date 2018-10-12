----------- Squelette du Banc de Test pour l'exercice MinMax -------------
--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_ARITH.all;

entity BancRegistres16_32_tb is
 port( Done: out boolean:=FALSE);
end entity BancRegistres16_32_tb;

architecture BENCH of BancRegistres16_32_tb is
  SIGNAL 	TClk		: STD_LOGIC := '0';
  SIGNAL 	TReset	: STD_LOGIC;
  SIGNAL 	TW : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL 	TRA : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL 	TRB : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL 	TRW : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL 	TWE : STD_LOGIC;
  SIGNAL 	TA : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL 	TB : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL 	TDone : boolean := false;
  
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

begin
  Done <= TDone;
  UUT: COMPONENT BancRegistres16_32 PORT MAP(
	Clk	=> TClk,
	Reset => TReset,
	W => TW,
	RA => TRA,
	RB => TRB,
	RW => TRW,
	WE => TWE,
	A => TA,
	B => TB);
  -- Generation d'une horloge
  TClk <= '0' when TDone else not TClk after 25 ns;
  -- Generation d'un reset au début
  TReset <= '1', '0' after 1 ns;
        
  stimulus:process
  begin
        wait until TReset = '0';
        --Verifier si les registres sont bien initialises.
        for i in 0 to 14 loop
          TRA <= conv_std_logic_vector(i, TRA'length);
          TRB <= conv_std_logic_vector(i, TRB'length);
          wait for 1 ns;
          ASSERT TA = "0" AND TB = TA REPORT "Initialization failed"  -- Initialization test.
          SEVERITY FAILURE; 
        end loop;
        TRA <= conv_std_logic_vector(15, TRA'length);
        TRB <= conv_std_logic_vector(15, TRB'length);
        wait for 1 ns;
        ASSERT TA = X"0030" AND TB = TA REPORT "Initialization failed"  -- Initialization test.
        SEVERITY FAILURE; 
        REPORT "Initialization Test 1 passed." SEVERITY note;

        for i in 0 to 7 loop
          
          TRA <= conv_std_logic_vector(i * 2, TRA'length);
          TRB <= conv_std_logic_vector(i * 2 + 1, TRB'length);
          
          wait until TClk = '0';
          --Verifier le reg_write.
          TWE <= '1';
          TRW <= TRA;
          TW <= X"000000A0" + TRA;
          wait until TClk = '1';
          TRW <= TRB;
          TW <= X"000000B0" + TRB;
          wait until TClk = '0';
          wait until TClk = '1';
          wait for 1 ns;
          TWE <= '0';
          
          wait for 1 ns;
          ASSERT TA = (X"A0" + TRA) REPORT "Write & read (A) failed"  -- Write & read test.
          SEVERITY FAILURE; 
          
          wait for 1 ns;
          ASSERT TB = (X"B0" + TRB) REPORT "Write & read (B) failed"  -- Write & read test.
          SEVERITY FAILURE; 
          wait until TClk = '0';
          REPORT "Write & Read Test passed." SEVERITY note;
        end loop;
      
        
          TDone <= TRUE; -- La fin du banc de teste. Le résultat est bon.
          WAIT; -- Boucle infinie
  end process;

  
end architecture BENCH;
