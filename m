Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1301BC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C6122CED
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bneG9CkJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbfICQoA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:44:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34120 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQoA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:44:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id b24so11162799pfp.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lztbyRYUuu5cMp563Zlls3XdyH0KZSCJz0DwSh7fXts=;
        b=bneG9CkJ0iqWUkiAeHTNWE+/vDlISrWRvFAZrZx5Fv1pVFJXzXOsmkJ3rAbQrELRQ4
         rAkIwzTvItPqL3oC6MxxWF8sRS1iBwWe+Uj7zDsh3otzDj5qMPMo7H3wPn4nS8PyqGU0
         jN4yF/l6tDRErMWniDUAKCcCukJ2gILHpSNB08AEjGKnGDkhT383W9yEQjcP0SrQfcYF
         JIhx0tgDqCfAqQk3n3np7V1/4TxQCZg8ptZ8A1zurPGHhlTwnxvxnUy0RJ5RtFzSIOvz
         H1hBWQytOTv50O0i3GJs/Zi9QV4REnHCCv7xgNoeavEhQQ4TNvicKGL4ZnTkZ+gwEb2d
         I1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lztbyRYUuu5cMp563Zlls3XdyH0KZSCJz0DwSh7fXts=;
        b=a7D0fqIsW5uFFAN85de+srqeabVUt7rbLTvyGWIqCuXeH8khjuwLFoBBen89H6rUiN
         sgFJX5Z0gIm8URwyp/VBFt13KVyg/ZRqmHymdr9Cu7O5PpRtHhYj2HHgxYqpGUOgXJH2
         xAARPXwLZ/OrDyhWdITOeVKvEPaF0ONcSRVhAZYw+j/Y756cNMtCJAbpevnpl+paLTU3
         vX8SZYNSY4Z5WZTDFa0ndxjRDfdhOorFPTdDxVTHrDV9rn3mBUXUwEWU/d/Zowx/Zn4F
         P1CTbMS5QKGWb/0jgUymKsxANfgqD5kscX5CjLUYP7kWX/eZsaZZZonOn3DG79DRM/kU
         fuUA==
X-Gm-Message-State: APjAAAUIqqFA6YHaZ7+LYLdUyRpp8qUC+m9Pr61M58N6ul8tRUUjVnZ3
        oz9Uy5tfBfGrnmypgeTsGqpq1hcbcnf7ORIP
X-Google-Smtp-Source: APXvYqxK1n4syUK28eu9Q0hbMJNAgS6hmXwyZWk74F2t/lf6nKJIWl6H8okkCDazWRvNP3nwDUpzQw==
X-Received: by 2002:a17:90a:7f06:: with SMTP id k6mr188039pjl.87.1567529038878;
        Tue, 03 Sep 2019 09:43:58 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 11/17] crypto: arm64/aes - implement support for XTS ciphertext stealing
Date:   Tue,  3 Sep 2019 09:43:33 -0700
Message-Id: <20190903164339.27984-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
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

