EESchema Schematic File Version 4
LIBS:wasserschaden-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L wasserschaden-rescue:WeMos_mini U2
U 1 1 5B26FC39
P 4000 2100
F 0 "U2" H 4000 2600 60  0000 C CNN
F 1 "WeMos_mini" H 4000 1600 60  0000 C CNN
F 2 "test_wemos:wemos-d1-mini-with-pin-header" H 4550 1400 60  0001 C CNN
F 3 "" H 4550 1400 60  0000 C CNN
	1    4000 2100
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:2N7000 IRFZ44N1
U 1 1 5B2A69C6
P 2900 2250
F 0 "IRFZ44N1" H 3150 2250 50  0000 L CNN
F 1 " " H 3100 2250 50  0000 L CNN
F 2 "test_wemos:irlz44n" H 3100 2175 50  0001 L CIN
F 3 "" H 2900 2250 50  0001 L CNN
	1    2900 2250
	-1   0    0    1   
$EndComp
Wire Wire Line
	3100 2250 3200 2250
$Comp
L wasserschaden-rescue:Screw_Terminal_01x02 J1
U 1 1 5B2A6B15
P 2450 2750
F 0 "J1" H 2450 2850 50  0000 C CNN
F 1 "valve out" H 2800 2700 50  0000 C CNN
F 2 "Connectors_Terminal_Blocks:TerminalBlock_Altech_AK300-2_P5.00mm" H 2450 2750 50  0001 C CNN
F 3 "" H 2450 2750 50  0001 C CNN
	1    2450 2750
	-1   0    0    1   
$EndComp
$Comp
L wasserschaden-rescue:Screw_Terminal_01x02 J2
U 1 1 5B2A6B9D
P 2450 3200
F 0 "J2" H 2450 3300 50  0000 C CNN
F 1 "12V in" H 2750 3150 50  0000 C CNN
F 2 "Connectors_Terminal_Blocks:TerminalBlock_Altech_AK300-2_P5.00mm" H 2450 3200 50  0001 C CNN
F 3 "" H 2450 3200 50  0001 C CNN
	1    2450 3200
	-1   0    0    1   
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR01
U 1 1 5B2A6BE6
P 2650 3200
F 0 "#PWR01" H 2650 2950 50  0001 C CNN
F 1 "GND" H 2650 3050 50  0000 C CNN
F 2 "" H 2650 3200 50  0001 C CNN
F 3 "" H 2650 3200 50  0001 C CNN
	1    2650 3200
	0    -1   -1   0   
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR02
U 1 1 5B2A6C2A
P 3500 1850
F 0 "#PWR02" H 3500 1600 50  0001 C CNN
F 1 "GND" H 3500 1700 50  0000 C CNN
F 2 "" H 3500 1850 50  0001 C CNN
F 3 "" H 3500 1850 50  0001 C CNN
	1    3500 1850
	0    1    1    0   
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR03
U 1 1 5B2A6C5A
P 2800 2050
F 0 "#PWR03" H 2800 1800 50  0001 C CNN
F 1 "GND" H 2800 1900 50  0000 C CNN
F 2 "" H 2800 2050 50  0001 C CNN
F 3 "" H 2800 2050 50  0001 C CNN
	1    2800 2050
	-1   0    0    1   
$EndComp
$Comp
L wasserschaden-rescue:D D1
U 1 1 5B2A6D63
P 3050 2750
F 0 "D1" H 3050 2850 50  0000 C CNN
F 1 " " H 3150 2850 50  0000 C CNN
F 2 "Diodes_THT:D_A-405_P7.62mm_Horizontal" H 3050 2750 50  0001 C CNN
F 3 "" H 3050 2750 50  0001 C CNN
	1    3050 2750
	-1   0    0    1   
$EndComp
$Comp
L wasserschaden-rescue:stepdown U1
U 1 1 5B2A6F8D
P 3800 3000
F 0 "U1" H 3950 2950 60  0000 C CNN
F 1 "stepdown" H 4050 3000 60  0000 C CNN
F 2 "stepdown:stepdown" H 3800 3000 60  0001 C CNN
F 3 "" H 3800 3000 60  0001 C CNN
	1    3800 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 1750 4950 1750
$Comp
L wasserschaden-rescue:GND #PWR04
U 1 1 5B2A7077
P 3400 2900
F 0 "#PWR04" H 3400 2650 50  0001 C CNN
F 1 "GND" H 3400 2750 50  0000 C CNN
F 2 "" H 3400 2900 50  0001 C CNN
F 3 "" H 3400 2900 50  0001 C CNN
	1    3400 2900
	0    1    1    0   
$EndComp
NoConn ~ 3500 1750
NoConn ~ 3500 1950
NoConn ~ 3500 2050
NoConn ~ 3500 2350
NoConn ~ 3500 2450
NoConn ~ 4500 2450
NoConn ~ 4500 2350
NoConn ~ 4500 2250
NoConn ~ 4500 2150
NoConn ~ 4500 2050
NoConn ~ 4500 1950
NoConn ~ 4500 1850
Wire Wire Line
	2650 2750 2800 2750
Wire Wire Line
	2800 2450 2800 2750
Connection ~ 2800 2750
Text Notes 2300 2800 0    60   ~ 0
+\n-
Text Notes 2300 3250 0    60   ~ 0
+\n-
Wire Wire Line
	4950 1750 4950 2000
Wire Wire Line
	2650 2650 3200 2650
Wire Wire Line
	3200 2650 3200 2750
$Comp
L wasserschaden-rescue:+12V #PWR05
U 1 1 5B2A7A00
P 2650 2650
F 0 "#PWR05" H 2650 2500 50  0001 C CNN
F 1 "+12V" H 2650 2790 50  0000 C CNN
F 2 "" H 2650 2650 50  0001 C CNN
F 3 "" H 2650 2650 50  0001 C CNN
	1    2650 2650
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:+12V #PWR06
U 1 1 5B2A7A20
P 2650 3100
F 0 "#PWR06" H 2650 2950 50  0001 C CNN
F 1 "+12V" H 2650 3240 50  0000 C CNN
F 2 "" H 2650 3100 50  0001 C CNN
F 3 "" H 2650 3100 50  0001 C CNN
	1    2650 3100
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:+12V #PWR07
U 1 1 5B2A7A40
P 3400 3050
F 0 "#PWR07" H 3400 2900 50  0001 C CNN
F 1 "+12V" H 3350 3200 50  0000 C CNN
F 2 "" H 3400 3050 50  0001 C CNN
F 3 "" H 3400 3050 50  0001 C CNN
	1    3400 3050
	0    -1   -1   0   
$EndComp
$Comp
L wasserschaden-rescue:R R1
U 1 1 5B2A7CB0
P 3050 2100
F 0 "R1" V 3130 2100 50  0000 C CNN
F 1 "20K" V 3050 2100 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2980 2100 50  0001 C CNN
F 3 "" H 3050 2100 50  0001 C CNN
	1    3050 2100
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR08
U 1 1 5B2A7CE4
P 3050 1950
F 0 "#PWR08" H 3050 1700 50  0001 C CNN
F 1 "GND" H 3050 1800 50  0000 C CNN
F 2 "" H 3050 1950 50  0001 C CNN
F 3 "" H 3050 1950 50  0001 C CNN
	1    3050 1950
	-1   0    0    1   
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR09
U 1 1 5B2A9F12
P 4700 2900
F 0 "#PWR09" H 4700 2650 50  0001 C CNN
F 1 "GND" H 4650 2750 50  0000 C CNN
F 2 "" H 4700 2900 50  0001 C CNN
F 3 "" H 4700 2900 50  0001 C CNN
	1    4700 2900
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4950 3050 4700 3050
$Comp
L wasserschaden-rescue:LED D2
U 1 1 5B2BDC1C
P 3200 1500
F 0 "D2" H 3200 1600 50  0000 C CNN
F 1 "LED" H 3200 1400 50  0000 C CNN
F 2 "LEDs:LED_D3.0mm" H 3200 1500 50  0001 C CNN
F 3 "" H 3200 1500 50  0001 C CNN
	1    3200 1500
	0    1    1    0   
$EndComp
$Comp
L wasserschaden-rescue:R R2
U 1 1 5B2BDCBD
P 3200 1200
F 0 "R2" V 3280 1200 50  0000 C CNN
F 1 "R" V 3200 1200 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3130 1200 50  0001 C CNN
F 3 "" H 3200 1200 50  0001 C CNN
	1    3200 1200
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR010
U 1 1 5B2BDCFD
P 3200 1050
F 0 "#PWR010" H 3200 800 50  0001 C CNN
F 1 "GND" H 3200 900 50  0000 C CNN
F 2 "" H 3200 1050 50  0001 C CNN
F 3 "" H 3200 1050 50  0001 C CNN
	1    3200 1050
	-1   0    0    1   
$EndComp
Connection ~ 4950 2000
Wire Wire Line
	3200 1650 3200 2250
Connection ~ 3200 2250
$Comp
L wasserschaden-rescue:LED D3
U 1 1 5B2C19FD
P 5100 2000
F 0 "D3" H 5100 2100 50  0000 C CNN
F 1 "LED" H 5100 1900 50  0000 C CNN
F 2 "LEDs:LED_D3.0mm" H 5100 2000 50  0001 C CNN
F 3 "" H 5100 2000 50  0001 C CNN
	1    5100 2000
	-1   0    0    1   
$EndComp
$Comp
L wasserschaden-rescue:R R3
U 1 1 5B2C1A03
P 5250 2150
F 0 "R3" V 5330 2150 50  0000 C CNN
F 1 "R" V 5250 2150 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 5180 2150 50  0001 C CNN
F 3 "" H 5250 2150 50  0001 C CNN
	1    5250 2150
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR011
U 1 1 5B2C1A09
P 5250 2300
F 0 "#PWR011" H 5250 2050 50  0001 C CNN
F 1 "GND" H 5250 2150 50  0000 C CNN
F 2 "" H 5250 2300 50  0001 C CNN
F 3 "" H 5250 2300 50  0001 C CNN
	1    5250 2300
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:LED D4
U 1 1 5B2C1D4C
P 3450 1500
F 0 "D4" H 3450 1600 50  0000 C CNN
F 1 "LED" H 3450 1400 50  0000 C CNN
F 2 "LEDs:LED_D3.0mm" H 3450 1500 50  0001 C CNN
F 3 "" H 3450 1500 50  0001 C CNN
	1    3450 1500
	0    1    1    0   
$EndComp
$Comp
L wasserschaden-rescue:R R4
U 1 1 5B2C1D52
P 3450 1200
F 0 "R4" V 3530 1200 50  0000 C CNN
F 1 "R" V 3450 1200 50  0000 C CNN
F 2 "Resistors_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3380 1200 50  0001 C CNN
F 3 "" H 3450 1200 50  0001 C CNN
	1    3450 1200
	1    0    0    -1  
$EndComp
$Comp
L wasserschaden-rescue:GND #PWR012
U 1 1 5B2C1D58
P 3450 1050
F 0 "#PWR012" H 3450 800 50  0001 C CNN
F 1 "GND" H 3450 900 50  0000 C CNN
F 2 "" H 3450 1050 50  0001 C CNN
F 3 "" H 3450 1050 50  0001 C CNN
	1    3450 1050
	-1   0    0    1   
$EndComp
Wire Wire Line
	3450 1650 3300 1650
Wire Wire Line
	3300 1650 3300 2150
Wire Wire Line
	3300 2150 3500 2150
$Comp
L wasserschaden-rescue:+3.3V #PWR013
U 1 1 5B2C1F93
P 4950 1750
F 0 "#PWR013" H 4950 1600 50  0001 C CNN
F 1 "+3.3V" H 4950 1890 50  0000 C CNN
F 2 "" H 4950 1750 50  0001 C CNN
F 3 "" H 4950 1750 50  0001 C CNN
	1    4950 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 2250 3050 2250
Wire Wire Line
	2800 2750 2900 2750
Wire Wire Line
	4950 2000 4950 3050
Wire Wire Line
	3200 2250 3500 2250
$EndSCHEMATC
