Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EB8C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1D332086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="czGwJyXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfF0K1y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:27:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38267 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfF0K1y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:27:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so1921486wrs.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9jtH53Jk7KStQcdKvZdfqjCIjywTrKC4erKe/oL3K6E=;
        b=czGwJyXJ+zNVPQyK6xTMltzIoJ0kfvneThDNU1tLZ+bXDWbKeo0ksXTFAIedwNjgF+
         h9h6Lhd9GwGzieKWif/HPYN9bTlF9ZeZ9dNMThONufUH1XKy5LMkE53FhDtMmY6/BRky
         EHGrmRKxnH+LbssJ0phJeeqANidGiQQXjUF4wL05n6nlpTxlbAVGTLT2dYuup5c1LZ8X
         K+fXRGJaE/STIMSQzI5E5ZbWngjzkhuDtBRzMliyJiKl0Kh/D9BZ4v9jAZw9ig050LLQ
         6kkG2IDS3yCyeCoh6iqxeD6F2YE+rHcZxb6v3Eb/aTu8Q7dqL62h0rp1D1TcRvhQh1Xu
         ffUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9jtH53Jk7KStQcdKvZdfqjCIjywTrKC4erKe/oL3K6E=;
        b=GKoQiOP+KaO0u3WYnY5NYg0sGT9WQGs6zH61E5owwJ662kUrO6mqkJypmohiacWBcV
         VenzRm8YYOHue0bxpy8GJm8Zv6Gf0/hCIRRRm8nvk44sENUoVNwMHZpeyWRdMXz8bF3O
         WV7ZTfac1M+usJMlaE7nRRUzx+Cg8ptnLDN86OZeSK76BhH/X+AiPa8eSRU2bI0illEN
         MCOMFza8nOWh88pq82vhgwegMPO/idYEUdHrYyUyquFS1Zkdyq97Z0h5p1CkZwWz6S0W
         pztAEDkX199pgI9hBZrKHpqnZxwKDLao9HssnXkAlADOQBUXVHmRgNAMngVLLEFkkvOn
         EdzA==
X-Gm-Message-State: APjAAAWYyXHUBlCMWeri75UfeLSmuk/NAjrMY2NB6rKg+DPDkK88LLQk
        xYmXnBpo2d5J+3sm6Bki0ADt/vA5O+M=
X-Google-Smtp-Source: APXvYqxdSFEwN/r9luXSvT0Nkm+Hb73fywBmkK8cEysOGEINaYVyyku3LHPgPp400j/G93zX1t7ZnA==
X-Received: by 2002:a05:6000:11c2:: with SMTP id i2mr2723505wrx.199.1561631272143;
        Thu, 27 Jun 2019 03:27:52 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 02/32] crypto: aes - rename local routines to prevent future clashes
Date:   Thu, 27 Jun 2019 12:26:17 +0200
Message-Id: <20190627102647.2992-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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

