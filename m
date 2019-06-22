Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6455C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979D820657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jJ3qN3P7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfFVTe4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40963 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbfFVTez (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so9704653wrm.8
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pgzq94PpKRgLR2IqqS+QLXIksHPk3/jPtTuBsqGb9fM=;
        b=jJ3qN3P7GB+LlOmKMZdJl6R+axoPADCBKhPa5hcIDq7yq3IJ3g06DH8JkGaZ5ArLd3
         DQVRyVzYlmDx9Msk1nlD/j3pe2RFyrapO00lU5nYQoAiFH+q0jnOkb32uHjD92gMoIu+
         jP6EH1wzF+cN93pZEYoQThimIrdpgiKtxagV4DunVLv8T0TOO2yt4b/xHS+YHWFcetwd
         DBnUu09qQ3D4IqoKEIPeWajOvYk4dbcOJ6rL+eNasQ1tgLIZ2sKYmI0tAlBlvAkmzogJ
         9q96mI/HO4Mx+MQyghDeubACjAlCAYJWSjvfW+FGG4YHcqfU5CImVncNhCTgPTvVWtdi
         gsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pgzq94PpKRgLR2IqqS+QLXIksHPk3/jPtTuBsqGb9fM=;
        b=V2TSxoU1U423MQni2VelkntoOB845YW3tD9PVjA3EG+z9BgloZus1d0Qk4Nxhdo2i4
         VB22I33TNOGsAna6NHWALBzbwQ1pB33e9DK1Bs8ZB9uBUwBMIdyTEy5mv9lBrHAghneK
         wLxSC+k0xE6BL8RlHnHPPb4L9x1fgVpG0omTdW17mJ49TkmAjyfisyHfwaLKc1gkLJUb
         HyNe3yPUdSOr6RZSrpPGukH9wLEz3c3026r7rbDqvypCC2Y4J9LH3tHlrT54YnFXFzq1
         hd37Xl6/DoKcZMsumIu8oVPjmrO6MD/OthG53fpUwqfDTtkBJZqwLSXqxFTZ9EUzif3E
         Jtyw==
X-Gm-Message-State: APjAAAUb8SFKOCiA78wchj8wb+z2f8IOdIuK8R/HtNU6kbS7qPDMp38N
        U1UnoFr8mHhKniyTpE5qHOOB4nln5y1555Ex
X-Google-Smtp-Source: APXvYqyHZbP0R8JRWi1nYXnb/1R5OY1A0rdlL/X1BUAWdbaHWE0LUz5cBCDuxxAo9oiQbwHY8BY7jA==
X-Received: by 2002:adf:e8cb:: with SMTP id k11mr4318379wrn.244.1561232092962;
        Sat, 22 Jun 2019 12:34:52 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:52 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 12/26] crypto: arm64/aes-ccm - switch to AES library
Date:   Sat, 22 Jun 2019 21:34:13 +0200
Message-Id: <20190622193427.20336-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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

