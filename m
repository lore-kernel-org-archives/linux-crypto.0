Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CC9C43217
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F01D6223E8
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgLaRZb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbgLaRZb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7450F224F4;
        Thu, 31 Dec 2020 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435473;
        bh=QswN+cSXOleQTv7jKXaF6pdOiygStZk2qsiKIqB19hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b93NIClbcXdLr3aWWCvKG+3zNpaQAfHK9J0ax4iMV7sxTrPS76kL6q2t0om0eF19u
         lewiBaW09+DMamylm6et0AwNJbPxe5j/tAN6vzpu6WVOvASJCi4FXvUEuGDwjEuXWn
         Sc8qpg3kuqKULqo4QMHvIr+BcWMuxp1V2OzEDZzNriDUGNlRc5sD0/N3h5oqNCsX25
         MCBJOUibpO9RbG2B5DUPKGEHbci6wbOSIodO37Sgu9/NzpSgtToAu/LN/7XKXTq95m
         yCyCE2qqzxBNsxFhm4r92gRaUk5oVctpa47D4bq0fROHKSdeSMTOmVpzkH+12RAw7e
         2UWGPcoeTAWoA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 19/21] crypto: x86/twofish - drop dependency on glue helper
Date:   Thu, 31 Dec 2020 18:23:35 +0100
Message-Id: <20201231172337.23073-20-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the glue helper dependency with implementations of ECB and CBC
based on the new CPP macros, which avoid the need for indirect calls.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/twofish_avx_glue.c  | 73 +++++-------------
 arch/x86/crypto/twofish_glue_3way.c | 80 ++++++--------------
 crypto/Kconfig                      |  2 -
 3 files changed, 44 insertions(+), 111 deletions(-)

diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 13f810b61034..6ce198f808a5 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -15,9 +15,10 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <crypto/twofish.h>
-#include <asm/crypto/glue_helper.h>
 #include <asm/crypto/twofish.h>
 
+#include "ecb_cbc_helpers.h"
+
 #define TWOFISH_PARALLEL_BLOCKS 8
 
 /* 8-way parallel cipher functions */
@@ -37,72 +38,38 @@ static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static const struct common_glue_ctx twofish_enc = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = twofish_ecb_enc_8way }
-	}, {
-		.num_blocks = 3,
-		.fn_u = { .ecb = twofish_enc_blk_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = twofish_enc_blk }
-	} }
-};
-
-static const struct common_glue_ctx twofish_dec = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = twofish_ecb_dec_8way }
-	}, {
-		.num_blocks = 3,
-		.fn_u = { .ecb = twofish_dec_blk_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = twofish_dec_blk }
-	} }
-};
-
-static const struct common_glue_ctx twofish_dec_cbc = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = TWOFISH_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = twofish_cbc_dec_8way }
-	}, {
-		.num_blocks = 3,
-		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .cbc = twofish_dec_blk }
-	} }
-};
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&twofish_enc, req);
+	ECB_WALK_START(req, TF_BLOCK_SIZE, TWOFISH_PARALLEL_BLOCKS);
+	ECB_BLOCK(TWOFISH_PARALLEL_BLOCKS, twofish_ecb_enc_8way);
+	ECB_BLOCK(3, twofish_enc_blk_3way);
+	ECB_BLOCK(1, twofish_enc_blk);
+	ECB_WALK_END();
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&twofish_dec, req);
+	ECB_WALK_START(req, TF_BLOCK_SIZE, TWOFISH_PARALLEL_BLOCKS);
+	ECB_BLOCK(TWOFISH_PARALLEL_BLOCKS, twofish_ecb_dec_8way);
+	ECB_BLOCK(3, twofish_dec_blk_3way);
+	ECB_BLOCK(1, twofish_dec_blk);
+	ECB_WALK_END();
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(twofish_enc_blk, req);
+	CBC_WALK_START(req, TF_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(twofish_enc_blk);
+	CBC_WALK_END();
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
-	return glue_cbc_decrypt_req_128bit(&twofish_dec_cbc, req);
+	CBC_WALK_START(req, TF_BLOCK_SIZE, TWOFISH_PARALLEL_BLOCKS);
+	CBC_DEC_BLOCK(TWOFISH_PARALLEL_BLOCKS, twofish_cbc_dec_8way);
+	CBC_DEC_BLOCK(3, twofish_dec_blk_cbc_3way);
+	CBC_DEC_BLOCK(1, twofish_dec_blk);
+	CBC_WALK_END();
 }
 
 static struct skcipher_alg twofish_algs[] = {
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 88252370db0a..d1fdefa5195a 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -5,17 +5,16 @@
  * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  */
 
-#include <asm/crypto/glue_helper.h>
 #include <asm/crypto/twofish.h>
 #include <crypto/algapi.h>
-#include <crypto/b128ops.h>
-#include <crypto/internal/skcipher.h>
 #include <crypto/twofish.h>
 #include <linux/crypto.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "ecb_cbc_helpers.h"
+
 EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);
 EXPORT_SYMBOL_GPL(twofish_dec_blk_3way);
 
@@ -30,79 +29,48 @@ static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-void twofish_dec_blk_cbc_3way(const void *ctx, u8 *d, const u8 *s)
+void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src)
 {
-	u128 ivs[2];
-	u128 *dst = (u128 *)d;
-	const u128 *src = (const u128 *)s;
-
-	ivs[0] = src[0];
-	ivs[1] = src[1];
+	u8 buf[2][TF_BLOCK_SIZE];
+	const u8 *s = src;
 
-	twofish_dec_blk_3way(ctx, (u8 *)dst, (u8 *)src);
+	if (dst == src)
+		s = memcpy(buf, src, sizeof(buf));
+	twofish_dec_blk_3way(ctx, dst, src);
+	crypto_xor(dst + TF_BLOCK_SIZE, s, sizeof(buf));
 
-	u128_xor(&dst[1], &dst[1], &ivs[0]);
-	u128_xor(&dst[2], &dst[2], &ivs[1]);
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-static const struct common_glue_ctx twofish_enc = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 3,
-		.fn_u = { .ecb = twofish_enc_blk_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = twofish_enc_blk }
-	} }
-};
-
-static const struct common_glue_ctx twofish_dec = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 3,
-		.fn_u = { .ecb = twofish_dec_blk_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = twofish_dec_blk }
-	} }
-};
-
-static const struct common_glue_ctx twofish_dec_cbc = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 3,
-		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .cbc = twofish_dec_blk }
-	} }
-};
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&twofish_enc, req);
+	ECB_WALK_START(req, TF_BLOCK_SIZE, -1);
+	ECB_BLOCK(3, twofish_enc_blk_3way);
+	ECB_BLOCK(1, twofish_enc_blk);
+	ECB_WALK_END();
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&twofish_dec, req);
+	ECB_WALK_START(req, TF_BLOCK_SIZE, -1);
+	ECB_BLOCK(3, twofish_dec_blk_3way);
+	ECB_BLOCK(1, twofish_dec_blk);
+	ECB_WALK_END();
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(twofish_enc_blk, req);
+	CBC_WALK_START(req, TF_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(twofish_enc_blk);
+	CBC_WALK_END();
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
-	return glue_cbc_decrypt_req_128bit(&twofish_dec_cbc, req);
+	CBC_WALK_START(req, TF_BLOCK_SIZE, -1);
+	CBC_DEC_BLOCK(3, twofish_dec_blk_cbc_3way);
+	CBC_DEC_BLOCK(1, twofish_dec_blk);
+	CBC_WALK_END();
 }
 
 static struct skcipher_alg tf_skciphers[] = {
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 25101558acb5..b2182658c55e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1711,7 +1711,6 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 	select CRYPTO_SKCIPHER
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
-	select CRYPTO_GLUE_HELPER_X86
 	help
 	  Twofish cipher algorithm (x86_64, 3-way parallel).
 
@@ -1730,7 +1729,6 @@ config CRYPTO_TWOFISH_AVX_X86_64
 	tristate "Twofish cipher algorithm (x86_64/AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_SKCIPHER
-	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
-- 
2.17.1

