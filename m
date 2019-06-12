Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D697DC31E48
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE0AD20684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bm10Ep11"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409156AbfFLMsw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:48:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42808 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406812AbfFLMsv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so1484707wrl.9
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kh+1icf/YKEvTTRJagBGMOB+f2u4C9zDf6SaxozYbCI=;
        b=bm10Ep11t57nCbm56g4vpVdy+Yaj8iHbmgP0FQq92PpqW6tSTKYLwLb9Xfe4PTu7c/
         5WDx8zgtCB2XRC8FbCA+JkKv/3S6EdFvXpC9hRWEwXMrxLmaFh//p5Nicq87n4EsPMNd
         k95tlbbrkmsBlVWG+v9r/soXrIgwaCjpTDz7066MHcjFV2FGoiAN5FvwSk3S4Q2o3vVD
         M4D/AYJg36iCrCnxCRYEkv8BB/xsIMEvNaWrWEXbSxT2UQjpBs/YvbzxJoHemS5LTDwL
         yK4MLTkbFAfzojdtDVwGHH/+LFeLkVbScOB6nefOJ+KMOCQ0yOkkCNoZl88Sy/SO2IvV
         8nmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kh+1icf/YKEvTTRJagBGMOB+f2u4C9zDf6SaxozYbCI=;
        b=QnpCEj9Bvm1Lgwaq92ovYpGSu8aQvRqVFzbmxVCVv9IPfXM1S4eD0GPamPM9e6Hg5D
         hivy/UL/0IMmC/MVE4vpuUHoeDlzlH6bHMlrtWUxYu99u7odkN3zIEIMZYPigbtk5buZ
         9SqZeRLI7IAHwCebrtHUlOJtIrbaktJhRKrRpSTC8GYUKV5lClKkAeVVfU4+EIuvtdcU
         cfKwNQkRixvajNPCarosAng9mXiD1W2Kaj5nVtUxwhEKtPfTiP5ZWBasxXs0jbZvWQsB
         RIg/NASvgutYKaEJXv0CrA3suY1RIYTY6+ZYByu84f1lvN67gVfHb0P9vFfuSiO6p71K
         hu8w==
X-Gm-Message-State: APjAAAVes539iGHQ1RBma74CwHIP5XGRiF7ol0TryvtKcNAbYgpXjDPc
        DLR5Vw57oik07NC9ipRsHdAcYIWoxpn0rg==
X-Google-Smtp-Source: APXvYqyFRbe5a7llDGgdZgGQ48cyE7FpVJnFDOKdhMwgD29ae0cAOhBTcXAdPK/P6xz8JRWbiVjupw==
X-Received: by 2002:adf:e6ca:: with SMTP id y10mr40142759wrm.3.1560343729058;
        Wed, 12 Jun 2019 05:48:49 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 02/20] crypto: arm/aes - rename local routines to prevent future clashes
Date:   Wed, 12 Jun 2019 14:48:20 +0200
Message-Id: <20190612124838.2492-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rename some local AES encrypt/decrypt routines so they don't clash with
the names we are about to introduce for the routines exposes by the
generic AES library.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-cipher-glue.c   | 8 ++++----
 arch/arm64/crypto/aes-cipher-glue.c | 8 ++++----
 crypto/aes_generic.c                | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

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
-- 
2.20.1

