Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C759C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 10:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 262B42133F
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 10:11:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kAJNDUvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfHPKK7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 06:10:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42369 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfHPKK7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 06:10:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so1009385wrq.9
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 03:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wevbYmSq0QTqpzL4EdYPtWSMgumyK/bEm6qSu4DG/z8=;
        b=kAJNDUvDuyqr3qQisSAmD+Zv/PHge1L1ECFcB22ev3wJO7OsmgELU/9KoWYnxv/H76
         p92kpQPOZLGsAmWRot3LxpBhKAjoSwbZGlBVu8Ucy0zPMTtQdcsXV/xUjO6oG355tmA6
         awVIyx4J/Noq6XUrWxcnOpnwE9rMnch4QLfVOyjWQS9c8ZarcWI3sG4bF386wu7PWKXK
         VBeFukUu8AWifM9bazkd3uGRp36hf8rETZc9GGTukB10i41sE2039htDk4LpbLApQqKu
         kdrQ6eVYUwHNGLQJx7duJyU0ap1BrzR9G0mE3pacRRT8myHHYhOcdPNzWslmjbHBdBf1
         V1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wevbYmSq0QTqpzL4EdYPtWSMgumyK/bEm6qSu4DG/z8=;
        b=Xyo57Ks2465YIkqgSFpwlhx2JmXmvI2W/EOIDu5OX0eW2ltQTJCERVHT3hMp22/vv9
         WxaBtmHOiRgOl2chwvrFp6vzP5+Ih2Bk4Xp1ToyZ7Wutao8Zn0KbEhLxqRaFd1g6i+QP
         1gLJP+xiJbB/HsWpGnGH8t1JlUB1mWU7cvJFA1oEHFOC+p2vvm5YNMfH4ymWkLaoUbTg
         iU5DiYUgTwXZJ1CyhvYJpJx6VgS3f4pYW+fGeaM19/homYJdsYD4Yl7rQWJwy19nZHfl
         xxuJgnNKEKLLaqvmKEN04rCQWXjb8qmxn636cQq8KD/nuHQbhCv3S/VG2ba77OfdBvPb
         cy5A==
X-Gm-Message-State: APjAAAVTBxrp3h/ORujbe6KCoZO5FfHyHIPOpCwY/OHp+8At7KA6P9Db
        Q4BqiW7zdF+FwTjsYH8rZcxb/sYUW38kkJVg
X-Google-Smtp-Source: APXvYqxzFeMxXUdQqxA5UMMnWvQVQrtU83ggcBHPnHo/Zm0k2YrHVWBJxRYxbQuphfRgTVFufwXGNw==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr9882238wrv.39.1565950255753;
        Fri, 16 Aug 2019 03:10:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id f6sm9343711wrh.30.2019.08.16.03.10.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 03:10:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        smueller@chronox.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH] crypto: aes/xts - implement support for ciphertext stealing
Date:   Fri, 16 Aug 2019 13:10:21 +0300
Message-Id: <20190816101021.7837-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Align the x86 code with the generic XTS template, which now supports
ciphertext stealing as described by the IEEE XTS-AES spec P1619.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/aesni-intel_glue.c         |  1 +
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  1 +
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  1 +
 arch/x86/crypto/cast6_avx_glue.c           |  1 +
 arch/x86/crypto/glue_helper.c              | 70 +++++++++++++++++++++-
 arch/x86/crypto/serpent_avx2_glue.c        |  1 +
 arch/x86/crypto/serpent_avx_glue.c         |  1 +
 arch/x86/crypto/twofish_avx_glue.c         |  1 +
 arch/x86/include/asm/crypto/glue_helper.h  |  1 +
 9 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ef165d8cf443..0ea1517faf09 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -591,6 +591,7 @@ static const struct common_glue_ctx aesni_enc_xts = {
 static const struct common_glue_ctx aesni_dec_xts = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = 1,
+	.xts_decrypt = 1,
 
 	.funcs = { {
 		.num_blocks = 8,
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index abf298c272dc..7854378e6d0c 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -129,6 +129,7 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 static const struct common_glue_ctx camellia_dec_xts = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
+	.xts_decrypt = 1,
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 0c22d84750a3..58e8f08819b6 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -136,6 +136,7 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 static const struct common_glue_ctx camellia_dec_xts = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
+	.xts_decrypt = 1,
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 645f8f16815c..dfdbdeff5a2b 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -132,6 +132,7 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 static const struct common_glue_ctx cast6_dec_xts = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
+	.xts_decrypt = 1,
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 901551445387..693541d00c0a 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -14,6 +14,7 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
 
@@ -261,15 +262,34 @@ int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 			common_glue_func_t tweak_fn, void *tweak_ctx,
 			void *crypt_ctx)
 {
+	const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
 	const unsigned int bsize = 128 / 8;
+	struct skcipher_request subreq;
 	struct skcipher_walk walk;
 	bool fpu_enabled = false;
-	unsigned int nbytes;
+	unsigned int nbytes, tail;
 	int err;
 
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (unlikely(cts)) {
+		struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+		tail = req->cryptlen % XTS_BLOCK_SIZE + XTS_BLOCK_SIZE;
+
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(&subreq,
+					      crypto_skcipher_get_flags(tfm),
+					      NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   req->cryptlen - tail, req->iv);
+		req = &subreq;
+	}
+
 	err = skcipher_walk_virt(&walk, req, false);
 	nbytes = walk.nbytes;
-	if (!nbytes)
+	if (err)
 		return err;
 
 	/* set minimum length to bsize, for tweak_fn */
@@ -287,6 +307,52 @@ int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 		nbytes = walk.nbytes;
 	}
 
+	if (unlikely(cts)) {
+		struct scatterlist *src, *dst;
+		struct scatterlist s[2], d[2];
+		le128 final_tweak;
+		u8 *next_tweak;
+		le128 b[2];
+
+		dst = src = scatterwalk_ffwd(s, req->src, req->cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(d, req->dst, req->cryptlen);
+
+		if (gctx->xts_decrypt) {
+			final_tweak = *(le128 *)req->iv;
+			next_tweak = memcpy(b, req->iv, XTS_BLOCK_SIZE);
+			gf128mul_x_ble(b, b);
+		} else {
+			next_tweak = req->iv;
+		}
+
+		skcipher_request_set_crypt(&subreq, src, dst, XTS_BLOCK_SIZE,
+					   next_tweak);
+
+		err = skcipher_walk_virt(&walk, req, false) ?:
+		      skcipher_walk_done(&walk,
+				__glue_xts_req_128bit(gctx, crypt_ctx, &walk));
+		if (err)
+			goto out;
+
+		scatterwalk_map_and_copy(b, dst, 0, XTS_BLOCK_SIZE, 0);
+		memcpy(b + 1, b, tail - XTS_BLOCK_SIZE);
+		scatterwalk_map_and_copy(b, src, XTS_BLOCK_SIZE,
+					 tail - XTS_BLOCK_SIZE, 0);
+		scatterwalk_map_and_copy(b, dst, 0, tail, 1);
+
+		skcipher_request_set_crypt(&subreq, dst, dst, XTS_BLOCK_SIZE,
+					   gctx->xts_decrypt ? (u8 *)&final_tweak
+							     : req->iv);
+
+		err = skcipher_walk_virt(&walk, req, false) ?:
+		      skcipher_walk_done(&walk,
+				__glue_xts_req_128bit(gctx, crypt_ctx, &walk));
+		if (err)
+			goto out;
+	}
+
+out:
 	glue_fpu_end(fpu_enabled);
 
 	return err;
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index b871728e0b2f..b7b82bf69a67 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -121,6 +121,7 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 static const struct common_glue_ctx serpent_dec_xts = {
 	.num_funcs = 3,
 	.fpu_blocks_limit = 8,
+	.xts_decrypt = 1,
 
 	.funcs = { {
 		.num_blocks = 16,
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 4a9a9f2ee1d8..c46d722ecc12 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -164,6 +164,7 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 static const struct common_glue_ctx serpent_dec_xts = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = SERPENT_PARALLEL_BLOCKS,
+	.xts_decrypt = 1,
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 0dbf8e8b09d7..220de42bc3ab 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -167,6 +167,7 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 static const struct common_glue_ctx twofish_dec_xts = {
 	.num_funcs = 2,
 	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
+	.xts_decrypt = 1,
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index d1818634ae7e..31e038759a54 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -36,6 +36,7 @@ struct common_glue_func_entry {
 struct common_glue_ctx {
 	unsigned int num_funcs;
 	int fpu_blocks_limit; /* -1 means fpu not needed at all */
+	int xts_decrypt; /* whether this implements XTS decryption */
 
 	/*
 	 * First funcs entry must have largest num_blocks and last funcs entry
-- 
2.17.1

