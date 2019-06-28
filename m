Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C317EC5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F492133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A9K4xomB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfF1JgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35049 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfF1JgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id f15so5565462wrp.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UJ/qjCXMkjgSxlng7j9T2B4eqrY2mnAGmeyjbF9pJ4k=;
        b=A9K4xomBg+iTOR/Eq5qF7qW4h9XqJZ3hJ5BM4s4KOsGYaTrEDi+pRLenn+4aFcAAm/
         UE744VQAGd4JU3xKoI0oHNL6/fI1mvzTrSdLUiRWlk++FxUN4nLRRP51o3XBu73AsIk4
         juaPMakKepZsbyf2gPje2JzVHMiISNDH4jc2cWcjeF4NN7fDLVScOGudzDF2UWeBNQ5L
         bMg8YjSkrcZrS+OUsXoAqI+EcKvyDwW0dECtH968o1RYZtaaA9aT2WSjyQUraEBfSosL
         0loWSiSFVseNOcMyZq6wWbQpDFGICV+chUejx1BKX+bMu2HPo/w1/9pDw26rwPuLCpw5
         enfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UJ/qjCXMkjgSxlng7j9T2B4eqrY2mnAGmeyjbF9pJ4k=;
        b=qj1wflr3+plehkd+0Gq+cLSLorP5NhKaFDVQx7JmeXPdNwSKLiS3qH6KO2Z3a2WNyp
         5J0bEOD+wG+6klsC5wJf0VdBTbUmGaD7Tec8dh9m3G1KH2DX04ng6sxcBhsAoEUXwRYy
         I3yxYa8JMptWHG0k9MhOEnjBcWe4WVidBNNzcj3jbtYEqnghZc1Rma4VPKsYbVEXseLH
         SdtFn7i5LTGfhCdCuUHTdYHUF3IZroxkBYrtdaMOwkUuiaLrKLbZma2rburUwtID8DP0
         gIuj9vYWiu6Ts7PKZnW4q3cCHXcE2ScSTI0JWGKtoiwCmTrFrSokd4A2QD6sXd6TqvQP
         vKiQ==
X-Gm-Message-State: APjAAAVve2uSlOd01vkIvn/dUzevfc+vK0xXzxWh6gv5N9QqBeSnGRKk
        qwxmA3M1cFjlOlAsNSLoT4f1sJKtBSxv5Q==
X-Google-Smtp-Source: APXvYqwdCRHksssmY5bQMQhwUmJqH7JYPkZhAcca6kyK5nFZjAr88edKaThrbbpP1aihSNPseARyUg==
X-Received: by 2002:adf:dec3:: with SMTP id i3mr7056107wrn.74.1561714563008;
        Fri, 28 Jun 2019 02:36:03 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 23/30] crypto: talitos/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:22 +0200
Message-Id: <20190628093529.12281-24-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/talitos.c | 34 ++++----------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index c865f5d5eaba..3ad97e42fafb 100644
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
+	if (err)
 		goto out;
-	}
 
 	if (ctx->keylen)
 		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
@@ -1538,32 +1535,15 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
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
+	return crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
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
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
+	       ablkcipher_setkey(cipher, key, keylen);
 }
 
 static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
-- 
2.20.1

