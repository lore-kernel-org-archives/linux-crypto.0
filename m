Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F80C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68A1320657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MbMFFh0L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfFVTfF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:35:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34690 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVTfD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:35:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so11349209wmd.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i5YAml7KVGLr/1+CAScarRaj3NSVjbEGTREd9Bd1Ltw=;
        b=MbMFFh0LVBuA2Ka3k502n9AtagHKkTgUoB+sYJXNU6ryLYM9VrunnEJz2HHY+Sng7D
         1hWgtcFtTSyeYji16HNVHN9hKNBLRs/iGdQdiTjh0xg1ycfiD3ndE5/Q0ko7EhBSoO5f
         efkGR/9VeB9g1RYM93GUR8DVnAjXR2DbZw06JxXj2epN7C6xlZHhXFa/lo1+1Q5pnvNT
         oIJDgMqZPBNsAxGGAGghocZRdGi376hUOy9ZrQFJxfXoPB0NZ8bvluP8Z6+fxgXtcBAt
         uidDQhxIPb7FyidBTE0hS8wrGWAl8BPOadwJFXsg7Kb9eYbbA30o8THue20ceXTSCQ/u
         wQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5YAml7KVGLr/1+CAScarRaj3NSVjbEGTREd9Bd1Ltw=;
        b=o4kgYbz43WaqSdtawcOvf6jv2NsRY/2t6AA71cyZRLTdDP+c6n31vrbZ+quIA1/OWz
         bVv5rji9hlnaX6hDQiUQO6WaVslglcGXmeVVmTLvjRuJCkwP+/J4Ji2KOE6HREBswVQ7
         KpW2hL57lG38Eor6U9Zh853taTwpeHBGL4A1T3IUZMTTlFdcpEfxBU5cC4h/5CZXTl/v
         tntRWVYHwD0vkdljoJ0vWMtcd/eUh/U3zJD2uKk2d7dE/9t1LQRUHaDGF67MU1Hw+Wce
         5C7JayxL02LSTD7RKQ4ttczsoHEutXKSvwFlKOfwCZ1R71mAbyGpnHYCj44y3WD+RgUN
         klOg==
X-Gm-Message-State: APjAAAUH3FxRzWxdvw2mA0O5KrN4Je9Qks4pI/n2KPfdy5tMUrMUMNgd
        mFQtFiOWYLcjtyOhdDINT2KRzMCx9NuEfPM+
X-Google-Smtp-Source: APXvYqxWeb1OLoXnaa/chafHAQgzTfdTo8y6pXCKjuwPl+VEZIiviU5un7AsgHthWALr8j7v63jz0Q==
X-Received: by 2002:a7b:cd9a:: with SMTP id y26mr9220661wmj.44.1561232101491;
        Sat, 22 Jun 2019 12:35:01 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.35.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:35:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 20/26] crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
Date:   Sat, 22 Jun 2019 21:34:21 +0200
Message-Id: <20190622193427.20336-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index e6da3e30018b..c3a78c5a5c35 100644
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
+	 * evicted when the CPU is interrupted to do something
+	 * else.
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
2.20.1

