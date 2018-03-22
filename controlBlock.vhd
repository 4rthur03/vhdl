LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY ControlBlock IS
	PORT (opCode			: 	IN STD_LOGIC_VECTOR( 5 DOWNTO 0);
			functCode		:	IN STD_LOGIC_VECTOR( 5 DOWNTO 0);
			RegDst, ALUSrc, Jump, Jal, Jr, Beq, Bne, MemRead, MemWrite, RegWrite : OUT STD_LOGIC;
			MemtoReg			: 	OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUControl		:	OUT STD_LOGIC_VECTOR( 3 DOWNTO 0));
END ControlBlock;

ARCHITECTURE Behavior OF ControlBlock IS
BEGIN
	PROCESS(opCode, functCode)
	BEGIN
		IF opCode = X"00" THEN
			CASE functCode IS
				WHEN "000000" => --sll
					ALUControl <= X"8";
				WHEN "000010" => --srl
					ALUControl <= X"9";
				WHEN "000100" => --sllv
					ALUControl <= X"A";
				WHEN "000110" => --srlv
					ALUControl <= X"B";
				WHEN "100000" => --add
					ALUControl <= X"2";
				WHEN "100001" => --addu
					ALUControl <= X"2";
				WHEN "100010" => --sub
					ALUControl <= X"6";
				WHEN "100011" => --subu
					ALUControl <= X"6";
				WHEN "100100" => --and
					ALUControl <= X"0";
				WHEN "100101" => --or
					ALUControl <= X"1";
				WHEN "100111" => --nor
					ALUControl <= X"C";
				WHEN "101010" => --slt
					ALUControl <= X"7";
				WHEN OTHERS=>
					ALUControl <= "----";
			END CASE;
		ELSE
			CASE opCode IS
				WHEN "000100" => --beq
					ALUControl <= X"6";
				WHEN "000101" => --bne
					ALUControl <= X"6";
				WHEN "001000" => --addi
					ALUControl <= X"2";
				WHEN "001001" => --addiu
					ALUControl <= X"2";
				WHEN "001010" => --slti
					ALUControl <= X"7";
				WHEN "001100" => --andi
					ALUControl <= X"0";
				WHEN "001101" => --ori
					ALUControl <= X"1";
				WHEN "001111" => --lui
					ALUControl <= X"D";
				WHEN OTHERS=>
					ALUControl <= "----";
			END CASE;
		END IF;
		
		Case opCode IS
			WHEN "000000" => --R-type
				Jump <= '0';
				Jal <= '0';
				Beq <= '0';
				Bne <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				CASE functCode IS
					WHEN "001000" => --Jr
						Jr <= '1';
						RegWrite <= '0';
						MemtoReg <= "--";
						ALUSrc <= '-';
						RegDst <= '-';
					WHEN OTHERS =>
						Jr <= '0';
						RegWrite <= '1';
						RegDst <= '1';
						ALUSrc <= '0';
						MemtoReg <= "00";
				END CASE;
			WHEN "000010" => --J
				Jump <= '1';
				Jal <= '0';
				Jr <= '0';
				Beq <= '0';
				Bne <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '0';
				MemtoReg <= "--";
				RegDst <= '-';
				ALUSrc <= '-';
			WHEN "000011" => --Jal
				Jal <= '1';
				Jump <= '0';
				Jr <= '0';
				Beq <= '0';
				Bne <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '1';
				MemtoReg <= "--";
				RegDst <= '1';
				ALUSrc <= '-';
			WHEN "000100" => --Beq
				Beq <= '1';
				Jump <= '0';
				Jal <= '0';
				Jr <= '0';
				Bne <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '0';
				MemtoReg <= "--";
				RegDst <= '-';
				ALUSrc <= '0';
			WHEN "000101" => --Bne
				Bne <= '1';
				Jump <= '0';
				Jal <= '0';
				Jr <= '0';
				Beq <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '0';
				MemtoReg <= "--";
				RegDst <= '-';
				ALUSrc <= '0';
			WHEN "001111" => --Lui
				MemRead <= '0';
				Jump <= '0';
				Jal <= '0';
				Jr <= '0';
				Beq <= '0';
				Bne <= '0';
				MemWrite <= '0';
				RegWrite <= '1';
				MemtoReg <= "00";
				RegDst <= '0';
				ALUSrc <= '1';
			WHEN "100011" => --Lw
				MemRead <= '1';
				Jump <= '0';
				Jal <= '0';
				Jr <= '0';
				Beq <= '0';
				Bne <= '0';
				MemWrite <= '0';
				RegWrite <= '1';
				MemtoReg <= "01";
				RegDst <= '0';
				ALUSrc <= '1';
			WHEN "101011" => --Sw
				MemWrite <= '1';
				Jump <= '0';
				Jal <= '0';
				Jr <= '0';
				Beq <= '0';
				Bne <= '0';
				MemRead <= '0';
				RegWrite <= '0';
				MemtoReg <= "00";
				RegDst <= '0';
				ALUSrc <= '1';
			WHEN OTHERS =>
				Jump <= '0';
				Jal <= '0';
				Jr <= '0';
				Beq <= '0';
				Bne <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '1';
				MemtoReg <= "00";
				RegDst <= '0';
				ALUSrc <= '1';
		END CASE;
	END PROCESS;
END Behavior;
					