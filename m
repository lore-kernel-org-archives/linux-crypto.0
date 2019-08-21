Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAAEC3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98B90216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AZj37Mwb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfHUOdX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39528 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfHUOdW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id i63so2381044wmg.4
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lztbyRYUuu5cMp563Zlls3XdyH0KZSCJz0DwSh7fXts=;
        b=AZj37MwbCaqyqq/V9/vMcceDFC/L/NYKHrv/WBzJjhkpE6DBMyo0T/ZINQeoCmgxMT
         oMVyQ6t5g6NosETRFqncBWEoc3haQar9hXndW81bovcunShgneer4VMQVsUyylQJHYIj
         oplc0ZpoAsN9RhRZTG9asF6VYfcZNctu9vx5hrVAoE6knnwbU0mTHbTYwOcNj0eAP3G/
         PIwHUJHZTC1d/5vCq6DMlP4TvGG8ZovVY9VEjQBodg/bQPzseOV4rYujwG0GdhO/xUXu
         2oS3LwwiJhQ62SN/xH91HWUMbZL6w7k/smFybBJwCkO/ksKTsvR2Zf2zZI4iRM8IgwCo
         h1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lztbyRYUuu5cMp563Zlls3XdyH0KZSCJz0DwSh7fXts=;
        b=kgBLdjQYCtEXEUOPbX4Yi2tzPoAfi9oJ4vHYpr6oKZ0uIKGmcPf/jtGTEOK6PSa15J
         419yxkWLDTYwqM95FiFwMxL1Y4edVg4J8D8tk3GEZvk6Znyj9LDOBSHLVizcqeke3iVj
         SptRK5CZ3mK+FEEsB0jtyhRBHdsbku8celtCEMtNdZ1+AEeMt0JU0QMSDW28cgdLjzH6
         ZgS8zn/jDDzoi6llLktCh6XLyU/HbHbkn/XrbDOxQ5TldvobLZrDIKDJtQ/StBueZxPa
         N96c848DfivysWnun7PhVy5ttVVLhINjpFmbFPC9qOXaZqTcGRZo4zWwWW/jM0eF4Oob
         gyNA==
X-Gm-Message-State: APjAAAXgfCzMrleoLdnoAIu30Sgn593oFk1B9j+q7AndTHkGvOnKsHry
        7gH2KiIxgpbZSUdgxLrvI9n4Q6nAoVzmHQ==
X-Google-Smtp-Source: APXvYqx89XdiU8twJmBh2qQNXsp5d6kwzSU5VaRjM7qGBGUtCARI4qxJcWLLUZoXxUpjVQ59pufKWg==
X-Received: by 2002:a05:600c:228e:: with SMTP id 14mr361348wmf.101.1566397998234;
        Wed, 21 Aug 2019 07:33:18 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:17 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 11/17] crypto: arm64/aes - implement support for XTS ciphertext stealing
Date:   Wed, 21 Aug 2019 17:32:47 +0300
Message-Id: <20190821143253.30209-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the missing support for ciphertext stealing in the implementation
of AES-XTS, which is part of the XTS specification but was omitted up
until now due to lack of a need for it.

The asm helpers are updated so they can deal with any input size, as
long as the last full block and the final partial block are presented
at the same time. The glue code is updated so that the common case of
operating on a sector or page is mostly as before. When CTS is needed,
the walk is split up into two pieces, unless the entire input is covered
by a single step.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c  | 126 ++++++++++++++++++--
 arch/arm64/crypto/aes-modes.S |  99 ++++++++++++---
 2 files changed, 195 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 5ee980c5a5c2..eecb74fd2f61 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -90,10 +90,10 @@ asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				int rounds, int blocks, u8 ctr[]);
 
 asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
-				int rounds, int blocks, u32 const rk2[], u8 iv[],
+				int rounds, int bytes, u32 const rk2[], u8 iv[],
 				int first);
 asmlinkage void aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[],
-				int rounds, int blocks, u32 const rk2[], u8 iv[],
+				int rounds, int bytes, u32 const rk2[], u8 iv[],
 				int first);
 
 asmlinkage void aes_essiv_cbc_encrypt(u8 out[], u8 const in[], u32 const rk1[],
@@ -529,21 +529,71 @@ static int __maybe_unused xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err, first, rounds = 6 + ctx->key1.key_length / 4;
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
 		aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				ctx->key1.key_enc, rounds, blocks,
+				ctx->key1.key_enc, rounds, nbytes,
 				ctx->key2.key_enc, walk.iv, first);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
-	return err;
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
+	err = skcipher_walk_virt(&walk, &subreq, false);
+	if (err)
+		return err;
+
+	kernel_neon_begin();
+	aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			ctx->key1.key_enc, rounds, walk.nbytes,
+			ctx->key2.key_enc, walk.iv, first);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
 }
 
 static int __maybe_unused xts_decrypt(struct skcipher_request *req)
@@ -551,21 +601,72 @@ static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err, first, rounds = 6 + ctx->key1.key_length / 4;
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
 		aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				ctx->key1.key_dec, rounds, blocks,
+				ctx->key1.key_dec, rounds, nbytes,
 				ctx->key2.key_enc, walk.iv, first);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 
-	return err;
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
+	err = skcipher_walk_virt(&walk, &subreq, false);
+	if (err)
+		return err;
+
+
+	kernel_neon_begin();
+	aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			ctx->key1.key_dec, rounds, walk.nbytes,
+			ctx->key2.key_enc, walk.iv, first);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
 }
 
 static struct skcipher_alg aes_algs[] = { {
@@ -646,6 +747,7 @@ static struct skcipher_alg aes_algs[] = { {
 	.min_keysize	= 2 * AES_MIN_KEY_SIZE,
 	.max_keysize	= 2 * AES_MAX_KEY_SIZE,
 	.ivsize		= AES_BLOCK_SIZE,
+	.walksize	= 2 * AES_BLOCK_SIZE,
 	.setkey		= xts_set_key,
 	.encrypt	= xts_encrypt,
 	.decrypt	= xts_decrypt,
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 38cd5a2091a8..f2c2ba739f36 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -413,10 +413,10 @@ AES_ENDPROC(aes_ctr_encrypt)
 
 
 	/*
+	 * aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
+	 *		   int bytes, u8 const rk2[], u8 iv[], int first)
 	 * aes_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-	 *		   int blocks, u8 const rk2[], u8 iv[], int first)
-	 * aes_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-	 *		   int blocks, u8 const rk2[], u8 iv[], int first)
+	 *		   int bytes, u8 const rk2[], u8 iv[], int first)
 	 */
 
 	.macro		next_tweak, out, in, tmp
@@ -451,7 +451,7 @@ AES_ENTRY(aes_xts_encrypt)
 .LxtsencloopNx:
 	next_tweak	v4, v4, v8
 .LxtsencNx:
-	subs		w4, w4, #4
+	subs		w4, w4, #64
 	bmi		.Lxtsenc1x
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 pt blocks */
 	next_tweak	v5, v4, v8
@@ -468,33 +468,66 @@ AES_ENTRY(aes_xts_encrypt)
 	eor		v2.16b, v2.16b, v6.16b
 	st1		{v0.16b-v3.16b}, [x0], #64
 	mov		v4.16b, v7.16b
-	cbz		w4, .Lxtsencout
+	cbz		w4, .Lxtsencret
 	xts_reload_mask	v8
 	b		.LxtsencloopNx
 .Lxtsenc1x:
-	adds		w4, w4, #4
+	adds		w4, w4, #64
 	beq		.Lxtsencout
+	subs		w4, w4, #16
+	bmi		.LxtsencctsNx
 .Lxtsencloop:
-	ld1		{v1.16b}, [x1], #16
-	eor		v0.16b, v1.16b, v4.16b
+	ld1		{v0.16b}, [x1], #16
+.Lxtsencctsout:
+	eor		v0.16b, v0.16b, v4.16b
 	encrypt_block	v0, w3, x2, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
-	st1		{v0.16b}, [x0], #16
-	subs		w4, w4, #1
-	beq		.Lxtsencout
+	cbz		w4, .Lxtsencout
+	subs		w4, w4, #16
 	next_tweak	v4, v4, v8
+	bmi		.Lxtsenccts
+	st1		{v0.16b}, [x0], #16
 	b		.Lxtsencloop
 .Lxtsencout:
+	st1		{v0.16b}, [x0]
+.Lxtsencret:
 	st1		{v4.16b}, [x6]
 	ldp		x29, x30, [sp], #16
 	ret
-AES_ENDPROC(aes_xts_encrypt)
 
+.LxtsencctsNx:
+	mov		v0.16b, v3.16b
+	sub		x0, x0, #16
+.Lxtsenccts:
+	adr_l		x8, .Lcts_permute_table
+
+	add		x1, x1, w4, sxtw	/* rewind input pointer */
+	add		w4, w4, #16		/* # bytes in final block */
+	add		x9, x8, #32
+	add		x8, x8, x4
+	sub		x9, x9, x4
+	add		x4, x0, x4		/* output address of final block */
+
+	ld1		{v1.16b}, [x1]		/* load final block */
+	ld1		{v2.16b}, [x8]
+	ld1		{v3.16b}, [x9]
+
+	tbl		v2.16b, {v0.16b}, v2.16b
+	tbx		v0.16b, {v1.16b}, v3.16b
+	st1		{v2.16b}, [x4]			/* overlapping stores */
+	mov		w4, wzr
+	b		.Lxtsencctsout
+AES_ENDPROC(aes_xts_encrypt)
 
 AES_ENTRY(aes_xts_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
+	/* subtract 16 bytes if we are doing CTS */
+	sub		w8, w4, #0x10
+	tst		w4, #0xf
+	csel		w4, w4, w8, eq
+
 	ld1		{v4.16b}, [x6]
 	xts_load_mask	v8
 	cbz		w7, .Lxtsdecnotfirst
@@ -509,7 +542,7 @@ AES_ENTRY(aes_xts_decrypt)
 .LxtsdecloopNx:
 	next_tweak	v4, v4, v8
 .LxtsdecNx:
-	subs		w4, w4, #4
+	subs		w4, w4, #64
 	bmi		.Lxtsdec1x
 	ld1		{v0.16b-v3.16b}, [x1], #64	/* get 4 ct blocks */
 	next_tweak	v5, v4, v8
@@ -530,22 +563,52 @@ AES_ENTRY(aes_xts_decrypt)
 	xts_reload_mask	v8
 	b		.LxtsdecloopNx
 .Lxtsdec1x:
-	adds		w4, w4, #4
+	adds		w4, w4, #64
 	beq		.Lxtsdecout
+	subs		w4, w4, #16
 .Lxtsdecloop:
-	ld1		{v1.16b}, [x1], #16
-	eor		v0.16b, v1.16b, v4.16b
+	ld1		{v0.16b}, [x1], #16
+	bmi		.Lxtsdeccts
+.Lxtsdecctsout:
+	eor		v0.16b, v0.16b, v4.16b
 	decrypt_block	v0, w3, x2, x8, w7
 	eor		v0.16b, v0.16b, v4.16b
 	st1		{v0.16b}, [x0], #16
-	subs		w4, w4, #1
-	beq		.Lxtsdecout
+	cbz		w4, .Lxtsdecout
+	subs		w4, w4, #16
 	next_tweak	v4, v4, v8
 	b		.Lxtsdecloop
 .Lxtsdecout:
 	st1		{v4.16b}, [x6]
 	ldp		x29, x30, [sp], #16
 	ret
+
+.Lxtsdeccts:
+	adr_l		x8, .Lcts_permute_table
+
+	add		x1, x1, w4, sxtw	/* rewind input pointer */
+	add		w4, w4, #16		/* # bytes in final block */
+	add		x9, x8, #32
+	add		x8, x8, x4
+	sub		x9, x9, x4
+	add		x4, x0, x4		/* output address of final block */
+
+	next_tweak	v5, v4, v8
+
+	ld1		{v1.16b}, [x1]		/* load final block */
+	ld1		{v2.16b}, [x8]
+	ld1		{v3.16b}, [x9]
+
+	eor		v0.16b, v0.16b, v5.16b
+	decrypt_block	v0, w3, x2, x8, w7
+	eor		v0.16b, v0.16b, v5.16b
+
+	tbl		v2.16b, {v0.16b}, v2.16b
+	tbx		v0.16b, {v1.16b}, v3.16b
+
+	st1		{v2.16b}, [x4]			/* overlapping stores */
+	mov		w4, wzr
+	b		.Lxtsdecctsout
 AES_ENDPROC(aes_xts_decrypt)
 
 	/*
-- 
2.17.1

