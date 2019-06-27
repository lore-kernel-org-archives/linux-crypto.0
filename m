Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41304C48BD9
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 197E6208CB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b1OjzH+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfF0MDl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34914 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfF0MDl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so5427968wml.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0BmAQ2xBY6YvXGaq2o5vjDuCRmHdlrsYW9+Mlp1M+vM=;
        b=b1OjzH+iNBCvpUvpJm9oA8voc14pDPqhn1XM5euaGAbwZnzuDSu0IIQfGaObCMQaUX
         A6H9o4qZ3wAPn17/eb24RZfcRmiO0LV4D9PlSlAwq5OzLHdC71R1pMEE4oXvHbcYTrJc
         aE1BjMvoM+StJfklpMlELp6bopgpWQB3kgQ1v9sp2wtpW8jLgvRlrcCxAQ3kX5f8V83g
         tg4YSioxp6tw6ShbqpIDbQh4T8GU8Rrm/dHbPpXwzsFnVw/1eAnpYX9KewEH8y9SN6zS
         fa98+B/yssJ6gffgvzqtffu1g4unzVXJDeo72QZ6L7PGM6IjTR7RNrZe2ZIS5udMfUJx
         ozZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0BmAQ2xBY6YvXGaq2o5vjDuCRmHdlrsYW9+Mlp1M+vM=;
        b=g9vhulc3bIHyOXYoSm5CIQmA4ZZxAALVnNtkoLs7WT3lGc5BbsSOGmm8M6Yfp5Uwd+
         6fZVw+XjRSR8ESgaJ+XXZPJhCz1kh+rdU9ZJeci0R64R/UD0++zacD5ftGEsg2o+Symc
         SODnclen7iZFlFD2Kblg5oOuZWaO30fN9pdeuDJvFioSkK4+e02cOi+H/0W+yGvfEgrJ
         joFlTSL8DflvNijKGlbSDI/limYMdRfEdcGZwclbeM6G0gLK5zHijl9Wpj3X3GgY0wEz
         xHqYKPrFqhhH7D0GPYzC/KnLHRrxmS3VPVW8Dmu+i38nR7m13BJEQbsCQ0OIfliEdzc5
         PyyA==
X-Gm-Message-State: APjAAAVeeQHTb1yxSb7yU9Vtcv13WKsYl6lWR75iL7JSfTqYHSKCX3cE
        WAJyglcwoj3mVJpeY08xy5S6f96Unoj0cA==
X-Google-Smtp-Source: APXvYqxVh8KTmbqEQh/BUZ2fGdYGVfNFkXq+ZUKdOUcpbJ6voCHp6M+ds2j4C+5guQnQMQyT1rAdtw==
X-Received: by 2002:a05:600c:20c3:: with SMTP id y3mr3136453wmm.3.1561637018471;
        Thu, 27 Jun 2019 05:03:38 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 11/30] crypto: hifn/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:55 +0200
Message-Id: <20190627120314.7197-12-ard.biesheuvel@linaro.org>
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
 drivers/crypto/hifn_795x.c | 30 +++++---------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index d656be0a142b..000477e4a429 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -30,7 +30,7 @@
 #include <linux/ktime.h>
 
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 static char hifn_pll_ref[sizeof("extNNN")] = "ext";
 module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
@@ -1948,25 +1948,13 @@ static void hifn_flush(struct hifn_device *dev)
 static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		unsigned int len)
 {
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct hifn_context *ctx = crypto_tfm_ctx(tfm);
 	struct hifn_device *dev = ctx->dev;
+	int err;
 
-	if (len > HIFN_MAX_CRYPT_KEY_LENGTH) {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -1;
-	}
-
-	if (len == HIFN_DES_KEY_LENGTH) {
-		u32 tmp[DES_EXPKEY_WORDS];
-		int ret = des_ekey(tmp, key);
-
-		if (unlikely(ret == 0) &&
-		    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			return -EINVAL;
-		}
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
+		return err;
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
@@ -1981,15 +1969,11 @@ static int hifn_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 {
 	struct hifn_context *ctx = crypto_ablkcipher_ctx(cipher);
 	struct hifn_device *dev = ctx->dev;
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
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
-- 
2.20.1

