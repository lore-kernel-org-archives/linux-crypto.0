Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2C3C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C04D3218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lwdPUe/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbfHOJBz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35700 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJBz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so684872wmg.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J7UX2XGzxWe3m3OUYUOwz7PyEEOQmjxp5jPkPEdXR2Q=;
        b=lwdPUe/gijOIrR3ckJmpvUAAvjkspyEacuIvTqd4h8m2oC+kIGVCkbaksQIci0Xlr1
         XCqUUjqfY1FsrtCaW7Ag+9MZ9bFJs4doisLJAt+Pvih4fQZBnMOVWfNoSFMxGq/X2Y7i
         7coHqNJDdFwMePIsblq3f+Osih5/7t46yyeAwLVLScUri0lwmxei15lMAzT7vw+o6twr
         lXbxuyv3/DXen2/5ud7gCSxOkwrYq2IVv+GSWU4nAm+7C/tf0TLR+RaZLZYZqTPN+InN
         kDuA4Kc/QvwmLIDc6z4xG2Q7SmvGFvWXgPYnzcYq7RgymaC+/EFgZ9T1WHrug78CFAFE
         k3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J7UX2XGzxWe3m3OUYUOwz7PyEEOQmjxp5jPkPEdXR2Q=;
        b=FReYssn0BHuJyqwwv0LMVJ3eKEuFLERkWf137J5d50wupN1SFJsWqEnnViIzlPU0GR
         0FuiRMkj8uZ7IbK2S0grKmIrFuAMzw6h31n2agxODkxmq5z2Qk/fyIL3eZCnP4wZGDZa
         ZpNqRwadEuifOOm7YFosOnVOxgUlr8opvls8XPPAySHoNJ27P6eZgbRPe0gKFmaS8gIM
         e9sDPA6YezIyCRdgCqwBF/6Ts8z1Cv/PXCjspszEAiaGykpwgpNN1ohNEAVxuxKTAfhA
         s3pjAO6yRtXXVlibbN8tEcUJsAxHLOEeejmNBbqjmLddEBqXTci02z5Yt+6jCVJFxJWU
         BLhg==
X-Gm-Message-State: APjAAAVQr3C9ZdJ0VuHMyR/e1D3DSuxDvg+v3h6qMjuVbMbJ8rpma91v
        SqJph3Nv+9juz+3hnzGZJ6UgQAxy6gORlSY/
X-Google-Smtp-Source: APXvYqyzu/tkjOsnROfmLVBAHc+XcwF6PLz5qTcpDPeNUEaFhAg0hcXy6mYQHooGXRUJC6uT1DZI/A==
X-Received: by 2002:a1c:6c01:: with SMTP id h1mr1700638wmc.30.1565859712659;
        Thu, 15 Aug 2019 02:01:52 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 16/30] crypto: n2/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:58 +0300
Message-Id: <20190815090112.9377-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/n2_core.c | 32 ++++++--------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 760e72a5893b..4765163df6be 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -17,7 +17,7 @@
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -757,24 +757,15 @@ static int n2_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			 unsigned int keylen)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
-	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
+	struct n2_cipher_context *ctx = crypto_ablkcipher_ctx(cipher);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
 	int err;
 
-	ctx->enc_type = n2alg->enc_type;
-
-	if (keylen != DES_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	err = verify_ablkcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
-	err = des_ekey(tmp, key);
-	if (err == 0 && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	ctx->enc_type = n2alg->enc_type;
 
 	ctx->key_len = keylen;
 	memcpy(ctx->key.des, key, keylen);
@@ -784,18 +775,13 @@ static int n2_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int n2_3des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			  unsigned int keylen)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
-	struct n2_cipher_context *ctx = crypto_tfm_ctx(tfm);
+	struct n2_cipher_context *ctx = crypto_ablkcipher_ctx(cipher);
 	struct n2_cipher_alg *n2alg = n2_cipher_alg(tfm);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = verify_ablkcipher_des3_key(cipher, key);
+	if (err)
 		return err;
-	}
 
 	ctx->enc_type = n2alg->enc_type;
 
-- 
2.17.1

