LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.numeric_std.all;

ENTITY MIPS_ALU IS
	PORT ( ALUControl			: IN STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			 inputA, inputB	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			 shamt				: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			 Zero					: OUT STD_LOGIC;
			 ALU_Result			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0)
			 );
END MIPS_ALU;

ARCHITECTURE Behavior OF MIPS_ALU IS
	SIGNAL thesignal : STD_LOGIC_VECTOR(31 DOWNTO 0);
	BEGIN
	PROCESS(ALUControl, inputA, inputB, shamt, thesignal)
		BEGIN
		Case ALUControl IS
			WHEN "0000" => --AND
				ALU_Result <= inputA AND inputB;
				zero <= '0';
			WHEN "0001" => --OR
				ALU_Result <= inputA OR inputB;
				zero <= '0';
			WHEN "0010" => --ADD
				ALU_Result <= inputA + inputB;
				zero <= '0';
			WHEN "0110" => --SUB
				thesignal <= inputA - inputB;
				CASE thesignal IS
					WHEN X"00000000" =>
						zero <= '1';
					WHEN Others =>
						zero <= '0';
				END CASE;
				ALU_Result <= thesignal;
			WHEN "0111" => --SLT
				IF inputA < inputB THEN
					ALU_Result <= X"00000001";
					zero <= '1';
				ELSE
					ALU_Result <= X"00000000";
					zero <= '0';
				END IF;
			WHEN "1000" => --SLL
				--ALU_Result <= inputA sll inputB;
				thesignal <= inputB;
				--FOR I in 0 to conv_integer(shamt) loop
				Case shamt IS
					WHEN "00000" =>
						ALU_Result <= thesignal(31 DOWNTO 0);
					WHEN "00001" =>
						ALU_Result <= thesignal(30 DOWNTO 0) & '0';
					WHEN "00010" =>
						ALU_Result <= thesignal(29 DOWNTO 0) & "00";
					WHEN "00011" =>
						ALU_Result <= thesignal(28 DOWNTO 0) & "000";
					WHEN "00100" =>
						ALU_Result <= thesignal(27 DOWNTO 0) & "0000";
					WHEN "00101" =>
						ALU_Result <= thesignal(26 DOWNTO 0) & "00000";
					WHEN "00110" =>
						ALU_Result <= thesignal(25 DOWNTO 0) & "000000";
					WHEN "00111" =>
						ALU_Result <= thesignal(24 DOWNTO 0) & "0000000";
					WHEN "01000" =>
						ALU_Result <= thesignal(23 DOWNTO 0) & "00000000";
					WHEN "01001" =>
						ALU_Result <= thesignal(22 DOWNTO 0) & "000000000";
					WHEN "01010" =>
						ALU_Result <= thesignal(21 DOWNTO 0) & "0000000000";
					WHEN "01011" =>
						ALU_Result <= thesignal(20 DOWNTO 0) & "00000000000";
					WHEN "01100" =>
						ALU_Result <= thesignal(19 DOWNTO 0) & "000000000000";
					WHEN "01101" =>
						ALU_Result <= thesignal(18 DOWNTO 0) & "0000000000000";
					WHEN "01110" =>
						ALU_Result <= thesignal(17 DOWNTO 0) & "00000000000000";
					WHEN "01111" =>
						ALU_Result <= thesignal(16 DOWNTO 0) & "000000000000000";
					WHEN "10000" =>
						ALU_Result <= thesignal(15 DOWNTO 0) & "0000000000000000";
					WHEN "10001" =>
						ALU_Result <= thesignal(14 DOWNTO 0) & "00000000000000000";
					WHEN "10010" =>
						ALU_Result <= thesignal(13 DOWNTO 0) & "000000000000000000";
					WHEN "10011" =>
						ALU_Result <= thesignal(12 DOWNTO 0) & "0000000000000000000";
					WHEN "10100" =>
						ALU_Result <= thesignal(11 DOWNTO 0) & "00000000000000000000";
					WHEN "10101" =>
						ALU_Result <= thesignal(10 DOWNTO 0) & "000000000000000000000";
					WHEN "10110" =>
						ALU_Result <= thesignal(9 DOWNTO 0) & "0000000000000000000000";
					WHEN "10111" =>
						ALU_Result <= thesignal(8 DOWNTO 0) & "00000000000000000000000";
					WHEN "11000" =>
						ALU_Result <= thesignal(7 DOWNTO 0) & "000000000000000000000000";
					WHEN "11001" =>
						ALU_Result <= thesignal(6 DOWNTO 0) & "0000000000000000000000000";
					WHEN "11010" =>
						ALU_Result <= thesignal(5 DOWNTO 0) & "00000000000000000000000000";
					WHEN "11011" =>
						ALU_Result <= thesignal(4 DOWNTO 0) & "000000000000000000000000000";
					WHEN "11100" =>
						ALU_Result <= thesignal(3 DOWNTO 0) & "0000000000000000000000000000";
					WHEN "11101" =>
						ALU_Result <= thesignal(2 DOWNTO 0) & "00000000000000000000000000000";
					WHEN "11110" =>
						ALU_Result <= thesignal(1 DOWNTO 0) & "000000000000000000000000000000";
					WHEN "11111" =>
						ALU_Result <= thesignal(0) & "0000000000000000000000000000000";
					WHEN OTHERS =>
						ALU_Result <= thesignal(31 downto 0);
				END Case;
				zero <= '0';
				--END loop;
			WHEN "1001" => --SRL
				thesignal <= inputB;
				--FOR I in 0 to conv_integer(shamt) loop
					Case shamt IS
					WHEN "00000" =>
						ALU_Result <= thesignal(31 DOWNTO 0);
					WHEN "00001" =>
						ALU_Result <= '0' & thesignal(31 DOWNTO 1);
					WHEN "00010" => 
						ALU_Result <= "00" & thesignal(31 DOWNTO 2);
					WHEN "00011" => 
						ALU_Result <= "000" & thesignal(31 DOWNTO 3);
					WHEN "00100" => 
						ALU_Result <= "0000" & thesignal(31 DOWNTO 4); 
					WHEN "00101" => 
						ALU_Result <= "00000" & thesignal(31 DOWNTO 5); 
					WHEN "00110" => 
						ALU_Result <= "000000" & thesignal(31 DOWNTO 6); 
					WHEN "00111" => 
						ALU_Result <= "0000000" & thesignal(31 DOWNTO 7); 
					WHEN "01000" => 
						ALU_Result <= "00000000" & thesignal(31 DOWNTO 8); 
					WHEN "01001" => 
						ALU_Result <= "000000000" & thesignal(31 DOWNTO 9); 
					WHEN "01010" => 
						ALU_Result <= "0000000000" & thesignal(31 DOWNTO 10); 
					WHEN "01011" => 
						ALU_Result <= "00000000000" & thesignal(31 DOWNTO 11); 
					WHEN "01100" => 
						ALU_Result <= "000000000000" & thesignal(31 DOWNTO 12); 
					WHEN "01101" => 
						ALU_Result <= "0000000000000" & thesignal(31 DOWNTO 13); 
					WHEN "01110" => 
						ALU_Result <= "00000000000000" & thesignal(31 DOWNTO 14); 
					WHEN "01111" => 
						ALU_Result <= "000000000000000" & thesignal(31 DOWNTO 15); 
					WHEN "10000" => 
						ALU_Result <= "0000000000000000" & thesignal(31 DOWNTO 16); 
					WHEN "10001" => 
						ALU_Result <= "00000000000000000" & thesignal(31 DOWNTO 17); 
					WHEN "10010" => 
						ALU_Result <= "000000000000000000" & thesignal(31 DOWNTO 18); 
					WHEN "10011" => 
						ALU_Result <= "0000000000000000000" & thesignal(31 DOWNTO 19); 
					WHEN "10100" => 
						ALU_Result <= "00000000000000000000" & thesignal(31 DOWNTO 20); 
					WHEN "10101" => 
						ALU_Result <= "000000000000000000000" & thesignal(31 DOWNTO 21); 
					WHEN "10110" => 
						ALU_Result <= "0000000000000000000000" & thesignal(31 DOWNTO 22);
					WHEN "10111" => 
						ALU_Result <= "00000000000000000000000" & thesignal(31 DOWNTO 23);
					WHEN "11000" => 
						ALU_Result <= "000000000000000000000000" & thesignal(31 DOWNTO 24);
					WHEN "11001" => 
						ALU_Result <= "0000000000000000000000000" & thesignal(31 DOWNTO 25);
					WHEN "11010" => 
						ALU_Result <= "00000000000000000000000000" & thesignal(31 DOWNTO 26);
					WHEN "11011" => 
						ALU_Result <= "000000000000000000000000000" & thesignal(31 DOWNTO 27);
					WHEN "11100" => 
						ALU_Result <= "0000000000000000000000000000" & thesignal(31 DOWNTO 28);
					WHEN "11101" => 
						ALU_Result <= "00000000000000000000000000000" & thesignal(31 DOWNTO 29);
					WHEN "11110" => 
						ALU_Result <= "000000000000000000000000000000" & thesignal(31 DOWNTO 30);
					WHEN "11111" =>
						ALU_Result <= "0000000000000000000000000000000" & thesignal(31);
					WHEN OTHERS =>
						ALU_Result <= thesignal(31 downto 0);
				END Case;
				zero <= '0';
				--END loop;
				--ALU_Result <= thesignal;
			WHEN "1010" => --SLLV
				thesignal <= inputB;
				Case inputA IS
					WHEN X"00000000" =>
						ALU_Result <= thesignal(31 DOWNTO 0);
					WHEN X"00000001" =>
						ALU_Result <= thesignal(30 DOWNTO 0) & '0';
					WHEN X"00000002" =>
						ALU_Result <= thesignal(29 DOWNTO 0) & "00";
					WHEN X"00000003" =>
						ALU_Result <= thesignal(28 DOWNTO 0) & "000";
					WHEN X"00000004" =>
						ALU_Result <= thesignal(27 DOWNTO 0) & "0000";
					WHEN X"00000005" =>
						ALU_Result <= thesignal(26 DOWNTO 0) & "00000";
					WHEN X"00000006" =>
						ALU_Result <= thesignal(25 DOWNTO 0) & "000000";
					WHEN X"00000007" =>
						ALU_Result <= thesignal(24 DOWNTO 0) & "0000000";
					WHEN X"00000008" =>
						ALU_Result <= thesignal(23 DOWNTO 0) & "00000000";
					WHEN X"00000009" =>
						ALU_Result <= thesignal(22 DOWNTO 0) & "000000000";
					WHEN X"0000000A" =>
						ALU_Result <= thesignal(21 DOWNTO 0) & "0000000000";
					WHEN X"0000000B" =>
						ALU_Result <= thesignal(20 DOWNTO 0) & "00000000000";
					WHEN X"0000000C" =>
						ALU_Result <= thesignal(19 DOWNTO 0) & "000000000000";
					WHEN X"0000000D" =>
						ALU_Result <= thesignal(18 DOWNTO 0) & "0000000000000";
					WHEN X"0000000E" =>
						ALU_Result <= thesignal(17 DOWNTO 0) & "00000000000000";
					WHEN X"0000000F" =>
						ALU_Result <= thesignal(16 DOWNTO 0) & "000000000000000";
					WHEN X"00000010" =>
						ALU_Result <= thesignal(15 DOWNTO 0) & "0000000000000000";
					WHEN X"00000011" =>
						ALU_Result <= thesignal(14 DOWNTO 0) & "00000000000000000";
					WHEN X"00000012" =>
						ALU_Result <= thesignal(13 DOWNTO 0) & "000000000000000000";
					WHEN X"00000013" =>
						ALU_Result <= thesignal(12 DOWNTO 0) & "0000000000000000000";
					WHEN X"00000014" =>
						ALU_Result <= thesignal(11 DOWNTO 0) & "00000000000000000000";
					WHEN X"00000015" =>
						ALU_Result <= thesignal(10 DOWNTO 0) & "000000000000000000000";
					WHEN X"00000016" =>
						ALU_Result <= thesignal(9 DOWNTO 0) & "0000000000000000000000";
					WHEN X"00000017" =>
						ALU_Result <= thesignal(8 DOWNTO 0) & "00000000000000000000000";
					WHEN X"00000018" =>
						ALU_Result <= thesignal(7 DOWNTO 0) & "000000000000000000000000";
					WHEN X"00000019" =>
						ALU_Result <= thesignal(6 DOWNTO 0) & "0000000000000000000000000";
					WHEN X"0000001A" =>
						ALU_Result <= thesignal(5 DOWNTO 0) & "00000000000000000000000000";
					WHEN X"0000001B" =>
						ALU_Result <= thesignal(4 DOWNTO 0) & "000000000000000000000000000";
					WHEN X"0000001C" =>
						ALU_Result <= thesignal(3 DOWNTO 0) & "0000000000000000000000000000";
					WHEN X"0000001D" =>
						ALU_Result <= thesignal(2 DOWNTO 0) & "00000000000000000000000000000";
					WHEN X"0000001E" =>
						ALU_Result <= thesignal(1 DOWNTO 0) & "000000000000000000000000000000";
					WHEN X"0000001F" =>
						ALU_Result <= thesignal(0) & "0000000000000000000000000000000";
					WHEN OTHERS =>
						ALU_Result <= X"00000000";
				END Case;
				zero <= '0';
				--END loop;
			WHEN "1011" => --SRLV
				thesignal <= inputB;
				Case inputA IS
					WHEN X"00000000" =>
						ALU_Result <= thesignal(31 DOWNTO 0);
					WHEN X"00000001" =>
						ALU_Result <= '0' & thesignal(31 DOWNTO 1);
					WHEN X"00000002" => 
						ALU_Result <= "00" & thesignal(31 DOWNTO 2);
					WHEN X"00000003" => 
						ALU_Result <= "000" & thesignal(31 DOWNTO 3);
					WHEN X"00000004" => 
						ALU_Result <= "0000" & thesignal(31 DOWNTO 4); 
					WHEN X"00000005" => 
						ALU_Result <= "00000" & thesignal(31 DOWNTO 5); 
					WHEN X"00000006" => 
						ALU_Result <= "000000" & thesignal(31 DOWNTO 6); 
					WHEN X"00000007" => 
						ALU_Result <= "0000000" & thesignal(31 DOWNTO 7); 
					WHEN X"00000008" => 
						ALU_Result <= "00000000" & thesignal(31 DOWNTO 8); 
					WHEN X"00000009" => 
						ALU_Result <= "000000000" & thesignal(31 DOWNTO 9); 
					WHEN X"0000000A" => 
						ALU_Result <= "0000000000" & thesignal(31 DOWNTO 10); 
					WHEN X"0000000B" => 
						ALU_Result <= "00000000000" & thesignal(31 DOWNTO 11); 
					WHEN X"0000000C" => 
						ALU_Result <= "000000000000" & thesignal(31 DOWNTO 12); 
					WHEN X"0000000D" => 
						ALU_Result <= "0000000000000" & thesignal(31 DOWNTO 13); 
					WHEN X"0000000E" => 
						ALU_Result <= "00000000000000" & thesignal(31 DOWNTO 14); 
					WHEN X"0000000F" => 
						ALU_Result <= "000000000000000" & thesignal(31 DOWNTO 15); 
					WHEN X"00000010" => 
						ALU_Result <= "0000000000000000" & thesignal(31 DOWNTO 16); 
					WHEN X"00000011" => 
						ALU_Result <= "00000000000000000" & thesignal(31 DOWNTO 17); 
					WHEN X"00000012" => 
						ALU_Result <= "000000000000000000" & thesignal(31 DOWNTO 18); 
					WHEN X"00000013" => 
						ALU_Result <= "0000000000000000000" & thesignal(31 DOWNTO 19); 
					WHEN X"00000014" => 
						ALU_Result <= "00000000000000000000" & thesignal(31 DOWNTO 20); 
					WHEN X"00000015" => 
						ALU_Result <= "000000000000000000000" & thesignal(31 DOWNTO 21); 
					WHEN X"00000016" => 
						ALU_Result <= "0000000000000000000000" & thesignal(31 DOWNTO 22);
					WHEN X"00000017" => 
						ALU_Result <= "00000000000000000000000" & thesignal(31 DOWNTO 23);
					WHEN X"00000018" => 
						ALU_Result <= "000000000000000000000000" & thesignal(31 DOWNTO 24);
					WHEN X"00000019" => 
						ALU_Result <= "0000000000000000000000000" & thesignal(31 DOWNTO 25);
					WHEN X"0000001A" => 
						ALU_Result <= "00000000000000000000000000" & thesignal(31 DOWNTO 26);
					WHEN X"0000001B" => 
						ALU_Result <= "000000000000000000000000000" & thesignal(31 DOWNTO 27);
					WHEN X"0000001C" => 
						ALU_Result <= "0000000000000000000000000000" & thesignal(31 DOWNTO 28);
					WHEN X"0000001D" => 
						ALU_Result <= "00000000000000000000000000000" & thesignal(31 DOWNTO 29);
					WHEN X"0000001E" => 
						ALU_Result <= "000000000000000000000000000000" & thesignal(31 DOWNTO 30);
					WHEN X"0000001F" =>
						ALU_Result <= "0000000000000000000000000000000" & thesignal(31);
					WHEN OTHERS =>
						ALU_Result <= X"00000000";
				END Case;
				zero <= '0';
			WHEN "1100" => --NOR
				ALU_Result <= inputA NOR inputB;
				zero <= '0';
			WHEN "1101" => --LUI
				ALU_Result <= inputB(15 downto 0) & X"0000";
				zero <= '0';
			WHEN OTHERS =>
				Zero <= '0';
				ALU_Result <= X"00000000";
		END CASE;
	END PROCESS;
END Behavior;