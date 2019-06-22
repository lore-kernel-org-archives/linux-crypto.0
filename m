Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0973AC4646C
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2FFD2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SnxxU/+1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfFVAcR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50959 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfFVAcR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id c66so7736085wmf.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MVcWeMwNTv13v+WqRc8HlJLKxMyNI5qCt4nrC5wTvjo=;
        b=SnxxU/+1YIkAksFjBl7jlWcjEgLlSQvEIKU5f3Y5jXNHiT1x2bO7m4NUwScl+HqnTd
         dqGBCq93hYTszUOjMlAXazCf6ZWWLqYxGWR7EuQpfAZguIwL4rqN251VeIYmAbbFM0SH
         b/CErMBQh532OAlfZMtZgx0LKohy7V168TIM40QLDmb8Js3DI9KL797mzOYi3dk5Mfb1
         s2GtekeIRNMGoYo0JO2aR9VUvR9lBKSzvpGw8fh5ro7zIPoQ8FjF9mcJnqjYYWEEdO/u
         wYjumyIP+qBdDhwUQidqfM0Imm/dvXkkU+Qvu8wYzOMtgj57wEcSS8HY+QPpphVSv6Oe
         7kuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MVcWeMwNTv13v+WqRc8HlJLKxMyNI5qCt4nrC5wTvjo=;
        b=MK8YmtkaELjM7gzvxlKxgDvNHXNr5FBxR1GAEoGwvZvit76DUz2wx2xjUJFNGPAptf
         gJa0XQnEqgeADlTnQEpdV1rYFjlcNkUe8AsNELWN28M2JZ3m4Rz33gS13hYL3G99uXcc
         kuAOse+Is5ZyhwZCIZyi/4Um+WrB5to1o514J/XW10SI5nyljKVCR/G7lYhFPFJyv3pK
         XjjGe7m/erUbAJpb8xpb48PDHBvvPtfivofA3AFIXVeGjINoETW9PpSeoYfkCXQ0dmVm
         BWXKdWYBEqF8DyeXbhJDN7ysrRYjUorH0kbTXaVEP9WaDb8+2p1XePrYeSIpPKW5wEUr
         Oq8g==
X-Gm-Message-State: APjAAAUX/az1y9Zxe3o1tDrL8FsI3ay5QLmwD52nvsQ4i76pGw0r+8H2
        8ynnfkc3CloNJ5XHx4hd6yczB62sX4PVQpqr
X-Google-Smtp-Source: APXvYqyxf4I2l4C0cUHx0NIEi5Kf97N4rA3Kq0lLCkj7Cy+c8nIDSrlCBD8c9zuLYbHjDmxucRB3Pg==
X-Received: by 2002:a05:600c:2201:: with SMTP id z1mr5301146wml.59.1561163534021;
        Fri, 21 Jun 2019 17:32:14 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 28/30] crypto: x86/des - switch to library interface
Date:   Sat, 22 Jun 2019 02:31:10 +0200
Message-Id: <20190622003112.31033-29-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/des3_ede_glue.c | 39 ++++++++++----------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index 571966e5c542..9c743246f5ad 100644
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
@@ -358,24 +358,25 @@ static int des3_ede_x86_setkey(struct crypto_tfm *tfm, const u8 *key,
 	u32 i, j, tmp;
 	int err;
 
-	err = des3_ede_verify_key(tfm, key, keylen);
-	if (unlikely(err))
-		return err;
+	err = des3_ede_expand_key(&ctx->enc, key, keylen);
+	if (err == -ENOKEY &&
+	    !(crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))
+		err = 0;
 
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

