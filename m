Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9B2C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 825D420684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tz4lZUGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439234AbfFLMtJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45980 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439227AbfFLMtJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so16738345wre.12
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1xxctaVyY+STLE0T/Ia3mG1xDByiyGRaSaAm3A+Hnfc=;
        b=tz4lZUGm9GNsN5QswSxBu7YXktply7N1ckplmsyGaNzKPqdMjhYQIq5MA5Za8gHjVv
         hbmHeCSyK9Dv1HCnMTpSoZuYGyLJcOccSyP8R9Wlt5gRPw7cEK4ArZ5pLJnKCI+QeEtT
         jn0ql/+fmwDUAt+1c2EgEFXX1XuxCczqDAGslmpsFUU2LCQZGEhBEjt6KKYQzuNZM+VI
         PZQNvwUOv0/D3yTH8JTNF3Oyl65MrIBMnLBLuMDcOYPabmhfCtaAvgK/9SzQCWq2D15L
         8yi/Hml1UiDmGFEws/lyBKVDlHJFjsQyUEc8MhCwy90KY9ki2vxhabPaIPfReMKal4nV
         C12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1xxctaVyY+STLE0T/Ia3mG1xDByiyGRaSaAm3A+Hnfc=;
        b=iImMA1ahyb/c6nZ6b3P8COk8rbhMib4CSondHip2M+1iPVctbH6g0k+ryPVkiF4aXL
         EaviRYaAQuo31kXGrlsiJC7c+tHAoOL4rsGr7IJ9Wtj9Z17XIZXP8vKJoOEsezUlKpt+
         yuTCNVxlsZYi3kt9xU/LWdEt0RFwX88DmOGFcPxJJhUOLBHk+bk++vYJbKiI1RbXLR9e
         ptAPVV8RUIVkAdBYLcZg6e8tlcBzAIN/RpI/3Cfxt0S0GtvNZhciv1plz5GV66RmOiBK
         8TqhMBt9ELQT7POnZWw1ZqCrIjin8H7WzffO8vMDweX/QOTCIcdngPfWwb+uKjDp5iIL
         /ToQ==
X-Gm-Message-State: APjAAAWkbL/U51IF/3X3Z4jMJa8FP3H1MnuYG9mSWbrNC/rADA5o0Y44
        vr8flDz937CO89fU2zblX8/vp2ejuUrB+A==
X-Google-Smtp-Source: APXvYqwRohvV78ZaYYR4vsm/h+DRxRjPQWQ7HUQFKascJ307uk4yoyMwiX8PUkwBDQO+q+L56ETbIA==
X-Received: by 2002:adf:9d81:: with SMTP id p1mr5078018wre.294.1560343746557;
        Wed, 12 Jun 2019 05:49:06 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.49.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:49:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 18/20] crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
Date:   Wed, 12 Jun 2019 14:48:36 +0200
Message-Id: <20190612124838.2492-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
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
 arch/arm/crypto/aes-ce-glue.c | 36 ++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 04ba66903674..cdcc4b09e7db 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,6 +10,7 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
@@ -292,6 +293,23 @@ static int ctr_encrypt(struct skcipher_request *req)
 	return err;
 }
 
+static int ctr_encrypt_sync(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (!crypto_simd_usable()) {
+		struct skcipher_walk walk;
+		int err;
+
+		err = skcipher_walk_virt(&walk, req, true);
+		if (err)
+			return err;
+		return skcipher_encrypt_aes_ctr(&walk, ctx);
+	}
+	return ctr_encrypt(req);
+}
+
 static int xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -381,6 +399,21 @@ static struct skcipher_alg aes_algs[] = { {
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
@@ -424,6 +457,9 @@ static int __init aes_init(void)
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

