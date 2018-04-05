LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.numeric_std.all;

ENTITY mips IS
	PORT(	reset							:	IN	STD_LOGIC;
			slow_clock, fast_clock	:	IN STD_LOGIC;
			PC_out, Instruction_out	:	OUT STD_LOGIC_VECTOR(31 downto 0);
			Read_reg1_out				:	OUT STD_LOGIC_VECTOR(4 downto 0);
			Read_reg2_out				:	OUT STD_LOGIC_VECTOR(4 downto 0);
			Write_reg_out				:	OUT STD_LOGIC_VECTOR(4 downto 0);
			Read_data1_out				:	OUT STD_LOGIC_VECTOR(31 downto 0);
			Read_data2_out				:	OUT STD_LOGIC_VECTOR(31 downto 0);
			Write_data_out				:	OUT STD_LOGIC_VECTOR(31 downto 0);
			MIDI_out						: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			MIDI_send					:	OUT STD_LOGIC;
			ready_in						:	IN STD_LOGIC
			);
END mips;

ARCHITECTURE Behavior OF mips IS

	SIGNAL PCout					:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL PC_in					:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL RegDstSig, ALUSrcSig, JumpSig, JalSig, JrSig, BeqSig, BneSig, MemReadSig, MemWriteSig, RegWriteSig : STD_LOGIC;
	SIGNAL MemtoRegSig 			:  STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ALUControlSig			:	STD_LOGIC_VECTOR( 3 DOWNTO 0);
	SIGNAL WriteRegister, WriteRegisterAfterJal	:	STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL SignExtended			:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL ALULower				:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL PCnoJr					:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL ALUZero					:	STD_LOGIC;
	SIGNAL ALUResult				:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL memOutput				:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL PCplusFour				:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL JumpAddress1			:	STD_LOGIC_VECTOR(27 downto 0);
	SIGNAL JumpAddress2			:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL MemReadOut				:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL ShiftedImmed			:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL BranchAddress			:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL BranchEqualSig		:	STD_LOGIC;
	SIGNAL BranchNotEqualSig	:	STD_LOGIC;
	SIGNAL BranchSig				:	STD_LOGIC;
	SIGNAL BranchTaken			:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL ReadReg1, ReadReg2	:	STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL ReadData1, ReadData2, WriteData			:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL instruction 			:	STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL ALUNotZero				:	STD_LOGIC;
	SIGNAL BOThJumpSig			:	STD_LOGIC;
	SIGNAL IOWrite					: 	STD_LOGIC;
	SIGNAL MemWriteNew			: 	STD_LOGIC;
	SIGNAL ReadDataOutIO			: 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL TEMPinOUT				: 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	COMPONENT ProgramCounter
		PORT (clock, reset: IN STD_LOGIC;
			inputBus:	IN STD_LOGIC_VECTOR( 31 DOWNTO 0);
			outputBus: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT Instructions
		PORT(
			address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT ControlBlock
		PORT (opCode: IN STD_LOGIC_VECTOR( 5 DOWNTO 0);
			functCode:	IN STD_LOGIC_VECTOR( 5 DOWNTO 0);
			RegDst, ALUSrc, Jump, Jal, Jr, Beq, Bne, MemRead, MemWrite, RegWrite : OUT STD_LOGIC;
			MemtoReg			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUControl:	OUT STD_LOGIC_VECTOR( 3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT MIPSRegister
		PORT( clock, reset, RegWrite			 	: IN STD_LOGIC;
			read_reg1, read_reg2, write_reg 	: IN STD_LOGIC_VECTOR( 4 DOWNTO 0);
			write_data 								: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			read_data1, read_data2 				: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0) );
	END COMPONENT;
	
	COMPONENT MIPS_ALU
		PORT ( ALUControl			: IN STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			 inputA, inputB	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			 shamt				: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			 Zero					: OUT STD_LOGIC;
			 ALU_Result			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0)
			 );
	END COMPONENT;
		
	COMPONENT DataMemory
		PORT
			(
				address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
				clock		: IN STD_LOGIC  := '1';
				data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				wren		: IN STD_LOGIC ;
				q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT SignExtendImmed
		PORT(input0 : IN STD_LOGIC_VECTOR(15 downto 0);
			output0 : OUT STD_LOGIC_VECTOR(31 downto 0)
			);
	END COMPONENT;
	
	COMPONENT IOBlock IS
	PORT( clock, reset			 				: IN STD_LOGIC;
			IOMemWrite								: IN STD_LOGIC;
			inAddr, inData							: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			dataOut									: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			inputSig1, inputSig2  				: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			outputSig1, outputSig2				: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
	
BEGIN

	
	PC1: ProgramCounter PORT MAP(clock => slow_clock, 
											reset => reset, 
											inputBus => PC_in, 
											outputBus => PCout);
	PC_out <= PCout;
											
	INST: Instructions PORT MAP(address => PCout(8 downto 2), 
											clock => fast_clock, 
											q => instruction);
										
	instruction_out <= instruction;
											
	CTRLB: ControlBlock PORT MAP(opcode => instruction(31 downto 26), 
											functCode => instruction(5 downto 0), 
											RegDst => RegDstSig, 
											ALUSrc => ALUSrcSig, 
											Jump => JumpSig, 
											Jal => JalSig, 
											Jr => JrSig, 
											Beq => BeqSig, 
											Bne => BneSig, 
											MemRead => MemReadSig, 
											MemWrite => MemWriteSig, 
											RegWrite => RegWriteSig, 
											MemtoReg => MemtoRegSig(1 DOWNTO 0), 
											ALUControl => ALUControlSig);
											
	PROCESS(instruction, RegDstSig, jalSig, WriteRegister)
		BEGIN
		CASE RegDstSig IS
			When '0' =>
				WriteRegister <= instruction(20 downto 16);
			WHEN '1' =>
				WriteRegister <= instruction(15 downto 11);
			WHEN OTHERS =>
				WriteRegister <= instruction(15 downto 11);
		END CASE;
		CASE jalSig IS
			WHEN '0' =>
				WriteRegisterAfterJal <= WriteRegister;
			WHEN '1' =>
				WriteRegisterAfterJal <= "11111";
			WHEN OTHERS =>
				WriteRegisterAfterJal <= WriteRegister;
		END CASE;
	END PROCESS;
	
	Read_reg1_out <= instruction(25 downto 21);
	Read_reg2_out <= instruction(20 downto 16);
	write_reg_out <= WriteRegisterAfterJal;
	
	MIPSR: MIPSRegister PORT MAP(clock => slow_clock, 
											reset => reset, 
											RegWrite => RegWriteSig, 
											Read_reg1 => instruction(25 downto 21), 
											Read_reg2 => instruction(20 downto 16), 
											Write_reg => WriteRegisterAfterJal, 
											Write_data => writedata, 
											Read_data1 => readdata1, 
											Read_data2 =>readdata2);
											
	write_data_out <= writedata;
	read_data1_out <= readdata1;
	read_data2_out	<= readdata2;
											
	SEI: SignExtendImmed PORT MAP(input0 => instruction(15 downto 0), 
											output0 => signExtended);
	PROCESS(readdata2, signExtended, ALUSrcSig, ALULower)
		BEGIN
		CASE ALUSrcSig IS
			WHEN '0' =>
				ALULower <= readdata2;
			WHEN '1' =>
				ALULower <= signExtended;
			WHEN OTHERS =>
				ALULower <= readdata2;
		END CASE;
	END PROCESS;
	
	PROCESS(readdata1, PCnoJR, jrsig, PC_in)
		BEGIN
		CASE jrsig IS
			WHEN '0' =>
				PC_in <= PCnoJR;
			WHEN '1' =>
				PC_in <= readdata1;
			WHEN OTHERS =>
				PC_in <= PCnoJR;
		END CASE;
	END PROCESS;
	
	MIPSALU: MIPS_ALU PORT MAP(ALUControl => ALUControlSig, 
										inputA => readdata1, 
										inputB => ALULower, 
										shamt => instruction(10 downto 6), 
										Zero => ALUZero, 
										ALU_Result => ALUResult);
										
	DM: DataMemory PORT MAP(Address => ALUresult(6 downto 0), 
									clock => fast_clock, 
									data => readdata2, 
									wren => MemWriteNew, 
									q => memOutput);
									
	IOWrite <= ALUResult(31) AND MemWriteSig;
	MemWriteNew <= (NOT ALUResult(31)) AND MemWriteSig;
	
	IO: IOBlock PORT MAP( clock => fast_clock,
								reset => reset,
								inAddr => ALUResult(31 DOWNTO 0),
								inData => ReadData2,
								IOMemWrite => IOWrite,
								inputSig1 => TEMPinOUT(7 DOWNTO 0),
								inputSig2 => TEMPinOUT(15 DOWNTO 8),
								outputSig1 => TEMPinOUT(23 DOWNTO 16),
								outputSig2 => TEMPinOUT(31 DOWNTO 24),
								dataOut => ReadDataOutIO(31 DOWNTO 0)
								);
	
	-- The new mux with third input for IO	
	PROCESS(memOutput, ALUResult, MemtoRegSig, memReadOut, ReadDataOutIO)
		BEGIN
		CASE MemtoRegSig IS
			WHEN "00" =>
				memReadOut <= ALUResult;
			WHEN "01" =>
				memReadOut <= memOutput;
			WHEN "10" =>
				memReadOut <= ReadDataOutIO;
			WHEN OTHERS =>
				memReadOut <= ALUResult;
		END CASE;
	END PROCESS;
	
	PROCESS(memReadOut, PCplusFour, JalSig, writedata)
		BEGIN
		CASE JalSig IS
			WHEN '0' =>
				writedata <= memReadOut;
			WHEN '1' =>
				writedata <= PCplusFour;
			WHEN OTHERS =>
				writedata <= memReadOut;
		END CASE;
	END PROCESS;
	
	PCplusFour <= PCout + "0100";
	JumpAddress1 <= instruction(25 downto 0) & "00";
	JumpAddress2 <= PCplusFour(31 downto 28) & jumpAddress1;
	shiftedImmed <= signExtended(29 downto 0) & "00";
	BranchAddress <= shiftedImmed + PCplusFour;
	BranchEqualSig <= beqSig AND ALUZero;
	ALUNotZero <= NOT ALUZero;
	BranchNotEqualSig <= bneSig AND ALUNotZero;
	BranchSig <= BranchEqualSig OR BranchNotEqualSig;
	
	PROCESS(BranchAddress, PCplusFour, BranchSig, BranchTaken)
		BEGIN
		CASE BranchSig IS
			WHEN '0' =>
				BranchTaken <= PCplusFour;
			WHEN '1' =>
				BranchTaken <= BranchAddress;
			WHEN OTHERS =>
				BranchTaken <= PCplusFour;
		END CASE;
	END PROCESS;
	
	BothJumpSig <= JumpSig OR JalSig;
	
	PROCESS(jumpAddress2, BranchTaken, BothJumpSig, PCnoJR)
		BEGIN
		CASE BothJumpSig IS
			WHEN '0' =>
				PCnoJR <= BranchTaken;
			WHEN '1' =>
				PCnoJR <= jumpAddress2;
			WHEN OTHERS =>
				PCnoJR <= BranchTaken;
		END CASE;
	END PROCESS;
END Behavior;
	