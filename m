Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F98C3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 12:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3413B2064A
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 12:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OZ1eEZdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfHPMWG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 08:22:06 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39609 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfHPMWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 08:22:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id i63so3910179wmg.4
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 05:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=x4lH8/mnV7a7140NXuXkOhO353UszRJy1bQKp2NkW04=;
        b=OZ1eEZdzB1/TDCPOxAkaPQZ4wMItmKfDPY75J1VIGsBOKI3QJdCAic+oCTg3Ua74fN
         sd1DlMgztR9wsDe45FZvbgYcW8p0FAqvXcp4MRkDPns+RMsaMcLnC8fdjdiBBmvofjWz
         rJbJX+xam/w9EUnT/JN1APd9bSTxTs42eda1gQ0RJv7c+94UR1iqorreXgIqxjQfTHbV
         gbaWkBOKexJoBceMMs6UIXefteJbyPgsFIwFSRM6mnmGPsejOLDZGv1oQtGQ7rtclXQ6
         e1uEu/GW8IgIdmPWSykwWVsDY5Ec9xt2B546AM9KNxUEZfvtsXXJtf06PasWdGHKxFDt
         07WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x4lH8/mnV7a7140NXuXkOhO353UszRJy1bQKp2NkW04=;
        b=njT8WrVeLAwlPFmXyQIFZVvChIUDeWw3X9ACG6RerJUpw4ZyefKT4uJvt2z9qpAWRn
         PuBFZDBtXa9twJv/RMM+/2BMkaKH+2pswjj289q3yf/Ll5DrySHuUDSVFId97doFNvsy
         SkPwlaFDtWEe1WdireqxLVyxmmhwhDxLlDVneJ82M9sVWX14cE/7enZ8UlNiGIQoK0Ql
         Q637nnjLAdvKuebEHdEbjCU4t9qx2x55/jeS5pbTBZBVZWlOpLk8EVPEemid73osppdD
         0J6MUNZmr9/tn32QGqZ+m1keezfCWZxbOmo0RsOWdGF50H0/w68oA+7rzxhioS88VFwU
         Gh0g==
X-Gm-Message-State: APjAAAVLsWpSvhf/vcK/wizd+V6Tx7Fv5eToX+zfqD+QSiHr0zI8l39K
        H1evJVaL2/23VWHcfXFoV7iK078mL/XWIaF1
X-Google-Smtp-Source: APXvYqx2xT6Nmr7FvDOqTxXjQbhJnvSDWBIUwxt0ZwRL16M0EQvzz69DlKLjHAb+oB7NiIeP4LlYLw==
X-Received: by 2002:a7b:c632:: with SMTP id p18mr7411024wmk.114.1565958122926;
        Fri, 16 Aug 2019 05:22:02 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id w13sm11681540wre.44.2019.08.16.05.21.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 05:22:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        smueller@chronox.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2] crypto: x86/xts - implement support for ciphertext stealing
Date:   Fri, 16 Aug 2019 15:21:50 +0300
Message-Id: <20190816122150.22170-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Align the x86 code with the generic XTS template, which now supports
ciphertext stealing as described by the IEEE XTS-AES spec P1619.

Tested-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v2: - move 'decrypt' flag from glue ctx struct to function prototype
    - remove redundant goto
    - make 'final_tweak' a pointer
    - fix typo in subject

 arch/x86/crypto/aesni-intel_glue.c         |  6 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  4 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  4 +-
 arch/x86/crypto/cast6_avx_glue.c           |  4 +-
 arch/x86/crypto/glue_helper.c              | 67 +++++++++++++++++++-
 arch/x86/crypto/serpent_avx2_glue.c        |  4 +-
 arch/x86/crypto/serpent_avx_glue.c         |  4 +-
 arch/x86/crypto/twofish_avx_glue.c         |  4 +-
 arch/x86/include/asm/crypto/glue_helper.h  |  2 +-
 9 files changed, 81 insertions(+), 18 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ef165d8cf443..bf12bb71cecc 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -609,7 +609,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	return glue_xts_req_128bit(&aesni_enc_xts, req,
 				   XTS_TWEAK_CAST(aesni_xts_tweak),
 				   aes_ctx(ctx->raw_tweak_ctx),
-				   aes_ctx(ctx->raw_crypt_ctx));
+				   aes_ctx(ctx->raw_crypt_ctx),
+				   false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -620,7 +621,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	return glue_xts_req_128bit(&aesni_dec_xts, req,
 				   XTS_TWEAK_CAST(aesni_xts_tweak),
 				   aes_ctx(ctx->raw_tweak_ctx),
-				   aes_ctx(ctx->raw_crypt_ctx));
+				   aes_ctx(ctx->raw_crypt_ctx),
+				   true);
 }
 
 static int
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index abf298c272dc..a4f00128ea55 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -182,7 +182,7 @@ static int xts_encrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&camellia_enc_xts, req,
 				   XTS_TWEAK_CAST(camellia_enc_blk),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -192,7 +192,7 @@ static int xts_decrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&camellia_dec_xts, req,
 				   XTS_TWEAK_CAST(camellia_enc_blk),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg camellia_algs[] = {
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 0c22d84750a3..f28d282779b8 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -208,7 +208,7 @@ static int xts_encrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&camellia_enc_xts, req,
 				   XTS_TWEAK_CAST(camellia_enc_blk),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -218,7 +218,7 @@ static int xts_decrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&camellia_dec_xts, req,
 				   XTS_TWEAK_CAST(camellia_enc_blk),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg camellia_algs[] = {
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 645f8f16815c..a8a38fffb4a9 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -201,7 +201,7 @@ static int xts_encrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&cast6_enc_xts, req,
 				   XTS_TWEAK_CAST(__cast6_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -211,7 +211,7 @@ static int xts_decrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&cast6_dec_xts, req,
 				   XTS_TWEAK_CAST(__cast6_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg cast6_algs[] = {
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 901551445387..d15b99397480 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -14,6 +14,7 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <asm/crypto/glue_helper.h>
 
@@ -259,17 +260,36 @@ static unsigned int __glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 			struct skcipher_request *req,
 			common_glue_func_t tweak_fn, void *tweak_ctx,
-			void *crypt_ctx)
+			void *crypt_ctx, bool decrypt)
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
@@ -287,6 +307,47 @@ int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 		nbytes = walk.nbytes;
 	}
 
+	if (unlikely(cts)) {
+		u8 *next_tweak, *final_tweak = req->iv;
+		struct scatterlist *src, *dst;
+		struct scatterlist s[2], d[2];
+		le128 b[2];
+
+		dst = src = scatterwalk_ffwd(s, req->src, req->cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(d, req->dst, req->cryptlen);
+
+		if (decrypt) {
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
+					   final_tweak);
+
+		err = skcipher_walk_virt(&walk, req, false) ?:
+		      skcipher_walk_done(&walk,
+				__glue_xts_req_128bit(gctx, crypt_ctx, &walk));
+	}
+
+out:
 	glue_fpu_end(fpu_enabled);
 
 	return err;
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index b871728e0b2f..13fd8d3d2da0 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -167,7 +167,7 @@ static int xts_encrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
 				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -177,7 +177,7 @@ static int xts_decrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
 				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 4a9a9f2ee1d8..7d3dca38a5a2 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -207,7 +207,7 @@ static int xts_encrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
 				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -217,7 +217,7 @@ static int xts_decrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
 				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 0dbf8e8b09d7..d561c821788b 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -210,7 +210,7 @@ static int xts_encrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&twofish_enc_xts, req,
 				   XTS_TWEAK_CAST(twofish_enc_blk),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -220,7 +220,7 @@ static int xts_decrypt(struct skcipher_request *req)
 
 	return glue_xts_req_128bit(&twofish_dec_xts, req,
 				   XTS_TWEAK_CAST(twofish_enc_blk),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx);
+				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg twofish_algs[] = {
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index d1818634ae7e..8d4a8e1226ee 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -114,7 +114,7 @@ extern int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 			       struct skcipher_request *req,
 			       common_glue_func_t tweak_fn, void *tweak_ctx,
-			       void *crypt_ctx);
+			       void *crypt_ctx, bool decrypt);
 
 extern void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src,
 				      le128 *iv, common_glue_func_t fn);
-- 
2.17.1

