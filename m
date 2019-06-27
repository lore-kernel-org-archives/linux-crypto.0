Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84830C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D33020656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ofcK2UZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfF0MEB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:04:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42842 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfF0MEA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:04:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so2242463wrl.9
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QoUaherJ4F3F3g9tyzF2ERxp8zs0Ke+hm33rT1mESmo=;
        b=ofcK2UZEkqhdTXRFOtqG74JI3NMc8mKubxVGoCg+reiDXkLB8T1WLmFotv/kzsR84y
         NXCw+AOcwt+EppJ7OjPfBfg6z2ARXbJt5ye3Us5JT9Vr1y7y2UNaMuha99euUUuDp8TT
         PDCH2nV8W/xhOmBpDNjR4d+S24PishygY0+B6EU1o6q+tM36MfjyQDVjE3IyDLovKYCX
         w+vD97OjUoVfWogwwEhK6mfiswGONLQ2GkgCbwdU8LtjSdsVGSfg8WiL4O3ayzIyNQY2
         Qt9XCMODH7gGW0ZdwTU35K65/2ITas+ST4FMGJGnn5uBECQplcRXmfo7xpw7Y7WUy/kn
         j4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QoUaherJ4F3F3g9tyzF2ERxp8zs0Ke+hm33rT1mESmo=;
        b=qUu712KSxsKhFpe6o9mvQaY+0EFuzGJJCBYtThw6nmySHF8ZuoX398V0U4RvbURuEe
         pKNbSkprzq2T4RnczL+2XbYeouebNWc/P07+jkckr51QThExT4C/GbWVMXFZz//3hBpK
         wf1IcjGY/p3an5PgqQw1NWJFBmBKfDR3xcwha0/xup+O5CaWZZZy299AhIhQmwfReS7Q
         BLNPGnLkT4uG+2AGTAz4IQ91ZwslGTAu2fa/Jvs3mktzWaRZ3D/LKSOYfo1CQWf3jZCP
         /Lzq83klzepLOkdMpjH8cjnHjCbwmGBOcKFm+OzMw3xUMn166RH1MAPr1DlSnX9t3y4X
         ONxg==
X-Gm-Message-State: APjAAAWFRst58PNoh7UNFtuk2mCUV0RuBQnydGQbBSZS9HBnCYi2aNBA
        ac6v4xeqvMg5CTh37rddxn6scxizO2y0nA==
X-Google-Smtp-Source: APXvYqyNRHxiC11p7WzIKTM6u8hK60HnjJIgdBjLOwPLAqBTWAwg2irXP9aTRqEPznoUnCk8msjdJg==
X-Received: by 2002:a5d:4909:: with SMTP id x9mr2823052wrq.226.1561637036942;
        Thu, 27 Jun 2019 05:03:56 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 28/30] crypto: x86/des - switch to library interface
Date:   Thu, 27 Jun 2019 14:03:12 +0200
Message-Id: <20190627120314.7197-29-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/des3_ede_glue.c | 42 +++++++++++---------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index ff6cca8d69eb..cce329b188d1 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -21,7 +21,7 @@
  */
 
 #include <crypto/algapi.h>
-#include <crypto/internal/des.h>
+#include <crypto/des.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
@@ -29,8 +29,8 @@
 #include <linux/types.h>
 
 struct des3_ede_x86_ctx {
-	u32 enc_expkey[DES3_EDE_EXPKEY_WORDS];
-	u32 dec_expkey[DES3_EDE_EXPKEY_WORDS];
+	struct des3_ede_ctx enc;
+	struct des3_ede_ctx dec;
 };
 
 /* regular block cipher functions */
@@ -44,7 +44,7 @@ asmlinkage void des3_ede_x86_64_crypt_blk_3way(const u32 *expkey, u8 *dst,
 static inline void des3_ede_enc_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 				    const u8 *src)
 {
-	u32 *enc_ctx = ctx->enc_expkey;
+	u32 *enc_ctx = ctx->enc.expkey;
 
 	des3_ede_x86_64_crypt_blk(enc_ctx, dst, src);
 }
@@ -52,7 +52,7 @@ static inline void des3_ede_enc_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 static inline void des3_ede_dec_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 				    const u8 *src)
 {
-	u32 *dec_ctx = ctx->dec_expkey;
+	u32 *dec_ctx = ctx->dec.expkey;
 
 	des3_ede_x86_64_crypt_blk(dec_ctx, dst, src);
 }
@@ -60,7 +60,7 @@ static inline void des3_ede_dec_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 static inline void des3_ede_enc_blk_3way(struct des3_ede_x86_ctx *ctx, u8 *dst,
 					 const u8 *src)
 {
-	u32 *enc_ctx = ctx->enc_expkey;
+	u32 *enc_ctx = ctx->enc.expkey;
 
 	des3_ede_x86_64_crypt_blk_3way(enc_ctx, dst, src);
 }
@@ -68,7 +68,7 @@ static inline void des3_ede_enc_blk_3way(struct des3_ede_x86_ctx *ctx, u8 *dst,
 static inline void des3_ede_dec_blk_3way(struct des3_ede_x86_ctx *ctx, u8 *dst,
 					 const u8 *src)
 {
-	u32 *dec_ctx = ctx->dec_expkey;
+	u32 *dec_ctx = ctx->dec.expkey;
 
 	des3_ede_x86_64_crypt_blk_3way(dec_ctx, dst, src);
 }
@@ -132,7 +132,7 @@ static int ecb_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct des3_ede_x86_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return ecb_crypt(req, ctx->enc_expkey);
+	return ecb_crypt(req, ctx->enc.expkey);
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
@@ -140,7 +140,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct des3_ede_x86_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return ecb_crypt(req, ctx->dec_expkey);
+	return ecb_crypt(req, ctx->dec.expkey);
 }
 
 static unsigned int __cbc_encrypt(struct des3_ede_x86_ctx *ctx,
@@ -358,24 +358,28 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 i, j, tmp;
 	int err;
 
-	err = crypto_des3_ede_verify_key(tfm, key);
-	if (unlikely(err))
-		return err;
+	err = des3_ede_expand_key(&ctx->enc, key, keylen);
+	if (err == -ENOKEY) {
+		if (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)
+			err = -EINVAL;
+		else
+			err = 0;
+	}
 
-	/* Generate encryption context using generic implementation. */
-	err = __des3_ede_setkey(ctx->enc_expkey, &tfm->crt_flags, key, keylen);
-	if (err < 0)
+	if (err) {
+		memzero_explicit(ctx, sizeof(*ctx));
 		return err;
+	}
 
 	/* Fix encryption context for this implementation and form decryption
 	 * context. */
 	j = DES3_EDE_EXPKEY_WORDS - 2;
 	for (i = 0; i < DES3_EDE_EXPKEY_WORDS; i += 2, j -= 2) {
-		tmp = ror32(ctx->enc_expkey[i + 1], 4);
-		ctx->enc_expkey[i + 1] = tmp;
+		tmp = ror32(ctx->enc.expkey[i + 1], 4);
+		ctx->enc.expkey[i + 1] = tmp;
 
-		ctx->dec_expkey[j + 0] = ctx->enc_expkey[i + 0];
-		ctx->dec_expkey[j + 1] = tmp;
+		ctx->dec.expkey[j + 0] = ctx->enc.expkey[i + 0];
+		ctx->dec.expkey[j + 1] = tmp;
 	}
 
 	return 0;
-- 
2.20.1

