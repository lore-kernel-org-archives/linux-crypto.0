Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103F9C48BE3
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA6D82084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RMfB2j6C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFVAcJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36787 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfFVAcG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so6915577wrs.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UegmsAOjoNCHrQaB/W23ATKBTZ4x8N3x14/ck1Y1UZ8=;
        b=RMfB2j6Cb2sx1Rm9XYLCYM6p+siIEicTA5Ft5WqkGakiwcWqNRaGPagAeNuE9E+ORH
         xAE1jD8aAE1ykIjapFruNPPK7Wrns0s8VdPWdUbl/RA29MGyOZbvdaKPHOfY/Ovff7z8
         dj4eLDKy+BXeNOclRGqgyOSb6yXGagY/11VGMhhsnEz7CRE86+4Phq+Iy1btjYlJWyjH
         qHaHe51FxfPtYNoigik2vd7OZKoTXjuz5ock/IW/LmRsEb+CZJW/g3MFj/UVY2hH75g4
         4xGKiBtKGKip/9cMqTB3BCWv3jfLSv07V9HB1DejT34dgkikka+4NgPwuFCepU2EFoAQ
         8b7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UegmsAOjoNCHrQaB/W23ATKBTZ4x8N3x14/ck1Y1UZ8=;
        b=S0gujvKIdV2O262FvLvqJxibtbZe3W0lgKvGm3AqGG4UO2c3nCqnil+LyMlltLwHTe
         ddKq0hzcP4FT0SQX1FL6qibJ/SIfeTs+/0badsza5JQlO1gCirWBY1F7P55nfVNEg2KJ
         ARFS47fjciTi2HMmDAd2f9lKXfuYEeniAb5orrlKv8Ve8QwzLsy40zu+hGkoaDTEVFoH
         Jc0y8ETsZ3QSovBoMOmLH8mjCl0w54MEtO/zS8d/n0Yb/Jb26SdPLXOCWsPALrh5B23t
         1Vebkr7nB58SFxw8hUfIy/nJB/9TTZ06d9+q/6FCXPwwS5bGAD68cknCqZEEqwzeRaCk
         TU5g==
X-Gm-Message-State: APjAAAXG7yHHEidkjo+6IT//cUWNulolN5sdbTF0P9foeDelC5rMdBnv
        HReHL5GyyvD3we2TXBojy3qNhlj8JSRh+Ffi
X-Google-Smtp-Source: APXvYqxypPmY2iDv3gGEXV2xCzsoeuFzu5q15Z4vZlhzBijOtt9dFzMHkyW/iwKl7QJr5zyZIVJJDg==
X-Received: by 2002:adf:ce82:: with SMTP id r2mr35969812wrn.223.1561163524328;
        Fri, 21 Jun 2019 17:32:04 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 19/30] crypto: qce/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:31:01 +0200
Message-Id: <20190622003112.31033-20-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/qce/ablkcipher.c | 23 ++++++--------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 8d3493855a70..e646e90f93ed 100644
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
@@ -177,12 +177,9 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 			goto fallback;
 		}
 	} else if (IS_DES(flags)) {
-		u32 tmp[DES_EXPKEY_WORDS];
-
-		ret = des_ekey(tmp, key);
-		if (!ret && (crypto_ablkcipher_get_flags(ablk) &
-			     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))
-			goto weakkey;
+		if (crypto_des_verify_key(crypto_ablkcipher_tfm(ablk), key,
+					  keylen))
+			return -EINVAL;
 	}
 
 	ctx->enc_keylen = keylen;
@@ -193,24 +190,18 @@ static int qce_ablkcipher_setkey(struct crypto_ablkcipher *ablk, const u8 *key,
 	if (!ret)
 		ctx->enc_keylen = keylen;
 	return ret;
-weakkey:
-	crypto_ablkcipher_set_flags(ablk, CRYPTO_TFM_RES_WEAK_KEY);
-	return -EINVAL;
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
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(ablk), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	ctx->enc_keylen = keylen;
 	memcpy(ctx->enc_key, key, keylen);
-- 
2.20.1

