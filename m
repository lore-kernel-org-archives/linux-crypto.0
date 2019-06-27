Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67570C48BDD
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3373820656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MZZmIZvX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfF0MDx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40678 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfF0MDw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so5399139wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K+e75pqvyX8YF44FDsxuzr3TRtIJEnQtyvl35LqdHDo=;
        b=MZZmIZvX5I7gzj2TvovtkfJh2LpPobIOIvy3y/rOcoR4z8HzpGrDMeW2I3eWAYhWnY
         OpvoVzF7CnplEpEzTQmJVFgdIp9CUwxKuwhhZnREfp6mYMmoFUg/pjwxz4qsv20fIZhD
         N0LGjNBKX3Fwp3RNJRxPzX5Bhzxpk3ZhhBn8RjSzcPT/dRViT1ECmxTtJBlGDy4Om7L8
         immsLupNgMR5Urs5spn3nVktSrkzHyeH8W/pzMVB6x5cHTKEXhKbk0q+J+9kh/bgdXUY
         Qy3sk4dmOTv/8WvhIV9zEEaLEnDYEA8jXRzxCrJ4Sh8Js1v3ogWZkHsXuRH8GqV1QDca
         K3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K+e75pqvyX8YF44FDsxuzr3TRtIJEnQtyvl35LqdHDo=;
        b=p9p6WrP+iyHTDZY6Msot4AGpo0Ik0466OQSGaWmb5cuzkcc4UPks5UYf3E7j9oZNrB
         37J1yLHfQZhB+uRINFIOZnYEc39AOubi5lEqNlzo/Lg6HAdKuYGtKdQx3dmZdReQAL9M
         YHF4KgwDsNKwPHEA+MoZ6JxlKvQ8VZiiDEQ6ZeuxlPfz1YfQBTn8s/jvxs7o7xE5o3eV
         sTlDhVo0OC+KRoWmUQ0xUHVyUBWXHoY0BXFbXsXAxdhfs0ZYqXF/iEqVz5ofU7dJ9ESh
         Eb+0FbCSJF9hCtkTdyRBgbRVl4TGt7DQ5tsr1AlgB6opDBEzTQ3K9rY/l63OVAZyge1T
         ZpCg==
X-Gm-Message-State: APjAAAXUWKWWYfL/tojbqIvxdGVypanU+hb7oZBafpI7aeOqQ1oTXfmJ
        7OjnWenWDbAMEdx6P4THReqfNtpF2npowA==
X-Google-Smtp-Source: APXvYqwBc/l8sXy1n878zh8aZBcffAenKx7hNm3CE0YctTEdS5vryQqrT4VZb8lbF9jzrkfDf1m02g==
X-Received: by 2002:a7b:c347:: with SMTP id l7mr2910218wmj.163.1561637031148;
        Thu, 27 Jun 2019 05:03:51 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 23/30] crypto: talitos/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:07 +0200
Message-Id: <20190627120314.7197-24-ard.biesheuvel@linaro.org>
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
 drivers/crypto/talitos.c | 28 +++++++-------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c865f5d5eaba..022292aed9f9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -30,7 +30,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
 #include <crypto/internal/aead.h>
@@ -923,12 +923,9 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(authenc);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(authenc, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(authenc), keys.enckey);
+	if (unlikely(err))
 		goto out;
-	}
 
 	if (ctx->keylen)
 		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
@@ -1538,14 +1535,11 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
+	int err;
 
-	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
-		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    !des_ekey(tmp, key)) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
 
 	return ablkcipher_setkey(cipher, key, keylen);
 }
@@ -1553,15 +1547,11 @@ static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
 static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
 		return err;
-	}
 
 	return ablkcipher_setkey(cipher, key, keylen);
 }
-- 
2.20.1

