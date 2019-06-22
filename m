Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4EBC48BE0
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516C62084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DqneX8HO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfFVAcJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38482 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfFVAcJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so8083011wmj.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FrBLYeLtuiaLDwgJn1TkWrukHdAbPf9Wo3+1MqcyfMY=;
        b=DqneX8HOgoQO2mD6QMWQn5DHaaqbsINCgJSEvBBaKHkLw4oRa3I1nLUayrw1Dubc6h
         5gUzeE63x8jZItdisVKTTO8CWBLYjuP/VH5JEeLv1r0QIhPvN7K+LKaDkGJ8VH4bl4Rx
         hQhTl26a9A7k9RKExhtIGTQM9nLeNaFpipvD2HUFslu+0JvjcltPcPZnJ8zaFHTffhE5
         W7J+VN4rqF3kPB0aXqFZThpeYggHOdLoCM+RtbWQlJmGXBTY3IT/AWZRHGRkI4bk31QV
         +Wm/1H1fzlrhYKzrs/ymUh5sxcOPvLcXGpgYuRXFHaK/1LzdkXBqLZuMfe9D3HsZFeiy
         uWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FrBLYeLtuiaLDwgJn1TkWrukHdAbPf9Wo3+1MqcyfMY=;
        b=RMOCwSKyz5K1ecd0OiZsX4yHnw8dszpikXb6GClYLshD/vhEk1l0KtCgqWXpDiL7Dl
         C0EnBCI1Ih+3fLkOiSKMEgFv1GBJhYvyTG0bQ8Od2m2f6nwn9SnWp9PDHvvjvSQB+6mh
         srInEJ8HdQDnKVvmzU0BXWf2JPwY8kHCjMHB5lfMUgAFutzj40Twg2K23Z0qjnoUn3fz
         Hw3fkULOdjSXNsMVGRAb4dPgQ34JsW4Kntu6dkpksVpPS2ICD4wOTbwmTteZElDUqBRy
         8T/3aI9gpBEVBrejUTbIrYuMKzeQ/pC27qeaXAgBmBmUgYRbLPDiO4ccQnEhNaZyLQZh
         GdLA==
X-Gm-Message-State: APjAAAVKEkH6USUUToISsmM0eY3rDtJZlnmon/e9rFp/6x9sv9bUm3JZ
        CE+M2qdaLf3CqG35hefPMdcKHCKSz8KR54kx
X-Google-Smtp-Source: APXvYqwYCpb2wO1+oLbUReu6OUp+xpshuUiOJ3+6oZqvxYdqGfIEEF5WuojzmNYQ/geyClR+cdJKKg==
X-Received: by 2002:a1c:f515:: with SMTP id t21mr5946128wmh.39.1561163527346;
        Fri, 21 Jun 2019 17:32:07 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:06 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 22/30] crypto: sun4i/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:31:04 +0200
Message-Id: <20190622003112.31033-23-ard.biesheuvel@linaro.org>
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
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 22 ++++----------------
 drivers/crypto/sunxi-ss/sun4i-ss.h        |  2 +-
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index b060a0810934..05b2b2136743 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -533,25 +533,11 @@ int sun4i_ss_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
-	struct sun4i_ss_ctx *ss = op->ss;
-	u32 flags;
-	u32 tmp[DES_EXPKEY_WORDS];
 	int ret;
 
-	if (unlikely(keylen != DES_KEY_SIZE)) {
-		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
-
-	flags = crypto_skcipher_get_flags(tfm);
-
-	ret = des_ekey(tmp, key);
-	if (unlikely(!ret) && (flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		dev_dbg(ss->dev, "Weak key %u\n", keylen);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_skcipher_tfm(tfm), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	op->keylen = keylen;
 	memcpy(op->key, key, keylen);
@@ -569,7 +555,7 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = des3_verify_key(tfm, key);
+	err = crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key, keylen);
 	if (unlikely(err))
 		return err;
 
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index 8c4ec9e93565..3c62624d8faa 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -30,7 +30,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/internal/rng.h>
 #include <crypto/rng.h>
 
-- 
2.20.1

