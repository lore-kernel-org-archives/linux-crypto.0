Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D5BC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594472086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TtoZmtib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfF0K2M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37188 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfF0K2M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so5110878wme.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lm7oGps4teOEwcLPMuq0r39VG4DYBydnuDjdvE8qRsQ=;
        b=TtoZmtibts70TH1a3wjS/gKu5pk5IvIOaZcpHpJay0/wt1KzHU/5mkmjSDI7esgDVf
         TkqpbMLLzVhD7G2+9q2D8ZeapC8IvfQW5XJgrp0QcCr3qxJrEoOHLek3aaFBywbstMPV
         oEkOe7BJM/UhqPDkm2coXdE288VWc9tr4UvSnMY3KCkaLtHCIakOUGuMP5BZdcijs1st
         vy/KVQVpwx2KmvjG+cGxf4DlQ7YuAllVxREc8oQCFPpzNTMdzcdLpmxn2ydd1r2Nnj7h
         ZHTmpMKGTcm2KWsi+iJmYMpQ2DDGh58+KWR33/sVAoggG3aD89wAYFJ659zuHdFdUm9O
         H5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lm7oGps4teOEwcLPMuq0r39VG4DYBydnuDjdvE8qRsQ=;
        b=pRGSe1KQ8lROgLKIidumtfHfneAciTIs4YXFCd7uphsNY3sfRmt1mgDHpnJHvznYNz
         yC52DmYNLawJoxVR68sAZ8d4a1hvsc6OrQQdxlAkzShHLdHKb3NJvk0NGRVYqIWO4B9Q
         My/Kb+Ls/hA59S0kxsH5TKIhSdvD8/NwhpSIRT7KSzjIKDXuCMszJsgMH/cpZsHETx3g
         iOhN3gJwyvB/ayRpd0ZlpVNeIeZOOcE8nFbyGbKlj49Px+NHhkPKkga37h1hOJfMQnzd
         ia5u0AdGyA+cFjDu4CWJpOlX04mfP59eEUgVnghKakEDFsAe/P32weQSezDO/qS4HQl2
         fGHA==
X-Gm-Message-State: APjAAAWwiC+hy1tUnaW5/DCJUs93xZaNX3bWcZDo1G2qBLUnpha/CAy3
        y8ZRqWdBdbChCf1ZpL34344engnViTs=
X-Google-Smtp-Source: APXvYqwwMjIEV21QbUvgGTO1NP8VtIDbpl6Z+Ppp3inY0YinqD8+9JkshN21+IfnmfOMumHCN+ZHfw==
X-Received: by 2002:a1c:9ecd:: with SMTP id h196mr2822857wme.98.1561631290333;
        Thu, 27 Jun 2019 03:28:10 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:09 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 18/32] crypto: arm64/aes-ce-cipher - use AES library as fallback
Date:   Thu, 27 Jun 2019 12:26:33 +0200
Message-Id: <20190627102647.2992-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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

