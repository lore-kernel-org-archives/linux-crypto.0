Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056533EB7F1;
	Sun, 27 Sep 2026 22:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549089; cv=none; b=YuA7wxrMNExiwRKcdEYzF1XC/k8ww8vAgWj/gv93JHPF84RgHCdb8uFDZD2rCgomQl6aHlzTZiWBweFoPPXwSueN1rynDmB0o0mE17zYpj9sIAEBQ61ujZvaaOO/Wo+oGlc/Pbdij411L8KVC1DX/kj9OoVXkzFcz8VwTzuow8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549089; c=relaxed/simple;
	bh=7lsTgsp3rNqb2iOXiB5NgGfo2WZOrOs1P6p1ft1h4a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s2UfskPduph2wW4JPUf2TKUmqnHqkeYgp9eRIWYJzT7X+UKhlT4mxrJ+hcYWq0HcBUq95NiiMcrdxYUoMJKU7ngqKcJXyj9nRQy1p/LzxhIc5GzQPQ4pPMxuz9EQshGyQIBokpc+IqScBSOwxVwZT/7qOlyGSvVXSo74dTjcgfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxNptmOd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxNptmOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A231F0089A;
	Sun, 27 Sep 2026 22:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549085;
	bh=/KgPf7qOImf02WNBc/Vis1MwsFR/IDPErtkbwnucFog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxNptmOd/heJQcxhNrsEGeLA7P8vZ287twXdNlVuFnsG48L1jyPnNCT09bGD2QrHz
	 22fMhmV/TDuLDaNLpebZfPmqUzc1HJrbkpzaU69g/qCWHuJ3FHnSCSAthsJ7Xgd2KX
	 GxIm5wMGLDaUjumYebH6CFW1GZfNpm0Gd+M93uPzuu4x0t7XoIJ+S1I0pcG0dsrPj1
	 hSSJYd1JYdalcE/B9kqZdOxP8bfzpW+tPlrLadpssc5YfAs6mQ/tue4lpOfolRp25N
	 RL9TOBPTknFnxYvfeCS7Uv5qhqmXi1dcsKoy7z3iIZhQDkFmA5O8rMJdAXkzVvUMOo
	 w8rUDsO9/8WGg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 18/20] lib/crypto: riscv/aes-cbc: Migrate optimized code into library
Date: Sun, 27 Sep 2026 15:43:09 -0700
Message-ID: <20260927224418.109759-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260927224418.109759-1-ebiggers@kernel.org>
References: <20260927224418.109759-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Instead of exposing the riscv-optimized AES-CBC and AES-CBC-CTS code via
a riscv-specific crypto_skcipher algorithm, just implement the AES-CBC
and AES-CBC-CTS library functions.  This is simpler, it makes the
AES-CBC and AES-CBC-CTS library functions be riscv-optimized, and it
also fixes the longstanding issue where the riscv-optimized AES-CBC and
AES-CBC-CTS code was disabled by default.  AES-CBC and AES-CBC-CTS
support still remains available through crypto_skcipher via
crypto/aes.c, but individual architectures no longer need to handle it.

To match what the library expects, update the assembly functions to
operate on struct aes_enckey or struct aes_key rather than struct
crypto_aes_ctx, and adjust the argument order.

Remove the single-block special case from the assembly code, since it's
already handled by lib/crypto/aes.c before calling aes_cbc_cts_*_arch().

Bump up the priority of the corresponding library-based algorithms on
riscv now that they no longer have to be lower than arch/riscv/crypto/.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/riscv/crypto/Kconfig              |   4 +-
 arch/riscv/crypto/Makefile             |   2 +-
 arch/riscv/crypto/aes-riscv64-glue.c   | 167 +--------------
 arch/riscv/crypto/aes-riscv64-zvkned.S | 273 -------------------------
 crypto/aes.c                           |   6 +-
 lib/crypto/riscv/aes-riscv64-zvkned.S  | 235 +++++++++++++++++++++
 lib/crypto/riscv/aes.h                 |  68 ++++++
 7 files changed, 312 insertions(+), 443 deletions(-)
 delete mode 100644 arch/riscv/crypto/aes-riscv64-zvkned.S

diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 84c41824b433..0a3f87ad384e 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -3,13 +3,13 @@
 menu "Accelerated Cryptographic Algorithms for CPU (riscv)"
 
 config CRYPTO_AES_RISCV64
-	tristate "Ciphers: AES, modes: CBC, CTS, CTR, XTS"
+	tristate "Ciphers: AES, modes: CTR, XTS"
 	depends on 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		   RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	select CRYPTO_LIB_AES
 	select CRYPTO_SKCIPHER
 	help
-	  Length-preserving ciphers: AES with CBC, CTS, CTR, XTS
+	  Length-preserving ciphers: AES with CTR, XTS
 
 	  Architecture: riscv64 using:
 	  - Zvkned vector crypto extension
diff --git a/arch/riscv/crypto/Makefile b/arch/riscv/crypto/Makefile
index 8cf31db57fc4..d8b85afa6d0b 100644
--- a/arch/riscv/crypto/Makefile
+++ b/arch/riscv/crypto/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_CRYPTO_AES_RISCV64) += aes-riscv64.o
-aes-riscv64-y := aes-riscv64-glue.o aes-riscv64-zvkned.o \
+aes-riscv64-y := aes-riscv64-glue.o \
 		 aes-riscv64-zvkned-zvbb-zvkg.o aes-riscv64-zvkned-zvkb.o
 
 obj-$(CONFIG_CRYPTO_SM4_RISCV64) += sm4-riscv64.o
diff --git a/arch/riscv/crypto/aes-riscv64-glue.c b/arch/riscv/crypto/aes-riscv64-glue.c
index f7c492dcfd57..97f5369d7e71 100644
--- a/arch/riscv/crypto/aes-riscv64-glue.c
+++ b/arch/riscv/crypto/aes-riscv64-glue.c
@@ -22,17 +22,6 @@
 #include <linux/minmax.h>
 #include <linux/module.h>
 
-asmlinkage void aes_cbc_encrypt_zvkned(const struct crypto_aes_ctx *key,
-				       const u8 *in, u8 *out, size_t len,
-				       u8 iv[AES_BLOCK_SIZE]);
-asmlinkage void aes_cbc_decrypt_zvkned(const struct crypto_aes_ctx *key,
-				       const u8 *in, u8 *out, size_t len,
-				       u8 iv[AES_BLOCK_SIZE]);
-
-asmlinkage void aes_cbc_cts_crypt_zvkned(const struct crypto_aes_ctx *key,
-					 const u8 *in, u8 *out, size_t len,
-					 const u8 iv[AES_BLOCK_SIZE], bool enc);
-
 asmlinkage void aes_ctr32_crypt_zvkned_zvkb(const struct crypto_aes_ctx *key,
 					    const u8 *in, u8 *out, size_t len,
 					    u8 iv[AES_BLOCK_SIZE]);
@@ -81,110 +70,6 @@ static int riscv64_aes_setkey_skcipher(struct crypto_skcipher *tfm,
 	return riscv64_aes_setkey(ctx, key, keylen);
 }
 
-/* AES-CBC */
-
-static int riscv64_aes_cbc_crypt(struct skcipher_request *req, bool enc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, false);
-	while ((nbytes = walk.nbytes) != 0) {
-		kernel_vector_begin();
-		if (enc)
-			aes_cbc_encrypt_zvkned(ctx, walk.src.virt.addr,
-					       walk.dst.virt.addr,
-					       nbytes & ~(AES_BLOCK_SIZE - 1),
-					       walk.iv);
-		else
-			aes_cbc_decrypt_zvkned(ctx, walk.src.virt.addr,
-					       walk.dst.virt.addr,
-					       nbytes & ~(AES_BLOCK_SIZE - 1),
-					       walk.iv);
-		kernel_vector_end();
-		err = skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
-	}
-
-	return err;
-}
-
-static int riscv64_aes_cbc_encrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_cbc_crypt(req, true);
-}
-
-static int riscv64_aes_cbc_decrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_cbc_crypt(req, false);
-}
-
-/* AES-CBC-CTS */
-
-static int riscv64_aes_cbc_cts_crypt(struct skcipher_request *req, bool enc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct scatterlist sg_src[2], sg_dst[2];
-	struct skcipher_request subreq;
-	struct scatterlist *src, *dst;
-	struct skcipher_walk walk;
-	unsigned int cbc_len;
-	int err;
-
-	if (req->cryptlen < AES_BLOCK_SIZE)
-		return -EINVAL;
-
-	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
-		return err;
-	/*
-	 * If the full message is available in one step, decrypt it in one call
-	 * to the CBC-CTS assembly function.  This reduces overhead, especially
-	 * on short messages.  Otherwise, fall back to doing CBC up to the last
-	 * two blocks, then invoke CTS just for the ciphertext stealing.
-	 */
-	if (unlikely(walk.nbytes != req->cryptlen)) {
-		cbc_len = round_down(req->cryptlen - AES_BLOCK_SIZE - 1,
-				     AES_BLOCK_SIZE);
-		skcipher_walk_abort(&walk);
-		skcipher_request_set_tfm(&subreq, tfm);
-		skcipher_request_set_callback(&subreq,
-					      skcipher_request_flags(req),
-					      NULL, NULL);
-		skcipher_request_set_crypt(&subreq, req->src, req->dst,
-					   cbc_len, req->iv);
-		err = riscv64_aes_cbc_crypt(&subreq, enc);
-		if (err)
-			return err;
-		dst = src = scatterwalk_ffwd(sg_src, req->src, cbc_len);
-		if (req->dst != req->src)
-			dst = scatterwalk_ffwd(sg_dst, req->dst, cbc_len);
-		skcipher_request_set_crypt(&subreq, src, dst,
-					   req->cryptlen - cbc_len, req->iv);
-		err = skcipher_walk_virt(&walk, &subreq, false);
-		if (err)
-			return err;
-	}
-	kernel_vector_begin();
-	aes_cbc_cts_crypt_zvkned(ctx, walk.src.virt.addr, walk.dst.virt.addr,
-				 walk.nbytes, req->iv, enc);
-	kernel_vector_end();
-	return skcipher_walk_done(&walk, 0);
-}
-
-static int riscv64_aes_cbc_cts_encrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_cbc_cts_crypt(req, true);
-}
-
-static int riscv64_aes_cbc_cts_decrypt(struct skcipher_request *req)
-{
-	return riscv64_aes_cbc_cts_crypt(req, false);
-}
-
 /* AES-CTR */
 
 static int riscv64_aes_ctr_crypt(struct skcipher_request *req)
@@ -366,41 +251,6 @@ static int riscv64_aes_xts_decrypt(struct skcipher_request *req)
 
 /* Algorithm definitions */
 
-static struct skcipher_alg riscv64_zvkned_aes_skcipher_algs[] = {
-	{
-		.setkey = riscv64_aes_setkey_skcipher,
-		.encrypt = riscv64_aes_cbc_encrypt,
-		.decrypt = riscv64_aes_cbc_decrypt,
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.base = {
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct crypto_aes_ctx),
-			.cra_priority = 300,
-			.cra_name = "cbc(aes)",
-			.cra_driver_name = "cbc-aes-riscv64-zvkned",
-			.cra_module = THIS_MODULE,
-		},
-	}, {
-		.setkey = riscv64_aes_setkey_skcipher,
-		.encrypt = riscv64_aes_cbc_cts_encrypt,
-		.decrypt = riscv64_aes_cbc_cts_decrypt,
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize = AES_BLOCK_SIZE,
-		.walksize = 4 * AES_BLOCK_SIZE, /* matches LMUL=4 */
-		.base = {
-			.cra_blocksize = AES_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct crypto_aes_ctx),
-			.cra_priority = 300,
-			.cra_name = "cts(cbc(aes))",
-			.cra_driver_name = "cts-cbc-aes-riscv64-zvkned",
-			.cra_module = THIS_MODULE,
-		},
-	}
-};
-
 static struct skcipher_alg riscv64_zvkned_zvkb_aes_skcipher_alg = {
 	.setkey = riscv64_aes_setkey_skcipher,
 	.encrypt = riscv64_aes_ctr_crypt,
@@ -452,17 +302,11 @@ static int __init riscv64_aes_mod_init(void)
 
 	if (riscv_isa_extension_available(NULL, ZVKNED) &&
 	    riscv_vector_vlen() >= 128) {
-		err = crypto_register_skciphers(
-			riscv64_zvkned_aes_skcipher_algs,
-			ARRAY_SIZE(riscv64_zvkned_aes_skcipher_algs));
-		if (err)
-			return err;
-
 		if (riscv_isa_extension_available(NULL, ZVKB)) {
 			err = crypto_register_skcipher(
 				&riscv64_zvkned_zvkb_aes_skcipher_alg);
 			if (err)
-				goto unregister_zvkned_skcipher_algs;
+				return err;
 		}
 
 		if (riscv64_aes_xts_supported()) {
@@ -478,9 +322,6 @@ static int __init riscv64_aes_mod_init(void)
 unregister_zvkned_zvkb_skcipher_alg:
 	if (riscv_isa_extension_available(NULL, ZVKB))
 		crypto_unregister_skcipher(&riscv64_zvkned_zvkb_aes_skcipher_alg);
-unregister_zvkned_skcipher_algs:
-	crypto_unregister_skciphers(riscv64_zvkned_aes_skcipher_algs,
-				    ARRAY_SIZE(riscv64_zvkned_aes_skcipher_algs));
 	return err;
 }
 
@@ -490,18 +331,14 @@ static void __exit riscv64_aes_mod_exit(void)
 		crypto_unregister_skcipher(&riscv64_zvkned_zvbb_zvkg_aes_skcipher_alg);
 	if (riscv_isa_extension_available(NULL, ZVKB))
 		crypto_unregister_skcipher(&riscv64_zvkned_zvkb_aes_skcipher_alg);
-	crypto_unregister_skciphers(riscv64_zvkned_aes_skcipher_algs,
-				    ARRAY_SIZE(riscv64_zvkned_aes_skcipher_algs));
 }
 
 module_init(riscv64_aes_mod_init);
 module_exit(riscv64_aes_mod_exit);
 
-MODULE_DESCRIPTION("AES-CBC/CTS/CTR/XTS (RISC-V accelerated)");
+MODULE_DESCRIPTION("AES-CTR/XTS (RISC-V accelerated)");
 MODULE_AUTHOR("Jerry Shih <jerry.shih@sifive.com>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CRYPTO("aes");
-MODULE_ALIAS_CRYPTO("cbc(aes)");
-MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.S b/arch/riscv/crypto/aes-riscv64-zvkned.S
deleted file mode 100644
index 00f8a06596d3..000000000000
--- a/arch/riscv/crypto/aes-riscv64-zvkned.S
+++ /dev/null
@@ -1,273 +0,0 @@
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
-// The generated code of this file depends on the following RISC-V extensions:
-// - RV64I
-// - RISC-V Vector ('V') with VLEN >= 128
-// - RISC-V Vector AES block cipher extension ('Zvkned')
-
-#include <linux/linkage.h>
-
-.text
-.option arch, +zvkned
-
-#include "aes-macros.S"
-
-#define KEYP		a0
-#define INP		a1
-#define OUTP		a2
-#define LEN		a3
-#define IVP		a4
-
-.macro	aes_cbc_encrypt	keylen
-	vle32.v		v16, (IVP)	// Load IV
-1:
-	vle32.v		v17, (INP)	// Load plaintext block
-	vxor.vv		v16, v16, v17	// XOR with IV or prev ciphertext block
-	aes_encrypt	v16, \keylen	// Encrypt
-	vse32.v		v16, (OUTP)	// Store ciphertext block
-	addi		INP, INP, 16
-	addi		OUTP, OUTP, 16
-	addi		LEN, LEN, -16
-	bnez		LEN, 1b
-
-	vse32.v		v16, (IVP)	// Store next IV
-	ret
-.endm
-
-.macro	aes_cbc_decrypt	keylen
-	srli		LEN, LEN, 2	// Convert LEN from bytes to words
-	vle32.v		v16, (IVP)	// Load IV
-1:
-	vsetvli		t0, LEN, e32, m4, ta, ma
-	vle32.v		v20, (INP)	// Load ciphertext blocks
-	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
-	addi		t1, t0, -4
-	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
-	aes_decrypt	v20, \keylen	// Decrypt the blocks
-	vxor.vv		v20, v20, v16	// XOR with prev ciphertext blocks
-	vse32.v		v20, (OUTP)	// Store plaintext blocks
-	vmv.v.v		v16, v24	// Next "IV" is last ciphertext block
-	slli		t1, t0, 2	// Words to bytes
-	add		INP, INP, t1
-	add		OUTP, OUTP, t1
-	sub		LEN, LEN, t0
-	bnez		LEN, 1b
-
-	vsetivli	zero, 4, e32, m1, ta, ma
-	vse32.v		v16, (IVP)	// Store next IV
-	ret
-.endm
-
-// void aes_cbc_encrypt_zvkned(const struct crypto_aes_ctx *key,
-//			       const u8 *in, u8 *out, size_t len, u8 iv[16]);
-//
-// |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
-SYM_FUNC_START(aes_cbc_encrypt_zvkned)
-	aes_begin	KEYP, 128f, 192f
-	aes_cbc_encrypt	256
-128:
-	aes_cbc_encrypt	128
-192:
-	aes_cbc_encrypt	192
-SYM_FUNC_END(aes_cbc_encrypt_zvkned)
-
-// Same prototype and calling convention as the encryption function
-SYM_FUNC_START(aes_cbc_decrypt_zvkned)
-	aes_begin	KEYP, 128f, 192f
-	aes_cbc_decrypt	256
-128:
-	aes_cbc_decrypt	128
-192:
-	aes_cbc_decrypt	192
-SYM_FUNC_END(aes_cbc_decrypt_zvkned)
-
-.macro	aes_cbc_cts_encrypt	keylen
-
-	// CBC-encrypt all blocks except the last.  But don't store the
-	// second-to-last block to the output buffer yet, since it will be
-	// handled specially in the ciphertext stealing step.  Exception: if the
-	// message is single-block, still encrypt the last (and only) block.
-	li		t0, 16
-	j		2f
-1:
-	vse32.v		v16, (OUTP)	// Store ciphertext block
-	addi		OUTP, OUTP, 16
-2:
-	vle32.v		v17, (INP)	// Load plaintext block
-	vxor.vv		v16, v16, v17	// XOR with IV or prev ciphertext block
-	aes_encrypt	v16, \keylen	// Encrypt
-	addi		INP, INP, 16
-	addi		LEN, LEN, -16
-	bgt		LEN, t0, 1b	// Repeat if more than one block remains
-
-	// Special case: if the message is a single block, just do CBC.
-	beqz		LEN, .Lcts_encrypt_done\@
-
-	// Encrypt the last two blocks using ciphertext stealing as follows:
-	//	C[n-1] = Encrypt(Encrypt(P[n-1] ^ C[n-2]) ^ P[n])
-	//	C[n] = Encrypt(P[n-1] ^ C[n-2])[0..LEN]
-	//
-	// C[i] denotes the i'th ciphertext block, and likewise P[i] the i'th
-	// plaintext block.  Block n, the last block, may be partial; its length
-	// is 1 <= LEN <= 16.  If there are only 2 blocks, C[n-2] means the IV.
-	//
-	// v16 already contains Encrypt(P[n-1] ^ C[n-2]).
-	// INP points to P[n].  OUTP points to where C[n-1] should go.
-	// To support in-place encryption, load P[n] before storing C[n].
-	addi		t0, OUTP, 16	// Get pointer to where C[n] should go
-	vsetvli		zero, LEN, e8, m1, tu, ma
-	vle8.v		v17, (INP)	// Load P[n]
-	vse8.v		v16, (t0)	// Store C[n]
-	vxor.vv		v16, v16, v17	// v16 = Encrypt(P[n-1] ^ C[n-2]) ^ P[n]
-	vsetivli	zero, 4, e32, m1, ta, ma
-	aes_encrypt	v16, \keylen
-.Lcts_encrypt_done\@:
-	vse32.v		v16, (OUTP)	// Store C[n-1] (or C[n] in single-block case)
-	ret
-.endm
-
-#define LEN32		t4 // Length of remaining full blocks in 32-bit words
-#define LEN_MOD16	t5 // Length of message in bytes mod 16
-
-.macro	aes_cbc_cts_decrypt	keylen
-	andi		LEN32, LEN, ~15
-	srli		LEN32, LEN32, 2
-	andi		LEN_MOD16, LEN, 15
-
-	// Save C[n-2] in v28 so that it's available later during the ciphertext
-	// stealing step.  If there are fewer than three blocks, C[n-2] means
-	// the IV, otherwise it means the third-to-last ciphertext block.
-	vmv.v.v		v28, v16	// IV
-	add		t0, LEN, -33
-	bltz		t0, .Lcts_decrypt_loop\@
-	andi		t0, t0, ~15
-	add		t0, t0, INP
-	vle32.v		v28, (t0)
-
-	// CBC-decrypt all full blocks.  For the last full block, or the last 2
-	// full blocks if the message is block-aligned, this doesn't write the
-	// correct output blocks (unless the message is only a single block),
-	// because it XORs the wrong values with the raw AES plaintexts.  But we
-	// fix this after this loop without redoing the AES decryptions.  This
-	// approach allows more of the AES decryptions to be parallelized.
-.Lcts_decrypt_loop\@:
-	vsetvli		t0, LEN32, e32, m4, ta, ma
-	addi		t1, t0, -4
-	vle32.v		v20, (INP)	// Load next set of ciphertext blocks
-	vmv.v.v		v24, v16	// Get IV or last ciphertext block of prev set
-	vslideup.vi	v24, v20, 4	// Setup prev ciphertext blocks
-	vslidedown.vx	v16, v20, t1	// Save last ciphertext block of this set
-	aes_decrypt	v20, \keylen	// Decrypt this set of blocks
-	vxor.vv		v24, v24, v20	// XOR prev ciphertext blocks with decrypted blocks
-	vse32.v		v24, (OUTP)	// Store this set of plaintext blocks
-	sub		LEN32, LEN32, t0
-	slli		t0, t0, 2	// Words to bytes
-	add		INP, INP, t0
-	add		OUTP, OUTP, t0
-	bnez		LEN32, .Lcts_decrypt_loop\@
-
-	vsetivli	zero, 4, e32, m4, ta, ma
-	vslidedown.vx	v20, v20, t1	// Extract raw plaintext of last full block
-	addi		t0, OUTP, -16	// Get pointer to last full plaintext block
-	bnez		LEN_MOD16, .Lcts_decrypt_non_block_aligned\@
-
-	// Special case: if the message is a single block, just do CBC.
-	li		t1, 16
-	beq		LEN, t1, .Lcts_decrypt_done\@
-
-	// Block-aligned message.  Just fix up the last 2 blocks.  We need:
-	//
-	//	P[n-1] = Decrypt(C[n]) ^ C[n-2]
-	//	P[n] = Decrypt(C[n-1]) ^ C[n]
-	//
-	// We have C[n] in v16, Decrypt(C[n]) in v20, and C[n-2] in v28.
-	// Together with Decrypt(C[n-1]) ^ C[n-2] from the output buffer, this
-	// is everything needed to fix the output without re-decrypting blocks.
-	addi		t1, OUTP, -32	// Get pointer to where P[n-1] should go
-	vxor.vv		v20, v20, v28	// Decrypt(C[n]) ^ C[n-2] == P[n-1]
-	vle32.v		v24, (t1)	// Decrypt(C[n-1]) ^ C[n-2]
-	vse32.v		v20, (t1)	// Store P[n-1]
-	vxor.vv		v20, v24, v16	// Decrypt(C[n-1]) ^ C[n-2] ^ C[n] == P[n] ^ C[n-2]
-	j		.Lcts_decrypt_finish\@
-
-.Lcts_decrypt_non_block_aligned\@:
-	// Decrypt the last two blocks using ciphertext stealing as follows:
-	//
-	//	P[n-1] = Decrypt(C[n] || Decrypt(C[n-1])[LEN_MOD16..16]) ^ C[n-2]
-	//	P[n] = (Decrypt(C[n-1]) ^ C[n])[0..LEN_MOD16]
-	//
-	// We already have Decrypt(C[n-1]) in v20 and C[n-2] in v28.
-	vmv.v.v		v16, v20	// v16 = Decrypt(C[n-1])
-	vsetvli		zero, LEN_MOD16, e8, m1, tu, ma
-	vle8.v		v20, (INP)	// v20 = C[n] || Decrypt(C[n-1])[LEN_MOD16..16]
-	vxor.vv		v16, v16, v20	// v16 = Decrypt(C[n-1]) ^ C[n]
-	vse8.v		v16, (OUTP)	// Store P[n]
-	vsetivli	zero, 4, e32, m1, ta, ma
-	aes_decrypt	v20, \keylen	// v20 = Decrypt(C[n] || Decrypt(C[n-1])[LEN_MOD16..16])
-.Lcts_decrypt_finish\@:
-	vxor.vv		v20, v20, v28	// XOR with C[n-2]
-	vse32.v		v20, (t0)	// Store last full plaintext block
-.Lcts_decrypt_done\@:
-	ret
-.endm
-
-.macro	aes_cbc_cts_crypt	keylen
-	vle32.v		v16, (IVP)	// Load IV
-	beqz		a5, .Lcts_decrypt\@
-	aes_cbc_cts_encrypt \keylen
-.Lcts_decrypt\@:
-	aes_cbc_cts_decrypt \keylen
-.endm
-
-// void aes_cbc_cts_crypt_zvkned(const struct crypto_aes_ctx *key,
-//			         const u8 *in, u8 *out, size_t len,
-//				 const u8 iv[16], bool enc);
-//
-// Encrypts or decrypts a message with the CS3 variant of AES-CBC-CTS.
-// This is the variant that unconditionally swaps the last two blocks.
-SYM_FUNC_START(aes_cbc_cts_crypt_zvkned)
-	aes_begin	KEYP, 128f, 192f
-	aes_cbc_cts_crypt 256
-128:
-	aes_cbc_cts_crypt 128
-192:
-	aes_cbc_cts_crypt 192
-SYM_FUNC_END(aes_cbc_cts_crypt_zvkned)
diff --git a/crypto/aes.c b/crypto/aes.c
index 9b9e5b413fc4..1daaa59d0cdf 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -626,7 +626,8 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "cbc(aes)",
 		.base.cra_driver_name = "cbc-aes-lib",
-		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
+		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
@@ -652,7 +653,8 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "cts(cbc(aes))",
 		.base.cra_driver_name = "cts-cbc-aes-lib",
-		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
+		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_X86)) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
diff --git a/lib/crypto/riscv/aes-riscv64-zvkned.S b/lib/crypto/riscv/aes-riscv64-zvkned.S
index 3700028e62ea..61c1f185c33d 100644
--- a/lib/crypto/riscv/aes-riscv64-zvkned.S
+++ b/lib/crypto/riscv/aes-riscv64-zvkned.S
@@ -132,3 +132,238 @@ SYM_FUNC_END(aes_ecb_encrypt_zvkned)
 SYM_FUNC_START(aes_ecb_decrypt_zvkned)
 	aes_ecb_crypt	0
 SYM_FUNC_END(aes_ecb_decrypt_zvkned)
+
+#undef DST
+#undef SRC
+#undef LEN
+#undef KEYP
+
+#define DST		a0
+#define SRC		a1
+#define LEN		a2
+#define IVP		a3
+#define KEYP		a4
+
+.macro	aes_cbc_encrypt	keylen
+	vle32.v		v16, (IVP)	// Load IV
+1:
+	vle32.v		v17, (SRC)	// Load plaintext block
+	vxor.vv		v16, v16, v17	// XOR with IV or prev ciphertext block
+	aes_encrypt	v16, \keylen	// Encrypt
+	vse32.v		v16, (DST)	// Store ciphertext block
+	addi		SRC, SRC, 16
+	addi		DST, DST, 16
+	addi		LEN, LEN, -16
+	bnez		LEN, 1b
+
+	vse32.v		v16, (IVP)	// Store next IV
+	ret
+.endm
+
+.macro	aes_cbc_decrypt	keylen
+	srli		LEN, LEN, 2	// Convert LEN from bytes to words
+	vle32.v		v16, (IVP)	// Load IV
+1:
+	vsetvli		t0, LEN, e32, m4, ta, ma
+	vle32.v		v20, (SRC)	// Load ciphertext blocks
+	vslideup.vi	v16, v20, 4	// Setup prev ciphertext blocks
+	addi		t1, t0, -4
+	vslidedown.vx	v24, v20, t1	// Save last ciphertext block
+	aes_decrypt	v20, \keylen	// Decrypt the blocks
+	vxor.vv		v20, v20, v16	// XOR with prev ciphertext blocks
+	vse32.v		v20, (DST)	// Store plaintext blocks
+	vmv.v.v		v16, v24	// Next "IV" is last ciphertext block
+	slli		t1, t0, 2	// Words to bytes
+	add		SRC, SRC, t1
+	add		DST, DST, t1
+	sub		LEN, LEN, t0
+	bnez		LEN, 1b
+
+	vsetivli	zero, 4, e32, m1, ta, ma
+	vse32.v		v16, (IVP)	// Store next IV
+	ret
+.endm
+
+// void aes_cbc_encrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+//			       u8 iv[AES_BLOCK_SIZE],
+//			       const struct aes_enckey *key);
+//
+// |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
+SYM_FUNC_START(aes_cbc_encrypt_zvkned)
+	aes_begin	KEYP, 128f, 192f
+	aes_cbc_encrypt	256
+128:
+	aes_cbc_encrypt	128
+192:
+	aes_cbc_encrypt	192
+SYM_FUNC_END(aes_cbc_encrypt_zvkned)
+
+// void aes_cbc_decrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+//			       u8 iv[AES_BLOCK_SIZE],
+//			       const struct aes_key *key);
+//
+// |len| must be nonzero and a multiple of 16 (AES_BLOCK_SIZE).
+SYM_FUNC_START(aes_cbc_decrypt_zvkned)
+	aes_begin	KEYP, 128f, 192f
+	aes_cbc_decrypt	256
+128:
+	aes_cbc_decrypt	128
+192:
+	aes_cbc_decrypt	192
+SYM_FUNC_END(aes_cbc_decrypt_zvkned)
+
+#undef DST
+#undef SRC
+#undef LEN
+#undef IVP
+#undef KEYP
+
+#define DST		a0
+#define SRC		a1
+#define LEN		a2
+#define IVP		a3
+#define KEYP		a4
+#define ENC		a5
+
+.macro	aes_cbc_cts_encrypt	keylen
+
+	// CBC-encrypt all blocks except the last.  But don't store the
+	// second-to-last block to the output buffer yet, since it will be
+	// handled specially in the ciphertext stealing step.
+	li		t0, 16
+	j		2f
+1:
+	vse32.v		v16, (DST)	// Store ciphertext block
+	addi		DST, DST, 16
+2:
+	vle32.v		v17, (SRC)	// Load plaintext block
+	vxor.vv		v16, v16, v17	// XOR with IV or prev ciphertext block
+	aes_encrypt	v16, \keylen	// Encrypt
+	addi		SRC, SRC, 16
+	addi		LEN, LEN, -16
+	bgt		LEN, t0, 1b	// Repeat if more than one block remains
+
+	// Encrypt the last two blocks using ciphertext stealing as follows:
+	//	C[n-1] = Encrypt(Encrypt(P[n-1] ^ C[n-2]) ^ P[n])
+	//	C[n] = Encrypt(P[n-1] ^ C[n-2])[0..LEN]
+	//
+	// C[i] denotes the i'th ciphertext block, and likewise P[i] the i'th
+	// plaintext block.  Block n, the last block, may be partial; its length
+	// is 1 <= LEN <= 16.  If there are only 2 blocks, C[n-2] means the IV.
+	//
+	// v16 already contains Encrypt(P[n-1] ^ C[n-2]).
+	// SRC points to P[n].  DST points to where C[n-1] should go.
+	// To support in-place encryption, load P[n] before storing C[n].
+	addi		t0, DST, 16	// Get pointer to where C[n] should go
+	vsetvli		zero, LEN, e8, m1, tu, ma
+	vle8.v		v17, (SRC)	// Load P[n]
+	vse8.v		v16, (t0)	// Store C[n]
+	vxor.vv		v16, v16, v17	// v16 = Encrypt(P[n-1] ^ C[n-2]) ^ P[n]
+	vsetivli	zero, 4, e32, m1, ta, ma
+	aes_encrypt	v16, \keylen
+	vse32.v		v16, (DST)	// Store C[n-1]
+	ret
+.endm
+
+#define LEN32		t4 // Length of remaining full blocks in 32-bit words
+#define LEN_MOD16	t5 // Length of message in bytes mod 16
+
+.macro	aes_cbc_cts_decrypt	keylen
+	andi		LEN32, LEN, ~15
+	srli		LEN32, LEN32, 2
+	andi		LEN_MOD16, LEN, 15
+
+	// Save C[n-2] in v28 so that it's available later during the ciphertext
+	// stealing step.  If there are fewer than three blocks, C[n-2] means
+	// the IV, otherwise it means the third-to-last ciphertext block.
+	vmv.v.v		v28, v16	// IV
+	add		t0, LEN, -33
+	bltz		t0, .Lcts_decrypt_loop\@
+	andi		t0, t0, ~15
+	add		t0, t0, SRC
+	vle32.v		v28, (t0)
+
+	// CBC-decrypt all full blocks.  For the last full block, or the last 2
+	// full blocks if the message is block-aligned, this doesn't write the
+	// correct output blocks, because it XORs the wrong values with the raw
+	// AES plaintexts.  But we fix this after this loop without redoing the
+	// AES decryptions.  This approach allows more of the AES decryptions to
+	// be parallelized.
+.Lcts_decrypt_loop\@:
+	vsetvli		t0, LEN32, e32, m4, ta, ma
+	addi		t1, t0, -4
+	vle32.v		v20, (SRC)	// Load next set of ciphertext blocks
+	vmv.v.v		v24, v16	// Get IV or last ciphertext block of prev set
+	vslideup.vi	v24, v20, 4	// Setup prev ciphertext blocks
+	vslidedown.vx	v16, v20, t1	// Save last ciphertext block of this set
+	aes_decrypt	v20, \keylen	// Decrypt this set of blocks
+	vxor.vv		v24, v24, v20	// XOR prev ciphertext blocks with decrypted blocks
+	vse32.v		v24, (DST)	// Store this set of plaintext blocks
+	sub		LEN32, LEN32, t0
+	slli		t0, t0, 2	// Words to bytes
+	add		SRC, SRC, t0
+	add		DST, DST, t0
+	bnez		LEN32, .Lcts_decrypt_loop\@
+
+	vsetivli	zero, 4, e32, m4, ta, ma
+	vslidedown.vx	v20, v20, t1	// Extract raw plaintext of last full block
+	addi		t0, DST, -16	// Get pointer to last full plaintext block
+	bnez		LEN_MOD16, .Lcts_decrypt_non_block_aligned\@
+
+	// Block-aligned message.  Just fix up the last 2 blocks.  We need:
+	//
+	//	P[n-1] = Decrypt(C[n]) ^ C[n-2]
+	//	P[n] = Decrypt(C[n-1]) ^ C[n]
+	//
+	// We have C[n] in v16, Decrypt(C[n]) in v20, and C[n-2] in v28.
+	// Together with Decrypt(C[n-1]) ^ C[n-2] from the output buffer, this
+	// is everything needed to fix the output without re-decrypting blocks.
+	addi		t1, DST, -32	// Get pointer to where P[n-1] should go
+	vxor.vv		v20, v20, v28	// Decrypt(C[n]) ^ C[n-2] == P[n-1]
+	vle32.v		v24, (t1)	// Decrypt(C[n-1]) ^ C[n-2]
+	vse32.v		v20, (t1)	// Store P[n-1]
+	vxor.vv		v20, v24, v16	// Decrypt(C[n-1]) ^ C[n-2] ^ C[n] == P[n] ^ C[n-2]
+	j		.Lcts_decrypt_finish\@
+
+.Lcts_decrypt_non_block_aligned\@:
+	// Decrypt the last two blocks using ciphertext stealing as follows:
+	//
+	//	P[n-1] = Decrypt(C[n] || Decrypt(C[n-1])[LEN_MOD16..16]) ^ C[n-2]
+	//	P[n] = (Decrypt(C[n-1]) ^ C[n])[0..LEN_MOD16]
+	//
+	// We already have Decrypt(C[n-1]) in v20 and C[n-2] in v28.
+	vmv.v.v		v16, v20	// v16 = Decrypt(C[n-1])
+	vsetvli		zero, LEN_MOD16, e8, m1, tu, ma
+	vle8.v		v20, (SRC)	// v20 = C[n] || Decrypt(C[n-1])[LEN_MOD16..16]
+	vxor.vv		v16, v16, v20	// v16 = Decrypt(C[n-1]) ^ C[n]
+	vse8.v		v16, (DST)	// Store P[n]
+	vsetivli	zero, 4, e32, m1, ta, ma
+	aes_decrypt	v20, \keylen	// v20 = Decrypt(C[n] || Decrypt(C[n-1])[LEN_MOD16..16])
+.Lcts_decrypt_finish\@:
+	vxor.vv		v20, v20, v28	// XOR with C[n-2]
+	vse32.v		v20, (t0)	// Store last full plaintext block
+	ret
+.endm
+
+.macro	aes_cbc_cts_crypt	keylen
+	vle32.v		v16, (IVP)	// Load IV
+	beqz		ENC, .Lcts_decrypt\@
+	aes_cbc_cts_encrypt \keylen
+.Lcts_decrypt\@:
+	aes_cbc_cts_decrypt \keylen
+.endm
+
+// void aes_cbc_cts_crypt_zvkned(u8 *dst, const u8 *src, size_t len,
+//				 const u8 iv[AES_BLOCK_SIZE],
+//				 aes_encrypt_arg key, bool enc);
+//
+// Encrypts or decrypts len >= 17 bytes of data using the CS3 variant of
+// AES-CBC-CTS.  This is the variant that always swaps the last two blocks.
+SYM_FUNC_START(aes_cbc_cts_crypt_zvkned)
+	aes_begin	KEYP, 128f, 192f
+	aes_cbc_cts_crypt 256
+128:
+	aes_cbc_cts_crypt 128
+192:
+	aes_cbc_cts_crypt 192
+SYM_FUNC_END(aes_cbc_cts_crypt_zvkned)
diff --git a/lib/crypto/riscv/aes.h b/lib/crypto/riscv/aes.h
index 5b36d0147d93..150cda82cb89 100644
--- a/lib/crypto/riscv/aes.h
+++ b/lib/crypto/riscv/aes.h
@@ -93,6 +93,74 @@ static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_ECB */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC)
+void aes_cbc_encrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+			    u8 iv[AES_BLOCK_SIZE], const struct aes_enckey *key);
+void aes_cbc_decrypt_zvkned(u8 *dst, const u8 *src, size_t len,
+			    u8 iv[AES_BLOCK_SIZE], const struct aes_key *key);
+void aes_cbc_cts_crypt_zvkned(u8 *dst, const u8 *src, size_t len,
+			      const u8 iv[AES_BLOCK_SIZE],
+			      aes_encrypt_arg key, bool enc);
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_cbc_encrypt_arch aes_cbc_encrypt_arch
+static bool aes_cbc_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_enckey *key)
+{
+	if (!static_branch_likely(&have_zvkned) || unlikely(!may_use_simd()))
+		return false;
+	kernel_vector_begin();
+	aes_cbc_encrypt_zvkned(dst, src, len, iv, key);
+	kernel_vector_end();
+	return true;
+}
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_cbc_decrypt_arch aes_cbc_decrypt_arch
+static bool aes_cbc_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_key *key)
+{
+	if (!static_branch_likely(&have_zvkned) || unlikely(!may_use_simd()))
+		return false;
+	kernel_vector_begin();
+	aes_cbc_decrypt_zvkned(dst, src, len, iv, key);
+	kernel_vector_end();
+	return true;
+}
+
+/* len can be any value greater than AES_BLOCK_SIZE here. */
+#define aes_cbc_cts_encrypt_arch aes_cbc_cts_encrypt_arch
+static bool aes_cbc_cts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				     u8 iv[AES_BLOCK_SIZE],
+				     const struct aes_enckey *key)
+{
+	if (!static_branch_likely(&have_zvkned) || unlikely(!may_use_simd()))
+		return false;
+
+	kernel_vector_begin();
+	aes_cbc_cts_crypt_zvkned(dst, src, len, iv, key, true);
+	kernel_vector_end();
+	return true;
+}
+
+/* len can be any value greater than AES_BLOCK_SIZE here. */
+#define aes_cbc_cts_decrypt_arch aes_cbc_cts_decrypt_arch
+static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				     u8 iv[AES_BLOCK_SIZE],
+				     const struct aes_key *key)
+{
+	if (!static_branch_likely(&have_zvkned) || unlikely(!may_use_simd()))
+		return false;
+
+	kernel_vector_begin();
+	aes_cbc_cts_crypt_zvkned(dst, src, len, iv, key, false);
+	kernel_vector_end();
+	return true;
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_CBC */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
-- 
2.55.0

