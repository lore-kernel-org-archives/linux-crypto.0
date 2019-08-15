Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025F4C32757
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3F7218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MMVlsP3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfHOJB6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36000 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJB6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so682146wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ya+ibHRHBdIQl7M6OE87Hqu8AxrbcNkQvqsyCSV7+xk=;
        b=MMVlsP3wQM1fAvXZbm8M0UMNRgoqbNZKjdfvb59f4jqEVYxqAtfnrXDSIbfOAfg8Uc
         kAXnmocvONZYKBx8lhUvUrq8Zx+8IjBKOg1Q8wqVtxUF6UtJBHD+Cb6/JXFKaUPCSi4X
         IL2ciJ6wcn5vYKL+gosC+vI387u5mA+seDBH1rlP1rMhbxKEJ3FhUvjWdNULDQ/z/NS2
         UHNGs95vqNtl1+O9wTKnVDEQ+r9IJURA6knuupQ/NTDeB56J/+1vZghzSO8MoPX2oGVp
         /Linik3X6FB3CddQRpV4oI1Wp57PlQVL7JNufcDVSunC7Qrdm75MsiW4qWPmd3Wn66oC
         KtHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ya+ibHRHBdIQl7M6OE87Hqu8AxrbcNkQvqsyCSV7+xk=;
        b=p1dDCcXO3781vKqAdLYorewTJ0AiIHgCe/Mx7aTOlfWjqSINay7kRPw/m8dPprjKBV
         x6U6KQ9476k2GKqCpmewJfADu/KzF7lW+My791L5hO9Yg9nzSUsmczLxjWNMmMkNnfzk
         HzHmYgzhYgVr5wj3Dma2LMB2R74XFqdAWb/IVhxCEt0XOokxh4WFayzr1UiuRM0XOFaT
         2O0e0/4QOsNK9NYHgm46u3AzyZTeYUeZh4LIeAmizGD32EK2lVLrQeBOwSy93IJYBb/O
         clRZKmzWdXz5Ecl/yZEPjcGKyywDDzxXqfC4Sy3V4hnlSgwYKSWr/OqsxHQ92+5WgCdJ
         XoBQ==
X-Gm-Message-State: APjAAAV31qdWOzj7Rl61w22ucpPj5zLPpGwi+faoKQRWz7ExtcjwJKI2
        lAWyPhVeePWS+9y/BFV1TaVHRzrBjAm/B+0y
X-Google-Smtp-Source: APXvYqyCJhHMddd5r/GWhTuSVo4fzQU4QbOvy02yR/rtvGR6JDpW0fdg4e/oW2K+D0iAIfo/Q8HbcQ==
X-Received: by 2002:a1c:80d0:: with SMTP id b199mr1660742wmd.31.1565859716118;
        Thu, 15 Aug 2019 02:01:56 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 18/30] crypto: picoxcell/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:01:00 +0300
Message-Id: <20190815090112.9377-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/picoxcell_crypto.c | 24 +++++++-------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 9a939b4fd32f..3cbefb41b099 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -6,7 +6,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/internal/skcipher.h>
@@ -736,16 +736,12 @@ static void spacc_aead_cra_exit(struct crypto_aead *tfm)
 static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			    unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
-	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
+	struct spacc_ablk_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	int err;
 
-	if (unlikely(!des_ekey(tmp, key)) &&
-	    (crypto_ablkcipher_get_flags(cipher) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = verify_ablkcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, len);
 	ctx->key_len = len;
@@ -761,15 +757,11 @@ static int spacc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			     unsigned int len)
 {
 	struct spacc_ablk_ctx *ctx = crypto_ablkcipher_ctx(cipher);
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
 
 	memcpy(ctx->key, key, len);
 	ctx->key_len = len;
-- 
2.17.1

