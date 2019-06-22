Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CB2C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F27920657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rjelpwRl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFVTep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35006 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfFVTeo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so9743937wrv.2
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9jtH53Jk7KStQcdKvZdfqjCIjywTrKC4erKe/oL3K6E=;
        b=rjelpwRlEGl8nDu1hlHJKl5gKKNiR5f23R8ycwG41M44RVvWF/etZuWgvSZGBO3dSt
         kXk51LyjJBDRBTFf5iMk2zBtfldLHm+TKlsjuZgo5mwuKHtPbRHdjZ9uSAq0cRRDCG0/
         1mYrI2Gasxagzbxr4vyW5w9Ix2RkIGntxbZWCuOd3F87Vwq98s5RtlPayQXBfBwQmLx4
         9OnBaEOZIhHr177ZShVOZBa4+EYWAeeutgwZDCUTDULlaCbCl1Pw2mVaHNRn0yID+AM3
         u4IsyDvhXpa/ZeAa3iT6flMwslQW46b4tsG/0qzox3GS2ZmWf8ldjU9qAjQGKsasPEvm
         a0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9jtH53Jk7KStQcdKvZdfqjCIjywTrKC4erKe/oL3K6E=;
        b=WE/A/f1t/F5TsVaIHsUM6naEfijqBtz2G9Mks33yx2hRrFASWYHNScAlaxsVB/JoOC
         Iw0ugbb1smsvi7E9xD206/oR08HW7BMMgo64Qjp65E9SYtb9xohYwpG43PK0XYEPminT
         OpLsvZ/V/G1JmBoZaNwnopnbACyx+34y0mxJXw7/MUNjWSVwyMj1MS4T9Rlw3a9mJZJ4
         QFGGQSXRtOHLSUukZEv0vRoARisM5I1Xw5ULHYwBEOi6DBqbRCr2Q8x7GExvYx5PFAhJ
         rrNjP+HEKUQKYScg1DSQIqAHAJQJRbvg+SwpDRydo/WmqGQrrXw8k/eSEHYd7xeN2sE5
         8tRQ==
X-Gm-Message-State: APjAAAXSPm9IEM85ITB68twEh+dAzVKicXIpse75w3aMLHRUYCL2E2kq
        +Z2yKOeYalijU4EWNYhIDS7zuN8cqu1d+T6S
X-Google-Smtp-Source: APXvYqxQEytti2os4ce2hRM7a3/kAFnySMa+81XQ6YkhzGfThfJMza837yuG6UC9SoN2fCUw30VsNQ==
X-Received: by 2002:a5d:4d84:: with SMTP id b4mr21162089wru.242.1561232081740;
        Sat, 22 Jun 2019 12:34:41 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 02/26] crypto: aes - rename local routines to prevent future clashes
Date:   Sat, 22 Jun 2019 21:34:03 +0200
Message-Id: <20190622193427.20336-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 arch/x86/crypto/aesni-intel_glue.c  | 8 ++++----
 crypto/aes_generic.c                | 8 ++++----
 drivers/crypto/padlock-aes.c        | 8 ++++----
 5 files changed, 20 insertions(+), 20 deletions(-)

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
2.20.1

