section .data
    msg db "Enter a string: "
    len_msg equ $-msg
    msg_palindrome db "It is a palindrome",0xa
    len_palindrome equ $-msg_palindrome
    msg_not_palindrome db "It is NOT a palindrome",0xa
    len_not_palindrome equ $-msg_not_palindrome

section .bss
buffer resb 1024

section .text
global _start

; is_palindrome function
is_palindrome:
    push ebp        ; set up stack frame
    mov ebp, esp
    push esi        ; save registers
    push edi

    mov eax, [ebp+8]    ; get buffer
    mov edx, [ebp+12]   ; get len

    mov esi, eax        ; set up pointers
    mov edi, eax
    add edi, edx
    dec edi
    shr edx, 1          ; divide by 2

    palindrome_loop:
        cmp esi, edi    ; check if pointers have met
        jae palindrome_end

        mov al, [esi]
        mov bl, [edi]
        cmp al, bl      ; check if characters are the same
        jne not_palindrome

        inc esi         ; move pointers
        dec edi
        jmp palindrome_loop

    not_palindrome:
        mov eax, 0      ; return 0 (false)
        jmp palindrome_exit

    palindrome_end:
        mov eax, 1      ; return 1 (true)

    palindrome_exit:
        pop edi         ; restore registers
        pop esi
        mov esp, ebp    ; clean up stack
        pop ebp
        ret

; main program
_start:
    ; loop until user is finished
    loop_start:
        ; prompt for string
        mov eax, 4      ; SYS_WRITE
        mov ebx, 1      ; STDOUT
        mov ecx, msg
        mov edx, len_msg
        int 0x80

        ; read string
        mov eax, 3      ; SYS_READ
        mov ebx, 0      ; STDIN
        mov ecx, buffer
        mov edx, 1024
        int 0x80

        ; check for end of input
        cmp byte [buffer], 10
        je loop_end

        ; call is_palindrome
        mov ecx, buffer
        dec eax      ; decrement length by 1 (to exclude newline)
        push eax
        push ecx
        call is_palindrome
        add esp, 8      ; clean up stack

        ; print result
        cmp eax, 1
        je is_palindrome_true
        jmp is_palindrome_false

    is_palindrome_true:
        mov eax, 4      ; SYS_WRITE
        mov ebx, 1      ; STDOUT
        mov ecx, msg_palindrome
        mov edx, len_palindrome
        int 0x80
        jmp loop_start

    is_palindrome_false:
        mov eax, 4      ; SYS_WRITE
        mov ebx, 1      ; STDOUT
        mov ecx, msg_not_palindrome
        mov edx, len_not_palindrome
        int 0x80
        jmp loop_start

    ; end of input
    loop_end:
        ; exit program
        mov eax, 1      ; SYS_EXIT
        xor ebx, ebx    ; return 0
        int 0x80