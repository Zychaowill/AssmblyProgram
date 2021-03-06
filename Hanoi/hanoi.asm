 ; The program is about Hanoi.
 ; This is main function.
 ;
			.ORIG 	x3000
 ;
 ; Push initial data onto stack 
 ;
	AGAIN		LD  	R6, STACKBASE		;
			LD  	R0, UPPER_E		; 
			STR 	R0, R6, #0		; Store uppercase letter E into R6
			ADD	R6, R6, #-1		;
			LD 	R0, UPPER_T		; 
			STR	R0, R6, #0		; Store uppercase letter T into R6
			ADD	R6, R6, #-1		; 
			LD 	R0, UPPER_S		; 
			STR 	R0, R6, #0		; Store uppercase letter S into R6
 ;
			LEA 	R0, PROMPT	  	; Load a prompt string 
			TRAP	x22			; Output to console
			LD	R0, NEWLINE		;
			TRAP 	x21			;
			LEA 	R0, PROMPT1		;
			TRAP 	x22			;
			LD  	R0, NEWLINE		;
			TRAP 	x21			;
			LEA 	R0, PROMPT2		;
			TRAP 	x22			;
 ;
 ; Input a data from console
 ;
	NEW		TRAP 	x23			; Input
 ;
 ; Read the data from keyboard.
 ; Check the data you input.
 ;
			AND	R2, R2, #0		;
			AND	R3, R3, #0		;
			LD	R2, NEGONE		; -x0031
			LD	R3, NEGNINE		; -x0039
			ADD	R2, R2, R0		;
			BRn	ERROR			;
			ADD	R3, R3, R0		;
			BRnz	NEXT			;
 ;	
	ERROR		LEA	R0, PROMPT4		;
			BRnzp	NEW			;
 ;
	NEXT		LD  	R1, ASCII		; -x0030
			ADD 	R0, R0, R1		;
			ADD 	R6, R6, #-1		;
			STR	R0, R6, #0		;
 ;
 ; Call subroutine from main.
 ;	
			JSR 	HANOI			;
	ERRLOOP		LEA	R0, PROMPT3		; Judge if you wanna continue?
			TRAP	x22			;
			TRAP	x23			;
			AND	R1, R1, #0		;
			AND	R2, R2, #0		;
			LD	R1, NEGUPPER_Y		;
			ADD	R1, R1, R0		;
			BRz	AGAIN			;
			LD	R2, NEGUPPER_N		;
			ADD	R2, R2, R0		;
			BRz	EXIT			;
			LEA	R0, PROMPT4		;
			TRAP	x22			;
			BRnzp	ERRLOOP			;
			
 ; 
 ; This is Hanoi function.
 ; Store the contents of R7 and R5.
 ;
	      HANOI	ADD	R6, R6, #-1		; Store the return address
			STR 	R7, R6, #0		;
			ADD 	R6, R6, #-1		; Push caller's frame pointer
			STR 	R5, R6, #0		;
			ADD 	R5, R6, #0		; Set new frame pointer
 ;
 ; Check if (n - 1 > 0) is true.
 ; If the condition is false,
 ;
			LDR 	R0, R5, #2		;
			ADD 	R0, R0, #-1		;
			BRz 	H_BASE			; When (R0 - 1 = 0) is true.
 ;
 ; else 
 ; Move(n - 1, S, E, T) 
 ;		
			LDR 	R0, R5, #4		; Push T
			ADD 	R6, R6, #-1		;
			STR 	R0, R6, #0		;
			LDR 	R0, R5, #5		; Push E
			ADD 	R6, R6, #-1		;
			STR 	R0, R6, #0		;
			LDR 	R0, R5, #3		; Push S
			ADD 	R6, R6, #-1		; 
			STR 	R0, R6, #0		;
			LDR 	R0, R5, #2		; Push (n - 1)
			ADD 	R0, R0, #-1		;
			ADD 	R6, R6, #-1		;
			STR 	R0, R6, #0		;
 ;
 ; Call subroutine
 ;
			JSR 	HANOI			;
 ;
 ; Move nth from S to E
 ;
			LDR 	R0, R5, #3		;
			TRAP 	x21			;
			LEA 	R0, OUTPUT		;
			TRAP 	x22			;
			LDR 	R0, R5, #5		;
			TRAP 	x21			;
			LD  	R0, NEWLINE		;
			TRAP 	x21			;
 ;
 ; Move(n - 1, T, S, E)
 ;	
			LDR 	R0, R5, #5		; Push E
			ADD 	R6, R6, #-1		;
			STR 	R0, R6, #0		;
			LDR 	R0, R5, #3		; Push S
			ADD 	R6, R6, #-1		;
			STR 	R0, R6, #0		;
			LDR 	R0, R5, #4		; Push T
			ADD 	R6, R6, #-1		;
			STR 	R0, R6, #0		;
			LDR 	R0, R5, #2		; Push (n - 1)
			ADD 	R0, R0, #-1		;
			ADD 	R6, R6, #-1		;
			STR 	R0, R6, #0		;
			JSR 	HANOI			;
 ;
			BRnzp 	H_END			;
 ; 
 ; Move S to E.
 ;
 	    H_BASE     	LDR 	R0, R5, #3		; 
			TRAP 	x21			;
			LEA 	R0, OUTPUT		; Load a string
			TRAP 	x22			; Output to console
			LDR 	R0, R5, #5		;
			TRAP 	x21			;
			LD  	R0, NEWLINE		; Print a new line
			TRAP 	x21			;
 ;
 ; Restore the contents of R5 and R7.
 ; 
	    H_END  	LDR 	R5, R6, #0		;
			ADD 	R6, R6, #1		;
			LDR 	R7, R6, #0		;
			ADD 	R6, R6, #5		;
			RET				;
 ;
 ; Exit. 
 ;
	    EXIT	TRAP	x25			;
 ;
	    ASCII   	.FILL 	xFFD0			;  -x0030
	    NEWLINE 	.FILL 	x000A			;
	    STACKBASE	.FILL 	x6000			;
	    NEGONE	.FILL	xFFCF			;
	    NEGNINE	.FILL	xFFC7			;
   	    UPPER_S     .FILL  	x0053			; Uppercase letter S
	    UPPER_T	.FILL 	x0054			; Uppercase letter T
 	    UPPER_E 	.FILL 	x0045			; Uppercase letter E
	    NEGUPPER_Y	.FILL	xFFA7			; Negative uppercase letter Y
	    NEGUPPER_N	.FILL 	xFFB2			; Negative uppercase letter N
	    PROMPT	.STRINGZ "Please input the number of Hanoi Tower(1-9)/>";
	    PROMPT1	.STRINGZ "All disks on the base S.";
	    PROMPT2	.STRINGZ "The sequence is S-T-E.";
	    PROMPT3	.STRINGZ "DO you wanna execute again?('Y' or 'N')/>";
	    PROMPT4	.STRINGZ "Input is an error!Please input again!";
  	    OUTPUT	.STRINGZ " -> "			;	
			.END
	