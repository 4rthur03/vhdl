LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY MIPSRegister IS
	PORT( clock, reset, RegWrite			 	: IN STD_LOGIC;
			read_reg1, read_reg2, write_reg 	: IN STD_LOGIC_VECTOR( 4 DOWNTO 0);
			write_data 								: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			read_data1, read_data2 				: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0) );
END MIPSRegister;

ARCHITECTURE arch OF MIPSRegister is

	TYPE REG_TYPE IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL registers : REG_TYPE;
	
	
BEGIN
	read_data1 <= registers( CONV_INTEGER( read_reg1) );
	read_data2 <= registers( CONV_INTEGER( read_reg2) );
	
	PROCESS (reset, clock)
	BEGIN
		IF( reset = '0' ) THEN
			FOR I in 0 to 31 loop
				registers(I) <= X"00000000";
			END loop;
		ELSIF( RISING_EDGE( clock)) THEN
			IF( RegWrite = '1' ) THEN
				registers( CONV_INTEGER( write_reg) ) <= write_data;
			END IF;
		END IF;
	END PROCESS;
END arch;
			
			