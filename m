Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EEBC3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11BA62339F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JCts070z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfHUOdW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55987 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbfHUOdW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so2365119wmf.5
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=inENxCG3FHp1A7FxE00V5o6CRhf+tePDkDNu7R3bkwg=;
        b=JCts070zoVcAudvUMZh6M+fun9PKjMe9ETdFJWpoUTq6tF4DseUW86ZWryLTErFtGs
         nx2qJa85uGK4emAP6Oxq0hA67Vmg8cZAoKYlN6V7dVGIIGgEjsmSYMJa2tvFVZUS4kXo
         Hoh8bL0HnxgrjDvnZPgWNRZVzrphoh8yzHg/AE2g2orLeUmP/5JB6u4VrKrM8t8aXolZ
         BQaYDZXmp3HgwOmh05uFB+K9NyfsrXAYNq5wnOp/fUIP7zvacgvmRIHjVrTgVhTSxrFL
         yDBZjwaVm9YiiyT8pnKPNt1fIANx3OAeeSNW6Ye+VS3jq1kv/vy6sBvoRqE12GrrczTO
         y0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=inENxCG3FHp1A7FxE00V5o6CRhf+tePDkDNu7R3bkwg=;
        b=GHf9PqLz5MkbJVgI8xdT9/XjnKp4EHVZFneG1c/4Zj3P4e9UsG2tzqLvxy5vjHH7kC
         GrDMwxCPqn1Y9hdFw3OG02TVvwefKDHq377s5ObxZQQAP5i+QgBSrw6lxN+WmR/1nI+3
         xTRFJiSp2EnYRe0hhv013DUDWtqssz+dkQJdLoGG05T9l/2OKG1oMfGDQxefEfVh0q0B
         rx0/bbS4AqLFyjBHOH4m0fkyICrBlscy71tomJA7ZpRmCC6ldgrbrjA6YTr3HIy0emAb
         4lNoMyhjemqfX0FkvUAzV8A7qQVzlEfMmYhjjuzzSiRUAwDNghiKD5kRHTiKm1wtpyiy
         k0GQ==
X-Gm-Message-State: APjAAAWXm6vMR3dbdPSjP46bdde9XNFCowKa7v2LkERYpsshLYKfMW8/
        3Mp00B9wWaY2PYljDg/MLrBLR2LgNRTAGg==
X-Google-Smtp-Source: APXvYqzQP+wJjL8AeAddbRGguWVgtvn2ojJuIWtYVHKcGUnLoD7XBstw6pRWhvhJ72tJNr5hyGZLOg==
X-Received: by 2002:a1c:c706:: with SMTP id x6mr405732wmf.104.1566397999771;
        Wed, 21 Aug 2019 07:33:19 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:19 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 12/17] crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS
Date:   Wed, 21 Aug 2019 17:32:48 +0300
Message-Id: <20190821143253.30209-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the AES-XTS implementation based on NEON instructions so that it
can deal with inputs whose size is not a multiple of the cipher block
size. This is part of the original XTS specification, but was never
implemented before in the Linux kernel.

Since the bit slicing driver is only faster if it can operate on at
least 7 blocks of input at the same time, let's reuse the alternate
path we are adding for CTS to process any data tail whose size is
not a multiple of 128 bytes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ce.S          |   3 +
 arch/arm64/crypto/aes-glue.c        |   2 +
 arch/arm64/crypto/aes-modes.S       |   3 +
 arch/arm64/crypto/aes-neon.S        |   5 +
 arch/arm64/crypto/aes-neonbs-glue.c | 111 +++++++++++++++++---
 5 files changed, 110 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 00bd2885feaa..c132c49c89a8 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -21,6 +21,9 @@
 	.macro		xts_reload_mask, tmp
 	.endm
 
+	.macro		xts_cts_skip_tw, reg, lbl
+	.endm
+
 	/* preload all round keys */
 	.macro		load_round_keys, rounds, rk
 	cmp		\rounds, #12
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index eecb74fd2f61..327ac8d1489e 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -1073,5 +1073,7 @@ module_cpu_feature_match(AES, aes_init);
 module_init(aes_init);
 EXPORT_SYMBOL(neon_aes_ecb_encrypt);
 EXPORT_SYMBOL(neon_aes_cbc_encrypt);
+EXPORT_SYMBOL(neon_aes_xts_encrypt);
+EXPORT_SYMBOL(neon_aes_xts_decrypt);
 #endif
 module_exit(aes_exit);
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index f2c2ba739f36..131618389f1f 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -442,6 +442,7 @@ AES_ENTRY(aes_xts_encrypt)
 	cbz		w7, .Lxtsencnotfirst
 
 	enc_prepare	w3, x5, x8
+	xts_cts_skip_tw	w7, .LxtsencNx
 	encrypt_block	v4, w3, x5, x8, w7		/* first tweak */
 	enc_switch_key	w3, x2, x8
 	b		.LxtsencNx
@@ -530,10 +531,12 @@ AES_ENTRY(aes_xts_decrypt)
 
 	ld1		{v4.16b}, [x6]
 	xts_load_mask	v8
+	xts_cts_skip_tw	w7, .Lxtsdecskiptw
 	cbz		w7, .Lxtsdecnotfirst
 
 	enc_prepare	w3, x5, x8
 	encrypt_block	v4, w3, x5, x8, w7		/* first tweak */
+.Lxtsdecskiptw:
 	dec_prepare	w3, x2, x8
 	b		.LxtsdecNx
 
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index 0cac5df6c901..22d9b110cf78 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -19,6 +19,11 @@
 	xts_load_mask	\tmp
 	.endm
 
+	/* special case for the neon-bs driver calling into this one for CTS */
+	.macro		xts_cts_skip_tw, reg, lbl
+	tbnz		\reg, #1, \lbl
+	.endm
+
 	/* multiply by polynomial 'x' in GF(2^8) */
 	.macro		mul_by_x, out, in, temp, const
 	sshr		\temp, \in, #7
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index bafd2ebef8f1..ea873b8904c4 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -11,6 +11,7 @@
 #include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <linux/module.h>
 
@@ -45,6 +46,12 @@ asmlinkage void neon_aes_ecb_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				     int rounds, int blocks);
 asmlinkage void neon_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				     int rounds, int blocks, u8 iv[]);
+asmlinkage void neon_aes_xts_encrypt(u8 out[], u8 const in[],
+				     u32 const rk1[], int rounds, int bytes,
+				     u32 const rk2[], u8 iv[], int first);
+asmlinkage void neon_aes_xts_decrypt(u8 out[], u8 const in[],
+				     u32 const rk1[], int rounds, int bytes,
+				     u32 const rk2[], u8 iv[], int first);
 
 struct aesbs_ctx {
 	u8	rk[13 * (8 * AES_BLOCK_SIZE) + 32];
@@ -64,6 +71,7 @@ struct aesbs_ctr_ctx {
 struct aesbs_xts_ctx {
 	struct aesbs_ctx	key;
 	u32			twkey[AES_MAX_KEYLENGTH_U32];
+	struct crypto_aes_ctx	cts;
 };
 
 static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
@@ -270,6 +278,10 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		return err;
 
 	key_len /= 2;
+	err = aes_expandkey(&ctx->cts, in_key, key_len);
+	if (err)
+		return err;
+
 	err = aes_expandkey(&rk, in_key + key_len, key_len);
 	if (err)
 		return err;
@@ -302,48 +314,119 @@ static int ctr_encrypt_sync(struct skcipher_request *req)
 	return ctr_encrypt(req);
 }
 
-static int __xts_crypt(struct skcipher_request *req,
+static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 		       void (*fn)(u8 out[], u8 const in[], u8 const rk[],
 				  int rounds, int blocks, u8 iv[]))
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int tail = req->cryptlen % (8 * AES_BLOCK_SIZE);
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct scatterlist *src, *dst;
 	struct skcipher_walk walk;
-	int err;
+	int nbytes, err;
+	int first = 1;
+	u8 *out, *in;
+
+	if (req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	/* ensure that the cts tail is covered by a single step */
+	if (unlikely(tail > 0 && tail < AES_BLOCK_SIZE)) {
+		int xts_blocks = DIV_ROUND_UP(req->cryptlen,
+					      AES_BLOCK_SIZE) - 2;
+
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(&subreq,
+					      skcipher_request_flags(req),
+					      NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   xts_blocks * AES_BLOCK_SIZE,
+					   req->iv);
+		req = &subreq;
+	} else {
+		tail = 0;
+	}
 
 	err = skcipher_walk_virt(&walk, req, false);
 	if (err)
 		return err;
 
-	kernel_neon_begin();
-	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey, ctx->key.rounds, 1);
-	kernel_neon_end();
-
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
-		if (walk.nbytes < walk.total)
+		if (walk.nbytes < walk.total || walk.nbytes % AES_BLOCK_SIZE)
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
 
+		out = walk.dst.virt.addr;
+		in = walk.src.virt.addr;
+		nbytes = walk.nbytes;
+
 		kernel_neon_begin();
-		fn(walk.dst.virt.addr, walk.src.virt.addr, ctx->key.rk,
-		   ctx->key.rounds, blocks, walk.iv);
+		if (likely(blocks > 6)) { /* plain NEON is faster otherwise */
+			if (first)
+				neon_aes_ecb_encrypt(walk.iv, walk.iv,
+						     ctx->twkey,
+						     ctx->key.rounds, 1);
+			first = 0;
+
+			fn(out, in, ctx->key.rk, ctx->key.rounds, blocks,
+			   walk.iv);
+
+			out += blocks * AES_BLOCK_SIZE;
+			in += blocks * AES_BLOCK_SIZE;
+			nbytes -= blocks * AES_BLOCK_SIZE;
+		}
+
+		if (walk.nbytes == walk.total && nbytes > 0)
+			goto xts_tail;
+
 		kernel_neon_end();
-		err = skcipher_walk_done(&walk,
-					 walk.nbytes - blocks * AES_BLOCK_SIZE);
+		skcipher_walk_done(&walk, nbytes);
 	}
-	return err;
+
+	if (err || likely(!tail))
+		return err;
+
+	/* handle ciphertext stealing */
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
+	out = walk.dst.virt.addr;
+	in = walk.src.virt.addr;
+	nbytes = walk.nbytes;
+
+	kernel_neon_begin();
+xts_tail:
+	if (encrypt)
+		neon_aes_xts_encrypt(out, in, ctx->cts.key_enc, ctx->key.rounds,
+				     nbytes, ctx->twkey, walk.iv, first ?: 2);
+	else
+		neon_aes_xts_decrypt(out, in, ctx->cts.key_dec, ctx->key.rounds,
+				     nbytes, ctx->twkey, walk.iv, first ?: 2);
+	kernel_neon_end();
+
+	return skcipher_walk_done(&walk, 0);
 }
 
 static int xts_encrypt(struct skcipher_request *req)
 {
-	return __xts_crypt(req, aesbs_xts_encrypt);
+	return __xts_crypt(req, true, aesbs_xts_encrypt);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
 {
-	return __xts_crypt(req, aesbs_xts_decrypt);
+	return __xts_crypt(req, false, aesbs_xts_decrypt);
 }
 
 static struct skcipher_alg aes_algs[] = { {
-- 
2.17.1

