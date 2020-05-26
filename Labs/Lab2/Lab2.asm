STACK_SEG SEGMENT STACK USE16
DB 100 DUP(?)
STACK_SEG ENDS  

DATA_SEG SEGMENT 'DATA' USE16

ERRORM1 DB 0DH,0AH,'ERRORM!!   $'
ERRORM2 DB 0DH,0AH,'Input format: Operand1 Operator Operand2 $'
ERRORM3 DB 0DH,0AH,'Operand: decimal numbers$'
ERRORM4 DB 0DH,0AH,'Operator: + -   $'
 
OUTMSG0 DB 0DH,0AH,'CE302 LAB4$'
OUTMSG DB 0DH,0AH,'Enter an algebraic command line:$'
OUTMSG2 DB 0DH,0AH,'Result:  $'
OUTMSG3 DB 0DH,0AH,'Again?:  $'
INSTRING DB 80,?,80 DUP('$') 
INCHAR DB ? 
NEWLINE DB 0DH,0AH,'$'
DATA_SEG ENDS 
 
CODE_SEG SEGMENT PARA 'CODE' PUBLIC USE16
ASSUME CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG  
                  
MAIN PROC FAR
 PUSH DS ;INITIATE THE PROGRAM
 XOR AX,AX
 PUSH AX
 MOV AX,DATA_SEG
 MOV DS,AX 
 
AGAIN:
 LEA DX,OUTMSG0 
 MOV AH,9
 INT 21H 
 
 LEA DX,OUTMSG 
 MOV AH,9
 INT 21H 
 
             MOV AH,0AH
			 LEA DX,INSTRING
			 INT 21H 
			 
             XOR AX,AX
             LEA DI,INSTRING+2 
             MOV AL,[DI]  ;FIRST NUMBER
             MOV BL,[DI+2];SECOND NUMBER
             
             CMP AL,30H
             JL  ERRORM
             CMP AL,39H
             JA  ERRORM
             
             CMP BL,30H
             JL  ERRORM
             CMP BL,39H
             JA  ERRORM
             
             SUB AL,30H
			 SUB BL,30H
              
             MOV CL,[DI+1] ;ANALYSE OPERATOR 
			 
CMP CL,2BH    ;ASCII FOR +		 
JNE NOTADD
ADD AL,BL     ;ADDITION HERE
JMP ENDSWITCH
          
NOTADD: 
CMP CL,2DH 	  ;ASCII FOR - 
JNE NOTSUB
SUB AL,BL
JMP ENDSWITCH
        
NOTSUB:
        ;@@@@@ IMPLEMENT MULTIPLICATION HERE @@@@@
CMP CL,2AH 	  ;ASCII FOR *
JNE NOTMULT
MUL BL
JMP ENDSWITCH

NOTMULT: 
		;@@@@@ IMPLEMENT DIVISION HERE @@@@@
CMP CL,2FH 	  ;ASCII FOR /
JNE ERRORM
DIV BL
JMP ENDSWITCH
		
ERRORM:
		;@@@@@ CALL ERRORS HERE @@@@@
 LEA DX,ERRORM1
 MOV AH,9
 INT 21H
 JMP AGAIN2

ENDSWITCH:

     MOV BX,10	;bx -> divide by 10
     DIV BL  	;divide. AL is quotient, AH is Remainder
     ADD AL,48	;any number + 48 = the same number in ASCII
     ADD AH,48  

MOV INCHAR,AL ;PRINT PART

PUSH AX
 MOV AH,9 
 LEA DX,OUTMSG2 ;Result:
 INT 21H 

 MOV DL,INCHAR;PRINTING AL
 MOV AH,2
 INT 21H 
POP AX

MOV AL,AH	 ;puts ah into al to print
MOV INCHAR,AL;PRINTING AH
MOV DL,INCHAR
MOV AH,2
INT 21H 

AGAIN2:
MOV AH,9 
LEA DX,OUTMSG3 ;AGAIN?
INT 21H 

MOV AH,1    ;READ A CHAR FROM USER TO DECIDE LOOP
INT 21H
MOV INCHAR,AL

		;@@@@@ CHECK IF INPUT IS CAPITAL 'Y', IF IT IS TRUE LOOP AGAIN ELSE CLOSE PROGRAM @@@@@
CMP AL,59H
JNE TERMINATE
JMP AGAIN

TERMINATE:

RET
MAIN ENDP 
CODE_SEG ENDS
END MAIN     