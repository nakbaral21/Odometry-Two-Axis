LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY odometry_2_axis IS

    PORT		(rot0_a, rot0_b, rot1_a, rot1_b							: in STD_LOGIC;
				 loutx2, loutx1, loutx0, louty2, louty1, louty0		: out STD_LOGIC_VECTOR (6 downto 0));
				 
END odometry_2_axis;

ARCHITECTURE logic OF odometry_2_axis IS
	
	SIGNAL a0prev			:	STD_LOGIC						  	:= rot0_a;
	SIGNAL a1prev			:	STD_LOGIC						  	:= rot1_a;
	SIGNAL counter0 		:	INTEGER range -2191 to 2191   := 0;
	SIGNAL counter1		:	INTEGER range -2191 to 2191   := 0;
	SIGNAL posisitemp0	:	INTEGER range 0 to 999999     := 0;
	SIGNAL posisitemp1	:	INTEGER range 0 to 999999     := 0;
	SIGNAL posisitemp_x	:	INTEGER range 0 to 999999     := 0;
	SIGNAL posisitemp_y	:	INTEGER range 0 to 999999     := 0;
	SIGNAL posisi_x		:	STD_LOGIC_VECTOR (9 DOWNTO 0)	:= "0000000000";
	SIGNAL posisi_y		:	STD_LOGIC_VECTOR (9 DOWNTO 0)	:= "0000000000";
	SIGNAL bcdx0			:	STD_LOGIC_VECTOR (3 DOWNTO 0)	:= "0000";
	SIGNAL bcdx1			:	STD_LOGIC_VECTOR (3 DOWNTO 0)	:= "0000";
	SIGNAL bcdx2			:	STD_LOGIC_VECTOR (3 DOWNTO 0)	:= "0000";
	SIGNAL bcdy0			:	STD_LOGIC_VECTOR (3 DOWNTO 0)	:= "0000";
	SIGNAL bcdy1			:	STD_LOGIC_VECTOR (3 DOWNTO 0)	:= "0000";
	SIGNAL bcdy2			:	STD_LOGIC_VECTOR (3 DOWNTO 0)	:= "0000";
	
BEGIN
	PROCESS (rot0_a, rot0_b, rot1_a, rot1_b)
	variable Zx		:	STD_LOGIC_VECTOR (21 DOWNTO 0);
	variable Zy		:	STD_LOGIC_VECTOR (21 DOWNTO 0);
   BEGIN
		--memastikan nilai zx kembali 0
		FOR i in 0 to 21 LOOP
			Zx(i) := '0';
		END LOOP;
		--memastikan nilai zy kembali 0
		FOR i in 0 to 21 LOOP
			Zy(i) := '0';
		END LOOP;
		--rotary encoder 0
		IF (rot0_a /= a0prev) THEN
			IF (rot0_b /= rot0_a) THEN
				IF (counter0 < 2191) THEN
					counter0 <= counter0 + 1;
				END IF;
			ELSIF (rot0_b = rot0_a) THEN
				IF (counter0 > -2191) THEN
					counter0 <= counter0 - 1;
				END IF;
			END IF;
		END IF;
		a0prev <= rot0_a;
		--rotary encoder 1
		IF (rot1_a /= a1prev) THEN
			IF (rot1_b /= rot1_a) THEN
				IF (counter1 < 2191) THEN
					counter1 <= counter1 + 1;
				END IF;
			ELSIF (rot1_b = rot1_a) THEN
				IF (counter1 > -2191) THEN
					counter1 <= counter1 - 1;
				END IF;
			END IF;
		END IF;
		a1prev <= rot1_a;
		--hitung posisi
		posisitemp0 <= abs(counter0) * 456 / 1000;
		posisitemp1 <= abs(counter1) * 456 / 1000;
		IF (counter0 >= 0) THEN
			IF (counter1 >= 0) THEN
				posisitemp_x <= (posisitemp0 * 707 / 1000) + (posisitemp1 * 707 / 1000);
				posisitemp_y <= (posisitemp0 * 707 / 1000) - (posisitemp1 * 707 / 1000);
			ELSE
				posisitemp_x <= (posisitemp0 * 707 / 1000) - (posisitemp1 * 707 / 1000);
				posisitemp_y <= (posisitemp0 * 707 / 1000) + (posisitemp1 * 707 / 1000);
			END IF;
		ELSE
			IF (counter1 >= 0) THEN
				posisitemp_x <= -(posisitemp0 * 707 / 1000) + (posisitemp1 * 707 / 1000);
				posisitemp_y <= -(posisitemp0 * 707 / 1000) - (posisitemp1 * 707 / 1000);
			ELSE
				posisitemp_x <= -(posisitemp0 * 707 / 1000) - (posisitemp1 * 707 / 1000);
				posisitemp_y <= -(posisitemp0 * 707 / 1000) + (posisitemp1 * 707 / 1000);
			END IF;
		END IF;
		posisi_x <= std_logic_vector(to_unsigned(posisitemp_x, posisi_x'length));
		posisi_y <= std_logic_vector(to_unsigned(posisitemp_y, posisi_y'length));
		--convert ke bcd axis x
		Zx(12 DOWNTO 3) := posisi_x;
		FOR i IN 0 TO 6 LOOP
			IF Zx(13 DOWNTO 10) > "0100" THEN
				Zx(13 DOWNTO 10) := Zx(13 DOWNTO 10) + "0011";
			END IF;
			IF Zx(17 DOWNTO 14) > "0100" THEN
				Zx(17 DOWNTO 14) := Zx(17 DOWNTO 14) + "0011";
			END IF;
			Zx(21 DOWNTO 1) := Zx(20 DOWNTO 0);
		END LOOP;
		bcdx0 <= Zx(13 DOWNTO 10);
		bcdx1 <= Zx(17 DOWNTO 14);
		bcdx2 <= Zx(21 DOWNTO 18);
		--convert ke bcd axis y
		Zy(12 DOWNTO 3) := posisi_y;
		FOR i IN 0 TO 6 LOOP
			IF Zy(13 DOWNTO 10) > "0100" THEN
				Zy(13 DOWNTO 10) := Zy(13 DOWNTO 10) + "0011";
			END IF;
			IF Zy(17 DOWNTO 14) > "0100" THEN
				Zy(17 DOWNTO 14) := Zy(17 DOWNTO 14) + "0011";
			END IF;
			Zy(21 DOWNTO 1) := Zy(20 DOWNTO 0);
		END LOOP;
		bcdy0 <= Zy(13 DOWNTO 10);
		bcdy1 <= Zy(17 DOWNTO 14);
		bcdy2 <= Zy(21 DOWNTO 18);
	END PROCESS;
	
	--seven segment
	loutx0 <= "0000001" when bcdx0 = "0000" else
				 "1001111" when bcdx0 = "0001" else
				 "0010010" when bcdx0 = "0010" else
				 "0000110" when bcdx0 = "0011" else
				 "1001100" when bcdx0 = "0100" else
				 "0100100" when bcdx0 = "0101" else
				 "0100000" when bcdx0 = "0110" else
				 "0001111" when bcdx0 = "0111" else
				 "0000000" when bcdx0 = "1000" else
				 "0000100" when bcdx0 = "1001" else
				 "0110000";
					
	loutx1 <= "0000001" when bcdx1 = "0000" else
				 "1001111" when bcdx1 = "0001" else
				 "0010010" when bcdx1 = "0010" else
				 "0000110" when bcdx1 = "0011" else
				 "1001100" when bcdx1 = "0100" else
				 "0100100" when bcdx1 = "0101" else
				 "0100000" when bcdx1 = "0110" else
				 "0001111" when bcdx1 = "0111" else
				 "0000000" when bcdx1 = "1000" else
				 "0000100" when bcdx1 = "1001" else
				 "0110000";
				
	loutx2 <= "0000001" when bcdx2 = "0000" else
				 "1001111" when bcdx2 = "0001" else
				 "0010010" when bcdx2 = "0010" else
				 "0000110" when bcdx2 = "0011" else
				 "1001100" when bcdx2 = "0100" else
				 "0100100" when bcdx2 = "0101" else
				 "0100000" when bcdx2 = "0110" else
				 "0001111" when bcdx2 = "0111" else
				 "0000000" when bcdx2 = "1000" else
				 "0000100" when bcdx2 = "1001" else
				 "0110000";
	
	louty0 <= "0000001" when bcdy0 = "0000" else
				 "1001111" when bcdy0 = "0001" else
				 "0010010" when bcdy0 = "0010" else
				 "0000110" when bcdy0 = "0011" else
				 "1001100" when bcdy0 = "0100" else
				 "0100100" when bcdy0 = "0101" else
				 "0100000" when bcdy0 = "0110" else
				 "0001111" when bcdy0 = "0111" else
				 "0000000" when bcdy0 = "1000" else
				 "0000100" when bcdy0 = "1001" else
				 "0110000";
					
	louty1 <= "0000001" when bcdy1 = "0000" else
				 "1001111" when bcdy1 = "0001" else
				 "0010010" when bcdy1 = "0010" else
				 "0000110" when bcdy1 = "0011" else
				 "1001100" when bcdy1 = "0100" else
				 "0100100" when bcdy1 = "0101" else
				 "0100000" when bcdy1 = "0110" else
				 "0001111" when bcdy1 = "0111" else
				 "0000000" when bcdy1 = "1000" else
				 "0000100" when bcdy1 = "1001" else
				 "0110000";
				
	louty2 <= "0000001" when bcdy2 = "0000" else
				 "1001111" when bcdy2 = "0001" else
				 "0010010" when bcdy2 = "0010" else
				 "0000110" when bcdy2 = "0011" else
				 "1001100" when bcdy2 = "0100" else
				 "0100100" when bcdy2 = "0101" else
				 "0100000" when bcdy2 = "0110" else
				 "0001111" when bcdy2 = "0111" else
				 "0000000" when bcdy2 = "1000" else
				 "0000100" when bcdy2 = "1001" else
				 "0110000";
END logic;