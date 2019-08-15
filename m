Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0582DC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C588C218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rVFgaPdx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbfHOJBd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36272 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbfHOJBd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so1598039wrt.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rdyePxh79O5cxOEfR+t7TLBYxhR+49UWEAWghHr6ZEw=;
        b=rVFgaPdx5jR/vH2Y8Q+hpDquwPjUatdPmd33Q88NnIHRtzOZY/gradDoPlbaaJzJkq
         Yxwfaw7I0NP3F3a3t37wwcQr6mpHX3xeL+dpakXYILjmRXYhjfPNX0ma/j2Wt+Fc5v1L
         jaJhYD09MFAtVBwuxByo/AoIgcO7E7PELP8yeziMJDTGRv63aiftpJX+QHdL7XHHPB46
         FK5csTBPvtt5hBa3qAV4lm913/SX0RIkQrRLIAWKxH9o+zdtEoRpA0XR2wNI2Hls/qvj
         MeMKe29BH68imRAF1uPrCqAPGC++jM2gxO2NNolaMvF9vRtbTVhCiPtyguFLUtZ2Ee/x
         qJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rdyePxh79O5cxOEfR+t7TLBYxhR+49UWEAWghHr6ZEw=;
        b=LGWjDHPZUrjfD45V3PeHot6GJ/+X529cYKHdaJT7dCpIieHYostPHgNLSqtBN0rDNG
         FcV6RCczdEBZ6bTo5fU96/ofnnhXE4qVxvP2aB7fNcQshM3DBaI9rihEy+hRmiui3OUc
         FKpiROV9fbyw+Zb9Gvk8VyQxVLI0AOvNcS8DCp4i88LQ6blaac9Ko+kA1RpkE6nNEGkH
         xyDgDYblspgMDHLF7Ll3x5ZuY2gmvP4KauNh358/zjf1Kt8/2qEJbctrC9fAChQQbsUk
         pHpMGOH/azA8ppl+M3JmYT/NoPTm8Hn4j2aotT7zOHjCQ2FJWXVpi5D8/iI549JmlvW8
         f1AA==
X-Gm-Message-State: APjAAAWqNBpJNhYi/AjCWPB3Xjjid6+2eVfWpiPBFVs8QeQFIMmR7jyi
        UHCRsMM1l7HlfHi6z0OW9rZBIFxfPnkKQsB1
X-Google-Smtp-Source: APXvYqwElgqRF0EXHGFFoFlYNOQWtxIoHln8XczVJbhBMk+uLkkvu07PBMaWTuSolb+rPy9kGnRyug==
X-Received: by 2002:adf:dc03:: with SMTP id t3mr4127450wri.80.1565859690772;
        Thu, 15 Aug 2019 02:01:30 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 04/30] crypto: atmel/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:46 +0300
Message-Id: <20190815090112.9377-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/atmel-tdes.c | 28 +++++---------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 6256883a89ed..1a6c86ae6148 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -33,7 +33,7 @@
 #include <linux/cryptohash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 #include <linux/platform_data/crypto-atmel.h>
@@ -773,22 +773,12 @@ static void atmel_tdes_dma_cleanup(struct atmel_tdes_dev *dd)
 static int atmel_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-	int err;
-	struct crypto_tfm *ctfm = crypto_ablkcipher_tfm(tfm);
-
 	struct atmel_tdes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	int err;
 
-	if (keylen != DES_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	err = des_ekey(tmp, key);
-	if (err == 0 && (ctfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		ctfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = verify_ablkcipher_des_key(tfm, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -800,15 +790,11 @@ static int atmel_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct atmel_tdes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(tfm, flags);
+	err = verify_ablkcipher_des3_key(tfm, key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.17.1

