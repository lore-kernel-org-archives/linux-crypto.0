Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8A2C48BDC
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F270620656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F27JwnaN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfF0MDt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36698 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfF0MDt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so5406485wmm.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VeolJNzqAbHR2k5+QLOu5yeDuXFXjA87uwpAg7wCVgs=;
        b=F27JwnaNdipTYbq5Clhv0zgBjhElTxTxy1x/wB6AlZuuvuV/GG277jRm307TXIROuZ
         dTIoZexNYXz41wrDqfb0FPT29ExOEkz3LweiNoX81MrFSw5q0oFigMScBTFrT4CcxE/m
         tyajpEN7kZdmbS7inDN0+Phqgp3DpS27GyMlYEABI5/7e8psK3nGgH1O0sepKP9D9hns
         hQuB4WXF5naesBIkI4HFZ/ZbxCCoTuRHXkNfOLtMLHwNKz65DAFwbWOfZwSQlc83d1bM
         8WmgJLNJWFJoqXSe9klGHyZNKB9k7KwNpKXRWxa2Z1FhRL8KLSdB3qbnYGJs2QJCPKHT
         qGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VeolJNzqAbHR2k5+QLOu5yeDuXFXjA87uwpAg7wCVgs=;
        b=uAwODw6H3gSEbBOwkIJdNTLfMqCnGOgGlMtb8lG9K+yPdCW7U5P3rCJEqWb6poQgZb
         cXGhK/N6pSmS2nNKhn+ZI7m1ADcVYl4NMmUdw4gzPqm64OKkpIR+3Uct1PqIYi5pH9cc
         qHtMjxBm21moeB5Bz+vofIKrljMe/2+ljw74zDFYDWV/VjGVBuw7Z5m+RrgCcx2UR3qR
         xYmOGBO57YwT8x2Z3E+Dm8/OI7ApmyFKt+vMKHSpajPliodw6y0GY+zpSa5o8zpVqhHr
         E03YbfOUUatX/pwgo6xwcNpeZkuujVDujzpiuwAobAJsm4OlcaiRHoU/nz7JhvBkl5qC
         mz5Q==
X-Gm-Message-State: APjAAAXjnXYKbmYIvxpGxVQVk3kFHKSUPIaaT2eU5OsuoD7vKR+N49MI
        p58L87FG4R5JN3IFv+lSfG95b6IGZ3vRzg==
X-Google-Smtp-Source: APXvYqxaj3i8IrAcHL8ic+MeUwkqAmOxPbKYUDU6LsbWug8zzl9s9jMxz4Ry3pb8oVex3SUvfiof+Q==
X-Received: by 2002:a1c:2907:: with SMTP id p7mr2980170wmp.100.1561637026831;
        Thu, 27 Jun 2019 05:03:46 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 19/30] crypto: qce/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:03 +0200
Message-Id: <20190627120314.7197-20-ard.biesheuvel@linaro.org>
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
 drivers/crypto/qce/ablkcipher.c | 55 ++++++++++----------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 8d3493855a70..3003603f1872 100644
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
+	if (unlikely(err))
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
+	if (unlikely(err))
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

