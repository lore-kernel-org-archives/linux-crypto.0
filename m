Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4337C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CD5820656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aI7XcIar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfF0MDw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52416 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfF0MDv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so5468165wms.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wZ7h7T6D7FriYQJyTTKDn8ZPwN76Sl1Op9utn1sqOJI=;
        b=aI7XcIarY98WRTvPq7tz5Nm6GmwQ1NW6C0S3zIpW9B5X5B6Bak2XRtfySkDtw4K2al
         3mz9+o24QCgHzD+df5or7VH5p/MygeL1U2H/Kjn4U+nbzi7FH4DVSy7KcRLXS/KkTItO
         us2MnJzyFkYUvK3gy9Ith38H9LCaZ845ek7bgyfPoW9CPaJDEWq2FEcrNrcvlf61f4sr
         zgG7aaEA8zhp8Adnkr3bckZeo5pAqjxy01UAzzgn/17Xh7tDgAg58XhGu4x0gAFxzJej
         oiDhhI06ImK6pMTErkBSV31Nipwh3QrzhW7uKQjK2gp6n5vRbNsfCgkVOD4InAy0xFMU
         7Z+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wZ7h7T6D7FriYQJyTTKDn8ZPwN76Sl1Op9utn1sqOJI=;
        b=fSTt1CyUQVusIrtcP+IuaoLRNfG/e7DEI/nHiTauCevNLHgrQ3bpZvqbjVCWy03gMv
         EUDzD6Cnx9m6XvPP2hxqZC6Ofrf8HBaXwzp4WeI/0Ahh3+9LQjP1iB6lJ/3penCncriS
         7eEj3egt5MgQ63i2jhGDoOxbFty/aHM3EFY4E4yoq38rIdfLaVt0rigXLXNepAUP83PH
         dhprxUrOfjoZ0zx3QxX17CoKsCNznQB9L+PJQmK+Ggpj5+s+TXXRfBblEnFukagNvVO7
         tNcqcZb+DA74UH49Ninxp1SxSSELD12EPUCStZjhtrwfVrVPuEODbEJGX4zqaJgMWexs
         WeRg==
X-Gm-Message-State: APjAAAUjZU9T++w5lJr4rcaE2837H5qHf1rp/nbOycneGVbxrODlA7MJ
        tcjkYnzFgITMH+8ZSwnQxreeBcqbE+Io6Q==
X-Google-Smtp-Source: APXvYqwBf1n1ySoLvVIe7R1SVrZfzGRONnnCWzHQ1mtx8lchpMwtUqy/vgKloNYH7B+3HTRJxf25ww==
X-Received: by 2002:a1c:3942:: with SMTP id g63mr2709158wma.61.1561637029136;
        Thu, 27 Jun 2019 05:03:49 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 21/30] crypto: stm32/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:05 +0200
Message-Id: <20190627120314.7197-22-ard.biesheuvel@linaro.org>
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
 drivers/crypto/stm32/stm32-cryp.c | 24 ++++++--------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index cddcc97875b2..c1c7124c44aa 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -15,7 +15,7 @@
 #include <linux/reset.h>
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/engine.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
@@ -767,17 +767,11 @@ static int stm32_cryp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				 unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
+	int err;
 
-	if ((crypto_ablkcipher_get_flags(tfm) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    unlikely(!des_ekey(tmp, key))) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key);
+	if (unlikely(err))
+		return err;
 
 	return stm32_cryp_setkey(tfm, key, keylen);
 }
@@ -785,15 +779,11 @@ static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				  unsigned int keylen)
 {
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
 
 	return stm32_cryp_setkey(tfm, key, keylen);
 }
-- 
2.20.1

