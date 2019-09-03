Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B684DC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86D4621881
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qT7FKLfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbfICQoD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:44:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33375 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQoD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:44:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so9465224pgn.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ss0hT+6FcmRtVnmYdaRt5cn9RrJ1dCb8Db0Ibbel/hM=;
        b=qT7FKLfOPYRHLYOnoAcjsz6UTVdRycrjXPObzeviWggNsvsetYNOqR+isKEFyR1RLS
         KV3wWpsfu1aWC4ezhzxuE9kTtCY8x9mnx5c2aIk/iLhD2MPWNCCiwJnmgjt4XPN8ymEh
         JhICdej3GKCMwR4eF8ni6ydFiMR4vQ806K3+Z3+4fzGrcfy/dgRtiyg9WWZfEs2c/y24
         6B2r5heX03jtWHdYZn9iAy+veE7OJWJdA4NfvUpIpNoia52IGIYPGDWrRtOIP0drh3f+
         lCmsOAvCQgTZVembdOmRpvwTbGsaTlZl4DgNJTcJ1rfyVa1mCqfyzzlFoz/8pTjngGwe
         vZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ss0hT+6FcmRtVnmYdaRt5cn9RrJ1dCb8Db0Ibbel/hM=;
        b=QtQimRUF421rVFQXhZ6fclFw6sXf+VliWkF1NgGkBUfZAr7wTl3wpad066Q/Z/SJCN
         HG2qw3B8HLLPGDIAvz4VTcq0OmviN3nA0J7EigVFO3Wpj0iCzFQDClECk7fgh0qCZlne
         iNO0+lNLWtb7bA/ZCILsX5fnhfbBj5waUPUsHWPgOu2lIGZxlxq3DIc/Sz6KF/Q31iFf
         x97A4Xxp24UWbkjXbSkZjYwJhEEUhd5XOonZrNuSVWpxpEhZ4s4C4vGegRRQoBsnm3QX
         gQ1kwMnjmDXJQ3zYw2xy+1wyoE64I2BtA76uYcyhNTp9ZcjZd/dqaPDiVbyBRmp9aQIy
         jhDQ==
X-Gm-Message-State: APjAAAUjcLA/xKQkdPIT4cYhMNjqXrfmoi+qqCnJW0+iniNakbEK8qTU
        xqt3C0IlMWh/F6SpcHttVbZ4wB3puc35j+LA
X-Google-Smtp-Source: APXvYqzcmzskeJt5jrcMuOAWF9kneZ7u7WfiSttZoJiTtnCtA9R4KCkBssoI/wT13jL/Qmbd28U4Mg==
X-Received: by 2002:a17:90a:b393:: with SMTP id e19mr230798pjr.118.1567529041664;
        Tue, 03 Sep 2019 09:44:01 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:44:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 13/17] crypto: arm/aes-ce - implement ciphertext stealing for XTS
Date:   Tue,  3 Sep 2019 09:43:35 -0700
Message-Id: <20190903164339.27984-14-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the AES-XTS implementation based on AES instructions so that it
can deal with inputs whose size is not a multiple of the cipher block
size. This is part of the original XTS specification, but was never
implemented before in the Linux kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-core.S | 103 ++++++++++++++--
 arch/arm/crypto/aes-ce-glue.c | 128 ++++++++++++++++++--
 2 files changed, 208 insertions(+), 23 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index bb6ec1844370..763e51604ab6 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -369,9 +369,9 @@ ENDPROC(ce_aes_ctr_encrypt)
 
 	/*
 	 * aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[], int rounds,
-	 *		   int blocks, u8 iv[], u32 const rk2[], int first)
+	 *		   int bytes, u8 iv[], u32 const rk2[], int first)
 	 * aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[], int rounds,
-	 *		   int blocks, u8 iv[], u32 const rk2[], int first)
+	 *		   int bytes, u8 iv[], u32 const rk2[], int first)
 	 */
 
 	.macro		next_tweak, out, in, const, tmp
@@ -414,7 +414,7 @@ ENTRY(ce_aes_xts_encrypt)
 .Lxtsencloop4x:
 	next_tweak	q4, q4, q15, q10
 .Lxtsenc4x:
-	subs		r4, r4, #4
+	subs		r4, r4, #64
 	bmi		.Lxtsenc1x
 	vld1.8		{q0-q1}, [r1]!		@ get 4 pt blocks
 	vld1.8		{q2-q3}, [r1]!
@@ -434,24 +434,58 @@ ENTRY(ce_aes_xts_encrypt)
 	vst1.8		{q2-q3}, [r0]!
 	vmov		q4, q7
 	teq		r4, #0
-	beq		.Lxtsencout
+	beq		.Lxtsencret
 	b		.Lxtsencloop4x
 .Lxtsenc1x:
-	adds		r4, r4, #4
+	adds		r4, r4, #64
 	beq		.Lxtsencout
+	subs		r4, r4, #16
+	bmi		.LxtsencctsNx
 .Lxtsencloop:
 	vld1.8		{q0}, [r1]!
+.Lxtsencctsout:
 	veor		q0, q0, q4
 	bl		aes_encrypt
 	veor		q0, q0, q4
-	vst1.8		{q0}, [r0]!
-	subs		r4, r4, #1
+	teq		r4, #0
 	beq		.Lxtsencout
+	subs		r4, r4, #16
 	next_tweak	q4, q4, q15, q6
+	bmi		.Lxtsenccts
+	vst1.8		{q0}, [r0]!
 	b		.Lxtsencloop
 .Lxtsencout:
+	vst1.8		{q0}, [r0]
+.Lxtsencret:
 	vst1.8		{q4}, [r5]
 	pop		{r4-r6, pc}
+
+.LxtsencctsNx:
+	vmov		q0, q3
+	sub		r0, r0, #16
+.Lxtsenccts:
+	movw		ip, :lower16:.Lcts_permute_table
+	movt		ip, :upper16:.Lcts_permute_table
+
+	add		r1, r1, r4		@ rewind input pointer
+	add		r4, r4, #16		@ # bytes in final block
+	add		lr, ip, #32
+	add		ip, ip, r4
+	sub		lr, lr, r4
+	add		r4, r0, r4		@ output address of final block
+
+	vld1.8		{q1}, [r1]		@ load final partial block
+	vld1.8		{q2}, [ip]
+	vld1.8		{q3}, [lr]
+
+	vtbl.8		d4, {d0-d1}, d4
+	vtbl.8		d5, {d0-d1}, d5
+	vtbx.8		d0, {d2-d3}, d6
+	vtbx.8		d1, {d2-d3}, d7
+
+	vst1.8		{q2}, [r4]		@ overlapping stores
+	mov		r4, #0
+	b		.Lxtsencctsout
 ENDPROC(ce_aes_xts_encrypt)
 
 
@@ -462,13 +496,17 @@ ENTRY(ce_aes_xts_decrypt)
 	prepare_key	r2, r3
 	vmov		q4, q0
 
+	/* subtract 16 bytes if we are doing CTS */
+	tst		r4, #0xf
+	subne		r4, r4, #0x10
+
 	teq		r6, #0			@ start of a block?
 	bne		.Lxtsdec4x
 
 .Lxtsdecloop4x:
 	next_tweak	q4, q4, q15, q10
 .Lxtsdec4x:
-	subs		r4, r4, #4
+	subs		r4, r4, #64
 	bmi		.Lxtsdec1x
 	vld1.8		{q0-q1}, [r1]!		@ get 4 ct blocks
 	vld1.8		{q2-q3}, [r1]!
@@ -491,22 +529,55 @@ ENTRY(ce_aes_xts_decrypt)
 	beq		.Lxtsdecout
 	b		.Lxtsdecloop4x
 .Lxtsdec1x:
-	adds		r4, r4, #4
+	adds		r4, r4, #64
 	beq		.Lxtsdecout
+	subs		r4, r4, #16
 .Lxtsdecloop:
 	vld1.8		{q0}, [r1]!
+	bmi		.Lxtsdeccts
+.Lxtsdecctsout:
 	veor		q0, q0, q4
-	add		ip, r2, #32		@ 3rd round key
 	bl		aes_decrypt
 	veor		q0, q0, q4
 	vst1.8		{q0}, [r0]!
-	subs		r4, r4, #1
+	teq		r4, #0
 	beq		.Lxtsdecout
+	subs		r4, r4, #16
 	next_tweak	q4, q4, q15, q6
 	b		.Lxtsdecloop
 .Lxtsdecout:
 	vst1.8		{q4}, [r5]
 	pop		{r4-r6, pc}
+
+.Lxtsdeccts:
+	movw		ip, :lower16:.Lcts_permute_table
+	movt		ip, :upper16:.Lcts_permute_table
+
+	add		r1, r1, r4		@ rewind input pointer
+	add		r4, r4, #16		@ # bytes in final block
+	add		lr, ip, #32
+	add		ip, ip, r4
+	sub		lr, lr, r4
+	add		r4, r0, r4		@ output address of final block
+
+	next_tweak	q5, q4, q15, q6
+
+	vld1.8		{q1}, [r1]		@ load final partial block
+	vld1.8		{q2}, [ip]
+	vld1.8		{q3}, [lr]
+
+	veor		q0, q0, q5
+	bl		aes_decrypt
+	veor		q0, q0, q5
+
+	vtbl.8		d4, {d0-d1}, d4
+	vtbl.8		d5, {d0-d1}, d5
+	vtbx.8		d0, {d2-d3}, d6
+	vtbx.8		d1, {d2-d3}, d7
+
+	vst1.8		{q2}, [r4]		@ overlapping stores
+	mov		r4, #0
+	b		.Lxtsdecctsout
 ENDPROC(ce_aes_xts_decrypt)
 
 	/*
@@ -532,3 +603,13 @@ ENTRY(ce_aes_invert)
 	vst1.32		{q0}, [r0]
 	bx		lr
 ENDPROC(ce_aes_invert)
+
+	.section	".rodata", "a"
+	.align		6
+.Lcts_permute_table:
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		 0x0,  0x1,  0x2,  0x3,  0x4,  0x5,  0x6,  0x7
+	.byte		 0x8,  0x9,  0xa,  0xb,  0xc,  0xd,  0xe,  0xf
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 486e862ae34a..c215792a2494 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -13,6 +13,7 @@
 #include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
 #include <linux/module.h>
 #include <crypto/xts.h>
@@ -39,10 +40,10 @@ asmlinkage void ce_aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks, u8 ctr[]);
 
 asmlinkage void ce_aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
-				   int rounds, int blocks, u8 iv[],
+				   int rounds, int bytes, u8 iv[],
 				   u32 const rk2[], int first);
 asmlinkage void ce_aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[],
-				   int rounds, int blocks, u8 iv[],
+				   int rounds, int bytes, u8 iv[],
 				   u32 const rk2[], int first);
 
 struct aes_block {
@@ -317,20 +318,71 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err, first, rounds = num_rounds(&ctx->key1);
+	int tail = req->cryptlen % AES_BLOCK_SIZE;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct scatterlist *src, *dst;
 	struct skcipher_walk walk;
-	unsigned int blocks;
+
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
+		int xts_blocks = DIV_ROUND_UP(req->cryptlen,
+					      AES_BLOCK_SIZE) - 2;
+
+		skcipher_walk_abort(&walk);
+
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(&subreq,
+					      skcipher_request_flags(req),
+					      NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   xts_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+		req = &subreq;
+		err = skcipher_walk_virt(&walk, req, false);
+	} else {
+		tail = 0;
+	}
+
+	for (first = 1; walk.nbytes >= AES_BLOCK_SIZE; first = 0) {
+		int nbytes = walk.nbytes;
+
+		if (walk.nbytes < walk.total)
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+
 		kernel_neon_begin();
 		ce_aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   ctx->key1.key_enc, rounds, blocks, walk.iv,
+				   ctx->key1.key_enc, rounds, nbytes, walk.iv,
 				   ctx->key2.key_enc, first);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
-	return err;
+
+	if (err || likely(!tail))
+		return err;
+
+	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+	if (req->dst != req->src)
+		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+
+	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+
+	kernel_neon_begin();
+	ce_aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			   ctx->key1.key_enc, rounds, walk.nbytes, walk.iv,
+			   ctx->key2.key_enc, first);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -338,20 +390,71 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err, first, rounds = num_rounds(&ctx->key1);
+	int tail = req->cryptlen % AES_BLOCK_SIZE;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct scatterlist *src, *dst;
 	struct skcipher_walk walk;
-	unsigned int blocks;
+
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
+		int xts_blocks = DIV_ROUND_UP(req->cryptlen,
+					      AES_BLOCK_SIZE) - 2;
+
+		skcipher_walk_abort(&walk);
+
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(&subreq,
+					      skcipher_request_flags(req),
+					      NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   xts_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+		req = &subreq;
+		err = skcipher_walk_virt(&walk, req, false);
+	} else {
+		tail = 0;
+	}
+
+	for (first = 1; walk.nbytes >= AES_BLOCK_SIZE; first = 0) {
+		int nbytes = walk.nbytes;
+
+		if (walk.nbytes < walk.total)
+			nbytes &= ~(AES_BLOCK_SIZE - 1);
+
 		kernel_neon_begin();
 		ce_aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   ctx->key1.key_dec, rounds, blocks, walk.iv,
+				   ctx->key1.key_dec, rounds, nbytes, walk.iv,
 				   ctx->key2.key_enc, first);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
-	return err;
+
+	if (err || likely(!tail))
+		return err;
+
+	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+	if (req->dst != req->src)
+		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+
+	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+
+	kernel_neon_begin();
+	ce_aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			   ctx->key1.key_dec, rounds, walk.nbytes, walk.iv,
+			   ctx->key2.key_enc, first);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
 }
 
 static struct skcipher_alg aes_algs[] = { {
@@ -426,6 +529,7 @@ static struct skcipher_alg aes_algs[] = { {
 	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
 	.ivsize			= AES_BLOCK_SIZE,
+	.walksize		= 2 * AES_BLOCK_SIZE,
 	.setkey			= xts_set_key,
 	.encrypt		= xts_encrypt,
 	.decrypt		= xts_decrypt,
-- 
2.17.1

