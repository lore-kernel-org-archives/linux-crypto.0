Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA6EC432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BA4223E8
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbgLaRZa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727094AbgLaRZ3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 623A6224D2;
        Thu, 31 Dec 2020 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435466;
        bh=kHQp5VXN9RcfosAkXgXkihxIjrqsHUOoSM9ko0R2Q3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfiqT114xI3ozoEVYkkMJwhSQMs6MVWqLKK32STyTdRn0u6Qjw9lrJdGMlt9bQ63i
         1s33PvNKYI3P3kHGKOx70cAnZ37PBFL+HPTB7dh2vP/FEMzM+mbRLbGmNnNZ2zvBpF
         rbtrY9OE8CcKq9pVQ7xQhgyRCL8aWxTmf89wrkrZKbxTwHOZ2DrXkJ28Gv5wshISw0
         xCCU1mYHvoCK2nHoAPiVNmeBx0a9VJGIrRNwPoSVhxpLLfdUecki2ZUc07KU7p7GCx
         Z+gA/87aVvLD/1TzOc8vDG+W/8IFtkFZ6IbXoO9Q+Bvi51O8N9O/3V2ZHoY9b8VoYN
         2tkirFhDP0Hqw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 15/21] crypto: x86/camellia - drop dependency on glue helper
Date:   Thu, 31 Dec 2020 18:23:31 +0100
Message-Id: <20201231172337.23073-16-ardb@kernel.org>
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
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 85 ++++++--------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 73 +++++------------
 arch/x86/crypto/camellia_glue.c            | 61 ++++----------
 crypto/Kconfig                             |  2 -
 4 files changed, 60 insertions(+), 161 deletions(-)

diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index 8f25a2a6222e..ef5c0f094584 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -6,7 +6,6 @@
  */
 
 #include <asm/crypto/camellia.h>
-#include <asm/crypto/glue_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <linux/crypto.h>
@@ -14,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "ecb_cbc_helpers.h"
+
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
@@ -23,63 +24,6 @@ asmlinkage void camellia_ecb_dec_32way(const void *ctx, u8 *dst, const u8 *src);
 
 asmlinkage void camellia_cbc_dec_32way(const void *ctx, u8 *dst, const u8 *src);
 
-static const struct common_glue_ctx camellia_enc = {
-	.num_funcs = 4,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = camellia_ecb_enc_32way }
-	}, {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = camellia_ecb_enc_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .ecb = camellia_enc_blk_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = camellia_enc_blk }
-	} }
-};
-
-static const struct common_glue_ctx camellia_dec = {
-	.num_funcs = 4,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = camellia_ecb_dec_32way }
-	}, {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = camellia_ecb_dec_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .ecb = camellia_dec_blk_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = camellia_dec_blk }
-	} }
-};
-
-static const struct common_glue_ctx camellia_dec_cbc = {
-	.num_funcs = 4,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = camellia_cbc_dec_32way }
-	}, {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = camellia_cbc_dec_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .cbc = camellia_dec_blk }
-	} }
-};
-
 static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
@@ -88,22 +32,39 @@ static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 static int ecb_encrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&camellia_enc, req);
+	ECB_WALK_START(req, CAMELLIA_BLOCK_SIZE, CAMELLIA_AESNI_PARALLEL_BLOCKS);
+	ECB_BLOCK(CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS, camellia_ecb_enc_32way);
+	ECB_BLOCK(CAMELLIA_AESNI_PARALLEL_BLOCKS, camellia_ecb_enc_16way);
+	ECB_BLOCK(2, camellia_enc_blk_2way);
+	ECB_BLOCK(1, camellia_enc_blk);
+	ECB_WALK_END();
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&camellia_dec, req);
+	ECB_WALK_START(req, CAMELLIA_BLOCK_SIZE, CAMELLIA_AESNI_PARALLEL_BLOCKS);
+	ECB_BLOCK(CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS, camellia_ecb_dec_32way);
+	ECB_BLOCK(CAMELLIA_AESNI_PARALLEL_BLOCKS, camellia_ecb_dec_16way);
+	ECB_BLOCK(2, camellia_dec_blk_2way);
+	ECB_BLOCK(1, camellia_dec_blk);
+	ECB_WALK_END();
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
+	CBC_WALK_START(req, CAMELLIA_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(camellia_enc_blk);
+	CBC_WALK_END();
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
-	return glue_cbc_decrypt_req_128bit(&camellia_dec_cbc, req);
+	CBC_WALK_START(req, CAMELLIA_BLOCK_SIZE, CAMELLIA_AESNI_PARALLEL_BLOCKS);
+	CBC_DEC_BLOCK(CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS, camellia_cbc_dec_32way);
+	CBC_DEC_BLOCK(CAMELLIA_AESNI_PARALLEL_BLOCKS, camellia_cbc_dec_16way);
+	CBC_DEC_BLOCK(2, camellia_decrypt_cbc_2way);
+	CBC_DEC_BLOCK(1, camellia_dec_blk);
+	CBC_WALK_END();
 }
 
 static struct skcipher_alg camellia_algs[] = {
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 22a89cdfedfb..68fed0a79889 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -6,7 +6,6 @@
  */
 
 #include <asm/crypto/camellia.h>
-#include <asm/crypto/glue_helper.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <linux/crypto.h>
@@ -14,6 +13,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "ecb_cbc_helpers.h"
+
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
@@ -26,54 +27,6 @@ EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
 asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
 
-static const struct common_glue_ctx camellia_enc = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = camellia_ecb_enc_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .ecb = camellia_enc_blk_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = camellia_enc_blk }
-	} }
-};
-
-static const struct common_glue_ctx camellia_dec = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = camellia_ecb_dec_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .ecb = camellia_dec_blk_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = camellia_dec_blk }
-	} }
-};
-
-static const struct common_glue_ctx camellia_dec_cbc = {
-	.num_funcs = 3,
-	.fpu_blocks_limit = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = camellia_cbc_dec_16way }
-	}, {
-		.num_blocks = 2,
-		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .cbc = camellia_dec_blk }
-	} }
-};
-
 static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
@@ -82,22 +35,36 @@ static int camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 static int ecb_encrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&camellia_enc, req);
+	ECB_WALK_START(req, CAMELLIA_BLOCK_SIZE, CAMELLIA_AESNI_PARALLEL_BLOCKS);
+	ECB_BLOCK(CAMELLIA_AESNI_PARALLEL_BLOCKS, camellia_ecb_enc_16way);
+	ECB_BLOCK(2, camellia_enc_blk_2way);
+	ECB_BLOCK(1, camellia_enc_blk);
+	ECB_WALK_END();
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&camellia_dec, req);
+	ECB_WALK_START(req, CAMELLIA_BLOCK_SIZE, CAMELLIA_AESNI_PARALLEL_BLOCKS);
+	ECB_BLOCK(CAMELLIA_AESNI_PARALLEL_BLOCKS, camellia_ecb_dec_16way);
+	ECB_BLOCK(2, camellia_dec_blk_2way);
+	ECB_BLOCK(1, camellia_dec_blk);
+	ECB_WALK_END();
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
+	CBC_WALK_START(req, CAMELLIA_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(camellia_enc_blk);
+	CBC_WALK_END();
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
-	return glue_cbc_decrypt_req_128bit(&camellia_dec_cbc, req);
+	CBC_WALK_START(req, CAMELLIA_BLOCK_SIZE, CAMELLIA_AESNI_PARALLEL_BLOCKS);
+	CBC_DEC_BLOCK(CAMELLIA_AESNI_PARALLEL_BLOCKS, camellia_cbc_dec_16way);
+	CBC_DEC_BLOCK(2, camellia_decrypt_cbc_2way);
+	CBC_DEC_BLOCK(1, camellia_dec_blk);
+	CBC_WALK_END();
 }
 
 static struct skcipher_alg camellia_algs[] = {
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index fefeedf2b33d..6c314bb46211 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -15,7 +15,8 @@
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <asm/crypto/camellia.h>
-#include <asm/crypto/glue_helper.h>
+
+#include "ecb_cbc_helpers.h"
 
 /* regular block cipher functions */
 asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
@@ -1274,63 +1275,35 @@ void camellia_decrypt_cbc_2way(const void *ctx, u8 *d, const u8 *s)
 }
 EXPORT_SYMBOL_GPL(camellia_decrypt_cbc_2way);
 
-static const struct common_glue_ctx camellia_enc = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 2,
-		.fn_u = { .ecb = camellia_enc_blk_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = camellia_enc_blk }
-	} }
-};
-
-static const struct common_glue_ctx camellia_dec = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 2,
-		.fn_u = { .ecb = camellia_dec_blk_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = camellia_dec_blk }
-	} }
-};
-
-static const struct common_glue_ctx camellia_dec_cbc = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = -1,
-
-	.funcs = { {
-		.num_blocks = 2,
-		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .cbc = camellia_dec_blk }
-	} }
-};
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&camellia_enc, req);
+	ECB_WALK_START(req, CAMELLIA_BLOCK_SIZE, -1);
+	ECB_BLOCK(2, camellia_enc_blk_2way);
+	ECB_BLOCK(1, camellia_enc_blk);
+	ECB_WALK_END();
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&camellia_dec, req);
+	ECB_WALK_START(req, CAMELLIA_BLOCK_SIZE, -1);
+	ECB_BLOCK(2, camellia_dec_blk_2way);
+	ECB_BLOCK(1, camellia_dec_blk);
+	ECB_WALK_END();
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
+	CBC_WALK_START(req, CAMELLIA_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(camellia_enc_blk);
+	CBC_WALK_END();
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
-	return glue_cbc_decrypt_req_128bit(&camellia_dec_cbc, req);
+	CBC_WALK_START(req, CAMELLIA_BLOCK_SIZE, -1);
+	CBC_DEC_BLOCK(2, camellia_decrypt_cbc_2way);
+	CBC_DEC_BLOCK(1, camellia_dec_blk);
+	CBC_WALK_END();
 }
 
 static struct crypto_alg camellia_cipher_alg = {
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 24c0e001d06d..f8518ff389bb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1286,7 +1286,6 @@ config CRYPTO_CAMELLIA_X86_64
 	depends on X86 && 64BIT
 	depends on CRYPTO
 	select CRYPTO_SKCIPHER
-	select CRYPTO_GLUE_HELPER_X86
 	imply CRYPTO_CTR
 	help
 	  Camellia cipher algorithm module (x86_64).
@@ -1305,7 +1304,6 @@ config CRYPTO_CAMELLIA_AESNI_AVX_X86_64
 	depends on CRYPTO
 	select CRYPTO_SKCIPHER
 	select CRYPTO_CAMELLIA_X86_64
-	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
 	imply CRYPTO_XTS
 	help
-- 
2.17.1

