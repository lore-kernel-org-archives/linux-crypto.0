Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C73C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64FF62086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WinQZvKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfF0MDe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46299 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfF0MDc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so2223415wrw.13
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SiK1utFZeFTC11vWPtZldu78CHZEvE7pPFtw9F0TrYw=;
        b=WinQZvKG+F/zYaC3KkYq5eI+mDGuzRqQ3cpZNStbcNVVA70G+aoW6UtdCWLyFRd3tk
         kG6YAN2tz3t/zvsV1qo8u8nXlNH2xrh1g+qAa6WniZm0nPuIRg/YrET1BlUhUDqyXpa1
         +rO8AP4Zp3iwbl8edXyTg9xGUQUkqFBtXmUXdPYP7sfPwiKFERq630cxxtFHzumqCJVX
         9zIizvNl6FDSb9XRCoHgBKHxc54MAaDYufGr7gcd2rMEyDHnWG/tSVfkd5hYpqc+dQEQ
         QhrIOFW1btkTdsGkYnmjhBhSAxMsp0B6zPR2eR0UubveHNBso2tsYQo7tTvEmfJv+Vwf
         FuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SiK1utFZeFTC11vWPtZldu78CHZEvE7pPFtw9F0TrYw=;
        b=iAob2NQUESv5Ct09pXsT6VhCJtU80Mu7oEtFFOrUV8Jd6rQlKeSJ4Y3/WxrEUmvvgE
         28+gvDd4qT3Ej9zvK929hs+o1rfs6UZpODlJZEuaZ13pGs1OoMmT0fMhUtobaYM7zEaW
         aKsbofvB6ca20mA++BbI9sDbu+6/2tQTebQbGOy5v3OUmKA+DUzf0UUspHGpW1+bpuvC
         d6fWlaNOtYZnPe3a8XUe90GR5n+8of5L08LCyjpohkcFdYBAGPV/QhXsuHc+aUq/1Zi4
         QkzDqfs/fi7Pn57yuiI3la+gd8pka03kg9XaM91+nA1kFOgtwSCQxHv0TZOgXMVoP+fu
         0W5w==
X-Gm-Message-State: APjAAAXqqtzlaSdvVd6a39CD47H6FHvrO94rTh5WQRbjG5VdEaySWGfJ
        tBnSDTTUjGyNidwBaEXehN2cosM1i5aKgg==
X-Google-Smtp-Source: APXvYqwIwpcvSVpXy5/3obUhn4kv71lAoxW59YLGcXaiBrKn02w9JSuQx/HQSC/cbUtgmeY88mn67w==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr2918027wrm.68.1561637010606;
        Thu, 27 Jun 2019 05:03:30 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 04/30] crypto: atmel/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:48 +0200
Message-Id: <20190627120314.7197-5-ard.biesheuvel@linaro.org>
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
 drivers/crypto/atmel-tdes.c | 28 +++++---------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index fa76620281e8..3df8b3bb12a5 100644
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
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -800,15 +790,11 @@ static int atmel_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct atmel_tdes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(tfm, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key);
+	if (unlikely(err))
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1

