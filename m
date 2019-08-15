Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E6AC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68754218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hVqmOF1q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbfHOJCJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33096 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730812AbfHOJCI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so592734wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sFD6/mvXD8MMx71MGNXO6jdjD0BYk/bg6JkcVmcj0vo=;
        b=hVqmOF1qu+II6tfY1zd1ybrlI9y2D9MSn93KwiDis2+WcuqorSMuQtbT1uLXWF3TIO
         e2f9UbNNN4WVMhtOV9Xd/mhOCZjDv3x5kPi2cMnC+WlBr4V1OlPerlxr1vkX4H7cdHAH
         1qzgZdatL4CXvv/pPEypzuKNjz51GVpMtg7uBndVdD3yz9KAoARJZYebXFqZMboO5+wM
         kYffU97K8UeQ4f+t0HxaB2g1AA4WLunEY73296dOIoWAQuVfIwy3DTm8g6wOHnJTC9Az
         q5WT+eJVRmnh+tpyCIbqfx4KRzaCEPMzOkdfmQgWBcoGXywsYKF+HkNfx9jAPVgR09bQ
         Zv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sFD6/mvXD8MMx71MGNXO6jdjD0BYk/bg6JkcVmcj0vo=;
        b=pCJMZa+eBWLVDu0YmOTYM32Mxw/9hcfr87FmgPLzAvwOyN7R+i+7xe6rK6lm/0Z7Sa
         bSSqoLPeJUFqKkz1VxvN+5cbnhMGTJyYZdAqH7SOCYteNx9y4OvLtFQzfI5VOACDgPpM
         3UCy2UKWotT/tohrrUuvYZO//ob8tvq7h1B0V5m+OaCIT+IpnfUZOTk1blK38UDIwdHm
         qzhf8CK9aJHIglbQgU/jKcDpBfzwSvJOqjBhLkg2rFpERJcz9HhfA5chK9dHLlJiynYj
         gHccpmj5dx9pBIYhKtzM+hlB5Kvn9zvqfhvbdVD7wXDCJpdH77g0X4vDXsg21UOB5LZn
         oSaA==
X-Gm-Message-State: APjAAAVFbTn7M3nTWu7NxeJ24iMouygLOOJpzeQcddxxgCSwIg0CPWSS
        GdXqYRY7YW3clgo635FRSV5zoW/MJHpzIbe1
X-Google-Smtp-Source: APXvYqxquWw4FVMVvxYHppGDQTV3jKOx0uQdaNWsr4EeKwdirMm3bBitrPPLa/sJjj72xAPxwHlQGw==
X-Received: by 2002:a1c:b146:: with SMTP id a67mr1689392wmf.124.1565859726346;
        Thu, 15 Aug 2019 02:02:06 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 24/30] crypto: ux500/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:01:06 +0300
Message-Id: <20190815090112.9377-25-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 31 +++++---------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index b4beb54c0dbe..e966e9a64501 100644
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
+	err = verify_ablkcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -1019,17 +1006,13 @@ static int des3_ablkcipher_setkey(struct crypto_ablkcipher *cipher,
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
+	err = verify_ablkcipher_des3_key(cipher, key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.17.1

