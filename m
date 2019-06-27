Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E26C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD12F20828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aadRIWnO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfF0K2F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38295 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfF0K2F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so1922067wrs.5
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8rzDm2pxsxDof2+7Zzrqa2tkF2eXq+Yv+cQAP5RFetY=;
        b=aadRIWnOfwvrsxYEaKgKoJKubsySZRTcezcL0Y5U6MgwQ8x2L7EKaloZTkFnCEJISb
         ryZVhyElEmd3GAyC9mbLtSYcGrcZ/ZQ2HT707XvmK90Kavku7AUD3VaceUKZpqGAQZLz
         uSB7DbCwjFMCStgeUJMc28aDfwi7nOoQD9FxQv5oeXoeZZXjJVgLrdWOkqts38Vfvy8y
         Wh61goGzeQZ5tvWC/q+Kxga9BknXruGdBwme6VrIEpew6jVhEV/xoYK9Gd6/Zz0Sjv1r
         geS72GRGS0ffT6nGJd5QB8OTVauND389Lwy+3CAQYseS4+7hOJOGbDVLwJjw4xKsv0Hr
         5O1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8rzDm2pxsxDof2+7Zzrqa2tkF2eXq+Yv+cQAP5RFetY=;
        b=jQM57InEVu9Xxq5Tl9e8BYNvTyjwBgf00bLLnRzTOdVIu0SqxOckCrJ63F8Dpf3uib
         pJ7FW6YqvcR4spVS2djQ4aao8FhUDST089m3AU7rztMe+zyZz3JPjwXfnYsmBtXlQUmr
         z809PbYIP61KsyISDz5bNNCpLHAXN7uyRMPEyL8Z29fZv2sEDd8hXfc/KzLcc/KAgSUc
         i+cdj9Nr1V1RZc9Pxe/t4iTT7K3963KpwYuAPW6M7Hzm9Y+2TXF82vNrH0kuQrFczPZz
         LEuvJqlHM0XVR4bmxlPE+w8F5TxItuFw5YLz3LwQB048lhE+ohTRa8t2YXi7jmlDTpHJ
         0Ppw==
X-Gm-Message-State: APjAAAXi6MUbYVXjz0engSpSQ8F3EzVtmhwE5F0z2+eUu1bLtFtbBsYf
        TB+2NiI8wdsNOzTccZTPWQX42ddhXno=
X-Google-Smtp-Source: APXvYqyTPyAiwVmY2JBd8DOoMWesoogPD7wygjO0F8KORzY9k1l9Dvz6kWBbzwzg59iwzMBLxDgHiw==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr2736785wrp.312.1561631281703;
        Thu, 27 Jun 2019 03:28:01 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.28.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:28:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 10/32] crypto: arm64/ghash - switch to AES library
Date:   Thu, 27 Jun 2019 12:26:25 +0200
Message-Id: <20190627102647.2992-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.20.1

