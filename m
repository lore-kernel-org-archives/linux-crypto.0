From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Tue, 10 Jan 2017 17:30:48 +0000
Message-ID: <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170110143340.GA3787@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10 January 2017 at 14:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> I recently applied the patch
>
>         https://patchwork.kernel.org/patch/9468391/
>
> and ended up with a boot crash when it tried to run the x86 chacha20
> code.  It turned out that the patch changed a manually aligned
> stack buffer to one that is aligned by gcc.  What was happening was
> that gcc can stack align to any value on x86-64 except 16.  The
> reason is that gcc assumes that the stack is always 16-byte aligned,
> which is not actually the case in the kernel.
>

Apologies for introducing this breakage. It seemed like an obvious and
simple cleanup, so I didn't even bother to mention it in the commit
log, but if the kernel does not guarantee 16 byte alignment, I guess
we should revert to the old method. If SSE instructions are the only
ones that require this alignment, then I suppose not having a ABI
conforming stack pointer should not be an issue in general.

> The x86-64 CPU actually tries to keep the stack 16-byte aligned,
> e.g., it'll do so when an IRQ comes in.  So the reason it doesn't
> work in the kernel mostly comes down to the fact that the struct
> pt_regs which lives near the top of the stack is 168 bytes which
> is not a multiple of 16.
>
> This patch tries to fix this by adding an 8-byte padding at the
> top of the call-chain involving pt_regs so that when we call a C
> function later we do so with an aligned stack.
>
> The same problem probably exists on i386 too since gcc also assumes
> 16-byte alignment there.  It's harder to fix however as the CPU
> doesn't help us in the IRQ case.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
> index 05ed3d3..29d3bcb 100644
> --- a/arch/x86/entry/calling.h
> +++ b/arch/x86/entry/calling.h
> @@ -59,39 +59,42 @@
>  /*
>   * C ABI says these regs are callee-preserved. They aren't saved on kernel entry
>   * unless syscall needs a complete, fully filled "struct pt_regs".
> + *
> + * Note we add 8 extra bytes at the beginning to preserve stack alignment.
>   */
> -#define R15            0*8
> -#define R14            1*8
> -#define R13            2*8
> -#define R12            3*8
> -#define RBP            4*8
> -#define RBX            5*8
> +#define R15            1*8
> +#define R14            2*8
> +#define R13            3*8
> +#define R12            4*8
> +#define RBP            5*8
> +#define RBX            6*8
>  /* These regs are callee-clobbered. Always saved on kernel entry. */
> -#define R11            6*8
> -#define R10            7*8
> -#define R9             8*8
> -#define R8             9*8
> -#define RAX            10*8
> -#define RCX            11*8
> -#define RDX            12*8
> -#define RSI            13*8
> -#define RDI            14*8
> +#define R11            7*8
> +#define R10            8*8
> +#define R9             9*8
> +#define R8             10*8
> +#define RAX            11*8
> +#define RCX            12*8
> +#define RDX            13*8
> +#define RSI            14*8
> +#define RDI            15*8
>  /*
>   * On syscall entry, this is syscall#. On CPU exception, this is error code.
>   * On hw interrupt, it's IRQ number:
>   */
> -#define ORIG_RAX       15*8
> +#define ORIG_RAX       16*8
>  /* Return frame for iretq */
> -#define RIP            16*8
> -#define CS             17*8
> -#define EFLAGS         18*8
> -#define RSP            19*8
> -#define SS             20*8
> +#define RIP            17*8
> +#define CS             18*8
> +#define EFLAGS         19*8
> +#define RSP            20*8
> +#define SS             21*8
>
> +/* Note that this excludes the 8-byte padding. */
>  #define SIZEOF_PTREGS  21*8
>
>         .macro ALLOC_PT_GPREGS_ON_STACK
> -       addq    $-(15*8), %rsp
> +       addq    $-(16*8), %rsp
>         .endm
>
>         .macro SAVE_C_REGS_HELPER offset=0 rax=1 rcx=1 r8910=1 r11=1
> @@ -114,7 +117,7 @@
>         movq %rdi, 14*8+\offset(%rsp)
>         .endm
>         .macro SAVE_C_REGS offset=0
> -       SAVE_C_REGS_HELPER \offset, 1, 1, 1, 1
> +       SAVE_C_REGS_HELPER 8+\offset, 1, 1, 1, 1
>         .endm
>         .macro SAVE_C_REGS_EXCEPT_RAX_RCX offset=0
>         SAVE_C_REGS_HELPER \offset, 0, 0, 1, 1
> @@ -130,43 +133,43 @@
>         .endm
>
>         .macro SAVE_EXTRA_REGS offset=0
> -       movq %r15, 0*8+\offset(%rsp)
> -       movq %r14, 1*8+\offset(%rsp)
> -       movq %r13, 2*8+\offset(%rsp)
> -       movq %r12, 3*8+\offset(%rsp)
> -       movq %rbp, 4*8+\offset(%rsp)
> -       movq %rbx, 5*8+\offset(%rsp)
> +       movq %r15, 1*8+\offset(%rsp)
> +       movq %r14, 2*8+\offset(%rsp)
> +       movq %r13, 3*8+\offset(%rsp)
> +       movq %r12, 4*8+\offset(%rsp)
> +       movq %rbp, 5*8+\offset(%rsp)
> +       movq %rbx, 6*8+\offset(%rsp)
>         .endm
>
>         .macro RESTORE_EXTRA_REGS offset=0
> -       movq 0*8+\offset(%rsp), %r15
> -       movq 1*8+\offset(%rsp), %r14
> -       movq 2*8+\offset(%rsp), %r13
> -       movq 3*8+\offset(%rsp), %r12
> -       movq 4*8+\offset(%rsp), %rbp
> -       movq 5*8+\offset(%rsp), %rbx
> +       movq 1*8+\offset(%rsp), %r15
> +       movq 2*8+\offset(%rsp), %r14
> +       movq 3*8+\offset(%rsp), %r13
> +       movq 4*8+\offset(%rsp), %r12
> +       movq 5*8+\offset(%rsp), %rbp
> +       movq 6*8+\offset(%rsp), %rbx
>         .endm
>
>         .macro RESTORE_C_REGS_HELPER rstor_rax=1, rstor_rcx=1, rstor_r11=1, rstor_r8910=1, rstor_rdx=1
>         .if \rstor_r11
> -       movq 6*8(%rsp), %r11
> +       movq 7*8(%rsp), %r11
>         .endif
>         .if \rstor_r8910
> -       movq 7*8(%rsp), %r10
> -       movq 8*8(%rsp), %r9
> -       movq 9*8(%rsp), %r8
> +       movq 8*8(%rsp), %r10
> +       movq 9*8(%rsp), %r9
> +       movq 10*8(%rsp), %r8
>         .endif
>         .if \rstor_rax
> -       movq 10*8(%rsp), %rax
> +       movq 11*8(%rsp), %rax
>         .endif
>         .if \rstor_rcx
> -       movq 11*8(%rsp), %rcx
> +       movq 12*8(%rsp), %rcx
>         .endif
>         .if \rstor_rdx
> -       movq 12*8(%rsp), %rdx
> +       movq 13*8(%rsp), %rdx
>         .endif
> -       movq 13*8(%rsp), %rsi
> -       movq 14*8(%rsp), %rdi
> +       movq 14*8(%rsp), %rsi
> +       movq 15*8(%rsp), %rdi
>         .endm
>         .macro RESTORE_C_REGS
>         RESTORE_C_REGS_HELPER 1,1,1,1,1
> @@ -185,7 +188,7 @@
>         .endm
>
>         .macro REMOVE_PT_GPREGS_FROM_STACK addskip=0
> -       subq $-(15*8+\addskip), %rsp
> +       subq $-(16*8+\addskip), %rsp
>         .endm
>
>         .macro icebp
> @@ -203,11 +206,7 @@
>   */
>  .macro ENCODE_FRAME_POINTER ptregs_offset=0
>  #ifdef CONFIG_FRAME_POINTER
> -       .if \ptregs_offset
> -               leaq \ptregs_offset(%rsp), %rbp
> -       .else
> -               mov %rsp, %rbp
> -       .endif
> +       leaq    8+\ptregs_offset(%rsp), %rbp
>         orq     $0x1, %rbp
>  #endif
>  .endm
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 5b21970..880bbb8 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -168,7 +168,7 @@ GLOBAL(entry_SYSCALL_64_after_swapgs)
>         pushq   %r9                             /* pt_regs->r9 */
>         pushq   %r10                            /* pt_regs->r10 */
>         pushq   %r11                            /* pt_regs->r11 */
> -       sub     $(6*8), %rsp                    /* pt_regs->bp, bx, r12-15 not saved */
> +       sub     $(7*8), %rsp                    /* pt_regs->bp, bx, r12-15 not saved */
>
>         /*
>          * If we need to do entry work or if we guess we'll need to do
> @@ -234,14 +234,14 @@ entry_SYSCALL_64_fastpath:
>         TRACE_IRQS_ON
>         ENABLE_INTERRUPTS(CLBR_NONE)
>         SAVE_EXTRA_REGS
> -       movq    %rsp, %rdi
> +       leaq    8(%rsp), %rdi
>         call    syscall_return_slowpath /* returns with IRQs disabled */
>         jmp     return_from_SYSCALL_64
>
>  entry_SYSCALL64_slow_path:
>         /* IRQs are off. */
>         SAVE_EXTRA_REGS
> -       movq    %rsp, %rdi
> +       leaq    8(%rsp), %rdi
>         call    do_syscall_64           /* returns with IRQs disabled */
>
>  return_from_SYSCALL_64:
> @@ -342,9 +342,9 @@ ENTRY(stub_ptregs_64)
>          * Called from fast path -- disable IRQs again, pop return address
>          * and jump to slow path
>          */
> +       popq    %rax
>         DISABLE_INTERRUPTS(CLBR_NONE)
>         TRACE_IRQS_OFF
> -       popq    %rax
>         jmp     entry_SYSCALL64_slow_path
>
>  1:
> @@ -409,13 +409,14 @@ END(__switch_to_asm)
>   */
>  ENTRY(ret_from_fork)
>         movq    %rax, %rdi
> +       subq    $8, %rsp
>         call    schedule_tail                   /* rdi: 'prev' task parameter */
>
>         testq   %rbx, %rbx                      /* from kernel_thread? */
>         jnz     1f                              /* kernel threads are uncommon */
>
>  2:
> -       movq    %rsp, %rdi
> +       leaq    8(%rsp), %rdi
>         call    syscall_return_slowpath /* returns with IRQs disabled */
>         TRACE_IRQS_ON                   /* user mode is traced as IRQS on */
>         SWAPGS
> @@ -494,10 +495,12 @@ END(irq_entries_start)
>          * a little cheaper to use a separate counter in the PDA (short of
>          * moving irq_enter into assembly, which would be too much work)
>          */
> -       movq    %rsp, %rdi
> +       movq    %rsp, %rax
> +       leaq    8(%rsp), %rdi
>         incl    PER_CPU_VAR(irq_count)
>         cmovzq  PER_CPU_VAR(irq_stack_ptr), %rsp
> -       pushq   %rdi
> +       sub     $8, %rsp
> +       pushq   %rax
>         /* We entered an interrupt context - irqs are off: */
>         TRACE_IRQS_OFF
>
> @@ -527,7 +530,7 @@ ret_from_intr:
>
>         /* Interrupt came from user space */
>  GLOBAL(retint_user)
> -       mov     %rsp,%rdi
> +       leaq    8(%rsp), %rdi
>         call    prepare_exit_to_usermode
>         TRACE_IRQS_IRETQ
>         SWAPGS
> @@ -774,7 +777,7 @@ ENTRY(\sym)
>         .endif
>         .endif
>
> -       movq    %rsp, %rdi                      /* pt_regs pointer */
> +       leaq    8(%rsp), %rdi                   /* pt_regs pointer */
>
>         .if \has_error_code
>         movq    ORIG_RAX(%rsp), %rsi            /* get error code */
> @@ -810,11 +813,11 @@ ENTRY(\sym)
>         call    error_entry
>
>
> -       movq    %rsp, %rdi                      /* pt_regs pointer */
> +       leaq    8(%rsp), %rdi                   /* pt_regs pointer */
>         call    sync_regs
> -       movq    %rax, %rsp                      /* switch stack */
> +       leaq    -8(%rax), %rsp                  /* switch stack */
>
> -       movq    %rsp, %rdi                      /* pt_regs pointer */
> +       movq    %rax, %rdi                      /* pt_regs pointer */
>
>         .if \has_error_code
>         movq    ORIG_RAX(%rsp), %rsi            /* get error code */
> @@ -895,6 +898,7 @@ ENTRY(do_softirq_own_stack)
>         mov     %rsp, %rbp
>         incl    PER_CPU_VAR(irq_count)
>         cmove   PER_CPU_VAR(irq_stack_ptr), %rsp
> +       sub     $8, %rsp
>         push    %rbp                            /* frame pointer backlink */
>         call    __do_softirq
>         leaveq
> @@ -924,10 +928,11 @@ ENTRY(xen_do_hypervisor_callback)         /* do_hypervisor_callback(struct *pt_regs) */
>   * Since we don't modify %rdi, evtchn_do_upall(struct *pt_regs) will
>   * see the correct pointer to the pt_regs
>   */
> -       movq    %rdi, %rsp                      /* we don't return, adjust the stack frame */
> +       leaq    -8(%rdi), %rsp                  /* we don't return, adjust the stack frame */
>  11:    incl    PER_CPU_VAR(irq_count)
>         movq    %rsp, %rbp
>         cmovzq  PER_CPU_VAR(irq_stack_ptr), %rsp
> +       subq    $8, %rsp
>         pushq   %rbp                            /* frame pointer backlink */
>         call    xen_evtchn_do_upcall
>         popq    %rsp
> @@ -1264,6 +1269,7 @@ ENTRY(nmi)
>          */
>
>         movq    %rsp, %rdi
> +       subq    $8, %rsp
>         movq    $-1, %rsi
>         call    do_nmi
>
> @@ -1475,7 +1481,7 @@ end_repeat_nmi:
>         call    paranoid_entry
>
>         /* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
> -       movq    %rsp, %rdi
> +       leaq    8(%rsp), %rdi
>         movq    $-1, %rsi
>         call    do_nmi
>
> @@ -1519,7 +1525,7 @@ ENTRY(rewind_stack_do_exit)
>         xorl    %ebp, %ebp
>
>         movq    PER_CPU_VAR(cpu_current_top_of_stack), %rax
> -       leaq    -TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE(%rax), %rsp
> +       leaq    -TOP_OF_KERNEL_STACK_PADDING-PTREGS_SIZE-8(%rax), %rsp
>
>         call    do_exit
>  1:     jmp 1b
> diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
> index e1721da..7d3f1e3 100644
> --- a/arch/x86/entry/entry_64_compat.S
> +++ b/arch/x86/entry/entry_64_compat.S
> @@ -89,6 +89,8 @@ ENTRY(entry_SYSENTER_compat)
>         pushq   $0                      /* pt_regs->r13 = 0 */
>         pushq   $0                      /* pt_regs->r14 = 0 */
>         pushq   $0                      /* pt_regs->r15 = 0 */
> +
> +       subq    $8, %rsp
>         cld
>
>         /*
> @@ -120,7 +122,7 @@ ENTRY(entry_SYSENTER_compat)
>          */
>         TRACE_IRQS_OFF
>
> -       movq    %rsp, %rdi
> +       leaq    8(%rsp), %rdi
>         call    do_fast_syscall_32
>         /* XEN PV guests always use IRET path */
>         ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
> @@ -215,13 +217,15 @@ ENTRY(entry_SYSCALL_compat)
>         pushq   $0                      /* pt_regs->r14 = 0 */
>         pushq   $0                      /* pt_regs->r15 = 0 */
>
> +       subq    $8, %rsp
> +
>         /*
>          * User mode is traced as though IRQs are on, and SYSENTER
>          * turned them off.
>          */
>         TRACE_IRQS_OFF
>
> -       movq    %rsp, %rdi
> +       leaq    8(%rsp), %rdi
>         call    do_fast_syscall_32
>         /* XEN PV guests always use IRET path */
>         ALTERNATIVE "testl %eax, %eax; jz .Lsyscall_32_done", \
> @@ -324,6 +328,8 @@ ENTRY(entry_INT80_compat)
>         pushq   %r13                    /* pt_regs->r13 */
>         pushq   %r14                    /* pt_regs->r14 */
>         pushq   %r15                    /* pt_regs->r15 */
> +
> +       subq    $8, %rsp
>         cld
>
>         /*
> @@ -332,7 +338,7 @@ ENTRY(entry_INT80_compat)
>          */
>         TRACE_IRQS_OFF
>
> -       movq    %rsp, %rdi
> +       leaq    8(%rsp), %rdi
>         call    do_int80_syscall_32
>  .Lsyscall_32_done:
>
> diff --git a/arch/x86/entry/thunk_64.S b/arch/x86/entry/thunk_64.S
> index be36bf4..3c80aac 100644
> --- a/arch/x86/entry/thunk_64.S
> +++ b/arch/x86/entry/thunk_64.S
> @@ -33,6 +33,7 @@
>         movq 8(%rbp), %rdi
>         .endif
>
> +       sub $8, %rsp
>         call \func
>         jmp  .L_restore
>         _ASM_NOKPROBE(\name)
> @@ -58,6 +59,7 @@
>   || defined(CONFIG_DEBUG_LOCK_ALLOC) \
>   || defined(CONFIG_PREEMPT)
>  .L_restore:
> +       add $8, %rsp
>         popq %r11
>         popq %r10
>         popq %r9
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index b467b14..d03ab72 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -384,6 +384,8 @@ early_idt_handler_common:
>         pushq %r14                              /* pt_regs->r14 */
>         pushq %r15                              /* pt_regs->r15 */
>
> +       sub $8, %rsp
> +
>         cmpq $14,%rsi           /* Page fault? */
>         jnz 10f
>         GET_CR2_INTO(%rdi)      /* Can clobber any volatile register if pv */
> @@ -392,7 +394,7 @@ early_idt_handler_common:
>         jz 20f                  /* All good */
>
>  10:
> -       movq %rsp,%rdi          /* RDI = pt_regs; RSI is already trapnr */
> +       leaq 8(%rsp), %rdi      /* RDI = pt_regs; RSI is already trapnr */
>         call early_fixup_exception
>
>  20:
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index bf0c6d0..2af9f81 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -590,6 +590,7 @@ asmlinkage __visible notrace struct pt_regs *sync_regs(struct pt_regs *eregs)
>
>  struct bad_iret_stack {
>         void *error_entry_ret;
> +       void *padding;
>         struct pt_regs regs;
>  };
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
