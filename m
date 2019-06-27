Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58331C48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E2E4208CB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WqbQsLf4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfF0MDv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56154 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfF0MDu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so5465893wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q25PpZzJYl69vPoE9WmxVzLyhHRn/eQiQv/nA2MhMqo=;
        b=WqbQsLf4i+Zc+IfQ5qJfmnEXS5HvXVLHPBm6UR9r5wy7sLYF8HuKSR3XB2oT6CQulv
         QS5DD3LmlrbO/mJ15O0jot0DvvBHcaeFhW7z+biSDf+YGFaitpteHi8SfT0RMrbPqcz0
         QW/uumO4uMKrqQ7Ffx7m3q0VJz6d64orRTVmPchUKPy7pllC64aKSZSsZozlaggH0a+9
         o3j1obGiUkUopsJip/gpWOqjB2/mp52jY+oTz19zwPS+lgyEnnHycY1X2Yz0WBoXXND0
         9mJChZmRgsaO2cyF9Ww3PvuqD/sSqtCnC5kfDXbPJLndGHSWlD4UzM3sR+LwgPTwnYew
         jTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q25PpZzJYl69vPoE9WmxVzLyhHRn/eQiQv/nA2MhMqo=;
        b=iPrp8MJs7mD5fYVWe0nZ37kh4qtni8HzQRtkZE0ZBswwDEEwehC0GYQi4ONPV92Nh6
         uMsaKAQBb68dMxUZzBSzLp8ULV2/C2z4rhCzpK16UW5X7iqn9+sKdI/eHM+pXDVIbONT
         lnUGxWF3z6q1KhR1tdqK6qbWBux7U4a0aiwTQompiXESJDjislqnQYy0rzQtwBOgws3U
         3p8c8zcoH0XURzAtlQN4qmw42wyLSZuYnTBojq9xIVBmD+qHLdMbLYumD3R6m86HTk4q
         6n5WAM9DApTHnn5sg7mk6LDLjYHc44P3j6bJRaUszE88FadP2jYIFyDgrCKqKWUB8jet
         C36A==
X-Gm-Message-State: APjAAAXZA4nDx+oaN/GBkI5l/boylmkJqjU/3+ZwuRNptxywZieFa9qK
        rhtsKO28fXs6jYuCI7YLjmMWlsti1dOjAw==
X-Google-Smtp-Source: APXvYqygobKEe5WfjFziR2sHzdTCAAZcet5MkCGTZRoEaVgbVLJNfaMPKavjmX9yk+wkhO41enkvPg==
X-Received: by 2002:a7b:c148:: with SMTP id z8mr3079238wmi.142.1561637028191;
        Thu, 27 Jun 2019 05:03:48 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 20/30] crypto: rk3288/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:03:04 +0200
Message-Id: <20190627120314.7197-21-ard.biesheuvel@linaro.org>
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
 drivers/crypto/rockchip/rk3288_crypto.h            |  2 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 21 +++++++-------------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 54ee5b3ed9db..18e2b3f29336 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -3,7 +3,7 @@
 #define __RK3288_CRYPTO_H__
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/algapi.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
index 313759521a0f..c4ddabb7bc5e 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -49,15 +49,12 @@ static int rk_aes_setkey(struct crypto_ablkcipher *cipher,
 static int rk_des_setkey(struct crypto_ablkcipher *cipher,
 			 const u8 *key, unsigned int keylen)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
-	struct rk_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
+	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	int err;
 
-	if (!des_ekey(tmp, key) &&
-	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
 
 	ctx->keylen = keylen;
 	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
@@ -68,15 +65,11 @@ static int rk_tdes_setkey(struct crypto_ablkcipher *cipher,
 			  const u8 *key, unsigned int keylen)
 {
 	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(cipher);
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
 
 	ctx->keylen = keylen;
 	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
-- 
2.20.1

