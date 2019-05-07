Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D94AC004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7B482087F
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Zz0b/Ltw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfEGQOC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 12:14:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45210 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfEGQNf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 12:13:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id e24so8887974pfi.12
        for <linux-crypto@vger.kernel.org>; Tue, 07 May 2019 09:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Pdo2fDDScMJxI15GIUPVgXWJIP7ArFHUMTEq/Lf9Zv8=;
        b=Zz0b/LtwgZrzNFkuiEEiWHaYLP93VeTNLBgNkOCZhOS1anyRhOevXHzi7tcEJu70Dt
         rl9zS0AMhyK/hQTX1Dls/CjIGHL3KAlpRXJGKDwz66abAthefKlGqGr3Nc5yfhaR3kdk
         /21NsWLCC7lJC4bP8LBYyeyKqg9kVsLJakAa4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Pdo2fDDScMJxI15GIUPVgXWJIP7ArFHUMTEq/Lf9Zv8=;
        b=pSytTaHbFPgcayvTLd+txjY3Q8IYEQL0gF3WLEgIU0mDwpUf1w7SnsC2U8U9ZLeewf
         L28UWc3rtj6I6kSJ2GZ4zgOEKi3/6NTYP2dYSlM4+/IfO3X5SJ/2UIsHN/HEc7EfdBht
         eG50lOvAbvjd8zY6nqwjUnXYNZ+5cmlkjrWjsvkfz8suOwle4TwgpbAwegISMlc/2UIf
         YnhE919UZD1IpTPXVu0sZ91wFj0EEJY5OpBnwOmkmO1Em7+ZEC3ILIPPEL978QCh0/B8
         Pp6nnfNMJVb2oCgQ6f7yY5j3+CRRTv5D2Zr18AJ2XLV0D4RaBkGIkKNCTJyiPp6OhEDE
         OAeg==
X-Gm-Message-State: APjAAAVcqzFRMazSD4PI2cNofPD4oKYDH9IboRaMbjCAgIVxJ6cuRv79
        A0w1zPqdByVVOEvFgvkNxbF7Lw==
X-Google-Smtp-Source: APXvYqzQFT6xa8JDTpTl0sGVkqI+BoD4/0Vgk+aIQRVcxNo0JN4QX2WqTaadN98jgYPmKbJURmesww==
X-Received: by 2002:a62:e718:: with SMTP id s24mr19331776pfh.247.1557245614661;
        Tue, 07 May 2019 09:13:34 -0700 (PDT)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id r18sm18377481pfd.89.2019.05.07.09.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 09:13:30 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>,
        Eric Biggers <ebiggers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v3 3/7] crypto: x86/camellia: Use new glue function macros
Date:   Tue,  7 May 2019 09:13:17 -0700
Message-Id: <20190507161321.34611-4-keescook@chromium.org>
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
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 73 +++++++++-------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 63 +++++++------------
 arch/x86/crypto/camellia_glue.c            | 21 +++----
 arch/x86/include/asm/crypto/camellia.h     | 64 ++++++-------------
 4 files changed, 80 insertions(+), 141 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index d4992e458f92..863a336fd4f5 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -24,20 +24,12 @@
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
 /* 32-way AVX2/AES-NI parallel cipher functions */
-asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-
-asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-
-asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+CAMELLIA_GLUE(camellia_ecb_enc_32way);
+CAMELLIA_GLUE(camellia_ecb_dec_32way);
+CAMELLIA_GLUE_CBC(camellia_cbc_dec_32way);
+CAMELLIA_GLUE_CTR(camellia_ctr_32way);
+CAMELLIA_GLUE_XTS(camellia_xts_enc_32way);
+CAMELLIA_GLUE_XTS(camellia_xts_dec_32way);
 
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 4,
@@ -45,16 +37,16 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_32way) }
+		.fn_u = { .ecb = camellia_ecb_enc_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -64,16 +56,16 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_32way) }
+		.fn_u = { .ctr = camellia_ctr_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -83,13 +75,13 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_32way) }
+		.fn_u = { .xts = camellia_xts_enc_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -99,16 +91,16 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_32way) }
+		.fn_u = { .ecb = camellia_ecb_dec_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk_glue }
 	} }
 };
 
@@ -118,16 +110,16 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_32way) }
+		.fn_u = { .cbc = camellia_cbc_dec_32way_cbc_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way_cbc_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk_cbc_glue }
 	} }
 };
 
@@ -137,13 +129,13 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_32way) }
+		.fn_u = { .xts = camellia_xts_dec_32way_glue }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -166,8 +158,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -185,8 +176,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
@@ -195,8 +185,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index d09f6521466a..182c23180377 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -11,7 +11,6 @@
  */
 
 #include <asm/crypto/camellia.h>
-#include <asm/crypto/glue_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <crypto/xts.h>
@@ -23,41 +22,22 @@
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
-
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
-
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
-
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_ctr_16way);
-
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
-
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
 
 void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_enc_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_enc_blk);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_enc);
 
 void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_dec_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_dec_blk_glue);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_dec);
 
@@ -67,13 +47,13 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -83,13 +63,13 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -99,10 +79,10 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -112,13 +92,13 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk_glue }
 	} }
 };
 
@@ -128,13 +108,13 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way_cbc_glue }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk_cbc_glue }
 	} }
 };
 
@@ -144,10 +124,10 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -170,8 +150,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -212,7 +191,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+				   camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
@@ -222,7 +201,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+				   camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index dcd5e0f71b00..23173046a609 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -1320,7 +1320,7 @@ void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 	le128_to_be128(&ctrblks[1], iv);
 	le128_inc(iv);
 
-	camellia_enc_blk_xor_2way(ctx, (u8 *)dst, (u8 *)ctrblks);
+	camellia_enc_blk_2way_xor(ctx, (u8 *)dst, (u8 *)ctrblks);
 }
 EXPORT_SYMBOL_GPL(camellia_crypt_ctr_2way);
 
@@ -1330,10 +1330,10 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -1343,10 +1343,10 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -1356,10 +1356,10 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk_glue }
 	} }
 };
 
@@ -1369,10 +1369,10 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk_cbc_glue }
 	} }
 };
 
@@ -1388,8 +1388,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index a5d86fc0593f..4a55b037c422 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -2,6 +2,7 @@
 #ifndef ASM_X86_CAMELLIA_H
 #define ASM_X86_CAMELLIA_H
 
+#include <asm/crypto/glue_helper.h>
 #include <crypto/b128ops.h>
 #include <linux/crypto.h>
 #include <linux/kernel.h>
@@ -24,6 +25,12 @@ struct camellia_xts_ctx {
 	struct camellia_ctx crypt_ctx;
 };
 
+#define CAMELLIA_GLUE(func)	GLUE_CAST(func, camellia_ctx)
+#define CAMELLIA_GLUE_XOR(func)	GLUE_CAST_XOR(func, camellia_ctx)
+#define CAMELLIA_GLUE_CBC(func)	GLUE_CAST_CBC(func, camellia_ctx)
+#define CAMELLIA_GLUE_CTR(func)	GLUE_CAST_CTR(func, camellia_ctx)
+#define CAMELLIA_GLUE_XTS(func)	GLUE_CAST_XTS(func, camellia_ctx)
+
 extern int __camellia_setkey(struct camellia_ctx *cctx,
 			     const unsigned char *key,
 			     unsigned int key_len, u32 *flags);
@@ -32,56 +39,21 @@ extern int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			       unsigned int keylen);
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+CAMELLIA_GLUE_XOR(camellia_enc_blk);
+CAMELLIA_GLUE(camellia_dec_blk);
+CAMELLIA_GLUE_CBC(camellia_dec_blk);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+CAMELLIA_GLUE_XOR(camellia_enc_blk_2way);
+CAMELLIA_GLUE(camellia_dec_blk_2way);
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-
-static inline void camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				    const u8 *src)
-{
-	__camellia_enc_blk(ctx, dst, src, false);
-}
-
-static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__camellia_enc_blk(ctx, dst, src, true);
-}
-
-static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					 const u8 *src)
-{
-	__camellia_enc_blk_2way(ctx, dst, src, false);
-}
-
-static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8 *dst,
-					     const u8 *src)
-{
-	__camellia_enc_blk_2way(ctx, dst, src, true);
-}
+CAMELLIA_GLUE(camellia_ecb_enc_16way);
+CAMELLIA_GLUE(camellia_ecb_dec_16way);
+CAMELLIA_GLUE_CBC(camellia_cbc_dec_16way);
+CAMELLIA_GLUE_CTR(camellia_ctr_16way);
+CAMELLIA_GLUE_XTS(camellia_xts_enc_16way);
+CAMELLIA_GLUE_XTS(camellia_xts_dec_16way);
 
 /* glue helpers */
 extern void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src);
-- 
2.17.1

