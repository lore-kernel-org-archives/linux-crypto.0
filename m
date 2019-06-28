Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87CEC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D11720665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JL6dJcEm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfF1Jf5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54305 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfF1Jf4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so8408004wme.4
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k/iZYvi+pgbmK6dBlOMIArAvCwNQqEFpOEidZ0EvGck=;
        b=JL6dJcEm7zigYiHSV8iF2rHPxsUkVqGaqOChxW+zU6EEycdZt/Gngzcbkm8P9sz01U
         g5Bob62H6tLhOjW5BG8DyKQiwUWNxW0gTBbOZf6ESG+mjSptO5+5hIBKzj0Xe8TrtDr8
         EfB7OgLI2VxcYiFsP+mDtHKbOwbakqMzG7gFOI5z3XD18Djf7fIbUm7vsSD0/bafQUCI
         CC0x54fV/VH3EO6qR+V+McmS4EbFraVZcsYKwDwrb2ymumrr3URyieFR7W+SzqGy9Uzu
         I7AhuiyLgDpOPtoJuORNHlrqnlgc7wzXrEbatUfFUQ862PcQeJf6erFE1DX2xRf4x5Id
         udSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k/iZYvi+pgbmK6dBlOMIArAvCwNQqEFpOEidZ0EvGck=;
        b=nlSI8drrVDBR5bT04r84S5rRpXVszKmJ7tDSgW0Dv5111YGBsdbN6UQ8eUDjZAyVhx
         +dtN6hpxfPCB7kEidUQaOEHDIF81r+ifdsRTd1dbCDjG2inNgCj24ZAxKPGuyulbVFud
         2xVt8P/ZznhoTSSXu023QgPCAyYMoT72iZKhhnSl1ICaYq79OfTax+pjYqYmMdoUfegh
         Zuskvau8TO+Oh9EsVPY5BelZqGy4I2iGQ5w0F5ZLDw0rCTKzcO1BagSfWtJ4UESBQOPg
         YiaUNWilqdRBoQwhC8xuqaDxbrqbCuic+uhMgbjo7hSSfE4+A/+WklqykSdYLnRSpM6a
         VTUA==
X-Gm-Message-State: APjAAAUGyFOQAbZyoxCnzpSVaBy7Gzo5/D8KBEncjIJuGWMrHVz+Py4M
        1DxpTnjijBbAeJ5r9BvPMluu6KEH7sBD+Q==
X-Google-Smtp-Source: APXvYqxcAdWlnrScfcOY4ddLPzprAaV3cQ6fLULFVUD9qfkrnI7SZrEneCAINtS5dnttSVpEFS/79w==
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr7016092wmc.151.1561714554746;
        Fri, 28 Jun 2019 02:35:54 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 15/30] crypto: cesa/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:14 +0200
Message-Id: <20190628093529.12281-16-ard.biesheuvel@linaro.org>
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
 drivers/crypto/marvell/cipher.c | 22 +++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 2fd936b19c6d..5182438a957c 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -13,7 +13,7 @@
  */
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "cesa.h"
 
@@ -277,19 +277,11 @@ static int mv_cesa_des_setkey(struct crypto_skcipher *cipher, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
 	struct mv_cesa_des_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
-
-	if (len != DES_KEY_SIZE) {
-		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	int err;
 
-	ret = des_ekey(tmp, key);
-	if (!ret && (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, DES_KEY_SIZE);
 
@@ -302,8 +294,8 @@ static int mv_cesa_des3_ede_setkey(struct crypto_skcipher *cipher,
 	struct mv_cesa_des_ctx *ctx = crypto_skcipher_ctx(cipher);
 	int err;
 
-	err = des3_verify_key(cipher, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(cipher), key);
+	if (err)
 		return err;
 
 	memcpy(ctx->key, key, DES3_EDE_KEY_SIZE);
-- 
2.20.1

