From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+ (part2)
Date: Tue, 01 Jul 2014 17:19:39 +0100
Message-ID: <E1X20mR-00083N-0C@rmk-PC.arm.linux.org.uk>
Cc: linux-crypto@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org,
	xen-devel@lists.xenproject.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50191 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932278AbaGAQTp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 12:19:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -55,7 +55,7 @@
  * cpu_arm926_proc_init()
  */
 ENTRY(cpu_arm926_proc_init)
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_arm926_proc_fin()
@@ -65,7 +65,7 @@ ENTRY(cpu_arm926_proc_fin)
 	bic	r0, r0, #0x1000			@ ...i............
 	bic	r0, r0, #0x000e			@ ............wca.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_arm926_reset(loc)
@@ -89,7 +89,7 @@ ENTRY(cpu_arm926_reset)
 	bic	ip, ip, #0x000f			@ ............wcam
 	bic	ip, ip, #0x1100			@ ...i...s........
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_arm926_reset)
 	.popsection
 
@@ -111,7 +111,7 @@ ENTRY(cpu_arm926_do_idle)
 	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
 	mcr	p15, 0, r1, c1, c0, 0		@ Restore ICache enable
 	msr	cpsr_c, r3			@ Restore FIQ state
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_icache_all()
@@ -121,7 +121,7 @@ ENTRY(cpu_arm926_do_idle)
 ENTRY(arm926_flush_icache_all)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
+	ret	lr
 ENDPROC(arm926_flush_icache_all)
 
 /*
@@ -151,7 +151,7 @@ __flush_whole_cache:
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_user_cache_range(start, end, flags)
@@ -188,7 +188,7 @@ ENTRY(arm926_flush_user_cache_range)
 	blo	1b
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_kern_range(start, end)
@@ -222,7 +222,7 @@ ENTRY(arm926_coherent_user_range)
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	r0, #0
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_kern_dcache_area(void *addr, size_t size)
@@ -242,7 +242,7 @@ ENTRY(arm926_flush_kern_dcache_area)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_inv_range(start, end)
@@ -270,7 +270,7 @@ arm926_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_clean_range(start, end)
@@ -291,7 +291,7 @@ arm926_dma_clean_range:
 	blo	1b
 #endif
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_flush_range(start, end)
@@ -313,7 +313,7 @@ ENTRY(arm926_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_map_area(start, size, dir)
@@ -336,7 +336,7 @@ ENDPROC(arm926_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(arm926_dma_unmap_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(arm926_dma_unmap_area)
 
 	.globl	arm926_flush_kern_cache_louis
@@ -353,7 +353,7 @@ ENTRY(cpu_arm926_dcache_clean_area)
 	bhi	1b
 #endif
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /* =============================== PageTable ============================== */
 
@@ -380,7 +380,7 @@ ENTRY(cpu_arm926_switch_mm)
 	mcr	p15, 0, r0, c2, c0, 0		@ load page table pointer
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
 #endif
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_arm926_set_pte_ext(ptep, pte, ext)
@@ -397,7 +397,7 @@ ENTRY(cpu_arm926_set_pte_ext)
 #endif
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 #endif
-	mov	pc, lr
+	ret	lr
 
 /* Suspend/resume support: taken from arch/arm/plat-s3c24xx/sleep.S */
 .globl	cpu_arm926_suspend_size
@@ -448,7 +448,7 @@ __arm926_setup:
 #ifdef CONFIG_CPU_CACHE_ROUND_ROBIN
 	orr	r0, r0, #0x4000			@ .1.. .... .... ....
 #endif
-	mov	pc, lr
+	ret	lr
 	.size	__arm926_setup, . - __arm926_setup
 
 	/*
diff --git a/arch/arm/mm/proc-arm940.S b/arch/arm/mm/proc-arm940.S
index 1c39a704ff6e..e5212d489377 100644
--- a/arch/arm/mm/proc-arm940.S
+++ b/arch/arm/mm/proc-arm940.S
@@ -31,7 +31,7 @@
  */
 ENTRY(cpu_arm940_proc_init)
 ENTRY(cpu_arm940_switch_mm)
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_arm940_proc_fin()
@@ -41,7 +41,7 @@ ENTRY(cpu_arm940_proc_fin)
 	bic	r0, r0, #0x00001000		@ i-cache
 	bic	r0, r0, #0x00000004		@ d-cache
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_arm940_reset(loc)
@@ -58,7 +58,7 @@ ENTRY(cpu_arm940_reset)
 	bic	ip, ip, #0x00000005		@ .............c.p
 	bic	ip, ip, #0x00001000		@ i-cache
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_arm940_reset)
 	.popsection
 
@@ -68,7 +68,7 @@ ENDPROC(cpu_arm940_reset)
 	.align	5
 ENTRY(cpu_arm940_do_idle)
 	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_icache_all()
@@ -78,7 +78,7 @@ ENTRY(cpu_arm940_do_idle)
 ENTRY(arm940_flush_icache_all)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
+	ret	lr
 ENDPROC(arm940_flush_icache_all)
 
 /*
@@ -122,7 +122,7 @@ ENTRY(arm940_flush_user_cache_range)
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_kern_range(start, end)
@@ -170,7 +170,7 @@ ENTRY(arm940_flush_kern_dcache_area)
 	bcs	1b				@ segments 7 to 0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_inv_range(start, end)
@@ -191,7 +191,7 @@ arm940_dma_inv_range:
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
 	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_clean_range(start, end)
@@ -215,7 +215,7 @@ ENTRY(cpu_arm940_dcache_clean_area)
 	bcs	1b				@ segments 7 to 0
 #endif
 	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_flush_range(start, end)
@@ -241,7 +241,7 @@ ENTRY(arm940_dma_flush_range)
 	subs	r1, r1, #1 << 4
 	bcs	1b				@ segments 7 to 0
 	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_map_area(start, size, dir)
@@ -264,7 +264,7 @@ ENDPROC(arm940_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(arm940_dma_unmap_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(arm940_dma_unmap_area)
 
 	.globl	arm940_flush_kern_cache_louis
@@ -337,7 +337,7 @@ __arm940_setup:
 	orr	r0, r0, #0x00001000		@ I-cache
 	orr	r0, r0, #0x00000005		@ MPU/D-cache
 
-	mov	pc, lr
+	ret	lr
 
 	.size	__arm940_setup, . - __arm940_setup
 
diff --git a/arch/arm/mm/proc-arm946.S b/arch/arm/mm/proc-arm946.S
index 0289cd905e73..b3dd9b2d0b8e 100644
--- a/arch/arm/mm/proc-arm946.S
+++ b/arch/arm/mm/proc-arm946.S
@@ -38,7 +38,7 @@
  */
 ENTRY(cpu_arm946_proc_init)
 ENTRY(cpu_arm946_switch_mm)
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_arm946_proc_fin()
@@ -48,7 +48,7 @@ ENTRY(cpu_arm946_proc_fin)
 	bic	r0, r0, #0x00001000		@ i-cache
 	bic	r0, r0, #0x00000004		@ d-cache
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_arm946_reset(loc)
@@ -65,7 +65,7 @@ ENTRY(cpu_arm946_reset)
 	bic	ip, ip, #0x00000005		@ .............c.p
 	bic	ip, ip, #0x00001000		@ i-cache
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_arm946_reset)
 	.popsection
 
@@ -75,7 +75,7 @@ ENDPROC(cpu_arm946_reset)
 	.align	5
 ENTRY(cpu_arm946_do_idle)
 	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_icache_all()
@@ -85,7 +85,7 @@ ENTRY(cpu_arm946_do_idle)
 ENTRY(arm946_flush_icache_all)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
+	ret	lr
 ENDPROC(arm946_flush_icache_all)
 
 /*
@@ -117,7 +117,7 @@ __flush_whole_cache:
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c5, 0		@ flush I cache
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_user_cache_range(start, end, flags)
@@ -156,7 +156,7 @@ ENTRY(arm946_flush_user_cache_range)
 	blo	1b
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_kern_range(start, end)
@@ -191,7 +191,7 @@ ENTRY(arm946_coherent_user_range)
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	r0, #0
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_kern_dcache_area(void *addr, size_t size)
@@ -212,7 +212,7 @@ ENTRY(arm946_flush_kern_dcache_area)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_inv_range(start, end)
@@ -239,7 +239,7 @@ arm946_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_clean_range(start, end)
@@ -260,7 +260,7 @@ arm946_dma_clean_range:
 	blo	1b
 #endif
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_flush_range(start, end)
@@ -284,7 +284,7 @@ ENTRY(arm946_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_map_area(start, size, dir)
@@ -307,7 +307,7 @@ ENDPROC(arm946_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(arm946_dma_unmap_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(arm946_dma_unmap_area)
 
 	.globl	arm946_flush_kern_cache_louis
@@ -324,7 +324,7 @@ ENTRY(cpu_arm946_dcache_clean_area)
 	bhi	1b
 #endif
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 	.type	__arm946_setup, #function
 __arm946_setup:
@@ -392,7 +392,7 @@ __arm946_setup:
 #ifdef CONFIG_CPU_CACHE_ROUND_ROBIN
 	orr	r0, r0, #0x00004000		@ .1.. .... .... ....
 #endif
-	mov	pc, lr
+	ret	lr
 
 	.size	__arm946_setup, . - __arm946_setup
 
diff --git a/arch/arm/mm/proc-arm9tdmi.S b/arch/arm/mm/proc-arm9tdmi.S
index f51197ba754a..8227322bbb8f 100644
--- a/arch/arm/mm/proc-arm9tdmi.S
+++ b/arch/arm/mm/proc-arm9tdmi.S
@@ -32,13 +32,13 @@ ENTRY(cpu_arm9tdmi_proc_init)
 ENTRY(cpu_arm9tdmi_do_idle)
 ENTRY(cpu_arm9tdmi_dcache_clean_area)
 ENTRY(cpu_arm9tdmi_switch_mm)
-		mov	pc, lr
+		ret	lr
 
 /*
  * cpu_arm9tdmi_proc_fin()
  */
 ENTRY(cpu_arm9tdmi_proc_fin)
-		mov	pc, lr
+		ret	lr
 
 /*
  * Function: cpu_arm9tdmi_reset(loc)
@@ -47,13 +47,13 @@ ENTRY(cpu_arm9tdmi_proc_fin)
  */
 		.pushsection	.idmap.text, "ax"
 ENTRY(cpu_arm9tdmi_reset)
-		mov	pc, r0
+		ret	r0
 ENDPROC(cpu_arm9tdmi_reset)
 		.popsection
 
 		.type	__arm9tdmi_setup, #function
 __arm9tdmi_setup:
-		mov	pc, lr
+		ret	lr
 		.size	__arm9tdmi_setup, . - __arm9tdmi_setup
 
 		__INITDATA
diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
index 2dfc0f1d3bfd..c494886892ba 100644
--- a/arch/arm/mm/proc-fa526.S
+++ b/arch/arm/mm/proc-fa526.S
@@ -32,7 +32,7 @@
  * cpu_fa526_proc_init()
  */
 ENTRY(cpu_fa526_proc_init)
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_fa526_proc_fin()
@@ -44,7 +44,7 @@ ENTRY(cpu_fa526_proc_fin)
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
 	nop
 	nop
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_fa526_reset(loc)
@@ -72,7 +72,7 @@ ENTRY(cpu_fa526_reset)
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
 	nop
 	nop
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_fa526_reset)
 	.popsection
 
@@ -81,7 +81,7 @@ ENDPROC(cpu_fa526_reset)
  */
 	.align	4
 ENTRY(cpu_fa526_do_idle)
-	mov	pc, lr
+	ret	lr
 
 
 ENTRY(cpu_fa526_dcache_clean_area)
@@ -90,7 +90,7 @@ ENTRY(cpu_fa526_dcache_clean_area)
 	subs	r1, r1, #CACHE_DLINESIZE
 	bhi	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /* =============================== PageTable ============================== */
 
@@ -117,7 +117,7 @@ ENTRY(cpu_fa526_switch_mm)
 	mcr	p15, 0, r0, c2, c0, 0		@ load page table pointer
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate UTLB
 #endif
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_fa526_set_pte_ext(ptep, pte, ext)
@@ -133,7 +133,7 @@ ENTRY(cpu_fa526_set_pte_ext)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 #endif
-	mov	pc, lr
+	ret	lr
 
 	.type	__fa526_setup, #function
 __fa526_setup:
@@ -162,7 +162,7 @@ __fa526_setup:
 	bic	r0, r0, r5
 	ldr	r5, fa526_cr1_set
 	orr	r0, r0, r5
-	mov	pc, lr
+	ret	lr
 	.size	__fa526_setup, . - __fa526_setup
 
 	/*
diff --git a/arch/arm/mm/proc-feroceon.S b/arch/arm/mm/proc-feroceon.S
index db79b62c92fb..03a1b75f2e16 100644
--- a/arch/arm/mm/proc-feroceon.S
+++ b/arch/arm/mm/proc-feroceon.S
@@ -69,7 +69,7 @@ ENTRY(cpu_feroceon_proc_init)
 	movne	r2, r2, lsr #2			@ turned into # of sets
 	sub	r2, r2, #(1 << 5)
 	stmia	r1, {r2, r3}
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_feroceon_proc_fin()
@@ -86,7 +86,7 @@ ENTRY(cpu_feroceon_proc_fin)
 	bic	r0, r0, #0x1000			@ ...i............
 	bic	r0, r0, #0x000e			@ ............wca.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_feroceon_reset(loc)
@@ -110,7 +110,7 @@ ENTRY(cpu_feroceon_reset)
 	bic	ip, ip, #0x000f			@ ............wcam
 	bic	ip, ip, #0x1100			@ ...i...s........
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_feroceon_reset)
 	.popsection
 
@@ -124,7 +124,7 @@ ENTRY(cpu_feroceon_do_idle)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c10, 4		@ Drain write buffer
 	mcr	p15, 0, r0, c7, c0, 4		@ Wait for interrupt
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_icache_all()
@@ -134,7 +134,7 @@ ENTRY(cpu_feroceon_do_idle)
 ENTRY(feroceon_flush_icache_all)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
+	ret	lr
 ENDPROC(feroceon_flush_icache_all)
 
 /*
@@ -169,7 +169,7 @@ __flush_whole_cache:
 	mov	ip, #0
 	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_user_cache_range(start, end, flags)
@@ -198,7 +198,7 @@ ENTRY(feroceon_flush_user_cache_range)
 	tst	r2, #VM_EXEC
 	mov	ip, #0
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_kern_range(start, end)
@@ -233,7 +233,7 @@ ENTRY(feroceon_coherent_user_range)
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	r0, #0
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_kern_dcache_area(void *addr, size_t size)
@@ -254,7 +254,7 @@ ENTRY(feroceon_flush_kern_dcache_area)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 	.align	5
 ENTRY(feroceon_range_flush_kern_dcache_area)
@@ -268,7 +268,7 @@ ENTRY(feroceon_range_flush_kern_dcache_area)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_inv_range(start, end)
@@ -295,7 +295,7 @@ feroceon_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 	.align	5
 feroceon_range_dma_inv_range:
@@ -311,7 +311,7 @@ feroceon_range_dma_inv_range:
 	mcr	p15, 5, r0, c15, c14, 0		@ D inv range start
 	mcr	p15, 5, r1, c15, c14, 1		@ D inv range top
 	msr	cpsr_c, r2			@ restore interrupts
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_clean_range(start, end)
@@ -331,7 +331,7 @@ feroceon_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 	.align	5
 feroceon_range_dma_clean_range:
@@ -344,7 +344,7 @@ feroceon_range_dma_clean_range:
 	mcr	p15, 5, r1, c15, c13, 1		@ D clean range top
 	msr	cpsr_c, r2			@ restore interrupts
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_flush_range(start, end)
@@ -362,7 +362,7 @@ ENTRY(feroceon_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 	.align	5
 ENTRY(feroceon_range_dma_flush_range)
@@ -375,7 +375,7 @@ ENTRY(feroceon_range_dma_flush_range)
 	mcr	p15, 5, r1, c15, c15, 1		@ D clean/inv range top
 	msr	cpsr_c, r2			@ restore interrupts
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_map_area(start, size, dir)
@@ -412,7 +412,7 @@ ENDPROC(feroceon_range_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(feroceon_dma_unmap_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(feroceon_dma_unmap_area)
 
 	.globl	feroceon_flush_kern_cache_louis
@@ -461,7 +461,7 @@ ENTRY(cpu_feroceon_dcache_clean_area)
 	bhi	1b
 #endif
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /* =============================== PageTable ============================== */
 
@@ -490,9 +490,9 @@ ENTRY(cpu_feroceon_switch_mm)
 
 	mcr	p15, 0, r0, c2, c0, 0		@ load page table pointer
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
-	mov	pc, r2
+	ret	r2
 #else
-	mov	pc, lr
+	ret	lr
 #endif
 
 /*
@@ -512,7 +512,7 @@ ENTRY(cpu_feroceon_set_pte_ext)
 #endif
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 #endif
-	mov	pc, lr
+	ret	lr
 
 /* Suspend/resume support: taken from arch/arm/mm/proc-arm926.S */
 .globl	cpu_feroceon_suspend_size
@@ -554,7 +554,7 @@ __feroceon_setup:
 	mrc	p15, 0, r0, c1, c0		@ get control register v4
 	bic	r0, r0, r5
 	orr	r0, r0, r6
-	mov	pc, lr
+	ret	lr
 	.size	__feroceon_setup, . - __feroceon_setup
 
 	/*
diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index 40acba595731..53d393455f13 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -45,7 +45,7 @@
  * cpu_mohawk_proc_init()
  */
 ENTRY(cpu_mohawk_proc_init)
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_mohawk_proc_fin()
@@ -55,7 +55,7 @@ ENTRY(cpu_mohawk_proc_fin)
 	bic	r0, r0, #0x1800			@ ...iz...........
 	bic	r0, r0, #0x0006			@ .............ca.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_mohawk_reset(loc)
@@ -79,7 +79,7 @@ ENTRY(cpu_mohawk_reset)
 	bic	ip, ip, #0x0007			@ .............cam
 	bic	ip, ip, #0x1100			@ ...i...s........
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_mohawk_reset)
 	.popsection
 
@@ -93,7 +93,7 @@ ENTRY(cpu_mohawk_do_idle)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
 	mcr	p15, 0, r0, c7, c0, 4		@ wait for interrupt
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_icache_all()
@@ -103,7 +103,7 @@ ENTRY(cpu_mohawk_do_idle)
 ENTRY(mohawk_flush_icache_all)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
+	ret	lr
 ENDPROC(mohawk_flush_icache_all)
 
 /*
@@ -128,7 +128,7 @@ __flush_whole_cache:
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate I cache
 	mcrne	p15, 0, ip, c7, c10, 0		@ drain write buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_user_cache_range(start, end, flags)
@@ -158,7 +158,7 @@ ENTRY(mohawk_flush_user_cache_range)
 	blo	1b
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_kern_range(start, end)
@@ -194,7 +194,7 @@ ENTRY(mohawk_coherent_user_range)
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	r0, #0
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_kern_dcache_area(void *addr, size_t size)
@@ -214,7 +214,7 @@ ENTRY(mohawk_flush_kern_dcache_area)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_inv_range(start, end)
@@ -240,7 +240,7 @@ mohawk_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_clean_range(start, end)
@@ -259,7 +259,7 @@ mohawk_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_flush_range(start, end)
@@ -277,7 +277,7 @@ ENTRY(mohawk_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_map_area(start, size, dir)
@@ -300,7 +300,7 @@ ENDPROC(mohawk_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(mohawk_dma_unmap_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(mohawk_dma_unmap_area)
 
 	.globl	mohawk_flush_kern_cache_louis
@@ -315,7 +315,7 @@ ENTRY(cpu_mohawk_dcache_clean_area)
 	subs	r1, r1, #CACHE_DLINESIZE
 	bhi	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_mohawk_switch_mm(pgd)
@@ -333,7 +333,7 @@ ENTRY(cpu_mohawk_switch_mm)
 	orr	r0, r0, #0x18			@ cache the page table in L2
 	mcr	p15, 0, r0, c2, c0, 0		@ load page table pointer
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_mohawk_set_pte_ext(ptep, pte, ext)
@@ -346,7 +346,7 @@ ENTRY(cpu_mohawk_set_pte_ext)
 	mov	r0, r0
 	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
-	mov	pc, lr
+	ret	lr
 
 .globl	cpu_mohawk_suspend_size
 .equ	cpu_mohawk_suspend_size, 4 * 6
@@ -400,7 +400,7 @@ __mohawk_setup:
 	mrc	p15, 0, r0, c1, c0		@ get control register
 	bic	r0, r0, r5
 	orr	r0, r0, r6
-	mov	pc, lr
+	ret	lr
 
 	.size	__mohawk_setup, . - __mohawk_setup
 
diff --git a/arch/arm/mm/proc-sa110.S b/arch/arm/mm/proc-sa110.S
index c45319c8f1d9..8008a0461cf5 100644
--- a/arch/arm/mm/proc-sa110.S
+++ b/arch/arm/mm/proc-sa110.S
@@ -38,7 +38,7 @@
 ENTRY(cpu_sa110_proc_init)
 	mov	r0, #0
 	mcr	p15, 0, r0, c15, c1, 2		@ Enable clock switching
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_sa110_proc_fin()
@@ -50,7 +50,7 @@ ENTRY(cpu_sa110_proc_fin)
 	bic	r0, r0, #0x1000			@ ...i............
 	bic	r0, r0, #0x000e			@ ............wca.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_sa110_reset(loc)
@@ -74,7 +74,7 @@ ENTRY(cpu_sa110_reset)
 	bic	ip, ip, #0x000f			@ ............wcam
 	bic	ip, ip, #0x1100			@ ...i...s........
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_sa110_reset)
 	.popsection
 
@@ -103,7 +103,7 @@ ENTRY(cpu_sa110_do_idle)
 	mov	r0, r0				@ safety
 	mov	r0, r0				@ safety
 	mcr	p15, 0, r0, c15, c1, 2		@ enable clock switching
-	mov	pc, lr
+	ret	lr
 
 /* ================================= CACHE ================================ */
 
@@ -121,7 +121,7 @@ ENTRY(cpu_sa110_dcache_clean_area)
 	add	r0, r0, #DCACHELINESIZE
 	subs	r1, r1, #DCACHELINESIZE
 	bhi	1b
-	mov	pc, lr
+	ret	lr
 
 /* =============================== PageTable ============================== */
 
@@ -141,7 +141,7 @@ ENTRY(cpu_sa110_switch_mm)
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
 	ldr	pc, [sp], #4
 #else
-	mov	pc, lr
+	ret	lr
 #endif
 
 /*
@@ -157,7 +157,7 @@ ENTRY(cpu_sa110_set_pte_ext)
 	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 #endif
-	mov	pc, lr
+	ret	lr
 
 	.type	__sa110_setup, #function
 __sa110_setup:
@@ -173,7 +173,7 @@ __sa110_setup:
 	mrc	p15, 0, r0, c1, c0		@ get control register v4
 	bic	r0, r0, r5
 	orr	r0, r0, r6
-	mov	pc, lr
+	ret	lr
 	.size	__sa110_setup, . - __sa110_setup
 
 	/*
diff --git a/arch/arm/mm/proc-sa1100.S b/arch/arm/mm/proc-sa1100.S
index 09d241ae2dbe..89f97ac648a9 100644
--- a/arch/arm/mm/proc-sa1100.S
+++ b/arch/arm/mm/proc-sa1100.S
@@ -43,7 +43,7 @@ ENTRY(cpu_sa1100_proc_init)
 	mov	r0, #0
 	mcr	p15, 0, r0, c15, c1, 2		@ Enable clock switching
 	mcr	p15, 0, r0, c9, c0, 5		@ Allow read-buffer operations from userland
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_sa1100_proc_fin()
@@ -58,7 +58,7 @@ ENTRY(cpu_sa1100_proc_fin)
 	bic	r0, r0, #0x1000			@ ...i............
 	bic	r0, r0, #0x000e			@ ............wca.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_sa1100_reset(loc)
@@ -82,7 +82,7 @@ ENTRY(cpu_sa1100_reset)
 	bic	ip, ip, #0x000f			@ ............wcam
 	bic	ip, ip, #0x1100			@ ...i...s........
 	mcr	p15, 0, ip, c1, c0, 0		@ ctrl register
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_sa1100_reset)
 	.popsection
 
@@ -113,7 +113,7 @@ ENTRY(cpu_sa1100_do_idle)
 	mcr	p15, 0, r0, c15, c8, 2		@ wait for interrupt
 	mov	r0, r0				@ safety
 	mcr	p15, 0, r0, c15, c1, 2		@ enable clock switching
-	mov	pc, lr
+	ret	lr
 
 /* ================================= CACHE ================================ */
 
@@ -131,7 +131,7 @@ ENTRY(cpu_sa1100_dcache_clean_area)
 	add	r0, r0, #DCACHELINESIZE
 	subs	r1, r1, #DCACHELINESIZE
 	bhi	1b
-	mov	pc, lr
+	ret	lr
 
 /* =============================== PageTable ============================== */
 
@@ -152,7 +152,7 @@ ENTRY(cpu_sa1100_switch_mm)
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
 	ldr	pc, [sp], #4
 #else
-	mov	pc, lr
+	ret	lr
 #endif
 
 /*
@@ -168,7 +168,7 @@ ENTRY(cpu_sa1100_set_pte_ext)
 	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 #endif
-	mov	pc, lr
+	ret	lr
 
 .globl	cpu_sa1100_suspend_size
 .equ	cpu_sa1100_suspend_size, 4 * 3
@@ -211,7 +211,7 @@ __sa1100_setup:
 	mrc	p15, 0, r0, c1, c0		@ get control register v4
 	bic	r0, r0, r5
 	orr	r0, r0, r6
-	mov	pc, lr
+	ret	lr
 	.size	__sa1100_setup, . - __sa1100_setup
 
 	/*
diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index 32b3558321c4..d0390f4b3f18 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -36,14 +36,14 @@
 #define PMD_FLAGS_SMP	PMD_SECT_WBWA|PMD_SECT_S
 
 ENTRY(cpu_v6_proc_init)
-	mov	pc, lr
+	ret	lr
 
 ENTRY(cpu_v6_proc_fin)
 	mrc	p15, 0, r0, c1, c0, 0		@ ctrl register
 	bic	r0, r0, #0x1000			@ ...i............
 	bic	r0, r0, #0x0006			@ .............ca.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  *	cpu_v6_reset(loc)
@@ -62,7 +62,7 @@ ENTRY(cpu_v6_reset)
 	mcr	p15, 0, r1, c1, c0, 0		@ disable MMU
 	mov	r1, #0
 	mcr	p15, 0, r1, c7, c5, 4		@ ISB
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_v6_reset)
 	.popsection
 
@@ -77,14 +77,14 @@ ENTRY(cpu_v6_do_idle)
 	mov	r1, #0
 	mcr	p15, 0, r1, c7, c10, 4		@ DWB - WFI may enter a low-power mode
 	mcr	p15, 0, r1, c7, c0, 4		@ wait for interrupt
-	mov	pc, lr
+	ret	lr
 
 ENTRY(cpu_v6_dcache_clean_area)
 1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
 	add	r0, r0, #D_CACHE_LINE_SIZE
 	subs	r1, r1, #D_CACHE_LINE_SIZE
 	bhi	1b
-	mov	pc, lr
+	ret	lr
 
 /*
  *	cpu_v6_switch_mm(pgd_phys, tsk)
@@ -113,7 +113,7 @@ ENTRY(cpu_v6_switch_mm)
 #endif
 	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
 #endif
-	mov	pc, lr
+	ret	lr
 
 /*
  *	cpu_v6_set_pte_ext(ptep, pte, ext)
@@ -131,7 +131,7 @@ ENTRY(cpu_v6_set_pte_ext)
 #ifdef CONFIG_MMU
 	armv6_set_pte_ext cpu_v6
 #endif
-	mov	pc, lr
+	ret	lr
 
 /* Suspend/resume support: taken from arch/arm/mach-s3c64xx/sleep.S */
 .globl	cpu_v6_suspend_size
@@ -241,7 +241,7 @@ __v6_setup:
 	mcreq	p15, 0, r5, c1, c0, 1		@ write aux control reg
 	orreq	r0, r0, #(1 << 21)		@ low interrupt latency configuration
 #endif
-	mov	pc, lr				@ return to head.S:__ret
+	ret	lr				@ return to head.S:__ret
 
 	/*
 	 *         V X F   I D LR
diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index 1f52915f2b28..ed448d8a596b 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -59,7 +59,7 @@ ENTRY(cpu_v7_switch_mm)
 	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
 	isb
 #endif
-	mov	pc, lr
+	bx	lr
 ENDPROC(cpu_v7_switch_mm)
 
 /*
@@ -106,7 +106,7 @@ ENTRY(cpu_v7_set_pte_ext)
 	ALT_SMP(W(nop))
 	ALT_UP (mcr	p15, 0, r0, c7, c10, 1)		@ flush_pte
 #endif
-	mov	pc, lr
+	bx	lr
 ENDPROC(cpu_v7_set_pte_ext)
 
 	/*
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 22e3ad63500c..564f4b934ceb 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -19,6 +19,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
+#include <asm/assembler.h>
 
 #define TTB_IRGN_NC	(0 << 8)
 #define TTB_IRGN_WBWA	(1 << 8)
@@ -61,7 +62,7 @@ ENTRY(cpu_v7_switch_mm)
 	mcrr	p15, 0, rpgdl, rpgdh, c2		@ set TTB 0
 	isb
 #endif
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7_switch_mm)
 
 #ifdef __ARMEB__
@@ -92,7 +93,7 @@ ENTRY(cpu_v7_set_pte_ext)
 	ALT_SMP(W(nop))
 	ALT_UP (mcr	p15, 0, r0, c7, c10, 1)		@ flush_pte
 #endif
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7_set_pte_ext)
 
 	/*
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 3db2c2f04a30..71abb60c4222 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -26,7 +26,7 @@
 #endif
 
 ENTRY(cpu_v7_proc_init)
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7_proc_init)
 
 ENTRY(cpu_v7_proc_fin)
@@ -34,7 +34,7 @@ ENTRY(cpu_v7_proc_fin)
 	bic	r0, r0, #0x1000			@ ...i............
 	bic	r0, r0, #0x0006			@ .............ca.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7_proc_fin)
 
 /*
@@ -71,20 +71,20 @@ ENDPROC(cpu_v7_reset)
 ENTRY(cpu_v7_do_idle)
 	dsb					@ WFI may enter a low-power mode
 	wfi
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7_do_idle)
 
 ENTRY(cpu_v7_dcache_clean_area)
 	ALT_SMP(W(nop))			@ MP extensions imply L1 PTW
 	ALT_UP_B(1f)
-	mov	pc, lr
+	ret	lr
 1:	dcache_line_size r2, r3
 2:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
 	add	r0, r0, r2
 	subs	r1, r1, r2
 	bhi	2b
 	dsb	ishst
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7_dcache_clean_area)
 
 	string	cpu_v7_name, "ARMv7 Processor"
@@ -163,7 +163,7 @@ ENTRY(cpu_pj4b_do_idle)
 	dsb					@ WFI may enter a low-power mode
 	wfi
 	dsb					@barrier
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_pj4b_do_idle)
 #else
 	globl_equ	cpu_pj4b_do_idle,  	cpu_v7_do_idle
@@ -407,7 +407,7 @@ __v7_setup:
 	bic	r0, r0, r5			@ clear bits them
 	orr	r0, r0, r6			@ set them
  THUMB(	orr	r0, r0, #1 << 30	)	@ Thumb exceptions
-	mov	pc, lr				@ return to head.S:__ret
+	ret	lr				@ return to head.S:__ret
 ENDPROC(__v7_setup)
 
 	.align	2
diff --git a/arch/arm/mm/proc-v7m.S b/arch/arm/mm/proc-v7m.S
index 1ca37c72f12f..d1e68b553d3b 100644
--- a/arch/arm/mm/proc-v7m.S
+++ b/arch/arm/mm/proc-v7m.S
@@ -16,11 +16,11 @@
 #include "proc-macros.S"
 
 ENTRY(cpu_v7m_proc_init)
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7m_proc_init)
 
 ENTRY(cpu_v7m_proc_fin)
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7m_proc_fin)
 
 /*
@@ -34,7 +34,7 @@ ENDPROC(cpu_v7m_proc_fin)
  */
 	.align	5
 ENTRY(cpu_v7m_reset)
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_v7m_reset)
 
 /*
@@ -46,18 +46,18 @@ ENDPROC(cpu_v7m_reset)
  */
 ENTRY(cpu_v7m_do_idle)
 	wfi
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7m_do_idle)
 
 ENTRY(cpu_v7m_dcache_clean_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7m_dcache_clean_area)
 
 /*
  * There is no MMU, so here is nothing to do.
  */
 ENTRY(cpu_v7m_switch_mm)
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7m_switch_mm)
 
 .globl	cpu_v7m_suspend_size
@@ -65,11 +65,11 @@ ENDPROC(cpu_v7m_switch_mm)
 
 #ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_v7m_do_suspend)
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7m_do_suspend)
 
 ENTRY(cpu_v7m_do_resume)
-	mov	pc, lr
+	ret	lr
 ENDPROC(cpu_v7m_do_resume)
 #endif
 
@@ -120,7 +120,7 @@ __v7m_setup:
 	ldr	r12, [r0, V7M_SCB_CCR]	@ system control register
 	orr	r12, #V7M_SCB_CCR_STKALIGN
 	str	r12, [r0, V7M_SCB_CCR]
-	mov	pc, lr
+	ret	lr
 ENDPROC(__v7m_setup)
 
 	.align 2
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index dc1645890042..f8acdfece036 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -83,7 +83,7 @@
  * Nothing too exciting at the moment
  */
 ENTRY(cpu_xsc3_proc_init)
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_xsc3_proc_fin()
@@ -93,7 +93,7 @@ ENTRY(cpu_xsc3_proc_fin)
 	bic	r0, r0, #0x1800			@ ...IZ...........
 	bic	r0, r0, #0x0006			@ .............CA.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_xsc3_reset(loc)
@@ -119,7 +119,7 @@ ENTRY(cpu_xsc3_reset)
 	@ CAUTION: MMU turned off from this point.  We count on the pipeline
 	@ already containing those two last instructions to survive.
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I and D TLBs
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_xsc3_reset)
 	.popsection
 
@@ -138,7 +138,7 @@ ENDPROC(cpu_xsc3_reset)
 ENTRY(cpu_xsc3_do_idle)
 	mov	r0, #1
 	mcr	p14, 0, r0, c7, c0, 0		@ go to idle
-	mov	pc, lr
+	ret	lr
 
 /* ================================= CACHE ================================ */
 
@@ -150,7 +150,7 @@ ENTRY(cpu_xsc3_do_idle)
 ENTRY(xsc3_flush_icache_all)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
+	ret	lr
 ENDPROC(xsc3_flush_icache_all)
 
 /*
@@ -176,7 +176,7 @@ __flush_whole_cache:
 	mcrne	p15, 0, ip, c7, c5, 0		@ invalidate L1 I cache and BTB
 	mcrne	p15, 0, ip, c7, c10, 4		@ data write barrier
 	mcrne	p15, 0, ip, c7, c5, 4		@ prefetch flush
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_user_cache_range(start, end, vm_flags)
@@ -205,7 +205,7 @@ ENTRY(xsc3_flush_user_cache_range)
 	mcrne	p15, 0, ip, c7, c5, 6		@ invalidate BTB
 	mcrne	p15, 0, ip, c7, c10, 4		@ data write barrier
 	mcrne	p15, 0, ip, c7, c5, 4		@ prefetch flush
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_kern_range(start, end)
@@ -232,7 +232,7 @@ ENTRY(xsc3_coherent_user_range)
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate L1 I cache and BTB
 	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mcr	p15, 0, r0, c7, c5, 4		@ prefetch flush
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_kern_dcache_area(void *addr, size_t size)
@@ -253,7 +253,7 @@ ENTRY(xsc3_flush_kern_dcache_area)
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate L1 I cache and BTB
 	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
 	mcr	p15, 0, r0, c7, c5, 4		@ prefetch flush
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_inv_range(start, end)
@@ -277,7 +277,7 @@ xsc3_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_clean_range(start, end)
@@ -294,7 +294,7 @@ xsc3_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_flush_range(start, end)
@@ -311,7 +311,7 @@ ENTRY(xsc3_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_map_area(start, size, dir)
@@ -334,7 +334,7 @@ ENDPROC(xsc3_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(xsc3_dma_unmap_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(xsc3_dma_unmap_area)
 
 	.globl	xsc3_flush_kern_cache_louis
@@ -348,7 +348,7 @@ ENTRY(cpu_xsc3_dcache_clean_area)
 	add	r0, r0, #CACHELINESIZE
 	subs	r1, r1, #CACHELINESIZE
 	bhi	1b
-	mov	pc, lr
+	ret	lr
 
 /* =============================== PageTable ============================== */
 
@@ -406,7 +406,7 @@ ENTRY(cpu_xsc3_set_pte_ext)
 	orr	r2, r2, ip
 
 	xscale_set_pte_ext_epilogue
-	mov	pc, lr
+	ret	lr
 
 	.ltorg
 	.align
@@ -478,7 +478,7 @@ __xsc3_setup:
 	bic	r0, r0, r5			@ ..V. ..R. .... ..A.
 	orr	r0, r0, r6			@ ..VI Z..S .... .C.M (mmu)
 						@ ...I Z..S .... .... (uc)
-	mov	pc, lr
+	ret	lr
 
 	.size	__xsc3_setup, . - __xsc3_setup
 
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index d19b1cfcad91..23259f104c66 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -118,7 +118,7 @@ ENTRY(cpu_xscale_proc_init)
 	mrc	p15, 0, r1, c1, c0, 1
 	bic	r1, r1, #1
 	mcr	p15, 0, r1, c1, c0, 1
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_xscale_proc_fin()
@@ -128,7 +128,7 @@ ENTRY(cpu_xscale_proc_fin)
 	bic	r0, r0, #0x1800			@ ...IZ...........
 	bic	r0, r0, #0x0006			@ .............CA.
 	mcr	p15, 0, r0, c1, c0, 0		@ disable caches
-	mov	pc, lr
+	ret	lr
 
 /*
  * cpu_xscale_reset(loc)
@@ -160,7 +160,7 @@ ENTRY(cpu_xscale_reset)
 	@ CAUTION: MMU turned off from this point. We count on the pipeline
 	@ already containing those two last instructions to survive.
 	mcr	p15, 0, ip, c8, c7, 0		@ invalidate I & D TLBs
-	mov	pc, r0
+	ret	r0
 ENDPROC(cpu_xscale_reset)
 	.popsection
 
@@ -179,7 +179,7 @@ ENDPROC(cpu_xscale_reset)
 ENTRY(cpu_xscale_do_idle)
 	mov	r0, #1
 	mcr	p14, 0, r0, c7, c0, 0		@ Go to IDLE
-	mov	pc, lr
+	ret	lr
 
 /* ================================= CACHE ================================ */
 
@@ -191,7 +191,7 @@ ENTRY(cpu_xscale_do_idle)
 ENTRY(xscale_flush_icache_all)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ invalidate I cache
-	mov	pc, lr
+	ret	lr
 ENDPROC(xscale_flush_icache_all)
 
 /*
@@ -216,7 +216,7 @@ __flush_whole_cache:
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c5, 0		@ Invalidate I cache & BTB
 	mcrne	p15, 0, ip, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_user_cache_range(start, end, vm_flags)
@@ -245,7 +245,7 @@ ENTRY(xscale_flush_user_cache_range)
 	tst	r2, #VM_EXEC
 	mcrne	p15, 0, ip, c7, c5, 6		@ Invalidate BTB
 	mcrne	p15, 0, ip, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_kern_range(start, end)
@@ -269,7 +269,7 @@ ENTRY(xscale_coherent_kern_range)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ Invalidate I cache & BTB
 	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	coherent_user_range(start, end)
@@ -291,7 +291,7 @@ ENTRY(xscale_coherent_user_range)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 6		@ Invalidate BTB
 	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	flush_kern_dcache_area(void *addr, size_t size)
@@ -312,7 +312,7 @@ ENTRY(xscale_flush_kern_dcache_area)
 	mov	r0, #0
 	mcr	p15, 0, r0, c7, c5, 0		@ Invalidate I cache & BTB
 	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_inv_range(start, end)
@@ -336,7 +336,7 @@ xscale_dma_inv_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_clean_range(start, end)
@@ -353,7 +353,7 @@ xscale_dma_clean_range:
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_flush_range(start, end)
@@ -371,7 +371,7 @@ ENTRY(xscale_dma_flush_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
-	mov	pc, lr
+	ret	lr
 
 /*
  *	dma_map_area(start, size, dir)
@@ -407,7 +407,7 @@ ENDPROC(xscale_80200_A0_A1_dma_map_area)
  *	- dir	- DMA direction
  */
 ENTRY(xscale_dma_unmap_area)
-	mov	pc, lr
+	ret	lr
 ENDPROC(xscale_dma_unmap_area)
 
 	.globl	xscale_flush_kern_cache_louis
@@ -458,7 +458,7 @@ ENTRY(cpu_xscale_dcache_clean_area)
 	add	r0, r0, #CACHELINESIZE
 	subs	r1, r1, #CACHELINESIZE
 	bhi	1b
-	mov	pc, lr
+	ret	lr
 
 /* =============================== PageTable ============================== */
 
@@ -521,7 +521,7 @@ ENTRY(cpu_xscale_set_pte_ext)
 	orr	r2, r2, ip
 
 	xscale_set_pte_ext_epilogue
-	mov	pc, lr
+	ret	lr
 
 	.ltorg
 	.align
@@ -572,7 +572,7 @@ __xscale_setup:
 	mrc	p15, 0, r0, c1, c0, 0		@ get control register
 	bic	r0, r0, r5
 	orr	r0, r0, r6
-	mov	pc, lr
+	ret	lr
 	.size	__xscale_setup, . - __xscale_setup
 
 	/*
diff --git a/arch/arm/mm/tlb-fa.S b/arch/arm/mm/tlb-fa.S
index d3ddcf9a76ca..d2d9ecbe0aac 100644
--- a/arch/arm/mm/tlb-fa.S
+++ b/arch/arm/mm/tlb-fa.S
@@ -18,6 +18,7 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/tlbflush.h>
 #include "proc-macros.S"
@@ -37,7 +38,7 @@ ENTRY(fa_flush_user_tlb_range)
 	vma_vm_mm ip, r2
 	act_mm	r3				@ get current->active_mm
 	eors	r3, ip, r3			@ == mm ?
-	movne	pc, lr				@ no, we dont do anything
+	retne	lr				@ no, we dont do anything
 	mov	r3, #0
 	mcr	p15, 0, r3, c7, c10, 4		@ drain WB
 	bic	r0, r0, #0x0ff
@@ -47,7 +48,7 @@ ENTRY(fa_flush_user_tlb_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, r3, c7, c10, 4		@ data write barrier
-	mov	pc, lr
+	ret	lr
 
 
 ENTRY(fa_flush_kern_tlb_range)
@@ -61,7 +62,7 @@ ENTRY(fa_flush_kern_tlb_range)
 	blo	1b
 	mcr	p15, 0, r3, c7, c10, 4		@ data write barrier
 	mcr	p15, 0, r3, c7, c5, 4		@ prefetch flush (isb)
-	mov	pc, lr
+	ret	lr
 
 	__INITDATA
 
diff --git a/arch/arm/mm/tlb-v4.S b/arch/arm/mm/tlb-v4.S
index 17a025ade573..a2b5dca42048 100644
--- a/arch/arm/mm/tlb-v4.S
+++ b/arch/arm/mm/tlb-v4.S
@@ -14,6 +14,7 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/tlbflush.h>
 #include "proc-macros.S"
@@ -33,7 +34,7 @@ ENTRY(v4_flush_user_tlb_range)
 	vma_vm_mm ip, r2
 	act_mm	r3				@ get current->active_mm
 	eors	r3, ip, r3				@ == mm ?
-	movne	pc, lr				@ no, we dont do anything
+	retne	lr				@ no, we dont do anything
 .v4_flush_kern_tlb_range:
 	bic	r0, r0, #0x0ff
 	bic	r0, r0, #0xf00
@@ -41,7 +42,7 @@ ENTRY(v4_flush_user_tlb_range)
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1
 	blo	1b
-	mov	pc, lr
+	ret	lr
 
 /*
  *	v4_flush_kern_tlb_range(start, end)
diff --git a/arch/arm/mm/tlb-v4wb.S b/arch/arm/mm/tlb-v4wb.S
index c04598fa4d4a..5a093b458dbc 100644
--- a/arch/arm/mm/tlb-v4wb.S
+++ b/arch/arm/mm/tlb-v4wb.S
@@ -14,6 +14,7 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/tlbflush.h>
 #include "proc-macros.S"
@@ -33,7 +34,7 @@ ENTRY(v4wb_flush_user_tlb_range)
 	vma_vm_mm ip, r2
 	act_mm	r3				@ get current->active_mm
 	eors	r3, ip, r3				@ == mm ?
-	movne	pc, lr				@ no, we dont do anything
+	retne	lr				@ no, we dont do anything
 	vma_vm_flags r2, r2
 	mcr	p15, 0, r3, c7, c10, 4		@ drain WB
 	tst	r2, #VM_EXEC
@@ -44,7 +45,7 @@ ENTRY(v4wb_flush_user_tlb_range)
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1
 	blo	1b
-	mov	pc, lr
+	ret	lr
 
 /*
  *	v4_flush_kern_tlb_range(start, end)
@@ -65,7 +66,7 @@ ENTRY(v4wb_flush_kern_tlb_range)
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1
 	blo	1b
-	mov	pc, lr
+	ret	lr
 
 	__INITDATA
 
diff --git a/arch/arm/mm/tlb-v4wbi.S b/arch/arm/mm/tlb-v4wbi.S
index 1f6062b6c1c1..058861548f68 100644
--- a/arch/arm/mm/tlb-v4wbi.S
+++ b/arch/arm/mm/tlb-v4wbi.S
@@ -14,6 +14,7 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/tlbflush.h>
 #include "proc-macros.S"
@@ -32,7 +33,7 @@ ENTRY(v4wbi_flush_user_tlb_range)
 	vma_vm_mm ip, r2
 	act_mm	r3				@ get current->active_mm
 	eors	r3, ip, r3			@ == mm ?
-	movne	pc, lr				@ no, we dont do anything
+	retne	lr				@ no, we dont do anything
 	mov	r3, #0
 	mcr	p15, 0, r3, c7, c10, 4		@ drain WB
 	vma_vm_flags r2, r2
@@ -44,7 +45,7 @@ ENTRY(v4wbi_flush_user_tlb_range)
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1
 	blo	1b
-	mov	pc, lr
+	ret	lr
 
 ENTRY(v4wbi_flush_kern_tlb_range)
 	mov	r3, #0
@@ -56,7 +57,7 @@ ENTRY(v4wbi_flush_kern_tlb_range)
 	add	r0, r0, #PAGE_SZ
 	cmp	r0, r1
 	blo	1b
-	mov	pc, lr
+	ret	lr
 
 	__INITDATA
 
diff --git a/arch/arm/mm/tlb-v6.S b/arch/arm/mm/tlb-v6.S
index eca07f550a0b..6f689be638bd 100644
--- a/arch/arm/mm/tlb-v6.S
+++ b/arch/arm/mm/tlb-v6.S
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/assembler.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
 #include "proc-macros.S"
@@ -55,7 +56,7 @@ ENTRY(v6wbi_flush_user_tlb_range)
 	cmp	r0, r1
 	blo	1b
 	mcr	p15, 0, ip, c7, c10, 4		@ data synchronization barrier
-	mov	pc, lr
+	ret	lr
 
 /*
  *	v6wbi_flush_kern_tlb_range(start,end)
@@ -84,7 +85,7 @@ ENTRY(v6wbi_flush_kern_tlb_range)
 	blo	1b
 	mcr	p15, 0, r2, c7, c10, 4		@ data synchronization barrier
 	mcr	p15, 0, r2, c7, c5, 4		@ prefetch flush (isb)
-	mov	pc, lr
+	ret	lr
 
 	__INIT
 
diff --git a/arch/arm/mm/tlb-v7.S b/arch/arm/mm/tlb-v7.S
index 355308767bae..e5101a3bc57c 100644
--- a/arch/arm/mm/tlb-v7.S
+++ b/arch/arm/mm/tlb-v7.S
@@ -57,7 +57,7 @@ ENTRY(v7wbi_flush_user_tlb_range)
 	cmp	r0, r1
 	blo	1b
 	dsb	ish
-	mov	pc, lr
+	ret	lr
 ENDPROC(v7wbi_flush_user_tlb_range)
 
 /*
@@ -86,7 +86,7 @@ ENTRY(v7wbi_flush_kern_tlb_range)
 	blo	1b
 	dsb	ish
 	isb
-	mov	pc, lr
+	ret	lr
 ENDPROC(v7wbi_flush_kern_tlb_range)
 
 	__INIT
diff --git a/arch/arm/nwfpe/entry.S b/arch/arm/nwfpe/entry.S
index d18dde95b8aa..5d65be1f1e8a 100644
--- a/arch/arm/nwfpe/entry.S
+++ b/arch/arm/nwfpe/entry.S
@@ -19,7 +19,7 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
-
+#include <asm/assembler.h>
 #include <asm/opcodes.h>
 
 /* This is the kernel's entry point into the floating point emulator.
@@ -92,7 +92,7 @@ emulate:
 	mov	r0, r6			@ prepare for EmulateAll()
 	bl	EmulateAll		@ emulate the instruction
 	cmp	r0, #0			@ was emulation successful
-	moveq	pc, r4			@ no, return failure
+	reteq	r4			@ no, return failure
 
 next:
 .Lx1:	ldrt	r6, [r5], #4		@ get the next instruction and
@@ -102,7 +102,7 @@ next:
 	teq	r2, #0x0C000000
 	teqne	r2, #0x0D000000
 	teqne	r2, #0x0E000000
-	movne	pc, r9			@ return ok if not a fp insn
+	retne	r9			@ return ok if not a fp insn
 
 	str	r5, [sp, #S_PC]		@ update PC copy in regs
 
@@ -115,7 +115,7 @@ next:
 	@ plain LDR instruction.  Weird, but it seems harmless.
 	.pushsection .fixup,"ax"
 	.align	2
-.Lfix:	mov	pc, r9			@ let the user eat segfaults
+.Lfix:	ret	r9			@ let the user eat segfaults
 	.popsection
 
 	.pushsection __ex_table,"a"
diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index fe6ca574d093..2e78760f3495 100644
--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -34,7 +34,7 @@ ENDPROC(do_vfp)
 
 ENTRY(vfp_null_entry)
 	dec_preempt_count_ti r10, r4
-	mov	pc, lr
+	ret	lr
 ENDPROC(vfp_null_entry)
 
 	.align	2
@@ -49,7 +49,7 @@ ENTRY(vfp_testing_entry)
 	dec_preempt_count_ti r10, r4
 	ldr	r0, VFP_arch_address
 	str	r0, [r0]		@ set to non-zero value
-	mov	pc, r9			@ we have handled the fault
+	ret	r9			@ we have handled the fault
 ENDPROC(vfp_testing_entry)
 
 	.align	2
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index be807625ed8c..cda654cbf2c2 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -183,7 +183,7 @@ vfp_hw_state_valid:
 					@ always subtract 4 from the following
 					@ instruction address.
 	dec_preempt_count_ti r10, r4
-	mov	pc, r9			@ we think we have handled things
+	ret	r9			@ we think we have handled things
 
 
 look_for_VFP_exceptions:
@@ -202,7 +202,7 @@ look_for_VFP_exceptions:
 
 	DBGSTR	"not VFP"
 	dec_preempt_count_ti r10, r4
-	mov	pc, lr
+	ret	lr
 
 process_exception:
 	DBGSTR	"bounce"
@@ -234,7 +234,7 @@ ENTRY(vfp_save_state)
 	VFPFMRX	r12, FPINST2		@ FPINST2 if needed (and present)
 1:
 	stmia	r0, {r1, r2, r3, r12}	@ save FPEXC, FPSCR, FPINST, FPINST2
-	mov	pc, lr
+	ret	lr
 ENDPROC(vfp_save_state)
 
 	.align
@@ -245,7 +245,7 @@ vfp_current_hw_state_address:
 #ifdef CONFIG_THUMB2_KERNEL
 	adr	\tmp, 1f
 	add	\tmp, \tmp, \base, lsl \shift
-	mov	pc, \tmp
+	ret	\tmp
 #else
 	add	pc, pc, \base, lsl \shift
 	mov	r0, r0
@@ -257,10 +257,10 @@ ENTRY(vfp_get_float)
 	tbl_branch r0, r3, #3
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 1:	mrc	p10, 0, r0, c\dr, c0, 0	@ fmrs	r0, s0
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 1:	mrc	p10, 0, r0, c\dr, c0, 4	@ fmrs	r0, s1
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 	.endr
 ENDPROC(vfp_get_float)
@@ -269,10 +269,10 @@ ENTRY(vfp_put_float)
 	tbl_branch r1, r3, #3
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 1:	mcr	p10, 0, r0, c\dr, c0, 0	@ fmsr	r0, s0
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 1:	mcr	p10, 0, r0, c\dr, c0, 4	@ fmsr	r0, s1
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 	.endr
 ENDPROC(vfp_put_float)
@@ -281,14 +281,14 @@ ENTRY(vfp_get_double)
 	tbl_branch r0, r3, #3
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 1:	fmrrd	r0, r1, d\dr
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 	.endr
 #ifdef CONFIG_VFPv3
 	@ d16 - d31 registers
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 1:	mrrc	p11, 3, r0, r1, c\dr	@ fmrrd	r0, r1, d\dr
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 	.endr
 #endif
@@ -296,21 +296,21 @@ ENTRY(vfp_get_double)
 	@ virtual register 16 (or 32 if VFPv3) for compare with zero
 	mov	r0, #0
 	mov	r1, #0
-	mov	pc, lr
+	ret	lr
 ENDPROC(vfp_get_double)
 
 ENTRY(vfp_put_double)
 	tbl_branch r2, r3, #3
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 1:	fmdrr	d\dr, r0, r1
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 	.endr
 #ifdef CONFIG_VFPv3
 	@ d16 - d31 registers
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 1:	mcrr	p11, 3, r0, r1, c\dr	@ fmdrr	r0, r1, d\dr
-	mov	pc, lr
+	ret	lr
 	.org	1b + 8
 	.endr
 #endif
diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
index 44e3a5f10c4c..f00e08075938 100644
--- a/arch/arm/xen/hypercall.S
+++ b/arch/arm/xen/hypercall.S
@@ -58,7 +58,7 @@
 ENTRY(HYPERVISOR_##hypercall)			\
 	mov r12, #__HYPERVISOR_##hypercall;	\
 	__HVC(XEN_IMM);						\
-	mov pc, lr;							\
+	ret lr;					\
 ENDPROC(HYPERVISOR_##hypercall)
 
 #define HYPERCALL0 HYPERCALL_SIMPLE
@@ -74,7 +74,7 @@ ENTRY(HYPERVISOR_##hypercall)			\
 	mov r12, #__HYPERVISOR_##hypercall;	\
 	__HVC(XEN_IMM);						\
 	ldm sp!, {r4}						\
-	mov pc, lr							\
+	ret lr					\
 ENDPROC(HYPERVISOR_##hypercall)
 
                 .text
@@ -101,5 +101,5 @@ ENTRY(privcmd_call)
 	ldr r4, [sp, #4]
 	__HVC(XEN_IMM)
 	ldm sp!, {r4}
-	mov pc, lr
+	ret lr
 ENDPROC(privcmd_call);
-- 
1.8.3.1
