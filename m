Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD8FC06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67E2721850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lxWeD94g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfGBTm3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:29 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39750 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfGBTm2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:28 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so18158402ljh.6
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ad0DoiAKzwKoTLL/HCg690cbeFEcYdQtGzvCJEzt4Xw=;
        b=lxWeD94g5yFO8oJjW/CzUVUNo7qwef+GL23iStNXnZM45mM94ZjY7gdpwoFSkheOwf
         tp7HPHofcHOl2i8JmwJoOXxzZLSJ18UFGTnZHNuqEfgwuF8qkkpX4i9i1m5kJ3JGgZLf
         3RcgGloEzBvatSyE01v/iIwNrTvm0SmzbgroWWLXZwSIARChYPX+85VL7hwJTCWsZIdp
         ncW8T4jQheH4O2h1wxS4oTuHj8+qXKCk/pD/Gz/Fmj1NOZmop5SybaDanT1OmuZSLa3U
         p+YvF5uXagnoQxvvqaDcuhG3RZV9/HMYmYFCpCmlri4dzyvEqy0UQOyrfwZYeXWOLXIF
         zEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ad0DoiAKzwKoTLL/HCg690cbeFEcYdQtGzvCJEzt4Xw=;
        b=gKiLSaCybINuM8OfdBWXP53Ul6zNpwsquUiLsREJd/wQPnTXYw+jrgvJbKvjGLYTZs
         cBiBZwYVtoka+6ZT5x0u6TLyGTPbpYtSYtOEDLXeH7ZOyYVZon4rxtgCHT3tas+T0a4V
         2RPOQgBnphxgSLsEzfwAOQHlXpwi6rwd9j1oSQL0um9SKoPpTDk2Gret3XwDeus2ThhB
         tfo0qM9Gcl+15mxIlmnHa7M52wBiW4XFd8qCp97ZazUTfpkAiAsYPD1oIBE332H6eSTm
         kQHQPSq9Ob1UoksKxggL6y6rOZ25ayK6qw3C5KjFaiId9SzeGeS4ZneZsjrWSJK4yze5
         50pQ==
X-Gm-Message-State: APjAAAXFJYrg3dvM3J3Uqsv34UB+4BaSgySuyWQESuTRYs1o3921rhzv
        uQlPKRnQylL2GhLFqsN+GBzHseqWBa6RETAz
X-Google-Smtp-Source: APXvYqz4QeP0cndbyim+bXtxP3rEab/FUphVaOvFRdqAK4JIp3aLTD9qWv/5OVMhHUCfvQNMYSPk+A==
X-Received: by 2002:a2e:5bdd:: with SMTP id m90mr17802446lje.46.1562096546620;
        Tue, 02 Jul 2019 12:42:26 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:25 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 12/32] crypto: arm64/aes-ccm - switch to AES library
Date:   Tue,  2 Jul 2019 21:41:30 +0200
Message-Id: <20190702194150.10405-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1

