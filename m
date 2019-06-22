Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F980C4646B
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55BB52084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZmbmJll2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfFVAcL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36798 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfFVAcL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so6915692wrs.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+sdt/3gJ4yj04TA6LoWxsEfYMxca+n+KFCJfOd7D3AQ=;
        b=ZmbmJll21x+q8cTsz00X56alzpx01OH6084Y11pxU0bcdWi1u9FYSgaGlfpsLkgatp
         LdSM/x7tS/qyYoJseoB95llS9+HHMA1ehsiJAgOIXNrk24jjtJJ1Oe3Ymefgxnhf0AZC
         Kfiuga+35cFFXSv1Kn9yadUc7Kgd5wAZsKNybkMg/rnVXWrezfG55CIfdSbrtycqWDnp
         l57E+yDkTkygoHOBjnvKwbvDhh0VCsCAIvtAUPzS2R+/zyFBMbQFXwhj3vQzLjKJvAUc
         8cODyBNtmAlacBgesrjoDpGjXdyUUDDBtA+IH+lmkWoDh3v4t3yNy8PbIWgLuMagkhAI
         lSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+sdt/3gJ4yj04TA6LoWxsEfYMxca+n+KFCJfOd7D3AQ=;
        b=tQt6wdGebDR0n2gIoiCbq4RwAbBhDO1dIaVQU11O2lTjoUsajfXxFiAVOMW5mvNcI5
         +w9jnV5G/8qDmdQi273HTxqIrx2WRzVGX1DyioYDr2UwqBwE5sZEiCtlPT0HL0DPEzTW
         +vzyulFAjdSD6YNP8zoVbZKs+B1Up6GCxpyVeRVOfwWUPlQXV8qditygL6wyGB9uzmao
         aVOVOcl0X8//vqBs6u5Xdh8NgTdWWYIRqXsvrdF9x8Rt1fQEtM2MF7PopxCZ9fuKgBQW
         nIbs8Gvc1CpKWPktwoqAn1Jx7XENKIkW5Oorj7IiHPsCyAX6DoJM+f8HnEgMmn5ocNbT
         zpQA==
X-Gm-Message-State: APjAAAWBbYk6YN3m2P/wm9LAOxSkmz8svfHhood0U/fl3mRNyGh2EJXO
        sgIkaDrN+MocA35T+m3ctqvpl6RkR7Ty/yx7
X-Google-Smtp-Source: APXvYqxPx8UaMi1gAbRWnKLmoL3SNi2TEloqGYPiQCEArQPdzpfZ5sBE3Hbwy9KXWLS0J/fN9hM9+Q==
X-Received: by 2002:a5d:6243:: with SMTP id m3mr5058729wrv.41.1561163529444;
        Fri, 21 Jun 2019 17:32:09 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 24/30] crypto: ux500/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:31:06 +0200
Message-Id: <20190622003112.31033-25-ard.biesheuvel@linaro.org>
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
 drivers/crypto/ux500/cryp/cryp_core.c | 32 +++++---------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 7a93cba0877f..9342e8e6398b 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -29,7 +29,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/scatterwalk.h>
 
 #include <linux/platform_data/crypto-ux500.h>
@@ -987,26 +987,13 @@ static int des_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 				 const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 *flags = &cipher->base.crt_flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
+	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
-	if (keylen != DES_KEY_SIZE) {
-		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_BAD_KEY_LEN",
-				__func__);
-		return -EINVAL;
-	}
 
-	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) &&
-	    (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		pr_debug(DEV_DBG_NAME " [%s]: CRYPTO_TFM_RES_WEAK_KEY",
-			 __func__);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -1019,17 +1006,14 @@ static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 				  const u8 *key, unsigned int keylen)
 {
 	struct cryp_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
 	pr_debug(DEV_DBG_NAME " [%s]", __func__);
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.20.1

