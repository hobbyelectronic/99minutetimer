;Interval Timer 
	LIST	p=16F84A		;tell assembler what chip we are using
	#include <P16F84A.INC>	;include the defaults for the chip


	__CONFIG   _CP_OFF & _WDT_OFF & _PWRTE_ON & _LP_OSC

						
PC			EQU H'0002'
Ticks 		EQU H'000C'
Seconds  	EQU H'000D'
Minutes  	EQU H'000E'
Count	  	EQU H'000F'
HNibble 	EQU H'0010'
Delay		EQU H'0011'
TenMinutes	EQU H'0012'
Dipswitch	EQU H'0013'








	org	0x0000			;org sets the origin, 0x0000 for the 16F628,
					;this is where the program starts running	

	goto start


						
start

	Movlw b'01000111'
	Option

	MOVLW b'00000001'
	TRIS PORTA
	BCF PORTA,1

	MOVLW b'11111111'
	TRIS PORTB
	MOVF PORTB,W
	MOVWF Dipswitch 

	movlw b'00000000'
	movwf Minutes
	BTFSS PORTB,0
	BSF Minutes,3
	NOP
	BTFSS PORTB,1
	BSF Minutes,2
	NOP
	BTFSS PORTB,2
	BSF Minutes,1
	NOP
	BTFSS PORTB,3
	BSF Minutes,0
	NOP

	movlw b'00000000'
	movwf TenMinutes
		
	BTFSS PORTB,4
	BSF TenMinutes,3
	NOP
	BTFSS PORTB,5
	BSF TenMinutes,2
	NOP
	BTFSS PORTB,6
	BSF TenMinutes,1
	NOP
	BTFSS PORTB,7
	BSF TenMinutes,0
	NOP
	
	BTFSC PORTA,0
	Goto start
	Call Delay1
	Call Delay1
	Call Delay1
	BTFSC PORTA,0
	Goto start


	Movlw 	0xFF
	SUBWF   Dipswitch,W           
	btfsc    STATUS,Z
	Goto	start
	bcf      STATUS,Z

	BSF	PORTA,1

	movlw .60
	movwf Seconds

	CLRWDT ;Clear WDT and prescaler

	Movlw b'01000111'
	Option
	
Timer1

	Clrf TMR0
	Movlw	.224;
	Movwf TMR0
	
	

loop

	btfsc TMR0,7
	Goto loop
	
	Decfsz Seconds,f
	Goto Timer1
	movlw .60;
	movwf Seconds
	Movf Minutes,W
	
	Decfsz Minutes,f
	Goto Timer1
	Movlw .10
	Movwf Minutes

	Movlw 	0x00
	SUBWF   TenMinutes,W           
	btfsc    STATUS,Z
	Goto	start
	bcf      STATUS,Z


	
	Decfsz TenMinutes,f
	Goto Timer1

	Movlw 	0x00
	SUBWF   TenMinutes,W           
	btfsc    STATUS,Z
	Goto	Timer1
	bcf      STATUS,Z


	
	bcf PORTA,1

	goto start	

Delay1

	movlw .200
	movwf Delay
Loop1

	Decfsz Delay,f
	Goto Loop1
	Return
	


	End
