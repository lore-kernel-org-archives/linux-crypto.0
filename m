Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42BCC31E48
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF0C9208C2
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ox4tpd6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439227AbfFLMtK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55485 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439231AbfFLMtJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so6430130wmj.5
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FRmUfZcZrs5gwbshqgmWeJhm624aavbe4mR2Os9kVds=;
        b=ox4tpd6P6ar74xvJmGEDOZ3bY7LZM6d2Wf22j9f17GQSx52dugdszFmC8DA6E1ppeL
         gQnDg3vb90lRTgUxt1dIpIvaeVp20WKtg6C3KQN1Cc9axY+s8kCQ7GmeSnFRBb18zhL+
         0eys7sjuzou33znvRYpG8SuL8thxqv892ZnATw5UmNEQGnyr4scvk70CUlR1dsvxb0af
         yx8EjN45Zers8YamyBGPXvV8l9dwGjOhwYRmzUpJf73gu6nNQ9vGG9pq+of/yNJtXFhO
         HUv+iSin+Pgv/FHfJE/7Wj5g1bnNppQEizdaJirgMbCCPAZXCaGxXXILj/kzeSzd/Hw3
         wJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FRmUfZcZrs5gwbshqgmWeJhm624aavbe4mR2Os9kVds=;
        b=IpsS6RmvJk0Si7VnY8aoNTMXkqEbAIncKXpvNlNXlQJ/8kgAWPdiwXZFK7/EKAbwXV
         mxjqWZQ+ct+pelkUl+WLqnPJXhswk7Q+oszNuNOtkrDpxHnDEIFYqMI8usZ4bKzvXW7q
         mPzeAqn7M71IvzacVkT5JAFeAgu0NbeqAteX8PnhmvZ2B1WeKetc0JKWzgkRE7DPY0d3
         3NNR3sx+NA9AGXUEOZuTCO0BifjKDDM51ukZnc4EKpICBpZRnIRbIgQBzeMpPRNmO4lK
         YrU8UwLHSPZxZV91a2COy63NlH9LrkKQDH9QyOZQnokIZBoht7dbOste31q5vfdrGIB6
         WIRw==
X-Gm-Message-State: APjAAAWmwONs2Cu5COb3pytgAFrBs1EW+6xK1M22/WYsZW9ljBCPGe2l
        5M9CsjyYgNF04C26HGH4h/3DOJAYDKnikA==
X-Google-Smtp-Source: APXvYqxd41RPyGlCq2WkdPX/ISV2qfcqiTJ1HY+ag6kqkFOkGEU0EfSPQmXHChF8S0G1+UUDVZka5Q==
X-Received: by 2002:a7b:c74a:: with SMTP id w10mr20999150wmk.99.1560343745519;
        Wed, 12 Jun 2019 05:49:05 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.49.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:49:04 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 17/20] crypto: aes - move ctr(aes) non-SIMD fallback to AES library
Date:   Wed, 12 Jun 2019 14:48:35 +0200
Message-Id: <20190612124838.2492-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In preparation of duplicating the sync ctr(aes) functionality to modules
under arch/arm, move the helper function from a inline .h file to the
AES library, which is already depended upon by the drivers that use this
fallback.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-ctr-fallback.h | 53 --------------------
 arch/arm64/crypto/aes-glue.c         | 17 ++++---
 arch/arm64/crypto/aes-neonbs-glue.c  | 12 +++--
 crypto/Kconfig                       |  1 +
 include/crypto/aes.h                 | 11 ++++
 lib/crypto/aes.c                     | 41 +++++++++++++++
 6 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/arch/arm64/crypto/aes-ctr-fallback.h b/arch/arm64/crypto/aes-ctr-fallback.h
deleted file mode 100644
index c9285717b6b5..000000000000
--- a/arch/arm64/crypto/aes-ctr-fallback.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- * Fallback for sync aes(ctr) in contexts where kernel mode NEON
- * is not allowed
- *
- * Copyright (C) 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <crypto/aes.h>
-#include <crypto/internal/skcipher.h>
-
-asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
-
-static inline int aes_ctr_encrypt_fallback(struct crypto_aes_ctx *ctx,
-					   struct skcipher_request *req)
-{
-	struct skcipher_walk walk;
-	u8 buf[AES_BLOCK_SIZE];
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, true);
-
-	while (walk.nbytes > 0) {
-		u8 *dst = walk.dst.virt.addr;
-		u8 *src = walk.src.virt.addr;
-		int nbytes = walk.nbytes;
-		int tail = 0;
-
-		if (nbytes < walk.total) {
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-			tail = walk.nbytes % AES_BLOCK_SIZE;
-		}
-
-		do {
-			int bsize = min(nbytes, AES_BLOCK_SIZE);
-
-			__aes_arm64_encrypt(ctx->key_enc, buf, walk.iv,
-					    6 + ctx->key_length / 4);
-			crypto_xor_cpy(dst, src, buf, bsize);
-			crypto_inc(walk.iv, AES_BLOCK_SIZE);
-
-			dst += AES_BLOCK_SIZE;
-			src += AES_BLOCK_SIZE;
-			nbytes -= AES_BLOCK_SIZE;
-		} while (nbytes > 0);
-
-		err = skcipher_walk_done(&walk, tail);
-	}
-	return err;
-}
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 8fa17a764802..3d9cedbb91c9 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -21,7 +21,6 @@
 #include <crypto/xts.h>
 
 #include "aes-ce-setkey.h"
-#include "aes-ctr-fallback.h"
 
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 #define MODE			"ce"
@@ -409,8 +408,15 @@ static int ctr_encrypt_sync(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (!crypto_simd_usable())
-		return aes_ctr_encrypt_fallback(ctx, req);
+	if (!crypto_simd_usable()) {
+		struct skcipher_walk walk;
+		int err;
+
+		err = skcipher_walk_virt(&walk, req, true);
+		if (err)
+			return err;
+		return skcipher_encrypt_aes_ctr(&walk, ctx);
+	}
 
 	return ctr_encrypt(req);
 }
@@ -653,15 +659,14 @@ static void mac_do_update(struct crypto_aes_ctx *ctx, u8 const in[], int blocks,
 		kernel_neon_end();
 	} else {
 		if (enc_before)
-			__aes_arm64_encrypt(ctx->key_enc, dg, dg, rounds);
+			aes_encrypt(ctx, dg, dg);
 
 		while (blocks--) {
 			crypto_xor(dg, in, AES_BLOCK_SIZE);
 			in += AES_BLOCK_SIZE;
 
 			if (blocks || enc_after)
-				__aes_arm64_encrypt(ctx->key_enc, dg, dg,
-						    rounds);
+				aes_encrypt(ctx, dg, dg);
 		}
 	}
 }
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index cb8d90f795a0..02d46e97c1e1 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -16,8 +16,6 @@
 #include <crypto/xts.h>
 #include <linux/module.h>
 
-#include "aes-ctr-fallback.h"
-
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
@@ -288,9 +286,15 @@ static int ctr_encrypt_sync(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (!crypto_simd_usable())
-		return aes_ctr_encrypt_fallback(&ctx->fallback, req);
+	if (!crypto_simd_usable()) {
+		struct skcipher_walk walk;
+		int err;
 
+		err = skcipher_walk_virt(&walk, req, true);
+		if (err)
+			return err;
+		return skcipher_encrypt_aes_ctr(&walk, &ctx->fallback);
+	}
 	return ctr_encrypt(req);
 }
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3b08230fe3ba..efeb307c0594 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1061,6 +1061,7 @@ comment "Ciphers"
 
 config CRYPTO_LIB_AES
 	tristate
+	select CRYPTO_ALGAPI
 
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 31ba40d803df..f67c38500746 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -8,6 +8,8 @@
 
 #include <linux/types.h>
 #include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 
 #define AES_MIN_KEY_SIZE	16
 #define AES_MAX_KEY_SIZE	32
@@ -69,4 +71,13 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
  */
 void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
 
+/**
+ * skcipher_encrypt_aes_ctr - Process a aes(ctr) skcipher encryption request
+ *                            using the generic AES implementation.
+ * @walk: the skcipher walk data structure that describes the data to operate on
+ * @ctx: the AES key schedule
+ */
+int skcipher_encrypt_aes_ctr(struct skcipher_walk *walk,
+			     const struct crypto_aes_ctx *ctx);
+
 #endif
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 57596148b010..f5ef29eaa714 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -363,6 +363,47 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
 }
 EXPORT_SYMBOL(aes_decrypt);
 
+/**
+ * skcipher_encrypt_aes_ctr - Process a aes(ctr) skcipher encryption request
+ *                            using the generic AES implementation.
+ * @walk: the skcipher walk data structure that describes the data to operate on
+ * @ctx: the AES key schedule
+ */
+int skcipher_encrypt_aes_ctr(struct skcipher_walk *walk,
+			     const struct crypto_aes_ctx *ctx)
+{
+	u8 buf[AES_BLOCK_SIZE];
+	int err = 0;
+
+	while (walk->nbytes > 0) {
+		u8 *dst = walk->dst.virt.addr;
+		u8 *src = walk->src.virt.addr;
+		int nbytes = walk->nbytes;
+		int tail = 0;
+
+		if (nbytes < walk->total) {
+			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
+			tail = walk->nbytes % AES_BLOCK_SIZE;
+		}
+
+		do {
+			int bsize = min(nbytes, AES_BLOCK_SIZE);
+
+			aes_encrypt(ctx, buf, walk->iv);
+			crypto_xor_cpy(dst, src, buf, bsize);
+			crypto_inc(walk->iv, AES_BLOCK_SIZE);
+
+			dst += AES_BLOCK_SIZE;
+			src += AES_BLOCK_SIZE;
+			nbytes -= AES_BLOCK_SIZE;
+		} while (nbytes > 0);
+
+		err = skcipher_walk_done(walk, tail);
+	}
+	return err;
+}
+EXPORT_SYMBOL(skcipher_encrypt_aes_ctr);
+
 MODULE_DESCRIPTION("Generic AES library");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
-- 
2.20.1

