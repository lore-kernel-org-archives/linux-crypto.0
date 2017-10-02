From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v4 26/27] x86_32: assembly, change all ENTRY+ENDPROC to SYM_FUNC_*
Date: Mon,  2 Oct 2017 11:12:45 +0200
Message-ID: <20171002091246.28432-26-jslaby@suse.cz>
References: <20171002091246.28432-1-jslaby@suse.cz>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bill Metzenthen <billm@melbpc.org.au>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-efi@vger.kernel.org
To: mingo@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002091246.28432-1-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These are all functions which are invoked from elsewhere, so we annotate
them as global using the new SYM_FUNC_START (and their ENDPROC's by
SYM_FUNC_END.)

Now, we can finally force ENTRY/ENDPROC to be undefined on X86.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Bill Metzenthen <billm@melbpc.org.au>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org
Cc: linux-efi@vger.kernel.org
---
 arch/x86/boot/compressed/efi_stub_32.S     |  4 ++--
 arch/x86/boot/compressed/head_32.S         | 12 +++++------
 arch/x86/crypto/salsa20-i586-asm_32.S      | 12 +++++------
 arch/x86/crypto/serpent-sse2-i586-asm_32.S |  8 ++++----
 arch/x86/crypto/twofish-i586-asm_32.S      |  8 ++++----
 arch/x86/entry/entry_32.S                  | 24 +++++++++++-----------
 arch/x86/kernel/head_32.S                  | 16 +++++++--------
 arch/x86/lib/atomic64_386_32.S             |  4 ++--
 arch/x86/lib/atomic64_cx8_32.S             | 32 +++++++++++++++---------------
 arch/x86/lib/checksum_32.S                 |  8 ++++----
 arch/x86/math-emu/div_Xsig.S               |  4 ++--
 arch/x86/math-emu/div_small.S              |  4 ++--
 arch/x86/math-emu/mul_Xsig.S               | 12 +++++------
 arch/x86/math-emu/polynom_Xsig.S           |  4 ++--
 arch/x86/math-emu/reg_norm.S               |  8 ++++----
 arch/x86/math-emu/reg_round.S              |  4 ++--
 arch/x86/math-emu/reg_u_add.S              |  4 ++--
 arch/x86/math-emu/reg_u_div.S              |  4 ++--
 arch/x86/math-emu/reg_u_mul.S              |  4 ++--
 arch/x86/math-emu/reg_u_sub.S              |  4 ++--
 arch/x86/math-emu/round_Xsig.S             |  8 ++++----
 arch/x86/math-emu/shr_Xsig.S               |  4 ++--
 arch/x86/math-emu/wm_shrx.S                |  8 ++++----
 arch/x86/math-emu/wm_sqrt.S                |  4 ++--
 arch/x86/platform/efi/efi_stub_32.S        |  4 ++--
 include/linux/linkage.h                    |  8 +++-----
 26 files changed, 107 insertions(+), 109 deletions(-)

diff --git a/arch/x86/boot/compressed/efi_stub_32.S b/arch/x86/boot/compressed/efi_stub_32.S
index a53440e81d52..4ceff75b0d2a 100644
--- a/arch/x86/boot/compressed/efi_stub_32.S
+++ b/arch/x86/boot/compressed/efi_stub_32.S
@@ -23,7 +23,7 @@
  */
 
 .text
-ENTRY(efi_call_phys)
+SYM_FUNC_START(efi_call_phys)
 	/*
 	 * 0. The function can only be called in Linux kernel. So CS has been
 	 * set to 0x0010, DS and SS have been set to 0x0018. In EFI, I found
@@ -76,7 +76,7 @@ ENTRY(efi_call_phys)
 	movl	saved_return_addr(%edx), %ecx
 	pushl	%ecx
 	ret
-ENDPROC(efi_call_phys)
+SYM_FUNC_END(efi_call_phys)
 .previous
 
 .data
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index d832ddb78ea2..86484c3788f8 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -60,7 +60,7 @@
 	.hidden _egot
 
 	__HEAD
-ENTRY(startup_32)
+SYM_FUNC_START(startup_32)
 	cld
 	/*
 	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -141,14 +141,14 @@ ENTRY(startup_32)
  */
 	leal	relocated(%ebx), %eax
 	jmp	*%eax
-ENDPROC(startup_32)
+SYM_FUNC_END(startup_32)
 
 #ifdef CONFIG_EFI_STUB
 /*
  * We don't need the return address, so set up the stack so efi_main() can find
  * its arguments.
  */
-ENTRY(efi_pe_entry)
+SYM_FUNC_START(efi_pe_entry)
 	add	$0x4, %esp
 
 	call	1f
@@ -173,9 +173,9 @@ ENTRY(efi_pe_entry)
 	pushl	%eax
 	pushl	%ecx
 	jmp	2f		/* Skip efi_config initialization */
-ENDPROC(efi_pe_entry)
+SYM_FUNC_END(efi_pe_entry)
 
-ENTRY(efi32_stub_entry)
+SYM_FUNC_START(efi32_stub_entry)
 	add	$0x4, %esp
 	popl	%ecx
 	popl	%edx
@@ -204,7 +204,7 @@ fail:
 	movl	BP_code32_start(%esi), %eax
 	leal	startup_32(%eax), %eax
 	jmp	*%eax
-ENDPROC(efi32_stub_entry)
+SYM_FUNC_END(efi32_stub_entry)
 #endif
 
 	.text
diff --git a/arch/x86/crypto/salsa20-i586-asm_32.S b/arch/x86/crypto/salsa20-i586-asm_32.S
index 329452b8f794..e9a6703056fc 100644
--- a/arch/x86/crypto/salsa20-i586-asm_32.S
+++ b/arch/x86/crypto/salsa20-i586-asm_32.S
@@ -7,7 +7,7 @@
 .text
 
 # enter salsa20_encrypt_bytes
-ENTRY(salsa20_encrypt_bytes)
+SYM_FUNC_START(salsa20_encrypt_bytes)
 	mov	%esp,%eax
 	and	$31,%eax
 	add	$256,%eax
@@ -934,10 +934,10 @@ ENTRY(salsa20_encrypt_bytes)
 	add	$64,%esi
 	# goto bytesatleast1
 	jmp	._bytesatleast1
-ENDPROC(salsa20_encrypt_bytes)
+SYM_FUNC_END(salsa20_encrypt_bytes)
 
 # enter salsa20_keysetup
-ENTRY(salsa20_keysetup)
+SYM_FUNC_START(salsa20_keysetup)
 	mov	%esp,%eax
 	and	$31,%eax
 	add	$256,%eax
@@ -1060,10 +1060,10 @@ ENTRY(salsa20_keysetup)
 	# leave
 	add	%eax,%esp
 	ret
-ENDPROC(salsa20_keysetup)
+SYM_FUNC_END(salsa20_keysetup)
 
 # enter salsa20_ivsetup
-ENTRY(salsa20_ivsetup)
+SYM_FUNC_START(salsa20_ivsetup)
 	mov	%esp,%eax
 	and	$31,%eax
 	add	$256,%eax
@@ -1111,4 +1111,4 @@ ENTRY(salsa20_ivsetup)
 	# leave
 	add	%eax,%esp
 	ret
-ENDPROC(salsa20_ivsetup)
+SYM_FUNC_END(salsa20_ivsetup)
diff --git a/arch/x86/crypto/serpent-sse2-i586-asm_32.S b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
index d348f1553a79..f3cebd3c6739 100644
--- a/arch/x86/crypto/serpent-sse2-i586-asm_32.S
+++ b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
@@ -512,7 +512,7 @@
 	pxor t0,		x3; \
 	movdqu x3,		(3*4*4)(out);
 
-ENTRY(__serpent_enc_blk_4way)
+SYM_FUNC_START(__serpent_enc_blk_4way)
 	/* input:
 	 *	arg_ctx(%esp): ctx, CTX
 	 *	arg_dst(%esp): dst
@@ -574,9 +574,9 @@ ENTRY(__serpent_enc_blk_4way)
 	xor_blocks(%eax, RA, RB, RC, RD, RT0, RT1, RE);
 
 	ret;
-ENDPROC(__serpent_enc_blk_4way)
+SYM_FUNC_END(__serpent_enc_blk_4way)
 
-ENTRY(serpent_dec_blk_4way)
+SYM_FUNC_START(serpent_dec_blk_4way)
 	/* input:
 	 *	arg_ctx(%esp): ctx, CTX
 	 *	arg_dst(%esp): dst
@@ -628,4 +628,4 @@ ENTRY(serpent_dec_blk_4way)
 	write_blocks(%eax, RC, RD, RB, RE, RT0, RT1, RA);
 
 	ret;
-ENDPROC(serpent_dec_blk_4way)
+SYM_FUNC_END(serpent_dec_blk_4way)
diff --git a/arch/x86/crypto/twofish-i586-asm_32.S b/arch/x86/crypto/twofish-i586-asm_32.S
index 694ea4587ba7..8ecb5234b2b3 100644
--- a/arch/x86/crypto/twofish-i586-asm_32.S
+++ b/arch/x86/crypto/twofish-i586-asm_32.S
@@ -220,7 +220,7 @@
 	xor	%esi,		d ## D;\
 	ror	$1,		d ## D;
 
-ENTRY(twofish_enc_blk)
+SYM_FUNC_START(twofish_enc_blk)
 	push	%ebp			/* save registers according to calling convention*/
 	push    %ebx
 	push    %esi
@@ -274,9 +274,9 @@ ENTRY(twofish_enc_blk)
 	pop	%ebp
 	mov	$1,	%eax
 	ret
-ENDPROC(twofish_enc_blk)
+SYM_FUNC_END(twofish_enc_blk)
 
-ENTRY(twofish_dec_blk)
+SYM_FUNC_START(twofish_dec_blk)
 	push	%ebp			/* save registers according to calling convention*/
 	push    %ebx
 	push    %esi
@@ -331,4 +331,4 @@ ENTRY(twofish_dec_blk)
 	pop	%ebp
 	mov	$1,	%eax
 	ret
-ENDPROC(twofish_dec_blk)
+SYM_FUNC_END(twofish_dec_blk)
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index c587bf34b93a..cd1e87a26875 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -258,7 +258,7 @@ SYM_CODE_END(__switch_to_asm)
  * asmlinkage function so its argument has to be pushed on the stack.  This
  * wrapper creates a proper "end of stack" frame header before the call.
  */
-ENTRY(schedule_tail_wrapper)
+SYM_FUNC_START(schedule_tail_wrapper)
 	FRAME_BEGIN
 
 	pushl	%eax
@@ -267,7 +267,7 @@ ENTRY(schedule_tail_wrapper)
 
 	FRAME_END
 	ret
-ENDPROC(schedule_tail_wrapper)
+SYM_FUNC_END(schedule_tail_wrapper)
 /*
  * A newly forked process directly context switches into this address.
  *
@@ -398,7 +398,7 @@ SYM_CODE_END(xen_sysenter_target)
  * ebp  user stack
  * 0(%ebp) arg6
  */
-ENTRY(entry_SYSENTER_32)
+SYM_FUNC_START(entry_SYSENTER_32)
 	movl	TSS_sysenter_sp0(%esp), %esp
 .Lsysenter_past_esp:
 	pushl	$__USER_DS		/* pt_regs->ss */
@@ -486,7 +486,7 @@ ENTRY(entry_SYSENTER_32)
 	popfl
 	jmp	.Lsysenter_flags_fixed
 SYM_ENTRY(__end_SYSENTER_singlestep_region, SYM_V_GLOBAL, SYM_A_NONE)
-ENDPROC(entry_SYSENTER_32)
+SYM_FUNC_END(entry_SYSENTER_32)
 
 /*
  * 32-bit legacy system call entry.
@@ -516,7 +516,7 @@ ENDPROC(entry_SYSENTER_32)
  * edi  arg5
  * ebp  arg6
  */
-ENTRY(entry_INT80_32)
+SYM_FUNC_START(entry_INT80_32)
 	ASM_CLAC
 	pushl	%eax			/* pt_regs->orig_ax */
 	SAVE_ALL pt_regs_ax=$-ENOSYS	/* save rest */
@@ -595,7 +595,7 @@ SYM_CODE_END(iret_exc)
 	lss	(%esp), %esp			/* switch to espfix segment */
 	jmp	.Lrestore_nocheck
 #endif
-ENDPROC(entry_INT80_32)
+SYM_FUNC_END(entry_INT80_32)
 
 .macro FIXUP_ESPFIX_STACK
 /*
@@ -663,7 +663,7 @@ SYM_CODE_START_LOCAL(common_interrupt)
 SYM_CODE_END(common_interrupt)
 
 #define BUILD_INTERRUPT3(name, nr, fn)	\
-ENTRY(name)				\
+SYM_FUNC_START(name)				\
 	ASM_CLAC;			\
 	pushl	$~(nr);			\
 	SAVE_ALL;			\
@@ -672,7 +672,7 @@ ENTRY(name)				\
 	movl	%esp, %eax;		\
 	call	fn;			\
 	jmp	ret_from_intr;		\
-ENDPROC(name)
+SYM_FUNC_END(name)
 
 #define BUILD_INTERRUPT(name, nr)		\
 	BUILD_INTERRUPT3(name, nr, smp_##name);	\
@@ -791,7 +791,7 @@ SYM_CODE_START(spurious_interrupt_bug)
 SYM_CODE_END(spurious_interrupt_bug)
 
 #ifdef CONFIG_XEN
-ENTRY(xen_hypervisor_callback)
+SYM_FUNC_START(xen_hypervisor_callback)
 	pushl	$-1				/* orig_ax = -1 => not a system call */
 	SAVE_ALL
 	ENCODE_FRAME_POINTER
@@ -819,7 +819,7 @@ SYM_CODE_INNER_LABEL(xen_do_upcall, SYM_V_GLOBAL)
 	call	xen_maybe_preempt_hcall
 #endif
 	jmp	ret_from_intr
-ENDPROC(xen_hypervisor_callback)
+SYM_FUNC_END(xen_hypervisor_callback)
 
 /*
  * Hypervisor uses this for application faults while it executes.
@@ -833,7 +833,7 @@ ENDPROC(xen_hypervisor_callback)
  * to pop the stack frame we end up in an infinite loop of failsafe callbacks.
  * We distinguish between categories by maintaining a status value in EAX.
  */
-ENTRY(xen_failsafe_callback)
+SYM_FUNC_START(xen_failsafe_callback)
 	pushl	%eax
 	movl	$1, %eax
 1:	mov	4(%esp), %ds
@@ -870,7 +870,7 @@ ENTRY(xen_failsafe_callback)
 	_ASM_EXTABLE(2b, 7b)
 	_ASM_EXTABLE(3b, 8b)
 	_ASM_EXTABLE(4b, 9b)
-ENDPROC(xen_failsafe_callback)
+SYM_FUNC_END(xen_failsafe_callback)
 
 BUILD_INTERRUPT3(xen_hvm_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
 		 xen_evtchn_do_upcall)
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 198b848f1874..1a51d2a61495 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -179,12 +179,12 @@ SYM_CODE_END(startup_32)
  * up already except stack. We just set up stack here. Then call
  * start_secondary().
  */
-ENTRY(start_cpu0)
+SYM_FUNC_START(start_cpu0)
 	movl initial_stack, %ecx
 	movl %ecx, %esp
 	call *(initial_code)
 1:	jmp 1b
-ENDPROC(start_cpu0)
+SYM_FUNC_END(start_cpu0)
 #endif
 
 /*
@@ -195,7 +195,7 @@ ENDPROC(start_cpu0)
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
  */
-ENTRY(startup_32_smp)
+SYM_FUNC_START(startup_32_smp)
 	cld
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
@@ -365,7 +365,7 @@ ENTRY(startup_32_smp)
 
 	call *(initial_code)
 1:	jmp 1b
-ENDPROC(startup_32_smp)
+SYM_FUNC_END(startup_32_smp)
 
 #include "verify_cpu.S"
 
@@ -395,7 +395,7 @@ setup_once:
 	andl $0,setup_once_ref	/* Once is enough, thanks */
 	ret
 
-ENTRY(early_idt_handler_array)
+SYM_FUNC_START(early_idt_handler_array)
 	# 36(%esp) %eflags
 	# 32(%esp) %cs
 	# 28(%esp) %eip
@@ -410,7 +410,7 @@ ENTRY(early_idt_handler_array)
 	i = i + 1
 	.fill early_idt_handler_array + i*EARLY_IDT_HANDLER_SIZE - ., 1, 0xcc
 	.endr
-ENDPROC(early_idt_handler_array)
+SYM_FUNC_END(early_idt_handler_array)
 	
 SYM_CODE_START_LOCAL(early_idt_handler_common)
 	/*
@@ -466,7 +466,7 @@ SYM_CODE_START_LOCAL(early_idt_handler_common)
 SYM_CODE_END(early_idt_handler_common)
 
 /* This is the default interrupt "handler" :-) */
-ENTRY(early_ignore_irq)
+SYM_FUNC_START(early_ignore_irq)
 	cld
 #ifdef CONFIG_PRINTK
 	pushl %eax
@@ -501,7 +501,7 @@ ENTRY(early_ignore_irq)
 hlt_loop:
 	hlt
 	jmp hlt_loop
-ENDPROC(early_ignore_irq)
+SYM_FUNC_END(early_ignore_irq)
 
 __INITDATA
 	.align 4
diff --git a/arch/x86/lib/atomic64_386_32.S b/arch/x86/lib/atomic64_386_32.S
index 9b0ca8fe80fc..9ed71edd9dfe 100644
--- a/arch/x86/lib/atomic64_386_32.S
+++ b/arch/x86/lib/atomic64_386_32.S
@@ -24,10 +24,10 @@
 
 #define BEGIN(op) \
 .macro endp; \
-ENDPROC(atomic64_##op##_386); \
+SYM_FUNC_END(atomic64_##op##_386); \
 .purgem endp; \
 .endm; \
-ENTRY(atomic64_##op##_386); \
+SYM_FUNC_START(atomic64_##op##_386); \
 	LOCK v;
 
 #define ENDP endp
diff --git a/arch/x86/lib/atomic64_cx8_32.S b/arch/x86/lib/atomic64_cx8_32.S
index db3ae85440ff..f02f70890121 100644
--- a/arch/x86/lib/atomic64_cx8_32.S
+++ b/arch/x86/lib/atomic64_cx8_32.S
@@ -20,12 +20,12 @@
 	cmpxchg8b (\reg)
 .endm
 
-ENTRY(atomic64_read_cx8)
+SYM_FUNC_START(atomic64_read_cx8)
 	read64 %ecx
 	ret
-ENDPROC(atomic64_read_cx8)
+SYM_FUNC_END(atomic64_read_cx8)
 
-ENTRY(atomic64_set_cx8)
+SYM_FUNC_START(atomic64_set_cx8)
 1:
 /* we don't need LOCK_PREFIX since aligned 64-bit writes
  * are atomic on 586 and newer */
@@ -33,19 +33,19 @@ ENTRY(atomic64_set_cx8)
 	jne 1b
 
 	ret
-ENDPROC(atomic64_set_cx8)
+SYM_FUNC_END(atomic64_set_cx8)
 
-ENTRY(atomic64_xchg_cx8)
+SYM_FUNC_START(atomic64_xchg_cx8)
 1:
 	LOCK_PREFIX
 	cmpxchg8b (%esi)
 	jne 1b
 
 	ret
-ENDPROC(atomic64_xchg_cx8)
+SYM_FUNC_END(atomic64_xchg_cx8)
 
 .macro addsub_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
+SYM_FUNC_START(atomic64_\func\()_return_cx8)
 	pushl %ebp
 	pushl %ebx
 	pushl %esi
@@ -73,14 +73,14 @@ ENTRY(atomic64_\func\()_return_cx8)
 	popl %ebx
 	popl %ebp
 	ret
-ENDPROC(atomic64_\func\()_return_cx8)
+SYM_FUNC_END(atomic64_\func\()_return_cx8)
 .endm
 
 addsub_return add add adc
 addsub_return sub sub sbb
 
 .macro incdec_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
+SYM_FUNC_START(atomic64_\func\()_return_cx8)
 	pushl %ebx
 
 	read64 %esi
@@ -98,13 +98,13 @@ ENTRY(atomic64_\func\()_return_cx8)
 	movl %ecx, %edx
 	popl %ebx
 	ret
-ENDPROC(atomic64_\func\()_return_cx8)
+SYM_FUNC_END(atomic64_\func\()_return_cx8)
 .endm
 
 incdec_return inc add adc
 incdec_return dec sub sbb
 
-ENTRY(atomic64_dec_if_positive_cx8)
+SYM_FUNC_START(atomic64_dec_if_positive_cx8)
 	pushl %ebx
 
 	read64 %esi
@@ -123,9 +123,9 @@ ENTRY(atomic64_dec_if_positive_cx8)
 	movl %ecx, %edx
 	popl %ebx
 	ret
-ENDPROC(atomic64_dec_if_positive_cx8)
+SYM_FUNC_END(atomic64_dec_if_positive_cx8)
 
-ENTRY(atomic64_add_unless_cx8)
+SYM_FUNC_START(atomic64_add_unless_cx8)
 	pushl %ebp
 	pushl %ebx
 /* these just push these two parameters on the stack */
@@ -159,9 +159,9 @@ ENTRY(atomic64_add_unless_cx8)
 	jne 2b
 	xorl %eax, %eax
 	jmp 3b
-ENDPROC(atomic64_add_unless_cx8)
+SYM_FUNC_END(atomic64_add_unless_cx8)
 
-ENTRY(atomic64_inc_not_zero_cx8)
+SYM_FUNC_START(atomic64_inc_not_zero_cx8)
 	pushl %ebx
 
 	read64 %esi
@@ -181,4 +181,4 @@ ENTRY(atomic64_inc_not_zero_cx8)
 3:
 	popl %ebx
 	ret
-ENDPROC(atomic64_inc_not_zero_cx8)
+SYM_FUNC_END(atomic64_inc_not_zero_cx8)
diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index a048436ce3ac..78523e028d88 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -49,7 +49,7 @@ unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
 	   * Fortunately, it is easy to convert 2-byte alignment to 4-byte
 	   * alignment for the unrolled loop.
 	   */		
-ENTRY(csum_partial)
+SYM_FUNC_START(csum_partial)
 	pushl %esi
 	pushl %ebx
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
@@ -131,13 +131,13 @@ ENTRY(csum_partial)
 	popl %ebx
 	popl %esi
 	ret
-ENDPROC(csum_partial)
+SYM_FUNC_END(csum_partial)
 
 #else
 
 /* Version for PentiumII/PPro */
 
-ENTRY(csum_partial)
+SYM_FUNC_START(csum_partial)
 	pushl %esi
 	pushl %ebx
 	movl 20(%esp),%eax	# Function arg: unsigned int sum
@@ -249,7 +249,7 @@ ENTRY(csum_partial)
 	popl %ebx
 	popl %esi
 	ret
-ENDPROC(csum_partial)
+SYM_FUNC_END(csum_partial)
 				
 #endif
 EXPORT_SYMBOL(csum_partial)
diff --git a/arch/x86/math-emu/div_Xsig.S b/arch/x86/math-emu/div_Xsig.S
index 066996dba6a2..8f2fadf8aed7 100644
--- a/arch/x86/math-emu/div_Xsig.S
+++ b/arch/x86/math-emu/div_Xsig.S
@@ -74,7 +74,7 @@ FPU_result_1:
 
 
 .text
-ENTRY(div_Xsig)
+SYM_FUNC_START(div_Xsig)
 	pushl	%ebp
 	movl	%esp,%ebp
 #ifndef NON_REENTRANT_FPU
@@ -363,4 +363,4 @@ L_bugged_2:
 	pop	%ebx
 	jmp	L_exit
 #endif /* PARANOID */ 
-ENDPROC(div_Xsig)
+SYM_FUNC_END(div_Xsig)
diff --git a/arch/x86/math-emu/div_small.S b/arch/x86/math-emu/div_small.S
index 2c71527bd917..15241e5a7e50 100644
--- a/arch/x86/math-emu/div_small.S
+++ b/arch/x86/math-emu/div_small.S
@@ -18,7 +18,7 @@
 #include "fpu_emu.h"
 
 .text
-ENTRY(FPU_div_small)
+SYM_FUNC_START(FPU_div_small)
 	pushl	%ebp
 	movl	%esp,%ebp
 
@@ -44,4 +44,4 @@ ENTRY(FPU_div_small)
 
 	leave
 	ret
-ENDPROC(FPU_div_small)
+SYM_FUNC_END(FPU_div_small)
diff --git a/arch/x86/math-emu/mul_Xsig.S b/arch/x86/math-emu/mul_Xsig.S
index 22e0631bb85a..eb59220280c3 100644
--- a/arch/x86/math-emu/mul_Xsig.S
+++ b/arch/x86/math-emu/mul_Xsig.S
@@ -24,7 +24,7 @@
 #include "fpu_emu.h"
 
 .text
-ENTRY(mul32_Xsig)
+SYM_FUNC_START(mul32_Xsig)
 	pushl %ebp
 	movl %esp,%ebp
 	subl $16,%esp
@@ -62,10 +62,10 @@ ENTRY(mul32_Xsig)
 	popl %esi
 	leave
 	ret
-ENDPROC(mul32_Xsig)
+SYM_FUNC_END(mul32_Xsig)
 
 
-ENTRY(mul64_Xsig)
+SYM_FUNC_START(mul64_Xsig)
 	pushl %ebp
 	movl %esp,%ebp
 	subl $16,%esp
@@ -115,11 +115,11 @@ ENTRY(mul64_Xsig)
 	popl %esi
 	leave
 	ret
-ENDPROC(mul64_Xsig)
+SYM_FUNC_END(mul64_Xsig)
 
 
 
-ENTRY(mul_Xsig_Xsig)
+SYM_FUNC_START(mul_Xsig_Xsig)
 	pushl %ebp
 	movl %esp,%ebp
 	subl $16,%esp
@@ -175,4 +175,4 @@ ENTRY(mul_Xsig_Xsig)
 	popl %esi
 	leave
 	ret
-ENDPROC(mul_Xsig_Xsig)
+SYM_FUNC_END(mul_Xsig_Xsig)
diff --git a/arch/x86/math-emu/polynom_Xsig.S b/arch/x86/math-emu/polynom_Xsig.S
index a9aaf414135d..fe98ab9acfa6 100644
--- a/arch/x86/math-emu/polynom_Xsig.S
+++ b/arch/x86/math-emu/polynom_Xsig.S
@@ -36,7 +36,7 @@
 #define OVERFLOWED      -16(%ebp)	/* addition overflow flag */
 
 .text
-ENTRY(polynomial_Xsig)
+SYM_FUNC_START(polynomial_Xsig)
 	pushl	%ebp
 	movl	%esp,%ebp
 	subl	$32,%esp
@@ -133,4 +133,4 @@ L_accum_done:
 	popl	%esi
 	leave
 	ret
-ENDPROC(polynomial_Xsig)
+SYM_FUNC_END(polynomial_Xsig)
diff --git a/arch/x86/math-emu/reg_norm.S b/arch/x86/math-emu/reg_norm.S
index 53ac1a343c69..4d71b607f007 100644
--- a/arch/x86/math-emu/reg_norm.S
+++ b/arch/x86/math-emu/reg_norm.S
@@ -21,7 +21,7 @@
 
 
 .text
-ENTRY(FPU_normalize)
+SYM_FUNC_START(FPU_normalize)
 	pushl	%ebp
 	movl	%esp,%ebp
 	pushl	%ebx
@@ -94,12 +94,12 @@ L_overflow:
 	call	arith_overflow
 	pop	%ebx
 	jmp	L_exit
-ENDPROC(FPU_normalize)
+SYM_FUNC_END(FPU_normalize)
 
 
 
 /* Normalise without reporting underflow or overflow */
-ENTRY(FPU_normalize_nuo)
+SYM_FUNC_START(FPU_normalize_nuo)
 	pushl	%ebp
 	movl	%esp,%ebp
 	pushl	%ebx
@@ -146,4 +146,4 @@ L_exit_nuo_zero:
 	popl	%ebx
 	leave
 	ret
-ENDPROC(FPU_normalize_nuo)
+SYM_FUNC_END(FPU_normalize_nuo)
diff --git a/arch/x86/math-emu/reg_round.S b/arch/x86/math-emu/reg_round.S
index 41af5b208d88..4ef24a419bc7 100644
--- a/arch/x86/math-emu/reg_round.S
+++ b/arch/x86/math-emu/reg_round.S
@@ -108,7 +108,7 @@ FPU_denormal:
 .globl fpu_Arith_exit
 
 /* Entry point when called from C */
-ENTRY(FPU_round)
+SYM_FUNC_START(FPU_round)
 	pushl	%ebp
 	movl	%esp,%ebp
 	pushl	%esi
@@ -707,4 +707,4 @@ L_exception_exit:
 	jmp	fpu_reg_round_special_exit
 #endif /* PARANOID */ 
 
-ENDPROC(FPU_round)
+SYM_FUNC_END(FPU_round)
diff --git a/arch/x86/math-emu/reg_u_add.S b/arch/x86/math-emu/reg_u_add.S
index 3b1bc5e9b2f6..9b21cbac6aa1 100644
--- a/arch/x86/math-emu/reg_u_add.S
+++ b/arch/x86/math-emu/reg_u_add.S
@@ -31,7 +31,7 @@
 #include "control_w.h"
 
 .text
-ENTRY(FPU_u_add)
+SYM_FUNC_START(FPU_u_add)
 	pushl	%ebp
 	movl	%esp,%ebp
 	pushl	%esi
@@ -165,4 +165,4 @@ L_exit:
 	leave
 	ret
 #endif /* PARANOID */
-ENDPROC(FPU_u_add)
+SYM_FUNC_END(FPU_u_add)
diff --git a/arch/x86/math-emu/reg_u_div.S b/arch/x86/math-emu/reg_u_div.S
index 796eb5ab921b..cb7c73807de9 100644
--- a/arch/x86/math-emu/reg_u_div.S
+++ b/arch/x86/math-emu/reg_u_div.S
@@ -74,7 +74,7 @@ FPU_ovfl_flag:
 #define DEST	PARAM3
 
 .text
-ENTRY(FPU_u_div)
+SYM_FUNC_START(FPU_u_div)
 	pushl	%ebp
 	movl	%esp,%ebp
 #ifndef NON_REENTRANT_FPU
@@ -470,4 +470,4 @@ L_exit:
 	ret
 #endif /* PARANOID */ 
 
-ENDPROC(FPU_u_div)
+SYM_FUNC_END(FPU_u_div)
diff --git a/arch/x86/math-emu/reg_u_mul.S b/arch/x86/math-emu/reg_u_mul.S
index 6196f68cf3c1..f36d62346785 100644
--- a/arch/x86/math-emu/reg_u_mul.S
+++ b/arch/x86/math-emu/reg_u_mul.S
@@ -44,7 +44,7 @@ FPU_accum_1:
 
 
 .text
-ENTRY(FPU_u_mul)
+SYM_FUNC_START(FPU_u_mul)
 	pushl	%ebp
 	movl	%esp,%ebp
 #ifndef NON_REENTRANT_FPU
@@ -146,4 +146,4 @@ L_exit:
 	ret
 #endif /* PARANOID */ 
 
-ENDPROC(FPU_u_mul)
+SYM_FUNC_END(FPU_u_mul)
diff --git a/arch/x86/math-emu/reg_u_sub.S b/arch/x86/math-emu/reg_u_sub.S
index d115b900919a..87c39c480701 100644
--- a/arch/x86/math-emu/reg_u_sub.S
+++ b/arch/x86/math-emu/reg_u_sub.S
@@ -32,7 +32,7 @@
 #include "control_w.h"
 
 .text
-ENTRY(FPU_u_sub)
+SYM_FUNC_START(FPU_u_sub)
 	pushl	%ebp
 	movl	%esp,%ebp
 	pushl	%esi
@@ -270,4 +270,4 @@ L_exit:
 	popl	%esi
 	leave
 	ret
-ENDPROC(FPU_u_sub)
+SYM_FUNC_END(FPU_u_sub)
diff --git a/arch/x86/math-emu/round_Xsig.S b/arch/x86/math-emu/round_Xsig.S
index 87c99749a495..42d4261d258d 100644
--- a/arch/x86/math-emu/round_Xsig.S
+++ b/arch/x86/math-emu/round_Xsig.S
@@ -22,7 +22,7 @@
 
 
 .text
-ENTRY(round_Xsig)
+SYM_FUNC_START(round_Xsig)
 	pushl	%ebp
 	movl	%esp,%ebp
 	pushl	%ebx		/* Reserve some space */
@@ -78,11 +78,11 @@ L_exit:
 	popl	%ebx
 	leave
 	ret
-ENDPROC(round_Xsig)
+SYM_FUNC_END(round_Xsig)
 
 
 
-ENTRY(norm_Xsig)
+SYM_FUNC_START(norm_Xsig)
 	pushl	%ebp
 	movl	%esp,%ebp
 	pushl	%ebx		/* Reserve some space */
@@ -138,4 +138,4 @@ L_n_exit:
 	popl	%ebx
 	leave
 	ret
-ENDPROC(norm_Xsig)
+SYM_FUNC_END(norm_Xsig)
diff --git a/arch/x86/math-emu/shr_Xsig.S b/arch/x86/math-emu/shr_Xsig.S
index c8552edeec75..ea50aa16add8 100644
--- a/arch/x86/math-emu/shr_Xsig.S
+++ b/arch/x86/math-emu/shr_Xsig.S
@@ -21,7 +21,7 @@
 #include "fpu_emu.h"
 
 .text
-ENTRY(shr_Xsig)
+SYM_FUNC_START(shr_Xsig)
 	push	%ebp
 	movl	%esp,%ebp
 	pushl	%esi
@@ -85,4 +85,4 @@ L_more_than_95:
 	popl	%esi
 	leave
 	ret
-ENDPROC(shr_Xsig)
+SYM_FUNC_END(shr_Xsig)
diff --git a/arch/x86/math-emu/wm_shrx.S b/arch/x86/math-emu/wm_shrx.S
index 340dd6897f85..1c10e993094d 100644
--- a/arch/x86/math-emu/wm_shrx.S
+++ b/arch/x86/math-emu/wm_shrx.S
@@ -32,7 +32,7 @@
  |   Results returned in the 64 bit arg and eax.                             |
  +---------------------------------------------------------------------------*/
 
-ENTRY(FPU_shrx)
+SYM_FUNC_START(FPU_shrx)
 	push	%ebp
 	movl	%esp,%ebp
 	pushl	%esi
@@ -92,7 +92,7 @@ L_more_than_95:
 	popl	%esi
 	leave
 	ret
-ENDPROC(FPU_shrx)
+SYM_FUNC_END(FPU_shrx)
 
 
 /*---------------------------------------------------------------------------+
@@ -111,7 +111,7 @@ ENDPROC(FPU_shrx)
  |   part which has been shifted out of the arg.                             |
  |   Results returned in the 64 bit arg and eax.                             |
  +---------------------------------------------------------------------------*/
-ENTRY(FPU_shrxs)
+SYM_FUNC_START(FPU_shrxs)
 	push	%ebp
 	movl	%esp,%ebp
 	pushl	%esi
@@ -203,4 +203,4 @@ Ls_more_than_95:
 	popl	%esi
 	leave
 	ret
-ENDPROC(FPU_shrxs)
+SYM_FUNC_END(FPU_shrxs)
diff --git a/arch/x86/math-emu/wm_sqrt.S b/arch/x86/math-emu/wm_sqrt.S
index 695afae38fdf..f5ac01472ee3 100644
--- a/arch/x86/math-emu/wm_sqrt.S
+++ b/arch/x86/math-emu/wm_sqrt.S
@@ -74,7 +74,7 @@ FPU_fsqrt_arg_0:
 
 
 .text
-ENTRY(wm_sqrt)
+SYM_FUNC_START(wm_sqrt)
 	pushl	%ebp
 	movl	%esp,%ebp
 #ifndef NON_REENTRANT_FPU
@@ -468,4 +468,4 @@ sqrt_more_prec_large:
 /* Our estimate is too large */
 	movl	$0x7fffff00,%eax
 	jmp	sqrt_round_result
-ENDPROC(wm_sqrt)
+SYM_FUNC_END(wm_sqrt)
diff --git a/arch/x86/platform/efi/efi_stub_32.S b/arch/x86/platform/efi/efi_stub_32.S
index 040192b50d02..9661a191138f 100644
--- a/arch/x86/platform/efi/efi_stub_32.S
+++ b/arch/x86/platform/efi/efi_stub_32.S
@@ -21,7 +21,7 @@
  */
 
 .text
-ENTRY(efi_call_phys)
+SYM_FUNC_START(efi_call_phys)
 	/*
 	 * 0. The function can only be called in Linux kernel. So CS has been
 	 * set to 0x0010, DS and SS have been set to 0x0018. In EFI, I found
@@ -113,7 +113,7 @@ ENTRY(efi_call_phys)
 	movl	(%edx), %ecx
 	pushl	%ecx
 	ret
-ENDPROC(efi_call_phys)
+SYM_FUNC_END(efi_call_phys)
 .previous
 
 .data
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 42762a45aab5..a88f332136b4 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -104,13 +104,13 @@
 
 /* === DEPRECATED annotations === */
 
-#ifndef CONFIG_X86_64
+#ifndef CONFIG_X86
 #ifndef ENTRY
 /* deprecated, use SYM_FUNC_START */
 #define ENTRY(name) \
 	SYM_FUNC_START(name)
 #endif
-#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_X86 */
 #endif /* LINKER_SCRIPT */
 
 #ifndef WEAK
@@ -125,9 +125,7 @@
 #define END(name) \
 	.size name, .-name
 #endif
-#endif /* CONFIG_X86 */
 
-#ifndef CONFIG_X86_64
 /* If symbol 'name' is treated as a subroutine (gets called, and returns)
  * then please use ENDPROC to mark 'name' as STT_FUNC for the benefit of
  * static analysis tools such as stack depth analyzer.
@@ -137,7 +135,7 @@
 #define ENDPROC(name) \
 	SYM_FUNC_END(name)
 #endif
-#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_X86 */
 
 /* === generic annotations === */
 
-- 
2.14.2
