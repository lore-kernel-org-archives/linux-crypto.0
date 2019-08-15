Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C7FC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00ED5218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r5tONMdJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfHOJBv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40060 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730793AbfHOJBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:51 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so674327wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YDi2S78kIoJe4bcEd09atrBhNAeLpe4eGoRIgiaftJs=;
        b=r5tONMdJ0NxxlvsctrofXLbL0C4JjABzo02ffFe+aDQ/6b1crHkcbt5r+vgPoVIYv9
         O8v0i//+SXVjgwBrX94dNLYvXlnlfdjpeVRGLxFOGtmy+WK937HWR4glJhYX2nrGtga1
         T/vAnfKuO142T0CXMVPRJOui+PtjmYcu56b+HpkyFjcfQCaji+1p0kpus2WApT7dMQV6
         vDmqwnwfc6TFZRqe8Upl7aDtua53zfgO5Luh05KKAPHXL3u66pk55poIkFtXwy4CpmbH
         nL085NI7y7kiCM4lZiJdX4GAawOKd81/eJW0OM+IB4BRNJVOEnPxGfV4ekbrXoq+fXSK
         iWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YDi2S78kIoJe4bcEd09atrBhNAeLpe4eGoRIgiaftJs=;
        b=ryU4N1e9LZpqocvrADxT986gb5VNUr1WSR1aoBGq4/JQ8+7bcNpcOMHCgoE1xbZmjW
         MzbbbCq/TV6ZRlmVDSKwFi0O0u/yuuipoYNpSVpEvCpQXgpsnWP3rO8yRolSezkDWqlh
         9h+/bKSbWYqGQHnBum/AnKOghNHx4+yOZdi+theRXmZRqjl3erlpXlRxTjhwmFHgv9i+
         OVkaycfHTmdqQ712hJ3B16vfJKmfyv6g10VToKKB7uaECSHBjvw2cjGvf0WPEgaSnWoP
         I6UvdUZGVY57bLvfCZemPHN288gEVO85KJl2Dvhw1yVuvVTYThsvaOaWPXzceFuTKfmV
         qeOw==
X-Gm-Message-State: APjAAAXiMnMHseqQD+S96xPF6nnUQ9jkhO0OgWi7XULkiOatpvXS4u0S
        bxO/e63V701mztFpPIOP34xuUgqCH+H0i4f6
X-Google-Smtp-Source: APXvYqxo0P5UXjG5SghH9bDidrFpni1NCg/XGwRnm8j8Mt9VWu1HQrf0yLH/oZNh7QjExmrFFWD9xA==
X-Received: by 2002:a1c:b146:: with SMTP id a67mr1688118wmf.124.1565859708821;
        Thu, 15 Aug 2019 02:01:48 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 14/30] crypto: ixp4xx/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:56 +0300
Message-Id: <20190815090112.9377-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ixp4xx_crypto.c | 27 +++++---------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index acedafe3fa98..f3c81bdffaf0 100644
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
+	return verify_ablkcipher_des3_key(tfm, key) ?:
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
 
@@ -1193,12 +1183,8 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (keys.authkeylen > sizeof(ctx->authkey))
 		goto badkey;
 
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(tfm);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err))
+	err = verify_aead_des3_key(tfm, keys.enckey, keys.enckeylen);
+	if (err)
 		goto badkey;
 
 	memcpy(ctx->authkey, keys.authkey, keys.authkeylen);
@@ -1209,7 +1195,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_setup(tfm, crypto_aead_authsize(tfm));
 badkey:
-	crypto_aead_set_flags(tfm, flags);
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
 }
-- 
2.17.1

