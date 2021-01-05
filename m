Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE70C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFD522CBE
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbhAEQu2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 11:50:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbhAEQu1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 11:50:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3557F22D2C;
        Tue,  5 Jan 2021 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609865362;
        bh=d9yUay/I+ZaBbGW12kziR2wKibLTa9hRopGJV4pm2mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b57+J0aOAGj1zZiBNn5foo+c0qp5hgGx8H2fGHlCGDkisKG1D1lG7h0kmf7N7dMB5
         Y+QDPvBaYKYyKA2c2Jw19DlmmunZ2Caq0ncXKKH74Z0W08TAnwDGxNqZiUvB9xhp5t
         2v1KRWOr9jewAtEOGyRW+ddqKbga7DIWtcQgdBcKUIFzUJk4oJgzyGKrOzqRSJZu4E
         5eQh1fbS6SDu1JosKPd+C5mzhbOXlgOiQYS68201ATTQ2YzWeG+uQlIaHg9c2dFtNS
         YpZl9HMabQAGu+ORLeIwTMLbHqCAIKAnlZohGo4PbZ8gKB1nghfRPxbyNb/IkKL5pR
         Rcr5slSocUBbw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 18/21] crypto: x86/cast6 - drop dependency on glue helper
Date:   Tue,  5 Jan 2021 17:48:06 +0100
Message-Id: <20210105164809.8594-19-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105164809.8594-1-ardb@kernel.org>
References: <20210105164809.8594-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the glue helper dependency with implementations of ECB and CBC
based on the new CPP macros, which avoid the need for indirect calls.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/cast6_avx_glue.c | 61 ++++++--------------
 crypto/Kconfig                   |  1 -
 2 files changed, 17 insertions(+), 45 deletions(-)

diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index 790efcb6df3b..7e2aea372349 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -15,7 +15,8 @@
 #include <crypto/algapi.h>
 #include <crypto/cast6.h>
 #include <crypto/internal/simd.h>
-#include <asm/crypto/glue_helper.h>
+
+#include "ecb_cbc_helpers.h"
 
 #define CAST6_PARALLEL_BLOCKS 8
 
@@ -30,63 +31,35 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 	return cast6_setkey(&tfm->base, key, keylen);
 }
 
-static const struct common_glue_ctx cast6_enc = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = cast6_ecb_enc_8way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = __cast6_encrypt }
-	} }
-};
-
-static const struct common_glue_ctx cast6_dec = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = cast6_ecb_dec_8way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .ecb = __cast6_decrypt }
-	} }
-};
-
-static const struct common_glue_ctx cast6_dec_cbc = {
-	.num_funcs = 2,
-	.fpu_blocks_limit = CAST6_PARALLEL_BLOCKS,
-
-	.funcs = { {
-		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = cast6_cbc_dec_8way }
-	}, {
-		.num_blocks = 1,
-		.fn_u = { .cbc = __cast6_decrypt }
-	} }
-};
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&cast6_enc, req);
+	ECB_WALK_START(req, CAST6_BLOCK_SIZE, CAST6_PARALLEL_BLOCKS);
+	ECB_BLOCK(CAST6_PARALLEL_BLOCKS, cast6_ecb_enc_8way);
+	ECB_BLOCK(1, __cast6_encrypt);
+	ECB_WALK_END();
 }
 
 static int ecb_decrypt(struct skcipher_request *req)
 {
-	return glue_ecb_req_128bit(&cast6_dec, req);
+	ECB_WALK_START(req, CAST6_BLOCK_SIZE, CAST6_PARALLEL_BLOCKS);
+	ECB_BLOCK(CAST6_PARALLEL_BLOCKS, cast6_ecb_dec_8way);
+	ECB_BLOCK(1, __cast6_decrypt);
+	ECB_WALK_END();
 }
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(__cast6_encrypt, req);
+	CBC_WALK_START(req, CAST6_BLOCK_SIZE, -1);
+	CBC_ENC_BLOCK(__cast6_encrypt);
+	CBC_WALK_END();
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
 {
-	return glue_cbc_decrypt_req_128bit(&cast6_dec_cbc, req);
+	CBC_WALK_START(req, CAST6_BLOCK_SIZE, CAST6_PARALLEL_BLOCKS);
+	CBC_DEC_BLOCK(CAST6_PARALLEL_BLOCKS, cast6_cbc_dec_8way);
+	CBC_DEC_BLOCK(1, __cast6_decrypt);
+	CBC_WALK_END();
 }
 
 static struct skcipher_alg cast6_algs[] = {
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 29dce7efc443..25101558acb5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1393,7 +1393,6 @@ config CRYPTO_CAST6_AVX_X86_64
 	select CRYPTO_SKCIPHER
 	select CRYPTO_CAST6
 	select CRYPTO_CAST_COMMON
-	select CRYPTO_GLUE_HELPER_X86
 	select CRYPTO_SIMD
 	imply CRYPTO_XTS
 	imply CRYPTO_CTR
-- 
2.17.1

