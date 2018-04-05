LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY ProgramCounter IS
	PORT (clock, reset: IN STD_LOGIC;
			inputBus:	IN STD_LOGIC_VECTOR( 31 DOWNTO 0);
			outputBus: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0));
END ProgramCounter;

ARCHITECTURE Behavior OF ProgramCounter IS
BEGIN
	PROCESS(clock, reset)
	BEGIN
		IF reset = '0' THEN
			outputBus <= X"00400000";
		ELSE 
			IF RISING_EDGE(clock) THEN
				outputBus <= inputBus;
			END IF;
		END IF;
	END PROCESS;
END Behavior;				