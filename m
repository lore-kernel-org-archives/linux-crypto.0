Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AD2C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B21E8218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zwz1i9rI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfHOJCD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53449 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbfHOJCD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id 10so680627wmp.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aK500irIOyWCZfK/24qo1jK8JNVXK4wIKJej8ysCy/c=;
        b=zwz1i9rIMzQzz4hNhkdPgRVfX+8Zx6QYhRurULthi6GqEs5NjcF5k52jjSdoTFFbTx
         yKJNq6gjNd/R1pgQ+ANfKrjrZ1KIsivwcRX10Qa4IWiINZz6PjBpOcJR5mm+l2mx/oMZ
         NhjXgQz9ys/aabQiN6fWYZ6Obp2CKSH5yxr1kzZEcKmLKKGjomBxYjQQSqKpNc+P7t/O
         I18ueMEoSLobQkJvG77NxowGTklkCpV4llzpbSWY6fdG90DlWWW6JWhAtGhzu3b9qLxe
         OzGDPkFSJb9yh1l5FSwkFINHknQM9nnw7ssT2QeIs+e7agBf1QV0KttnHm1e6TcmN+C0
         URyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aK500irIOyWCZfK/24qo1jK8JNVXK4wIKJej8ysCy/c=;
        b=KMVEwOpVR4ImyeiZb9ou4LYLs3KgsV+HOqbtHVw2EscIi9w09B5FMI+/Qf7hkD23Bi
         aOFRG+EoeGAg6WCK12LZAYKmnlR8p+/TyR/OwH+MbX/RUK9wEfSBkRpV/UhJg78nmUbR
         IxdcnjfWg74yAjK4kK5G0PJ9bHjy8Nnmy5kWVSNJuO2fcYRf8EzlXa8l2Ovtb7gtNErK
         3nMEBaXbRrqUIq+3SMqT+VLJTD/hp1YLy9C+rt8cuFAlTIsEoCPPN+f7kk3eIrznwbZw
         4Q7DJpqZSHGqXB9L/A60Ui02wac1WDhAHbz8TcizeXnNf/IEsOMx/8llY+ASVmXPkoEa
         fn/w==
X-Gm-Message-State: APjAAAXV2ycFJqvXEc8DWzpZLIXjKcFnMns8z6QnxJ6oVpOGDgrBGGCi
        LV9pgJZrgUOxNXNG6w1AlYVEejswYdjOgp7W
X-Google-Smtp-Source: APXvYqz9hs2IkYmDG4ILyL6cW6fej+iWsXuMhRoUqx+wywifktnpUkK1+F8sECiUadQssd1oC9a1Gg==
X-Received: by 2002:a1c:5a56:: with SMTP id o83mr1663958wmb.103.1565859720430;
        Thu, 15 Aug 2019 02:02:00 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 21/30] crypto: stm32/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:01:03 +0300
Message-Id: <20190815090112.9377-22-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 30 ++++----------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 5cf6679da580..ba5ea6434f9c 100644
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
@@ -767,35 +767,15 @@ static int stm32_cryp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				 unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	if ((crypto_ablkcipher_get_flags(tfm) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    unlikely(!des_ekey(tmp, key))) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
-
-	return stm32_cryp_setkey(tfm, key, keylen);
+	return verify_ablkcipher_des_key(tfm, key) ?:
+	       stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				  unsigned int keylen)
 {
-	u32 flags;
-	int err;
-
-	flags = crypto_ablkcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(tfm, flags);
-		return err;
-	}
-
-	return stm32_cryp_setkey(tfm, key, keylen);
+	return verify_ablkcipher_des3_key(tfm, key) ?:
+	       stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8 *key,
-- 
2.17.1

