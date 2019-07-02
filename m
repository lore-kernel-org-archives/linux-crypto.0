Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AED3C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7353521850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pSZFdLA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfGBTm1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:27 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37753 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfGBTm0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:26 -0400
Received: by mail-lj1-f194.google.com with SMTP id 131so18175742ljf.4
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ess0mOhZtdacgukC/NjpqGdseB8Y22UnFMYYev7cVNc=;
        b=pSZFdLA6eORzgQv41SSsA0mO6SCQHY/ZclAh2KiY6yeCRnt/857PHmofjy6sMsdDjT
         ph2AhqhQf/3k+ddM7MXUO37wT+QrGUQLbDgTsWNb7cwSXj0RdweWX4Lqf2D0FoBqrMwX
         g2TAajtPfZykdJ0OtLvlg+WVbExMosB65ynL/uTJM9+HBlkRvPLqCAovuDwDpDRgDjNX
         uiNYAxpiqqFA9KaW5BVlMR+etINtksrrUyIMczU8d3AsILkBEjZx7QpUdcHyIUjxdtdX
         zIuarEZxsTMCOesQQxiA3rloxJh5HLVI+FFwGHluNmSPYE+F7cdoSKVOGe8ZdcEX26BZ
         nzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ess0mOhZtdacgukC/NjpqGdseB8Y22UnFMYYev7cVNc=;
        b=l0KLumbJoVXoi07y+quM0Mm8H1mL08R+R3cT1Oyy2J3iHa1ao6EHGhP5PYnNn9F1JF
         OofMEPHw/q1VIl3nvJqbLNebK4S3KpScnWflY/oJMXRDi8wApyLnUx+hRjkhg3XIRLln
         L6FM9bXrt30qlqaxWNk/vmLWaB8005NnUZZhPVlysOHIqhChnb22FsrEg7Gyson57/vo
         YvRPtLgYYdKmRbBxCmUfC9q+heBnWWW6tBAZgEL6S5y4IFbczy8qfuNt+pbZafeOn0uO
         pwwhpNZ5rGxIt8wJNasnGKbSBuWHlmaCpMRekwo/++tX6sUeDCc0giJcK1zDeCVJqw2C
         EGJg==
X-Gm-Message-State: APjAAAX2HKV8CH2D+H9jHzS+QzmB4+yVdVRt7TJLaVbY4TPaYyVXLNG2
        bWu8aud+DLYJrJXoNO47ElTVRFaCgZbw+hvl
X-Google-Smtp-Source: APXvYqyORUq3u9i9VGAMI3OeWMwd7CkWXF/ydjA4IWS0ZKhQluAa+E10t9gnulRg+PHQIABqYknwWQ==
X-Received: by 2002:a2e:5b0f:: with SMTP id p15mr18078724ljb.82.1562096544052;
        Tue, 02 Jul 2019 12:42:24 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:23 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 10/32] crypto: arm64/ghash - switch to AES library
Date:   Tue,  2 Jul 2019 21:41:28 +0200
Message-Id: <20190702194150.10405-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The GHASH code uses the generic AES key expansion routines, and calls
directly into the scalar table based AES cipher for arm64 from the
fallback path, and since this implementation is known to be non-time
invariant, doing so from a time invariant SIMD cipher is a bit nasty.

So let's switch to the AES library - this makes the code more robust,
and drops the dependency on the generic AES cipher, allowing us to
omit it entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/Kconfig         |  3 +-
 arch/arm64/crypto/ghash-ce-glue.c | 30 +++++++-------------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index d9a523ecdd83..1762055e7093 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -58,8 +58,7 @@ config CRYPTO_GHASH_ARM64_CE
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
 	select CRYPTO_GF128MUL
-	select CRYPTO_AES
-	select CRYPTO_AES_ARM64
+	select CRYPTO_LIB_AES
 
 config CRYPTO_CRCT10DIF_ARM64_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index b39ed99b06fb..90496765d22f 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -73,8 +73,6 @@ asmlinkage void pmull_gcm_decrypt(int blocks, u64 dg[], u8 dst[],
 asmlinkage void pmull_gcm_encrypt_block(u8 dst[], u8 const src[],
 					u32 const rk[], int rounds);
 
-asmlinkage void __aes_arm64_encrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
-
 static int ghash_init(struct shash_desc *desc)
 {
 	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
@@ -312,14 +310,13 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	u8 key[GHASH_BLOCK_SIZE];
 	int ret;
 
-	ret = crypto_aes_expand_key(&ctx->aes_key, inkey, keylen);
+	ret = aes_expandkey(&ctx->aes_key, inkey, keylen);
 	if (ret) {
 		tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
 
-	__aes_arm64_encrypt(ctx->aes_key.key_enc, key, (u8[AES_BLOCK_SIZE]){},
-			    num_rounds(&ctx->aes_key));
+	aes_encrypt(&ctx->aes_key, key, (u8[AES_BLOCK_SIZE]){});
 
 	return __ghash_setkey(&ctx->ghash_key, key, sizeof(be128));
 }
@@ -470,7 +467,7 @@ static int gcm_encrypt(struct aead_request *req)
 			rk = ctx->aes_key.key_enc;
 		} while (walk.nbytes >= 2 * AES_BLOCK_SIZE);
 	} else {
-		__aes_arm64_encrypt(ctx->aes_key.key_enc, tag, iv, nrounds);
+		aes_encrypt(&ctx->aes_key, tag, iv);
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
 		while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
@@ -481,8 +478,7 @@ static int gcm_encrypt(struct aead_request *req)
 			int remaining = blocks;
 
 			do {
-				__aes_arm64_encrypt(ctx->aes_key.key_enc,
-						    ks, iv, nrounds);
+				aes_encrypt(&ctx->aes_key, ks, iv);
 				crypto_xor_cpy(dst, src, ks, AES_BLOCK_SIZE);
 				crypto_inc(iv, AES_BLOCK_SIZE);
 
@@ -498,13 +494,10 @@ static int gcm_encrypt(struct aead_request *req)
 						 walk.nbytes % (2 * AES_BLOCK_SIZE));
 		}
 		if (walk.nbytes) {
-			__aes_arm64_encrypt(ctx->aes_key.key_enc, ks, iv,
-					    nrounds);
+			aes_encrypt(&ctx->aes_key, ks, iv);
 			if (walk.nbytes > AES_BLOCK_SIZE) {
 				crypto_inc(iv, AES_BLOCK_SIZE);
-				__aes_arm64_encrypt(ctx->aes_key.key_enc,
-					            ks + AES_BLOCK_SIZE, iv,
-						    nrounds);
+				aes_encrypt(&ctx->aes_key, ks + AES_BLOCK_SIZE, iv);
 			}
 		}
 	}
@@ -608,7 +601,7 @@ static int gcm_decrypt(struct aead_request *req)
 			rk = ctx->aes_key.key_enc;
 		} while (walk.nbytes >= 2 * AES_BLOCK_SIZE);
 	} else {
-		__aes_arm64_encrypt(ctx->aes_key.key_enc, tag, iv, nrounds);
+		aes_encrypt(&ctx->aes_key, tag, iv);
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
 		while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
@@ -621,8 +614,7 @@ static int gcm_decrypt(struct aead_request *req)
 					pmull_ghash_update_p64);
 
 			do {
-				__aes_arm64_encrypt(ctx->aes_key.key_enc,
-						    buf, iv, nrounds);
+				aes_encrypt(&ctx->aes_key, buf, iv);
 				crypto_xor_cpy(dst, src, buf, AES_BLOCK_SIZE);
 				crypto_inc(iv, AES_BLOCK_SIZE);
 
@@ -640,11 +632,9 @@ static int gcm_decrypt(struct aead_request *req)
 				memcpy(iv2, iv, AES_BLOCK_SIZE);
 				crypto_inc(iv2, AES_BLOCK_SIZE);
 
-				__aes_arm64_encrypt(ctx->aes_key.key_enc, iv2,
-						    iv2, nrounds);
+				aes_encrypt(&ctx->aes_key, iv2, iv2);
 			}
-			__aes_arm64_encrypt(ctx->aes_key.key_enc, iv, iv,
-					    nrounds);
+			aes_encrypt(&ctx->aes_key, iv, iv);
 		}
 	}
 
-- 
2.17.1

