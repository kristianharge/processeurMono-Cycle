library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.STD_LOGIC_unsigned.all;
use ieee.numeric_std.all;
use work.common.all;
 
ENTITY Instruction_Decoder IS 
PORT(
  Instruction : IN STD_LOGIC_VECTOR(31 downto 0);
  PSR : IN STD_LOGIC_VECTOR(31 downto 0);
  nPCSEL : out  std_logic;
  RegWr : out STD_LOGIC;
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
END Instruction_Decoder;


ARCHITECTURE Structural OF Instruction_Decoder IS
signal instr_courante: enum_instruction; 
SIGNAL MuxSel : STD_LOGIC_VECTOR(7 downto 0);

BEGIN
	label_instr : process(Instruction)
	begin
 	case Instruction(31 downto 24) is
 	  --Traitement des données
 	  when x"E3" =>
 	    case instruction(23 downto 20) is
   	    when x"A" =>
 	        instr_courante <= MOV;
 	      when x"5" =>
     	    instr_courante <= CMP;
 	      when others =>
 	        instr_courante <= ERR;
 	    end case;
 	  when x"E0" =>
 	    instr_courante <= ADDr;
 	  when x"E2" =>
 	    instr_courante <= ADDi;
 	  --Acess Memoire
 	  when x"E6" =>
 	    case instruction(23 downto 20) is
   	    when x"0" =>
 	        instr_courante <= STR;
     	  when x"1" => 
 	        instr_courante <= LDR;
 	      when others =>
 	        instr_courante <= ERR;
 	    end case;
 	  --Branchement
 	  when X"EA" =>
 	    instr_courante <= BAL;
 	  when X"BA" =>
 	    instr_courante <= BLT;
 	  when others =>
 	    instr_courante <= ERR;
 	end case;
  end process;
  stimulus : process(Instruction)
  begin
 	case Instruction(31 downto 24) is
 	  --Traitement des données
 	  when x"E3" =>
 	    case instruction(23 downto 20) is
   	    when x"A" =>
	        MuxSel <= muxsel_mov;
          RW <= Instruction(15 downto 12);
          Imm <= Instruction(7 downto 0);
          Offset <= (others => '0');
          RegSel <= '0';
 	      when x"5" =>
	        MuxSel <= muxsel_comp;
          RA <= Instruction(19 downto 16);
          Imm <= Instruction(7 downto 0);
          Offset <= (others => '0');
          RegSel <= '0';
 	      when others =>
 	    end case;
 	  when x"E0" =>
	    MuxSel<= muxsel_addr;
        RA <= Instruction(3 downto 0);
		RB <= Instruction(19 downto 16);
		RW <= Instruction(15 downto 12);
        Offset <= (others => '0');
		RegSel <= '0';
 	  when x"E2" =>
 	    MuxSel<= muxsel_addi;
		  RA <= Instruction(19 downto 16);
		  RW <= Instruction(15 downto 12);
		  Imm <= Instruction(7 downto 0);
          Offset <= (others => '0');
		  RegSel <= '0';
	  --Acess Memoire
	  
	  when x"E6" =>
 	    case instruction(23 downto 20) is
   	    when x"0" =>
		    MuxSel<= muxsel_str;
		    RW <= Instruction(15 downto 12);
		    RA <= Instruction(19 downto 16);
          Offset <= (others => '0');
		    RegSel <= '0';
     	  when x"1" => 
		    MuxSel<= muxsel_ldr;
		    RW <= Instruction(15 downto 12);
		    RA <= Instruction(19 downto 16);
			Offset <= (others => '0');
		    RegSel <= '0';
 	      when others =>
 	    end case;
 	  --Branchement
 	  when X"EA" =>
		MuxSel <= muxsel_bal;
		RegSel <= '0';
		Offset <= Instruction(23 downto 0);
 	  when X"BA" =>
	    if PSR(31) = '1' then 
			MuxSel<= muxsel_blt;
			RegSel <= '0';
		ELSE
			MuxSel<= '0' & muxsel_blt(6 downto 0);
			RegSel <= '0';
		end if;
		Offset <= Instruction(23 downto 0);
 	  when others =>		
          Offset <= (others => '0');
          Muxsel <= (others => '0');
          RegSel <= '0';
 	end case;
  end process;
  nPCSEL <= MuxSel(7);
  RegWr <= MuxSel(6);
  ALUSrc <= MuxSel(5);
  ALUCtr <= MuxSel(4 downto 3);
  PSREn <= MuxSel(2);
  MemWr <= MuxSel(1);
  WrSrc <= MuxSel(0);
  instr_type <= instr_courante;
END Structural;
