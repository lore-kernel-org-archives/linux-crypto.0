Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE79C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECEB21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i7+sZ9Ig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfGBTmh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:37 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46350 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTmh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id v24so18173079ljg.13
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0MCWUw3vDUq5xLL2N3UUfYVxMc1CoRLbEbf+zv4bCoE=;
        b=i7+sZ9Igg4lFlDQipgk5rFK5Kut6D04gI5g4VSt8nyeAs9CnyeExlo369v4slcQel0
         3msnORzG9uRH+7JRWmobhA1wREy8DMgFzO80oCFY/7WezPLU7CXPUyquTmEbFrKsLj/d
         hB9uQXvY6qeoWa+RV0K3L+Sx/KHGeXuNqMdwQE2iGagm3C9fNtzIc6ujO6wOzGmj2VG9
         E0Lry3+EwvQE63pH1EcA4ExhBqGL7FZkCczZKpxBTYX0PManuADqNOJpk/xoI2xr+0o5
         z3TcEsUIUb2ZA+hvckFl1vZ6p5B56tX4Gu1FvenrIAUxag9tRRAntC5HsKjU5DtL+Mba
         VmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0MCWUw3vDUq5xLL2N3UUfYVxMc1CoRLbEbf+zv4bCoE=;
        b=gMYJioALH8CtQlRUMqeWJkKuBYO4Y4iO0hodSsvwrEUqcfFbvi6m1iVaiFJGA4S5+l
         KrFnjLvSrZajj3oNfc184HLU5SIwMbTDIEApmYzdLSX+6Mpk0E1VAxcAOapy3sdHkV+G
         QLdgNmBTqxM0k0UnEmDC9z+7c3/iiwcznF64wuZx42X7vyDWI7ntdF3QAo4bHjj4wyde
         7KGsbjlXOn8WSZNmw+YdAs2eA59DQKI4/zBYGbBiS1Agpz/R9C3Lqotpiyiwm1cxAKx2
         lMzp4E3ufS6wg809NVtcjhulOnlN3o0gyM4st6tdevvWTyoHzfAkWjOSS1uYh/iLdyv0
         Zr7Q==
X-Gm-Message-State: APjAAAUPggCkVv4l+WJVmFclV52sbdzXBXC0CJuRmqvBAC3UpT21Jghj
        xL0yFN//YoPRZo7NBfAgWxNqPLNxJAv4YCXC
X-Google-Smtp-Source: APXvYqyaw7jbBXt8so+3kEH/cayCSGtUNq10mPaQWrmGIvViT0Mu+Sx50xsniYUwuBudbccm58/Wdg==
X-Received: by 2002:a2e:3602:: with SMTP id d2mr18733543lja.112.1562096553145;
        Tue, 02 Jul 2019 12:42:33 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:32 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 17/32] crypto: aes - move sync ctr(aes) to AES library and generic helper
Date:   Tue,  2 Jul 2019 21:41:35 +0200
Message-Id: <20190702194150.10405-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
index 3c80345d914f..60303ea625e6 100644
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
+	 * cachelines are evicted when the CPU is interrupted
+	 * to do something else.
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
index cb8d90f795a0..73c17ccb347d 100644
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
+	 * cachelines are evicted when the CPU is interrupted
+	 * to do something else.
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
2.17.1

