Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1C8C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61C9E2054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o4WRoOJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfHERCT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41328 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so81915793wrm.8
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SK3G8mftmBkSyQQ38QCarXxu9hLxdoWAD1b59wF92Zg=;
        b=o4WRoOJ8Uwn4tZuh2mtviMkMtPpXMeYPQcz9zx4O4FJdwIcf4G7bilSJf91U4KRLJX
         qP8yzH+dsSxQKK6+OaY9lhngFyWoznx73Svpmo3BX6Fqgnas3qpeuF5cbnVPrt2FzB7c
         jSg55l5bIr9Yt2nuWYcLIjle4w/lqQjHHrnmQkc1SbaaTB3jjBya2IAU/E7KdpRuMjcU
         LOtRmy+1q/MearQ326eNUN198w5wR3UXpWgqgOespSLXKiLqvJ915Qy3xXdiXM0uIw0X
         fQ2SIWNJMce07raJKku08P8h/T7wV2xIZi9jBxIAQBYnZdSxnGhZwBOuURS3yxrqZCK+
         FRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SK3G8mftmBkSyQQ38QCarXxu9hLxdoWAD1b59wF92Zg=;
        b=Jlb9MCGit9p3bYAUYVL5eicpx4SF4C+7eu9aDlJmThPUNgWzosgJHDYXtSJral4BGt
         /oI//6TCwpkfJtDA0JueLDPWb1OqVk2i32tKdqVTMikD7qcXkoaMlULbCJWtWBMXUtz1
         9kOGKELxhFdZrLbZp/YltJK1ymsdQShlJQyfhNgvImk6SqK6OugNCKeEsJU75TwGqAT6
         UWRCk4iZ6+D7GJHLUonqrSSbtQq7BQdatjM6cDseOjGuThl+04Sume+S8lMNr+Nt+DZr
         ZskI+zCnPH6a6BLt7a914IcB1RWe/oEUYYzXKlLZo22xN7gsleVoXtLzrD7F4cGRrBoO
         wvIQ==
X-Gm-Message-State: APjAAAXI2Yil/Y6s9lfL0vggaAiEDMXT5LOrLusWSxwgcTfNYhLzGMJo
        0TskKhAv8xazyBNTfCiddEJ4ppTz41HweQ==
X-Google-Smtp-Source: APXvYqwTSAJ03u0y5QIvKiY5Tz16o7SbtLtpWlZhCFxP/SB1iboUBdr3WeogJK3RV9EvsYRbEgzsJg==
X-Received: by 2002:adf:e343:: with SMTP id n3mr125259033wrj.103.1565024536548;
        Mon, 05 Aug 2019 10:02:16 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 24/30] crypto: ux500/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:31 +0300
Message-Id: <20190805170037.31330-25-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 31 +++++---------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index b4beb54c0dbe..34fe3f36804c 100644
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
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
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
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.17.1

