Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A99C43333
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44DC22D01
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbhAEQu4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 11:50:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729518AbhAEQuz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 11:50:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03F0222D2B;
        Tue,  5 Jan 2021 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609865366;
        bh=7Hl7xWA576UO7K7qxdAB3pBVC3K/yat6nQST1MP9lNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ixyv95x1+B9Nlzt2TMZGXqPmErYIjvDTesvq21v3bgu5i64BdYZztOZbZh0+sDm2W
         w8DB4q+gwgxJ7tQLeBNujnbDtqWSYsjtshQAqWpurrCdK6rmfNtpW40gELimUGhI2i
         54GQerZU2YjE+qkhH5P1ZVAItZjZ59sB+ko+/+g1eoyg8LzJKZPCNwG7JwlP1GkvuD
         Kn4knAFdbTAX6VFoZZ9Twkh0WZIWufQE1GTeW/hc2ddomPMElH6gmLmelsQFFXj3In
         3y/UA4jHJdyjnQzxXxNysdR2UuCMLCIRTdyW/mZNnix109j6oI0ioWMgVZidRgM6tE
         LYlAJAUpqJGVA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 20/21] crypto: x86 - remove glue helper module
Date:   Tue,  5 Jan 2021 17:48:08 +0100
Message-Id: <20210105164809.8594-21-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105164809.8594-1-ardb@kernel.org>
References: <20210105164809.8594-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

All dependencies on the x86 glue helper module have been replaced by
local instantiations of the new ECB/CBC preprocessor helper macros, so
the glue helper module can be retired.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/Makefile                  |   2 -
 arch/x86/crypto/glue_helper.c             | 155 --------------------
 arch/x86/include/asm/crypto/glue_helper.h |  74 ----------
 crypto/Kconfig                            |   5 -
 crypto/skcipher.c                         |   6 -
 include/crypto/internal/skcipher.h        |   1 -
 6 files changed, 243 deletions(-)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a31de0c6ccde..b28e36b7c96b 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -4,8 +4,6 @@
 
 OBJECT_FILES_NON_STANDARD := y
 
-obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
-
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
deleted file mode 100644
index 895d34150c3f..000000000000
--- a/arch/x86/crypto/glue_helper.c
+++ /dev/null
@@ -1,155 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Shared glue code for 128bit block ciphers
- *
- * Copyright © 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
- *
- * CBC & ECB parts based on code (crypto/cbc.c,ecb.c) by:
- *   Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <linux/module.h>
-#include <crypto/b128ops.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
-#include <asm/crypto/glue_helper.h>
-
-int glue_ecb_req_128bit(const struct common_glue_ctx *gctx,
-			struct skcipher_request *req)
-{
-	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	const unsigned int bsize = 128 / 8;
-	struct skcipher_walk walk;
-	bool fpu_enabled = false;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes)) {
-		const u8 *src = walk.src.virt.addr;
-		u8 *dst = walk.dst.virt.addr;
-		unsigned int func_bytes;
-		unsigned int i;
-
-		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     &walk, fpu_enabled, nbytes);
-		for (i = 0; i < gctx->num_funcs; i++) {
-			func_bytes = bsize * gctx->funcs[i].num_blocks;
-
-			if (nbytes < func_bytes)
-				continue;
-
-			/* Process multi-block batch */
-			do {
-				gctx->funcs[i].fn_u.ecb(ctx, dst, src);
-				src += func_bytes;
-				dst += func_bytes;
-				nbytes -= func_bytes;
-			} while (nbytes >= func_bytes);
-
-			if (nbytes < bsize)
-				break;
-		}
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	glue_fpu_end(fpu_enabled);
-	return err;
-}
-EXPORT_SYMBOL_GPL(glue_ecb_req_128bit);
-
-int glue_cbc_encrypt_req_128bit(const common_glue_func_t fn,
-				struct skcipher_request *req)
-{
-	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	const unsigned int bsize = 128 / 8;
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes)) {
-		const u128 *src = (u128 *)walk.src.virt.addr;
-		u128 *dst = (u128 *)walk.dst.virt.addr;
-		u128 *iv = (u128 *)walk.iv;
-
-		do {
-			u128_xor(dst, src, iv);
-			fn(ctx, (u8 *)dst, (u8 *)dst);
-			iv = dst;
-			src++;
-			dst++;
-			nbytes -= bsize;
-		} while (nbytes >= bsize);
-
-		*(u128 *)walk.iv = *iv;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-	return err;
-}
-EXPORT_SYMBOL_GPL(glue_cbc_encrypt_req_128bit);
-
-int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
-				struct skcipher_request *req)
-{
-	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	const unsigned int bsize = 128 / 8;
-	struct skcipher_walk walk;
-	bool fpu_enabled = false;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	while ((nbytes = walk.nbytes)) {
-		const u128 *src = walk.src.virt.addr;
-		u128 *dst = walk.dst.virt.addr;
-		unsigned int func_bytes, num_blocks;
-		unsigned int i;
-		u128 last_iv;
-
-		fpu_enabled = glue_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					     &walk, fpu_enabled, nbytes);
-		/* Start of the last block. */
-		src += nbytes / bsize - 1;
-		dst += nbytes / bsize - 1;
-
-		last_iv = *src;
-
-		for (i = 0; i < gctx->num_funcs; i++) {
-			num_blocks = gctx->funcs[i].num_blocks;
-			func_bytes = bsize * num_blocks;
-
-			if (nbytes < func_bytes)
-				continue;
-
-			/* Process multi-block batch */
-			do {
-				src -= num_blocks - 1;
-				dst -= num_blocks - 1;
-
-				gctx->funcs[i].fn_u.cbc(ctx, (u8 *)dst,
-							(const u8 *)src);
-
-				nbytes -= func_bytes;
-				if (nbytes < bsize)
-					goto done;
-
-				u128_xor(dst, dst, --src);
-				dst--;
-			} while (nbytes >= func_bytes);
-		}
-done:
-		u128_xor(dst, dst, (u128 *)walk.iv);
-		*(u128 *)walk.iv = last_iv;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-
-	glue_fpu_end(fpu_enabled);
-	return err;
-}
-EXPORT_SYMBOL_GPL(glue_cbc_decrypt_req_128bit);
-
-MODULE_LICENSE("GPL");
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
deleted file mode 100644
index 23e09efd2aa6..000000000000
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ /dev/null
@@ -1,74 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Shared glue code for 128bit block ciphers
- */
-
-#ifndef _CRYPTO_GLUE_HELPER_H
-#define _CRYPTO_GLUE_HELPER_H
-
-#include <crypto/internal/skcipher.h>
-#include <linux/kernel.h>
-#include <asm/fpu/api.h>
-
-typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
-
-struct common_glue_func_entry {
-	unsigned int num_blocks; /* number of blocks that @fn will process */
-	union {
-		common_glue_func_t ecb;
-		common_glue_cbc_func_t cbc;
-	} fn_u;
-};
-
-struct common_glue_ctx {
-	unsigned int num_funcs;
-	int fpu_blocks_limit; /* -1 means fpu not needed at all */
-
-	/*
-	 * First funcs entry must have largest num_blocks and last funcs entry
-	 * must have num_blocks == 1!
-	 */
-	struct common_glue_func_entry funcs[];
-};
-
-static inline bool glue_fpu_begin(unsigned int bsize, int fpu_blocks_limit,
-				  struct skcipher_walk *walk,
-				  bool fpu_enabled, unsigned int nbytes)
-{
-	if (likely(fpu_blocks_limit < 0))
-		return false;
-
-	if (fpu_enabled)
-		return true;
-
-	/*
-	 * Vector-registers are only used when chunk to be processed is large
-	 * enough, so do not enable FPU until it is necessary.
-	 */
-	if (nbytes < bsize * (unsigned int)fpu_blocks_limit)
-		return false;
-
-	/* prevent sleeping if FPU is in use */
-	skcipher_walk_atomise(walk);
-
-	kernel_fpu_begin();
-	return true;
-}
-
-static inline void glue_fpu_end(bool fpu_enabled)
-{
-	if (fpu_enabled)
-		kernel_fpu_end();
-}
-
-extern int glue_ecb_req_128bit(const struct common_glue_ctx *gctx,
-			       struct skcipher_request *req);
-
-extern int glue_cbc_encrypt_req_128bit(const common_glue_func_t fn,
-				       struct skcipher_request *req);
-
-extern int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
-				       struct skcipher_request *req);
-
-#endif /* _CRYPTO_GLUE_HELPER_H */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b2182658c55e..94f0fde06b94 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -210,11 +210,6 @@ config CRYPTO_SIMD
 	tristate
 	select CRYPTO_CRYPTD
 
-config CRYPTO_GLUE_HELPER_X86
-	tristate
-	depends on X86
-	select CRYPTO_SKCIPHER
-
 config CRYPTO_ENGINE
 	tristate
 
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index ff16d05644c7..a15376245416 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -491,12 +491,6 @@ int skcipher_walk_virt(struct skcipher_walk *walk,
 }
 EXPORT_SYMBOL_GPL(skcipher_walk_virt);
 
-void skcipher_walk_atomise(struct skcipher_walk *walk)
-{
-	walk->flags &= ~SKCIPHER_WALK_SLEEP;
-}
-EXPORT_SYMBOL_GPL(skcipher_walk_atomise);
-
 int skcipher_walk_async(struct skcipher_walk *walk,
 			struct skcipher_request *req)
 {
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 9dd6c0c17eb8..a2339f80a615 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -133,7 +133,6 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err);
 int skcipher_walk_virt(struct skcipher_walk *walk,
 		       struct skcipher_request *req,
 		       bool atomic);
-void skcipher_walk_atomise(struct skcipher_walk *walk);
 int skcipher_walk_async(struct skcipher_walk *walk,
 			struct skcipher_request *req);
 int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
-- 
2.17.1

