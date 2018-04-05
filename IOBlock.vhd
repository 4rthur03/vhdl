LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY IOBlock IS
	PORT( clock, reset			 				: IN STD_LOGIC;
			IOMemWrite								: IN STD_LOGIC;
			inAddr, inData							: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			dataOut									: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			inputSig1, inputSig2  				: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			outputSig1, outputSig2				: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END IOBlock;


ARCHITECTURE behavior OF IOBlock is
	
	--SIGNAL inAddr				: STD_LOGIC_VECTOR(7 DOWNTO 0);
	--SIGNAL inWriteData		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	--SIGNAL outReadData		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN

PROCESS (reset, clock)
BEGIN
	IF( reset = '0' ) THEN
		outputSig1 <= "00000000";
		outputSig2 <= "00000000";
	ELSIF(RISING_EDGE(clock)) THEN
		IF IOMemWrite = '1' THEN
			CASE inAddr IS
				WHEN x"80000000" =>
					outputSig1 <= inData(7 DOWNTO 0);
				WHEN x"80000001" =>
					outputSig2 <= inData(7 DOWNTO 0);
				WHEN OTHERS =>
					
			END CASE;	
		END IF;
	END IF;
END PROCESS;

PROCESS (inAddr, inputSig1, inputSig2)
BEGIN
	CASE inAddr IS
		WHEN x"80000000" =>
			dataOut <= X"000000" & inputSig1;
		WHEN x"80000001" =>
			dataOut <= X"000000" & inputSig2;
		WHEN OTHERS =>
			dataOut <= X"00000000";
	END CASE;
END PROCESS;

END behavior;
