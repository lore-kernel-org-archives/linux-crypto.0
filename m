Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499D9C48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D6320828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pFRNGVBV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfF0K1x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:27:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38051 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF0K1x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:27:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so5103705wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BVjKB83CGDhuLXJgz703gQuRW2ORbNsUnSLW3NNqkVc=;
        b=pFRNGVBV903LkrX6Ej7fElal8/dsVoWDCuZybsQAlqT1+nIllH9Vc7gEtNmwwCpctg
         scw9hyKtMmF21FYPvrznEo/dLZrf3kCTfjrK9QYizKP6jJ/Y7SWmWUcEncfWsyg+nlA7
         pzhRZacgY6+FMLHITkkEnhjOdpPdPcMlWQkhqgGIau2npN12wjlHLKtDSAonx1ytKPSk
         TZB/RBwHVML2sx5ulymyVcgK/UbXVZ4GJ7FbSnaG1B6PcV7CS2/EyvlKvMJgGnN9znlA
         fv5KnztOyXVaZPid25gPwoqNuI1u7/L4Fh5Id4BVtSZ7Y8tgv6jCUDr3y2+ZBNi+XOWS
         G4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVjKB83CGDhuLXJgz703gQuRW2ORbNsUnSLW3NNqkVc=;
        b=Mca/JI58KrRY9qDw/wDSvn8BsTsL9LKuuQbwo72TK8efIpwea4XL8uahNQ0nu8F+cF
         ipng6LY5chF4l6LXyr7GjhvLjW5HobiL/HYxPyAw3xPzAqVTPzXMpGA7C6Zhoie95nDG
         8GVyA9oj+B/zRu+tBs/VSLA46VJQk05yuV0PjSqUhnJyXKC54cnG5sXYcXomkFDsA8xP
         2JSF4f15JB835vbLIRxwIzH2bUFBHiEOakZEQyqMaE97k5I6VXUtJtIWY5trvRzwfwKM
         V3aTW0J50CF0dsFxNpomRMMw2s+HNmcX6CUiqHAimpbSDK2IIewE50JTBK2fcty8rsq1
         +Izg==
X-Gm-Message-State: APjAAAW1WZfFmkqN2pMQqY5CPjcX2Vt49QU7z0WGsV894Y2fQbNJVTxg
        V1ZxgGwVWSfJqgDizA5I7GO2jki9aFY=
X-Google-Smtp-Source: APXvYqxzulCx3y/YHAWui2/ALxYcltZ7YhezXmyp6l4LLGUJnLUb8tyuRRlmCE+gSqVOr19gKgWO4g==
X-Received: by 2002:a7b:cc16:: with SMTP id f22mr2553680wmh.115.1561631270702;
        Thu, 27 Jun 2019 03:27:50 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 01/32] crypto: arm/aes-ce - cosmetic/whitespace cleanup
Date:   Thu, 27 Jun 2019 12:26:16 +0200
Message-Id: <20190627102647.2992-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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

