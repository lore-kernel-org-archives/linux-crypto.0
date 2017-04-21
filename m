From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v3 27/29] x86_32: assembly, change all ENTRY to SYM_FUNC_START
Date: Fri, 21 Apr 2017 16:13:03 +0200
Message-ID: <20170421141305.25180-27-jslaby@suse.cz>
References: <20170421141305.25180-1-jslaby@suse.cz>
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>,
        Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>,
        Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
        Bill Metzenthen <billm-GyIjJ2z7gDS3Zbb/xt2tYQ@public.gmane.org>,
        Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>,
        Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lguest-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org,
        linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170421141305.25180-1-jslaby-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

These are all functions which are invoked from elsewhere, so we annotate
them as global using the new SYM_FUNC_START (and their ENDPROC's by
SYM_FUNC_END.)

Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Cc: Bill Metzenthen <billm-GyIjJ2z7gDS3Zbb/xt2tYQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lguest-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
---
 arch/x86/boot/compressed/efi_stub_32.S     |   4 +-
 arch/x86/boot/compressed/head_32.S         |  12 +--
 arch/x86/crypto/salsa20-i586-asm_32.S      |  12 +--
 arch/x86/crypto/serpent-sse2-i586-asm_32.S |   8 +-
 arch/x86/crypto/twofish-i586-asm_32.S      |   8 +-
 arch/x86/entry/entry_32.S                  | 132 ++++++++++++++---------------
 arch/x86/kernel/acpi/wakeup_32.S           |   8 +-
 arch/x86/kernel/ftrace_32.S                |  20 ++---
 arch/x86/kernel/head_32.S                  |  16 ++--
 arch/x86/lguest/head_32.S                  |  16 ++--
 arch/x86/lib/atomic64_386_32.S             |   4 +-
 arch/x86/lib/atomic64_cx8_32.S             |  32 +++----
 arch/x86/lib/checksum_32.S                 |   8 +-
 arch/x86/math-emu/div_Xsig.S               |   4 +-
 arch/x86/math-emu/div_small.S              |   4 +-
 arch/x86/math-emu/mul_Xsig.S               |  12 +--
 arch/x86/math-emu/polynom_Xsig.S           |   4 +-
 arch/x86/math-emu/reg_norm.S               |   8 +-
 arch/x86/math-emu/reg_round.S              |   4 +-
 arch/x86/math-emu/reg_u_add.S              |   4 +-
 arch/x86/math-emu/reg_u_div.S              |   4 +-
 arch/x86/math-emu/reg_u_mul.S              |   4 +-
 arch/x86/math-emu/reg_u_sub.S              |   4 +-
 arch/x86/math-emu/round_Xsig.S             |   8 +-
 arch/x86/math-emu/shr_Xsig.S               |   4 +-
 arch/x86/math-emu/wm_shrx.S                |   8 +-
 arch/x86/math-emu/wm_sqrt.S                |   4 +-
 arch/x86/platform/efi/efi_stub_32.S        |   4 +-
 arch/x86/power/hibernate_asm_32.S          |   8 +-
 arch/x86/realmode/rm/trampoline_32.S       |   8 +-
 arch/x86/xen/xen-asm_32.S                  |   8 +-
 drivers/lguest/x86/switcher_32.S           |   4 +-
 32 files changed, 194 insertions(+), 194 deletions(-)

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
index f1babb84510b..1a4c925c55e7 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -223,7 +223,7 @@
  * %eax: prev task
  * %edx: next task
  */
-ENTRY(__switch_to_asm)
+SYM_FUNC_START(__switch_to_asm)
 	/*
 	 * Save callee-saved registers
 	 * This must match the order in struct inactive_task_frame
@@ -249,7 +249,7 @@ ENTRY(__switch_to_asm)
 	popl	%ebp
 
 	jmp	__switch_to
-ENDPROC(__switch_to_asm)
+SYM_FUNC_END(__switch_to_asm)
 
 /*
  * A newly forked process directly context switches into this address.
@@ -258,7 +258,7 @@ ENDPROC(__switch_to_asm)
  * ebx: kernel thread func (NULL for user thread)
  * edi: kernel thread arg
  */
-ENTRY(ret_from_fork)
+SYM_FUNC_START(ret_from_fork)
 	FRAME_BEGIN		/* help unwinder find end of stack */
 
 	/*
@@ -289,7 +289,7 @@ ENTRY(ret_from_fork)
 	 */
 	movl	$0, PT_EAX(%esp)
 	jmp	2b
-ENDPROC(ret_from_fork)
+SYM_FUNC_END(ret_from_fork)
 
 /*
  * Return to user mode is not as complex as all this looks,
@@ -325,7 +325,7 @@ SYM_FUNC_INNER_LABEL(resume_userspace, SYM_V_LOCAL)
 SYM_FUNC_END(ret_from_exception)
 
 #ifdef CONFIG_PREEMPT
-ENTRY(resume_kernel)
+SYM_FUNC_START(resume_kernel)
 	DISABLE_INTERRUPTS(CLBR_ANY)
 .Lneed_resched:
 	cmpl	$0, PER_CPU_VAR(__preempt_count)
@@ -334,7 +334,7 @@ ENTRY(resume_kernel)
 	jz	restore_all
 	call	preempt_schedule_irq
 	jmp	.Lneed_resched
-ENDPROC(resume_kernel)
+SYM_FUNC_END(resume_kernel)
 #endif
 
 SYM_ENTRY(__begin_SYSENTER_singlestep_region, SYM_V_GLOBAL, SYM_A_NONE)
@@ -352,10 +352,10 @@ SYM_ENTRY(__begin_SYSENTER_singlestep_region, SYM_V_GLOBAL, SYM_A_NONE)
  * Xen doesn't set %esp to be precisely what the normal SYSENTER
  * entry point expects, so fix it up before using the normal path.
  */
-ENTRY(xen_sysenter_target)
+SYM_FUNC_START(xen_sysenter_target)
 	addl	$5*4, %esp			/* remove xen-provided frame */
 	jmp	.Lsysenter_past_esp
-ENDPROC(xen_sysenter_target)
+SYM_FUNC_END(xen_sysenter_target)
 #endif
 
 /*
@@ -390,7 +390,7 @@ ENDPROC(xen_sysenter_target)
  * ebp  user stack
  * 0(%ebp) arg6
  */
-ENTRY(entry_SYSENTER_32)
+SYM_FUNC_START(entry_SYSENTER_32)
 	movl	TSS_sysenter_sp0(%esp), %esp
 .Lsysenter_past_esp:
 	pushl	$__USER_DS		/* pt_regs->ss */
@@ -478,7 +478,7 @@ ENTRY(entry_SYSENTER_32)
 	popfl
 	jmp	.Lsysenter_flags_fixed
 SYM_ENTRY(__end_SYSENTER_singlestep_region, SYM_V_GLOBAL, SYM_A_NONE)
-ENDPROC(entry_SYSENTER_32)
+SYM_FUNC_END(entry_SYSENTER_32)
 
 /*
  * 32-bit legacy system call entry.
@@ -508,7 +508,7 @@ ENDPROC(entry_SYSENTER_32)
  * edi  arg5
  * ebp  arg6
  */
-ENTRY(entry_INT80_32)
+SYM_FUNC_START(entry_INT80_32)
 	ASM_CLAC
 	pushl	%eax			/* pt_regs->orig_ax */
 	SAVE_ALL pt_regs_ax=$-ENOSYS	/* save rest */
@@ -587,7 +587,7 @@ SYM_FUNC_END(iret_exc)
 	lss	(%esp), %esp			/* switch to espfix segment */
 	jmp	.Lrestore_nocheck
 #endif
-ENDPROC(entry_INT80_32)
+SYM_FUNC_END(entry_INT80_32)
 
 .macro FIXUP_ESPFIX_STACK
 /*
@@ -628,7 +628,7 @@ ENDPROC(entry_INT80_32)
  * We pack 1 stub into every 8-byte block.
  */
 	.align 8
-ENTRY(irq_entries_start)
+SYM_FUNC_START(irq_entries_start)
     vector=FIRST_EXTERNAL_VECTOR
     .rept (FIRST_SYSTEM_VECTOR - FIRST_EXTERNAL_VECTOR)
 	pushl	$(~vector+0x80)			/* Note: always in signed byte range */
@@ -636,7 +636,7 @@ ENTRY(irq_entries_start)
 	jmp	common_interrupt
 	.align	8
     .endr
-ENDPROC(irq_entries_start)
+SYM_FUNC_END(irq_entries_start)
 
 /*
  * the CPU automatically disables interrupts when executing an IRQ vector,
@@ -655,7 +655,7 @@ SYM_FUNC_START_LOCAL(common_interrupt)
 SYM_FUNC_END(common_interrupt)
 
 #define BUILD_INTERRUPT3(name, nr, fn)	\
-ENTRY(name)				\
+SYM_FUNC_START(name)				\
 	ASM_CLAC;			\
 	pushl	$~(nr);			\
 	SAVE_ALL;			\
@@ -664,7 +664,7 @@ ENTRY(name)				\
 	movl	%esp, %eax;		\
 	call	fn;			\
 	jmp	ret_from_intr;		\
-ENDPROC(name)
+SYM_FUNC_END(name)
 
 
 #ifdef CONFIG_TRACING
@@ -680,14 +680,14 @@ ENDPROC(name)
 /* The include is where all of the SMP etc. interrupts come from */
 #include <asm/entry_arch.h>
 
-ENTRY(coprocessor_error)
+SYM_FUNC_START(coprocessor_error)
 	ASM_CLAC
 	pushl	$0
 	pushl	$do_coprocessor_error
 	jmp	common_exception
-ENDPROC(coprocessor_error)
+SYM_FUNC_END(coprocessor_error)
 
-ENTRY(simd_coprocessor_error)
+SYM_FUNC_START(simd_coprocessor_error)
 	ASM_CLAC
 	pushl	$0
 #ifdef CONFIG_X86_INVD_BUG
@@ -699,99 +699,99 @@ ENTRY(simd_coprocessor_error)
 	pushl	$do_simd_coprocessor_error
 #endif
 	jmp	common_exception
-ENDPROC(simd_coprocessor_error)
+SYM_FUNC_END(simd_coprocessor_error)
 
-ENTRY(device_not_available)
+SYM_FUNC_START(device_not_available)
 	ASM_CLAC
 	pushl	$-1				# mark this as an int
 	pushl	$do_device_not_available
 	jmp	common_exception
-ENDPROC(device_not_available)
+SYM_FUNC_END(device_not_available)
 
 #ifdef CONFIG_PARAVIRT
-ENTRY(native_iret)
+SYM_FUNC_START(native_iret)
 	iret
 	_ASM_EXTABLE(native_iret, iret_exc)
-ENDPROC(native_iret)
+SYM_FUNC_END(native_iret)
 #endif
 
-ENTRY(overflow)
+SYM_FUNC_START(overflow)
 	ASM_CLAC
 	pushl	$0
 	pushl	$do_overflow
 	jmp	common_exception
-ENDPROC(overflow)
+SYM_FUNC_END(overflow)
 
-ENTRY(bounds)
+SYM_FUNC_START(bounds)
 	ASM_CLAC
 	pushl	$0
 	pushl	$do_bounds
 	jmp	common_exception
-ENDPROC(bounds)
+SYM_FUNC_END(bounds)
 
-ENTRY(invalid_op)
+SYM_FUNC_START(invalid_op)
 	ASM_CLAC
 	pushl	$0
 	pushl	$do_invalid_op
 	jmp	common_exception
-ENDPROC(invalid_op)
+SYM_FUNC_END(invalid_op)
 
-ENTRY(coprocessor_segment_overrun)
+SYM_FUNC_START(coprocessor_segment_overrun)
 	ASM_CLAC
 	pushl	$0
 	pushl	$do_coprocessor_segment_overrun
 	jmp	common_exception
-ENDPROC(coprocessor_segment_overrun)
+SYM_FUNC_END(coprocessor_segment_overrun)
 
-ENTRY(invalid_TSS)
+SYM_FUNC_START(invalid_TSS)
 	ASM_CLAC
 	pushl	$do_invalid_TSS
 	jmp	common_exception
-ENDPROC(invalid_TSS)
+SYM_FUNC_END(invalid_TSS)
 
-ENTRY(segment_not_present)
+SYM_FUNC_START(segment_not_present)
 	ASM_CLAC
 	pushl	$do_segment_not_present
 	jmp	common_exception
-ENDPROC(segment_not_present)
+SYM_FUNC_END(segment_not_present)
 
-ENTRY(stack_segment)
+SYM_FUNC_START(stack_segment)
 	ASM_CLAC
 	pushl	$do_stack_segment
 	jmp	common_exception
-ENDPROC(stack_segment)
+SYM_FUNC_END(stack_segment)
 
-ENTRY(alignment_check)
+SYM_FUNC_START(alignment_check)
 	ASM_CLAC
 	pushl	$do_alignment_check
 	jmp	common_exception
-ENDPROC(alignment_check)
+SYM_FUNC_END(alignment_check)
 
-ENTRY(divide_error)
+SYM_FUNC_START(divide_error)
 	ASM_CLAC
 	pushl	$0				# no error code
 	pushl	$do_divide_error
 	jmp	common_exception
-ENDPROC(divide_error)
+SYM_FUNC_END(divide_error)
 
 #ifdef CONFIG_X86_MCE
-ENTRY(machine_check)
+SYM_FUNC_START(machine_check)
 	ASM_CLAC
 	pushl	$0
 	pushl	machine_check_vector
 	jmp	common_exception
-ENDPROC(machine_check)
+SYM_FUNC_END(machine_check)
 #endif
 
-ENTRY(spurious_interrupt_bug)
+SYM_FUNC_START(spurious_interrupt_bug)
 	ASM_CLAC
 	pushl	$0
 	pushl	$do_spurious_interrupt_bug
 	jmp	common_exception
-ENDPROC(spurious_interrupt_bug)
+SYM_FUNC_END(spurious_interrupt_bug)
 
 #ifdef CONFIG_XEN
-ENTRY(xen_hypervisor_callback)
+SYM_FUNC_START(xen_hypervisor_callback)
 	pushl	$-1				/* orig_ax = -1 => not a system call */
 	SAVE_ALL
 	ENCODE_FRAME_POINTER
@@ -819,7 +819,7 @@ SYM_FUNC_INNER_LABEL(xen_do_upcall, SYM_V_GLOBAL)
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
@@ -885,19 +885,19 @@ BUILD_INTERRUPT3(hyperv_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
 #endif /* CONFIG_HYPERV */
 
 #ifdef CONFIG_TRACING
-ENTRY(trace_page_fault)
+SYM_FUNC_START(trace_page_fault)
 	ASM_CLAC
 	pushl	$trace_do_page_fault
 	jmp	common_exception
-ENDPROC(trace_page_fault)
+SYM_FUNC_END(trace_page_fault)
 #endif
 
-ENTRY(page_fault)
+SYM_FUNC_START(page_fault)
 	ASM_CLAC
 	pushl	$do_page_fault
 	ALIGN
 	jmp common_exception
-ENDPROC(page_fault)
+SYM_FUNC_END(page_fault)
 
 SYM_FUNC_START_LOCAL(common_exception)
 	/* the function address is in %gs's slot on the stack */
@@ -931,7 +931,7 @@ SYM_FUNC_START_LOCAL(common_exception)
 	jmp	ret_from_exception
 SYM_FUNC_END(common_exception)
 
-ENTRY(debug)
+SYM_FUNC_START(debug)
 	/*
 	 * #DB can happen at the first instruction of
 	 * entry_SYSENTER_32 or in Xen's SYSENTER prologue.  If this
@@ -966,7 +966,7 @@ ENTRY(debug)
 	call	do_debug
 	movl	%ebx, %esp
 	jmp	ret_from_exception
-ENDPROC(debug)
+SYM_FUNC_END(debug)
 
 /*
  * NMI is doubly nasty.  It can happen on the first instruction of
@@ -975,7 +975,7 @@ ENDPROC(debug)
  * switched stacks.  We handle both conditions by simply checking whether we
  * interrupted kernel code running on the SYSENTER stack.
  */
-ENTRY(nmi)
+SYM_FUNC_START(nmi)
 	ASM_CLAC
 #ifdef CONFIG_X86_ESPFIX32
 	pushl	%eax
@@ -1034,9 +1034,9 @@ ENTRY(nmi)
 	lss	12+4(%esp), %esp		# back to espfix stack
 	jmp	.Lirq_return
 #endif
-ENDPROC(nmi)
+SYM_FUNC_END(nmi)
 
-ENTRY(int3)
+SYM_FUNC_START(int3)
 	ASM_CLAC
 	pushl	$-1				# mark this as an int
 	SAVE_ALL
@@ -1046,22 +1046,22 @@ ENTRY(int3)
 	movl	%esp, %eax			# pt_regs pointer
 	call	do_int3
 	jmp	ret_from_exception
-ENDPROC(int3)
+SYM_FUNC_END(int3)
 
-ENTRY(general_protection)
+SYM_FUNC_START(general_protection)
 	pushl	$do_general_protection
 	jmp	common_exception
-ENDPROC(general_protection)
+SYM_FUNC_END(general_protection)
 
 #ifdef CONFIG_KVM_GUEST
-ENTRY(async_page_fault)
+SYM_FUNC_START(async_page_fault)
 	ASM_CLAC
 	pushl	$do_async_page_fault
 	jmp	common_exception
-ENDPROC(async_page_fault)
+SYM_FUNC_END(async_page_fault)
 #endif
 
-ENTRY(rewind_stack_do_exit)
+SYM_FUNC_START(rewind_stack_do_exit)
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
 
@@ -1070,4 +1070,4 @@ ENTRY(rewind_stack_do_exit)
 
 	call	do_exit
 1:	jmp 1b
-ENDPROC(rewind_stack_do_exit)
+SYM_FUNC_END(rewind_stack_do_exit)
diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 11fb24d15f3d..15a61607ccb8 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -8,7 +8,7 @@
 	.code32
 	ALIGN
 
-ENTRY(wakeup_pmode_return)
+SYM_FUNC_START(wakeup_pmode_return)
 wakeup_pmode_return:
 	movw	$__KERNEL_DS, %ax
 	movw	%ax, %ss
@@ -38,7 +38,7 @@ wakeup_pmode_return:
 	# jump to place where we left off
 	movl	saved_eip, %eax
 	jmp	*%eax
-ENDPROC(wakeup_pmode_return)
+SYM_FUNC_END(wakeup_pmode_return)
 
 bogus_magic:
 	jmp	bogus_magic
@@ -72,7 +72,7 @@ restore_registers:
 	popfl
 	ret
 
-ENTRY(do_suspend_lowlevel)
+SYM_FUNC_START(do_suspend_lowlevel)
 	call	save_processor_state
 	call	save_registers
 	pushl	$3
@@ -87,7 +87,7 @@ ret_point:
 	call	restore_registers
 	call	restore_processor_state
 	ret
-ENDPROC(do_suspend_lowlevel)
+SYM_FUNC_END(do_suspend_lowlevel)
 
 .data
 ALIGN
diff --git a/arch/x86/kernel/ftrace_32.S b/arch/x86/kernel/ftrace_32.S
index 8ad07ddfa1c9..9c3db18b2a19 100644
--- a/arch/x86/kernel/ftrace_32.S
+++ b/arch/x86/kernel/ftrace_32.S
@@ -29,11 +29,11 @@ EXPORT_SYMBOL(mcount)
 # define MCOUNT_FRAME			0	/* using frame = false */
 #endif
 
-ENTRY(function_hook)
+SYM_FUNC_START(function_hook)
 	ret
-ENDPROC(function_hook)
+SYM_FUNC_END(function_hook)
 
-ENTRY(ftrace_caller)
+SYM_FUNC_START(ftrace_caller)
 
 #ifdef USING_FRAME_POINTER
 # ifdef CC_USING_FENTRY
@@ -98,9 +98,9 @@ ftrace_graph_call:
 /* This is weak to keep gas from relaxing the jumps */
 WEAK(ftrace_stub)
 	ret
-ENDPROC(ftrace_caller)
+SYM_FUNC_END(ftrace_caller)
 
-ENTRY(ftrace_regs_caller)
+SYM_FUNC_START(ftrace_regs_caller)
 	/*
 	 * i386 does not save SS and ESP when coming from kernel.
 	 * Instead, to get sp, &regs->sp is used (see ptrace.h).
@@ -168,10 +168,10 @@ SYM_FUNC_INNER_LABEL(ftrace_regs_call, SYM_V_GLOBAL)
 	lea	3*4(%esp), %esp			/* Skip orig_ax, ip and cs */
 
 	jmp	.Lftrace_ret
-ENDPROC(ftrace_regs_caller)
+SYM_FUNC_END(ftrace_regs_caller)
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
-ENTRY(function_hook)
+SYM_FUNC_START(function_hook)
 	cmpl	$__PAGE_OFFSET, %esp
 	jb	ftrace_stub			/* Paging not enabled yet? */
 
@@ -203,11 +203,11 @@ ftrace_stub:
 	popl	%ecx
 	popl	%eax
 	jmp	ftrace_stub
-ENDPROC(function_hook)
+SYM_FUNC_END(function_hook)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-ENTRY(ftrace_graph_caller)
+SYM_FUNC_START(ftrace_graph_caller)
 	pushl	%eax
 	pushl	%ecx
 	pushl	%edx
@@ -226,7 +226,7 @@ ENTRY(ftrace_graph_caller)
 	popl	%ecx
 	popl	%eax
 	ret
-ENDPROC(ftrace_graph_caller)
+SYM_FUNC_END(ftrace_graph_caller)
 
 .globl return_to_handler
 return_to_handler:
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 47a212e3beee..74d18d2fef5a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -63,7 +63,7 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  * can.
  */
 __HEAD
-ENTRY(startup_32)
+SYM_FUNC_START(startup_32)
 	movl pa(initial_stack),%ecx
 	
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
@@ -173,7 +173,7 @@ num_subarch_entries = (. - subarch_entries) / 4
 #else
 	jmp .Ldefault_entry
 #endif /* CONFIG_PARAVIRT */
-ENDPROC(startup_32)
+SYM_FUNC_END(startup_32)
 
 #ifdef CONFIG_HOTPLUG_CPU
 /*
@@ -181,12 +181,12 @@ ENDPROC(startup_32)
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
@@ -197,7 +197,7 @@ ENDPROC(start_cpu0)
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
  */
-ENTRY(startup_32_smp)
+SYM_FUNC_START(startup_32_smp)
 	cld
 	movl $(__BOOT_DS),%eax
 	movl %eax,%ds
@@ -368,7 +368,7 @@ ENTRY(startup_32_smp)
 
 	call *(initial_code)
 1:	jmp 1b
-ENDPROC(startup_32_smp)
+SYM_FUNC_END(startup_32_smp)
 
 #include "verify_cpu.S"
 
@@ -429,7 +429,7 @@ setup_once:
 	andl $0,setup_once_ref	/* Once is enough, thanks */
 	ret
 
-ENTRY(early_idt_handler_array)
+SYM_FUNC_START(early_idt_handler_array)
 	# 36(%esp) %eflags
 	# 32(%esp) %cs
 	# 28(%esp) %eip
@@ -444,7 +444,7 @@ ENTRY(early_idt_handler_array)
 	i = i + 1
 	.fill early_idt_handler_array + i*EARLY_IDT_HANDLER_SIZE - ., 1, 0xcc
 	.endr
-ENDPROC(early_idt_handler_array)
+SYM_FUNC_END(early_idt_handler_array)
 	
 SYM_FUNC_START_LOCAL(early_idt_handler_common)
 	/*
diff --git a/arch/x86/lguest/head_32.S b/arch/x86/lguest/head_32.S
index b11a989de062..99069ec13511 100644
--- a/arch/x86/lguest/head_32.S
+++ b/arch/x86/lguest/head_32.S
@@ -29,7 +29,7 @@
  * boot.
  */
 .section .init.text, "ax", @progbits
-ENTRY(lguest_entry)
+SYM_FUNC_START(lguest_entry)
 	/*
 	 * We make the "initialization" hypercall now to tell the Host where
 	 * our lguest_data struct is.
@@ -48,7 +48,7 @@ ENTRY(lguest_entry)
 
 	/* Jumps are relative: we're running __PAGE_OFFSET too low. */
 	jmp lguest_init+__PAGE_OFFSET
-ENDPROC(lguest_entry)
+SYM_FUNC_END(lguest_entry)
 
 /*G:055
  * We create a macro which puts the assembler code between lgstart_ and lgend_
@@ -73,7 +73,7 @@ LGUEST_PATCH(pushf, movl lguest_data+LGUEST_DATA_irq_enabled, %eax)
  * in a bit more detail so I'll describe in easy stages.  First, the routine to
  * enable interrupts:
  */
-ENTRY(lg_irq_enable)
+SYM_FUNC_START(lg_irq_enable)
 	/*
 	 * The reverse of irq_disable, this sets lguest_data.irq_enabled to
 	 * X86_EFLAGS_IF (ie. "Interrupts enabled").
@@ -111,14 +111,14 @@ send_interrupts:
 	/* Put eax back the way we found it. */
 	popl %eax
 	ret
-ENDPROC(lg_irq_enable)
+SYM_FUNC_END(lg_irq_enable)
 
 /*
  * Finally, the "popf" or "restore flags" routine.  The %eax register holds the
  * flags (in practice, either X86_EFLAGS_IF or 0): if it's X86_EFLAGS_IF we're
  * enabling interrupts again, if it's 0 we're leaving them off.
  */
-ENTRY(lg_restore_fl)
+SYM_FUNC_START(lg_restore_fl)
 	/* This is just "lguest_data.irq_enabled = flags;" */
 	movl %eax, lguest_data+LGUEST_DATA_irq_enabled
 	/*
@@ -133,7 +133,7 @@ ENTRY(lg_restore_fl)
 	jnz send_interrupts
 	/* Again, the normal path has used no extra registers.  Clever, huh? */
 	ret
-ENDPROC(lg_restore_fl)
+SYM_FUNC_END(lg_restore_fl)
 /*:*/
 
 /* These demark the EIP where host should never deliver interrupts. */
@@ -182,7 +182,7 @@ ENDPROC(lg_restore_fl)
  * data gets updated only after it completes, so we only need to protect
  * one instruction, iret).
  */
-ENTRY(lguest_iret)
+SYM_FUNC_START(lguest_iret)
 	pushl	2*4(%esp)
 	/*
 	 * Note the %ss: segment prefix here.  Normal data accesses use the
@@ -193,4 +193,4 @@ ENTRY(lguest_iret)
 	popl	%ss:lguest_data+LGUEST_DATA_irq_enabled
 lguest_noirq_iret:
 	iret
-ENDPROC(lguest_iret)
+SYM_FUNC_END(lguest_iret)
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
diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index 9480f4b2df94..3fdc4d77ead0 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -14,7 +14,7 @@
 
 .text
 
-ENTRY(swsusp_arch_suspend)
+SYM_FUNC_START(swsusp_arch_suspend)
 	movl %esp, saved_context_esp
 	movl %ebx, saved_context_ebx
 	movl %ebp, saved_context_ebp
@@ -25,9 +25,9 @@ ENTRY(swsusp_arch_suspend)
 
 	call swsusp_save
 	ret
-ENDPROC(swsusp_arch_suspend)
+SYM_FUNC_END(swsusp_arch_suspend)
 
-ENTRY(restore_image)
+SYM_FUNC_START(restore_image)
 	movl	mmu_cr4_features, %ecx
 	movl	resume_pg_dir, %eax
 	subl	$__PAGE_OFFSET, %eax
@@ -83,5 +83,5 @@ done:
 	xorl	%eax, %eax
 
 	ret
-ENDPROC(restore_image)
+SYM_FUNC_END(restore_image)
 
diff --git a/arch/x86/realmode/rm/trampoline_32.S b/arch/x86/realmode/rm/trampoline_32.S
index 956b1c451661..8cee44fbd362 100644
--- a/arch/x86/realmode/rm/trampoline_32.S
+++ b/arch/x86/realmode/rm/trampoline_32.S
@@ -28,7 +28,7 @@
 	.code16
 
 	.balign	PAGE_SIZE
-ENTRY(trampoline_start)
+SYM_FUNC_START(trampoline_start)
 	wbinvd			# Needed for NUMA-Q should be harmless for others
 
 	LJMPW_RM(1f)
@@ -56,13 +56,13 @@ ENTRY(trampoline_start)
 	lmsw	%dx			# into protected mode
 
 	ljmpl	$__BOOT_CS, $pa_startup_32
-ENDPROC(trampoline_start)
+SYM_FUNC_END(trampoline_start)
 
 	.section ".text32","ax"
 	.code32
-ENTRY(startup_32)			# note: also used from wakeup_asm.S
+SYM_FUNC_START(startup_32)			# note: also used from wakeup_asm.S
 	jmp	*%eax
-ENDPROC(startup_32)
+SYM_FUNC_END(startup_32)
 
 	.bss
 	.balign 8
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 748beeff6e7d..d4c6f6d50f29 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -72,7 +72,7 @@ check_events:
 	_ASM_EXTABLE(1b,2b)
 .endm
 
-ENTRY(xen_iret)
+SYM_FUNC_START(xen_iret)
 	/* test eflags for special cases */
 	testl $(X86_EFLAGS_VM | XEN_EFLAGS_NMI), 8(%esp)
 	jnz hyper_iret
@@ -138,7 +138,7 @@ xen_iret_end_crit:
 hyper_iret:
 	/* put this out of line since its very rarely used */
 	jmp hypercall_page + __HYPERVISOR_iret * 32
-ENDPROC(xen_iret)
+SYM_FUNC_END(xen_iret)
 
 	.globl xen_iret_start_crit, xen_iret_end_crit
 
@@ -182,7 +182,7 @@ ENDPROC(xen_iret)
  * SAVE_ALL state before going on, since it's usermode state which we
  * eventually need to restore.
  */
-ENTRY(xen_iret_crit_fixup)
+SYM_FUNC_START(xen_iret_crit_fixup)
 	/*
 	 * Paranoia: Make sure we're really coming from kernel space.
 	 * One could imagine a case where userspace jumps into the
@@ -221,4 +221,4 @@ ENTRY(xen_iret_crit_fixup)
 
 	lea 4(%edi), %esp		/* point esp to new frame */
 2:	jmp xen_do_upcall
-ENDPROC(xen_iret_crit_fixup)
+SYM_FUNC_END(xen_iret_crit_fixup)
diff --git a/drivers/lguest/x86/switcher_32.S b/drivers/lguest/x86/switcher_32.S
index 3318a967f28b..ad49e53e342c 100644
--- a/drivers/lguest/x86/switcher_32.S
+++ b/drivers/lguest/x86/switcher_32.S
@@ -101,7 +101,7 @@ ENTRY(start_switcher_text)
 // Where we save state and still see it from the Guest
 // And %ebx holds the Guest shadow pagetable:
 // Once set we have truly left Host behind.
-ENTRY(switch_to_guest)
+SYM_FUNC_START(switch_to_guest)
 	// We told gcc all its regs could fade,
 	// Clobbered by our journey into the Guest
 	// We could have saved them, if we tried
@@ -265,7 +265,7 @@ ENTRY(switch_to_guest)
 return_to_host:
 	SWITCH_TO_HOST
 	iret
-ENDPROC(switch_to_guest)
+SYM_FUNC_END(switch_to_guest)
 
 // We are lead to the second path like so:
 // An interrupt, with some cause external
-- 
2.12.2
