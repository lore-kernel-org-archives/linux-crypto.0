Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A506C32757
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 016A5218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qgtO7cCM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbfHOJCB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53445 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJCB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id 10so680562wmp.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=778hfxXDi1a/ED/3zsXr54rfRhlsz4uqHXQp8Y8p7z0=;
        b=qgtO7cCMgFqe7yoxE5EcOEeZm3bOuxQAXQz8DvCiciHXoXsquLAsfb0y0lIpwHOaI/
         Yqyxe5NtrPX86K6YdD1wSDT/6zzZRbwiDJ1NMmpHow6nP+A2/xINrsTMtalqnFWgP4DA
         YpaxhkV6u5jzxGnT4MBrNDPwDAl774aH5RX+JZeLSle1i4rTHFxYfynypj9GObR6zWFx
         9ZnuV2bVfeK1Fbao6gq3CEjJK9wFSXjKFuivDKSNSvdg9D3SYrEfauK5T3NUVAa6eCSn
         plTLmJNEnNWRFWiKzfJ5saWbt0yV9JHbEF2QkXaotW5iDcH6Qqq3lcCaHhw0KkuOzwX+
         q5Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=778hfxXDi1a/ED/3zsXr54rfRhlsz4uqHXQp8Y8p7z0=;
        b=RX9P5TK6MkvFmr1gbBC6EBuzGasG9htQEn5t8cXOxEb+7f0gzJ0CWRFNNuTBnvYKQS
         cCnSP1FAaMZzM9vVTn76blU0In44Suz6q32TWrX6TAjoGcMOT5l5ytR3mrLqsQBaCyE/
         kZ0jgF+UBdHdhFp6BhMRpPgAgGtWXKVE2ixewGPwuK1bsctnG83A+m3so7h+2cPuV0Li
         q1+rxw1K8a31U284tBSyeiy8Vx4pjJaHvSRNS/sX5/gsub0bv8VoqBPdWAPA+4tx902S
         WSuesl31v7ndIvuZB9Ru2STM8BzUmUzFAHgtHp4udWMDQKf5+EIS2FPrw/4GEx9lOf6f
         /rxQ==
X-Gm-Message-State: APjAAAU6EGxexNV512n2a8Zt5vPrL5Kyn8AkkPTUkoYQi57s3IILsjaI
        CKjN8XX8WjRegnfaGA1q96tKpGUtv8lFx+d5
X-Google-Smtp-Source: APXvYqz4JwPL81MrPLtmw/V9g9UtE9tKCTJ3e+fGxOCQFxDYT96OV4PsyxTXImsWuRx/Fl3rI8rzIQ==
X-Received: by 2002:a1c:3945:: with SMTP id g66mr1620772wma.139.1565859718954;
        Thu, 15 Aug 2019 02:01:58 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 20/30] crypto: rk3288/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:01:02 +0300
Message-Id: <20190815090112.9377-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
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
index 96078aaa2098..d0f4b2d18059 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
@@ -46,15 +46,12 @@ static int rk_aes_setkey(struct crypto_ablkcipher *cipher,
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
+	err = verify_ablkcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
 	ctx->keylen = keylen;
 	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
@@ -65,15 +62,11 @@ static int rk_tdes_setkey(struct crypto_ablkcipher *cipher,
 			  const u8 *key, unsigned int keylen)
 {
 	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = verify_ablkcipher_des3_key(cipher, key);
+	if (err)
 		return err;
-	}
 
 	ctx->keylen = keylen;
 	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
-- 
2.17.1

