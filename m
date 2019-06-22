Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EE0C48BE3
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D4020881
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h6drCIm9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfFVAcC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36734 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfFVAcA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so8098340wmm.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7F5RsJkfhfCqxXQ3FuUN7mpglFHFhmO5SknpRKUDDDg=;
        b=h6drCIm9lg+tvttAr95UWZKBo2HwuwNEi6WN4wEwRTWeAd/wcXknaXvXOrt2fvKSz8
         WX60sznO5UJbVgwbjZXav3x029fq2hCUjPDT/YwPscUYFqGaFyAXx/Y+G8Tl9jnzZ8be
         X5lgn9jrcEeEs2mBP270kP5/6H9qOf+IwizawD79M66okiJY78ZFDOScH7TiE0nqJHKk
         t6MCOhkuQyFdBpzDlDpTfQQLCXuiy7nCytgjf9Ls0gvtgcgaz2sr5VA2hdLSXu0H+wZL
         byV8Lv8TzqZE3NCp2wLWPmG5kqJ107GIRG1bx/p/N6guGPMhiAlq3Ubr2WzOe7biN28e
         GBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7F5RsJkfhfCqxXQ3FuUN7mpglFHFhmO5SknpRKUDDDg=;
        b=mN+3UAUoayftujdzPGLJblLtAEHI5DHrqlYzKfuTKEzje/4sLKb4i7ISPp0AzhQAiY
         pm3yiGHBNNrtQZEiQKKXuVRhoSqjiy0tsmB2ZS31r6fo2Hfb6+a3B/+zCEqxF5d3/2Bs
         U7HaFHpkj1YuzsHqpEcqzHbIDKRRgOsKygE9FKgwxL7nV2hz543CIZz13Sd9IuR2NChY
         Xme/j9INTG+mX/aG0VnbrB20b04p9UtOpcasEkyWVhpDPiMwlvcOpVCji43ykU7Joaxp
         3vA43TfWF2+dqoEaVewHIlmp67lvIfD0tGExVDqZgKBn+vQDWLRmn5PVJ8XDR/ETKgGm
         bSRA==
X-Gm-Message-State: APjAAAVaOW0SMNnw9EJsv48Y/wNLO3t93O/ALll+lFHpBND96FrZII6l
        9BQoU9b/TMCtTX+L+kb/zJGZRDBm/Iuov114
X-Google-Smtp-Source: APXvYqwExDWGtv1CkJa91p8WbiH56MDj4r4+7abZVTRx5Pg0xBFAIJ6GP9qlgc2HpsETDhJfuBgYCA==
X-Received: by 2002:a1c:c003:: with SMTP id q3mr5610542wmf.42.1561163518975;
        Fri, 21 Jun 2019 17:31:58 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 14/30] crypto: ixp4xx/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:56 +0200
Message-Id: <20190622003112.31033-15-ard.biesheuvel@linaro.org>
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
 drivers/crypto/ixp4xx_crypto.c | 22 +++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 3f40be34ac95..e3bc61eb873d 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -21,7 +21,7 @@
 #include <linux/module.h>
 
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/aes.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
@@ -760,10 +760,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 		}
 		cipher_cfg |= keylen_cfg;
 	} else {
-		u32 tmp[DES_EXPKEY_WORDS];
-		if (des_ekey(tmp, key) == 0) {
-			*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		}
+		des_verify_key(tfm, key, key_len);
 	}
 	/* write cfg word to cryptinfo */
 	*(u32*)cinfo = cpu_to_be32(cipher_cfg);
@@ -855,12 +852,12 @@ static int ablk_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int ablk_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			    unsigned int key_len)
 {
-	u32 flags = crypto_ablkcipher_get_flags(tfm);
 	int err;
 
-	err = __des3_verify_key(&flags, key);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key,
+					 keylen);
 	if (unlikely(err))
-		crypto_ablkcipher_set_flags(tfm, flags);
+		return err;
 
 	return ablk_setkey(tfm, key, key_len);
 }
@@ -1185,7 +1182,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
-	u32 flags = CRYPTO_TFM_RES_BAD_KEY_LEN;
 	struct crypto_authenc_keys keys;
 	int err;
 
@@ -1197,11 +1193,8 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (keys.authkeylen > sizeof(ctx->authkey))
 		goto badkey;
 
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(tfm);
-	err = __des3_verify_key(&flags, keys.enckey);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey,
+					 keys.enckeylen);
 	if (unlikely(err))
 		goto badkey;
 
@@ -1213,7 +1206,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_setup(tfm, crypto_aead_authsize(tfm));
 badkey:
-	crypto_aead_set_flags(tfm, flags);
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
 }
-- 
2.20.1

