Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B48C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E4F2054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X1UdoxMP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfHERCK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39339 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so63359296wmc.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9oZqlT+Ip3tp7/dloqkra7bobLN3ro1GYng6jmL31Tk=;
        b=X1UdoxMP1PP7LGTgUczoAeG0wCY3NO6KnJO8Z67dvA4HZCTI1G2Tiv/dk7bhcssspG
         NY8nhJTVfzG8FM9WKP9ZO/r1nKm1pzdlCb1k+uZ/yeebtohCL5e16MQ2TDY0DB82DZJc
         RLNMBij2B38h/eau5N5tUDvdNGJr+ZeQyngGtnZvWJGtCpmR7UnuNBApPhU6IrSGOd2s
         sAftOqM6iX7TrO4T9vAmYb3DaImdtibk5g6lsDUhAtGc2xFjI/ihnsHCo6wWSbPNNn1u
         iBK8MnMGLf5C13mcZKduTL6R96ksXSCfiAbH5J6j8wy3j3Ef4aYJOwMoPSOlJhvRrYGQ
         qCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9oZqlT+Ip3tp7/dloqkra7bobLN3ro1GYng6jmL31Tk=;
        b=BOPnYhIhiDleC7srpTyHEPnberPWXQB0cqPJ1K6+NFb4kYFtagKCCLWDZuEoBR+mMc
         TWcvJPEtYMxF36K1/l1glbgOb03KjJYYVPkmAZg64tKXTnxKyDPTeSDF7ahz5atVon8t
         C9KGjm+0UiPsDPujqt0rDzNrgVlSLD2xB0B75AJRfIkyIV6LCz4eLvpMI5SFGKFZdI97
         tVuuwAsNnk/3HB42iqFZOvAtHMyWtqVizdTa7wdVOZ5ONbQX2A2eIY9MiotrIHh5S4hm
         0G3NU4D3+LfmYBTfMIV57bCS8PmwdDrR+NmqytPVZZWW3WHkFBHWVHPyX9fzKpesDD3/
         NJgA==
X-Gm-Message-State: APjAAAVIh4mNNTGwyzkVcQf2YnS6cEvZUAtgILJ7wxrfsOYnz25PLnUE
        xledb/Hoooy4arR2SUNXCqRNzeUNGwV64A==
X-Google-Smtp-Source: APXvYqwLjTJ9uSr2yPhYyU/n5NMZrMnXa39lvtvSGmA0y1KQVPhW5otOyP7simbfoUeMFpLUmnnU9g==
X-Received: by 2002:a7b:c7cb:: with SMTP id z11mr17846582wmk.24.1565024528609;
        Mon, 05 Aug 2019 10:02:08 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:07 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 21/30] crypto: stm32/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:28 +0300
Message-Id: <20190805170037.31330-22-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 30 ++++----------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 98ae02826e8f..a704b1d38436 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -15,7 +15,7 @@
 #include <linux/reset.h>
 
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/engine.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
@@ -767,35 +767,15 @@ static int stm32_cryp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				 unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	if ((crypto_ablkcipher_get_flags(tfm) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    unlikely(!des_ekey(tmp, key))) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
-
-	return stm32_cryp_setkey(tfm, key, keylen);
+	return crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key) ?:
+	       stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				  unsigned int keylen)
 {
-	u32 flags;
-	int err;
-
-	flags = crypto_ablkcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(tfm, flags);
-		return err;
-	}
-
-	return stm32_cryp_setkey(tfm, key, keylen);
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key) ?:
+	       stm32_cryp_setkey(tfm, key, keylen);
 }
 
 static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8 *key,
-- 
2.17.1

