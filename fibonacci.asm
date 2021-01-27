default rel
bits 64

global getint ; Debug purpose
global main

extern _CRT_INIT
extern printf
extern scanf
extern ExitProcess

section .data
    intprompt db "%lld", 0 ; Prompt for the limit
    result db "%lld", 13, 10, 0 ; Print the current suite value


section .text

getint:
    push rbp
    mov rbp, rsp
    sub rsp, 16 ; 1 u64 used on the 1st byte of the stack (rsp+8), 16 bytes aligned
    
    lea rdx, [rsp + 8] ; Pointer to 1st stack byte, where the inputted value will by written
    mov al, 2
    sub rsp, 32
    call scanf ; 1st argument in scanf is the same as the one for getint call, so rcx isn't changed
    add rsp, 32

    mov rax, [rsp + 8] ; Result stored in the 1st stack byte

    add rsp, 16
    mov rsp, rbp
    pop rbp
    ret

main:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 24 ; main's stack layout :
    ; rsp+24 (== rbp) : saved caller's rbx
    ; rsp+16          : (16 bytes alignment)
    ; rsp+8           : previous fibonacci suite term (k-1 term)
    ; rsp+0           : current fibonacci suite term (k term)

    sub rsp, 32 ; Same 4 bytes stack reserved for both _CRT_INIT and getint calls
    call _CRT_INIT ; Microsoft C Runtime initialization
    lea rcx, [intprompt]
    call getint
    mov rbx, rax ; Saved inputted integer N into rbx
    add rsp, 32

    mov qword [rsp + 8], 0 ; 1st term (for k=0) is 0
    mov qword [rsp], 1 ; 2nd term (for k=1) is 1
    
    iteration: ; for each term... [*]
    mov rdx, [rsp + 8] ; Preparing sum : beginning from u(k-1)
    add rdx, [rsp] ; Then add u(k) 

    mov rax, [rsp] ; Store u(k) in tmp rax
    mov [rsp + 8], rax ; Set u(k-1) to u(k) by using rax (address-to-address mov not possible in x86/64)
    mov [rsp], rdx ; Set u(k) to previously calculated u(k) + u(k-1) (now u(k-1) + u(k-2) as u(k) has been moved to u(k-1))

    lea rcx, [result]
    mov al, 2
    sub rsp, 32
    call printf ; Sum to print at rsp+0 was already calculated in rdx (2nd arg), so no need to change that register before calling
    add rsp, 32

    cmp qword [rsp], rbx ; [*] ...until current term u(k) is superior or equal than
    jb iteration

    add rsp, 24 ; Stack deallocation
    pop rbx ; Restore caller's rbx
    mov rsp, rbp
    pop rbp
    
    xor ecx, ecx ; Set u32 part of rcx (1st arg) to 0, because the process terminated successfully
    call ExitProcess
