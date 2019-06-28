Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D54C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E35D020665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HONQYpGu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfF1Jfp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46701 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jfo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so5504215wrw.13
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g7i2ZeLmxiVPOgMFtREvWuPCCFZFsjn7qjyJc0aT0qk=;
        b=HONQYpGuHmQVrjQCNaaTEMw1t6HNmsN8mt04cX8Dlg9bzelZf/Bj1Rk4TgvRk9lsIF
         46enjWA/lvnBFHp4IliDeNUfIVJUun8e0mBEJta3n9SU/rSRBMjpI6rKftqe2hFtLeIK
         Jqy9zmV2Gcdztar8MfSqCEk0qVCmhh9rP1h2hYgj2cpDzLaKjXLa/9Zyr3UnjdEHWwIX
         JHuLS+XnTgR/iy84gNynWmCmmzSnITsc8Ct0QD40iISeMBZSF9yLK5WI6BP731Ez9wQ8
         ih1UKGFWNKv4a3YgPZDMIwgzbpo+mZ1v4/6P5EEDYnEFRxbMVM1NFiuIJFcKXDXxyCBf
         HEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g7i2ZeLmxiVPOgMFtREvWuPCCFZFsjn7qjyJc0aT0qk=;
        b=RVy6TAbDNGoEF99TVqd5UjkEVPgH1DOXtk1FzW8nO8shdRRKea2VrgYPZHWVd+un4z
         2iewpURgq6r4qMpYmLSGO3P2UZh9Xpa426RNvfymc4yJ63WzllyXrsNhBBXLCiR05pCy
         tXipkgVcrx38J5KNUqnKSIIREIvWVzKC7K0p1QTkfPk2U9P4LnaLiSFtZCw6nrposRIs
         yzTqhwzu7L6b5FV9oCskIQMPLvWxjOStPYn3vZiaxdZmvUKpFHe6veQQfqCJDDMQlYR6
         kkz/hbucBrtBMi/N5VOQfiwOSeptR/y3OSCIFM8WKkcI/6xrugV2Fr/a7VXJXhvwGvhD
         OIzA==
X-Gm-Message-State: APjAAAWRgWQ0wlpXKDiBvIS31tFevQKP/3e2gchcXSY2udagxmPMXHNc
        Sxy6LPhhGAUY7YQL022cDeiKXVNE/OwbQw==
X-Google-Smtp-Source: APXvYqzslMPeXTjzWHR6Vay+uRavFpLCPc9xPL9RZl7IhOp6x968sM5S3gjZEW/IkQ1tOJcPUF4NqQ==
X-Received: by 2002:adf:b605:: with SMTP id f5mr7522691wre.305.1561714542678;
        Fri, 28 Jun 2019 02:35:42 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 04/30] crypto: atmel/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:03 +0200
Message-Id: <20190628093529.12281-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1

