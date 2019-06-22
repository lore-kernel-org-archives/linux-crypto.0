Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AF7C48BE5
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB7E2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v0aeJQDQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfFVAcJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42662 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfFVAcI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so8088118wrl.9
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lrgZUl57nCjRD4Ecxl/6+lhgudAbeMv5YE7gLc7E7NY=;
        b=v0aeJQDQzEzolIu1C+8SuRAoxm8KsfKkkpG6gaiFkGqpDHFQVGOFkWRIXI1riH/hhp
         sM+bIXOCOp0JTKIgobm4WIkRS7fQQWjzMxp/tchGVZGQ0mFnawTQGR1UCfjFibjlNZlT
         D6VLo2SxWMbXdLw1Uxmmqq59I7ATdhUCgyv5LP7lbJvZIe3ZLthPEtuAB5+pJEbjvcW+
         aB9LZIinLgckEBXNh3OsqOKeqppEKZ8O/dVF1Hp8B8lcgh9Q2nPG1UiAjxH/f8qhXo5N
         fk5tGunlH8qIrIvl/iKRQLIRDIfYNI5Uy1NxeEH4vZi1a6+oFFGz9avRwKnlH3lkIlLp
         5fYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lrgZUl57nCjRD4Ecxl/6+lhgudAbeMv5YE7gLc7E7NY=;
        b=ERjXrBv5VANJxjdNd/fjl2nUJy3KvjYWV2l3qvtZGPuEhzXgsZG3uPRMI4OmqH1VCm
         3F2L/U8J14PtZuOUyURxUTNFs1r+LkxkpBTqn8SzwroTiN0LolhM+R3c3wAtmNsnr/Kl
         jKRPQwBZoQEn6roUg5gYg6BDJNwNjyTycKPr3oAcUwxGtZMAKYnYXjI1TweLZezi2OQy
         hD9FN2aZtWvCY1zIgxz61wozv02DLm5fLrj9gmie41UcKDdMQVrnHHGGdFZfb5y6plwT
         uliV+jLZ2gd2/IgHmx662idx3CE6gbJ3FMXswdruC8j95JWEetMZnxvdTxB0BS3kqnZr
         a14w==
X-Gm-Message-State: APjAAAWdhtn/wBQsg5m84XsCVnRGv6ejHtecqf+g5MkWkFn3U03smoQu
        EwAMg/oKdts2wths7mwoPmw5O4XXO3ksUsgj
X-Google-Smtp-Source: APXvYqzYaOvZEjK1mgaqGSBcelh1l0uCUvVFCJvb1Fj/lCvtkjyxN8aOCfG0l4vfZuU6ly7FsigoYQ==
X-Received: by 2002:adf:dd89:: with SMTP id x9mr21011334wrl.7.1561163526321;
        Fri, 21 Jun 2019 17:32:06 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 21/30] crypto: stm32/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:31:03 +0200
Message-Id: <20190622003112.31033-22-ard.biesheuvel@linaro.org>
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
 drivers/crypto/stm32/stm32-cryp.c | 25 +++++++-------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index cddcc97875b2..12473c297060 100644
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
@@ -767,17 +767,11 @@ static int stm32_cryp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				 unsigned int keylen)
 {
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
+	int err;
 
-	if ((crypto_ablkcipher_get_flags(tfm) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) &&
-	    unlikely(!des_ekey(tmp, key))) {
-		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	return stm32_cryp_setkey(tfm, key, keylen);
 }
@@ -785,15 +779,12 @@ static int stm32_cryp_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 				  unsigned int keylen)
 {
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(tfm, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	return stm32_cryp_setkey(tfm, key, keylen);
 }
-- 
2.20.1

