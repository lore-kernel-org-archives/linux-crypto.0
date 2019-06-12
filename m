Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38ECC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E57920684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PhOA519R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439232AbfFLMtH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37905 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439229AbfFLMtG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so6411027wmj.3
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lm7oGps4teOEwcLPMuq0r39VG4DYBydnuDjdvE8qRsQ=;
        b=PhOA519RQ/KSm8Wq2yejvZbrXDftUtvpiVOr23t3wVMghc2GenkIWkRSLQWvCugDB1
         fHLSI958DpSR+ppikmXzADwbVAEpbWu8fxOTcoTPM27vCiB0Vb6vvCNNp9FYtEQbtBOI
         fmSNGvDIcxoK+95wfBwL0ji7nw4Y3rZQBz15O32vV5o7WCkv2S7vxfoR2vLdx1trUutS
         tfiwpTr16f864dZ1gQ57VWdZ8oXo+aGb1SreN1vg7eVFbVITaAd+vLOcdsIDjh4WPPTz
         AJe4gMbJD1EpUW8DVBHTMvnwN7VR1Cw6wJYetUc9g5LnM2M+av50xnw/8QAG/CbWijEm
         GbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lm7oGps4teOEwcLPMuq0r39VG4DYBydnuDjdvE8qRsQ=;
        b=lHkpNO9yXO0R/aT0ga5qd4UYiDgsWtBoOg3u/gP3Ac6JGxXFDX3ZHAPMYbR45COhNo
         aqgTMZAYA3f/byjJnWX5PBniPit5IbQsdTW2yB33hlbok9kvZIj40zkIKSZREvSML2qY
         omrcIveagADus1MbFDQkZgBogRURl2KwP0WTetz2CG0eQDXeltbAz9lWSGEVFKtGKe6j
         PRvAthYgmY814rmJitHh3sepqLaUw0NbmOFkeQE2iQhyxqlMJToAHJAx/RwWRQ8Ey+Ja
         FUaNOd/4BlfmJ+DU6xUjclPDjpGy3GcOuB5DH3bkqvwpXdTB593g5AZPxkmCcAGgdg1b
         Y65w==
X-Gm-Message-State: APjAAAXjpPhHc/hpXhRdiqj+7d+CAj2YsPah7ojIHSGiw5159s+IKM7I
        ubkwlIPPo+aHoBYodAjXjD054ogr03EpGA==
X-Google-Smtp-Source: APXvYqzHFhZd9Lo9GxcvMVDWmdhtntULzodtBWuiah4NQZql4MQH5zvRXcR8CgE5ZJkyFGZsBBc/pQ==
X-Received: by 2002:a05:600c:23d2:: with SMTP id p18mr21441697wmb.108.1560343744412;
        Wed, 12 Jun 2019 05:49:04 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.49.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:49:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 16/20] crypto: arm64/aes-ce-cipher - use AES library as fallback
Date:   Wed, 12 Jun 2019 14:48:34 +0200
Message-Id: <20190612124838.2492-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of calling into the table based scalar AES code in situations
where the SIMD unit may not be used, use the generic AES code, which
is more appropriate since it is less likely to be susceptible to
timing attacks.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig           | 2 +-
 arch/arm64/crypto/aes-ce-glue.c     | 7 ++-----
 arch/arm64/crypto/aes-cipher-glue.c | 3 ---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 66dea518221c..4922c4451e7c 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -73,7 +73,7 @@ config CRYPTO_AES_ARM64_CE
 	tristate "AES core cipher using ARMv8 Crypto Extensions"
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
-	select CRYPTO_AES_ARM64
+	select CRYPTO_LIB_AES
 
 config CRYPTO_AES_ARM64_CE_CCM
 	tristate "AES in CCM mode using ARMv8 Crypto Extensions"
diff --git a/arch/arm64/crypto/aes-ce-glue.c b/arch/arm64/crypto/aes-ce-glue.c
index 3213843fcb46..6890e003b8f1 100644
--- a/arch/arm64/crypto/aes-ce-glue.c
+++ b/arch/arm64/crypto/aes-ce-glue.c
@@ -23,9 +23,6 @@ MODULE_DESCRIPTION("Synchronous AES cipher using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
 
-asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
-asmlinkage void __aes_arm64_decrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
-
 struct aes_block {
 	u8 b[AES_BLOCK_SIZE];
 };
@@ -54,7 +51,7 @@ static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!crypto_simd_usable()) {
-		__aes_arm64_encrypt(ctx->key_enc, dst, src, num_rounds(ctx));
+		aes_encrypt(ctx, dst, src);
 		return;
 	}
 
@@ -68,7 +65,7 @@ static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	if (!crypto_simd_usable()) {
-		__aes_arm64_decrypt(ctx->key_dec, dst, src, num_rounds(ctx));
+		aes_decrypt(ctx, dst, src);
 		return;
 	}
 
diff --git a/arch/arm64/crypto/aes-cipher-glue.c b/arch/arm64/crypto/aes-cipher-glue.c
index 0e90b06ebcec..bf32cc6489e1 100644
--- a/arch/arm64/crypto/aes-cipher-glue.c
+++ b/arch/arm64/crypto/aes-cipher-glue.c
@@ -13,10 +13,7 @@
 #include <linux/module.h>
 
 asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
-EXPORT_SYMBOL(__aes_arm64_encrypt);
-
 asmlinkage void __aes_arm64_decrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
-EXPORT_SYMBOL(__aes_arm64_decrypt);
 
 static void aes_arm64_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
-- 
2.20.1

