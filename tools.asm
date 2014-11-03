BITS 64

SECTION .data

hello: db "Hello world",10
.end:

SECTION .text   

EXTERN  _Z7mallocxm  

GLOBAL  leaf_size
GLOBAL  inner_size
GLOBAL  prologue_size
GLOBAL  epilogue_size
GLOBAL  compile_leaf
GLOBAL  compile_inner
GLOBAL  compile_prologue
GLOBAL  compile_epilogue

prologue:
    mov     r8,rsp
.end:

; rdi - void * memory
compile_prologue:
    mov     rcx, prologue.end - prologue
    mov     rsi, prologue
    rep     movsb
    ret

prologue_size:
    mov     rax,prologue.end - prologue
    ret

apply:
	mov     rax, -1
			.arg0:
	push    rax
	mov     rax, -1
			.arg1:
	push    rax
	ret
.end:

leaf:
    mov     rcx, -1
                .arg0:
    sub     rcx, 1
    mov     rcx,[8*rcx + r8]
    push    rcx
.end:

; rdi - void * memory
; rsi - int n
compile_leaf:
    mov     r11,rdi
    mov     r9, rsi
    mov     rcx, leaf.end - leaf;
    mov     rsi, leaf
    rep     movsb

    mov     [r11 + leaf.arg0-leaf - 8], r9
    ret

leaf_size:
    mov     rax,leaf.end - leaf;
    ret

inner:
    mov     rdi, apply.end-apply
    mov     rcx,_Z7mallocxm
    call    rcx 

    mov     rdi,rax
    mov     rsi,apply
    mov     rcx, apply.end - apply
    
    rep     movsb
    
    pop     rsi 	; x
    pop     rcx 	; y
    mov     [rax+apply.arg0-apply-8], rcx
    mov     [rax+apply.arg1-apply-8], rsi
    push    rax
.end:

compile_inner:
    mov     rcx, inner.end - inner
    mov     rsi, inner
    rep     movsb
    ret

inner_size:
    mov     rax,inner.end - inner
    ret

epilogue:
    pop	    r9
    mov     rax, -1
            .arg0:
    shl     rax, 3
    add     rsp, rax
    push    r9
    ret
.end:

; rdi - void * mem
; rsi - int nargs 
compile_epilogue:
    mov     r11, rdi
    mov     rax, rsi
    mov     rsi, epilogue
    mov     rcx, epilogue.end - epilogue
    
    rep     movsb
    
    mov     [r11+epilogue.arg0-epilogue-8],rax
    ret

epilogue_size:
    mov     rax, epilogue.end - epilogue
    ret
