Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B8FC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03FF72147A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jrdksNqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfHERBQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36940 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfHERBQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so60059897wrr.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1skf/16VMTsy4/8YdQYg+FGNGjDWW/YmRxDC16RubmA=;
        b=jrdksNqWvQXJFmtLTjlY+Ah3a6ZQgkAyKDhX4zTNj6E7M6FuA1+Af4185U26SUtcX6
         G70XmCtYkzl2/hfktrgQyC8t+H4sMjDK1iIzzipjX2fBnhI41vgPQzp1a5PreJsjfgjN
         yjarnirAeNqRGc8nvsMQCt3tegZ+E1rp3X/hCxGuSZTiWN2z0QFRqzmmJP7FMDyvUKAN
         6P9lpIpTtaMNbmCcP60kfMCyM7Vxik/LKDxKLJEW9/bMHhQYuCkxMfjgwvA0dfBg0LcB
         y2YT/Sg9zxlyGBssB8v7uKD29nudN2/gCYNMU/gZD66DF+lj6oGuogjzzb5QISA/Dgx8
         twKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1skf/16VMTsy4/8YdQYg+FGNGjDWW/YmRxDC16RubmA=;
        b=ILQ/GCjhVY/4SNXTUz0gY0gTNwHk3BS9YmOf1tHUw/OnUOEvJSaXUfaPOA/PjKwzlB
         f5VJprxaQb0GLhRRfr6MtqpsPbZbXdIjPlkw7ck0Uw/Jn4ldQCSj13G+8yYGk8Dv4uPs
         W6c+CoBZ728H1VhsZtqtLgxUJJkBxdSzQzwyPjPu1WVFkFMzCqAopnmKhhy0ugtg+D/x
         X3/vz2iuHXmIYDIIUDfSm8+Qae0kuq9vTAONp27R403onc6kVl2DUn/h/mC1kGn19ugA
         cRhU4d8yjf5pHtz1pn4v6Q3sZ4c8Arhw1kgvgKeZp8KoP+sBdzx/vLEEr+mrNpTjiQKS
         N5XQ==
X-Gm-Message-State: APjAAAX67MJKN8JIWkF2qX61z3rJbcSEy29SKaH6QkXDkoRXw8Rp7z3k
        MJV3HbrmX0PxwhTgtszOiKdTAHOo33uR7w==
X-Google-Smtp-Source: APXvYqzQtLbO3vOf744SgXwet7xh8lB0AmI93WarmwWQll/1cQp6XV4/PKel45BH75E6K0XzLw3XEw==
X-Received: by 2002:adf:f3c1:: with SMTP id g1mr26896670wrp.203.1565024473011;
        Mon, 05 Aug 2019 10:01:13 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 05/30] crypto: bcm/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:12 +0300
Message-Id: <20190805170037.31330-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/bcm/cipher.c | 82 +++++---------------
 1 file changed, 20 insertions(+), 62 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 1c23e452700b..064c6433b417 100644
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
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
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
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
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
 
@@ -2868,40 +2847,19 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 
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
2.17.1

