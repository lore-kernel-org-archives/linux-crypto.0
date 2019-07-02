Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16AF7C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8F0621850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cFSPCIG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfGBTmg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43128 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfGBTmg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id 16so18134504ljv.10
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RA/9IzM/wteRuTKu0pLDxMNR1Wzx064tA8Ih0Blx/i0=;
        b=cFSPCIG/bffIkSOQesv7FkfPabeFVhhkSZpvMaJ1VeLDzo7FC5pD7m6sQB3EJMQBSO
         r2GYUbQ0o51V6I4iDxEk3PTvelCfsdtr6JBBVTHt1KVlGIuGgbbPQHoNEfZX+oGzUqLQ
         4ubA3HfxM6y+lDhP8dcgOYQUnGBhZcV83YuXXNKq0GlXSJCWvShzeGL1A2e3/xfgB9Tz
         PK9i1cDfy3MuSDa9fs9IQogmvpLGe/VMI/XwcZbu8eD4cVgocfUIWuH1p1kq4PcwlxvC
         ztqvhoN9z/yYEgAoRs7DBZdkKnjLvjkDmRIoSm6wPd8/g1gf4IFesjFS4pbcJDQllhrO
         T9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RA/9IzM/wteRuTKu0pLDxMNR1Wzx064tA8Ih0Blx/i0=;
        b=X9939y6R63Z4MwTIob/wtmKD9gORjKAskZD8xQFrzzv4LXoz3gagc+N0m2/meH6lvl
         KIXXcefIYaEyQ8DLQWwLZvIv9hEyRPybMPM/eu9+NUCmlvXVEpWYisoKkFusWL7RJWpH
         HmN82UlFJhC5Qkv7BEI6zlQVjWQbapv7ls4TUMsxuIYtkz7JcNGurrYjdQJkc6SHA/yE
         r3FzkT5gQsUg3Fj/MQlHUteTAFaoGSO8OZ2LXB2qmmLk/V05EtSkLa1G1+vJtVUU4M7w
         0WQjmavNxQjMSwlauVTToEDByAusEHT8AT3p9cxpJuNRxhhD8rsV2UXesqOFgxDe7FaP
         3S1A==
X-Gm-Message-State: APjAAAWizuGs8LTjVC816Vl9AfV23F8B6oR39R60TptaC98Snbps5j29
        h3A0jiQ73T3tLLZ7KN+gOSVxCYPujGI6qJeX
X-Google-Smtp-Source: APXvYqxAavoMSRtKSF5TetHoVj18kzccCHeX/StX5kHh1C2q79XskppXcmcL8eiYLynkOuxtZXYGaQ==
X-Received: by 2002:a2e:3e01:: with SMTP id l1mr18413773lja.208.1562096554329;
        Tue, 02 Jul 2019 12:42:34 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:33 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 18/32] crypto: arm64/aes-ce-cipher - use AES library as fallback
Date:   Tue,  2 Jul 2019 21:41:36 +0200
Message-Id: <20190702194150.10405-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1

