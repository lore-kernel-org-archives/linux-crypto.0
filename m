Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5446EC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 291AC2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IuQR9FjV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfF0MDe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43605 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0MDd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so2235139wru.10
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j1mRQgZhEVSPh2opm7CEW9MGSpAHZzLYocHpi9vXVhA=;
        b=IuQR9FjV28obh9kejFUuADrMW+nbQSRoh/rCQkpHUQZy4fxMUz1VIFs2yhC9ZMRbFE
         9ngofC4f201T6/zNCABrTeGibavlm53XnOm5C6cKnMUT0alBjR7JqmYN9x7BZ2fhzzJ/
         hlo8pOhkbrfo+JzcDT3cI4o6d4lCU9BJzXBcH24uHy70FFNIBw77aPKgSPd+KOxmmc7S
         QloYY8S38Fa+lD0h9fyX/fAi83M2+G1+Isf2fDocZprBkc49Vf09sWg20yLxl29DZK8k
         4w0hZbmzxl/859JniNbwGy1wAYfI57lqnq10Nse1YAeamHzeBlPTOOInTAK6hD0ii/DO
         JqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j1mRQgZhEVSPh2opm7CEW9MGSpAHZzLYocHpi9vXVhA=;
        b=uMi/aIBlTHiu+R+kwXJ2tIfhhKO52FxJLUVvpzkQkpK5r1C2pN2HI5sPYHkgLRRB2b
         Ta68aSG4/4bVuxx/bbLUcBBp+7uSz3GigF2QgBMqC/CAtzZZpvHO1BT+UV7v/7RsFotm
         LkDCWDeX9Smlal5LPu0puWujXZsnhLD83kY+lVM3m/XIjoNrEHtMVRX90C1AjIt5/14D
         aypylUYUfkDK7G5EFmBFk769GSM3sFVYHycpXU0DYctu1miPVzbxcdtpWaFT8YqoOlMA
         A+Dg2RMpPRbmzAhXiqBUnJ2LYsvTyIrbhJCh+mN6FdkZqnKcZScsS55ZDaoYNSsIe3+G
         XBbw==
X-Gm-Message-State: APjAAAVQVTwFIgVUen3Oe7rmuGSbDm9VEQLRxo9VsflN5yurOr/Y/tnB
        BHU2zzc7KwMP93k1SyMt1aw8qQHmkB9Eqw==
X-Google-Smtp-Source: APXvYqzS1WKKZIRFZl2VXbTPkDmzHu2xNg8v41FIDl5glby+gvz+hbW8fCYoE6i5MNFtc70oa+Z6nQ==
X-Received: by 2002:adf:ea92:: with SMTP id s18mr2921647wrm.257.1561637011600;
        Thu, 27 Jun 2019 05:03:31 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:31 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 05/30] crypto: bcm/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:49 +0200
Message-Id: <20190627120314.7197-6-ard.biesheuvel@linaro.org>
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
 drivers/crypto/bcm/cipher.c | 82 +++++---------------
 1 file changed, 20 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index d972ffac779d..02006781528a 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -35,7 +35,7 @@
 #include <crypto/aead.h>
 #include <crypto/internal/aead.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
@@ -1813,24 +1813,13 @@ static int des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		      unsigned int keylen)
 {
 	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen == DES_KEY_SIZE) {
-		if (des_ekey(tmp, key) == 0) {
-			if (crypto_ablkcipher_get_flags(cipher) &
-			    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-				u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
+	int err;
 
-				crypto_ablkcipher_set_flags(cipher, flags);
-				return -EINVAL;
-			}
-		}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_DES;
 	return 0;
 }
 
@@ -1838,23 +1827,13 @@ static int threedes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+	int err;
 
-	if (keylen == (DES_KEY_SIZE * 3)) {
-		u32 flags;
-		int ret;
-
-		flags = crypto_ablkcipher_get_flags(cipher);
-		ret = __des3_verify_key(&flags, key);
-		if (unlikely(ret)) {
-			crypto_ablkcipher_set_flags(cipher, flags);
-			return ret;
-		}
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_3DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_3DES;
 	return 0;
 }
 
@@ -2866,40 +2845,19 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 
 	switch (ctx->alg->cipher_info.alg) {
 	case CIPHER_ALG_DES:
-		if (ctx->enckeylen == DES_KEY_SIZE) {
-			u32 tmp[DES_EXPKEY_WORDS];
-			u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
-
-			if (des_ekey(tmp, keys.enckey) == 0) {
-				if (crypto_aead_get_flags(cipher) &
-				    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-					crypto_aead_set_flags(cipher, flags);
-					return -EINVAL;
-				}
-			}
+		if (keys.enckeylen != DES_KEY_SIZE ||
+		    crypto_des_verify_key(crypto_aead_tfm(cipher), keys.enckey))
+			return -EINVAL;
 
-			ctx->cipher_type = CIPHER_TYPE_DES;
-		} else {
-			goto badkey;
-		}
+		ctx->cipher_type = CIPHER_TYPE_DES;
 		break;
 	case CIPHER_ALG_3DES:
-		if (ctx->enckeylen == (DES_KEY_SIZE * 3)) {
-			u32 flags;
-
-			flags = crypto_aead_get_flags(cipher);
-			ret = __des3_verify_key(&flags, keys.enckey);
-			if (unlikely(ret)) {
-				crypto_aead_set_flags(cipher, flags);
-				return ret;
-			}
-
-			ctx->cipher_type = CIPHER_TYPE_3DES;
-		} else {
-			crypto_aead_set_flags(cipher,
-					      CRYPTO_TFM_RES_BAD_KEY_LEN);
+		if (keys.enckeylen != DES3_EDE_KEY_SIZE ||
+		    crypto_des3_ede_verify_key(crypto_aead_tfm(cipher),
+					       keys.enckey))
 			return -EINVAL;
-		}
+
+		ctx->cipher_type = CIPHER_TYPE_3DES;
 		break;
 	case CIPHER_ALG_AES:
 		switch (ctx->enckeylen) {
-- 
2.20.1

