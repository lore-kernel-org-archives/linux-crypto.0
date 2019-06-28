Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC252C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 934BB2133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ULVnDH3o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfF1JgG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51079 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfF1JgG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so8418964wmf.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SbP+be0VKCZMV/R80dxJeOXmRejXLpbCq1GzzNrrppI=;
        b=ULVnDH3o0sPgrwXdSpZyQyQgZnv8qjUaslB9qt2wtEb1qBPDf5+vDLlTMXI8J6uyEB
         8A6cpgmQjXNt3wp1JydGw2Q80HYomdNP82/k1slx5pCGDC9JoPFcMiI2hd0leLU3Ua9h
         zEnlNJHgmbGh0KC8TKKElmovPl1ooGzJ4TqY+lWLy+HoUQJVi6x9IlvSITtryOJMmUyf
         wPIj0XdFdiodlMd9BahOXwStWb9CQmdCtwPSK5BsniXCq9k72SxrczZxa8WHU286PqkF
         Czv+Km+ESc7ao/XacT1BVRGuQukonuZi2/ek+sOpepWjeuuVeJcyc4O/NiISyrz15SJt
         STFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SbP+be0VKCZMV/R80dxJeOXmRejXLpbCq1GzzNrrppI=;
        b=sTmdLrSPf6oPjmuODu7g96wgawcJZIMsDuwCv9SSLlgNbo30o2GwvaH9BGlkZNuodg
         wIbsZTc9moIVVTrhdcqv9+lZCCjyHdsK//UfUf0dYzuV09aZQjKv49c/V6ZpcAmbuuls
         PzhStAQit3opKw+ewTEUlzbHHf9g6/YugflGq8oJLrdFwDoZ0oOl66c8SnrVnrGYD9du
         DP72CIE7ulFVk41hMZ5Wutz7QfLIQ1brl6UxC4GSchsATYhc+6W0DwL7wMp53RoR4zi7
         nwvXmMPUONzgt4ETHwuXnFxtUTuT8wWS+nA4h7SaLDd46Y5sBEXfU+4MRfzWRmAjRHR9
         Vc6w==
X-Gm-Message-State: APjAAAW/RtTXzVKGHqQ2trA2ezor0QQ9u1ieIj8rZ2cLLB4Ebm8GVKer
        la3QiLeHuuXd+cV9dqiRQjVrk8LyWu33Tg==
X-Google-Smtp-Source: APXvYqzlGEJR0cMdsuW0HIkalaGMAE5I3T5T+lDzNh9JKAJq4YhG5OiJSQ45e7CwYK1y8Zxduczk9Q==
X-Received: by 2002:a1c:f61a:: with SMTP id w26mr7002918wmc.75.1561714564236;
        Fri, 28 Jun 2019 02:36:04 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 24/30] crypto: ux500/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:23 +0200
Message-Id: <20190628093529.12281-25-ard.biesheuvel@linaro.org>
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
 drivers/crypto/ux500/cryp/cryp_core.c | 31 +++++---------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 7a93cba0877f..4713e534547b 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -29,7 +29,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/scatterwalk.h>
 
 #include <linux/platform_data/crypto-ux500.h>
@@ -987,26 +987,13 @@ static int des_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 *flags = &cipher->base.crt_flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
+	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
-	if (keylen != DES_KEY_SIZE) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_BAD_KEY_LEN",
-				__func__);
-		return -EINVAL;
-	}
 
-	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) &&
-	    (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
-			 __func__);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -1019,17 +1006,13 @@ static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1

