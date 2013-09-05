;Assembly language program  A3.ASM
;         Objective: 	The objective of the program is transmit data using serial in paralel out structure
;         Inputs:       data from a seperate file.
;         Output:     	Messages telling the user what the data file contained.
%include  "io.mac"



.DATA
	start_msg    			db  'The program has started',0
	trans_start			db  'The transmission has started',0
	trans_end			db  'The transmission has ended',0
	ip_msg				db  'The IP address is ',0
	message_msg			db  'The message is ',0
	ones_msg			db  'The number of ones is ',0
	expected_msg			db  'The expected number of ones is ',0
	error_msg			db  'Error In Transmission',0
	end_msg				db  'The program has ended',0
	address	  	TIMES 4  	db  1	 ; reserve 4 bytes for the address array
	message		TIMES 10	db  1	 ; reserve an array of a few bytes for the message
	STX				db  02H	; start of transmission
	ETX				db  03H	; end of text
	EOT				db  04H	; end of transmission


.UDATA
	checksum	resb  1          ;stores the checksum
	input_str	resb  12	 ;stores the input string
	count		resb  1		 ;keeps track of the position of the index of the input string
	temp		resb  1		 ; temporary variable
	

.CODE
	.STARTUP
	GetStr input_str	; get the text from the other file
	nwln			; new line
	PutStr input_str	; print it
	nwln			; new line
	nwln			; new line
	PutStr start_msg	; print the start message
	nwln			; new line
	push address		; push a pointer of the address array into the stack
	push message		; push a pointer of the address array into the stack 
	push WORD [checksum]	; push the checksum word into the stack

	call sipo		; call the sipo function (serial in parallel out)
	call checker		; call the checker function
	call terminate		; call terminate function

	.EXIT


sipo:					; sipo procedure
	push EBP			; store the stack pointer
	push EAX			; push eax onto the stack
	push ECX			; push ecx onto the stack
	push EBX			; push ebx onto the stack
	push EDI			; push edi onto the stack
	push ESI			; push esi onto the stack
	push EDX			; push edx onto the stack
	
	mov EAX, input_str		; move the input string into eax
	mov EBP, ESP			; move the stack pointer into esp
	mov ECX, 8			; put 8 into CL for the loop
	mov ESI, 128			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI



start_loop:
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz shiftmask			; if yes jump to shiftmask
     	or EDI, ESI			; logical-or EDI and ESI
     	jmp	shiftmask		; jump to shiftmask

	
shiftmask:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	start_loop		; go back to the beginning of the loop and decrement the c register
	nwln				; new line
	test EDI, STX			; check if EDI is the same as the start of transmission character
	jz start_transmission		; if it is jump to start_transmission
	PutStr error_msg		; otherwise print the error message
	nwln				; new line
	jmp poper			; and jump to pop to skip the rest of the transmission

start_transmission:
	PutStr trans_start		; print the start of transmission message
	nwln				; new line
	PutStr ip_msg			; put the ip address message
	jmp setup_ip			; jump to setup_ip

setup_ip:
	mov ECX, 8			; put 8 in the c register for the loop
	mov ESI, 128			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI
	mov EBX, 0			; put 0 in EBX
	mov EBX, [EBP+31]		; put the address array in EBX
second_loop:
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz shift			; if the value is 0 jump to shift
	or EDI, ESI			; logical-or EDI and ESI
     	jmp shift			; jump to shiftmask	
shift:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	second_loop		; go back to the beginning of the loop and decrement the c register
	mov EBX, EDI			; put the value of the ip address into the array
	inc EBX				; increment the address pointer
	PutLInt EDI			; print the first number of the ip address
	PutCh '.'


setup_ip2:
	mov ECX, 8			; put 8 in the c register for the loop
	mov ESI, 128			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI
second_loop2:
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz shift2			; if the value is 0 jump to shift2
	or EDI, ESI			; logical-or EDI and ESI
     	jmp shift2			; jump to shiftmask	
shift2:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	second_loop2		; go back to the beginning of the loop and decrement the c register
	mov EBX, EDI			; put the value of the ip address into the array
	inc EBX				; increment the address pointer
	PutLInt EDI			; print the first number of the ip address
	PutCh '.'


setup_ip3:
	mov ECX, 8			; put 8 in the c register for the loop
	mov ESI, 128			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI
second_loop3:
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz shift3			; if the value is 0 jump to shift3
	or EDI, ESI			; logical-or EDI and ESI
     	jmp shift3			; jump to shiftmask
shift3:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	second_loop3		; go back to the beginning of the loop and decrement the c register
	mov EBX, EDI			; put the value of the ip address into the array
	inc EBX				; increment the address pointer
	PutLInt EDI			; print the first number of the ip address
	PutCh '.'
	

setup_ip4:
	mov ECX, 8			; put 8 in the c register for the loop
	mov ESI, 128			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI
second_loop4:
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz shift4			;
	or EDI, ESI			; logical-or EDI and ESI
     	jmp shift4			; jump to shiftmask	
shift4:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	second_loop4		; go back to the beginning of the loop and decrement the c register
	mov EBX, EDI			; put the value of the ip address into the array
	inc EBX				; increment the address pointer
	PutLInt EDI			; print the first number of the ip address
	nwln				; new line
	PutStr message_msg		; print the message message
	PutCh '"'			; print the beginning quote character

setup_message:
	mov ECX, 8			; put 8 in the c register for the loop
	mov ESI, 128			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI
	
message_loop:
	mov EBX, 0;
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz message_shift		; if the value is 0 jump to message_shift
	or EDI, ESI			; logical-or EDI and ESI
     	jmp message_shift		; jump to shiftmask
	
message_shift:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	message_loop		; go back to the beginning of the loop and decrement the c register
	mov EBX, EDI			; put the value of EDI into EBX
	cmp EBX, 3			; check if EBX contains the end of text symbol
	je end				; jump to end
	jmp do				; jump to do
do:	
	mov [count], EDI		; print the first character of the message
	PutCh [count]			; print the characer value of count
	jmp setup_message		; jump to setup_message
	


end:
	PutCh '"'			; print the closing quote sign
	nwln				; new line
	nwln				; new line
poper:
	pop EDX				; pop the original value of EDX
	pop ESI				; pop the original value of ESI
	pop EDI				; pop the original value of EDI
	pop EBX				; pop the original value of ebx
	pop ECX				; pop the original value of ecx
	pop EAX				; pop the original value of eax
	pop EBP				; restore the stack pointer

	ret 0				; return from the function



checker:			; checker procedure
	push EBP		; store the stack pointer
	push EAX		; push eax onto the stack
	push ECX		; push ecx onto the stack
	push EBX		; push ebx onto the stack
	push EDI		; push edi onto the stack
	push ESI		; push esi onto the stack
	push EDX		; push edx onto the stack
	mov EBP, ESP		; move the stack pointer into esp
	
	mov EAX, input_str	; put the input string into EAX
	add EAX, 40		; bring the input string pointer to the beginning of the message
	mov EDX, 0		; put 0 in edx
	PutStr ones_msg		; print the ones message

a_message:
	mov ECX, 8			; put 8 in the c register for the loop
	mov ESI, 128			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI
	
a_loop:
	mov EBX, 0;
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz a_shift			; if its zero jump to a_shift
	inc EDX				; increment the number of ones
	or EDI, ESI			; logical-or EDI and ESI
     	jmp a_shift			; jump to shiftmask
	
a_shift:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	a_loop			; go back to the beginning of the loop and decrement the c register
	mov EBX, EDI			; store the value of EDI into EBX
	cmp EBX, 3			; compare EBX and 3 which is the end of text character
	je bmessage			; jump to bmessage
	jmp doa				; jump to doa
doa:	
	jmp a_message			; jump to a_message
	


bmessage:
	mov ECX, 16			; put 8 in the c register for the loop
	mov ESI, 32768			; put 128 into edi which will be the bitmask
	mov EDI, 0			; Put 0 in EDI
	
bloop:
	mov EBX, 0;
	test BYTE [EAX+0], BYTE 1	; check is the selected character was a 1
	jz bshift			; if its zero jump to a_shift
	or EDI, ESI			; logical-or EDI and ESI
     	jmp bshift			; jump to shiftmask
	
bshift:
	shr	ESI,1			; right shift the bitmask by 1
	inc	EAX			; move esi's pointer to the next position in the array
	loop	bloop			; go back to the beginning of the loop and decrement the c register




enda:
	xor EAX, EAX			; empty the a register
	mov [count], EDX		; put the number of ones in a temporary variable
	mov AX, [count]			; put the numbers of ones in AX
	PutInt AX			; print the number of ones
	nwln				; new line
	PutStr expected_msg		; expected number of ones
	PutLInt EDI			; print the expected number of ones
	cmp EDX, EDI			; compare EDX and EDI
	je equal			; if they are not equal
	nwln 				; new line
	PutStr error_msg		; print the error message
	nwln				; new line
equal:
	nwln				; new line
	nwln				; new line
	pop EDX				; pop the original value of EDX
	pop ESI				; pop the original value of ESI
	pop EDI				; pop the original value of EDI
	pop EBX				; pop the original value of ebx
	pop ECX				; pop the original value of ecx
	pop EAX				; pop the original value of eax
	pop EBP				; restore the stack pointer
	ret 0				; return from the function 



terminate:			; terminate procedure
	PutStr trans_end	; print the end of transmission message
	nwln			; new line
	PutStr end_msg		; print the end message
	nwln			; new line
	ret 3			; return from the procedure

