Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1B8C04AAD
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80AD320825
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HXFTi8/H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfEGQNh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 12:13:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37055 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfEGQNh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 12:13:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id e6so8550690pgc.4
        for <linux-crypto@vger.kernel.org>; Tue, 07 May 2019 09:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OLFjOKOIpgl1sQZOZV5HokWwcV9dbLiuY0v43zeEmqQ=;
        b=HXFTi8/HkXpDU2PFc2Mw/IOZVdlwyapj689DH54ZoPz+yO0undbmi8zJAEfB8418H+
         UPifeze559M22KJpXabF8HhoZ0l0NsBloTQzNp69+H5aOtO/xkRyfk6vgtz8+nL1OJr8
         T1SLlyLNAWEwfNz6f9yPvsndn30YAJba3tCQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OLFjOKOIpgl1sQZOZV5HokWwcV9dbLiuY0v43zeEmqQ=;
        b=AdwniesLM2yC4qJDzQLQIytSLX81LJXqWnA/N2aMEgzEbSjbj+qAD/tfMWBkWY67Bw
         GldQaw7Fhq/O+pKk7q9RWBrcYXRZxxrfK990TOVemhwr7V89ZcY/Zu/UXYL+bs8AZZlM
         zYUjCneCu/mjfk76zUYOqx+rotg4Z6yA80h31IuPsxiXis1shiArHP3VoEdfLsknMt6b
         ftL0fXvUWSeognpBMl73NPG0hqynkU/nNv2ovNT0e3Dx/ysrIfJV5gdaK58aWAvBDy5g
         NguG+K2sXvrOL1oqhRnaZCLxBdaQl2FX6IOzdy1aTmJsGHy39X3ejsFps9fGMVn+ZUif
         skOQ==
X-Gm-Message-State: APjAAAU1QVYzXv2NmODYQjTL0XMYR6eqkk5xW6QItvOCMcItw86n9Hjm
        Ke+BYSYVlafR172KKOUpEmvplQ==
X-Google-Smtp-Source: APXvYqytnwDZUzLfiiZ5lHq0t5TNqV9NlHs0qSDDmEJn3fGPAQjSkryopq9cUSFH+6iFRLtvY0rKSA==
X-Received: by 2002:aa7:8392:: with SMTP id u18mr43242175pfm.217.1557245616548;
        Tue, 07 May 2019 09:13:36 -0700 (PDT)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id v1sm7827259pgb.85.2019.05.07.09.13.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 09:13:34 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>,
        Eric Biggers <ebiggers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v3 5/7] crypto: x86/cast6: Use new glue function macros
Date:   Tue,  7 May 2019 09:13:19 -0700
Message-Id: <20190507161321.34611-6-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Joao Moreira <jmoreira@suse.de>

Convert to function declaration macros from function prototype casts
to avoid trigger Control-Flow Integrity checks during indirect function
calls.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/cast6_avx_glue.c | 65 +++++++++++++++-----------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 18965c39305e..4735cd0ef379 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -35,20 +35,20 @@
 
 #define CAST6_PARALLEL_BLOCKS 8
 
-asmlinkage void cast6_ecb_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ecb_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-
-asmlinkage void cast6_cbc_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u8 *src,
-			       le128 *iv);
-
-asmlinkage void cast6_xts_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-asmlinkage void cast6_xts_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+#define CAST6_GLUE(func)	GLUE_CAST(func, cast6_ctx)
+#define CAST6_GLUE_CBC(func)	GLUE_CAST_CBC(func, cast6_ctx)
+#define CAST6_GLUE_CTR(func)	GLUE_CAST_CTR(func, cast6_ctx)
+#define CAST6_GLUE_XTS(func)	GLUE_CAST_XTS(func, cast6_ctx)
+
+CAST6_GLUE(__cast6_encrypt);
+CAST6_GLUE(__cast6_decrypt);
+CAST6_GLUE(cast6_ecb_enc_8way);
+CAST6_GLUE(cast6_ecb_dec_8way);
+CAST6_GLUE_CBC(cast6_cbc_dec_8way);
+CAST6_GLUE_CBC(__cast6_decrypt);
+CAST6_GLUE_CTR(cast6_ctr_8way);
+CAST6_GLUE_XTS(cast6_xts_enc_8way);
+CAST6_GLUE_XTS(cast6_xts_dec_8way);
 
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
@@ -58,14 +58,12 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 
 static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_encrypt_glue);
 }
 
 static void cast6_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_decrypt_glue);
 }
 
 static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
@@ -85,10 +83,10 @@ static const struct common_glue_ctx cast6_enc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_enc_8way) }
+		.fn_u = { .ecb = cast6_ecb_enc_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_encrypt) }
+		.fn_u = { .ecb = __cast6_encrypt_glue }
 	} }
 };
 
@@ -98,10 +96,10 @@ static const struct common_glue_ctx cast6_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_ctr_8way) }
+		.fn_u = { .ctr = cast6_ctr_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr) }
+		.fn_u = { .ctr = cast6_crypt_ctr }
 	} }
 };
 
@@ -111,10 +109,10 @@ static const struct common_glue_ctx cast6_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc_8way) }
+		.fn_u = { .xts = cast6_xts_enc_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc) }
+		.fn_u = { .xts = cast6_xts_enc }
 	} }
 };
 
@@ -124,10 +122,10 @@ static const struct common_glue_ctx cast6_dec = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_dec_8way) }
+		.fn_u = { .ecb = cast6_ecb_dec_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .ecb = __cast6_decrypt_glue }
 	} }
 };
 
@@ -137,10 +135,10 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_cbc_dec_8way) }
+		.fn_u = { .cbc = cast6_cbc_dec_8way_cbc_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .cbc = __cast6_decrypt_cbc_glue }
 	} }
 };
 
@@ -150,10 +148,10 @@ static const struct common_glue_ctx cast6_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec_8way) }
+		.fn_u = { .xts = cast6_xts_dec_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec) }
+		.fn_u = { .xts = cast6_xts_dec }
 	} }
 };
 
@@ -169,8 +167,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__cast6_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__cast6_encrypt_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -215,7 +212,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&cast6_enc_xts, req,
-				   XTS_TWEAK_CAST(__cast6_encrypt),
+				   __cast6_encrypt_glue,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
@@ -225,7 +222,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&cast6_dec_xts, req,
-				   XTS_TWEAK_CAST(__cast6_encrypt),
+				   __cast6_encrypt_glue,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
-- 
2.17.1

