Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4B4C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 11:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiA0LgD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 06:36:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57554 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240535AbiA0LgC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 06:36:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A11E9B820FC
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 11:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C033C340EA;
        Thu, 27 Jan 2022 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643283360;
        bh=WVbTx1JyllWW4v3l+jd4ch0VO+J29rY+kHtvde10urI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m70CQ6dXCy4iqAMvqq89qpgNXPUOHosCNp4nPjN1TTlHumO0rNIs8D3C0yBrvEvRQ
         gpE+/F0KLVsNDlK5bU9iHquMWLcwxcp3/ZV+6rnhf51mQ1hR3ptEzgWGJ1SI66xMkm
         GlaMeZKem0AI4zDClg59R+f4fzl7Ossda9UvsWv9zmTJUEQ4hYFhGHuNCocrHKMK5x
         rfPMZlzI2bV5bx/KhHMFXgV8+d9kQmntoD8onkHDmFCoAAmmtBtW/SCELX850E5cc6
         /Viii0KbNukE0TNzRVmO7KBchhUJavF/Tz2eZeyjoHuekwhgvuFnclrrmCsXQr3YeY
         G17quMQME9cFQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/3] crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk
Date:   Thu, 27 Jan 2022 12:35:44 +0100
Message-Id: <20220127113545.7821-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127113545.7821-1-ardb@kernel.org>
References: <20220127113545.7821-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10563; h=from:subject; bh=WVbTx1JyllWW4v3l+jd4ch0VO+J29rY+kHtvde10urI=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8oOQM68sUxXYiQARl0nuBZtpH0RUbT8RxavnvxTX MNhpJGqJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfKDkAAKCRDDTyI5ktmPJCZRC/ 0Z3dPIhhOqxdHO+kEkNhHFuw+IR88Y0RzjuhCNovjG22ip6jmo5LmJ5/AvvpORq216lGtf/fi+6aN9 x+T48XAAZqknUgPvfJISq2+YyjewT3z/FWpWijjlO62OrntVKx1DJ3KIyqTuAtcKQ6dx7a/6UTgF28 Um26R2MpFfmtYaebmLbexcdFV5kfy2FXmN0RrScqPjvPm8jdl1yZcdgj/BqCk3+3XaAjZRliN8Dkjt GFYpCM1r972XAO4ptjI+VNKhuVA1I9/Dspx7CBGvefkEqS4D0EryG8hh1HT5ynBpd75+ZzltSXC2X7 1TK70vhYIURzJZOkms6+Mzr0ePDF/39wF3d5hq9kqh11SnNKvxyXD5p8hLHSZ2EzZYvTA1H9shoojb ae0dTNWJOHczNliRIgRTIOSIeAGswWIjYe5dl6ft+laptJyad4rmGo4q88NxV5ZEyZI6dU+nnYihzA gLF6cnNqjG7hItBIzOK6oLG6Kn/RQGvjxWOfLpGAKg7Xs=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of processing the entire input with the 8-way bit sliced
algorithm, which is sub-optimal for inputs that are not a multiple of
128 bytes in size, invoke the plain NEON version of CTR for the
remainder of the input after processing the bulk using 128 byte strides.

This allows us to greatly simplify the asm code that implements CTR, and
get rid of all the branches and special code paths. It also gains us a
couple of percent of performance.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-glue.c        |   1 +
 arch/arm64/crypto/aes-neonbs-core.S | 132 ++++----------------
 arch/arm64/crypto/aes-neonbs-glue.c |  64 +++++-----
 3 files changed, 55 insertions(+), 142 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 30b7cc6a7079..3127794c09d6 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -983,6 +983,7 @@ module_cpu_feature_match(AES, aes_init);
 module_init(aes_init);
 EXPORT_SYMBOL(neon_aes_ecb_encrypt);
 EXPORT_SYMBOL(neon_aes_cbc_encrypt);
+EXPORT_SYMBOL(neon_aes_ctr_encrypt);
 EXPORT_SYMBOL(neon_aes_xts_encrypt);
 EXPORT_SYMBOL(neon_aes_xts_decrypt);
 #endif
diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index a3405b8c344b..f2761481181d 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -869,133 +869,51 @@ SYM_FUNC_END(aesbs_xts_decrypt)
 
 	/*
 	 * aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
-	 *		     int rounds, int blocks, u8 iv[], u8 final[])
+	 *		     int rounds, int blocks, u8 iv[])
 	 */
 SYM_FUNC_START(aesbs_ctr_encrypt)
-	frame_push	8
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
 
-	mov		x19, x0
-	mov		x20, x1
-	mov		x21, x2
-	mov		x22, x3
-	mov		x23, x4
-	mov		x24, x5
-	mov		x25, x6
-
-	cmp		x25, #0
-	cset		x26, ne
-	add		x23, x23, x26		// do one extra block if final
-
-	ldp		x7, x8, [x24]
-	ld1		{v0.16b}, [x24]
+	ldp		x7, x8, [x5]
+	ld1		{v0.16b}, [x5]
 CPU_LE(	rev		x7, x7		)
 CPU_LE(	rev		x8, x8		)
 	adds		x8, x8, #1
 	adc		x7, x7, xzr
 
-99:	mov		x9, #1
-	lsl		x9, x9, x23
-	subs		w23, w23, #8
-	csel		x23, x23, xzr, pl
-	csel		x9, x9, xzr, le
-
-	tbnz		x9, #1, 0f
-	next_ctr	v1
-	tbnz		x9, #2, 0f
+0:	next_ctr	v1
 	next_ctr	v2
-	tbnz		x9, #3, 0f
 	next_ctr	v3
-	tbnz		x9, #4, 0f
 	next_ctr	v4
-	tbnz		x9, #5, 0f
 	next_ctr	v5
-	tbnz		x9, #6, 0f
 	next_ctr	v6
-	tbnz		x9, #7, 0f
 	next_ctr	v7
 
-0:	mov		bskey, x21
-	mov		rounds, x22
+	mov		bskey, x2
+	mov		rounds, x3
 	bl		aesbs_encrypt8
 
-	lsr		x9, x9, x26		// disregard the extra block
-	tbnz		x9, #0, 0f
-
-	ld1		{v8.16b}, [x20], #16
-	eor		v0.16b, v0.16b, v8.16b
-	st1		{v0.16b}, [x19], #16
-	tbnz		x9, #1, 1f
-
-	ld1		{v9.16b}, [x20], #16
-	eor		v1.16b, v1.16b, v9.16b
-	st1		{v1.16b}, [x19], #16
-	tbnz		x9, #2, 2f
-
-	ld1		{v10.16b}, [x20], #16
-	eor		v4.16b, v4.16b, v10.16b
-	st1		{v4.16b}, [x19], #16
-	tbnz		x9, #3, 3f
+	ld1		{ v8.16b-v11.16b}, [x1], #64
+	ld1		{v12.16b-v15.16b}, [x1], #64
 
-	ld1		{v11.16b}, [x20], #16
-	eor		v6.16b, v6.16b, v11.16b
-	st1		{v6.16b}, [x19], #16
-	tbnz		x9, #4, 4f
+	eor		v8.16b, v0.16b, v8.16b
+	eor		v9.16b, v1.16b, v9.16b
+	eor		v10.16b, v4.16b, v10.16b
+	eor		v11.16b, v6.16b, v11.16b
+	eor		v12.16b, v3.16b, v12.16b
+	eor		v13.16b, v7.16b, v13.16b
+	eor		v14.16b, v2.16b, v14.16b
+	eor		v15.16b, v5.16b, v15.16b
 
-	ld1		{v12.16b}, [x20], #16
-	eor		v3.16b, v3.16b, v12.16b
-	st1		{v3.16b}, [x19], #16
-	tbnz		x9, #5, 5f
+	st1		{ v8.16b-v11.16b}, [x0], #64
+	st1		{v12.16b-v15.16b}, [x0], #64
 
-	ld1		{v13.16b}, [x20], #16
-	eor		v7.16b, v7.16b, v13.16b
-	st1		{v7.16b}, [x19], #16
-	tbnz		x9, #6, 6f
-
-	ld1		{v14.16b}, [x20], #16
-	eor		v2.16b, v2.16b, v14.16b
-	st1		{v2.16b}, [x19], #16
-	tbnz		x9, #7, 7f
+	next_ctr	v0
+	subs		x4, x4, #8
+	b.gt		0b
 
-	ld1		{v15.16b}, [x20], #16
-	eor		v5.16b, v5.16b, v15.16b
-	st1		{v5.16b}, [x19], #16
-
-8:	next_ctr	v0
-	st1		{v0.16b}, [x24]
-	cbz		x23, .Lctr_done
-
-	b		99b
-
-.Lctr_done:
-	frame_pop
+	st1		{v0.16b}, [x5]
+	ldp		x29, x30, [sp], #16
 	ret
-
-	/*
-	 * If we are handling the tail of the input (x6 != NULL), return the
-	 * final keystream block back to the caller.
-	 */
-0:	cbz		x25, 8b
-	st1		{v0.16b}, [x25]
-	b		8b
-1:	cbz		x25, 8b
-	st1		{v1.16b}, [x25]
-	b		8b
-2:	cbz		x25, 8b
-	st1		{v4.16b}, [x25]
-	b		8b
-3:	cbz		x25, 8b
-	st1		{v6.16b}, [x25]
-	b		8b
-4:	cbz		x25, 8b
-	st1		{v3.16b}, [x25]
-	b		8b
-5:	cbz		x25, 8b
-	st1		{v7.16b}, [x25]
-	b		8b
-6:	cbz		x25, 8b
-	st1		{v2.16b}, [x25]
-	b		8b
-7:	cbz		x25, 8b
-	st1		{v5.16b}, [x25]
-	b		8b
 SYM_FUNC_END(aesbs_ctr_encrypt)
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 8df6ad8cb09d..3189003e1cbe 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -34,7 +34,7 @@ asmlinkage void aesbs_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]);
 
 asmlinkage void aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
-				  int rounds, int blocks, u8 iv[], u8 final[]);
+				  int rounds, int blocks, u8 iv[]);
 
 asmlinkage void aesbs_xts_encrypt(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]);
@@ -46,6 +46,8 @@ asmlinkage void neon_aes_ecb_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				     int rounds, int blocks);
 asmlinkage void neon_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				     int rounds, int blocks, u8 iv[]);
+asmlinkage void neon_aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				     int rounds, int bytes, u8 ctr[]);
 asmlinkage void neon_aes_xts_encrypt(u8 out[], u8 const in[],
 				     u32 const rk1[], int rounds, int bytes,
 				     u32 const rk2[], u8 iv[], int first);
@@ -58,7 +60,7 @@ struct aesbs_ctx {
 	int	rounds;
 } __aligned(AES_BLOCK_SIZE);
 
-struct aesbs_cbc_ctx {
+struct aesbs_cbc_ctr_ctx {
 	struct aesbs_ctx	key;
 	u32			enc[AES_MAX_KEYLENGTH_U32];
 };
@@ -128,10 +130,10 @@ static int ecb_decrypt(struct skcipher_request *req)
 	return __ecb_crypt(req, aesbs_ecb_decrypt);
 }
 
-static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+static int aesbs_cbc_ctr_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct aesbs_cbc_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_aes_ctx rk;
 	int err;
 
@@ -154,7 +156,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 static int cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct aesbs_cbc_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
 	int err;
 
@@ -177,7 +179,7 @@ static int cbc_encrypt(struct skcipher_request *req)
 static int cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct aesbs_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct aesbs_cbc_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
 	int err;
 
@@ -205,40 +207,32 @@ static int cbc_decrypt(struct skcipher_request *req)
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct aesbs_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct aesbs_cbc_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
-	u8 buf[AES_BLOCK_SIZE];
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes > 0) {
-		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
-		u8 *final = (walk.total % AES_BLOCK_SIZE) ? buf : NULL;
-
-		if (walk.nbytes < walk.total) {
-			blocks = round_down(blocks,
-					    walk.stride / AES_BLOCK_SIZE);
-			final = NULL;
-		}
+		int blocks = (walk.nbytes / AES_BLOCK_SIZE) & ~7;
+		int nbytes = walk.nbytes % (8 * AES_BLOCK_SIZE);
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
 
 		kernel_neon_begin();
-		aesbs_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				  ctx->rk, ctx->rounds, blocks, walk.iv, final);
-		kernel_neon_end();
-
-		if (final) {
-			u8 *dst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
-			u8 *src = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
-
-			crypto_xor_cpy(dst, src, final,
-				       walk.total % AES_BLOCK_SIZE);
-
-			err = skcipher_walk_done(&walk, 0);
-			break;
+		if (blocks >= 8) {
+			aesbs_ctr_encrypt(dst, src, ctx->key.rk, ctx->key.rounds,
+					  blocks, walk.iv);
+			dst += blocks * AES_BLOCK_SIZE;
+			src += blocks * AES_BLOCK_SIZE;
 		}
-		err = skcipher_walk_done(&walk,
-					 walk.nbytes - blocks * AES_BLOCK_SIZE);
+		if (nbytes && walk.nbytes == walk.total) {
+			neon_aes_ctr_encrypt(dst, src, ctx->enc, ctx->key.rounds,
+					     nbytes, walk.iv);
+			nbytes = 0;
+		}
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 	return err;
 }
@@ -402,14 +396,14 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_driver_name	= "cbc-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= AES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctx),
+	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctr_ctx),
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
 	.max_keysize		= AES_MAX_KEY_SIZE,
 	.walksize		= 8 * AES_BLOCK_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
-	.setkey			= aesbs_cbc_setkey,
+	.setkey			= aesbs_cbc_ctr_setkey,
 	.encrypt		= cbc_encrypt,
 	.decrypt		= cbc_decrypt,
 }, {
@@ -417,7 +411,7 @@ static struct skcipher_alg aes_algs[] = { {
 	.base.cra_driver_name	= "ctr-aes-neonbs",
 	.base.cra_priority	= 250,
 	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct aesbs_ctx),
+	.base.cra_ctxsize	= sizeof(struct aesbs_cbc_ctr_ctx),
 	.base.cra_module	= THIS_MODULE,
 
 	.min_keysize		= AES_MIN_KEY_SIZE,
@@ -425,7 +419,7 @@ static struct skcipher_alg aes_algs[] = { {
 	.chunksize		= AES_BLOCK_SIZE,
 	.walksize		= 8 * AES_BLOCK_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
-	.setkey			= aesbs_setkey,
+	.setkey			= aesbs_cbc_ctr_setkey,
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
 }, {
-- 
2.30.2

