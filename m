Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BF7C5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAC2F2147A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UEN4T0zi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfF1JgE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38530 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF1JgB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so5546955wrs.5
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BBtjv0mX3l20qT+8X4zS6U3CU75NGBuRJ4htuDc2CpI=;
        b=UEN4T0ziMKU+6EBQ1exK9Y/LYpmLXGHDfemNF5GTYMVK0DIj95tqV792DMmD/Q4RrM
         ccYCHnkD0uN7vsl4Hl1CCTc1DG9M3dyxKcvD+oNZxjlBuApAXaw2Xc9A1FRfYVIgIwYB
         4lrQgksi0s7df3SS4If/6llVVFnrjNXK203MboD/+LQWm5OacGxH63J3Bkiag1E9DF19
         0CLvQ5HBjPI4M8/gGFKtrPZGys8JwYtfe1uFN72kiYKWcckjCjJ4nZEnyR2xrhi9vCOu
         UlE5wdd3niYvOsQxcWzGAQFbj3JoxzV8FV7qGg7TpQasGmT07GdysgR1T7U1Aknl62Pp
         mmRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BBtjv0mX3l20qT+8X4zS6U3CU75NGBuRJ4htuDc2CpI=;
        b=PLDMY9i3ONE8FhIShtKp8W8+ObGjpDbuX2uXi7t7T+w5Uv0ZxeMngxLvz1AgkeBCjn
         pYrbks52oE67tmV1+d9hHkq5oQRSPLYgUsUVBHJAwSuLJvoFJ4eKEZ0rXhTzpy0W2bJA
         NKuIpu1KVCXZdbc88yXl/NW/3mzQZhsH6QNM/tILHoA9c6PcJlzUAcH6xbMQ18PsTH4L
         S7wgcHuKSJbyHzeNSnIgrWt11rN8eauFotZF7VG82ls9Cz/PXoIc4XOepF961CmdCXb6
         LTrjA5bPVYsa3k2tQP/d4MPd2TPHWN1fnravrj9JtopIk+2E0xlIxNDLi2NXf1SY3cGI
         qZPA==
X-Gm-Message-State: APjAAAWaNYVcatW3VJTlENHjUrHEQgJCexmTsRhLy6kAvV4NYPrW28Tj
        YZoFMETZaNPxUKQjN9Vt+mGWIK5NuYGdgw==
X-Google-Smtp-Source: APXvYqyal48oF9oi65iTOJAjdtLaKNzYcrlLsqHcaAOoeZwN13XmazcGN2LT1CqO6Lz3NWeLWEt4Vw==
X-Received: by 2002:adf:a55b:: with SMTP id j27mr477097wrb.154.1561714560007;
        Fri, 28 Jun 2019 02:36:00 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 20/30] crypto: rk3288/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:19 +0200
Message-Id: <20190628093529.12281-21-ard.biesheuvel@linaro.org>
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
index 313759521a0f..ef9f192339c7 100644
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
+	if (err)
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
+	if (err)
 		return err;
-	}
 
 	ctx->keylen = keylen;
 	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
-- 
2.20.1

