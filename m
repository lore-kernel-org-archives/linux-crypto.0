Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4206F364EB0;
	Mon, 21 Sep 2026 05:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967775; cv=none; b=jXK5LmfsjQ1qAaEbwDsVObP81lypuSWdFdb5PLhypKxSFEOdo/5zcJVanlR4cp7vZnnnJ9ZKjmva84Sh4e0xLz5j5iYzUmmpkB756DE5OD9OsLWVrq/V9vn9u3Y1h1jKJNmnal0ddHUNEUqKOnKinMh3yJ4zcwQGhR3kcsEcAU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967775; c=relaxed/simple;
	bh=i3Y/7w1J5Qa9h3tTbtwc43bFrrIUkSTfWgLXNrhdKMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mrtd69IzER6ltFOOwyOzgTv7Cs6UFl1oOQk/RbmQ/FH2xQR6WuWdAtanidSCLZDEXzgyx0v+hhR/LjXD3zw0aHmhzQZf8sNo37fpsLOAfd3P+sXdFNAMK/U1N3an5xvjMOIwIXOqVxm/cJsHW/E9nl+81ncNAd/N42BEpmv3vNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=irQ2EgMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="irQ2EgMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E101F0089D;
	Mon, 21 Sep 2026 05:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967770;
	bh=MkyyNHKuYCDPCVmWsZf9HSuueJU5Xg70rl8FKthz/7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irQ2EgMttOtWnDEVEMMRrZAWMY9y5rZvUzNRsWtg6aKFnuT3P/oOMgSVP8tnuheHa
	 jO/a7Ae/duUzKi7YfMg1ccAH/xLZQXjejtR937gxZYmv53l1rE7iRUOALPsYHGgyRu
	 EPQJ8j78ciwDoLdc22A8dDOweBJkY6oDQFUfCRPfindTkDu7j+9tnGkF7nfPfVNZS1
	 xmNz2/xZVqnfJUZ8fdiO/DLuU2JaGwSQFbli5tTPFJOLHSh1tKuWR14zPUZ6IU2PFS
	 q2gyy8K37b1Ae3h/BoAZQuwfcbg52DHTN8yW/xYHd8pUyvja89cdJKuM73K7EVF/YG
	 zr3cKACkl8lHw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 20/20] lib/crypto: riscv/aes-xts: Migrate optimized code into library
Date: Sun, 20 Sep 2026 22:09:06 -0700
Message-ID: <20260921050910.296144-21-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Instead of exposing the riscv-optimized AES-XTS code via a
riscv-specific crypto_skcipher algorithm, just implement the AES-XTS
library functions.  This is simpler, it makes the AES-XTS library
functions be riscv-optimized, and it also fixes the longstanding issue
where the riscv-optimized AES-XTS code was disabled by default.  AES-XTS
support still remains available through crypto_skcipher via
crypto/aes.c, but individual architectures no longer need to handle it.

To match what the library expects, update the assembly functions to
operate on struct aes_key rather than struct crypto_aes_ctx, adjust the
argument order, and remove the redundant ciphertext stealing support
which is already implemented in a generic way in the library.

Bump up the priority of the corresponding library-based algorithm on
riscv now that it no longer has to be lower than arch/riscv/crypto/.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/riscv/crypto/Kconfig                     |  14 --
 arch/riscv/crypto/Makefile                    |   4 -
 arch/riscv/crypto/aes-macros.S                | 166 ------------
 arch/riscv/crypto/aes-riscv64-glue.c          | 236 ------------------
 crypto/aes.c                                  |   3 +-
 lib/crypto/Makefile                           |   3 +
 .../riscv}/aes-riscv64-zvkned-zvbb-zvkg.S     |  96 ++-----
 lib/crypto/riscv/aes.h                        |  53 ++++
 8 files changed, 74 insertions(+), 501 deletions(-)
 delete mode 100644 arch/riscv/crypto/aes-macros.S
 delete mode 100644 arch/riscv/crypto/aes-riscv64-glue.c
 rename {arch/riscv/crypto => lib/crypto/riscv}/aes-riscv64-zvkned-zvbb-zvkg.S (75%)

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 0733d4894401..614f93214862 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -2,20 +2,6 @@
 
 menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
 
-config CRYPTO_AES_RISCV64
-	tristate "Ciphers: AES, modes: XTS"
-	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
-		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
-	select CRYPTO_LIB_AES
-	select CRYPTO_SKCIPHER
-	help
-	  Length-preserving ciphers: AES with XTS
-
-	  Architecture: riscv64 using:
-	  - Zvkned vector crypto extension
-	  - Zvbb vector extension (XTS)
-	  - Zvkg vector crypto extension (XTS)
-
 config CRYPTO_SM4_RISCV64
 	tristate "Ciphers: SM4 (ShangMi 4)"
 	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 08904603fc94..9f6956cf50b1 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -1,8 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_CRYPTO_AES_RISCV64) += aes-riscv64.o
-aes-riscv64-y := aes-riscv64-glue.o \
-		 aes-riscv64-zvkned-zvbb-zvkg.o
-
 obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
 sm4-riscv64-y := sm4-riscv64-glue.o sm4-riscv64-zvksed-zvkb.o
diff --git a/arch/riscv/crypto/aes-macros.S b/arch/riscv/crypto/aes-macros.S
deleted file mode 100644
index 1384164621a5..000000000000
--- a/arch/riscv/crypto/aes-macros.S
+++ /dev/null
@@ -1,166 +0,0 @@
-/* SPDX-License-Identifier: Apache-2.0 OR BSD-2-Clause */
-//
-// This file is dual-licensed, meaning that you can use it under your
-// choice of either of the following two licenses:
-//
-// Copyright 2023 The OpenSSL Project Authors. All Rights Reserved.
-//
-// Licensed under the Apache License 2.0 (the "License"). You can obtain
-// a copy in the file LICENSE in the source distribution or at
-// https://www.openssl.org/source/license.html
-//
-// or
-//
-// Copyright (c) 2023, Christoph Müllner <christoph.muellner@vrull.eu>
-// Copyright (c) 2023, Phoebe Chen <phoebe.chen@sifive.com>
-// Copyright (c) 2023, Jerry Shih <jerry.shih@sifive.com>
-// Copyright 2024 Google LLC
-// All rights reserved.
-//
-// Redistribution and use in source and binary forms, with or without
-// modification, are permitted provided that the following conditions
-// are met:
-// 1. Redistributions of source code must retain the above copyright
-//    notice, this list of conditions and the following disclaimer.
-// 2. Redistributions in binary form must reproduce the above copyright
-//    notice, this list of conditions and the following disclaimer in the
-//    documentation and/or other materials provided with the distribution.
-//
-// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
-// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
-// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
-// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
-// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-
-// This file contains macros that are shared by the other aes-*.S files.  The
-// generated code of these macros depends on the following RISC-V extensions:
-// - RV64I
-// - RISC-V Vector ('V') with VLEN >= 128
-// - RISC-V Vector AES block cipher extension ('Zvkned')
-
-// Loads the AES round keys from \keyp into vector registers and jumps to code
-// specific to the length of the key.  Specifically:
-//   - If AES-128, loads round keys into v1-v11 and jumps to \label128.
-//   - If AES-192, loads round keys into v1-v13 and jumps to \label192.
-//   - If AES-256, loads round keys into v1-v15 and continues onwards.
-//
-// Also sets vl=4 and vtype=e32,m1,ta,ma.  Clobbers t0 and t1.
-.macro	aes_begin	keyp, label128, label192, key_len
-.ifb \key_len
-	lwu		t0, 480(\keyp)	// t0 = key length in bytes
-.endif
-	li		t1, 24		// t1 = key length for AES-192
-	vsetivli	zero, 4, e32, m1, ta, ma
-	vle32.v		v1, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v2, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v3, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v4, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v5, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v6, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v7, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v8, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v9, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v10, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v11, (\keyp)
-.ifb \key_len
-	blt		t0, t1, \label128	// If AES-128, goto label128.
-.else
-	blt		\key_len, t1, \label128	// If AES-128, goto label128.
-.endif
-	addi		\keyp, \keyp, 16
-	vle32.v		v12, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v13, (\keyp)
-.ifb \key_len
-	beq		t0, t1, \label192	// If AES-192, goto label192.
-.else
-	beq		\key_len, t1, \label192	// If AES-192, goto label192.
-.endif
-	// Else, it's AES-256.
-	addi		\keyp, \keyp, 16
-	vle32.v		v14, (\keyp)
-	addi		\keyp, \keyp, 16
-	vle32.v		v15, (\keyp)
-.endm
-
-// Encrypts \data using zvkned instructions, using the round keys loaded into
-// v1-v11 (for AES-128), v1-v13 (for AES-192), or v1-v15 (for AES-256).  \keylen
-// is the AES key length in bits.  vl and vtype must already be set
-// appropriately.  Note that if vl > 4, multiple blocks are encrypted.
-.macro	aes_encrypt	data, keylen
-	vaesz.vs	\data, v1
-	vaesem.vs	\data, v2
-	vaesem.vs	\data, v3
-	vaesem.vs	\data, v4
-	vaesem.vs	\data, v5
-	vaesem.vs	\data, v6
-	vaesem.vs	\data, v7
-	vaesem.vs	\data, v8
-	vaesem.vs	\data, v9
-	vaesem.vs	\data, v10
-.if \keylen == 128
-	vaesef.vs	\data, v11
-.elseif \keylen == 192
-	vaesem.vs	\data, v11
-	vaesem.vs	\data, v12
-	vaesef.vs	\data, v13
-.else
-	vaesem.vs	\data, v11
-	vaesem.vs	\data, v12
-	vaesem.vs	\data, v13
-	vaesem.vs	\data, v14
-	vaesef.vs	\data, v15
-.endif
-.endm
-
-// Same as aes_encrypt, but decrypts instead of encrypts.
-.macro	aes_decrypt	data, keylen
-.if \keylen == 128
-	vaesz.vs	\data, v11
-.elseif \keylen == 192
-	vaesz.vs	\data, v13
-	vaesdm.vs	\data, v12
-	vaesdm.vs	\data, v11
-.else
-	vaesz.vs	\data, v15
-	vaesdm.vs	\data, v14
-	vaesdm.vs	\data, v13
-	vaesdm.vs	\data, v12
-	vaesdm.vs	\data, v11
-.endif
-	vaesdm.vs	\data, v10
-	vaesdm.vs	\data, v9
-	vaesdm.vs	\data, v8
-	vaesdm.vs	\data, v7
-	vaesdm.vs	\data, v6
-	vaesdm.vs	\data, v5
-	vaesdm.vs	\data, v4
-	vaesdm.vs	\data, v3
-	vaesdm.vs	\data, v2
-	vaesdf.vs	\data, v1
-.endm
-
-// Expands to aes_encrypt or aes_decrypt according to \enc, which is 1 or 0.
-.macro	aes_crypt	data, enc, keylen
-.if \enc
-	aes_encrypt	\data, \keylen
-.else
-	aes_decrypt	\data, \keylen
-.endif
-.endm
diff --git a/arch/riscv/crypto/aes-riscv64-glue.c b/arch/riscv/crypto/aes-riscv64-glue.c
deleted file mode 100644
index a7dcceb77c49..000000000000
--- a/arch/riscv/crypto/aes-riscv64-glue.c
+++ /dev/null
@@ -1,236 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * AES modes using the RISC-V vector crypto extensions
- *
- * Copyright (C) 2023 VRULL GmbH
- * Author: Heiko Stuebner <heiko.stuebner@vrull.eu>
- *
- * Copyright (C) 2023 SiFive, Inc.
- * Author: Jerry Shih <jerry.shih@sifive.com>
- *
- * Copyright 2024 Google LLC
- */
-
-#include <asm/simd.h>
-#include <asm/vector.h>
-#include <crypto/aes.h>
-#include <crypto/internal/simd.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/xts.h>
-#include <linux/linkage.h>
-#include <linux/minmax.h>
-#include <linux/module.h>
-
-asmlinkage void aes_xts_encrypt_zvkned_zvbb_zvkg(
-			const struct crypto_aes_ctx *key,
-			const u8 *in, u8 *out, size_t len,
-			u8 tweak[AES_BLOCK_SIZE]);
-
-asmlinkage void aes_xts_decrypt_zvkned_zvbb_zvkg(
-			const struct crypto_aes_ctx *key,
-			const u8 *in, u8 *out, size_t len,
-			u8 tweak[AES_BLOCK_SIZE]);
-
-static int riscv64_aes_setkey(struct crypto_aes_ctx *ctx,
-			      const u8 *key, unsigned int keylen)
-{
-	/*
-	 * For now we just use the generic key expansion, for these reasons:
-	 *
-	 * - zvkned's key expansion instructions don't support AES-192.
-	 *   So, non-zvkned fallback code would be needed anyway.
-	 *
-	 * - Users of AES in Linux usually don't change keys frequently.
-	 *   So, key expansion isn't performance-critical.
-	 *
-	 * - For single-block AES exposed as a "cipher" algorithm, it's
-	 *   necessary to use struct crypto_aes_ctx and initialize its 'key_dec'
-	 *   field with the round keys for the Equivalent Inverse Cipher.  This
-	 *   is because with "cipher", decryption can be requested from a
-	 *   context where the vector unit isn't usable, necessitating a
-	 *   fallback to aes_decrypt().  But, zvkned can only generate and use
-	 *   the normal round keys.  Of course, it's preferable to not have
-	 *   special code just for "cipher", as e.g. XTS also uses a
-	 *   single-block AES encryption.  It's simplest to just use
-	 *   struct crypto_aes_ctx and aes_expandkey() everywhere.
-	 */
-	return aes_expandkey(ctx, key, keylen);
-}
-
-/* AES-XTS */
-
-struct riscv64_aes_xts_ctx {
-	struct crypto_aes_ctx ctx1;
-	struct aes_enckey tweak_key;
-};
-
-static int riscv64_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
-				  unsigned int keylen)
-{
-	struct riscv64_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	return xts_verify_key(tfm, key, keylen) ?:
-	       riscv64_aes_setkey(&ctx->ctx1, key, keylen / 2) ?:
-	       aes_prepareenckey(&ctx->tweak_key, key + keylen / 2, keylen / 2);
-}
-
-static int riscv64_aes_xts_crypt(struct skcipher_request *req, bool enc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct riscv64_aes_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int tail = req->cryptlen % AES_BLOCK_SIZE;
-	struct scatterlist sg_src[2], sg_dst[2];
-	struct skcipher_request subreq;
-	struct scatterlist *src, *dst;
-	struct skcipher_walk walk;
-	int err;
-
-	if (req->cryptlen < AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	/* Encrypt the IV with the tweak key to get the first tweak. */
-	aes_encrypt(&ctx->tweak_key, req->iv, req->iv);
-
-	err = skcipher_walk_virt(&walk, req, false);
-
-	/*
-	 * If the message length isn't divisible by the AES block size and the
-	 * full message isn't available in one step of the scatterlist walk,
-	 * then separate off the last full block and the partial block.  This
-	 * ensures that they are processed in the same call to the assembly
-	 * function, which is required for ciphertext stealing.
-	 */
-	if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
-		skcipher_walk_abort(&walk);
-
-		skcipher_request_set_tfm(&subreq, tfm);
-		skcipher_request_set_callback(&subreq,
-					      skcipher_request_flags(req),
-					      NULL, NULL);
-		skcipher_request_set_crypt(&subreq, req->src, req->dst,
-					   req->cryptlen - tail - AES_BLOCK_SIZE,
-					   req->iv);
-		req = &subreq;
-		err = skcipher_walk_virt(&walk, req, false);
-	} else {
-		tail = 0;
-	}
-
-	while (walk.nbytes) {
-		unsigned int nbytes = walk.nbytes;
-
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-
-		kernel_vector_begin();
-		if (enc)
-			aes_xts_encrypt_zvkned_zvbb_zvkg(
-				&ctx->ctx1, walk.src.virt.addr,
-				walk.dst.virt.addr, nbytes, req->iv);
-		else
-			aes_xts_decrypt_zvkned_zvbb_zvkg(
-				&ctx->ctx1, walk.src.virt.addr,
-				walk.dst.virt.addr, nbytes, req->iv);
-		kernel_vector_end();
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
-
-	if (err || likely(!tail))
-		return err;
-
-	/* Do ciphertext stealing with the last full block and partial block. */
-
-	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
-	if (req->dst != req->src)
-		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
-
-	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
-				   req->iv);
-
-	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
-		return err;
-
-	kernel_vector_begin();
-	if (enc)
-		aes_xts_encrypt_zvkned_zvbb_zvkg(
-			&ctx->ctx1, walk.src.virt.addr,
-			walk.dst.virt.addr, walk.nbytes, req->iv);
-	else
-		aes_xts_decrypt_zvkned_zvbb_zvkg(
-			&ctx->ctx1, walk.src.virt.addr,
-			walk.dst.virt.addr, walk.nbytes, req->iv);
-	kernel_vector_end();
-
-	return skcipher_walk_done(&walk, 0);
-}
-
-static int riscv64_aes_xts_encrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_xts_crypt(req, true);
-}
-
-static int riscv64_aes_xts_decrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_xts_crypt(req, false);
-}
-
-/* Algorithm definitions */
-
-static struct skcipher_alg riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg = {
-	.setkey = riscv64_aes_xts_setkey,
-	.encrypt = riscv64_aes_xts_encrypt,
-	.decrypt = riscv64_aes_xts_decrypt,
-	.min_keysize = 2 * AES_MIN_KEY_SIZE,
-	.max_keysize = 2 * AES_MAX_KEY_SIZE,
-	.ivsize = AES_BLOCK_SIZE,
-	.chunksize = AES_BLOCK_SIZE,
-	.walksize = 4 * AES_BLOCK_SIZE, /* matches LMUL=4 */
-	.base = {
-		.cra_blocksize = AES_BLOCK_SIZE,
-		.cra_ctxsize = sizeof(struct riscv64_aes_xts_ctx),
-		.cra_priority = 300,
-		.cra_name = "xts(aes)",
-		.cra_driver_name = "xts-aes-riscv64-zvkned-zvbb-zvkg",
-		.cra_module = THIS_MODULE,
-	},
-};
-
-static inline bool riscv64_aes_xts_supported(void)
-{
-	return riscv_isa_extension_available(NULL, ZVBB) &&
-	       riscv_isa_extension_available(NULL, ZVKG) &&
-	       riscv_vector_vlen() < 2048 /* Implementation limitation */;
-}
-
-static int __init riscv64_aes_mod_init(void)
-{
-	int err = -ENODEV;
-
-	if (riscv_isa_extension_available(NULL, ZVKNED) &&
-	    riscv_vector_vlen() >= 128) {
-		if (riscv64_aes_xts_supported()) {
-			err = crypto_register_skcipher(
-				&riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg);
-			if (err)
-				return err;
-		}
-	}
-
-	return err;
-}
-
-static void __exit riscv64_aes_mod_exit(void)
-{
-	crypto_unregister_skcipher(&riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg);
-}
-
-module_init(riscv64_aes_mod_init);
-module_exit(riscv64_aes_mod_exit);
-
-MODULE_DESCRIPTION("AES-XTS (RISC-V accelerated)");
-MODULE_AUTHOR("Jerry Shih <jerry.shih@sifive.com>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_CRYPTO("aes");
-MODULE_ALIAS_CRYPTO("xts(aes)");
diff --git a/crypto/aes.c b/crypto/aes.c
index 9990e5034d34..a5f34cbf6676 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -705,7 +705,8 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "xts(aes)",
 		.base.cra_driver_name = "xts-aes-lib",
-		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
+		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_xts_key),
 		.base.cra_module = THIS_MODULE,
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index ff34aeda37ba..d683b8520f55 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -54,6 +54,9 @@ libaes-$(CONFIG_RISCV) += riscv/aes-riscv64-zvkned.o
 ifneq ($(CONFIG_CRYPTO_LIB_AES_CTR),)
 libaes-$(CONFIG_RISCV) += riscv/aes-riscv64-zvkned-zvkb.o
 endif
+ifneq ($(CONFIG_CRYPTO_LIB_AES_XTS),)
+libaes-$(CONFIG_RISCV) += riscv/aes-riscv64-zvkned-zvbb-zvkg.o
+endif
 
 libaes-$(CONFIG_SPARC) += sparc/aes_asm.o
 
diff --git a/arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.S b/lib/crypto/riscv/aes-riscv64-zvkned-zvbb-zvkg.S
similarity index 75%
rename from arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.S
rename to lib/crypto/riscv/aes-riscv64-zvkned-zvbb-zvkg.S
index 146fc9cfb268..0a87e2666ae2 100644
--- a/arch/riscv/crypto/aes-riscv64-zvkned-zvbb-zvkg.S
+++ b/lib/crypto/riscv/aes-riscv64-zvkned-zvbb-zvkg.S
@@ -50,11 +50,11 @@
 
 #include "aes-macros.S"
 
-#define KEYP		a0
-#define INP		a1
-#define OUTP		a2
-#define LEN		a3
-#define TWEAKP		a4
+#define DST		a0
+#define SRC		a1
+#define LEN		a2
+#define TWEAKP		a3
+#define KEYP		a4
 
 #define LEN32		a5
 #define TAIL_LEN	a6
@@ -167,24 +167,21 @@
 .endm
 
 .macro	__aes_xts_crypt	enc, keylen
-	// With 16 < len <= 31, there's no main loop, just ciphertext stealing.
-	beqz		LEN32, .Lcts_without_main_loop\@
-
 	vsetvli		VLMAX, zero, e32, m4, ta, ma
 1:
 	vsetvli		VL, LEN32, e32, m4, ta, ma
 2:
 	// Encrypt or decrypt VL/4 blocks.
-	vle32.v		TMP0, (INP)
+	vle32.v		TMP0, (SRC)
 	vxor.vv		TMP0, TMP0, TWEAKS
 	aes_crypt	TMP0, \enc, \keylen
 	vxor.vv		TMP0, TMP0, TWEAKS
-	vse32.v		TMP0, (OUTP)
+	vse32.v		TMP0, (DST)
 
 	// Update the pointers and the remaining length.
 	slli		t0, VL, 2
-	add		INP, INP, t0
-	add		OUTP, OUTP, t0
+	add		SRC, SRC, t0
+	add		DST, DST, t0
 	sub		LEN32, LEN32, VL
 
 	// Check whether more blocks remain.
@@ -217,73 +214,14 @@
 	vsetivli	zero, 4, e32, m1, ta, ma
 	vgmul.vv	TWEAKS_BREV, MULTS_BREV		// Advance to next tweak
 
-	bnez		TAIL_LEN, .Lcts\@
-
 	// Update *TWEAKP to contain the next tweak.
 	vbrev8.v	TWEAKS, TWEAKS_BREV
 	vse32.v		TWEAKS, (TWEAKP)
 	ret
-
-.Lcts_without_main_loop\@:
-	load_x
-.Lcts\@:
-	// TWEAKS_BREV now contains the next tweak.  Compute the one after that.
-	vsetivli	zero, 4, e32, m1, ta, ma
-	vmv.v.v		TMP0, TWEAKS_BREV
-	vgmul.vv	TMP0, MULTS_BREV
-	// Undo the bit reversal of the next two tweaks and store them in TMP1
-	// and TMP2, such that TMP1 is the first needed and TMP2 the second.
-.if \enc
-	vbrev8.v	TMP1, TWEAKS_BREV
-	vbrev8.v	TMP2, TMP0
-.else
-	vbrev8.v	TMP1, TMP0
-	vbrev8.v	TMP2, TWEAKS_BREV
-.endif
-
-	// Encrypt/decrypt the last full block.
-	vle32.v		TMP0, (INP)
-	vxor.vv		TMP0, TMP0, TMP1
-	aes_crypt	TMP0, \enc, \keylen
-	vxor.vv		TMP0, TMP0, TMP1
-
-	// Swap the first TAIL_LEN bytes of the above result with the tail.
-	// Note that to support in-place encryption/decryption, the load from
-	// the input tail must happen before the store to the output tail.
-	addi		t0, INP, 16
-	addi		t1, OUTP, 16
-	vmv.v.v		TMP3, TMP0
-	vsetvli		zero, TAIL_LEN, e8, m1, tu, ma
-	vle8.v		TMP0, (t0)
-	vse8.v		TMP3, (t1)
-
-	// Encrypt/decrypt again and store the last full block.
-	vsetivli	zero, 4, e32, m1, ta, ma
-	vxor.vv		TMP0, TMP0, TMP2
-	aes_crypt	TMP0, \enc, \keylen
-	vxor.vv		TMP0, TMP0, TMP2
-	vse32.v		TMP0, (OUTP)
-
-	ret
 .endm
 
 .macro	aes_xts_crypt	enc
-
-	// Check whether the length is a multiple of the AES block size.
-	andi		TAIL_LEN, LEN, 15
-	beqz		TAIL_LEN, 1f
-
-	// The length isn't a multiple of the AES block size, so ciphertext
-	// stealing will be required.  Ciphertext stealing involves special
-	// handling of the partial block and the last full block, so subtract
-	// the length of both from the length to be processed in the main loop.
-	sub		LEN, LEN, TAIL_LEN
-	addi		LEN, LEN, -16
-1:
 	srli		LEN32, LEN, 2
-	// LEN and LEN32 now contain the total length of the blocks that will be
-	// processed in the main loop, in bytes and 32-bit words respectively.
-
 	xts_init
 	aes_begin	KEYP, 128f, 192f
 	__aes_xts_crypt	\enc, 256
@@ -293,15 +231,13 @@
 	__aes_xts_crypt	\enc, 192
 .endm
 
-// void aes_xts_encrypt_zvkned_zvbb_zvkg(const struct crypto_aes_ctx *key,
-//					 const u8 *in, u8 *out, size_t len,
-//					 u8 tweak[16]);
-//
-// |key| is the data key.  |tweak| contains the next tweak; the encryption of
-// the original IV with the tweak key was already done.  This function supports
-// incremental computation, but |len| must always be >= 16 (AES_BLOCK_SIZE), and
-// |len| must be a multiple of 16 except on the last call.  If |len| is a
-// multiple of 16, then this function updates |tweak| to contain the next tweak.
+// void aes_xts_encrypt_zvkned_zvbb_zvkg(u8 *dst, const u8 *src, size_t len,
+//					 u8 tweak[AES_BLOCK_SIZE],
+//					 const struct aes_key *key);
+
+// `tweak` must have already been encrypted by the tweak key; `key` is just the
+// main key.  To allow incremental computation, this updates `tweak` to contain
+// the next tweak.
 SYM_FUNC_START(aes_xts_encrypt_zvkned_zvbb_zvkg)
 	aes_xts_crypt	1
 SYM_FUNC_END(aes_xts_encrypt_zvkned_zvbb_zvkg)
diff --git a/lib/crypto/riscv/aes.h b/lib/crypto/riscv/aes.h
index 2c4d1e58c703..1727302568f8 100644
--- a/lib/crypto/riscv/aes.h
+++ b/lib/crypto/riscv/aes.h
@@ -1,5 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
+ * AES using the RISC-V vector crypto extensions
+ *
  * Copyright (C) 2023 VRULL GmbH
  * Copyright (C) 2023 SiFive, Inc.
  * Copyright 2024 Google LLC
@@ -10,6 +12,7 @@
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_zvkned);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_zvkned_zvkb);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_xts);
 
 /* The assembly code assumes the following offsets. */
 static_assert(offsetof(struct aes_enckey, len) == 0);
@@ -223,6 +226,52 @@ static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_CTR */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
+void aes_xts_encrypt_zvkned_zvbb_zvkg(u8 *dst, const u8 *src, size_t len,
+				      u8 tweak[AES_BLOCK_SIZE],
+				      const struct aes_key *key);
+void aes_xts_decrypt_zvkned_zvbb_zvkg(u8 *dst, const u8 *src, size_t len,
+				      u8 tweak[AES_BLOCK_SIZE],
+				      const struct aes_key *key);
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+static __always_inline bool
+aes_xts_crypt_riscv(u8 *dst, const u8 *src, size_t len,
+		    u8 tweak[AES_BLOCK_SIZE],
+		    const struct aes_xts_key *key, bool cont, bool enc)
+{
+	if (!static_branch_likely(&have_xts) || unlikely(!may_use_simd()))
+		return false;
+	kernel_vector_begin();
+	if (!cont)
+		aes_encrypt_zvkned(&key->tweak_key, tweak, tweak);
+	if (enc)
+		aes_xts_encrypt_zvkned_zvbb_zvkg(dst, src, len, tweak,
+						 &key->main_key);
+	else
+		aes_xts_decrypt_zvkned_zvbb_zvkg(dst, src, len, tweak,
+						 &key->main_key);
+	kernel_vector_end();
+	return true;
+}
+
+#define aes_xts_encrypt_arch aes_xts_encrypt_arch
+static bool aes_xts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return aes_xts_crypt_riscv(dst, src, len, tweak, key, cont, true);
+}
+
+#define aes_xts_decrypt_arch aes_xts_decrypt_arch
+static bool aes_xts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return aes_xts_crypt_riscv(dst, src, len, tweak, key, cont, false);
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_XTS */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
@@ -231,5 +280,9 @@ static void aes_mod_init_arch(void)
 		static_branch_enable(&have_zvkned);
 		if (riscv_isa_extension_available(NULL, ZVKB))
 			static_branch_enable(&have_zvkned_zvkb);
+		if (riscv_isa_extension_available(NULL, ZVBB) &&
+		    riscv_isa_extension_available(NULL, ZVKG) &&
+		    riscv_vector_vlen() < 2048 /* Implementation limitation */)
+			static_branch_enable(&have_xts);
 	}
 }
-- 
2.55.0

