Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12171C31E47
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD99D208C2
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pEI0k+6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439228AbfFLMtC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:49:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39434 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439221AbfFLMtC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:49:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so6394877wma.4
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pgzq94PpKRgLR2IqqS+QLXIksHPk3/jPtTuBsqGb9fM=;
        b=pEI0k+6wRBRQqYRce8OQ6w7+qzDTcY9VdLpprLUjALVpHrp3KXp8B7+l0jeIyQ8lQ7
         9dp9dDJ4UejLYCht5Til3Ll+9/chqnWTJuUA8+xnk3oYaN7+z2uwhZb6FsJnU873/E29
         N5bxyAaFyrbhvo6zscxxdXLBqf6XG498RaeA4Fe/ypTpVRzQWJl2I8CjFWrF3d9vfqDq
         s74i9Ga+4c5X+DU1wxy87mG9QKFSjkOokrrcup/UlK2XXVO+cP10OHmaMyR7c1Fufdai
         I6Vx47XAtXxMdhd0bcddGCJi4s6B/v4Yjtr7nPMkR90sRX+QdHxaARay5S8uSa/HegIF
         zQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pgzq94PpKRgLR2IqqS+QLXIksHPk3/jPtTuBsqGb9fM=;
        b=IClUpRjNQRNaGoLk8qWXjDuLhKZHhZ5MpuBz1LIXQDK3MxoiGrzraObrQKjIBjxQ5u
         P5n6eOiHfTdg7yTK74s2POsh37K2V2R5maG7VlWrJSXFbo9ffccYBzqkNyhJXdzmJNd1
         lXpEYpV3FO/psoEdQnEmO3IjyJ02pHoiCPFuMVTY3buUv1vVJvO1VWF5lQjKgL/LTWCW
         XdAQ18sck0L/L4Tb8YLa1JLpq/eoNXEtAfoUY11Ef4XCfZpKcWOqAWlsGYpaKRy6teKB
         E2nM9IQJuUEb814ms4YTYknKXsvrzF3btofwDTjyT0Dn6K/eunXJHrW9noeV05lbmUlS
         6osw==
X-Gm-Message-State: APjAAAUzQPR2GOEQ6BbUGuiOoQyjOKwY4jZhfuduGgK2YArgWfNtJmb0
        tv6IuTU8/5cM75XTqbQsViLSpIdTkK9LWQ==
X-Google-Smtp-Source: APXvYqzPoAyNpHd8lrlzzzYij7/9XnDDVzvgpESpiKWrZVEe6+mlg8cd2vQ2P5uivoE/zn1aOC5kRQ==
X-Received: by 2002:a7b:c7d8:: with SMTP id z24mr22344472wmk.10.1560343740210;
        Wed, 12 Jun 2019 05:49:00 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 12/20] crypto: arm64/aes-ccm - switch to AES library
Date:   Wed, 12 Jun 2019 14:48:30 +0200
Message-Id: <20190612124838.2492-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
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

