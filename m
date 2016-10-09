From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/6] crypto: arm64/aes-ccm-ce: fix for big endian
Date: Sun,  9 Oct 2016 18:42:24 +0100
Message-ID: <1476034945-9186-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33036 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbcJIRmq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 13:42:46 -0400
Received: by mail-lf0-f49.google.com with SMTP id x79so84677628lff.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 Oct 2016 10:42:44 -0700 (PDT)
In-Reply-To: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES-CCM implementation that uses ARMv8 Crypto Extensions instructions
refers to the AES round keys as pairs of 64-bit quantities, which causes
failures when building the code for big endian. In addition, it byte swaps
the input counter unconditionally, while this is only required for little
endian builds. So fix both issues.

Fixes: 12ac3efe74f8 ("arm64/crypto: use crypto instructions to generate AES key schedule")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S | 53 ++++++++++----------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index a2a7fbcacc14..3363560c79b7 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -9,6 +9,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 	.text
 	.arch	armv8-a+crypto
@@ -19,7 +20,7 @@
 	 */
 ENTRY(ce_aes_ccm_auth_data)
 	ldr	w8, [x3]			/* leftover from prev round? */
-	ld1	{v0.2d}, [x0]			/* load mac */
+	ld1	{v0.16b}, [x0]			/* load mac */
 	cbz	w8, 1f
 	sub	w8, w8, #16
 	eor	v1.16b, v1.16b, v1.16b
@@ -31,7 +32,7 @@ ENTRY(ce_aes_ccm_auth_data)
 	beq	8f				/* out of input? */
 	cbnz	w8, 0b
 	eor	v0.16b, v0.16b, v1.16b
-1:	ld1	{v3.2d}, [x4]			/* load first round key */
+1:	ld1	{v3.16b}, [x4]			/* load first round key */
 	prfm	pldl1strm, [x1]
 	cmp	w5, #12				/* which key size? */
 	add	x6, x4, #16
@@ -41,17 +42,17 @@ ENTRY(ce_aes_ccm_auth_data)
 	mov	v5.16b, v3.16b
 	b	4f
 2:	mov	v4.16b, v3.16b
-	ld1	{v5.2d}, [x6], #16		/* load 2nd round key */
+	ld1	{v5.16b}, [x6], #16		/* load 2nd round key */
 3:	aese	v0.16b, v4.16b
 	aesmc	v0.16b, v0.16b
-4:	ld1	{v3.2d}, [x6], #16		/* load next round key */
+4:	ld1	{v3.16b}, [x6], #16		/* load next round key */
 	aese	v0.16b, v5.16b
 	aesmc	v0.16b, v0.16b
-5:	ld1	{v4.2d}, [x6], #16		/* load next round key */
+5:	ld1	{v4.16b}, [x6], #16		/* load next round key */
 	subs	w7, w7, #3
 	aese	v0.16b, v3.16b
 	aesmc	v0.16b, v0.16b
-	ld1	{v5.2d}, [x6], #16		/* load next round key */
+	ld1	{v5.16b}, [x6], #16		/* load next round key */
 	bpl	3b
 	aese	v0.16b, v4.16b
 	subs	w2, w2, #16			/* last data? */
@@ -60,7 +61,7 @@ ENTRY(ce_aes_ccm_auth_data)
 	ld1	{v1.16b}, [x1], #16		/* load next input block */
 	eor	v0.16b, v0.16b, v1.16b		/* xor with mac */
 	bne	1b
-6:	st1	{v0.2d}, [x0]			/* store mac */
+6:	st1	{v0.16b}, [x0]			/* store mac */
 	beq	10f
 	adds	w2, w2, #16
 	beq	10f
@@ -79,7 +80,7 @@ ENTRY(ce_aes_ccm_auth_data)
 	adds	w7, w7, #1
 	bne	9b
 	eor	v0.16b, v0.16b, v1.16b
-	st1	{v0.2d}, [x0]
+	st1	{v0.16b}, [x0]
 10:	str	w8, [x3]
 	ret
 ENDPROC(ce_aes_ccm_auth_data)
@@ -89,27 +90,27 @@ ENDPROC(ce_aes_ccm_auth_data)
 	 * 			 u32 rounds);
 	 */
 ENTRY(ce_aes_ccm_final)
-	ld1	{v3.2d}, [x2], #16		/* load first round key */
-	ld1	{v0.2d}, [x0]			/* load mac */
+	ld1	{v3.16b}, [x2], #16		/* load first round key */
+	ld1	{v0.16b}, [x0]			/* load mac */
 	cmp	w3, #12				/* which key size? */
 	sub	w3, w3, #2			/* modified # of rounds */
-	ld1	{v1.2d}, [x1]			/* load 1st ctriv */
+	ld1	{v1.16b}, [x1]			/* load 1st ctriv */
 	bmi	0f
 	bne	3f
 	mov	v5.16b, v3.16b
 	b	2f
 0:	mov	v4.16b, v3.16b
-1:	ld1	{v5.2d}, [x2], #16		/* load next round key */
+1:	ld1	{v5.16b}, [x2], #16		/* load next round key */
 	aese	v0.16b, v4.16b
 	aesmc	v0.16b, v0.16b
 	aese	v1.16b, v4.16b
 	aesmc	v1.16b, v1.16b
-2:	ld1	{v3.2d}, [x2], #16		/* load next round key */
+2:	ld1	{v3.16b}, [x2], #16		/* load next round key */
 	aese	v0.16b, v5.16b
 	aesmc	v0.16b, v0.16b
 	aese	v1.16b, v5.16b
 	aesmc	v1.16b, v1.16b
-3:	ld1	{v4.2d}, [x2], #16		/* load next round key */
+3:	ld1	{v4.16b}, [x2], #16		/* load next round key */
 	subs	w3, w3, #3
 	aese	v0.16b, v3.16b
 	aesmc	v0.16b, v0.16b
@@ -120,47 +121,47 @@ ENTRY(ce_aes_ccm_final)
 	aese	v1.16b, v4.16b
 	/* final round key cancels out */
 	eor	v0.16b, v0.16b, v1.16b		/* en-/decrypt the mac */
-	st1	{v0.2d}, [x0]			/* store result */
+	st1	{v0.16b}, [x0]			/* store result */
 	ret
 ENDPROC(ce_aes_ccm_final)
 
 	.macro	aes_ccm_do_crypt,enc
 	ldr	x8, [x6, #8]			/* load lower ctr */
-	ld1	{v0.2d}, [x5]			/* load mac */
-	rev	x8, x8				/* keep swabbed ctr in reg */
+	ld1	{v0.16b}, [x5]			/* load mac */
+CPU_LE(	rev	x8, x8			)	/* keep swabbed ctr in reg */
 0:	/* outer loop */
-	ld1	{v1.1d}, [x6]			/* load upper ctr */
+	ld1	{v1.8b}, [x6]			/* load upper ctr */
 	prfm	pldl1strm, [x1]
 	add	x8, x8, #1
 	rev	x9, x8
 	cmp	w4, #12				/* which key size? */
 	sub	w7, w4, #2			/* get modified # of rounds */
 	ins	v1.d[1], x9			/* no carry in lower ctr */
-	ld1	{v3.2d}, [x3]			/* load first round key */
+	ld1	{v3.16b}, [x3]			/* load first round key */
 	add	x10, x3, #16
 	bmi	1f
 	bne	4f
 	mov	v5.16b, v3.16b
 	b	3f
 1:	mov	v4.16b, v3.16b
-	ld1	{v5.2d}, [x10], #16		/* load 2nd round key */
+	ld1	{v5.16b}, [x10], #16		/* load 2nd round key */
 2:	/* inner loop: 3 rounds, 2x interleaved */
 	aese	v0.16b, v4.16b
 	aesmc	v0.16b, v0.16b
 	aese	v1.16b, v4.16b
 	aesmc	v1.16b, v1.16b
-3:	ld1	{v3.2d}, [x10], #16		/* load next round key */
+3:	ld1	{v3.16b}, [x10], #16		/* load next round key */
 	aese	v0.16b, v5.16b
 	aesmc	v0.16b, v0.16b
 	aese	v1.16b, v5.16b
 	aesmc	v1.16b, v1.16b
-4:	ld1	{v4.2d}, [x10], #16		/* load next round key */
+4:	ld1	{v4.16b}, [x10], #16		/* load next round key */
 	subs	w7, w7, #3
 	aese	v0.16b, v3.16b
 	aesmc	v0.16b, v0.16b
 	aese	v1.16b, v3.16b
 	aesmc	v1.16b, v1.16b
-	ld1	{v5.2d}, [x10], #16		/* load next round key */
+	ld1	{v5.16b}, [x10], #16		/* load next round key */
 	bpl	2b
 	aese	v0.16b, v4.16b
 	aese	v1.16b, v4.16b
@@ -177,14 +178,14 @@ ENDPROC(ce_aes_ccm_final)
 	eor	v0.16b, v0.16b, v2.16b		/* xor mac with pt ^ rk[last] */
 	st1	{v1.16b}, [x0], #16		/* write output block */
 	bne	0b
-	rev	x8, x8
-	st1	{v0.2d}, [x5]			/* store mac */
+CPU_LE(	rev	x8, x8			)
+	st1	{v0.16b}, [x5]			/* store mac */
 	str	x8, [x6, #8]			/* store lsb end of ctr (BE) */
 5:	ret
 
 6:	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
 	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
-	st1	{v0.2d}, [x5]			/* store mac */
+	st1	{v0.16b}, [x5]			/* store mac */
 	add	w2, w2, #16			/* process partial tail block */
 7:	ldrb	w9, [x1], #1			/* get 1 byte of input */
 	umov	w6, v1.b[0]			/* get top crypted ctr byte */
-- 
2.7.4
