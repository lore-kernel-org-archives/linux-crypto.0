Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1190C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F2622054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bUrIic1R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfHERCF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53215 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:04 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so75433441wms.2
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r7ls2DjxpPhpnSXgla0/xrMuG6IDqfz30uB5D7zV4eg=;
        b=bUrIic1R02Ou6MH2xLxKoZIHEo0CSPuBtMlSUf1eAa5cnjOmkc4XqMq9wcU61nNLJi
         aw27qNyfsf5VhUCJIPmNVEVgdyzP5DMMRk4YNR4/xuDPgGk3stuGHkEQGtlYA60EvaGi
         P1oHlxG2cqDUG32pG2Or6HCG3vR2wrIGLk88vEqwVwqRxiddQzLqMm4nHVPTGLntqOY2
         sUBhWNjeNQJjFSlG6qc4B8UgXJQbZRPV+5LL6SsemnGW1Xep1yqLHI++CeTq1NEE75ZH
         Yp/rE/hRt5KT9qVJEt8lkpTPFeaCbhpM7ndu9HUxJwdZD/Yv9te3ABRDpMCKBbAuct0R
         0oow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r7ls2DjxpPhpnSXgla0/xrMuG6IDqfz30uB5D7zV4eg=;
        b=AS2xLpPi0kRVMJ4sNvu41BbkCJJmy8srcmHvawrnhBVBPV1jo2ZKKnxL6X5YaPsJtv
         WXXvpwt0HIp9cFO//p/6P7fEpvkVO9gS7hXG6MVPgua8LtVxUJlk6hCh9OkAaWahueQx
         Kv6eNd966BoMgIEcnizFG5GpT4MhVEMH6upBwwE4cU+Yup++T2XAG2Zwn8rAjCBNeozE
         udM2SQm6D89RBQzx5cRauOnrRToTI849MOmFIi+aIRKd/hOgK6wkZ4Y9rKKCndUVdkTP
         LCZtVzxS0uOTi63hE7d8d07D6P3hxxD7Oa07vlOeIXV+k7Pwgvox3G2z7Mr54LugVtM2
         GQVw==
X-Gm-Message-State: APjAAAVtegkTNSVct0OQzphE0IkKLMnXhFp0/8tsicAUc287ZxrnUkMk
        KAvi3EFzk91rJ3ZhISj7NIASJVIhnjEU5w==
X-Google-Smtp-Source: APXvYqzUFovAeMqROFKZ8aO0KvvI/jILBYlHkpb4y/+9ZpjLYtMHfX8Kpu9KbbB7WBwO9itXmroZnw==
X-Received: by 2002:a1c:e109:: with SMTP id y9mr18615191wmg.35.1565024522647;
        Mon, 05 Aug 2019 10:02:02 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:01 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 19/30] crypto: qce/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:26 +0300
Message-Id: <20190805170037.31330-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/qce/ablkcipher.c | 55 ++++++++++----------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index a976210ba41c..f78f47a18a3e 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -7,7 +7,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
 
 #include "cipher.h"
@@ -154,27 +154,17 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
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
@@ -185,24 +175,32 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
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
@@ -374,8 +372,9 @@ static int qce_ablkcipher_register_one(const struct qce_ablkcipher_def *def,
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
2.17.1

