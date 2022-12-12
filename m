Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0883C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Dec 2022 18:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiLLSj7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Dec 2022 13:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbiLLSj2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2022 13:39:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4016D1758A
        for <linux-crypto@vger.kernel.org>; Mon, 12 Dec 2022 10:38:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2156611D5
        for <linux-crypto@vger.kernel.org>; Mon, 12 Dec 2022 18:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1543CC433D2;
        Mon, 12 Dec 2022 18:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670870288;
        bh=nhr19mh+afkqUAwiOaVfXMz2wkeJHYCTBevEN4it3FQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ujUhVt88s6KnGQTMR2lrLxfyBXlpH/SxzZNyhmUqDAMyE24LRC/zgJ8YbJSKt0M7f
         ctSXasK7JnlbrR6WIApMh6avSG1iywjTVptRR3fivqpbgnzCfCR3TN82qFWaegTqSE
         SRE7O++f8CqV8HvIPmK3h2JkP8zuNF83KZlTe3kOOQuxudZjZxdNIqcoNEgqobQ0nT
         KEtxosFYNGitb2JDeXCYKCHkSZz7qIz2k/RBM836ceGK5ns3tk1NSD+VvDW8gqcUju
         jLhInSnoUJZYoZ/pBlci9tJ9cl47waqOwbWviYq+vDTsZXpJbrpBbPQvExzTv/auAX
         oDdXyJIJt1UYw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: arm/ghash - implement fused AES/GHASH implementation of GCM
Date:   Mon, 12 Dec 2022 19:37:58 +0100
Message-Id: <20221212183758.1079283-1-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=21966; i=ardb@kernel.org; h=from:subject; bh=nhr19mh+afkqUAwiOaVfXMz2wkeJHYCTBevEN4it3FQ=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjl3UFPgOgAa823Pdh3gjlxarxwI5I9/wXXoxfSXgo 5PUA9ueJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5d1BQAKCRDDTyI5ktmPJG5hC/ 9Hm0cPpjyayOBf/vXinSraPkk+JOfnDMu2pt/KcaD4VqGSzY5xLBHmrWGXvGD+5PhCrjpYFSrg4ugc M30keMji6Dmz/Fcb6TQjmRBfrFDlgLb24rMtEKUWFnHgBBz03rIKEB2nlnhEhUhJdx3IimRFmKQ7YA bR525k3CAeluwQgj8Rle6nvBYdbSleTjHde8kzJUcnt0Rpwestmxdcd7BfiCtfj+a1abwX19yQydjp piDGt4grCIqPp5M6l8P2ffqZ/v50ArkI/R2qhX7Zqf2IAUIlPUSlxYyPH/avDT0ogNDn80HSdzien5 C/bdzb9WaCjRcrWTvf+mf+J18snDhwaxP7+lU/KiDWccrQVGee2xlMzy0AMW0Aye26sTokdysVN2ew RUAmFSEioJfyrkABnnrJ1YI/iPWCIziXunPpVeOhSSNj9CwhzzX8s49NbpyCXO9ICZD5oOc1gCLc03 qZP2YvilBh1RdGH3Fz2JQdNJ5BDlYiNYsyJpX2owmYeG4=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 32-bit ARM, AES in GCM mode takes full advantage of the ARMv8 Crypto
Extensions when available, resulting in a performance of 6-7 cycles per
byte for typical IPsec frames on cores such as Cortex-A53, using the
generic GCM template encapsulating the accelerated AES-CTR and GHASH
implementations.

At such high rates, any time spent copying data or doing other poorly
optimized work in the generic layer hurts disproportionately, and we can
get a significant performance improvement by combining the optimized
AES-CTR and GHASH implementations into a single one.

On Cortex-A53, this results in a performance improvement of around 70%,
or 4.2 cycles per byte for AES-256-GCM-128 with RFC4106 encapsulation.
The fastest mode on this core is bare AES-128-GCM using 8k blocks, which
manages 2.66 cycles per byte.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Note: this patch depends on the softirq context patches for kernel mode
NEON I sent last week. More specifically, this implements a sync AEAD
that does not implement a !simd fallback, as AEADs are not callable in
IRQ context anyway.

 arch/arm/crypto/Kconfig         |   2 +
 arch/arm/crypto/ghash-ce-core.S | 381 +++++++++++++++++++-
 arch/arm/crypto/ghash-ce-glue.c | 350 +++++++++++++++++-
 3 files changed, 718 insertions(+), 15 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 3858c4d4cb98854d..c693a4fdf3771e63 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -16,9 +16,11 @@ config CRYPTO_CURVE25519_NEON
 config CRYPTO_GHASH_ARM_CE
 	tristate "Hash functions: GHASH (PMULL/NEON/ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
+	select CRYPTO_AEAD
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
 	select CRYPTO_GF128MUL
+	select CRYPTO_LIB_AES
 	help
 	  GCM GHASH function (NIST SP800-38D)
 
diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index 9f51e3fa45268de9..e0a4dc20a3a96832 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -44,7 +44,7 @@
 	t2q		.req	q7
 	t3q		.req	q8
 	t4q		.req	q9
-	T2		.req	q9
+	XH2		.req	q9
 
 	s1l		.req	d20
 	s1h		.req	d21
@@ -80,7 +80,7 @@
 
 	XL2		.req	q5
 	XM2		.req	q6
-	XH2		.req	q7
+	T2		.req	q7
 	T3		.req	q8
 
 	XL2_L		.req	d10
@@ -192,23 +192,42 @@
 	vshr.u64	XL, XL, #1
 	.endm
 
-	.macro		ghash_update, pn
+	.macro		ghash_update, pn, enc, aggregate=1, head=1
 	vld1.64		{XL}, [r1]
 
+	.if		\head
 	/* do the head block first, if supplied */
-	ldr		ip, [sp]
 	teq		ip, #0
 	beq		0f
 	vld1.64		{T1}, [ip]
 	teq		r0, #0
 	b		3f
+	.endif
 
 0:	.ifc		\pn, p64
+	.if		\aggregate
 	tst		r0, #3			// skip until #blocks is a
 	bne		2f			// round multiple of 4
 
 	vld1.8		{XL2-XM2}, [r2]!
-1:	vld1.8		{T3-T2}, [r2]!
+1:	vld1.8		{T2-T3}, [r2]!
+
+	.ifnb		\enc
+	\enc\()_4x	XL2, XM2, T2, T3
+
+	add		ip, r3, #16
+	vld1.64		{HH}, [ip, :128]!
+	vld1.64		{HH3-HH4}, [ip, :128]
+
+	veor		SHASH2_p64, SHASH_L, SHASH_H
+	veor		SHASH2_H, HH_L, HH_H
+	veor		HH34_L, HH3_L, HH3_H
+	veor		HH34_H, HH4_L, HH4_H
+
+	vmov.i8		MASK, #0xe1
+	vshl.u64	MASK, MASK, #57
+	.endif
+
 	vrev64.8	XL2, XL2
 	vrev64.8	XM2, XM2
 
@@ -218,8 +237,8 @@
 	veor		XL2_H, XL2_H, XL_L
 	veor		XL, XL, T1
 
-	vrev64.8	T3, T3
-	vrev64.8	T1, T2
+	vrev64.8	T1, T3
+	vrev64.8	T3, T2
 
 	vmull.p64	XH, HH4_H, XL_H			// a1 * b1
 	veor		XL2_H, XL2_H, XL_H
@@ -267,14 +286,22 @@
 
 	b		1b
 	.endif
+	.endif
+
+2:	vld1.8		{T1}, [r2]!
+
+	.ifnb		\enc
+	\enc\()_1x	T1
+	veor		SHASH2_p64, SHASH_L, SHASH_H
+	vmov.i8		MASK, #0xe1
+	vshl.u64	MASK, MASK, #57
+	.endif
 
-2:	vld1.64		{T1}, [r2]!
 	subs		r0, r0, #1
 
 3:	/* multiply XL by SHASH in GF(2^128) */
-#ifndef CONFIG_CPU_BIG_ENDIAN
 	vrev64.8	T1, T1
-#endif
+
 	vext.8		IN1, T1, T1, #8
 	veor		T1_L, T1_L, XL_H
 	veor		XL, XL, IN1
@@ -293,9 +320,6 @@
 	veor		XL, XL, T1
 
 	bne		0b
-
-	vst1.64		{XL}, [r1]
-	bx		lr
 	.endm
 
 	/*
@@ -315,7 +339,11 @@ ENTRY(pmull_ghash_update_p64)
 	vmov.i8		MASK, #0xe1
 	vshl.u64	MASK, MASK, #57
 
+	ldr		ip, [sp]
 	ghash_update	p64
+	vst1.64		{XL}, [r1]
+
+	bx		lr
 ENDPROC(pmull_ghash_update_p64)
 
 ENTRY(pmull_ghash_update_p8)
@@ -335,5 +363,332 @@ ENTRY(pmull_ghash_update_p8)
 	vmov.i64	k32, #0xffffffff
 	vmov.i64	k48, #0xffffffffffff
 
+	ldr		ip, [sp]
 	ghash_update	p8
+	vst1.64		{XL}, [r1]
+
+	bx		lr
 ENDPROC(pmull_ghash_update_p8)
+
+	e0		.req	q9
+	e1		.req	q10
+	e2		.req	q11
+	e3		.req	q12
+	e0l		.req	d18
+	e0h		.req	d19
+	e2l		.req	d22
+	e2h		.req	d23
+	e3l		.req	d24
+	e3h		.req	d25
+	ctr		.req	q13
+	ctr0		.req	d26
+	ctr1		.req	d27
+
+	ek0		.req	q14
+	ek1		.req	q15
+
+	.macro		round, rk:req, regs:vararg
+	.irp		r, \regs
+	aese.8		\r, \rk
+	aesmc.8		\r, \r
+	.endr
+	.endm
+
+	.macro		aes_encrypt, rkp, rounds, regs:vararg
+	vld1.8		{ek0-ek1}, [\rkp, :128]!
+	cmp		\rounds, #12
+	blt		.L\@_1			// AES-128
+	beq		.L\@_0			// AES-192
+
+	round		ek0, \regs
+	vld1.8		{ek0}, [\rkp, :128]!
+	round		ek1, \regs
+	vld1.8		{ek1}, [\rkp, :128]!
+
+.L\@_0:	round		ek0, \regs
+	vld1.8		{ek0}, [\rkp, :128]!
+	round		ek1, \regs
+	vld1.8		{ek1}, [\rkp, :128]!
+
+.L\@_1: .rept		4
+	round		ek0, \regs
+	vld1.8		{ek0}, [\rkp, :128]!
+	round		ek1, \regs
+	vld1.8		{ek1}, [\rkp, :128]!
+	.endr
+
+	round		ek0, \regs
+	vld1.8		{ek0}, [\rkp, :128]
+
+	.irp		r, \regs
+	aese.8		\r, ek1
+	.endr
+	.irp		r, \regs
+	veor		\r, \r, ek0
+	.endr
+	.endm
+
+pmull_aes_encrypt:
+	add		ip, r5, #4
+	vld1.8		{ctr0}, [r5]		// load 12 byte IV
+	vld1.8		{ctr1}, [ip]
+	rev		r8, r7
+	vext.8		ctr1, ctr1, ctr1, #4
+	add		r7, r7, #1
+	vmov.32		ctr1[1], r8
+	vmov		e0, ctr
+
+	add		ip, r3, #64
+	aes_encrypt	ip, r6, e0
+	bx		lr
+ENDPROC(pmull_aes_encrypt)
+
+pmull_aes_encrypt_4x:
+	add		ip, r5, #4
+	vld1.8		{ctr0}, [r5]
+	vld1.8		{ctr1}, [ip]
+	rev		r8, r7
+	vext.8		ctr1, ctr1, ctr1, #4
+	add		r7, r7, #1
+	vmov.32		ctr1[1], r8
+	rev		ip, r7
+	vmov		e0, ctr
+	add		r7, r7, #1
+	vmov.32		ctr1[1], ip
+	rev		r8, r7
+	vmov		e1, ctr
+	add		r7, r7, #1
+	vmov.32		ctr1[1], r8
+	rev		ip, r7
+	vmov		e2, ctr
+	add		r7, r7, #1
+	vmov.32		ctr1[1], ip
+	vmov		e3, ctr
+
+	add		ip, r3, #64
+	aes_encrypt	ip, r6, e0, e1, e2, e3
+	bx		lr
+ENDPROC(pmull_aes_encrypt_4x)
+
+pmull_aes_encrypt_final:
+	add		ip, r5, #4
+	vld1.8		{ctr0}, [r5]
+	vld1.8		{ctr1}, [ip]
+	rev		r8, r7
+	vext.8		ctr1, ctr1, ctr1, #4
+	mov		r7, #1 << 24		// BE #1 for the tag
+	vmov.32		ctr1[1], r8
+	vmov		e0, ctr
+	vmov.32		ctr1[1], r7
+	vmov		e1, ctr
+
+	add		ip, r3, #64
+	aes_encrypt	ip, r6, e0, e1
+	bx		lr
+ENDPROC(pmull_aes_encrypt_final)
+
+	.macro		enc_1x, in0
+	bl		pmull_aes_encrypt
+	veor		\in0, \in0, e0
+	vst1.8		{\in0}, [r4]!
+	.endm
+
+	.macro		dec_1x, in0
+	bl		pmull_aes_encrypt
+	veor		e0, e0, \in0
+	vst1.8		{e0}, [r4]!
+	.endm
+
+	.macro		enc_4x, in0, in1, in2, in3
+	bl		pmull_aes_encrypt_4x
+
+	veor		\in0, \in0, e0
+	veor		\in1, \in1, e1
+	veor		\in2, \in2, e2
+	veor		\in3, \in3, e3
+
+	vst1.8		{\in0-\in1}, [r4]!
+	vst1.8		{\in2-\in3}, [r4]!
+	.endm
+
+	.macro		dec_4x, in0, in1, in2, in3
+	bl		pmull_aes_encrypt_4x
+
+	veor		e0, e0, \in0
+	veor		e1, e1, \in1
+	veor		e2, e2, \in2
+	veor		e3, e3, \in3
+
+	vst1.8		{e0-e1}, [r4]!
+	vst1.8		{e2-e3}, [r4]!
+	.endm
+
+	/*
+	 * void pmull_gcm_encrypt(int blocks, u64 dg[], const char *src,
+	 *			  struct gcm_key const *k, char *dst,
+	 *			  char *iv, int rounds, u32 counter)
+	 */
+ENTRY(pmull_gcm_encrypt)
+	mov		ip, sp
+	push		{r4-r8, lr}
+	ldm		ip, {r4-r7}
+
+	vld1.64		{SHASH}, [r3]
+
+	ghash_update	p64, enc, head=0
+	vst1.64		{XL}, [r1]
+
+	pop		{r4-r8, pc}
+ENDPROC(pmull_gcm_encrypt)
+
+	/*
+	 * void pmull_gcm_decrypt(int blocks, u64 dg[], const char *src,
+	 *			  struct gcm_key const *k, char *dst,
+	 *			  char *iv, int rounds, u32 counter)
+	 */
+ENTRY(pmull_gcm_decrypt)
+	mov		ip, sp
+	push		{r4-r8, lr}
+	ldm		ip, {r4-r7}
+
+	vld1.64		{SHASH}, [r3]
+
+	ghash_update	p64, dec, head=0
+	vst1.64		{XL}, [r1]
+
+	pop		{r4-r8, pc}
+ENDPROC(pmull_gcm_decrypt)
+
+	/*
+	 * void pmull_gcm_enc_final(int bytes, u64 dg[], char *tag,
+	 *			    struct gcm_key const *k, char *head,
+	 *			    char *iv, int rounds, u32 counter)
+	 */
+ENTRY(pmull_gcm_enc_final)
+	mov		ip, sp
+	push		{r4-r8, lr}
+	ldm		ip, {r4-r7}
+
+	bl		pmull_aes_encrypt_final
+
+	cmp		r0, #0
+	beq		.Lenc_final
+
+	adr_l		ip, .Lpermute
+	sub		r4, r4, #16
+	add		r8, ip, r0
+	add		ip, ip, #32
+	add		r4, r4, r0
+	sub		ip, ip, r0
+
+	vld1.8		{e3}, [r8]		// permute vector for key stream
+	vld1.8		{e2}, [ip]		// permute vector for ghash input
+
+	vtbl.8		e3l, {e0}, e3l
+	vtbl.8		e3h, {e0}, e3h
+
+	vld1.8		{e0}, [r4]		// encrypt tail block
+	veor		e0, e0, e3
+	vst1.8		{e0}, [r4]
+
+	vtbl.8		T1_L, {e0}, e2l
+	vtbl.8		T1_H, {e0}, e2h
+
+	vld1.64		{XL}, [r1]
+.Lenc_final:
+	vld1.64		{SHASH}, [r3, :128]
+	vmov.i8		MASK, #0xe1
+	veor		SHASH2_p64, SHASH_L, SHASH_H
+	vshl.u64	MASK, MASK, #57
+	mov		r0, #1
+	bne		3f			// process head block first
+	ghash_update	p64, aggregate=0, head=0
+
+	vrev64.8	XL, XL
+	vext.8		XL, XL, XL, #8
+	veor		XL, XL, e1
+
+	sub		r2, r2, #16		// rewind src pointer
+	vst1.8		{XL}, [r2]		// store tag
+
+	pop		{r4-r8, pc}
+ENDPROC(pmull_gcm_enc_final)
+
+	/*
+	 * int pmull_gcm_dec_final(int bytes, u64 dg[], char *tag,
+	 *			   struct gcm_key const *k, char *head,
+	 *			   char *iv, int rounds, u32 counter,
+	 *			   const char *otag, int authsize)
+	 */
+ENTRY(pmull_gcm_dec_final)
+	mov		ip, sp
+	push		{r4-r8, lr}
+	ldm		ip, {r4-r7}
+
+	bl		pmull_aes_encrypt_final
+
+	cmp		r0, #0
+	beq		.Ldec_final
+
+	adr_l		ip, .Lpermute
+	sub		r4, r4, #16
+	add		r8, ip, r0
+	add		ip, ip, #32
+	add		r4, r4, r0
+	sub		ip, ip, r0
+
+	vld1.8		{e3}, [r8]		// permute vector for key stream
+	vld1.8		{e2}, [ip]		// permute vector for ghash input
+
+	vtbl.8		e3l, {e0}, e3l
+	vtbl.8		e3h, {e0}, e3h
+
+	vld1.8		{e0}, [r4]
+
+	vtbl.8		T1_L, {e0}, e2l
+	vtbl.8		T1_H, {e0}, e2h
+
+	veor		e0, e0, e3
+	vst1.8		{e0}, [r4]
+
+	vld1.64		{XL}, [r1]
+.Ldec_final:
+	vld1.64		{SHASH}, [r3]
+	vmov.i8		MASK, #0xe1
+	veor		SHASH2_p64, SHASH_L, SHASH_H
+	vshl.u64	MASK, MASK, #57
+	mov		r0, #1
+	bne		3f			// process head block first
+	ghash_update	p64, aggregate=0, head=0
+
+	vrev64.8	XL, XL
+	vext.8		XL, XL, XL, #8
+	veor		XL, XL, e1
+
+	adr_l		ip, .Lpermute
+	ldrd		r2, r3, [sp, #40]	// otag and authsize
+	vld1.8		{T1}, [r2]
+	add		ip, ip, r3
+	vceq.i8		T1, T1, XL		// compare tags
+	vmvn		T1, T1			// 0 for eq, -1 for ne
+
+	vld1.8		{e0}, [ip]
+	vtbl.8		XL_L, {T1}, e0l		// keep authsize bytes only
+	vtbl.8		XL_H, {T1}, e0h
+
+	vpmin.s8	XL_L, XL_L, XL_H	// take the minimum s8 across the vector
+	vpmin.s8	XL_L, XL_L, XL_L
+	vmov		r0, XL_L[0]		// fail if != 0x0
+
+	pop		{r4-r8, pc}
+ENDPROC(pmull_gcm_dec_final)
+
+	.section	".rodata", "a", %progbits
+	.align		5
+.Lpermute:
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
+	.byte		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index 3e598284498865cf..f234c6fdc0472791 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -9,10 +9,16 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <asm/unaligned.h>
+#include <crypto/aes.h>
+#include <crypto/gcm.h>
+#include <crypto/b128ops.h>
 #include <crypto/cryptd.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/gf128mul.h>
+#include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/jump_label.h>
@@ -25,12 +31,19 @@ MODULE_ALIAS_CRYPTO("ghash");
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
+#define GCM_IV_SIZE		12
 
 struct ghash_key {
 	u64	h0[2];
 	u64	h[][2];
 };
 
+struct gcm_key {
+	u64	h[4][2];
+	u32	rk[AES_MAX_KEYLENGTH_U32];
+	int	rounds;
+};
+
 struct ghash_desc_ctx {
 	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
 	u8 buf[GHASH_BLOCK_SIZE];
@@ -324,6 +337,332 @@ static struct ahash_alg ghash_async_alg = {
 	},
 };
 
+
+void pmull_gcm_encrypt(int blocks, u64 dg[], const char *src,
+		       struct gcm_key const *k, char *dst,
+		       char *iv, int rounds, u32 counter);
+
+void pmull_gcm_enc_final(int blocks, u64 dg[], char *tag,
+			 struct gcm_key const *k, char *head,
+			 char *iv, int rounds, u32 counter);
+
+void pmull_gcm_decrypt(int bytes, u64 dg[], const char *src,
+		       struct gcm_key const *k, char *dst,
+		       char *iv, int rounds, u32 counter);
+
+int pmull_gcm_dec_final(int bytes, u64 dg[], char *tag,
+			struct gcm_key const *k, char *head,
+			char *iv, int rounds, u32 counter,
+			const char *otag, int authsize);
+
+static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
+		      unsigned int keylen)
+{
+	struct gcm_key *ctx = crypto_aead_ctx(tfm);
+	struct crypto_aes_ctx aes_ctx;
+	be128 h, k;
+	int ret;
+
+	ret = aes_expandkey(&aes_ctx, inkey, keylen);
+	if (ret)
+		return -EINVAL;
+
+	aes_encrypt(&aes_ctx, (u8 *)&k, (u8[AES_BLOCK_SIZE]){});
+
+	memcpy(ctx->rk, aes_ctx.key_enc, sizeof(ctx->rk));
+	ctx->rounds = 6 + keylen / 4;
+
+	memzero_explicit(&aes_ctx, sizeof(aes_ctx));
+
+	ghash_reflect(ctx->h[0], &k);
+
+	h = k;
+	gf128mul_lle(&h, &k);
+	ghash_reflect(ctx->h[1], &h);
+
+	gf128mul_lle(&h, &k);
+	ghash_reflect(ctx->h[2], &h);
+
+	gf128mul_lle(&h, &k);
+	ghash_reflect(ctx->h[3], &h);
+
+	return 0;
+}
+
+static int gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12 ... 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void gcm_update_mac(u64 dg[], const u8 *src, int count, u8 buf[],
+			   int *buf_count, struct gcm_key *ctx)
+{
+	if (*buf_count > 0) {
+		int buf_added = min(count, GHASH_BLOCK_SIZE - *buf_count);
+
+		memcpy(&buf[*buf_count], src, buf_added);
+
+		*buf_count += buf_added;
+		src += buf_added;
+		count -= buf_added;
+	}
+
+	if (count >= GHASH_BLOCK_SIZE || *buf_count == GHASH_BLOCK_SIZE) {
+		int blocks = count / GHASH_BLOCK_SIZE;
+
+		pmull_ghash_update_p64(blocks, dg, src, ctx->h,
+				       *buf_count ? buf : NULL);
+
+		src += blocks * GHASH_BLOCK_SIZE;
+		count %= GHASH_BLOCK_SIZE;
+		*buf_count = 0;
+	}
+
+	if (count > 0) {
+		memcpy(buf, src, count);
+		*buf_count = count;
+	}
+}
+
+static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[])
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_key *ctx = crypto_aead_ctx(aead);
+	u8 buf[GHASH_BLOCK_SIZE];
+	struct scatter_walk walk;
+	u32 len = req->assoclen;
+	int buf_count = 0;
+
+	scatterwalk_start(&walk, req->src);
+
+	do {
+		u32 n = scatterwalk_clamp(&walk, len);
+		u8 *p;
+
+		if (!n) {
+			scatterwalk_start(&walk, sg_next(walk.sg));
+			n = scatterwalk_clamp(&walk, len);
+		}
+		p = scatterwalk_map(&walk);
+
+		gcm_update_mac(dg, p, n, buf, &buf_count, ctx);
+
+		scatterwalk_unmap(p);
+
+		if (unlikely(len / SZ_4K > (len - n) / SZ_4K)) {
+                        kernel_neon_end();
+                        kernel_neon_begin();
+                }
+
+		len -= n;
+		scatterwalk_advance(&walk, n);
+		scatterwalk_done(&walk, 0, len);
+	} while (len);
+
+	if (buf_count) {
+		memset(&buf[buf_count], 0, GHASH_BLOCK_SIZE - buf_count);
+		pmull_ghash_update_p64(1, dg, buf, ctx->h, NULL);
+	}
+}
+
+static int gcm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_key *ctx = crypto_aead_ctx(aead);
+	struct skcipher_walk walk;
+	u8 buf[AES_BLOCK_SIZE];
+	u32 counter = 2;
+	u64 dg[2] = {};
+	be128 lengths;
+	const u8 *src;
+	u8 *tag, *dst;
+	int tail, err;
+
+	if (WARN_ON_ONCE(!may_use_simd()))
+		return -EBUSY;
+
+	err = skcipher_walk_aead_encrypt(&walk, req, false);
+
+	kernel_neon_begin();
+
+	if (req->assoclen)
+		gcm_calculate_auth_mac(req, dg);
+
+	src = walk.src.virt.addr;
+	dst = walk.dst.virt.addr;
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int nblocks = walk.nbytes / AES_BLOCK_SIZE;
+
+		pmull_gcm_encrypt(nblocks, dg, src, ctx, dst, req->iv,
+				  ctx->rounds, counter);
+		counter += nblocks;
+
+		if (walk.nbytes == walk.total && walk.nbytes % AES_BLOCK_SIZE) {
+			src += nblocks * AES_BLOCK_SIZE;
+			dst += nblocks * AES_BLOCK_SIZE;
+			break;
+		}
+
+		kernel_neon_end();
+
+		err = skcipher_walk_done(&walk,
+					 walk.nbytes % AES_BLOCK_SIZE);
+		if (err)
+			return err;
+
+		src = walk.src.virt.addr;
+		dst = walk.dst.virt.addr;
+
+		kernel_neon_begin();
+	}
+
+
+	lengths.a = cpu_to_be64(req->assoclen * 8);
+	lengths.b = cpu_to_be64(req->cryptlen * 8);
+
+	tag = (u8 *)&lengths;
+	tail = walk.nbytes % AES_BLOCK_SIZE;
+
+	/*
+	 * Bounce via a buffer unless we are encrypting in place and src/dst
+	 * are not pointing to the start of the walk buffer. In that case, we
+	 * can do a NEON load/xor/store sequence in place as long as we move
+	 * the plain/ciphertext and keystream to the start of the register. If
+	 * not, do a memcpy() to the end of the buffer so we can reuse the same
+	 * logic.
+	 */
+	if (unlikely(tail && (tail == walk.nbytes || src != dst)))
+		src = memcpy(buf + sizeof(buf) - tail, src, tail);
+
+	pmull_gcm_enc_final(tail, dg, tag, ctx, (u8 *)src, req->iv,
+			    ctx->rounds, counter);
+	kernel_neon_end();
+
+	if (unlikely(tail && src != dst))
+		memcpy(dst, src, tail);
+
+	if (walk.nbytes) {
+		err = skcipher_walk_done(&walk, 0);
+		if (err)
+			return err;
+	}
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(tag, req->dst, req->assoclen + req->cryptlen,
+				 crypto_aead_authsize(aead), 1);
+
+	return 0;
+}
+
+static int gcm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct gcm_key *ctx = crypto_aead_ctx(aead);
+	int authsize = crypto_aead_authsize(aead);
+	struct skcipher_walk walk;
+	u8 otag[AES_BLOCK_SIZE];
+	u8 buf[AES_BLOCK_SIZE];
+	u32 counter = 2;
+	u64 dg[2] = {};
+	be128 lengths;
+	const u8 *src;
+	u8 *tag, *dst;
+	int tail, err, ret;
+
+	if (WARN_ON_ONCE(!may_use_simd()))
+		return -EBUSY;
+
+	scatterwalk_map_and_copy(otag, req->src,
+				 req->assoclen + req->cryptlen - authsize,
+				 authsize, 0);
+
+	err = skcipher_walk_aead_decrypt(&walk, req, false);
+
+	kernel_neon_begin();
+
+	if (req->assoclen)
+		gcm_calculate_auth_mac(req, dg);
+
+	src = walk.src.virt.addr;
+	dst = walk.dst.virt.addr;
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int nblocks = walk.nbytes / AES_BLOCK_SIZE;
+
+		pmull_gcm_decrypt(nblocks, dg, src, ctx, dst, req->iv,
+				  ctx->rounds, counter);
+		counter += nblocks;
+
+		if (walk.nbytes == walk.total && walk.nbytes % AES_BLOCK_SIZE) {
+			src += nblocks * AES_BLOCK_SIZE;
+			dst += nblocks * AES_BLOCK_SIZE;
+			break;
+		}
+
+		kernel_neon_end();
+
+		err = skcipher_walk_done(&walk,
+					 walk.nbytes % AES_BLOCK_SIZE);
+		if (err)
+			return err;
+
+		src = walk.src.virt.addr;
+		dst = walk.dst.virt.addr;
+
+		kernel_neon_begin();
+	}
+
+	lengths.a = cpu_to_be64(req->assoclen * 8);
+	lengths.b = cpu_to_be64((req->cryptlen - authsize) * 8);
+
+	tag = (u8 *)&lengths;
+	tail = walk.nbytes % AES_BLOCK_SIZE;
+
+	if (unlikely(tail && (tail == walk.nbytes || src != dst)))
+		src = memcpy(buf + sizeof(buf) - tail, src, tail);
+
+	ret = pmull_gcm_dec_final(tail, dg, tag, ctx, (u8 *)src, req->iv,
+				  ctx->rounds, counter, otag, authsize);
+	kernel_neon_end();
+
+	if (unlikely(tail && src != dst))
+		memcpy(dst, src, tail);
+
+	if (walk.nbytes) {
+		err = skcipher_walk_done(&walk, 0);
+		if (err)
+			return err;
+	}
+
+	return ret ? -EBADMSG : 0;
+}
+
+static struct aead_alg gcm_aes_alg = {
+	.ivsize			= GCM_IV_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.maxauthsize		= AES_BLOCK_SIZE,
+	.setkey			= gcm_setkey,
+	.setauthsize		= gcm_setauthsize,
+	.encrypt		= gcm_encrypt,
+	.decrypt		= gcm_decrypt,
+
+	.base.cra_name		= "gcm(aes)",
+	.base.cra_driver_name	= "gcm-aes-ce",
+	.base.cra_priority	= 400,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct gcm_key),
+	.base.cra_module	= THIS_MODULE,
+};
+
 static int __init ghash_ce_mod_init(void)
 {
 	int err;
@@ -332,21 +671,26 @@ static int __init ghash_ce_mod_init(void)
 		return -ENODEV;
 
 	if (elf_hwcap2 & HWCAP2_PMULL) {
+		err = crypto_register_aead(&gcm_aes_alg);
+		if (err)
+			return err;
 		ghash_alg.base.cra_ctxsize += 3 * sizeof(u64[2]);
 		static_branch_enable(&use_p64);
 	}
 
 	err = crypto_register_shash(&ghash_alg);
 	if (err)
-		return err;
+		goto err_aead;
 	err = crypto_register_ahash(&ghash_async_alg);
 	if (err)
 		goto err_shash;
 
 	return 0;
-
 err_shash:
 	crypto_unregister_shash(&ghash_alg);
+err_aead:
+	if (elf_hwcap2 & HWCAP2_PMULL)
+		crypto_unregister_aead(&gcm_aes_alg);
 	return err;
 }
 
@@ -354,6 +698,8 @@ static void __exit ghash_ce_mod_exit(void)
 {
 	crypto_unregister_ahash(&ghash_async_alg);
 	crypto_unregister_shash(&ghash_alg);
+	if (elf_hwcap2 & HWCAP2_PMULL)
+		crypto_unregister_aead(&gcm_aes_alg);
 }
 
 module_init(ghash_ce_mod_init);
-- 
2.35.1

