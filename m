Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EBB8C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24FE4218AD
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KdXNwkVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfHOJCH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44478 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbfHOJCH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so1563909wrf.11
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w4DLwdf0vNkcjK1oUYPJMOwRT6FQjUNCaxQ0VkHOdYY=;
        b=KdXNwkVeoBib8xSjJPulcNiB/FgALn1BQj+LmHP09bdsN1d33d1VIb20tqVLDomkrz
         rvzM+h4qhmy+8IdHi2XgQHCliThwE0H8XBo1M1+7ntEIjlv9fKhYzncBeuCNnO8ROfTU
         HoVRIloSyBv/s8+wEWhdiMQNQPQ1LsWBStijTQi+dQDmec0WmUibaRPASYx4BdmDdUfN
         o6+Gh9WcIagnlMQDqDOTi+wSsWGIekiiAnLmAIuROvPvG8a+uCKbaocRJ5fQc1GLANag
         3E2fkabbCHmkPOqx/M3mf2eDZbT1GH6mE7JfRyQYKAx+qtqglAHRAphKD+HnX32I8oG8
         jSkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w4DLwdf0vNkcjK1oUYPJMOwRT6FQjUNCaxQ0VkHOdYY=;
        b=NfnU/3NCNvoeUAx3E+7FgZXt767PE6KBFDqNnR4eYARcsIOkI6JG/IxajeD8oRsGzL
         lKTjIhFc3d9qIjK6COrjkPnmp7e/yK2YH3qvS9ftiTsPEi52Nbrxr4cfcfRwdtUDI1oe
         nOQmOy6nAChkgaWk9Wi3AAwAmcASBN563YxxTkHJiHWkxxWj7Hly2cdEyYF5gHXFv4yt
         Z8Qz1uf1benqZ1ZIpLHR7fw9J0d8FafcAfM2IBxUSQuFL9N+cOizoFkE7nkrzsGpga7L
         39685WggogF6CTONvu/d8qSqvvaLxdi1mmCDdOebU5Ur4zgoWeRM6DC8QCJAapnVVrEF
         x04A==
X-Gm-Message-State: APjAAAWDExB6CbKggjVcRHpy7RpDZazDr0fGS7z8AV9e1hoovUp7U/Rz
        YicgBC8ht+F9dW1fQjrToUeHLMNmuRzuAndM
X-Google-Smtp-Source: APXvYqwPxJDS+DXcGg/LG5Jv+5HJpHDeF0bbvKnU8jKuvRNUXUz+HsaFvnlTAeikY8QHmeFq1ad7Jw==
X-Received: by 2002:a5d:6b11:: with SMTP id v17mr4149576wrw.323.1565859725010;
        Thu, 15 Aug 2019 02:02:05 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:04 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v5 23/30] crypto: talitos/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:01:05 +0300
Message-Id: <20190815090112.9377-24-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/talitos.c | 37 ++++----------------
 1 file changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c9d686a0e805..117c831b5ede 100644
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
@@ -936,15 +936,9 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
 	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
 		goto badkey;
 
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(authenc);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(authenc, flags);
+	err = verify_aead_des3_key(authenc, keys.enckey, keys.enckeylen);
+	if (err)
 		goto out;
-	}
 
 	if (ctx->keylen)
 		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
@@ -1517,32 +1511,15 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (unlikely(crypto_ablkcipher_get_flags(cipher) &
-		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    !des_ekey(tmp, key)) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
-
-	return ablkcipher_setkey(cipher, key, keylen);
+	return verify_ablkcipher_des_key(cipher, key) ?:
+	       ablkcipher_setkey(cipher, key, keylen);
 }
 
 static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
-	u32 flags;
-	int err;
-
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
-		return err;
-	}
-
-	return ablkcipher_setkey(cipher, key, keylen);
+	return verify_ablkcipher_des3_key(cipher, key) ?:
+	       ablkcipher_setkey(cipher, key, keylen);
 }
 
 static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
-- 
2.17.1

