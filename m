Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367AFC48BDA
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1088B2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zqKRnQks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF0K2G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:06 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36036 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfF0K2G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so1934403wrs.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pgzq94PpKRgLR2IqqS+QLXIksHPk3/jPtTuBsqGb9fM=;
        b=zqKRnQks+zzywDk154HrQyQHGVKltKxj2se24VndSlzuLaEsncsM1YqSEitfnJBLw5
         D+TPzsz/Ykp9Mu3ZCbSlgoiMe+NM3QRWGuuNmtf+Iwd+gLmNYbgksZQ9efJXh4WOiOis
         U8JBYx2/h2kRo/SaQ3fw5gUaVFVBv8YJUGuAiy6FHYghrlr3IbW130TwZZUizgEbmnS1
         F7khnmPmbA73vzK27R+FJ+GtlZZk2D8X3uql7A2jC2Hei21vpducb9f4jnp5YLaGLce6
         8wEj+7G1fT9wEcSip3wCEIHHIjGzvKNG24P1RYy6eV25ZHVM1ifJAcqUVMdDpwdCUoW9
         VEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pgzq94PpKRgLR2IqqS+QLXIksHPk3/jPtTuBsqGb9fM=;
        b=Z9VIs4mvfgOhuSyZ+5d263IGXwQHB2MKGrDFNaHx1mQvH4Y+C0vyfGllRs3Tss9xf6
         ICwFN00N0xkVRK3ZoXy59e8X+latUECayRHxYeGaPDJXlJwVdGB+L/LQWyhsY5F4eLik
         ZJfDWY+I8vUg4D/yLthoOluGuA5hZJ4k+v7VtSDhmhQASDEsBzJx9ZLj2HQyYe72tM+9
         7x60BmVcPXtksnG9buhu5vTN9E7Ze67oRdAiK7jw/ESxL9+IxLhuCjWzfwE7YYGIKEuq
         11W5xJ5Jh7jvE0ggp/Gk/pG19siNyzus1mQXrgOqJQmZ3JfW1++lnLBHZvPLiBK9grR0
         2qwQ==
X-Gm-Message-State: APjAAAU/VeFHDjKEQ1xKfgJKrfGZqVBQxKA3gdG2Ilzw71lh+EubQAXN
        cwLVVvpI4TbIQBLBQoA3qvxvirV+Qj4=
X-Google-Smtp-Source: APXvYqxRHFicdZZqoTqWw8tox1hJUEE4wRuPfXgxom8PlTYZVPczbsYVxCurOF3lmp2x3q1xMbCP1w==
X-Received: by 2002:adf:e806:: with SMTP id o6mr483716wrm.269.1561631283771;
        Thu, 27 Jun 2019 03:28:03 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:03 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 12/32] crypto: arm64/aes-ccm - switch to AES library
Date:   Thu, 27 Jun 2019 12:26:27 +0200
Message-Id: <20190627102647.2992-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CCM code calls directly into the scalar table based AES cipher for
arm64 from the fallback path, and since this implementation is known to
be non-time invariant, doing so from a time invariant SIMD cipher is a
bit nasty.

So let's switch to the AES library - this makes the code more robust,
and drops the dependency on the generic AES cipher, allowing us to
omit it entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig           |  2 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c | 18 ++++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 1762055e7093..c6032bfb44fb 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -80,8 +80,8 @@ config CRYPTO_AES_ARM64_CE_CCM
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_ALGAPI
 	select CRYPTO_AES_ARM64_CE
-	select CRYPTO_AES_ARM64
 	select CRYPTO_AEAD
+	select CRYPTO_LIB_AES
 
 config CRYPTO_AES_ARM64_CE_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index cb89c80800b5..b9b7cf4b5a8f 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -46,8 +46,6 @@ asmlinkage void ce_aes_ccm_decrypt(u8 out[], u8 const in[], u32 cbytes,
 asmlinkage void ce_aes_ccm_final(u8 mac[], u8 const ctr[], u32 const rk[],
 				 u32 rounds);
 
-asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
-
 static int ccm_setkey(struct crypto_aead *tfm, const u8 *in_key,
 		      unsigned int key_len)
 {
@@ -127,8 +125,7 @@ static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 		}
 
 		while (abytes >= AES_BLOCK_SIZE) {
-			__aes_arm64_encrypt(key->key_enc, mac, mac,
-					    num_rounds(key));
+			aes_encrypt(key, mac, mac);
 			crypto_xor(mac, in, AES_BLOCK_SIZE);
 
 			in += AES_BLOCK_SIZE;
@@ -136,8 +133,7 @@ static void ccm_update_mac(struct crypto_aes_ctx *key, u8 mac[], u8 const in[],
 		}
 
 		if (abytes > 0) {
-			__aes_arm64_encrypt(key->key_enc, mac, mac,
-					    num_rounds(key));
+			aes_encrypt(key, mac, mac);
 			crypto_xor(mac, in, abytes);
 			*macp = abytes;
 		}
@@ -209,10 +205,8 @@ static int ccm_crypt_fallback(struct skcipher_walk *walk, u8 mac[], u8 iv0[],
 				bsize = nbytes;
 
 			crypto_inc(walk->iv, AES_BLOCK_SIZE);
-			__aes_arm64_encrypt(ctx->key_enc, buf, walk->iv,
-					    num_rounds(ctx));
-			__aes_arm64_encrypt(ctx->key_enc, mac, mac,
-					    num_rounds(ctx));
+			aes_encrypt(ctx, buf, walk->iv);
+			aes_encrypt(ctx, mac, mac);
 			if (enc)
 				crypto_xor(mac, src, bsize);
 			crypto_xor_cpy(dst, src, buf, bsize);
@@ -227,8 +221,8 @@ static int ccm_crypt_fallback(struct skcipher_walk *walk, u8 mac[], u8 iv0[],
 	}
 
 	if (!err) {
-		__aes_arm64_encrypt(ctx->key_enc, buf, iv0, num_rounds(ctx));
-		__aes_arm64_encrypt(ctx->key_enc, mac, mac, num_rounds(ctx));
+		aes_encrypt(ctx, buf, iv0);
+		aes_encrypt(ctx, mac, mac);
 		crypto_xor(mac, buf, AES_BLOCK_SIZE);
 	}
 	return err;
-- 
2.20.1

