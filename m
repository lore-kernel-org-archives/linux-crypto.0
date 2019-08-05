Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392B6C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AFE12147A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qh5/u+tN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfHERBL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:11 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39216 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfHERBL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:11 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so63356272wmc.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UaFeIJVkdrrw/rHVyeG7FW2dacd7QIWLt424KK353nA=;
        b=qh5/u+tNP38v3vR8pSIfog3UhGhSUVTn37qlhEudFCxYh8pYPh9cSJHMdyyDXQn/3y
         sL00KeVt5Gxttqo9et3o6kIUFJ2zw0D8eo/vYD7u8+TSXzc/FOxxOgwwmi48fL3ww7tW
         wcpTErW8rO7yo9ttQsYNpsFckceMFUBHHP5H/8gdHmw3i3fAkEWreKW+djB1WUk+U+VN
         sN6AioHkfubYfxHeOn8dfMDUpW+fjx566bxQb9HGMdyRtxl8k4fPqLHfSow1tExq2kJz
         qiks3keC/0NN94jQAmx9dzS55Yy771rmreQ0Vml8LyC7GenTWb+TG2CuQbxJFnnReaF/
         BKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UaFeIJVkdrrw/rHVyeG7FW2dacd7QIWLt424KK353nA=;
        b=paAcuPMtViM9T+xOuUw+HuzDpjiqLgl6dIaqquO9DyQx6Yvoe7TgeCen65CUONBWmG
         G5nMlIrMVNkdSEnIb+Kvx66lrI/O0GMogSadq+vGXWooDmLI2ThA4ZSCeSKb5djhAt5B
         +QyRxdX19q9zQokMo7/R+IxHJHjwHirQ/HcxUhSPm2Tf4ldY3MZUuZ4bsIOhu0OuF9O+
         mQFaRAChWuCMmBwWzZzBtk6YYByX5pH4wh0haklfnu+kR0imlSt5yg0SXMa6ZNETnhpN
         ++HMYe4mOSOaGvi0aGMHyYK6cnHErARSGit7EQz/oMfrF6I245bzMu2d/3vYZgUqUDuN
         +O3Q==
X-Gm-Message-State: APjAAAWQvp7VaP+0dNyi1LnMMj56lq1cHlaZ/tJ6yZGWtPwQX/2Efudk
        7EmampcLm28GfQDNoS3Pdne2lmp4Q+7Mtw==
X-Google-Smtp-Source: APXvYqzt3LyylFt49fme4MMAh6CIFc91EQDHzM/2i/CEeTmlYBa2LQuEjakQHehi+L9ur1OAFt1Nbg==
X-Received: by 2002:a7b:c251:: with SMTP id b17mr20120586wmj.143.1565024468705;
        Mon, 05 Aug 2019 10:01:08 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 04/30] crypto: atmel/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:11 +0300
Message-Id: <20190805170037.31330-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/atmel-tdes.c | 28 +++++---------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index fa76620281e8..4e1d9ca3a347 100644
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
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key);
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
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.17.1

