Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05FAC48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8AA320828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uH6LAflM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF0K2M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39914 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfF0K2L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so1918162wrt.6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oSCqTZSbnLGprwAW+e+bdrFNNEkfE8SXrdCsMDCAbr0=;
        b=uH6LAflM9kUATgqIET7X+ah0VppC4JxoWVyXuragBeImnlFhlhm1lyzlP3g0wNpIwI
         pqwWmC+csqfdw9N3Lmz7ADIgq+rsq9Q9t4WV2iyOEWwdDzmniJW7Qa2iNS5nWIOGVlmJ
         NNYRhl/4o48r/K51/GbDBSqzlls3KCXzOP/XYb8MQgQrl0MevxaWCYjYLQ6KoWLocoZV
         BKZVUZCIPCRTtbNbEAQ8+uFN872ozvESM2y75LmttTke93BSqajtZmDdpP3ZaccbR+Bf
         ZeswzqjquZXJaVRNKCX0PevVVgHXqaZUqvKNttyRa8fvkLG8OeIFE6Th8ThHMd1Lwf7b
         bdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oSCqTZSbnLGprwAW+e+bdrFNNEkfE8SXrdCsMDCAbr0=;
        b=Cp4qxCcupH2Q47fxzPvaYSOUY9cd3DKOYO1WAxNRPgcU+ucGvc+5xwaf+J/2ZaJCCM
         vWVZS/ZBiAOGKmNUQqQWt3zLyesBn8JPL54EL+Cave+OwIaAw6hlD8BtAuvbEZJSw3zJ
         lGn9xZLhc5ZBNkcfybCF50l7ka6wPKf4CGaKqcqF36y34GWWONwtCPueH7hJVGGWzm6V
         UUksOMcAc6yOoDf5oWM4vfK4WSN16kdzUsgwSK1a1m1qCMvb+H1rF3LBlH0Ndst6usWH
         p7UtstQx093KmuRAi11TvUXBX6VbWGvZKVIHp5wwmNOmP/sLCllf49G8Y+oSaaoj009N
         xsXA==
X-Gm-Message-State: APjAAAXpJ5WJE9/yXIXz4Q9mFnB4t1X3tfNXEyXIdM60eP+i/tR53aEY
        029I5FomraIfg8StK4lO0AOKe0K1iq0=
X-Google-Smtp-Source: APXvYqyre6UNVtPdqNjFeLYyGsSBFivJHf/5lhHANzZfj4UbHwoivb1tSepEKwSiIuHzKA7Xx3is/g==
X-Received: by 2002:a05:6000:11c2:: with SMTP id i2mr2724806wrx.199.1561631289230;
        Thu, 27 Jun 2019 03:28:09 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 17/32] crypto: aes - move sync ctr(aes) to AES library and generic helper
Date:   Thu, 27 Jun 2019 12:26:32 +0200
Message-Id: <20190627102647.2992-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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

