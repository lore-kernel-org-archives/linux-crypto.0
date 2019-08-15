Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD8BC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA81D218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zOPR7zma"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbfHOJBf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40035 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbfHOJBf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so673711wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ycLlab3IQyS0WLy8fOsxcrFStN9eKVE/xTtX4RGLwls=;
        b=zOPR7zmazEa3IlB5ICwrAAJAzqjQnvWGCJzPRaHG1yS4f4yYE6+qn7GV+md6T1dOQ6
         surM/TQNDSoPZgvf80fM5q7AMOVwumM+lJAREEtmyhfIG63GJmaSQZHLfmpv6rBHDyX5
         STQAPWuTHG5pQb3RLMzJoxbHGA7ukO7wa32pnl9HNx7lsVnHHSyUN6OLWxnsccoLehSv
         T1ZYIyXowVYHLoToTPmYU9PZYO7zeyU6dvBhJM663YeCoiPoIzD3t9Czvz/m4qRbKmtk
         eURFvlIt9bF4umuhXKXavrgMCVLjCFidx3jIHNXE4v6Fnsq4ZsQu90j8EUUKqt11vZ9l
         T3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ycLlab3IQyS0WLy8fOsxcrFStN9eKVE/xTtX4RGLwls=;
        b=JOicpdksfkvmtIOh2wWqeLd3qzuUUWW6GSSXJCMuFzGqtul7JtCLp/ZYjtDwIBjKnB
         Y7zbrtIkuVuQ4gByOsgxE86q8ZetkzHsecJClxAzO630deC2yucIO2JnaKq/fobe83Gr
         jVPiAlhLRkm3WZM+g38enjsY5mRHYlNRb5jQOmPWWrYi7T/EQsQX9oYLf2js5Gib6USZ
         4sj1TSZ8krIVr00yTxW7KKwVZKyDaYlLen8LTo06qlxMfnU0BCT1ffmTUz2Dh4LRvqZh
         nOnDnPxajqXzx0z2Xc/JM3tDs1+l/IDmcFZ741T8MRD3Tow6KV2X2lwH85BKKfCnHauD
         XVEw==
X-Gm-Message-State: APjAAAX8LoEGiogZJvN7a1yP/aSySyOg4BRXITnfehiIjjVVJgorORZf
        KhmFOpcrPuldbWxs3Z7r+6iQKsDZwVbbzZTp
X-Google-Smtp-Source: APXvYqy8UUip7jsQnkW58R005BoWWqaB6ilKwRPHgsUk/6i2oNwSVoUSxe+AZl4tp+udUPKP9B2ljw==
X-Received: by 2002:a1c:a852:: with SMTP id r79mr1640031wme.36.1565859692936;
        Thu, 15 Aug 2019 02:01:32 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:32 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 05/30] crypto: bcm/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:47 +0300
Message-Id: <20190815090112.9377-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/bcm/cipher.c | 79 +++++---------------
 1 file changed, 17 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 1c23e452700b..f85356a48e7e 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -24,7 +24,7 @@
 #include <crypto/aead.h>
 #include <crypto/internal/aead.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
@@ -1802,24 +1802,13 @@ static int des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
+	err = verify_ablkcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_DES;
 	return 0;
 }
 
@@ -1827,23 +1816,13 @@ static int threedes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
+	err = verify_ablkcipher_des3_key(cipher, key);
+	if (err)
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_3DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_3DES;
 	return 0;
 }
 
@@ -2868,40 +2847,16 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 
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
+		if (verify_aead_des_key(cipher, keys.enckey, keys.enckeylen))
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
+		if (verify_aead_des3_key(cipher, keys.enckey, keys.enckeylen))
 			return -EINVAL;
-		}
+
+		ctx->cipher_type = CIPHER_TYPE_3DES;
 		break;
 	case CIPHER_ALG_AES:
 		switch (ctx->enckeylen) {
-- 
2.17.1

