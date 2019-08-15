Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3FEC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50B51218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xDReowXW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbfHOJBw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55958 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJBw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so673500wmf.5
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tzS9LGpq6ZYGPr0TCVhTbC0UKoF/48plVxVUkivfzi8=;
        b=xDReowXWvAHMKgAX26p+WjLOlTeUj3+QhLfKzEve2e3YZasi7clWMcSEBNGiT6k41q
         1E16c9DmCHlUcrW/m/fvpzxfaFihfJMdrd/hFhuV13/u1gggXpYdZfMNcI1CEvR2O00r
         9PAHdS9mBMv74GyivxORGOxGb5hmBHMrnoMpzZRERjZXFGhsqCRd4I0hZDc0dstdLOSl
         GBpyn2Ah1wsry1EdfAIDHy+yGZ8jAw6W8AN6R3OkplcrfCt3O6eXTFpyTH+UtFuv2QE0
         swR5ah5suCeE3Q4wQNcufx5BRyenNaaWHdbLKO6ry9WLOn0KdrcLS99Gr33DmB3dl/4G
         h5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tzS9LGpq6ZYGPr0TCVhTbC0UKoF/48plVxVUkivfzi8=;
        b=ns6LLclGaxMGxNrqu9AOi9t8i8bbwtkFpUi+7I1QEsRFRcZgbhOCedcr4n4hNWmqK/
         Wz+Yv6s94rdGot89zj54iO2lNUFmL2yuPSY+B4VQh953GLHcv0OYzsrW4n0C9Ufcr2Au
         xqvv/51dYY7O+QrLMYFzZ/KfBUpvdAJIzc8JFSkkEUVT4v85/qtGxUm3cR5BNQuQ6KFV
         IvS4bafPfaAsi0HZOnfs0C/hg0QjdEZpiZNw9pX+88mZqVn2W/coOOGW3Rnia7glF13V
         v6LibUOoqi29AvIAGib3t7yWU3SMjRSr43RZcstpYi8pl3CpUzhpsOQ8SpJO3kkfRnVK
         NgfA==
X-Gm-Message-State: APjAAAU1ibdbi6E6mPcxA7rsWIafpHu3eNTgroW4wEZVgLXSphTGUubg
        o4OvzlP7aGoiRAeP7Kk7qAJLa8gKD4lBzDpm
X-Google-Smtp-Source: APXvYqx40kLxl/00AdUwHXwrRrzx7YNzyDytBvC5uOIogymYTjRi3dlCvBPuwEOq0SlgypXBfHb0ZA==
X-Received: by 2002:a1c:a852:: with SMTP id r79mr1641225wme.36.1565859710358;
        Thu, 15 Aug 2019 02:01:50 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 15/30] crypto: cesa/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:57 +0300
Message-Id: <20190815090112.9377-16-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/marvell/cipher.c | 25 +++++++-------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index fa1997e70b63..84ceddfee76b 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -10,7 +10,7 @@
  */
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "cesa.h"
 
@@ -272,21 +272,12 @@ static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
 			      unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
-	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
-
-	if (len != DES_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
+	int err;
 
-	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = verify_skcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, DES_KEY_SIZE);
 
@@ -299,8 +290,8 @@ static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
 	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
-	err = des3_verify_key(cipher, key);
-	if (unlikely(err))
+	err = verify_skcipher_des3_key(cipher, key);
+	if (err)
 		return err;
 
 	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
-- 
2.17.1

