INCLUDE NUTS.DAT ;DONT FORGET TO INCLUDE YOUR EXTERNAL FILES
INCLUDE DOS.MAC  ;IF YOU USE DIFFERENT NAMED MACRO, CHANGE HERE

STACK_SEG SEGMENT STACK USE16
DB 100 DUP(?)
STACK_SEG ENDS     

DATA_SEG SEGMENT 'DATA' USE16
NUTS  ;DEFINE MACRO NAME HERE IF IT INCLUDES DATA_SEG RELATED CODE
NEWLINE DB 0DH,0AH,'$'
DATA_SEG ENDS 

CODE_SEG SEGMENT PARA 'CODE' PUBLIC USE16
ASSUME CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG

PRINT PROC NEAR
PRINTSTRING [DI+2]
RET
PRINT ENDP
MAIN PROC FAR

  
INITIATE
MOV CX,08

 
MOV DI,LIST_ORG ;READ FIRST DATA FROM THE LIST
 
AGAIN:
 
MOV SI,[DI]  ;DEFINE NEXT ELEMENT
MOV DI,SI    ;MOVE TO NEXT ELEMENT
 
 

;MOV AH,9 ;CHANGE PRINT LIST TO A MACRO
;LEA DX,[DI+2]
;INT 21H
 
PRINTSTRING NEWLINE ;USE NEWLINE MACRO
call PRINT
  
  
DEC CX
JNZ AGAIN
  
  
;YOU SHOULD USE A LOOP TO PRINT THE LIST 
    
RET
MAIN ENDP
CODE_SEG ENDS              
END MAIN