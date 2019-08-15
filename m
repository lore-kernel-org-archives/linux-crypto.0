Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB1CC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27DA3218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F441Umy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfHOJCS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33104 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730823AbfHOJCS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id p77so592948wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uMoPWG7ZtNqmAOxM6E+qCA9KIAAzgWl56JeFS/8CuPA=;
        b=F441Umy/1KJ6iJyvfwZoAuD8zpROKzYiD0r0+XQQiL48PNrrojPbbLSaFEcn7jnyBD
         CcEKgpvvWc+2sLCSTb24PokyQHKybx4OxD9eJ/b1F9OkzE4cmOf7PKXk5IQL9i2gui2A
         ZIdGaAdUPq+i9C4o2lpp7SWCelAg0pE5WR2EVRPF76r7KxuCNpWD8Np34U26Z6trTVpE
         8c3ZtE/cf02jcoaCZCHdKb64wFv76enxWSe1Ux5LRDlkUK+7EPM4CFRw/Zq6QrPW6Ji2
         5GTK/MyT9kmdcYKxWylf4tW9BnPDHQUiVF7RnaCqka/J1i42xWmkyz7q9QzWMoH0Fnlu
         6/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uMoPWG7ZtNqmAOxM6E+qCA9KIAAzgWl56JeFS/8CuPA=;
        b=Kt7MvvexbgmkS1XNXf8EXD1OLJdw9CLRz7aO7NptrZ9lfN+6IN8Y6kP9fDakpKB/0I
         cuqnV/vX0bgH/8GSH1Azw6ABpGZ4mwxFFSEzuaMQjc3Cle/TynhzSNcs48fMTxWBz6WQ
         P7qZKSgtStihp9woXQNJiryv9c6vgTLVBmAA5ZoRcughe51fysiP5FOGTPJRIxFpOK5I
         J5j/v+H32+biRqGf0Ewu2jaLGbCdpdLu8x2aq9fCI3ue3Vel1hYfJn9OUAGIrmdm4XiO
         eTaaVkDHCPyAFKU9HrG83HSjZzwR6qLuIQJzlcDw/iaNaNa6BFK6xqLC0OXoAYXLfah/
         pyVA==
X-Gm-Message-State: APjAAAVbYFrIDZ00f/wj9dbuVk38VVA36C9zR32EJAJSp76CPtClf4JZ
        DOkw+U5aBiKEIohL5NARiJV6kTutNGFrLcoh
X-Google-Smtp-Source: APXvYqwkePq09Uwx7KU+zUf7kNn+P6rkZ48kbErsJrh+TrCOnb41k+pD9f2z5NvFyfhWyM4wcEte/w==
X-Received: by 2002:a7b:ca5a:: with SMTP id m26mr1600238wml.134.1565859736265;
        Thu, 15 Aug 2019 02:02:16 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 28/30] crypto: x86/des - switch to library interface
Date:   Thu, 15 Aug 2019 12:01:10 +0300
Message-Id: <20190815090112.9377-29-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/des3_ede_glue.c | 42 +++++++++++---------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index f730a312ce35..89830e531350 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -11,7 +11,7 @@
  */
 
 #include <crypto/algapi.h>
-#include <crypto/internal/des.h>
+#include <crypto/des.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
@@ -19,8 +19,8 @@
 #include <linux/types.h>
 
 struct des3_ede_x86_ctx {
-	u32 enc_expkey[DES3_EDE_EXPKEY_WORDS];
-	u32 dec_expkey[DES3_EDE_EXPKEY_WORDS];
+	struct des3_ede_ctx enc;
+	struct des3_ede_ctx dec;
 };
 
 /* regular block cipher functions */
@@ -34,7 +34,7 @@ asmlinkage void des3_ede_x86_64_crypt_blk_3way(const u32 *expkey, u8 *dst,
 static inline void des3_ede_enc_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 				    const u8 *src)
 {
-	u32 *enc_ctx = ctx->enc_expkey;
+	u32 *enc_ctx = ctx->enc.expkey;
 
 	des3_ede_x86_64_crypt_blk(enc_ctx, dst, src);
 }
@@ -42,7 +42,7 @@ static inline void des3_ede_enc_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 static inline void des3_ede_dec_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 				    const u8 *src)
 {
-	u32 *dec_ctx = ctx->dec_expkey;
+	u32 *dec_ctx = ctx->dec.expkey;
 
 	des3_ede_x86_64_crypt_blk(dec_ctx, dst, src);
 }
@@ -50,7 +50,7 @@ static inline void des3_ede_dec_blk(struct des3_ede_x86_ctx *ctx, u8 *dst,
 static inline void des3_ede_enc_blk_3way(struct des3_ede_x86_ctx *ctx, u8 *dst,
 					 const u8 *src)
 {
-	u32 *enc_ctx = ctx->enc_expkey;
+	u32 *enc_ctx = ctx->enc.expkey;
 
 	des3_ede_x86_64_crypt_blk_3way(enc_ctx, dst, src);
 }
@@ -58,7 +58,7 @@ static inline void des3_ede_enc_blk_3way(struct des3_ede_x86_ctx *ctx, u8 *dst,
 static inline void des3_ede_dec_blk_3way(struct des3_ede_x86_ctx *ctx, u8 *dst,
 					 const u8 *src)
 {
-	u32 *dec_ctx = ctx->dec_expkey;
+	u32 *dec_ctx = ctx->dec.expkey;
 
 	des3_ede_x86_64_crypt_blk_3way(dec_ctx, dst, src);
 }
@@ -122,7 +122,7 @@ static int ecb_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct des3_ede_x86_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return ecb_crypt(req, ctx->enc_expkey);
+	return ecb_crypt(req, ctx->enc.expkey);
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
@@ -130,7 +130,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct des3_ede_x86_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return ecb_crypt(req, ctx->dec_expkey);
+	return ecb_crypt(req, ctx->dec.expkey);
 }
 
 static unsigned int __cbc_encrypt(struct des3_ede_x86_ctx *ctx,
@@ -348,24 +348,28 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
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
+		memset(ctx, 0, sizeof(*ctx));
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
2.17.1

