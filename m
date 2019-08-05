Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B5FC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A0D72147A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="unGbFAsL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfHERBy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51826 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729765AbfHERBx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so75474189wma.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HxDFvWt3ENFa7ihAescSzZPGut8ewm6FCVY9y62ZOIM=;
        b=unGbFAsLk108V04tov9lOxG8yXySP3JkDWYvyvReB7oiwev5ujlcxO7enHCDq3G61K
         NwKe+LhPMmp+Cvs8DajN/kWA/DRtn2dic5ZmXo4oxxjh2WZoKiZdNPuOR61I2q91nBHq
         Wi5erpP3Ok6IYvGdBKJBsSdsdY2EvjLX5Dd9p6UJMXnf3/84N7L6eDBwcfpWVaEWUZrd
         AKnb00/57/+3AdbJ1c7lItY+g0NYS3AYsAaU36DjWNu4ORK+uG5Zl6JhTHY83M9rl64t
         fAVe7NXilIMF98OFeDwNqTAwarqixHmZEX/43WM8Mxm96QTI5YppQ1dlNpxmsp5HKdR9
         eKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HxDFvWt3ENFa7ihAescSzZPGut8ewm6FCVY9y62ZOIM=;
        b=CRIhas4bYc1L+HkLYhLy7uISZWtpwI1nbDScK/Ovc+aI9PtPM3cRBTwgHA7PGOkZ+D
         OZwmXeNzB8pQhtmuK0JBpz53hgxbUKycfQzbaSxyyttanV8fXUXjTPy8KSG7oP0J7xGQ
         jNkkY0EI21Dea/V/qZKZH2e2CruCPz8uVYE3k7fJNjHY/4dBoyVTy2ogt9PpIMBgPoHU
         hIZSN0PtxBX3ZAsUkgL5ZcRDzoC2b0WlfGwWiX/h0mRYpz95MBPTxjAnZ9dQ1gSE3iBH
         RVhrV/7lIIwlP6VdDcTp4BSveVh/FI0V30OaxRCUKj9zZselOTyvVv5bWm9FF2XtEDeQ
         6xsQ==
X-Gm-Message-State: APjAAAWr6Ltooe1JHTgsmz1EGYhM+NowUtvKIKCv4Ezhzc/kVKqcVnet
        zNqfBnrO78uMC+b07tnLNKGxSXP401iaUQ==
X-Google-Smtp-Source: APXvYqzOS5FkCY4CywFt0HeAY+5fkIXNZZURoK6w/s+fbaXra20CmrHqPCkvVp0cojhzXsmqrSbM6g==
X-Received: by 2002:a1c:a8d7:: with SMTP id r206mr19757735wme.47.1565024510809;
        Mon, 05 Aug 2019 10:01:50 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 14/30] crypto: ixp4xx/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:21 +0300
Message-Id: <20190805170037.31330-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ixp4xx_crypto.c | 28 +++++++-------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index acedafe3fa98..d3d683107050 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -17,7 +17,7 @@
 #include <linux/module.h>
 
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/aes.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
@@ -756,10 +756,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 		}
 		cipher_cfg |= keylen_cfg;
 	} else {
-		u32 tmp[DES_EXPKEY_WORDS];
-		if (des_ekey(tmp, key) == 0) {
-			*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		}
+		crypto_des_verify_key(tfm, key, key_len);
 	}
 	/* write cfg word to cryptinfo */
 	*(u32*)cinfo = cpu_to_be32(cipher_cfg);
@@ -851,14 +848,8 @@ static int ablk_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int ablk_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			    unsigned int key_len)
 {
-	u32 flags = crypto_ablkcipher_get_flags(tfm);
-	int err;
-
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err))
-		crypto_ablkcipher_set_flags(tfm, flags);
-
-	return ablk_setkey(tfm, key, key_len);
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key) ?:
+	       ablk_setkey(tfm, key, key_len);
 }
 
 static int ablk_rfc3686_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -1181,7 +1172,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
-	u32 flags = CRYPTO_TFM_RES_BAD_KEY_LEN;
 	struct crypto_authenc_keys keys;
 	int err;
 
@@ -1193,12 +1183,13 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (keys.authkeylen > sizeof(ctx->authkey))
 		goto badkey;
 
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE) {
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		goto badkey;
+	}
 
-	flags = crypto_aead_get_flags(tfm);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey);
+	if (err)
 		goto badkey;
 
 	memcpy(ctx->authkey, keys.authkey, keys.authkeylen);
@@ -1209,7 +1200,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_setup(tfm, crypto_aead_authsize(tfm));
 badkey:
-	crypto_aead_set_flags(tfm, flags);
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
 }
-- 
2.17.1

