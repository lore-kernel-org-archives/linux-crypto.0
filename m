Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE115C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B248120665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BtHuZ18E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfF1Jfw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35013 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jfw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id f15so5564750wrp.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q5518Fu0qbEYULyTPyyJZ5MNF13pn8CvciS2tOCCXSU=;
        b=BtHuZ18EzYN3SILXl9LvM0f7VRwtGKe4rW+9i4aVHuFqG4pcyzhfOVDIS8CVHbMMOq
         kfvOPlmSVMUgCnFXIOTWFutPGlOLE3gaaWYItJvAL9u34HzuqbCTE+DBG0TvzW4FfYJW
         tjOxaXVgL7AoDQwZI8RxVe/cav2o4TTQWn2kqV092roTeLrtCQuY0LWyAYs9x1W+wWCX
         O0qqkY/ISJh2K5p+AI9ZEr6um0oF6oRiOxSqEoIp6Vous/dyBGVIP/dPZjVRTzl5F5su
         zQNwgGFhR5bSjfQdFlqVprBJ6g35zAB0IgmWKEEn6tuDNd5nDkBOdwdUQxCapQyWmhE0
         QHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q5518Fu0qbEYULyTPyyJZ5MNF13pn8CvciS2tOCCXSU=;
        b=baGSQPkn/GTuhigl24nuWiPQgmS4Cr/scdBbz+dI20qJ3nccYgu9oXnMuoZyXXlzkT
         sIFp4kz6gXVyIDnM8BRbf2iPHmv1nt6irwCBIplDpQvn2c3beoQ+OYMFm0Sgoc6LMa0W
         BcLMbgK/dbLtobfHwL4zftsQMA9LPIlp7/OFR+nqkRGCd76zRl9grJPrGyBkQjG67Wva
         8vQAUmnQ+crmKUF8vOHqFsj+rwJa2h/sJY3ivh+0UkAhIQFXo6dVghSsi+CBqr0bT06Y
         hfPzrtmJKVKAxJoq1ykvjtXXwxPThAnG1BT8MnQbUtZazCYRoZVkH2g8es2xrTLJrksj
         yosA==
X-Gm-Message-State: APjAAAWICZ/KmUA8zwr+cY6X7Lggn8Smcc17vE/QZocBXkXUzboK8tyH
        tIUzwf/rYMolnawgUIqEpurhhVXjf8mZcg==
X-Google-Smtp-Source: APXvYqxbpGqcGLQWChBd0jxI8y+TAQ3F7gClab48u78vyxWyDz3qR6zkH8WWmSpOJ12Ut4Y0qk14oA==
X-Received: by 2002:adf:a305:: with SMTP id c5mr6915355wrb.29.1561714550294;
        Fri, 28 Jun 2019 02:35:50 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 11/30] crypto: hifn/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:10 +0200
Message-Id: <20190628093529.12281-12-ard.biesheuvel@linaro.org>
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
 drivers/crypto/hifn_795x.c | 29 +++++---------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index d656be0a142b..5a86d0cf9070 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -30,7 +30,7 @@
 #include <linux/ktime.h>
 
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 static char hifn_pll_ref[sizeof("extNNN")] = "ext";
 module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
@@ -1951,22 +1951,11 @@ static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
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
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
@@ -1981,15 +1970,11 @@ static int hifn_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
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
+	if (err)
 		return err;
-	}
 
 	dev->flags &= ~HIFN_FLAG_OLD_KEY;
 
-- 
2.20.1

