Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71ADC5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D8FC20665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nfq7HSWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfF1Jf4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52852 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so8401961wms.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rdODT+FHjoSLRdaSp+suVW4mRIrssGGLkWxGg/PtoU8=;
        b=nfq7HSWxaIt7leLBM7hzJ5ONkzzGF0Etf+Sfm4JJxMeeFtB/q3/7IjDwxJSzdSf2GG
         kNJleZDA1QQsAl8UR6Yd/c2wBo40/iGbtP5OPrA/jvvpXurI419EI6ZwJq+5gZAT2JyK
         oS48M7Wd8joGgSaMA/yGLm4/sP2KYUl3Q64Rwc38xDERD5yLjlmYcRrJhO26FYg5ntZ6
         8tgMEyMgKN++xN0IYXx0fzOXg4+DPLdfVC8AmguVlvjc0gYL/dd6NhlQHtVa9TkIuisO
         Lmd626mwSds5qW/k1B30s/Ul+Fyo8DBiymQO/0ZgXJgv84SWIzfC5tx6Hn9bUmKOrSP5
         /+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rdODT+FHjoSLRdaSp+suVW4mRIrssGGLkWxGg/PtoU8=;
        b=e5yzse6BqQPTuzSkOONDIdfHFKBFIbaODgY98o+dmO/0jfOZc7END7wG/FweXXE1fx
         HX41wIa8Pj1JIBukAuHJeojtxyVptIyxLtw9/SiPLLnx4JAPU2w40MMaeLjY6t1pz2N/
         gmFQxk8jqiXV1DnI2x5VZFIBkP6+YnOJG8tMBdEulUUrhPhZnU9oEHRWvi0mEZ1BHQvH
         66ssVpmcMsUDM6yQkXrv9KP0+XsS+5sMwLCBOrdyJ6w3tOhRY9MlTfFz+APEskhq3Wo0
         In+LlRWtp99jE8qhsGsVCT5GeNTV4sz/t0S+QK4M6GeumvI5l82gP8H+Ue+Cz8cv+cvZ
         BTlA==
X-Gm-Message-State: APjAAAXd1D5CNChd8aNP8sugUDd6vGwsnfe44R8lLFXueCxE5ZGCPFtz
        rcF7jwMMGoRca+D/+5COYKwg0i/HMeV3Dg==
X-Google-Smtp-Source: APXvYqynjlRM/0yat21YSbU7uzbHGy4V2XAGI9uHk9l9GqlfmysBSdYXOJXbpjbgLS/PczmAxRZotg==
X-Received: by 2002:a1c:4803:: with SMTP id v3mr6697979wma.49.1561714553578;
        Fri, 28 Jun 2019 02:35:53 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 14/30] crypto: ixp4xx/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:13 +0200
Message-Id: <20190628093529.12281-15-ard.biesheuvel@linaro.org>
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
 drivers/crypto/ixp4xx_crypto.c | 28 +++++++-------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 3f40be34ac95..16a81e58aaee 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -21,7 +21,7 @@
 #include <linux/module.h>
 
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/aes.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
@@ -760,10 +760,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 		}
 		cipher_cfg |= keylen_cfg;
 	} else {
-		u32 tmp[DES_EXPKEY_WORDS];
-		if (des_ekey(tmp, key) == 0) {
-			*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		}
+		crypto_des_verify_key(tfm, key, key_len);
 	}
 	/* write cfg word to cryptinfo */
 	*(u32*)cinfo = cpu_to_be32(cipher_cfg);
@@ -855,14 +852,8 @@ static int ablk_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int ablk_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			    unsigned int key_len)
 {
-	u32 flags = crypto_ablkcipher_get_flags(tfm);
-	int err;
-
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err))
-		crypto_ablkcipher_set_flags(tfm, flags);
-
-	return ablk_setkey(tfm, key, key_len);
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key) ?:
+	       ablk_setkey(tfm, key, key_len);
 }
 
 static int ablk_rfc3686_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -1185,7 +1176,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
-	u32 flags = CRYPTO_TFM_RES_BAD_KEY_LEN;
 	struct crypto_authenc_keys keys;
 	int err;
 
@@ -1197,12 +1187,13 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (keys.authkeylen > sizeof(ctx->authkey))
 		goto badkey;
 
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE) {
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		goto badkey;
+	}
 
-	flags = crypto_aead_get_flags(tfm);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey);
+	if (err)
 		goto badkey;
 
 	memcpy(ctx->authkey, keys.authkey, keys.authkeylen);
@@ -1213,7 +1204,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_setup(tfm, crypto_aead_authsize(tfm));
 badkey:
-	crypto_aead_set_flags(tfm, flags);
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
 }
-- 
2.20.1

