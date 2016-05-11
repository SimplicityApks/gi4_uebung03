
SECTION .data
    x DW 2
    ergebnis RESD 1
    message DB "Result: %i", 10, 0

SECTION .text
    global main
   ; global ergebnis
    extern printf

main:
    push ebp
    mov ebp, esp

    ; begin program

    call calc

    call print
    ;call calc_polynomial
    ;call calc_horner

    ; end program

    mov esp, ebp
    pop ebp

    mov ebx, 0
    mov eax, 1
    int 0x80

calc:
    mov eax, DWORD [x]
    mov ebx, DWORD [x]
    imul ebx        ; edx:eax = ebx*eax
    mov ecx, DWORD 3
    imul ecx        ; edx:eax = 3*eax
    mov ecx, DWORD 4
    imul ecx, ebx   ; edx:ecx = 4*x
    add eax, ecx
    mov ecx, DWORD 5
    sub eax, ecx

    ; save result in ergebnis
	mov [ergebnis], eax
    ret

; calculates the general polynomial ax¹+bx+c
calc_polynomial:
    ; array in memory (a=0x21, b=0x02, c=0x07), little endian:
    ;   a       b       c
    ; 0x210000000200000007000000

    ; ebx contians pointer to coefficient array
    mov eax, DWORD [x]
    imul eax        ; edx:eax = eax*eax
    ; load a from coefficient into ecx
    lds ecx, [ebx]
    imul ecx        ; edx:eax = 3*eax
    ; load b from coefficient into ecx
    lds ecx, [ebx + 4] ; bytes
    mov edx, DWORD [x]
    imul ecx, edx   ; edx:ecx = 4*x
    add eax, ecx
    ; load c from coefficient into ecx
    lds ecx, [ebx + 8] ; bytes
    add eax, ecx

    ; save result in ergebnis
	mov [ergebnis], eax
    ret

calc_horner:
    ; with the Horner scheme
    ; 3x²+4x-5 = (3x+4)x-5
    ; ax¹+bx+c = (ax+b)x+c
    ; there are now only 2 (=n) multiplications instead of 3 (=2n-1)

    ;  TODO number 5
    mov eax, DWORD [x]
    lds ecx, [ebx]
    imul ecx        ; edx:eax = ecx*eax = ax
    lds ecx, [ebx + 4] ; bytes
    add eax, ecx
    mov ecx, DWORD [x]
    imul ecx
    lds ecx, [ebx + 8] ; bytes
    add eax, ecx
    ; save result in ergebnis
	mov [ergebnis], eax
    ret

; to calculate expressions of the form for(i=0; i<N; i++) { a(i) * x^i }
; we'd need to put the lds, imul and add commands (lines 82—87) above in a loop
; running from 0 to N/2 (adjusting ebx accordingly), assuming the array still contains the values a(i).

; print contents of ergebnis with printf
print:
    ; printf tokes the text as first and the param as second argument
    push DWORD [ergebnis]
    push message
    call printf
    ; reset stack pointer
	add esp, 8
    ret
