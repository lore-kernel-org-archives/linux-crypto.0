Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C622CC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9768C216B7
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ufjjEcrg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbfHERCd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39561 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbfHERCb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so31972029wrt.6
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uMoPWG7ZtNqmAOxM6E+qCA9KIAAzgWl56JeFS/8CuPA=;
        b=ufjjEcrg/2Jv/d51R7cDrKbAvrREURUhkX4Dfm8DPcIUtLmY4dZVWaMAoZVJw6ICvt
         qXvxQY/flcD10W88Et37euPeHlCIHbf+MMTotJLR7E6vulsQtPDM7atoBDXYwow/hOko
         7a1R0jM6mtUahtGHTFtM8RPJo+ZxY24z1WLAv3CNyX8VQLrOKmIZNbdK3rHGM65pAqw4
         RFjB4Yg1TbYEFjjgrcbHwaeQPjbzBL1FyEQ9dIkoHCvtPYCLe9SHdyMGFWjnAD1j96AB
         YnaXXgyZNrsqU5z/vbbFZ2/NY/Nv8SLUCt+ehWHdncO5OWu9T7vF+/Rsz12sIWD7DfZu
         umEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uMoPWG7ZtNqmAOxM6E+qCA9KIAAzgWl56JeFS/8CuPA=;
        b=cMl7l9+sha+FNdygJnD2Nodp/LHHZq9WA1suI8RTTKZwzQ+H+3cExRNGkDmstQeHYW
         Qe212pRDQs+sZ89FjkNx1WRUmfGtpZNjsVFeJ02UkbyA8zf+NCdJaOr7vuOojYtR5/oD
         jQsWe6L16byN8I0PzVe00J3ScZC854tvx4R+J4LLDPkJpv53lFx0yQjVC/LzogdPIOFI
         1f3XgEEw+1IIKDKEUbsOW6lyEjP9yU6sYW/iNJTBwgtw1SoLRbreiJowXwBe+cqOxyS8
         6glqzJtmHJMU12urh4BEK1hrX+C47P0n7a1PHgDFT6EwayJdH6wBzX/E1k31UQ9s0LzY
         hz/Q==
X-Gm-Message-State: APjAAAWRGFNzMPc7e/w6RLThDFVe0R9jGD6tP5cKSNNC0OCzeCO0dNTp
        P8SiGKU/2JaXBX5jEKc6yLIAj7cbNwcD/w==
X-Google-Smtp-Source: APXvYqxCudVRILPYoxP8jEMu4VaeqEDrjv14njNJaqnGVhpNV9ybFKmowzCWvOlPNq9aEkYGwTzqFA==
X-Received: by 2002:adf:e343:: with SMTP id n3mr125259830wrj.103.1565024549785;
        Mon, 05 Aug 2019 10:02:29 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 28/30] crypto: x86/des - switch to library interface
Date:   Mon,  5 Aug 2019 20:00:35 +0300
Message-Id: <20190805170037.31330-29-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
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

