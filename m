Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E63CC06511
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D20421850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XNauRQ8V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfGBTmj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:39 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37922 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTmj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:39 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so18181160ljg.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9R634f5tUJpvqy1jJF6+TjW/ZQOJkrwjqwK24wF4gE4=;
        b=XNauRQ8VO6r2djNte89iUcIO+FGn0a93v3jW5RP0j4XZji/tyXbEkoalx5RSJKGzCR
         1D4GgukKAfMxPJsaEnlvIhCS1MdbiNwtwQPWCQ/llgvgB6ltZmxNftph0BvIeV3T3QkD
         M3/YaEYkRTg3vvnjqYTY/xwPzZxQjftwfca7T8F8FNy5trVQpWOPL1aJah34GVzVu6Qv
         NVDTvj5L5iMarSbkd8PwZKA4mN2+8K20pv+RerxLGO6Xn/0/sgGY0s7s3FCOQIfoI/eF
         /o2Y8jUAlG2M6+jG1CDi5dc6jL8NOJEmqqwzlOkaKfiJYRckpUUxXRSIa9YE1Tp1FB4s
         LedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9R634f5tUJpvqy1jJF6+TjW/ZQOJkrwjqwK24wF4gE4=;
        b=JC07bGJll8+xcLuOdHDhFaMuOY4NJoT9R/jOFVek1qfpqyWNC4X97nVgYin5HZG6mf
         hb6ZZTLCFi8+V9caEkmxAGHbt5AqfANVqE5G+xlEs1nmSgcwVEOGbKrMyDTI/r4cZWd7
         p9kUBrCtRHqFa9MqfjDGw86eE08+dEUxjY/9WFJA+C3hMHH+EWx0/c2d56Aucbq2jIHy
         Zj6rlynqAHweCfXSdmSAiXIqbxhnltT1pZ4f5qUV7y+U5wWtLpdSY3djAXnxQp0tU3Rh
         JWqFDnLuf+kSahYW/8KxtRMJ/AxlYIJzxwsUX93MpuRgAS31gR99DIY4yUyKCcLlvzgK
         8xOA==
X-Gm-Message-State: APjAAAV2pfpzJUpLEZ6lag1Sje0TINyyEC7VkqvyLuvzvBVEcA186gGa
        SHvoacaZdymnyp52pjOmDgJ532TYjcN7Jfss
X-Google-Smtp-Source: APXvYqw2qcB83U8SqXNXyE1nWz0+ZrEIOYGhCXhz+sxSBm6wNS3BrRQfDxQCEM8wGYg/ucc0o8whyA==
X-Received: by 2002:a2e:a0cf:: with SMTP id f15mr18583670ljm.180.1562096557122;
        Tue, 02 Jul 2019 12:42:37 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:36 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 20/32] crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
Date:   Tue,  2 Jul 2019 21:41:38 +0200
Message-Id: <20190702194150.10405-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AES in CTR mode is used by modes such as GCM and CCM, which are often
used in contexts where only synchronous ciphers are permitted. So
provide a synchronous version of ctr(aes) based on the existing code.
This requires a non-SIMD fallback to deal with invocations occurring
from a context where SIMD instructions may not be used. We have a
helper for this now in the AES library, so wire that up.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c | 43 ++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index e6da3e30018b..1d93da29d03a 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,8 +10,10 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <asm/unaligned.h>
 #include <crypto/aes.h>
+#include <crypto/ctr.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/cpufeature.h>
@@ -289,6 +291,29 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static void ctr_encrypt_one(struct crypto_skcipher *tfm, const u8 *src, u8 *dst)
+{
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
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
+
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
+	if (!crypto_simd_usable())
+		return crypto_ctr_encrypt_walk(req, ctr_encrypt_one);
+
+	return ctr_encrypt(req);
+}
+
 static int xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -378,6 +403,21 @@ static struct skcipher_alg aes_algs[] = { {
 	.setkey			= ce_aes_setkey,
 	.encrypt		= ctr_encrypt,
 	.decrypt		= ctr_encrypt,
+}, {
+	.base.cra_name		= "ctr(aes)",
+	.base.cra_driver_name	= "ctr-aes-ce-sync",
+	.base.cra_priority	= 300 - 1,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.setkey			= ce_aes_setkey,
+	.encrypt		= ctr_encrypt_sync,
+	.decrypt		= ctr_encrypt_sync,
 }, {
 	.base.cra_name		= "__xts(aes)",
 	.base.cra_driver_name	= "__xts-aes-ce",
@@ -421,6 +461,9 @@ static int __init aes_init(void)
 		return err;
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
+		if (!(aes_algs[i].base.cra_flags & CRYPTO_ALG_INTERNAL))
+			continue;
+
 		algname = aes_algs[i].base.cra_name + 2;
 		drvname = aes_algs[i].base.cra_driver_name + 2;
 		basename = aes_algs[i].base.cra_driver_name;
-- 
2.17.1

