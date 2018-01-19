From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 8/8] crypto/arm64: sha512 - fix/improve new v8.2 Crypto Extensions code
Date: Fri, 19 Jan 2018 12:04:40 +0000
Message-ID: <20180119120440.31556-9-ard.biesheuvel@linaro.org>
References: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:46704 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754232AbeASMFc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 07:05:32 -0500
Received: by mail-wm0-f68.google.com with SMTP id 143so2933601wma.5
        for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2018 04:05:31 -0800 (PST)
In-Reply-To: <20180119120440.31556-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a missing symbol export that prevents this code to be built as a
module. Also, move the round constant table to the .rodata section,
and use a more optimized version of the core transform.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/sha512-ce-core.S | 145 ++++++++++----------
 arch/arm64/crypto/sha512-glue.c    |   1 +
 2 files changed, 72 insertions(+), 74 deletions(-)

diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
index 6c562f8df0b0..7f3bca5c59a2 100644
--- a/arch/arm64/crypto/sha512-ce-core.S
+++ b/arch/arm64/crypto/sha512-ce-core.S
@@ -12,10 +12,7 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	//
-	// Temporary - for testing only. binutils has no support for these yet
-	//
-	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
 	.set		.Lq\b, \b
 	.set		.Lv\b\().2d, \b
 	.endr
@@ -36,12 +33,10 @@
 	.inst		0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
 	.endm
 
-	.text
-	.arch		armv8-a+crypto
-
 	/*
 	 * The SHA-512 round constants
 	 */
+	.section	".rodata", "a"
 	.align		4
 .Lsha512_rcon:
 	.quad		0x428a2f98d728ae22, 0x7137449123ef65cd
@@ -87,20 +82,20 @@
 
 	.macro		dround, i0, i1, i2, i3, i4, rc0, rc1, in0, in1, in2, in3, in4
 	.ifnb		\rc1
-	ld1		{v\rc1\().2d}, [x3], #16
+	ld1		{v\rc1\().2d}, [x4], #16
 	.endif
-	add		v\rc0\().2d, v\rc0\().2d, v\in0\().2d
+	add		v5.2d, v\rc0\().2d, v\in0\().2d
 	ext		v6.16b, v\i2\().16b, v\i3\().16b, #8
-	ext		v\rc0\().16b, v\rc0\().16b, v\rc0\().16b, #8
+	ext		v5.16b, v5.16b, v5.16b, #8
 	ext		v7.16b, v\i1\().16b, v\i2\().16b, #8
-	add		v\i3\().2d, v\i3\().2d, v\rc0\().2d
+	add		v\i3\().2d, v\i3\().2d, v5.2d
 	.ifnb		\in1
-	ext		v10.16b, v\in3\().16b, v\in4\().16b, #8
+	ext		v5.16b, v\in3\().16b, v\in4\().16b, #8
 	sha512su0	v\in0\().2d, v\in1\().2d
 	.endif
 	sha512h		q\i3, q6, v7.2d
 	.ifnb		\in1
-	sha512su1	v\in0\().2d, v\in2\().2d, v10.2d
+	sha512su1	v\in0\().2d, v\in2\().2d, v5.2d
 	.endif
 	add		v\i4\().2d, v\i1\().2d, v\i3\().2d
 	sha512h2	q\i3, q\i1, v\i0\().2d
@@ -110,18 +105,20 @@
 	 * void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
 	 *			  int blocks)
 	 */
+	.text
 ENTRY(sha512_ce_transform)
 	/* load state */
-	ld1		{v20.2d-v23.2d}, [x0]
+	ld1		{v8.2d-v11.2d}, [x0]
+
+	/* load first 4 round constants */
+	adr_l		x3, .Lsha512_rcon
+	ld1		{v20.2d-v23.2d}, [x3], #64
 
 	/* load input */
 0:	ld1		{v12.2d-v15.2d}, [x1], #64
 	ld1		{v16.2d-v19.2d}, [x1], #64
 	sub		w2, w2, #1
 
-	/* load round constants */
-	adr		x3, .Lsha512_rcon
-
 CPU_LE(	rev64		v12.16b, v12.16b	)
 CPU_LE(	rev64		v13.16b, v13.16b	)
 CPU_LE(	rev64		v14.16b, v14.16b	)
@@ -131,12 +128,12 @@ CPU_LE(	rev64		v17.16b, v17.16b	)
 CPU_LE(	rev64		v18.16b, v18.16b	)
 CPU_LE(	rev64		v19.16b, v19.16b	)
 
-	ld1		{v8.2d}, [x3], #16
+	mov		x4, x3				// rc pointer
 
-	mov		v0.16b, v20.16b
-	mov		v1.16b, v21.16b
-	mov		v2.16b, v22.16b
-	mov		v3.16b, v23.16b
+	mov		v0.16b, v8.16b
+	mov		v1.16b, v9.16b
+	mov		v2.16b, v10.16b
+	mov		v3.16b, v11.16b
 
 	// v0  ab  cd  --  ef  gh  ab
 	// v1  cd  --  ef  gh  ab  cd
@@ -144,64 +141,64 @@ CPU_LE(	rev64		v19.16b, v19.16b	)
 	// v3  gh  ab  cd  --  ef  gh
 	// v4  --  ef  gh  ab  cd  --
 
-	dround		0, 1, 2, 3, 4, 8, 9, 12, 13, 19, 16, 17
-	dround		3, 0, 4, 2, 1, 9, 8, 13, 14, 12, 17, 18
-	dround		2, 3, 1, 4, 0, 8, 9, 14, 15, 13, 18, 19
-	dround		4, 2, 0, 1, 3, 9, 8, 15, 16, 14, 19, 12
-	dround		1, 4, 3, 0, 2, 8, 9, 16, 17, 15, 12, 13
-
-	dround		0, 1, 2, 3, 4, 9, 8, 17, 18, 16, 13, 14
-	dround		3, 0, 4, 2, 1, 8, 9, 18, 19, 17, 14, 15
-	dround		2, 3, 1, 4, 0, 9, 8, 19, 12, 18, 15, 16
-	dround		4, 2, 0, 1, 3, 8, 9, 12, 13, 19, 16, 17
-	dround		1, 4, 3, 0, 2, 9, 8, 13, 14, 12, 17, 18
-
-	dround		0, 1, 2, 3, 4, 8, 9, 14, 15, 13, 18, 19
-	dround		3, 0, 4, 2, 1, 9, 8, 15, 16, 14, 19, 12
-	dround		2, 3, 1, 4, 0, 8, 9, 16, 17, 15, 12, 13
-	dround		4, 2, 0, 1, 3, 9, 8, 17, 18, 16, 13, 14
-	dround		1, 4, 3, 0, 2, 8, 9, 18, 19, 17, 14, 15
-
-	dround		0, 1, 2, 3, 4, 9, 8, 19, 12, 18, 15, 16
-	dround		3, 0, 4, 2, 1, 8, 9, 12, 13, 19, 16, 17
-	dround		2, 3, 1, 4, 0, 9, 8, 13, 14, 12, 17, 18
-	dround		4, 2, 0, 1, 3, 8, 9, 14, 15, 13, 18, 19
-	dround		1, 4, 3, 0, 2, 9, 8, 15, 16, 14, 19, 12
-
-	dround		0, 1, 2, 3, 4, 8, 9, 16, 17, 15, 12, 13
-	dround		3, 0, 4, 2, 1, 9, 8, 17, 18, 16, 13, 14
-	dround		2, 3, 1, 4, 0, 8, 9, 18, 19, 17, 14, 15
-	dround		4, 2, 0, 1, 3, 9, 8, 19, 12, 18, 15, 16
-	dround		1, 4, 3, 0, 2, 8, 9, 12, 13, 19, 16, 17
-
-	dround		0, 1, 2, 3, 4, 9, 8, 13, 14, 12, 17, 18
-	dround		3, 0, 4, 2, 1, 8, 9, 14, 15, 13, 18, 19
-	dround		2, 3, 1, 4, 0, 9, 8, 15, 16, 14, 19, 12
-	dround		4, 2, 0, 1, 3, 8, 9, 16, 17, 15, 12, 13
-	dround		1, 4, 3, 0, 2, 9, 8, 17, 18, 16, 13, 14
-
-	dround		0, 1, 2, 3, 4, 8, 9, 18, 19, 17, 14, 15
-	dround		3, 0, 4, 2, 1, 9, 8, 19, 12, 18, 15, 16
-	dround		2, 3, 1, 4, 0, 8, 9, 12
-	dround		4, 2, 0, 1, 3, 9, 8, 13
-	dround		1, 4, 3, 0, 2, 8, 9, 14
-
-	dround		0, 1, 2, 3, 4, 9, 8, 15
-	dround		3, 0, 4, 2, 1, 8, 9, 16
-	dround		2, 3, 1, 4, 0, 9, 8, 17
-	dround		4, 2, 0, 1, 3, 8, 9, 18
-	dround		1, 4, 3, 0, 2, 9,  , 19
+	dround		0, 1, 2, 3, 4, 20, 24, 12, 13, 19, 16, 17
+	dround		3, 0, 4, 2, 1, 21, 25, 13, 14, 12, 17, 18
+	dround		2, 3, 1, 4, 0, 22, 26, 14, 15, 13, 18, 19
+	dround		4, 2, 0, 1, 3, 23, 27, 15, 16, 14, 19, 12
+	dround		1, 4, 3, 0, 2, 24, 28, 16, 17, 15, 12, 13
+
+	dround		0, 1, 2, 3, 4, 25, 29, 17, 18, 16, 13, 14
+	dround		3, 0, 4, 2, 1, 26, 30, 18, 19, 17, 14, 15
+	dround		2, 3, 1, 4, 0, 27, 31, 19, 12, 18, 15, 16
+	dround		4, 2, 0, 1, 3, 28, 24, 12, 13, 19, 16, 17
+	dround		1, 4, 3, 0, 2, 29, 25, 13, 14, 12, 17, 18
+
+	dround		0, 1, 2, 3, 4, 30, 26, 14, 15, 13, 18, 19
+	dround		3, 0, 4, 2, 1, 31, 27, 15, 16, 14, 19, 12
+	dround		2, 3, 1, 4, 0, 24, 28, 16, 17, 15, 12, 13
+	dround		4, 2, 0, 1, 3, 25, 29, 17, 18, 16, 13, 14
+	dround		1, 4, 3, 0, 2, 26, 30, 18, 19, 17, 14, 15
+
+	dround		0, 1, 2, 3, 4, 27, 31, 19, 12, 18, 15, 16
+	dround		3, 0, 4, 2, 1, 28, 24, 12, 13, 19, 16, 17
+	dround		2, 3, 1, 4, 0, 29, 25, 13, 14, 12, 17, 18
+	dround		4, 2, 0, 1, 3, 30, 26, 14, 15, 13, 18, 19
+	dround		1, 4, 3, 0, 2, 31, 27, 15, 16, 14, 19, 12
+
+	dround		0, 1, 2, 3, 4, 24, 28, 16, 17, 15, 12, 13
+	dround		3, 0, 4, 2, 1, 25, 29, 17, 18, 16, 13, 14
+	dround		2, 3, 1, 4, 0, 26, 30, 18, 19, 17, 14, 15
+	dround		4, 2, 0, 1, 3, 27, 31, 19, 12, 18, 15, 16
+	dround		1, 4, 3, 0, 2, 28, 24, 12, 13, 19, 16, 17
+
+	dround		0, 1, 2, 3, 4, 29, 25, 13, 14, 12, 17, 18
+	dround		3, 0, 4, 2, 1, 30, 26, 14, 15, 13, 18, 19
+	dround		2, 3, 1, 4, 0, 31, 27, 15, 16, 14, 19, 12
+	dround		4, 2, 0, 1, 3, 24, 28, 16, 17, 15, 12, 13
+	dround		1, 4, 3, 0, 2, 25, 29, 17, 18, 16, 13, 14
+
+	dround		0, 1, 2, 3, 4, 26, 30, 18, 19, 17, 14, 15
+	dround		3, 0, 4, 2, 1, 27, 31, 19, 12, 18, 15, 16
+	dround		2, 3, 1, 4, 0, 28, 24, 12
+	dround		4, 2, 0, 1, 3, 29, 25, 13
+	dround		1, 4, 3, 0, 2, 30, 26, 14
+
+	dround		0, 1, 2, 3, 4, 31, 27, 15
+	dround		3, 0, 4, 2, 1, 24,   , 16
+	dround		2, 3, 1, 4, 0, 25,   , 17
+	dround		4, 2, 0, 1, 3, 26,   , 18
+	dround		1, 4, 3, 0, 2, 27,   , 19
 
 	/* update state */
-	add		v20.2d, v20.2d, v0.2d
-	add		v21.2d, v21.2d, v1.2d
-	add		v22.2d, v22.2d, v2.2d
-	add		v23.2d, v23.2d, v3.2d
+	add		v8.2d, v8.2d, v0.2d
+	add		v9.2d, v9.2d, v1.2d
+	add		v10.2d, v10.2d, v2.2d
+	add		v11.2d, v11.2d, v3.2d
 
 	/* handled all input blocks? */
 	cbnz		w2, 0b
 
 	/* store new state */
-3:	st1		{v20.2d-v23.2d}, [x0]
+3:	st1		{v8.2d-v11.2d}, [x0]
 	ret
 ENDPROC(sha512_ce_transform)
diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index aff35c9992a4..27db4851e380 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -27,6 +27,7 @@ MODULE_ALIAS_CRYPTO("sha512");
 
 asmlinkage void sha512_block_data_order(u32 *digest, const void *data,
 					unsigned int num_blks);
+EXPORT_SYMBOL(sha512_block_data_order);
 
 static int sha512_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
-- 
2.11.0
