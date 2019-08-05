Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87888C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B8712054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ts7v1viZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfHERCI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39334 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so63359138wmc.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wfAyMSI+isugVytbOn9ACte5k7G1Dq3BijffxGwub4E=;
        b=Ts7v1viZxWFV0xstSX05mcvYZM/jVEHylW+yNIedZVv8Up56sI/xkesfTrKWtdnWvg
         LRZHulRy/K0KI7zZ/OtiZcWjdxtimzKtFfJFQHekltcErF1w+zTn+BEz9plQrQsJ2r8O
         vo6jIsjziYhPBJXHPqSDdSFcVyfv76S0mGhyxBU+eddUI6VRZRfzjWU2A1fw6jpeAB3r
         IUqJ2zpMOz6Ssgz/tkGMX9b4eci57MMGDNkzFlRce5MpgmI0WlmwTlPwsySYfJOXlKtp
         F30UpMbK1bxe63oh4Fpwv2/EfU/YPkWoJzHwo94zAQJqHbJqu2u8ZmZN5zYa5bDq9m45
         BD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wfAyMSI+isugVytbOn9ACte5k7G1Dq3BijffxGwub4E=;
        b=khvBW8PuaOytXJanNeMnOSva21blFRaQXcx5uN4Vt1USft9lKDNG0CnrMotvunL+sM
         J+G7p7GuOBjQb4omUU788Bw8pXW9C6W2ElFyokvIot7w2buGBGDPm8JRh0C3rTprwDpr
         YsxLvOEU3AHx/4X4uC4TnIfTJvXLLfei+p80OTRxCyjt9LsuIbs17pZqqnH3JD8Xc9En
         sy8XHfxzA/Budz7Q3LVaMcT1ZgdgWHwkkKxkin8ueSMqDxOlmkgrNeXSRjTaoMVmhkBy
         Ici64MMQqPdxthS41YdRCMd1nWOw7DJSEKXqeDpE7OJyss8tfe5W9S5tfe/CCFqTnaTu
         WGUQ==
X-Gm-Message-State: APjAAAV+nYINglTmrl24hYpeNdrcNNoBfXXh0rwH0jQzHvdJFRcFjvtp
        0pj4EfFJnv+7Mngjb7xUJNCazPfR1P69/A==
X-Google-Smtp-Source: APXvYqx2v+zIWsTcEZYtStq1bN4rSY8C8ZFlt+iK0XQDAui8qdWm25LGuziNeBX18uV8ro1iQlzCSQ==
X-Received: by 2002:a7b:c745:: with SMTP id w5mr19157602wmk.21.1565024525494;
        Mon, 05 Aug 2019 10:02:05 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:04 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 20/30] crypto: rk3288/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:27 +0300
Message-Id: <20190805170037.31330-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
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
index 96078aaa2098..ec84c2374b90 100644
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
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
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
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	ctx->keylen = keylen;
 	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
-- 
2.17.1

