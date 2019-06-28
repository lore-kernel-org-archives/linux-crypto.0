Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F8BC5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D188208E3
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sy6VsdaN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfF1JgL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33757 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfF1JgK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so8945148wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N2BlLzFuQehpzWwGcUqNkw7wuytXhknZeoPcZaYTlhI=;
        b=sy6VsdaNSyMFgmFJUCxIU6iej6cfiNWWZU0aRTHLOW19zyFo/3tshhtcWuIrSmQcrX
         H0yK3ltIQywTitvKecqzyA1GIWHZpn2THfGf7PVU477vbyAGBT+GhZb7RGm7opP1rjjY
         fVzoqtiWw8x25KGC4s5rSwbBc/6R9dIDZpVLMaiL19JmUNj+SV24GwuSFdgFnrIKbyDw
         X1cUPb5eElJhZMHGE9MH8WWIThCMPIsnX8a0VQHF4uBWWfj0rj2Ia8D8XfDBdqnaFqJY
         oGWT67cqpFF8QjnXfFaT+Jk5YlV9NqgnDADHyqHLj5SHLL1j0IWdI3WVP3+PapHg3t9B
         WVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N2BlLzFuQehpzWwGcUqNkw7wuytXhknZeoPcZaYTlhI=;
        b=eeOzZpR5IgDXdpmcDbthRej69mI1gHK5vn51f/fDNlUGjTY9gZlHiJ0OE0MjtmcxVX
         oNDLkFbePVWKS5rE1MxKmRABSfebuJOZYCV3KENiV3QMUi7/g2NUWMNDQk995ZLycfMd
         BAmlzCjvFheY5bIG9g4QnV5pEWnfOlmPseXqF8Po9DXwqoqs4n6kqxvhsPlGFkl7LDqo
         /+lYFCDdOks3yUa18pNRTy7+LpmwhlqVd6ybQllGn1yYbhIPdh7nDqPHhE/2DUDPaHfW
         HLSSbvfid/2JJCtR23MQZjvqdYH67DiVM9wdPA416BjEmJYMP6gpnB/2hnrLTVHOopcq
         E1sQ==
X-Gm-Message-State: APjAAAXa/KfdQDSRRcB3qnicS9KmABSzOaIX0S6qwEfOqD5mhWV34CEO
        Oo6wQ9ZOjlLzgearsXJApMTWTMAjtA8BSg==
X-Google-Smtp-Source: APXvYqw9h603uxFQYP9HdxP9WNAZTk9ZWgkj4WhpUQ1onZWaVOW0xP4Yu79lhQTbDGyO2GXKqelxhQ==
X-Received: by 2002:a1c:a654:: with SMTP id p81mr6211235wme.36.1561714568619;
        Fri, 28 Jun 2019 02:36:08 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 28/30] crypto: x86/des - switch to library interface
Date:   Fri, 28 Jun 2019 11:35:27 +0200
Message-Id: <20190628093529.12281-29-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
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
index dfee4cec9452..cce329b188d1 100644
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
-	if (err)
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

