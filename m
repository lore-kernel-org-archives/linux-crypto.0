Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 076D6C06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D970621850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vFAIUsgB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGBTmO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:14 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40378 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBTmO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:14 -0400
Received: by mail-lj1-f193.google.com with SMTP id a21so18168051ljh.7
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=trJajH9cyH+LbZxrv+7nC1tNggLxsbw2lvOtUdKDNJM=;
        b=vFAIUsgB1TrvxsRf5eFLNylXY+O9MuJSETqU8ykntVQYNNIOSNEeWMYs1l8/h7HZXB
         11OOd4bGMOIKMd8pc74eJ4Thosg2H9P5QA85f+VPk+uZVy4/oMDy3vApeBm9dkhBN/bD
         6hP/IOyDQ/CNTF3nWLBXseR5fx81qCfSKeRimvcXtNtK3sZuTHJzJN1gmIMfla47APn2
         70yPZpEiFKk37t6e9jwUXGF5HxmIWNFRy7cqXXaBuFVhc1scMJlaR/8MkfR2EiHGMlSo
         Eb+K5AUT2QJTjINjqWcJr+qo/AbWk0BBdXg3SYn36zOSRJf41UxMxJ0fczXCRA1wk/xn
         yV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=trJajH9cyH+LbZxrv+7nC1tNggLxsbw2lvOtUdKDNJM=;
        b=AXqFN9DSbLhq3pEOJstyfAqGgo2D1UtvqoorQByRkmpZC09p1J6ySclweAj9EBu7Hj
         SU2s1z07u4SN/95vWaXf1e8mpIHmYEWATkgWN3x9pGrCKnzhJctQNuXlsR+BRXxSEPP0
         MCk1sQ3Jv3j0ypZpBbTgWS1U9JC+U8WzDqXuEQ8d6z3dKyjSqqw745XMMjjIA2yFtMtw
         fh9Ubm1GuDk91ZikvBlgBsYKY1cZkBM9oZqWFe7mgrj8gQDEeRsvTogQ6TvwoieaA1gf
         hUVlAgzN9U0HGKWvjKh3+i2/psboJZUev+xYLS0UApNHdu28bxFevTwPakYG2s9FuMMK
         rlPQ==
X-Gm-Message-State: APjAAAXrM/loIY/m/2noltGjUG7mz3YD4W/1RGbJVnupV5PSJ/APrAe2
        kw0Qu72DhcCIHIEBVJOpo3U0zGjzwerwAjGB
X-Google-Smtp-Source: APXvYqxPOjUYHzDeSJJ3z4209rfW5szJyLHfYBaNYP7HUzbkvZ5ZOD3O9H7sMV2Y4E71IxtkTSZ9hw==
X-Received: by 2002:a2e:8997:: with SMTP id c23mr18128703lji.158.1562096531542;
        Tue, 02 Jul 2019 12:42:11 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 01/32] crypto: arm/aes-ce - cosmetic/whitespace cleanup
Date:   Tue,  2 Jul 2019 21:41:19 +0200
Message-Id: <20190702194150.10405-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1

