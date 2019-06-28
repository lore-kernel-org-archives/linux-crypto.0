Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA82C5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 278582133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AvPEdUyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfF1Jfo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52060 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfF1Jfo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so8404545wma.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cn/4xS2+9iH5jH+iLcS0rdXNUDZPIJrnRSc05Y5YX+o=;
        b=AvPEdUyLhYlqdFiZmwmH25y8ZXahV306yrZr394PZC1FPYPjcXrJ1ySdO9nlY9PZKW
         wxtAY31i09RwIXYWTG5Njaqoy7Q1wwriiOyi6S2MAEZ5ywQOUL8rjuzEBh031u5eS4pk
         PxWli+0Ejj7x/zaUp/Btk5NLx17v8t2HHdc9ObezXuHif7zQoA71f8QzmwCINXZjIpXt
         pbD0kUseAnPbFAhhQT55lULrs1kahu7L4TEPIf+mKBBlITS3pft9AmeumJLfNC3L5ncO
         M+NjcoNHIsbgkI9gQidKIaDF+7s7LvMedeD7nnuhSEhxyE0G4adifjthD5LyGaqJFSi+
         iqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cn/4xS2+9iH5jH+iLcS0rdXNUDZPIJrnRSc05Y5YX+o=;
        b=U2Yd9CtcBrXKfGfEkdFmvHP+RQGnYLaH610i+Sa7uP/6Aov9qwSjvfPDc1pkFKo+/6
         Dfrpi/jTAZi0EPcDMxxc/h4QPfF1xRcrcFuMsf/nJzkE3E/fLhTB+M5dMWAmrIbH2bn7
         IqE0sU918VvKZtowQbR+99qQZMmYi5p13vSt5AyY9JvV/9reegTjhANwU2xDeLcTykL5
         317CQW/fvGfdD3/r/rCkcCL7OHa/YLVI9d22lWpqSuqv4N5kEn00EoiefTgCevmTIR5C
         v7JPu7TV3nSAvzCcv8g/korR0V0PgLIRwdCoyHZ7afk134q3tZjuqPaZBzhuzQpF3Fcr
         aWSg==
X-Gm-Message-State: APjAAAUV1aSfQ6beOHfqDD42tgOzjgTFYpwFPrm+Up1CeZXbEMLko+Zf
        yFoRUIxND7OWYeZLcqvrHSCUOvg9yT/Abw==
X-Google-Smtp-Source: APXvYqz6RRi3VfGRkUui7b8TxSBz5d8R6eNVH6QbZGzJ6FPSKiy3IUn1RNRZ+FqT8NBZ1/Il5BemzQ==
X-Received: by 2002:a7b:cc04:: with SMTP id f4mr6823350wmh.125.1561714541579;
        Fri, 28 Jun 2019 02:35:41 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:40 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 03/30] crypto: sparc/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:02 +0200
Message-Id: <20190628093529.12281-4-ard.biesheuvel@linaro.org>
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
 arch/sparc/crypto/des_glue.c | 37 +++++++++-----------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 453a4cf5492a..80b646d32ee8 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -11,7 +11,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include <asm/fpumacro.h>
 #include <asm/pstate.h>
@@ -44,19 +44,15 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 		       unsigned int keylen)
 {
 	struct des_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
+	int err;
 
 	/* Even though we have special instructions for key expansion,
-	 * we call des_ekey() so that we don't have to write our own
+	 * we call des_verify_key() so that we don't have to write our own
 	 * weak key detection code.
 	 */
-	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	des_sparc64_key_expand((const u32 *) key, &dctx->encrypt_expkey[0]);
 	encrypt_to_decrypt(&dctx->decrypt_expkey[0], &dctx->encrypt_expkey[0]);
@@ -67,7 +63,7 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 extern void des_sparc64_crypt(const u64 *key, const u64 *input,
 			      u64 *output);
 
-static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -75,7 +71,7 @@ static void des_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->decrypt_expkey;
@@ -201,14 +197,13 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct des3_ede_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
 	u64 k1[DES_EXPKEY_WORDS / 2];
 	u64 k2[DES_EXPKEY_WORDS / 2];
 	u64 k3[DES_EXPKEY_WORDS / 2];
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(tfm, key);
+	if (err)
 		return err;
 
 	des_sparc64_key_expand((const u32 *)key, k1);
@@ -234,7 +229,7 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 extern void des3_ede_sparc64_crypt(const u64 *key, const u64 *input,
 				   u64 *output);
 
-static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->encrypt_expkey;
@@ -242,7 +237,7 @@ static void des3_ede_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des3_ede_sparc64_crypt(K, (const u64 *) src, (u64 *) dst);
 }
 
-static void des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_des3_ede_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct des3_ede_sparc64_ctx *ctx = crypto_tfm_ctx(tfm);
 	const u64 *K = ctx->decrypt_expkey;
@@ -389,8 +384,8 @@ static struct crypto_alg algs[] = { {
 			.cia_min_keysize	= DES_KEY_SIZE,
 			.cia_max_keysize	= DES_KEY_SIZE,
 			.cia_setkey		= des_set_key,
-			.cia_encrypt		= des_encrypt,
-			.cia_decrypt		= des_decrypt
+			.cia_encrypt		= crypto_des_encrypt,
+			.cia_decrypt		= crypto_des_decrypt
 		}
 	}
 }, {
@@ -446,8 +441,8 @@ static struct crypto_alg algs[] = { {
 			.cia_min_keysize	= DES3_EDE_KEY_SIZE,
 			.cia_max_keysize	= DES3_EDE_KEY_SIZE,
 			.cia_setkey		= des3_ede_set_key,
-			.cia_encrypt		= des3_ede_encrypt,
-			.cia_decrypt		= des3_ede_decrypt
+			.cia_encrypt		= crypto_des3_ede_encrypt,
+			.cia_decrypt		= crypto_des3_ede_decrypt
 		}
 	}
 }, {
-- 
2.20.1

