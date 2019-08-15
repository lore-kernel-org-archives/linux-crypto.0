Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD7DC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56C5D218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qc9NeIxw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfHOJB7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40074 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbfHOJB7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so674699wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oDHNJUSdNPqpSjf/F+ShbODkMMvSncr+A96YTCBGPY0=;
        b=qc9NeIxwzioPaFkaKkT3fVDcnGY3Fgrc+Vxc5idgsbqDUdnVU/RcGxbYyYJPaiecXO
         /5rjUmoM22ds59uL8XVIB4e+i8R9g5DeRFTC4KIhihzEcUUpjQPwlEz0albFDx5U2PmA
         OIGsJNpIe8an0jIQytcvt5UiK0oV1smRL10iI6nyLuOO9Xwq26XWLnNYeSxJPVGJh0Is
         cnkYtaUMgh2GsefAE2gmIept4mKR/UZm1BSHhFReIgbswY7KdFJDvt4uuCJvUZpJavMp
         UAouVGaL71Bb9k0Ia9sUTPguDnFVlWOJv0qnTm2TsJkFq0s5pnJVGbnzv1/oWVpP38i7
         bPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oDHNJUSdNPqpSjf/F+ShbODkMMvSncr+A96YTCBGPY0=;
        b=LPL6QzBRvoEJt2WKppfg6qtT+S0sZLJ8hFi+vL3ec8pK8ib0mgsAen7h/35TSCEUUv
         T4TCs3xJ6hRrAsw8sFxf2fIGaQfLXncNEG0x3SaggNzeE0MV6EKHHfRtkOLzJb8pUwGO
         tIQp1Z1pTOmVhLqypdjJAmPGjzSEcJyNwizP48Oei5pfA3FAeLj8a8daNIFUYx1nFKE3
         4Z0gk9r7SYpysRVKMsGA+QIYdBZU9EPVAfNC+qDY1Pgj21poAqop94hN2BuG0p8WF1QY
         8mUjKvL27wbqJNwGGAH/swrl5PBoivdaEtVdaLtScO4SiOKB9/ZSIqbbmQuiKic0f93t
         QmMg==
X-Gm-Message-State: APjAAAWi7hjxlXfY6vRJ4s/x4tZ1/f/awaGLBjL2aspC+zj0b0vZFUrC
        5pYNVedppRqaWS8emY2JKHIxdBrLOICu30wD
X-Google-Smtp-Source: APXvYqxL7DIBN5Wl3PDJWVYojday5JMSfhT2qRK1IEFakaDsUsVc2CK6ZxRvbuU9+8mNeVmH2aOVDw==
X-Received: by 2002:a1c:2ec6:: with SMTP id u189mr1655823wmu.67.1565859717581;
        Thu, 15 Aug 2019 02:01:57 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 19/30] crypto: qce/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:01:01 +0300
Message-Id: <20190815090112.9377-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/qce/ablkcipher.c | 55 ++++++++++----------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index a976210ba41c..7a98bf5cc967 100644
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
+	err = verify_ablkcipher_des_key(ablk, key);
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
+	err = verify_ablkcipher_des3_key(ablk, key);
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

