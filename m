Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB88C32757
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75CF2218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e96FvNtn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbfHOJB5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34574 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJB4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id e8so589724wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+kgpUivqCm6iG3E/0kf20tMpbngNNZjTQte9WULnO08=;
        b=e96FvNtns/NJo1MXRUb+181SdySwSU6p807OfAMxX+rlEgkbWWyuYRTER06B+6i+B+
         vwOlY53Z2GZBOGBmDSRFKuZSEBNkCKiFVweR6/QoxCt31AQlNLlpu8yQ2DqnQhENNcff
         BMWZTnQjUpgX4wDDcXm5GPLvM4k3IZogxlUltvFIjqolA3SIS//yySXU7AltFFF5Fm8M
         3emdZNyOiTZCV3Zw/6Joz36itzKyy769jPDd7cCGvsH7OIC/aCEp9yLJI5vGg+tH3VpJ
         zR3p0KCy3c+P9Ktv7P9Ij2b/4/pPBrWeCHw8QIczj7e6vuGf+fHv9OYKvI1jwky1/vZq
         ec2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+kgpUivqCm6iG3E/0kf20tMpbngNNZjTQte9WULnO08=;
        b=lzlc3u7GkSVk48LpZBRz0JpZBeQ/GOboJdTJyRA834CK13M5wiBTJaMrtl17qrBsWa
         I+bi17Jp3Cmli4AcqXqzmqx+yrgRKQm/UCrlC27S/uSsFQrD0WSpGIa7nJqLQSQVbTlS
         qjAH0+CGy/6x8WUFlKCtNh13jygaXL+OtcNcftLw9f/3jn1J60JIcxeB7qWF/Ynm2GBU
         TmmqD4K7Iw0X3xfmUCI7oENpvLnXaAKnA6wJ4yPj99V0CQMaC7T5RC9ox/KClQ9o6DsO
         Pw6GPZN/TIrU5ZozFtom+s6i6dQ/x6hef+P/bY6wIH5b95h4KgoVj73USAwhuKUgGh8/
         +uWQ==
X-Gm-Message-State: APjAAAWypV3lM7qiE8AQYOYviRNjNLzlNtrTXpAK1NFzRDarJjjNGFv0
        DQu0fDnNBPfCbc4pEZYfMJxPxZb9sAhKcnnJ
X-Google-Smtp-Source: APXvYqxmqzZx7tRSPbUeTabSZvHni5BrcYQPApt2LlkynCL8oySNdPD1aWPRduZ1YgOcmBO17w+Slw==
X-Received: by 2002:a05:600c:114e:: with SMTP id z14mr1594557wmz.161.1565859714739;
        Thu, 15 Aug 2019 02:01:54 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 17/30] crypto: omap/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:59 +0300
Message-Id: <20190815090112.9377-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/omap-des.c | 27 ++++++--------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 484a693122af..b19d7e5d55ec 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -33,7 +33,7 @@
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/algapi.h>
 #include <crypto/engine.h>
 
@@ -650,20 +650,13 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
-	/* Do we need to test against weak key? */
-	if (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-		u32 tmp[DES_EXPKEY_WORDS];
-		int ret = des_ekey(tmp, key);
-
-		if (!ret) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			return -EINVAL;
-		}
-	}
+	err = verify_ablkcipher_des_key(cipher, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -672,20 +665,16 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 }
 
 static int omap_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
-			   unsigned int keylen)
+			    unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
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

