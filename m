Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785A9C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4621520665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NmOY6m7u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF1Jfr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39531 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jfr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so8312667wma.4
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xiXfaTfcHNmXQXrZbZppecn1+XjTuidegBVVmTGjHhU=;
        b=NmOY6m7uysJCw04k2UVIPXaBeNA1MB8fx4SqVi9Pk/Gd2fZ9aZdE9EkI8x7hDKSGZl
         DnWacO/Ek9juMK2zhjq6AVM/JGfp4uuNzrbAsHDi8Qdj6Wv93q8dC7ChIAlTs1J0BfUd
         GFetWBFE1uMneslkK86N1orZRptukd9V5YMcXDAWu4EMUENqnK0FA0UNe+bAs6C4xX7W
         vAgBIdTBPeevvlUxAgFyGlnDECkQawq5jurusOWcL8Ag+khT+VRk4U9glVn2dSej9IrA
         4dj400qBDwFaJMVStDVuYyCwoSHQ/vBQHfxtrKtnyoaYcnKeowVUsRhlyT/uMyHVDfI7
         7fEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xiXfaTfcHNmXQXrZbZppecn1+XjTuidegBVVmTGjHhU=;
        b=UfqpBe1Me2vQimH0byg0YBLJXLzC7XsnaocCXmpFSGnpzGxfqzCJv4jejfpD7T3o06
         xU4MUyCQuHszSdSOcvIe7lI6fS0T5lkiD4KSpnJI75GQvC7YBkDWickGdgOQDcLtkqiG
         cN3IlSdn36PSl2z1Jag4VVGprBH200EOp+geI2sMkWOCiWGtQcN41dMAD7wKi4T5RBNK
         1L7VL1/oRomYzOkXbVVMqAJoE8noIfnomDkQIch4Yf4wptV9UGNctSUa/EvUw2XtkNQg
         O15w/Sd5z/Wj8WaX9ec6uUbfflAPgTUrP+hr0RJI0D97ANCFZ/bZ85MSdDROg36JhSfl
         AeYA==
X-Gm-Message-State: APjAAAWpSqGnTXiT43XjvAdbNH4p+ru2P5UanPHrCNVloRuMmr5qwkxc
        E/aUkb4qXfafoWJClv+2EA4Qbb3byS6MIw==
X-Google-Smtp-Source: APXvYqw5G8qfqqVlnhVI9nYxQS1lWn2w42NdC8/HY8Tb7VVG1dI3T5c9JSSBDl7VCtUgb4ABYKPpQA==
X-Received: by 2002:a1c:ca06:: with SMTP id a6mr6692519wmg.48.1561714544612;
        Fri, 28 Jun 2019 02:35:44 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 06/30] crypto: caam/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:05 +0200
Message-Id: <20190628093529.12281-7-ard.biesheuvel@linaro.org>
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
 drivers/crypto/caam/caamalg.c     | 38 +++++++-------------
 drivers/crypto/caam/caamalg_qi.c  | 13 ++-----
 drivers/crypto/caam/caamalg_qi2.c | 13 ++-----
 drivers/crypto/caam/compat.h      |  2 +-
 4 files changed, 19 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 43f18253e5b6..9a9a55263b17 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -633,7 +633,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -644,14 +643,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
-
-	err = aead_setkey(aead, key, keylen);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
+	      aead_setkey(aead, key, keylen);
 
 out:
 	memzero_explicit(&keys, sizeof(keys));
@@ -785,22 +778,15 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
-
-	if (keylen == DES3_EDE_KEY_SIZE &&
-	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
-		return -EINVAL;
-	}
-
-	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
-	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	return crypto_des_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
+	       skcipher_setkey(skcipher, key, keylen);
+}
 
-	return skcipher_setkey(skcipher, key, keylen);
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
+	       skcipher_setkey(skcipher, key, keylen);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
@@ -1899,7 +1885,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -2018,7 +2004,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ecb-des3-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 32f0f8a72067..b3868c996af8 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -296,7 +296,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -307,14 +306,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
-
-	err = aead_setkey(aead, key, keylen);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
+	      aead_setkey(aead, key, keylen);
 
 out:
 	memzero_explicit(&keys, sizeof(keys));
@@ -697,7 +690,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
 	       skcipher_setkey(skcipher, key, keylen);
 }
 
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 06bf32c32cbd..b5c41b36cdec 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -329,7 +329,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -340,14 +339,8 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
-
-	err = aead_setkey(aead, key, keylen);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
+	      aead_setkey(aead, key, keylen);
 
 out:
 	memzero_explicit(&keys, sizeof(keys));
@@ -999,7 +992,7 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key) ?:
 	       skcipher_setkey(skcipher, key, keylen);
 }
 
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 8639b2df0371..60e2a54c19f1 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -32,7 +32,7 @@
 #include <crypto/null.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/gcm.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
-- 
2.20.1

