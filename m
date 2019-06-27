Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF986C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6042086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bdL1sSFI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfF0MDf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36993 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbfF0MDf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so5403704wme.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hai0Lu7faBG5mSfDAFgpAWqlovJTaNKDb9Ui/f2YGWE=;
        b=bdL1sSFIqH//pFaPnXFtH7QkVxPCKTCvt2xQDfSDQYMSH2A9wKAEQ/RK7mS6kRwZWb
         VgIY8WNsnjWrpJHYpMOCI3CaCtK2+JEzblkJ9DQ7z6EvHMmi8sLLHi3UDGiiuWAzhw35
         tWAH6wVvK9PXHAE4xr02xQOXjA6tpd1B2lo/hjNQl8n7/sxtLfrAMl5ovdgswV3M6fH5
         rTCUQvY1lD0FjUYZkq/611L6kjmwhRV0rQvuNCMivAHijD/Ag76PiFyjIUTjaA9JDvr6
         YsAeNy5PIl+JjtQmFbumiMu2ymVeQRzKI1rRmXBY2aHb1KtcVHuq0kEhHatWHBQpa7Ei
         Qh2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hai0Lu7faBG5mSfDAFgpAWqlovJTaNKDb9Ui/f2YGWE=;
        b=FM5Wumy+3S5g3sqRCc9aG15ujA/4CHiII8AQLbg2HrL9UmctP040Udv295KeGHIFWo
         OKUaGsz+lVOfzsf7oFSjLKfSppNDdix3uUlYb3L2zaOIf+EQjZHwUVItMNx29ifSgpZ0
         VH9b90kc3VwdaC6BHaY+OoH5yD8ouui846DCYqn7GOxCzvyod+Pkl0BIRCseZB7HFlpx
         3bMyZ3yeBz437C+Ujmg3C4DOPIqfxaGZH/hxxIxqOsYmeYtvnqWeMKxA0Q/Af8DYQ/rJ
         6bvEMf3TT4NKZ1Pn3Ks+l3DvcSrdOJ7Pbct12TTOttaoLYVo7Ozzqp0rWGxuCNGGz3VJ
         rRcA==
X-Gm-Message-State: APjAAAUSt3OFE8q8SSA1L/yuNo98WRvxpQa1EzofcBRbQV4oAf5fU1/R
        OL2rMzAhJmmPsZjsY6JO7jtDshWPav1Gig==
X-Google-Smtp-Source: APXvYqzNfBRdpY3khjEzXMTVa4ZvTKRZlA44J4IowMsn9WkSTeSZf7e5GQyCSFapQXkkuUShR4oXOg==
X-Received: by 2002:a1c:b604:: with SMTP id g4mr3095567wmf.111.1561637012557;
        Thu, 27 Jun 2019 05:03:32 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:31 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 06/30] crypto: caam/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:50 +0200
Message-Id: <20190627120314.7197-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/caam/caamalg.c     | 39 ++++++++++----------
 drivers/crypto/caam/caamalg_qi.c  | 17 +++++----
 drivers/crypto/caam/caamalg_qi2.c | 17 +++++----
 drivers/crypto/caam/compat.h      |  2 +-
 4 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 43f18253e5b6..bc054c119cdf 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -633,7 +633,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -644,12 +643,9 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = aead_setkey(aead, key, keylen);
 
@@ -785,20 +781,23 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
+	int err;
 
-	if (keylen == DES3_EDE_KEY_SIZE &&
-	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_skcipher_tfm(skcipher), key);
+	if (unlikely(err))
+		return err;
 
-	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
-	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	return skcipher_setkey(skcipher, key, keylen);
+}
+
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);
+	if (unlikely(err))
+		return err;
 
 	return skcipher_setkey(skcipher, key, keylen);
 }
@@ -1899,7 +1898,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -2018,7 +2017,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ecb-des3-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 32f0f8a72067..3e29d4ba14e0 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -296,7 +296,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -307,12 +306,9 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = aead_setkey(aead, key, keylen);
 
@@ -697,8 +693,13 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
-	       skcipher_setkey(skcipher, key, keylen);
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);
+	if (unlikely(err))
+		return err;
+
+	return skcipher_setkey(skcipher, key, keylen);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 06bf32c32cbd..edf619f33b44 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -329,7 +329,6 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			    unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -340,12 +339,9 @@ static int des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = aead_setkey(aead, key, keylen);
 
@@ -999,8 +995,13 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
 				const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(skcipher, key)) ?:
-	       skcipher_setkey(skcipher, key, keylen);
+	int err;
+
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key);
+	if (unlikely(err))
+		return err;
+
+	return skcipher_setkey(skcipher, key, keylen);
 }
 
 static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
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

