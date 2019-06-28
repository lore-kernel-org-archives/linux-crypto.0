Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89BAC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2822133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cX4JGEFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfF1JgE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35557 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfF1JgB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so8334933wml.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K222XYBP17tSu5k19NnMFnfodyv8IVdo2b46vWib5MQ=;
        b=cX4JGEFXO5VmJM2e5FpHXtbXwUVXAEsK/csLWR+EqZoubHgnfh7BAMiw7xAOU54xj3
         abheNFTjuHtphO6hpRH+XLstLP0MWJlS2DwliWghS+beVeH6pNwtT44wragY4VqlK4aL
         wA0Wh2WojWF/C3Q9bKrP3lDz3x/IPMc7o2lcXlxMGnOaxKY+HKiSqIYSifzmFOyUekES
         O8+LwTu+DB+2M5U7PDoPiV4YZxrz+OLVyaYcH2KZGk8w2JgTPyx63wme7eZ4DmJ/R6kQ
         gD6H6ulB7A+kFc++VxdMqtR3UjXVWt5hi1VNeknvzKAcaehWAXtLmhRNW9z802yK+6hC
         DiEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K222XYBP17tSu5k19NnMFnfodyv8IVdo2b46vWib5MQ=;
        b=si5MWVNu7RIYigFEKJAamn/CwJshti1wuG5JJIlc+W6IQacQbeou48vKGaJylVPfAM
         Kb8GJcvvr53gyVUaHDoyT1BU52iPVDRodKaXj3s2zOdobuRskj7EnVl6mJYcnsW1XzTR
         QXefxqSTDB3jmoo1rY5/XayDCiSa0YnEQj1txWyvnTu0oZQeF8pcg0XjH0OJj0JWFDD5
         Mtg3QAbmPa7UxDImluez7PoiGKeRoo9gT1Kq8osCT44cUp18i9Xs+/vtipVTnD2ILSHN
         IMOPEzyz0oB2o986wMTPm4R9KVSE2uip7hqcFONJ8RyiKvLIYWjSJztFPm+jv+5qY6Dl
         OwFA==
X-Gm-Message-State: APjAAAU09onZaYFToo1/+YLPvxGNAYD/wvtsWhWNj5dD9Uob2OImI4ZU
        5qsoOJk5XZg9yLKuYWizNFR2r5I7aN9AuA==
X-Google-Smtp-Source: APXvYqxHtFnC+m1zX2moM/tf/j5BtTYCVrlbH2jGtY5g/005vlpSeIY9izTQFsBK7l0MaK7ynU3S6g==
X-Received: by 2002:a1c:a654:: with SMTP id p81mr6210556wme.36.1561714558596;
        Fri, 28 Jun 2019 02:35:58 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 19/30] crypto: qce/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:18 +0200
Message-Id: <20190628093529.12281-20-ard.biesheuvel@linaro.org>
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
 drivers/crypto/qce/ablkcipher.c | 55 ++++++++++----------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 8d3493855a70..d9e067885a0e 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -15,7 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
 
 #include "cipher.h"
@@ -162,27 +162,17 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablk);
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	unsigned long flags = to_cipher_tmpl(tfm)->alg_flags;
 	int ret;
 
 	if (!key || !keylen)
 		return -EINVAL;
 
-	if (IS_AES(flags)) {
-		switch (keylen) {
-		case AES_KEYSIZE_128:
-		case AES_KEYSIZE_256:
-			break;
-		default:
-			goto fallback;
-		}
-	} else if (IS_DES(flags)) {
-		u32 tmp[DES_EXPKEY_WORDS];
-
-		ret = des_ekey(tmp, key);
-		if (!ret && (crypto_ablkcipher_get_flags(ablk) &
-			     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))
-			goto weakkey;
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+	case AES_KEYSIZE_256:
+		break;
+	default:
+		goto fallback;
 	}
 
 	ctx->enc_keylen = keylen;
@@ -193,24 +183,32 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	if (!ret)
 		ctx->enc_keylen = keylen;
 	return ret;
-weakkey:
-	crypto_ablkcipher_set_flags(ablk, CRYPTO_TFM_RES_WEAK_KEY);
-	return -EINVAL;
+}
+
+static int qce_des_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
+			  unsigned int keylen)
+{
+	struct qce_cipher_ctx *ctx = crypto_ablkcipher_ctx(ablk);
+	int err;
+
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(ablk), key);
+	if (err)
+		return err;
+
+	ctx->enc_keylen = keylen;
+	memcpy(ctx->enc_key, key, keylen);
+	return 0;
 }
 
 static int qce_des3_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 			   unsigned int keylen)
 {
 	struct qce_cipher_ctx *ctx = crypto_ablkcipher_ctx(ablk);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(ablk);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(ablk, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(ablk), key);
+	if (err)
 		return err;
-	}
 
 	ctx->enc_keylen = keylen;
 	memcpy(ctx->enc_key, key, keylen);
@@ -382,8 +380,9 @@ static int qce_ablkcipher_register_one(const struct qce_ablkcipher_def *def,
 	alg->cra_ablkcipher.ivsize = def->ivsize;
 	alg->cra_ablkcipher.min_keysize = def->min_keysize;
 	alg->cra_ablkcipher.max_keysize = def->max_keysize;
-	alg->cra_ablkcipher.setkey = IS_3DES(def->flags) ?
-				     qce_des3_setkey : qce_ablkcipher_setkey;
+	alg->cra_ablkcipher.setkey = IS_3DES(def->flags) ? qce_des3_setkey :
+				     IS_DES(def->flags) ? qce_des_setkey :
+				     qce_ablkcipher_setkey;
 	alg->cra_ablkcipher.encrypt = qce_ablkcipher_encrypt;
 	alg->cra_ablkcipher.decrypt = qce_ablkcipher_decrypt;
 
-- 
2.20.1

