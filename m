From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] arm: new W macro to WORD_ACCESS
Date: Wed, 16 Sep 2009 19:58:12 +0200
Message-ID: <20090916175812.GA18993@Chamillionaire.breakpoint.cc>
References: <200909161601.35662.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org
To: Frans Pop <elendil@planet.nl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43968 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754257AbZIPR6K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Sep 2009 13:58:10 -0400
Content-Disposition: inline
In-Reply-To: <200909161601.35662.elendil@planet.nl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As reported by Frans Pop the new global macro W on ARM which is included
via
|arch/arm/include/asm/uaccess.h:20
|include/linux/uaccess.h:5
|include/linux/crypto.h:26
|crypto/cast6.c:23

leads to a build error because the crypto/cast6.c defines a function
which is named W.

Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
* Frans Pop | 2009-09-16 16:01:34 [+0200]:

>Maybe it's a result of enabling the new config option CRYPTO_DEV_MV_CESA?
please don't blame my shiny new driver :)

Catalin: bisect leads to 8b592783a. I've renamed the macro in this
commit and everything else I found due to compile error. Hope the new
name is acceptable. I think W in global name space is a bad thing to do.
In crypto there are many one letter identifier.
Since you use this in assembly code only you might want to move it to
another header file which does get included from every .c file.

 arch/arm/boot/compressed/head.S |   96 +++++++++++++++++++-------------------
 arch/arm/include/asm/unified.h  |    4 +-
 arch/arm/kernel/entry-armv.S    |   50 ++++++++++----------
 arch/arm/lib/copy_from_user.S   |    2 +-
 arch/arm/lib/copy_template.S    |    4 +-
 arch/arm/lib/copy_to_user.S     |    2 +-
 arch/arm/lib/memcpy.S           |    4 +-
 arch/arm/lib/memmove.S          |   28 ++++++------
 8 files changed, 95 insertions(+), 95 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index fa6fbf4..6939dd0 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -612,8 +612,8 @@ call_cache_fn:	adr	r12, proc_types
 proc_types:
 		.word	0x41560600		@ ARM6/610
 		.word	0xffffffe0
-		W(b)	__arm6_mmu_cache_off	@ works, but slow
-		W(b)	__arm6_mmu_cache_off
+		WORD_ACCESS(b)	__arm6_mmu_cache_off	@ works, but slow
+		WORD_ACCESS(b)	__arm6_mmu_cache_off
 		mov	pc, lr
  THUMB(		nop				)
 @		b	__arm6_mmu_cache_on		@ untested
@@ -631,29 +631,29 @@ proc_types:
 
 		.word	0x41007000		@ ARM7/710
 		.word	0xfff8fe00
-		W(b)	__arm7_mmu_cache_off
-		W(b)	__arm7_mmu_cache_off
+		WORD_ACCESS(b)	__arm7_mmu_cache_off
+		WORD_ACCESS(b)	__arm7_mmu_cache_off
 		mov	pc, lr
  THUMB(		nop				)
 
 		.word	0x41807200		@ ARM720T (writethrough)
 		.word	0xffffff00
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
 		mov	pc, lr
  THUMB(		nop				)
 
 		.word	0x41007400		@ ARM74x
 		.word	0xff00ff00
-		W(b)	__armv3_mpu_cache_on
-		W(b)	__armv3_mpu_cache_off
-		W(b)	__armv3_mpu_cache_flush
+		WORD_ACCESS(b)	__armv3_mpu_cache_on
+		WORD_ACCESS(b)	__armv3_mpu_cache_off
+		WORD_ACCESS(b)	__armv3_mpu_cache_flush
 		
 		.word	0x41009400		@ ARM94x
 		.word	0xff00ff00
-		W(b)	__armv4_mpu_cache_on
-		W(b)	__armv4_mpu_cache_off
-		W(b)	__armv4_mpu_cache_flush
+		WORD_ACCESS(b)	__armv4_mpu_cache_on
+		WORD_ACCESS(b)	__armv4_mpu_cache_off
+		WORD_ACCESS(b)	__armv4_mpu_cache_flush
 
 		.word	0x00007000		@ ARM7 IDs
 		.word	0x0000f000
@@ -668,39 +668,39 @@ proc_types:
 
 		.word	0x4401a100		@ sa110 / sa1100
 		.word	0xffffffe0
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv4_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_flush
 
 		.word	0x6901b110		@ sa1110
 		.word	0xfffffff0
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv4_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_flush
 
 		.word	0x56056930
 		.word	0xff0ffff0		@ PXA935
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv4_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_flush
 
 		.word	0x56158000		@ PXA168
 		.word	0xfffff000
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv5tej_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv5tej_mmu_cache_flush
 
 		.word	0x56056930
 		.word	0xff0ffff0		@ PXA935
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv4_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_flush
 
 		.word	0x56050000		@ Feroceon
 		.word	0xff0f0000
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv5tej_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv5tej_mmu_cache_flush
 
 #ifdef CONFIG_CPU_FEROCEON_OLD_ID
 		/* this conflicts with the standard ARMv5TE entry */
@@ -713,41 +713,41 @@ proc_types:
 
 		.word	0x66015261		@ FA526
 		.word	0xff01fff1
-		W(b)	__fa526_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__fa526_cache_flush
+		WORD_ACCESS(b)	__fa526_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__fa526_cache_flush
 
 		@ These match on the architecture ID
 
 		.word	0x00020000		@ ARMv4T
 		.word	0x000f0000
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv4_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_flush
 
 		.word	0x00050000		@ ARMv5TE
 		.word	0x000f0000
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv4_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_flush
 
 		.word	0x00060000		@ ARMv5TEJ
 		.word	0x000f0000
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv4_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv4_mmu_cache_flush
 
 		.word	0x0007b000		@ ARMv6
 		.word	0x000ff000
-		W(b)	__armv4_mmu_cache_on
-		W(b)	__armv4_mmu_cache_off
-		W(b)	__armv6_mmu_cache_flush
+		WORD_ACCESS(b)	__armv4_mmu_cache_on
+		WORD_ACCESS(b)	__armv4_mmu_cache_off
+		WORD_ACCESS(b)	__armv6_mmu_cache_flush
 
 		.word	0x000f0000		@ new CPU Id
 		.word	0x000f0000
-		W(b)	__armv7_mmu_cache_on
-		W(b)	__armv7_mmu_cache_off
-		W(b)	__armv7_mmu_cache_flush
+		WORD_ACCESS(b)	__armv7_mmu_cache_on
+		WORD_ACCESS(b)	__armv7_mmu_cache_off
+		WORD_ACCESS(b)	__armv7_mmu_cache_flush
 
 		.word	0			@ unrecognised type
 		.word	0
diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index 073e85b..0dd685a 100644
--- a/arch/arm/include/asm/unified.h
+++ b/arch/arm/include/asm/unified.h
@@ -35,7 +35,7 @@
 
 #define ARM(x...)
 #define THUMB(x...)	x
-#define W(instr)	instr.w
+#define WORD_ACCESS(instr)	instr.w
 #define BSYM(sym)	sym + 1
 
 #else	/* !CONFIG_THUMB2_KERNEL */
@@ -45,7 +45,7 @@
 
 #define ARM(x...)	x
 #define THUMB(x...)
-#define W(instr)	instr
+#define WORD_ACCESS(instr)	instr
 #define BSYM(sym)	sym
 
 #endif	/* CONFIG_THUMB2_KERNEL */
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 3d727a8..564789a 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -606,33 +606,33 @@ call_fpe:
  THUMB(	add	pc, r8			)
 	nop
 
-	W(mov)	pc, lr				@ CP#0
-	W(b)	do_fpe				@ CP#1 (FPE)
-	W(b)	do_fpe				@ CP#2 (FPE)
-	W(mov)	pc, lr				@ CP#3
+	WORD_ACCESS(mov)	pc, lr			@ CP#0
+	WORD_ACCESS(b)	do_fpe				@ CP#1 (FPE)
+	WORD_ACCESS(b)	do_fpe				@ CP#2 (FPE)
+	WORD_ACCESS(mov)	pc, lr			@ CP#3
 #ifdef CONFIG_CRUNCH
 	b	crunch_task_enable		@ CP#4 (MaverickCrunch)
 	b	crunch_task_enable		@ CP#5 (MaverickCrunch)
 	b	crunch_task_enable		@ CP#6 (MaverickCrunch)
 #else
-	W(mov)	pc, lr				@ CP#4
-	W(mov)	pc, lr				@ CP#5
-	W(mov)	pc, lr				@ CP#6
+	WORD_ACCESS(mov)	pc, lr			@ CP#4
+	WORD_ACCESS(mov)	pc, lr			@ CP#5
+	WORD_ACCESS(mov)	pc, lr			@ CP#6
 #endif
-	W(mov)	pc, lr				@ CP#7
-	W(mov)	pc, lr				@ CP#8
-	W(mov)	pc, lr				@ CP#9
+	WORD_ACCESS(mov)	pc, lr			@ CP#7
+	WORD_ACCESS(mov)	pc, lr			@ CP#8
+	WORD_ACCESS(mov)	pc, lr			@ CP#9
 #ifdef CONFIG_VFP
-	W(b)	do_vfp				@ CP#10 (VFP)
-	W(b)	do_vfp				@ CP#11 (VFP)
+	WORD_ACCESS(b)	do_vfp				@ CP#10 (VFP)
+	WORD_ACCESS(b)	do_vfp				@ CP#11 (VFP)
 #else
-	W(mov)	pc, lr				@ CP#10 (VFP)
-	W(mov)	pc, lr				@ CP#11 (VFP)
+	WORD_ACCESS(mov)	pc, lr			@ CP#10 (VFP)
+	WORD_ACCESS(mov)	pc, lr			@ CP#11 (VFP)
 #endif
-	W(mov)	pc, lr				@ CP#12
-	W(mov)	pc, lr				@ CP#13
-	W(mov)	pc, lr				@ CP#14 (Debug)
-	W(mov)	pc, lr				@ CP#15 (Control)
+	WORD_ACCESS(mov)	pc, lr			@ CP#12
+	WORD_ACCESS(mov)	pc, lr			@ CP#13
+	WORD_ACCESS(mov)	pc, lr			@ CP#14 (Debug)
+	WORD_ACCESS(mov)	pc, lr			@ CP#15 (Control)
 
 #ifdef CONFIG_NEON
 	.align	6
@@ -1236,13 +1236,13 @@ __vectors_start:
  ARM(	swi	SYS_ERROR0	)
  THUMB(	svc	#0		)
  THUMB(	nop			)
-	W(b)	vector_und + stubs_offset
-	W(ldr)	pc, .LCvswi + stubs_offset
-	W(b)	vector_pabt + stubs_offset
-	W(b)	vector_dabt + stubs_offset
-	W(b)	vector_addrexcptn + stubs_offset
-	W(b)	vector_irq + stubs_offset
-	W(b)	vector_fiq + stubs_offset
+	WORD_ACCESS(b)	vector_und + stubs_offset
+	WORD_ACCESS(ldr)	pc, .LCvswi + stubs_offset
+	WORD_ACCESS(b)	vector_pabt + stubs_offset
+	WORD_ACCESS(b)	vector_dabt + stubs_offset
+	WORD_ACCESS(b)	vector_addrexcptn + stubs_offset
+	WORD_ACCESS(b)	vector_irq + stubs_offset
+	WORD_ACCESS(b)	vector_fiq + stubs_offset
 
 	.globl	__vectors_end
 __vectors_end:
diff --git a/arch/arm/lib/copy_from_user.S b/arch/arm/lib/copy_from_user.S
index e4fe124..ea25eb7 100644
--- a/arch/arm/lib/copy_from_user.S
+++ b/arch/arm/lib/copy_from_user.S
@@ -61,7 +61,7 @@
 	.endm
 
 	.macro str1w ptr reg abort
-	W(str) \reg, [\ptr], #4
+	WORD_ACCESS(str) \reg, [\ptr], #4
 	.endm
 
 	.macro str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
diff --git a/arch/arm/lib/copy_template.S b/arch/arm/lib/copy_template.S
index 805e3f8..8619346 100644
--- a/arch/arm/lib/copy_template.S
+++ b/arch/arm/lib/copy_template.S
@@ -113,7 +113,7 @@
 		b	7f
 6:
 		.rept	(1 << LDR1W_SHIFT)
-		W(nop)
+		WORD_ACCESS(nop)
 		.endr
 		ldr1w	r1, r3, abort=20f
 		ldr1w	r1, r4, abort=20f
@@ -131,7 +131,7 @@
 		add	pc, pc, ip
 		nop
 		.rept	(1 << STR1W_SHIFT)
-		W(nop)
+		WORD_ACCESS(nop)
 		.endr
 		str1w	r0, r3, abort=20f
 		str1w	r0, r4, abort=20f
diff --git a/arch/arm/lib/copy_to_user.S b/arch/arm/lib/copy_to_user.S
index 1a71e15..8e7b756 100644
--- a/arch/arm/lib/copy_to_user.S
+++ b/arch/arm/lib/copy_to_user.S
@@ -41,7 +41,7 @@
 #endif
 
 	.macro ldr1w ptr reg abort
-	W(ldr) \reg, [\ptr], #4
+	WORD_ACCESS(ldr) \reg, [\ptr], #4
 	.endm
 
 	.macro ldr4w ptr reg1 reg2 reg3 reg4 abort
diff --git a/arch/arm/lib/memcpy.S b/arch/arm/lib/memcpy.S
index a9b9e22..28aa074 100644
--- a/arch/arm/lib/memcpy.S
+++ b/arch/arm/lib/memcpy.S
@@ -17,7 +17,7 @@
 #define STR1W_SHIFT	0
 
 	.macro ldr1w ptr reg abort
-	W(ldr) \reg, [\ptr], #4
+	WORD_ACCESS(ldr) \reg, [\ptr], #4
 	.endm
 
 	.macro ldr4w ptr reg1 reg2 reg3 reg4 abort
@@ -33,7 +33,7 @@
 	.endm
 
 	.macro str1w ptr reg abort
-	W(str) \reg, [\ptr], #4
+	WORD_ACCESS(str) \reg, [\ptr], #4
 	.endm
 
 	.macro str8w ptr reg1 reg2 reg3 reg4 reg5 reg6 reg7 reg8 abort
diff --git a/arch/arm/lib/memmove.S b/arch/arm/lib/memmove.S
index 5025c86..08a6210 100644
--- a/arch/arm/lib/memmove.S
+++ b/arch/arm/lib/memmove.S
@@ -75,24 +75,24 @@ ENTRY(memmove)
 		addne	pc, pc, ip		@ C is always clear here
 		b	7f
 6:		nop
-		W(ldr)	r3, [r1, #-4]!
-		W(ldr)	r4, [r1, #-4]!
-		W(ldr)	r5, [r1, #-4]!
-		W(ldr)	r6, [r1, #-4]!
-		W(ldr)	r7, [r1, #-4]!
-		W(ldr)	r8, [r1, #-4]!
-		W(ldr)	lr, [r1, #-4]!
+		WORD_ACCESS(ldr)	r3, [r1, #-4]!
+		WORD_ACCESS(ldr)	r4, [r1, #-4]!
+		WORD_ACCESS(ldr)	r5, [r1, #-4]!
+		WORD_ACCESS(ldr)	r6, [r1, #-4]!
+		WORD_ACCESS(ldr)	r7, [r1, #-4]!
+		WORD_ACCESS(ldr)	r8, [r1, #-4]!
+		WORD_ACCESS(ldr)	lr, [r1, #-4]!
 
 		add	pc, pc, ip
 		nop
 		nop
-		W(str)	r3, [r0, #-4]!
-		W(str)	r4, [r0, #-4]!
-		W(str)	r5, [r0, #-4]!
-		W(str)	r6, [r0, #-4]!
-		W(str)	r7, [r0, #-4]!
-		W(str)	r8, [r0, #-4]!
-		W(str)	lr, [r0, #-4]!
+		WORD_ACCESS(str)	r3, [r0, #-4]!
+		WORD_ACCESS(str)	r4, [r0, #-4]!
+		WORD_ACCESS(str)	r5, [r0, #-4]!
+		WORD_ACCESS(str)	r6, [r0, #-4]!
+		WORD_ACCESS(str)	r7, [r0, #-4]!
+		WORD_ACCESS(str)	r8, [r0, #-4]!
+		WORD_ACCESS(str)	lr, [r0, #-4]!
 
 	CALGN(	bcs	2b			)
 
-- 
1.6.4.GIT

