Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E969C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7245D21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RKQ0FGEE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfGBTmQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:16 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35975 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBTmP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:15 -0400
Received: by mail-lf1-f66.google.com with SMTP id q26so12287831lfc.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2+eLnmRKp4RXP1xyqf/h535DDbVPM+2CtmZm4AazSXI=;
        b=RKQ0FGEEBrttzHzkR9FWohWLqG23UNciB8IPtB4ALc43cybdfjAo6AsB1OLOl4e8xw
         1QcO1+Q+aEYErm10TZIZoGAYp8bQk5xhHk0D7VnKXDqjLd6WP3mfLkATBf0j3Yt5dV4H
         jd3zlxdYpJLEczF2Kiuyc97CkqpIGwC1QznkYH2lNC4RaNdg94qupJN3dXxTC0+TJEsV
         J6vvNXA0mLbkR0lI5Vh4iicgUaAjr9vSr7wR3mqV1AYMT+jVvnoqvOW+l/OW6yNxodS4
         u8T7kuRq3dxSYoWgbFfWahxRz9QVLqz8huRP4EzuLv94xPNFXTF0ByTQacgBS+APQg8/
         lbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2+eLnmRKp4RXP1xyqf/h535DDbVPM+2CtmZm4AazSXI=;
        b=PNURjZ36tgkI9huVyTE/TP9iXLTOeWPx9G31L9ElrlqYFDLOvD4A+or231yZz41HPA
         iAGwSZAUO73YTI2/4BQ/OCnaiPbhNB8ZPZZKrlcuUeod+Kbyv1pONnpbfEXd4Bzq6/hL
         Rj/Q9IrtWffDNp4yJH/6bE6nTUL3LzmrvRjrtIc0wDsxTHwXnq2Wu27rhwJO7rw8rqXX
         /qHGjpksk6WXDdDOb5EH+MGtPVYVbyppfRsirD4g3JJfCKdUnspY5IXO3S+kAFG9wOnU
         5iSqd3lCASAUOgpdLwJpmrX25jkQz3iW4wNjtVjyrXDN+IFrvWJ2vRpbvswmfYDM1GFS
         TboQ==
X-Gm-Message-State: APjAAAXXjtYLwdot+l+FXY0R4+EJqWnQosO1WFQcCPKJluN/jyZG4DtN
        7wYSFkmRS14okrrd/aIjveJTLmpbesJWF8hg
X-Google-Smtp-Source: APXvYqyDWpw8RcHPJhlhUBQRKl//N/GyNpxjYrwKuFQDHGAMIdFpgPudJpjDSrqA+r0LzEoAyHVaNw==
X-Received: by 2002:ac2:42ca:: with SMTP id n10mr3545468lfl.121.1562096532875;
        Tue, 02 Jul 2019 12:42:12 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 02/32] crypto: aes - rename local routines to prevent future clashes
Date:   Tue,  2 Jul 2019 21:41:20 +0200
Message-Id: <20190702194150.10405-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rename some local AES encrypt/decrypt routines so they don't clash with
the names we are about to introduce for the routines exposed by the
generic AES library.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-cipher-glue.c   | 8 ++++----
 arch/arm64/crypto/aes-cipher-glue.c | 8 ++++----
 arch/sparc/crypto/aes_glue.c        | 8 ++++----
 arch/x86/crypto/aesni-intel_glue.c  | 8 ++++----
 crypto/aes_generic.c                | 8 ++++----
 drivers/crypto/padlock-aes.c        | 8 ++++----
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/arm/crypto/aes-cipher-glue.c b/arch/arm/crypto/aes-cipher-glue.c
index c222f6e072ad..f6c07867b8ff 100644
--- a/arch/arm/crypto/aes-cipher-glue.c
+++ b/arch/arm/crypto/aes-cipher-glue.c
@@ -19,7 +19,7 @@ EXPORT_SYMBOL(__aes_arm_encrypt);
 asmlinkage void __aes_arm_decrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
 EXPORT_SYMBOL(__aes_arm_decrypt);
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void aes_arm_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	int rounds = 6 + ctx->key_length / 4;
@@ -27,7 +27,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	__aes_arm_encrypt(ctx->key_enc, rounds, in, out);
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void aes_arm_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	int rounds = 6 + ctx->key_length / 4;
@@ -47,8 +47,8 @@ static struct crypto_alg aes_alg = {
 	.cra_cipher.cia_min_keysize	= AES_MIN_KEY_SIZE,
 	.cra_cipher.cia_max_keysize	= AES_MAX_KEY_SIZE,
 	.cra_cipher.cia_setkey		= crypto_aes_set_key,
-	.cra_cipher.cia_encrypt		= aes_encrypt,
-	.cra_cipher.cia_decrypt		= aes_decrypt,
+	.cra_cipher.cia_encrypt		= aes_arm_encrypt,
+	.cra_cipher.cia_decrypt		= aes_arm_decrypt,
 
 #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	.cra_alignmask			= 3,
diff --git a/arch/arm64/crypto/aes-cipher-glue.c b/arch/arm64/crypto/aes-cipher-glue.c
index 7288e7cbebff..0e90b06ebcec 100644
--- a/arch/arm64/crypto/aes-cipher-glue.c
+++ b/arch/arm64/crypto/aes-cipher-glue.c
@@ -18,7 +18,7 @@ EXPORT_SYMBOL(__aes_arm64_encrypt);
 asmlinkage void __aes_arm64_decrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
 EXPORT_SYMBOL(__aes_arm64_decrypt);
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void aes_arm64_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	int rounds = 6 + ctx->key_length / 4;
@@ -26,7 +26,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	__aes_arm64_encrypt(ctx->key_enc, out, in, rounds);
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void aes_arm64_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	int rounds = 6 + ctx->key_length / 4;
@@ -46,8 +46,8 @@ static struct crypto_alg aes_alg = {
 	.cra_cipher.cia_min_keysize	= AES_MIN_KEY_SIZE,
 	.cra_cipher.cia_max_keysize	= AES_MAX_KEY_SIZE,
 	.cra_cipher.cia_setkey		= crypto_aes_set_key,
-	.cra_cipher.cia_encrypt		= aes_encrypt,
-	.cra_cipher.cia_decrypt		= aes_decrypt
+	.cra_cipher.cia_encrypt		= aes_arm64_encrypt,
+	.cra_cipher.cia_decrypt		= aes_arm64_decrypt
 };
 
 static int __init aes_init(void)
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index a9b8b0b94a8d..1f7191c243bc 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -196,14 +196,14 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->ops->encrypt(&ctx->key[0], (const u32 *) src, (u32 *) dst);
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -395,8 +395,8 @@ static struct crypto_alg algs[] = { {
 			.cia_min_keysize	= AES_MIN_KEY_SIZE,
 			.cia_max_keysize	= AES_MAX_KEY_SIZE,
 			.cia_setkey		= aes_set_key,
-			.cia_encrypt		= aes_encrypt,
-			.cia_decrypt		= aes_decrypt
+			.cia_encrypt		= crypto_aes_encrypt,
+			.cia_decrypt		= crypto_aes_decrypt
 		}
 	}
 }, {
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index c95bd397dc07..836d50bd096f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -349,7 +349,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return aes_set_key_common(tfm, crypto_tfm_ctx(tfm), in_key, key_len);
 }
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void aesni_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
@@ -362,7 +362,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	}
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
+static void aesni_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
@@ -923,8 +923,8 @@ static struct crypto_alg aesni_cipher_alg = {
 			.cia_min_keysize	= AES_MIN_KEY_SIZE,
 			.cia_max_keysize	= AES_MAX_KEY_SIZE,
 			.cia_setkey		= aes_set_key,
-			.cia_encrypt		= aes_encrypt,
-			.cia_decrypt		= aes_decrypt
+			.cia_encrypt		= aesni_encrypt,
+			.cia_decrypt		= aesni_decrypt
 		}
 	}
 };
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index f217568917e4..3aa4a715c216 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1332,7 +1332,7 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 	f_rl(bo, bi, 3, k);	\
 } while (0)
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 b0[4], b1[4];
@@ -1402,7 +1402,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	i_rl(bo, bi, 3, k);	\
 } while (0)
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	u32 b0[4], b1[4];
@@ -1454,8 +1454,8 @@ static struct crypto_alg aes_alg = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
 			.cia_setkey		=	crypto_aes_set_key,
-			.cia_encrypt		=	aes_encrypt,
-			.cia_decrypt		=	aes_decrypt
+			.cia_encrypt		=	crypto_aes_encrypt,
+			.cia_decrypt		=	crypto_aes_decrypt
 		}
 	}
 };
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 09d823d36d3a..854539512c35 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -299,7 +299,7 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 	return iv;
 }
 
-static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void padlock_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 
@@ -308,7 +308,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	padlock_store_cword(&ctx->cword.encrypt);
 }
 
-static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void padlock_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
 
@@ -331,8 +331,8 @@ static struct crypto_alg aes_alg = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
 			.cia_setkey	   	= 	aes_set_key,
-			.cia_encrypt	 	=	aes_encrypt,
-			.cia_decrypt	  	=	aes_decrypt,
+			.cia_encrypt	 	=	padlock_aes_encrypt,
+			.cia_decrypt	  	=	padlock_aes_decrypt,
 		}
 	}
 };
-- 
2.17.1

