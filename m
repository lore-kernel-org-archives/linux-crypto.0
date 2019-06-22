Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5256C48BE8
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BBD520657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cHSgDKcu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfFVTen (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35941 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVTen (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so8516961wrs.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BVjKB83CGDhuLXJgz703gQuRW2ORbNsUnSLW3NNqkVc=;
        b=cHSgDKcuFMWYNb1pWS6aRdjp/rWrXTERCfIoFtcTtDIpaPxn7MWw9CCY4djWKBKq6n
         dl03jsNcdHz7noxOcNJZfh7LbIcbKyLj6wDzOD5YUAKRiRsvaAHmoM6R3xR5Gg+TNEO6
         aFVZTwQ6fkWYTbevLZXf8UaU481qRjwMm58zyitx4vvz3a+hlBo6l4MoxlWxhRf7abj3
         Yo5gQoP7l2ZEYv/i/2sP8re8hN+0sxJzI4FrhLEvm+1G+OJM05eI5rbIoS0qd81ynJxv
         sTAb+Dy5DDQebUXJoMzft2go4ItS7+ARQFL+HNM37FyUQjoJgzhN4/SxRgY1z9YM3yFE
         W6DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BVjKB83CGDhuLXJgz703gQuRW2ORbNsUnSLW3NNqkVc=;
        b=F9WMeDBcyVKSR5xTzhCiqFKEzNTm/LZV9KTLf8qrfrTmv/KZORhnGsjX4XEcG6cuw4
         LCRmI8PV6T3n1UBeeEk/7patY0D0LQ2o5CAza8tSUFZtQUuAIe991dgOit3oVRmyE2ZA
         g+uYQG9VQUDkf9PpUyJJCY/98wF37NPDPP9awcWwgv9Rqj04id12hxpPZaMfV3Moqt5K
         zerZOKEVz46csL3mXXhGNmcGbXMMuNLKPzDwMph6Ij/a4+UVvUEDcyWem3F3fWfOpOdb
         MyN0d3cFpC0+WFA2fGSyDww0mUM+VyxxgqD9WKV1jdnYYNUdcpeTCxmkYREdVN/uqUpR
         e1CQ==
X-Gm-Message-State: APjAAAWEnVAf9sZAGndpCmM0LeVrkR9VE4PU289Et3GM/x8S8kgu/e6L
        s+kix6A6EotO5+zudq4RxccJD0MOeY/RgHVr
X-Google-Smtp-Source: APXvYqwuzEFy2qvPY0qE0K8adGRudQP1cyAVVFmr411xkJuD2KxQCFpSOcVm4CkZQziVek0JHfvf1g==
X-Received: by 2002:a5d:5607:: with SMTP id l7mr15715149wrv.228.1561232080494;
        Sat, 22 Jun 2019 12:34:40 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:39 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 01/26] crypto: arm/aes-ce - cosmetic/whitespace cleanup
Date:   Sat, 22 Jun 2019 21:34:02 +0200
Message-Id: <20190622193427.20336-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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

