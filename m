Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD721C48BE8
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8082720657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XLvYdmzx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFVTfC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:35:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42724 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVTfB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:35:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so9693741wrl.9
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oSCqTZSbnLGprwAW+e+bdrFNNEkfE8SXrdCsMDCAbr0=;
        b=XLvYdmzxeQ2M1tGuF+68xj4dQmIlodjFDHEdTN8LhTKOP5H7ZcCelcfoTo1bLG2HXg
         VGmzxKuinpIWzKFX0MBT/RZgkFdwvbXOgS/GMqGtpSos/+P7M9XFahSXvnyJ4nUqR014
         E3jSxIxcAet0H9D9UcYPBsnZ31gxgh5ZfF5n8RSgkKL0M0yvAvjePHhc2YHqM/ygqCGb
         NLYMjJGwKL5lxv6sFK8k09CSpeOhEOo1NtZW31ajLjQDqhXFocepnOM1UnIIPd70LI4y
         UyV1V4bHSz54M4D0anatWFm5BuRG++FhrCb7LZShlMYV983FhFzug5RqR9lhC4lzEjvM
         OBUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oSCqTZSbnLGprwAW+e+bdrFNNEkfE8SXrdCsMDCAbr0=;
        b=RchRO7Gj766YjnLrDABNs4meOTlf9s2QpMx4EMVC2W+KzXLb9bS5/a98vzmViIkb09
         VL/G28f4mwjSm4aeVaGUuOb1hpOc/h1JVpl8QQ+X/MbQEEBdG+ym8dNLS3uiKeh2tPoh
         iBG/hSq+1+I1WbpGPapuUAe8v2sCf3HzYC4ZuinXLVIabU7FxzEMEadQoAJtQ4TuZezD
         1MTNxKUDOYVeBEiYQka5WNZqca7xOLJ0l8wTljzUtcWi6agDdbrCrtBTDsPrqs6R08ZY
         nb4m+OZ9oY6lvHluYk3b820VenP+lceWSqYJA2oNjRLRA00finHsZ9EoBqbInGNHWgrE
         AAIQ==
X-Gm-Message-State: APjAAAUiH7sHc1YCvPjgSBn2RJpAigGS6kmZL+SzOXITkwoYvVmlYNfx
        DPGShFzfGhCyRXa3l3YwgISshNdHC65jmvhy
X-Google-Smtp-Source: APXvYqxoHD5wlZbo2i9VlxQjEJIpa+f5PWLWHhECX3wVi8knKWM6uRVEkeoQQhmOIMcSONCpZTuu7w==
X-Received: by 2002:a5d:4642:: with SMTP id j2mr3319100wrs.211.1561232098125;
        Sat, 22 Jun 2019 12:34:58 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:57 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 17/26] crypto: aes - move sync ctr(aes) to AES library and generic helper
Date:   Sat, 22 Jun 2019 21:34:18 +0200
Message-Id: <20190622193427.20336-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/aes-glue.c         | 22 ++++++--
 arch/arm64/crypto/aes-neonbs-glue.c  | 21 ++++++--
 3 files changed, 33 insertions(+), 63 deletions(-)

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
index 3c80345d914f..6dc90557282d 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -12,6 +12,7 @@
 #include <asm/hwcap.h>
 #include <asm/simd.h>
 #include <crypto/aes.h>
+#include <crypto/ctr.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
@@ -21,7 +22,6 @@
 #include <crypto/xts.h>
 
 #include "aes-ce-setkey.h"
-#include "aes-ctr-fallback.h"
 
 #ifdef USE_V8_CRYPTO_EXTENSIONS
 #define MODE			"ce"
@@ -404,13 +404,25 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
-static int ctr_encrypt_sync(struct skcipher_request *req)
+static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned long flags;
+
+	/*
+	 * Temporarily disable interrupts to avoid races where
+	 * evicted when the CPU is interrupted to do something
+	 * else.
+	 */
+	local_irq_save(flags);
+	aes_encrypt(ctx, dst, src);
+	local_irq_restore(flags);
+}
 
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
 	if (!crypto_simd_usable())
-		return aes_ctr_encrypt_fallback(ctx, req);
+		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
 
 	return ctr_encrypt(req);
 }
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index cb8d90f795a0..933ce70a2504 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -11,13 +11,12 @@
 #include <asm/neon.h>
 #include <asm/simd.h>
 #include <crypto/aes.h>
+#include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
 #include <linux/module.h>
 
-#include "aes-ctr-fallback.h"
-
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
@@ -283,13 +282,25 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	return aesbs_setkey(tfm, in_key, key_len);
 }
 
-static int ctr_encrypt_sync(struct skcipher_request *req)
+static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned long flags;
+
+	/*
+	 * Temporarily disable interrupts to avoid races where
+	 * evicted when the CPU is interrupted to do something
+	 * else.
+	 */
+	local_irq_save(flags);
+	aes_encrypt(&ctx->fallback, dst, src);
+	local_irq_restore(flags);
+}
 
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
 	if (!crypto_simd_usable())
-		return aes_ctr_encrypt_fallback(&ctx->fallback, req);
+		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
 
 	return ctr_encrypt(req);
 }
-- 
2.20.1

