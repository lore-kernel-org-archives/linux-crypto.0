Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D05C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3650820657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OEI3R8Zd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfFVTfB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:35:01 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37437 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfFVTfB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:35:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so9609959wme.2
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lm7oGps4teOEwcLPMuq0r39VG4DYBydnuDjdvE8qRsQ=;
        b=OEI3R8ZdEFOf2IK+/cF7HPZfZj4AkMIKfVOxytWBcOxnlrXK9fTyom7onykz9NbC5C
         euufNlTWgEZEqS6bgABNwEWRaxXV51aaoGTDogrwcaO4sVP+o8PBLQtc+GBmgRar1KWA
         HG3AbG1TViD3gypmMAuNDKBuyOC8wmVhw6jgdNzKnM5sVK+LmdqQYrQz3ZePevNJQu1P
         wZKer/5Ws7/2h92qHpw81y1uwXyrzmvcLyYssd159glKG6uq+21yIDyq2JZiwRZyj4hF
         EF6DaElXL1TiVDTsZdGHrpvwr1UcITG2hwNWItjHFkBhMaYoYLN8lvPRucTJXV5COkE2
         69Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lm7oGps4teOEwcLPMuq0r39VG4DYBydnuDjdvE8qRsQ=;
        b=j1+mg8BGrd1kCk24g6wOnJS6bhW/NvfDLa7KkF1QnU0elkU0UwMQEvDyC99+8RV6j4
         ZQpn8DVpbBO75siF/uYXOim2mysL7FlSJlv3isTCkZWPjFoE5VQzyk3QgpC2eUZHPbZI
         e0dgz0erJ/ESshq6oak6bw/F949kVF+t3a+ID8QIEOyHvwIaEj9ZLu6KYpfwOe4oUw1b
         Z4CHb4t4hWXo0Ov2at0UhOWM76jysatsqYtSl1UHSK4pymBed3maZUthXMf5nx1yXMsp
         WXtQtqkh3jCT2vaGoR7awNJXCwyItb7pXSAXGgfgnPx+oznqCdoJxrbvtLiaLuWvmZJy
         xuwA==
X-Gm-Message-State: APjAAAXlO0jo9eaKsbeAvRMma3xuE3N7AN7g95bSBK84OiXJ5fvVtk2c
        KqAe90CxVMcJi2mOKQuEMe8spe3EaqvZ4kY7
X-Google-Smtp-Source: APXvYqw6Wne8AQZFrVYYATsyXcu/ubW3SVD0Ho5VFaoT6eOn2prN+S83ritthukDQgANum0NI/L8yA==
X-Received: by 2002:a1c:452:: with SMTP id 79mr9014805wme.149.1561232099327;
        Sat, 22 Jun 2019 12:34:59 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 18/26] crypto: arm64/aes-ce-cipher - use AES library as fallback
Date:   Sat, 22 Jun 2019 21:34:19 +0200
Message-Id: <20190622193427.20336-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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

