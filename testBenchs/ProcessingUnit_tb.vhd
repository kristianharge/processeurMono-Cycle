--Roqyun KO / 370109
--EI-SE4

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity ProcessingUnit_tb is
 port( Done: out boolean:=FALSE);
end entity ProcessingUnit_tb;


Architecture Strutural of ProcessingUnit_tb is
  
Component ProcessingUnit IS 
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
END Component;

