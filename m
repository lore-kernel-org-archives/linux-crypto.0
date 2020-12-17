Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8342AC2BB9A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 18:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C19238EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 18:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgLQS4F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 13:56:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgLQS4E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 13:56:04 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/2] crypto: arm64/aes-ctr - improve tail handling
Date:   Thu, 17 Dec 2020 19:55:16 +0100
Message-Id: <20201217185516.26969-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201217185516.26969-1-ardb@kernel.org>
References: <20201217185516.26969-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Counter mode is a stream cipher chaining mode that is typically used
with inputs that are of arbitrarily length, and so a tail block which
is smaller than a full AES block is rule rather than exception.

The current ctr(aes) implementation for arm64 always makes a separate
call into the assembler routine to process this tail block, which is
suboptimal, given that it requires reloading of the AES round keys,
and prevents us from handling this tail block using the 5-way stride
that we use for better performance on deep pipelines.

So let's update the assembler routine so it can handle any input size,
and uses NEON permutation instructions and overlapping loads and stores
to handle the tail block. This results in a ~16% speedup for 1420 byte
blocks on cores with deep pipelines such as ThunderX2.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-glue.c  |  46 +++---
 arch/arm64/crypto/aes-modes.S | 165 +++++++++++++-------
 2 files changed, 137 insertions(+), 74 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index cafb5b96be0e..e7f116d833b9 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -24,6 +24,7 @@
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 #define MODE			"ce"
 #define PRIO			300
+#define STRIDE			5
 #define aes_expandkey		ce_aes_expandkey
 #define aes_ecb_encrypt		ce_aes_ecb_encrypt
 #define aes_ecb_decrypt		ce_aes_ecb_decrypt
@@ -41,6 +42,7 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #else
 #define MODE			"neon"
 #define PRIO			200
+#define STRIDE			4
 #define aes_ecb_encrypt		neon_aes_ecb_encrypt
 #define aes_ecb_decrypt		neon_aes_ecb_decrypt
 #define aes_cbc_encrypt		neon_aes_cbc_encrypt
@@ -87,7 +89,7 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int bytes, u8 const iv[]);
 
 asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
-				int rounds, int blocks, u8 ctr[]);
+				int rounds, int bytes, u8 ctr[], u8 finalbuf[]);
 
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int bytes, u32 const rk2[], u8 iv[],
@@ -448,34 +450,36 @@ static int ctr_encrypt(struct skcipher_request *req)
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err, rounds = 6 + ctx->key_length / 4;
 	struct skcipher_walk walk;
-	int blocks;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
-		kernel_neon_begin();
-		aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				ctx->key_enc, rounds, blocks, walk.iv);
-		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
-	}
-	if (walk.nbytes) {
-		u8 __aligned(8) tail[AES_BLOCK_SIZE];
+	while (walk.nbytes > 0) {
+		const u8 *src = walk.src.virt.addr;
 		unsigned int nbytes = walk.nbytes;
-		u8 *tdst = walk.dst.virt.addr;
-		u8 *tsrc = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 buf[AES_BLOCK_SIZE];
+		unsigned int tail;
 
-		/*
-		 * Tell aes_ctr_encrypt() to process a tail block.
-		 */
-		blocks = -1;
+		if (unlikely(nbytes < AES_BLOCK_SIZE))
+			src = memcpy(buf, src, nbytes);
+		else if (nbytes < walk.total)
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
 
 		kernel_neon_begin();
-		aes_ctr_encrypt(tail, NULL, ctx->key_enc, rounds,
-				blocks, walk.iv);
+		aes_ctr_encrypt(dst, src, ctx->key_enc, rounds, nbytes,
+				walk.iv, buf);
 		kernel_neon_end();
-		crypto_xor_cpy(tdst, tsrc, tail, nbytes);
-		err = skcipher_walk_done(&walk, 0);
+
+		tail = nbytes % (STRIDE * AES_BLOCK_SIZE);
+		if (tail > 0 && tail < AES_BLOCK_SIZE)
+			/*
+			 * The final partial block could not be returned using
+			 * an overlapping store, so it was passed via buf[]
+			 * instead.
+			 */
+			memcpy(dst + nbytes - tail, buf, tail);
+
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
 	return err;
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index cf618d8f6cec..3d1f97799899 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -321,42 +321,76 @@ AES_FUNC_END(aes_cbc_cts_decrypt)
 
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
-	 *		   int blocks, u8 ctr[])
+	 *		   int bytes, u8 ctr[], u8 finalbuf[])
 	 */
 
 AES_FUNC_START(aes_ctr_encrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
-	enc_prepare	w3, x2, x6
+	enc_prepare	w3, x2, x12
 	ld1		{vctr.16b}, [x5]
 
-	umov		x6, vctr.d[1]		/* keep swabbed ctr in reg */
-	rev		x6, x6
-	cmn		w6, w4			/* 32 bit overflow? */
-	bcs		.Lctrloop
+	umov		x12, vctr.d[1]		/* keep swabbed ctr in reg */
+	rev		x12, x12
+
 .LctrloopNx:
-	subs		w4, w4, #MAX_STRIDE
-	bmi		.Lctr1x
-	add		w7, w6, #1
+	add		w7, w4, #15
+	sub		w4, w4, #MAX_STRIDE << 4
+	lsr		w7, w7, #4
+	mov		w8, #MAX_STRIDE
+	cmp		w7, w8
+	csel		w7, w7, w8, lt
+	adds		x12, x12, x7
+
 	mov		v0.16b, vctr.16b
-	add		w8, w6, #2
 	mov		v1.16b, vctr.16b
-	add		w9, w6, #3
 	mov		v2.16b, vctr.16b
-	add		w9, w6, #3
-	rev		w7, w7
 	mov		v3.16b, vctr.16b
-	rev		w8, w8
 ST5(	mov		v4.16b, vctr.16b		)
-	mov		v1.s[3], w7
-	rev		w9, w9
-ST5(	add		w10, w6, #4			)
-	mov		v2.s[3], w8
-ST5(	rev		w10, w10			)
-	mov		v3.s[3], w9
-ST5(	mov		v4.s[3], w10			)
-	ld1		{v5.16b-v7.16b}, [x1], #48	/* get 3 input blocks */
+	bcs		0f
+
+	.subsection	1
+	/* apply carry to outgoing counter */
+0:	umov		x8, vctr.d[0]
+	rev		x8, x8
+	add		x8, x8, #1
+	rev		x8, x8
+	ins		vctr.d[0], x8
+
+	/* apply carry to N counter blocks for N := x12 */
+	adr		x16, 1f
+	sub		x16, x16, x12, lsl #3
+	br		x16
+	hint		34			// bti c
+	mov		v0.d[0], vctr.d[0]
+	hint		34			// bti c
+	mov		v1.d[0], vctr.d[0]
+	hint		34			// bti c
+	mov		v2.d[0], vctr.d[0]
+	hint		34			// bti c
+	mov		v3.d[0], vctr.d[0]
+ST5(	hint		34				)
+ST5(	mov		v4.d[0], vctr.d[0]		)
+1:	b		2f
+	.previous
+
+2:	rev		x7, x12
+	ins		vctr.d[1], x7
+	sub		x7, x12, #MAX_STRIDE - 1
+	sub		x8, x12, #MAX_STRIDE - 2
+	sub		x9, x12, #MAX_STRIDE - 3
+	rev		x7, x7
+	rev		x8, x8
+	mov		v1.d[1], x7
+	rev		x9, x9
+ST5(	sub		x10, x12, #MAX_STRIDE - 4	)
+	mov		v2.d[1], x8
+ST5(	rev		x10, x10			)
+	mov		v3.d[1], x9
+ST5(	mov		v4.d[1], x10			)
+	tbnz		w4, #31, .Lctrtail
+	ld1		{v5.16b-v7.16b}, [x1], #48
 ST4(	bl		aes_encrypt_block4x		)
 ST5(	bl		aes_encrypt_block5x		)
 	eor		v0.16b, v5.16b, v0.16b
@@ -368,47 +402,72 @@ ST5(	ld1		{v5.16b-v6.16b}, [x1], #32	)
 ST5(	eor		v4.16b, v6.16b, v4.16b		)
 	st1		{v0.16b-v3.16b}, [x0], #64
 ST5(	st1		{v4.16b}, [x0], #16		)
-	add		x6, x6, #MAX_STRIDE
-	rev		x7, x6
-	ins		vctr.d[1], x7
 	cbz		w4, .Lctrout
 	b		.LctrloopNx
-.Lctr1x:
-	adds		w4, w4, #MAX_STRIDE
-	beq		.Lctrout
-.Lctrloop:
-	mov		v0.16b, vctr.16b
-	encrypt_block	v0, w3, x2, x8, w7
-
-	adds		x6, x6, #1		/* increment BE ctr */
-	rev		x7, x6
-	ins		vctr.d[1], x7
-	bcs		.Lctrcarry		/* overflow? */
-
-.Lctrcarrydone:
-	subs		w4, w4, #1
-	bmi		.Lctrtailblock		/* blocks <0 means tail block */
-	ld1		{v3.16b}, [x1], #16
-	eor		v3.16b, v0.16b, v3.16b
-	st1		{v3.16b}, [x0], #16
-	bne		.Lctrloop
 
 .Lctrout:
 	st1		{vctr.16b}, [x5]	/* return next CTR value */
 	ldp		x29, x30, [sp], #16
 	ret
 
-.Lctrtailblock:
-	st1		{v0.16b}, [x0]
+.Lctrtail:
+	/* XOR up to MAX_STRIDE * 16 - 1 bytes of in/output with v0 ... v3/v4 */
+	mov		x16, #16
+	ands		x13, x4, #0xf
+	csel		x13, x13, x16, ne
+
+ST5(	cmp		w4, #64 - (MAX_STRIDE << 4)	)
+ST5(	csel		x14, x16, xzr, gt		)
+	cmp		w4, #48 - (MAX_STRIDE << 4)
+	csel		x15, x16, xzr, gt
+	cmp		w4, #32 - (MAX_STRIDE << 4)
+	csel		x16, x16, xzr, gt
+	cmp		w4, #16 - (MAX_STRIDE << 4)
+	ble		.Lctrtail1x
+
+	adr_l		x12, .Lcts_permute_table
+	add		x12, x12, x13
+
+ST5(	ld1		{v5.16b}, [x1], x14		)
+	ld1		{v6.16b}, [x1], x15
+	ld1		{v7.16b}, [x1], x16
+
+ST4(	bl		aes_encrypt_block4x		)
+ST5(	bl		aes_encrypt_block5x		)
+
+	ld1		{v8.16b}, [x1], x13
+	ld1		{v9.16b}, [x1]
+	ld1		{v10.16b}, [x12]
+
+ST4(	eor		v6.16b, v6.16b, v0.16b		)
+ST4(	eor		v7.16b, v7.16b, v1.16b		)
+ST4(	tbl		v3.16b, {v3.16b}, v10.16b	)
+ST4(	eor		v8.16b, v8.16b, v2.16b		)
+ST4(	eor		v9.16b, v9.16b, v3.16b		)
+
+ST5(	eor		v5.16b, v5.16b, v0.16b		)
+ST5(	eor		v6.16b, v6.16b, v1.16b		)
+ST5(	tbl		v4.16b, {v4.16b}, v10.16b	)
+ST5(	eor		v7.16b, v7.16b, v2.16b		)
+ST5(	eor		v8.16b, v8.16b, v3.16b		)
+ST5(	eor		v9.16b, v9.16b, v4.16b		)
+
+ST5(	st1		{v5.16b}, [x0], x14		)
+	st1		{v6.16b}, [x0], x15
+	st1		{v7.16b}, [x0], x16
+	add		x13, x13, x0
+	st1		{v9.16b}, [x13]		// overlapping stores
+	st1		{v8.16b}, [x0]
 	b		.Lctrout
 
-.Lctrcarry:
-	umov		x7, vctr.d[0]		/* load upper word of ctr  */
-	rev		x7, x7			/* ... to handle the carry */
-	add		x7, x7, #1
-	rev		x7, x7
-	ins		vctr.d[0], x7
-	b		.Lctrcarrydone
+.Lctrtail1x:
+	csel		x0, x0, x6, eq		// use finalbuf if less than a full block
+	ld1		{v5.16b}, [x1]
+ST5(	mov		v3.16b, v4.16b			)
+	encrypt_block	v3, w3, x2, x8, w7
+	eor		v5.16b, v5.16b, v3.16b
+	st1		{v5.16b}, [x0]
+	b		.Lctrout
 AES_FUNC_END(aes_ctr_encrypt)
 
 
-- 
2.17.1

