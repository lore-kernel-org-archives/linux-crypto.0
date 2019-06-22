Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4293C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8668C2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ElTmLRwt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFVAbv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47064 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfFVAbu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so8064172wrw.13
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xRjBVTkBknzStzHYOLza7roZdaQ2R1JxmaHYUbiqvWg=;
        b=ElTmLRwtLSeQqaRoNvsJJp/41tSWboLM8FSS9CRfscU1Q9kA0zGoNFPVXquQI7EMGy
         aLiY0XJNppxwK0E0VjUpc/h6HGrEFvBuRv1IJUfehx3V/aTiyNScsjjT6Y5JOow18zPc
         dCBb7sj4/sBOSsig7O6dvvf5n4yXzi19M5PAEQPxg+mY1WCV4Ffhkz8eXdshp/NwY7ns
         26JlD5aUEwlLZqNqwR6vmGGPsih+qKy7gIigakNwwE2gxlq0a4ZaCuGd5SBtfRX/aX/K
         KTbvkualcnXGFbZTog2t/BfWxnzkp2vyy01y7jqgikpfajvHnLGLX/jYbNczxIxzkq3w
         XDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xRjBVTkBknzStzHYOLza7roZdaQ2R1JxmaHYUbiqvWg=;
        b=RgekQJ8HvyjtlFVj9GGHGfCBwEV8ANiPDy+i7uBt69tqteZnKxetOw9FErlnrTHjKw
         7FDA589QPdVas0o5J59wwTocy4fj3p3pEPVbCRZWBEuPvPeEqcwEUCYQiHyMvexp4X5S
         gXqq++nU9pLH5fJ4W+HkNMrXsOnS2nQC8uf5nfya3gtyoBQbg9DHIsssHnyIgCu/Dvge
         6f4Onh/0VFfbXTPT1KcCF4YlSOqBmnPtf3LpTPEbTMMYpWrNMd3BnKnIeLA4tdvBNAxq
         eJ357oVV1e5OROHazBlS7NyVTZyYN++s5C8aVtCrcyXK/PmbKLIw5hiBFhrE3VBbBowV
         hRqA==
X-Gm-Message-State: APjAAAXXRm8YSIUR4Ncb/ZddFtk4P1kPiNAQGHoKnbfPc9DJ460hkKES
        k/ETnihScfiWePD9NcLw9gxOxeSOTyr1d8BJ
X-Google-Smtp-Source: APXvYqy5+Cyrfi1FNaf4yNcx4b1MCA2PNT7V9RMjF84fnUYcYvgaeSIr3OTqI9Np9Jpfbd2vCNxWWg==
X-Received: by 2002:adf:de02:: with SMTP id b2mr21934091wrm.349.1561163508422;
        Fri, 21 Jun 2019 17:31:48 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 04/30] crypto: atmel/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:46 +0200
Message-Id: <20190622003112.31033-5-ard.biesheuvel@linaro.org>
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
 drivers/crypto/atmel-tdes.c | 29 ++++++--------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index fa76620281e8..2f35b73b35bb 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -33,7 +33,7 @@
 #include <linux/cryptohash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 #include <linux/platform_data/crypto-atmel.h>
@@ -773,22 +773,12 @@ static void atmel_tdes_dma_cleanup(struct atmel_tdes_dev *dd)
 static int atmel_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-	int err;
-	struct crypto_tfm *ctfm = crypto_ablkcipher_tfm(tfm);
-
 	struct atmel_tdes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	int err;
 
-	if (keylen != DES_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	err = des_ekey(tmp, key);
-	if (err == 0 && (ctfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		ctfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -800,15 +790,12 @@ static int atmel_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct atmel_tdes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(tfm, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1

