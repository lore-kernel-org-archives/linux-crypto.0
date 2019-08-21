Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A68C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41A42339F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IZHnHCuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfHUOd3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39106 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfHUOd3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so2272424wra.6
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hp23yxcEr25HscpkTDg71i1OPHKTlvstuNQTz096mYk=;
        b=IZHnHCuDr0MnRcraaSf2WWBr1lyW3xoaETta+/qC9crDFRcCFKIEbFgj2Tax0to+l9
         QU8tHDpB/N1+hT73pXihZ/H0V50hqJ1/ruOSWjT4k1T4TFuZ11Z35VppXgqFuIJSECxJ
         v4uLCkZgv1dBVS0TWs7VOsWxjrAwrs+bEfyErdMcV3FCxEY7rZox1fcRS5XQF6w+1PZa
         lrOMxk5EDL8mVykogB6NRZgedQYXhs4XgRaiLumem/CNsaAgXjBkeQBmGXxHIf7Qg6S6
         HOJYK2w/VO0aPYqeMFaNotIpzQMs3BofyzzuS2UM/U1PraVTP3xIfVqOx442jY7OsZrz
         fElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hp23yxcEr25HscpkTDg71i1OPHKTlvstuNQTz096mYk=;
        b=euH395RVap6cUd+XIHS56N7FCMaLnPoy2Sx1J7XDDiL0oT2KY1X505FoSFQfFiUsry
         X/yUpR+Q4g/7v0GYwuRBS/bef3VKDAsxTACwdaGARPYPCUDTJ1thD6r/Hg4BwB+5X46q
         Cs41WoIpdJoLEerEPK8/h82tE9LYI6bvW9+lpkUVnakL76e5/rOqlAbRVFk9v3eaWPpQ
         +9thQaLGv4qVJ3S2U9SVEdEEQRuzzXN2GXoeTKlIm2wkuNqjt96AQvJVMiquwYvGE7z1
         6OLyeNkRsSklCvstxtnBpBgL1KoYaV9gXG3ixik+lTUlTDxAsiVhl5rjq51XhDwpu07B
         gptw==
X-Gm-Message-State: APjAAAW7ajgnMa8Jz5U29esxK2mp6oquLNVE3F4h1tUb0b6X6nM6Z3C+
        gZ5weok4NE+mD/oZPZ0AUmRxwWFEkqwSog==
X-Google-Smtp-Source: APXvYqws62AWObiYwLq7xVEZsKIubb89xrbxzSXRuOIdzDsBWhmyAQgr5CaX1PU0+2euV3jt09Zh8A==
X-Received: by 2002:adf:d4c6:: with SMTP id w6mr42019243wrk.98.1566398005615;
        Wed, 21 Aug 2019 07:33:25 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:24 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 15/17] crypto: arm/aes-ce - implement ciphertext stealing for CBC
Date:   Wed, 21 Aug 2019 17:32:51 +0300
Message-Id: <20190821143253.30209-16-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of relying on the CTS template to wrap the accelerated CBC
skcipher, implement the ciphertext stealing part directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-core.S |  85 +++++++++
 arch/arm/crypto/aes-ce-glue.c | 188 ++++++++++++++++++--
 2 files changed, 256 insertions(+), 17 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index 763e51604ab6..b978cdf133af 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -284,6 +284,91 @@ ENTRY(ce_aes_cbc_decrypt)
 	pop		{r4-r6, pc}
 ENDPROC(ce_aes_cbc_decrypt)
 
+
+	/*
+	 * ce_aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
+	 *			  int rounds, int bytes, u8 const iv[])
+	 * ce_aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
+	 *			  int rounds, int bytes, u8 const iv[])
+	 */
+
+ENTRY(ce_aes_cbc_cts_encrypt)
+	push		{r4-r6, lr}
+	ldrd		r4, r5, [sp, #16]
+
+	movw		ip, :lower16:.Lcts_permute_table
+	movt		ip, :upper16:.Lcts_permute_table
+	sub		r4, r4, #16
+	add		lr, ip, #32
+	add		ip, ip, r4
+	sub		lr, lr, r4
+	vld1.8		{q5}, [ip]
+	vld1.8		{q6}, [lr]
+
+	add		ip, r1, r4
+	vld1.8		{q0}, [r1]			@ overlapping loads
+	vld1.8		{q3}, [ip]
+
+	vld1.8		{q1}, [r5]			@ get iv
+	prepare_key	r2, r3
+
+	veor		q0, q0, q1			@ xor with iv
+	bl		aes_encrypt
+
+	vtbl.8		d4, {d0-d1}, d10
+	vtbl.8		d5, {d0-d1}, d11
+	vtbl.8		d2, {d6-d7}, d12
+	vtbl.8		d3, {d6-d7}, d13
+
+	veor		q0, q0, q1
+	bl		aes_encrypt
+
+	add		r4, r0, r4
+	vst1.8		{q2}, [r4]			@ overlapping stores
+	vst1.8		{q0}, [r0]
+
+	pop		{r4-r6, pc}
+ENDPROC(ce_aes_cbc_cts_encrypt)
+
+ENTRY(ce_aes_cbc_cts_decrypt)
+	push		{r4-r6, lr}
+	ldrd		r4, r5, [sp, #16]
+
+	movw		ip, :lower16:.Lcts_permute_table
+	movt		ip, :upper16:.Lcts_permute_table
+	sub		r4, r4, #16
+	add		lr, ip, #32
+	add		ip, ip, r4
+	sub		lr, lr, r4
+	vld1.8		{q5}, [ip]
+	vld1.8		{q6}, [lr]
+
+	add		ip, r1, r4
+	vld1.8		{q0}, [r1]			@ overlapping loads
+	vld1.8		{q1}, [ip]
+
+	vld1.8		{q3}, [r5]			@ get iv
+	prepare_key	r2, r3
+
+	bl		aes_decrypt
+
+	vtbl.8		d4, {d0-d1}, d10
+	vtbl.8		d5, {d0-d1}, d11
+	vtbx.8		d0, {d2-d3}, d12
+	vtbx.8		d1, {d2-d3}, d13
+
+	veor		q1, q1, q2
+	bl		aes_decrypt
+	veor		q0, q0, q3			@ xor with iv
+
+	add		r4, r0, r4
+	vst1.8		{q1}, [r4]			@ overlapping stores
+	vst1.8		{q0}, [r0]
+
+	pop		{r4-r6, pc}
+ENDPROC(ce_aes_cbc_cts_decrypt)
+
+
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
 	 *		   int blocks, u8 ctr[])
diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index c215792a2494..cdb1a07e7ad0 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -35,6 +35,10 @@ asmlinkage void ce_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks, u8 iv[]);
 asmlinkage void ce_aes_cbc_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks, u8 iv[]);
+asmlinkage void ce_aes_cbc_cts_encrypt(u8 out[], u8 const in[], u32 const rk[],
+				   int rounds, int bytes, u8 const iv[]);
+asmlinkage void ce_aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
+				   int rounds, int bytes, u8 const iv[]);
 
 asmlinkage void ce_aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks, u8 ctr[]);
@@ -210,48 +214,182 @@ static int ecb_decrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int cbc_encrypt(struct skcipher_request *req)
+static int cbc_encrypt_walk(struct skcipher_request *req,
+			    struct skcipher_walk *walk)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
 	unsigned int blocks;
-	int err;
+	int err = 0;
 
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
-		ce_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+		ce_aes_cbc_encrypt(walk->dst.virt.addr, walk->src.virt.addr,
 				   ctx->key_enc, num_rounds(ctx), blocks,
-				   walk.iv);
+				   walk->iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
 
-static int cbc_decrypt(struct skcipher_request *req)
+static int cbc_encrypt(struct skcipher_request *req)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
-	unsigned int blocks;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+	return cbc_encrypt_walk(req, &walk);
+}
 
-	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+static int cbc_decrypt_walk(struct skcipher_request *req,
+			    struct skcipher_walk *walk)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned int blocks;
+	int err = 0;
+
+	while ((blocks = (walk->nbytes / AES_BLOCK_SIZE))) {
 		kernel_neon_begin();
-		ce_aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+		ce_aes_cbc_decrypt(walk->dst.virt.addr, walk->src.virt.addr,
 				   ctx->key_dec, num_rounds(ctx), blocks,
-				   walk.iv);
+				   walk->iv);
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+		err = skcipher_walk_done(walk, walk->nbytes % AES_BLOCK_SIZE);
 	}
 	return err;
 }
 
+static int cbc_decrypt(struct skcipher_request *req)
+{
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+	return cbc_decrypt_walk(req, &walk);
+}
+
+static int cts_cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
+	struct scatterlist *src = req->src, *dst = req->dst;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct skcipher_walk walk;
+	int err;
+
+	skcipher_request_set_tfm(&subreq, tfm);
+	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
+				      NULL, NULL);
+
+	if (req->cryptlen <= AES_BLOCK_SIZE) {
+		if (req->cryptlen < AES_BLOCK_SIZE)
+			return -EINVAL;
+		cbc_blocks = 1;
+	}
+
+	if (cbc_blocks > 0) {
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   cbc_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+
+		err = skcipher_walk_virt(&walk, &subreq, false) ?:
+		      cbc_encrypt_walk(&subreq, &walk);
+		if (err)
+			return err;
+
+		if (req->cryptlen == AES_BLOCK_SIZE)
+			return 0;
+
+		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst,
+					       subreq.cryptlen);
+	}
+
+	/* handle ciphertext stealing */
+	skcipher_request_set_crypt(&subreq, src, dst,
+				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, &subreq, false);
+	if (err)
+		return err;
+
+	kernel_neon_begin();
+	ce_aes_cbc_cts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			       ctx->key_enc, num_rounds(ctx), walk.nbytes,
+			       walk.iv);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
+}
+
+static int cts_cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int cbc_blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
+	struct scatterlist *src = req->src, *dst = req->dst;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct skcipher_walk walk;
+	int err;
+
+	skcipher_request_set_tfm(&subreq, tfm);
+	skcipher_request_set_callback(&subreq, skcipher_request_flags(req),
+				      NULL, NULL);
+
+	if (req->cryptlen <= AES_BLOCK_SIZE) {
+		if (req->cryptlen < AES_BLOCK_SIZE)
+			return -EINVAL;
+		cbc_blocks = 1;
+	}
+
+	if (cbc_blocks > 0) {
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   cbc_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+
+		err = skcipher_walk_virt(&walk, &subreq, false) ?:
+		      cbc_decrypt_walk(&subreq, &walk);
+		if (err)
+			return err;
+
+		if (req->cryptlen == AES_BLOCK_SIZE)
+			return 0;
+
+		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst,
+					       subreq.cryptlen);
+	}
+
+	/* handle ciphertext stealing */
+	skcipher_request_set_crypt(&subreq, src, dst,
+				   req->cryptlen - cbc_blocks * AES_BLOCK_SIZE,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, &subreq, false);
+	if (err)
+		return err;
+
+	kernel_neon_begin();
+	ce_aes_cbc_cts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+			       ctx->key_dec, num_rounds(ctx), walk.nbytes,
+			       walk.iv);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -486,6 +624,22 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey			= ce_aes_setkey,
 	.encrypt		= cbc_encrypt,
 	.decrypt		= cbc_decrypt,
+}, {
+	.base.cra_name		= "__cts(cbc(aes))",
+	.base.cra_driver_name	= "__cts-cbc-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.walksize		= 2 * AES_BLOCK_SIZE,
+	.setkey			= ce_aes_setkey,
+	.encrypt		= cts_cbc_encrypt,
+	.decrypt		= cts_cbc_decrypt,
 }, {
 	.base.cra_name		= "__ctr(aes)",
 	.base.cra_driver_name	= "__ctr-aes-ce",
-- 
2.17.1

