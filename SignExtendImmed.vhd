LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;

ENTITY SignExtendImmed IS
	PORT(input0 : IN STD_LOGIC_VECTOR(15 downto 0);
			output0 : OUT STD_LOGIC_VECTOR(31 downto 0)
			);
END SignExtendImmed;

ARCHITECTURE Behavior OF SignExtendImmed IS
	SIGNAL upper : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	PROCESS(input0, upper)
		BEGIN
		FOR I in 0 to 15 loop
			upper(I) <= input0(15);
		END loop;
		output0 <= upper & input0;
	END PROCESS;
END Behavior;