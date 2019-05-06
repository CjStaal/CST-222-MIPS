insertionSort(int*, int):
        lea     r9d, [rsi-2]
        xor     r8d, r8d
        cmp     esi, 1
        jle     .L1
.L7:
        mov     ecx, DWORD PTR [rdi+4+r8*4]
        mov     edx, DWORD PTR [rdi+r8*4]
        mov     rax, r8
        cmp     ecx, edx
        jl      .L4
        jmp     .L3
.L5:
        mov     edx, DWORD PTR [rdi+rax*4]
        cmp     edx, ecx
        jle     .L3
.L4:
        mov     DWORD PTR [rdi+4+rax*4], edx
        sub     rax, 1
        cmp     rax, -1
        jne     .L5
.L3:
        mov     DWORD PTR [rdi+4+rax*4], ecx
        lea     rax, [r8+1]
        cmp     r9, r8
        je      .L1
        mov     r8, rax
        jmp     .L7
.L1:
        ret