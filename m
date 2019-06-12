Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585F8C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CEF2208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PEO+oml8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405620AbfFLMsv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:48:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53398 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409156AbfFLMsv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so6449787wmj.3
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BVjKB83CGDhuLXJgz703gQuRW2ORbNsUnSLW3NNqkVc=;
        b=PEO+oml8sbOBJnA2JgN8yi8oG/YrG3PgZZ8hW5sCEhx3zRADsH4VIEc+C2lfQ9ID4H
         eY9GZRlCgvsU0wxkPjtYKurKi14Rwj+DRDWE5oP+/0q36mRyX/k3sDFFnSiZE2Z2nS0N
         +Kud0bquyc5memcL6tJI5k53Dc0KTcwBECh4fbh95l/UH5bVDnHpvKUrUpnU4RnoFI4L
         7LQInRcFEOUc0RY3Rqu2aZd9JT/CfvDaI9GHC64ZuKEWbsGse3uAe12zj3oQt93Bvb9s
         09IQH3BbPVewj67JRu9AQsvb5o2yVlE10C7OWjfdt2XooE/6wBQgQGtBQvGua0WYTjl1
         d+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVjKB83CGDhuLXJgz703gQuRW2ORbNsUnSLW3NNqkVc=;
        b=i0b/SpltcuyEUX7gYwgtAG3xXL4X3z/NvlvgICYqbmKcZOgVeQ21WbIn7D3GXmdTMR
         +VNpJEUu+QgNAcZfdeHjFCaGpU74WvE3RjtTpPvwH+LkHdMxYIDmxpXMTeNDlfLq/XUi
         40F9JRbGAXMVQbztqNpUT41x/Grx1aC0vX/U/cX0gMOnNZTujoXZDHCHlLJHw3wMkHwI
         yQ0K62+sVDdEKKj04crdgQ8SbJZxQ7k3fpanxfoVYa8VfIrhL2+l/Dx1aGc0UnuHu28f
         Kw9OEncqPZGKmzFAN5jw0BKsHRgoT9bkjRTotL4B/aYU3p+9y8PXJIL5vpwooJ6ThDXz
         SXBg==
X-Gm-Message-State: APjAAAXMQGv0nbqzk2YMiS7XYGiAbow/uDqqklauqRpra+K44hbWgdWn
        ysehGqDCs5IaeX7ewpxd/rUDT4Q+62+Ayg==
X-Google-Smtp-Source: APXvYqwPrt1EyvzxlUQYiFV1xBy+Vu/TkM1O+aI1kjXzvBXiBbnL/Ff/KxkVtzu1sQXvTIm5Sa3LlQ==
X-Received: by 2002:a1c:f102:: with SMTP id p2mr20392795wmh.60.1560343728001;
        Wed, 12 Jun 2019 05:48:48 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 01/20] crypto: arm/aes-ce - cosmetic/whitespace cleanup
Date:   Wed, 12 Jun 2019 14:48:19 +0200
Message-Id: <20190612124838.2492-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rearrange the aes_algs[] array for legibility.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c | 116 ++++++++++----------
 1 file changed, 56 insertions(+), 60 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 5affb8482379..04ba66903674 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -337,69 +337,65 @@ static int xts_decrypt(struct skcipher_request *req)
 }
 
 static struct skcipher_alg aes_algs[] = { {
-	.base = {
-		.cra_name		= "__ecb(aes)",
-		.cra_driver_name	= "__ecb-aes-ce",
-		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize		= AES_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.min_keysize	= AES_MIN_KEY_SIZE,
-	.max_keysize	= AES_MAX_KEY_SIZE,
-	.setkey		= ce_aes_setkey,
-	.encrypt	= ecb_encrypt,
-	.decrypt	= ecb_decrypt,
+	.base.cra_name		= "__ecb(aes)",
+	.base.cra_driver_name	= "__ecb-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.setkey			= ce_aes_setkey,
+	.encrypt		= ecb_encrypt,
+	.decrypt		= ecb_decrypt,
 }, {
-	.base = {
-		.cra_name		= "__cbc(aes)",
-		.cra_driver_name	= "__cbc-aes-ce",
-		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize		= AES_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.min_keysize	= AES_MIN_KEY_SIZE,
-	.max_keysize	= AES_MAX_KEY_SIZE,
-	.ivsize		= AES_BLOCK_SIZE,
-	.setkey		= ce_aes_setkey,
-	.encrypt	= cbc_encrypt,
-	.decrypt	= cbc_decrypt,
+	.base.cra_name		= "__cbc(aes)",
+	.base.cra_driver_name	= "__cbc-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.setkey			= ce_aes_setkey,
+	.encrypt		= cbc_encrypt,
+	.decrypt		= cbc_decrypt,
 }, {
-	.base = {
-		.cra_name		= "__ctr(aes)",
-		.cra_driver_name	= "__ctr-aes-ce",
-		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize		= 1,
-		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.min_keysize	= AES_MIN_KEY_SIZE,
-	.max_keysize	= AES_MAX_KEY_SIZE,
-	.ivsize		= AES_BLOCK_SIZE,
-	.chunksize	= AES_BLOCK_SIZE,
-	.setkey		= ce_aes_setkey,
-	.encrypt	= ctr_encrypt,
-	.decrypt	= ctr_encrypt,
+	.base.cra_name		= "__ctr(aes)",
+	.base.cra_driver_name	= "__ctr-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.setkey			= ce_aes_setkey,
+	.encrypt		= ctr_encrypt,
+	.decrypt		= ctr_encrypt,
 }, {
-	.base = {
-		.cra_name		= "__xts(aes)",
-		.cra_driver_name	= "__xts-aes-ce",
-		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
-		.cra_blocksize		= AES_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct crypto_aes_xts_ctx),
-		.cra_module		= THIS_MODULE,
-	},
-	.min_keysize	= 2 * AES_MIN_KEY_SIZE,
-	.max_keysize	= 2 * AES_MAX_KEY_SIZE,
-	.ivsize		= AES_BLOCK_SIZE,
-	.setkey		= xts_set_key,
-	.encrypt	= xts_encrypt,
-	.decrypt	= xts_decrypt,
+	.base.cra_name		= "__xts(aes)",
+	.base.cra_driver_name	= "__xts-aes-ce",
+	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_ALG_INTERNAL,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_xts_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.min_keysize		= 2 * AES_MIN_KEY_SIZE,
+	.max_keysize		= 2 * AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.setkey			= xts_set_key,
+	.encrypt		= xts_encrypt,
+	.decrypt		= xts_decrypt,
 } };
 
 static struct simd_skcipher_alg *aes_simd_algs[ARRAY_SIZE(aes_algs)];
-- 
2.20.1

