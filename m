Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B32C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C3592084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dl+sGCgs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfFVAbx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50931 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVAbw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id c66so7735620wmf.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=72feiy3abGUux7F2VbobpSpYBQ2b1eQYzkaU1DsyD2Q=;
        b=dl+sGCgs0VQno0vJe4GwzTfiOiZ39kfSChb0Kb/s+TMMFk9rFS9UzRagck8gCs/oCt
         MYUMo0lzvokj1XQz8r7Ipw+WGADPt2Emn8xipz3LRI3jkMMyqxfxS7gCXTVHtMreT5z9
         EjObMIYQMvkswtN7PZwDAIzE+X0INypFVkjxKFpSF6ZL5jlxSa1a0EDhrlYDzUkOw27T
         1GN0g69Lk14R9oMGZ8166BWAWKhS1NybPImZKkDNrq9DKFvJQLtlrRgEQVsl4+bk76HC
         sYZtZnJF/eiGP+sd7mMtYxXoHGE+k0DwIKrQNiaT9Zlnt3ItISqVHYd/6wh3cg22JyqT
         pWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=72feiy3abGUux7F2VbobpSpYBQ2b1eQYzkaU1DsyD2Q=;
        b=s3stTm2oQHtu6tPxBMm2Ir/fYllr9grw/AUKo0mGhN/Tc9nPFcr0FxzIgVRWBNqIN7
         z/WbP6EZME/ThZ6dR0z5vc1hd0GMRvz5gygAdZQW3klfHGY8L1sYRdySyxow02QSYV0y
         vymEq1RF3hiL6FVaVOjCKhPW/oJTFVk/qUBHihSCcz6ixqKxhdvKCpVIGSkvvSvoJbAO
         5n1inkiU6mQNp/a5rTwYLQax5kxP4U7zyRjVaUC2Hi25U7kKe6m2BNRj8OnceJOwCn1l
         mK6pvUvGCHKmsyZ1Af+tuazwxieekWC9TIWwanIXji1kqjxeKhKIH5IzKaWCGY4wOolc
         bs+A==
X-Gm-Message-State: APjAAAVrgGAozwzo4a0p9OrCkx8upem49d/NRLhiJpe3CqEAkDjwvw4h
        LzxQRiR58GHqnrbINhLWrswarCUSGSYW/r0R
X-Google-Smtp-Source: APXvYqwcDxPHKQBJzbK1rFxCyk2KcOCQv4/SGCz1oVd0LyBN3RKAmVbarMaj0RmmYsL8Dp8ofr67bQ==
X-Received: by 2002:a7b:c383:: with SMTP id s3mr604630wmj.44.1561163509594;
        Fri, 21 Jun 2019 17:31:49 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 05/30] crypto: bcm/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:47 +0200
Message-Id: <20190622003112.31033-6-ard.biesheuvel@linaro.org>
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
 drivers/crypto/bcm/cipher.c   | 82 +++++---------------
 drivers/crypto/caam/caamalg.c | 31 ++++----
 2 files changed, 37 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index d972ffac779d..70f2d0cb1a0c 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -35,7 +35,7 @@
 #include <crypto/aead.h>
 #include <crypto/internal/aead.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
@@ -1813,24 +1813,13 @@ static int des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		      unsigned int keylen)
 {
 	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 tmp[DES_EXPKEY_WORDS];
-
-	if (keylen == DES_KEY_SIZE) {
-		if (des_ekey(tmp, key) == 0) {
-			if (crypto_ablkcipher_get_flags(cipher) &
-			    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-				u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
+	int err;
 
-				crypto_ablkcipher_set_flags(cipher, flags);
-				return -EINVAL;
-			}
-		}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key, keylen);
+	if (unlikely(err))
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_DES;
 	return 0;
 }
 
@@ -1838,23 +1827,14 @@ static int threedes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct iproc_ctx_s *ctx = crypto_ablkcipher_ctx(cipher);
+	int err;
 
-	if (keylen == (DES_KEY_SIZE * 3)) {
-		u32 flags;
-		int ret;
-
-		flags = crypto_ablkcipher_get_flags(cipher);
-		ret = __des3_verify_key(&flags, key);
-		if (unlikely(ret)) {
-			crypto_ablkcipher_set_flags(cipher, flags);
-			return ret;
-		}
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key,
+					 keylen);
+	if (unlikely(err))
+		return err;
 
-		ctx->cipher_type = CIPHER_TYPE_3DES;
-	} else {
-		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		return -EINVAL;
-	}
+	ctx->cipher_type = CIPHER_TYPE_3DES;
 	return 0;
 }
 
@@ -2866,40 +2846,18 @@ static int aead_authenc_setkey(struct crypto_aead *cipher,
 
 	switch (ctx->alg->cipher_info.alg) {
 	case CIPHER_ALG_DES:
-		if (ctx->enckeylen == DES_KEY_SIZE) {
-			u32 tmp[DES_EXPKEY_WORDS];
-			u32 flags = CRYPTO_TFM_RES_WEAK_KEY;
-
-			if (des_ekey(tmp, keys.enckey) == 0) {
-				if (crypto_aead_get_flags(cipher) &
-				    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-					crypto_aead_set_flags(cipher, flags);
-					return -EINVAL;
-				}
-			}
+		if (crypto_des_verify_key(crypto_aead_tfm(cipher), keys.enckey,
+				   keys.enckeylen))
+			return -EINVAL;
 
-			ctx->cipher_type = CIPHER_TYPE_DES;
-		} else {
-			goto badkey;
-		}
+		ctx->cipher_type = CIPHER_TYPE_DES;
 		break;
 	case CIPHER_ALG_3DES:
-		if (ctx->enckeylen == (DES_KEY_SIZE * 3)) {
-			u32 flags;
-
-			flags = crypto_aead_get_flags(cipher);
-			ret = __des3_verify_key(&flags, keys.enckey);
-			if (unlikely(ret)) {
-				crypto_aead_set_flags(cipher, flags);
-				return ret;
-			}
-
-			ctx->cipher_type = CIPHER_TYPE_3DES;
-		} else {
-			crypto_aead_set_flags(cipher,
-					      CRYPTO_TFM_RES_BAD_KEY_LEN);
+		if (crypto_des3_ede_verify_key(crypto_aead_tfm(cipher),
+					       keys.enckey, keys.enckeylen))
 			return -EINVAL;
-		}
+
+		ctx->cipher_type = CIPHER_TYPE_3DES;
 		break;
 	case CIPHER_ALG_AES:
 		switch (ctx->enckeylen) {
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 43f18253e5b6..5d4fa65a015f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -785,20 +785,23 @@ static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 static int des_skcipher_setkey(struct crypto_skcipher *skcipher,
 			       const u8 *key, unsigned int keylen)
 {
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
-	struct crypto_tfm *tfm = crypto_skcipher_tfm(skcipher);
+	int err;
 
-	if (keylen == DES3_EDE_KEY_SIZE &&
-	    __des3_ede_setkey(tmp, &tfm->crt_flags, key, DES3_EDE_KEY_SIZE)) {
-		return -EINVAL;
-	}
+	err = des_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);
+	if (unlikely(err))
+		return err;
 
-	if (!des_ekey(tmp, key) && (crypto_skcipher_get_flags(skcipher) &
-	    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		crypto_skcipher_set_flags(skcipher,
-					  CRYPTO_TFM_RES_WEAK_KEY);
-		return -EINVAL;
-	}
+	return skcipher_setkey(skcipher, key, keylen);
+}
+
+static int des3_skcipher_setkey(struct crypto_skcipher *skcipher,
+				const u8 *key, unsigned int keylen)
+{
+	int err;
+
+	err = des3_ede_verify_key(crypto_skcipher_tfm(skcipher), key, keylen);
+	if (unlikely(err))
+		return err;
 
 	return skcipher_setkey(skcipher, key, keylen);
 }
@@ -1899,7 +1902,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "cbc-3des-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
@@ -2018,7 +2021,7 @@ static struct caam_skcipher_alg driver_algs[] = {
 				.cra_driver_name = "ecb-des3-caam",
 				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-			.setkey = des_skcipher_setkey,
+			.setkey = des3_skcipher_setkey,
 			.encrypt = skcipher_encrypt,
 			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
-- 
2.20.1

