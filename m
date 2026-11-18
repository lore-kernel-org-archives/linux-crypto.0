Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975056;
	b=pZrIm2XhAu+z/p5Ht7l1jdyQ5blGeGcIZeuLR6eGD/Vhd6oDrQK8597j3XaM98Pij7jH
	 Gh/IdCdFydOzqWftjuh5WePd+TaG/K2ozEWMHhMUS+Tp/XzuLpO+43EjCfbYTskeKLjLP
	 7LJ3HpLROBIxu/IH/9AOZtwE9rfPCZwIwJbrg9clUAiEpdrA6vg7Uc6YPZ5u9pC+JmbbD
	 HNv4AnPDrI7kyjoZ/W8iMgNBGEp8xufKtBsmKs1eqG4tzzMe2xvX85xdPAuODfLAPzxU4
	 WsLMTZaakRjv11jjt70S6rdvzmlpg1FpxpIOliE7wW3KE7kfoipjNstU33jXbk5Mpyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=a0pKXARSSbUJgBMPmE8zE6RzfaRVyFT/qmKuKgUUWRA=;
	b=s5oxxD+fh+3Q2XmtFBPZx7zZAPtkqouTrmTihDF6Zo/R/rTrbMCLwGkrfOGdP/1sVFnf
	 keATx6MuMZnisZrrIjKMB63gSFwZfpq9ql+y/PTJGvnvUaEBtLkH/n3jlfXBfWMuOqsoo
	 FhPCyIYkaFQj5xgfevh5Si+zWWLrCQ9pulcDMnMMcjBXEbjqu/HhipV3VUhXcvez/MF5R
	 r5uJhB6pY+fgnEAfC4mgus1oxf6rgts32ol+utiZOyVUXIR5yYOMQR+1SedUm2qwVDQ2X
	 M+RIpCYXXg6B5Wg/dKHMYWskW8jryJPMBtzcTtKCs81oVJjT/E6dPsU9vBgpB+G+5lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kX4eIvAT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8DF606A33D;
	Wed, 18 Nov 2026 04:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kX4eIvAT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9221F000CA;
	Wed, 18 Nov 2026 04:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794975056;
	bh=a0pKXARSSbUJgBMPmE8zE6RzfaRVyFT/qmKuKgUUWRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kX4eIvATr5MNoN8kQ302Rbkxq089IC+3+WJhRQSALTgdY1u/8RyzPwY3YryELxsOd
	 c48CME7nzuo0Ni7BWTaVNjCKyk0FjAMMcJdLz0MpSLhMOWXt81jVP4BJsrgi/Hne2I
	 PNWhuY7PppFuHkw+cAwZpGJbh9F76AfwycYlb4zN/MnF0Ru9Ovj8krNaQDq2i6te0h
	 3Gb59sr9luSHatdKDJY4B503b/0ySh5QW2h+ozkeG0EjRgrXRjnXNAZySylJ5j2EyI
	 cJDOr/fD64PjQjQhh0//8yS1d5ixVQGULZowgnHdiZvw4Uy6TJMFWgf9dwfD1iCTIe
	 NqW6A2c1F9c7g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	sparclinux@vger.kernel.org,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Stian Halseth <stian@itx.no>,
	Magnus Lindholm <linmag7@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/4] lib/crypto: sparc/aes-cbc: Migrate optimized code into library
Date: Tue, 17 Nov 2026 20:10:33 -0800
Message-ID: <20261118041033.50014-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118041033.50014-1-ebiggers@kernel.org>
References: <20261118041033.50014-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of exposing the sparc64-optimized AES-CBC code via a
sparc64-specific crypto_skcipher algorithm, implement the AES-CBC
library functions.  This is simpler, makes the AES-CBC and
AES-CBC-CTS library functions sparc64-optimized, and fixes the
longstanding issue where the sparc64-optimized AES-CBC code was
disabled by default.  AES-CBC and AES-CBC-CTS support remains
available through crypto_skcipher via crypto/aes.c.

The library functions take size_t lengths, so update the prototypes of
the CBC assembly functions to match.  The assembly code actually already
treated the length argument as 64-bit.

Handle the CBC assembly code's data alignment requirement by explicitly
using an on-stack bounce buffer when the data is misaligned.  (Note that
bounce buffering was used in the old code too; it was just hidden in the
skcipher_walk_* functions via the configured cra_alignmask=7.)

Now that cbc-aes-sparc64 is removed, also increase the priority of
cbc-aes-lib on SPARC, and re-enable cts-cbc-aes-lib.

Tested in QEMU (commit 97c88c61d45d) with aes_cbc_kunit
(https://lore.kernel.org/r/20261116062849.1071038-4-ebiggers@kernel.org/)
and CONFIG_CRYPTO_SELFTESTS_FULL=y, using the patch that makes the SPARC
kernel detect QEMU's support for the SPARC crypto opcodes
(https://lore.kernel.org/r/20261117112914.2300417-1-stian@itx.no/).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/sparc/crypto/Kconfig    |  10 --
 arch/sparc/crypto/Makefile   |   2 -
 arch/sparc/crypto/aes_glue.c | 209 -----------------------------------
 crypto/aes.c                 |   5 +-
 include/crypto/aes.h         |  21 ----
 lib/crypto/sparc/aes.h       | 118 +++++++++++++++++---
 lib/crypto/sparc/aes_asm.S   |   2 +
 7 files changed, 109 insertions(+), 258 deletions(-)
 delete mode 100644 arch/sparc/crypto/aes_glue.c

diff --git a/arch/sparc/crypto/Kconfig b/arch/sparc/crypto/Kconfig
index 783b057aeebfb..5cff41005241c 100644
--- a/arch/sparc/crypto/Kconfig
+++ b/arch/sparc/crypto/Kconfig
@@ -2,16 +2,6 @@
 
 menu "Accelerated Cryptographic Algorithms for CPU (sparc64)"
 
-config CRYPTO_AES_SPARC64
-	tristate "Ciphers: AES, modes: CBC"
-	depends on SPARC64
-	select CRYPTO_LIB_AES
-	select CRYPTO_SKCIPHER
-	help
-	  Length-preserving ciphers: AES with CBC mode
-
-	  Architecture: sparc64 using crypto instructions
-
 config CRYPTO_CAMELLIA_SPARC64
 	tristate "Ciphers: Camellia, modes: ECB, CBC"
 	depends on SPARC64
diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index ab4a7765babf5..b95c66c2f81cc 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -3,8 +3,6 @@
 # Arch-specific CryptoAPI modules.
 #
 
-obj-$(CONFIG_CRYPTO_AES_SPARC64) += aes-sparc64.o
 obj-$(CONFIG_CRYPTO_CAMELLIA_SPARC64) += camellia-sparc64.o
 
-aes-sparc64-y := aes_glue.o
 camellia-sparc64-y := camellia_asm.o camellia_glue.o
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
deleted file mode 100644
index cb36070ca39bf..0000000000000
--- a/arch/sparc/crypto/aes_glue.c
+++ /dev/null
@@ -1,209 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* Glue code for AES encryption optimized for sparc64 crypto opcodes.
- *
- * This is based largely upon arch/x86/crypto/aesni-intel_glue.c
- *
- * Copyright (C) 2008, Intel Corp.
- *    Author: Huang Ying <ying.huang@intel.com>
- *
- * Added RFC4106 AES-GCM support for 128-bit keys under the AEAD
- * interface for 64-bit kernels.
- *    Authors: Adrian Hoban <adrian.hoban@intel.com>
- *             Gabriele Paoloni <gabriele.paoloni@intel.com>
- *             Tadeusz Struk (tadeusz.struk@intel.com)
- *             Aidan O'Mahony (aidan.o.mahony@intel.com)
- *    Copyright (c) 2010, Intel Corporation.
- */
-
-#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
-
-#include <linux/crypto.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <crypto/algapi.h>
-#include <crypto/aes.h>
-#include <crypto/internal/skcipher.h>
-
-#include <asm/fpumacro.h>
-#include <asm/opcodes.h>
-#include <asm/pstate.h>
-#include <asm/elf.h>
-
-struct aes_ops {
-	void (*load_encrypt_keys)(const u64 *key);
-	void (*load_decrypt_keys)(const u64 *key);
-	void (*cbc_encrypt)(const u64 *key, const u64 *input, u64 *output,
-			    unsigned int len, u64 *iv);
-	void (*cbc_decrypt)(const u64 *key, const u64 *input, u64 *output,
-			    unsigned int len, u64 *iv);
-};
-
-struct crypto_sparc64_aes_ctx {
-	struct aes_ops *ops;
-	u64 key[AES_MAX_KEYLENGTH / sizeof(u64)];
-	u32 key_length;
-	u32 expanded_key_length;
-};
-
-static struct aes_ops aes128_ops = {
-	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_128,
-	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_128,
-	.cbc_encrypt		= aes_sparc64_cbc_encrypt_128,
-	.cbc_decrypt		= aes_sparc64_cbc_decrypt_128,
-};
-
-static struct aes_ops aes192_ops = {
-	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_192,
-	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_192,
-	.cbc_encrypt		= aes_sparc64_cbc_encrypt_192,
-	.cbc_decrypt		= aes_sparc64_cbc_decrypt_192,
-};
-
-static struct aes_ops aes256_ops = {
-	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_256,
-	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_256,
-	.cbc_encrypt		= aes_sparc64_cbc_encrypt_256,
-	.cbc_decrypt		= aes_sparc64_cbc_decrypt_256,
-};
-
-static int aes_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
-				unsigned int key_len)
-{
-	struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	switch (key_len) {
-	case AES_KEYSIZE_128:
-		ctx->expanded_key_length = 0xb0;
-		ctx->ops = &aes128_ops;
-		break;
-
-	case AES_KEYSIZE_192:
-		ctx->expanded_key_length = 0xd0;
-		ctx->ops = &aes192_ops;
-		break;
-
-	case AES_KEYSIZE_256:
-		ctx->expanded_key_length = 0xf0;
-		ctx->ops = &aes256_ops;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	aes_sparc64_key_expand((const u32 *)in_key, &ctx->key[0], key_len);
-	ctx->key_length = key_len;
-
-	return 0;
-}
-
-static int cbc_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, true);
-	if (err)
-		return err;
-
-	ctx->ops->load_encrypt_keys(&ctx->key[0]);
-	while ((nbytes = walk.nbytes) != 0) {
-		ctx->ops->cbc_encrypt(&ctx->key[0], walk.src.virt.addr,
-				      walk.dst.virt.addr,
-				      round_down(nbytes, AES_BLOCK_SIZE),
-				      walk.iv);
-		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
-	}
-	fprs_write(0);
-	return err;
-}
-
-static int cbc_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct crypto_sparc64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	const u64 *key_end;
-	struct skcipher_walk walk;
-	unsigned int nbytes;
-	int err;
-
-	err = skcipher_walk_virt(&walk, req, true);
-	if (err)
-		return err;
-
-	ctx->ops->load_decrypt_keys(&ctx->key[0]);
-	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
-	while ((nbytes = walk.nbytes) != 0) {
-		ctx->ops->cbc_decrypt(key_end, walk.src.virt.addr,
-				      walk.dst.virt.addr,
-				      round_down(nbytes, AES_BLOCK_SIZE),
-				      walk.iv);
-		err = skcipher_walk_done(&walk, nbytes % AES_BLOCK_SIZE);
-	}
-	fprs_write(0);
-
-	return err;
-}
-
-static struct skcipher_alg skcipher_algs[] = {
-	{
-		.base.cra_name		= "cbc(aes)",
-		.base.cra_driver_name	= "cbc-aes-sparc64",
-		.base.cra_priority	= SPARC_CR_OPCODE_PRIORITY,
-		.base.cra_blocksize	= AES_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct crypto_sparc64_aes_ctx),
-		.base.cra_alignmask	= 7,
-		.base.cra_module	= THIS_MODULE,
-		.min_keysize		= AES_MIN_KEY_SIZE,
-		.max_keysize		= AES_MAX_KEY_SIZE,
-		.ivsize			= AES_BLOCK_SIZE,
-		.setkey			= aes_set_key_skcipher,
-		.encrypt		= cbc_encrypt,
-		.decrypt		= cbc_decrypt,
-	}
-};
-
-static bool __init sparc64_has_aes_opcode(void)
-{
-	unsigned long cfr;
-
-	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
-		return false;
-
-	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
-	if (!(cfr & CFR_AES))
-		return false;
-
-	return true;
-}
-
-static int __init aes_sparc64_mod_init(void)
-{
-	if (!sparc64_has_aes_opcode()) {
-		pr_info("sparc64 aes opcodes not available.\n");
-		return -ENODEV;
-	}
-	pr_info("Using sparc64 aes opcodes optimized AES implementation\n");
-	return crypto_register_skciphers(skcipher_algs,
-					 ARRAY_SIZE(skcipher_algs));
-}
-
-static void __exit aes_sparc64_mod_fini(void)
-{
-	crypto_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
-}
-
-module_init(aes_sparc64_mod_init);
-module_exit(aes_sparc64_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, sparc64 aes opcode accelerated");
-
-MODULE_ALIAS_CRYPTO("aes");
-
-#include "crop_devid.c"
diff --git a/crypto/aes.c b/crypto/aes.c
index 2e4ea9d7a74d8..a2db6351feefa 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -628,6 +628,7 @@ static struct skcipher_alg skcipher_algs[] = {
 		.base.cra_name = "cbc(aes)",
 		.base.cra_driver_name = "cbc-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_SPARC) ||
 				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
@@ -650,12 +651,12 @@ static struct skcipher_alg skcipher_algs[] = {
 	!(IS_ENABLED(CONFIG_ARM) || \
 	  IS_ENABLED(CONFIG_ARM64) || \
 	  IS_ENABLED(CONFIG_PPC) || \
-	  IS_ENABLED(CONFIG_S390) || \
-	  IS_ENABLED(CONFIG_SPARC))
+	  IS_ENABLED(CONFIG_S390))
 	{
 		.base.cra_name = "cts(cbc(aes))",
 		.base.cra_driver_name = "cts-cbc-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_SPARC) ||
 				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index e77e8660f347e..a62cf6ef96c99 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -299,27 +299,6 @@ void aes_p8_xts_encrypt(const u8 *in, u8 *out, size_t len,
 void aes_p8_xts_decrypt(const u8 *in, u8 *out, size_t len,
 			const struct p8_aes_key *key1,
 			const struct p8_aes_key *key2, u8 *iv);
-#elif defined(CONFIG_SPARC64)
-void aes_sparc64_key_expand(const u32 *in_key, u64 *output_key,
-			    unsigned int key_len);
-void aes_sparc64_load_encrypt_keys_128(const u64 *key);
-void aes_sparc64_load_encrypt_keys_192(const u64 *key);
-void aes_sparc64_load_encrypt_keys_256(const u64 *key);
-void aes_sparc64_load_decrypt_keys_128(const u64 *key);
-void aes_sparc64_load_decrypt_keys_192(const u64 *key);
-void aes_sparc64_load_decrypt_keys_256(const u64 *key);
-void aes_sparc64_cbc_encrypt_128(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len, u64 *iv);
-void aes_sparc64_cbc_encrypt_192(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len, u64 *iv);
-void aes_sparc64_cbc_encrypt_256(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len, u64 *iv);
-void aes_sparc64_cbc_decrypt_128(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len, u64 *iv);
-void aes_sparc64_cbc_decrypt_192(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len, u64 *iv);
-void aes_sparc64_cbc_decrypt_256(const u64 *key, const u64 *input, u64 *output,
-				 unsigned int len, u64 *iv);
 #endif
 
 /**
diff --git a/lib/crypto/sparc/aes.h b/lib/crypto/sparc/aes.h
index b13e8046467ea..96251c22f4a31 100644
--- a/lib/crypto/sparc/aes.h
+++ b/lib/crypto/sparc/aes.h
@@ -14,26 +14,20 @@
 
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_aes_opcodes);
 
-EXPORT_SYMBOL_GPL(aes_sparc64_key_expand);
-EXPORT_SYMBOL_GPL(aes_sparc64_load_encrypt_keys_128);
-EXPORT_SYMBOL_GPL(aes_sparc64_load_encrypt_keys_192);
-EXPORT_SYMBOL_GPL(aes_sparc64_load_encrypt_keys_256);
-EXPORT_SYMBOL_GPL(aes_sparc64_load_decrypt_keys_128);
-EXPORT_SYMBOL_GPL(aes_sparc64_load_decrypt_keys_192);
-EXPORT_SYMBOL_GPL(aes_sparc64_load_decrypt_keys_256);
-EXPORT_SYMBOL_GPL(aes_sparc64_cbc_encrypt_128);
-EXPORT_SYMBOL_GPL(aes_sparc64_cbc_encrypt_192);
-EXPORT_SYMBOL_GPL(aes_sparc64_cbc_encrypt_256);
-EXPORT_SYMBOL_GPL(aes_sparc64_cbc_decrypt_128);
-EXPORT_SYMBOL_GPL(aes_sparc64_cbc_decrypt_192);
-EXPORT_SYMBOL_GPL(aes_sparc64_cbc_decrypt_256);
-
+void aes_sparc64_key_expand(const u32 *in_key, u64 *output_key,
+			    unsigned int key_len);
 void aes_sparc64_encrypt_128(const u64 *key, const u32 *input, u32 *output);
 void aes_sparc64_encrypt_192(const u64 *key, const u32 *input, u32 *output);
 void aes_sparc64_encrypt_256(const u64 *key, const u32 *input, u32 *output);
 void aes_sparc64_decrypt_128(const u64 *key, const u32 *input, u32 *output);
 void aes_sparc64_decrypt_192(const u64 *key, const u32 *input, u32 *output);
 void aes_sparc64_decrypt_256(const u64 *key, const u32 *input, u32 *output);
+void aes_sparc64_load_encrypt_keys_128(const u64 *key);
+void aes_sparc64_load_encrypt_keys_192(const u64 *key);
+void aes_sparc64_load_encrypt_keys_256(const u64 *key);
+void aes_sparc64_load_decrypt_keys_128(const u64 *key);
+void aes_sparc64_load_decrypt_keys_192(const u64 *key);
+void aes_sparc64_load_decrypt_keys_256(const u64 *key);
 
 static void aes_preparekey_arch(union aes_enckey_arch *k,
 				union aes_invkey_arch *inv_k,
@@ -246,6 +240,101 @@ static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
 }
 #endif /* CONFIG_CRYPTO_LIB_AES_ECB */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC)
+void aes_sparc64_cbc_encrypt_128(const u64 *key, const u64 *input, u64 *output,
+				 size_t len, u64 iv[2]);
+void aes_sparc64_cbc_encrypt_192(const u64 *key, const u64 *input, u64 *output,
+				 size_t len, u64 iv[2]);
+void aes_sparc64_cbc_encrypt_256(const u64 *key, const u64 *input, u64 *output,
+				 size_t len, u64 iv[2]);
+void aes_sparc64_cbc_decrypt_128(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len, u64 iv[2]);
+void aes_sparc64_cbc_decrypt_192(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len, u64 iv[2]);
+void aes_sparc64_cbc_decrypt_256(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len, u64 iv[2]);
+
+static __always_inline void aes_sparc64_cbc_crypt(const struct aes_enckey *key,
+						  const u64 *in, u64 *out,
+						  size_t len, u64 iv[2],
+						  bool enc)
+{
+	const u64 *rk = key->k.sparc_rndkeys;
+	const u64 *rk_end = &rk[2 * (key->nrounds + 1)];
+
+	if (enc) {
+		if (key->len == AES_KEYSIZE_128)
+			aes_sparc64_cbc_encrypt_128(rk, in, out, len, iv);
+		else if (key->len == AES_KEYSIZE_192)
+			aes_sparc64_cbc_encrypt_192(rk, in, out, len, iv);
+		else
+			aes_sparc64_cbc_encrypt_256(rk, in, out, len, iv);
+	} else {
+		if (key->len == AES_KEYSIZE_128)
+			aes_sparc64_cbc_decrypt_128(rk_end, in, out, len, iv);
+		else if (key->len == AES_KEYSIZE_192)
+			aes_sparc64_cbc_decrypt_192(rk_end, in, out, len, iv);
+		else
+			aes_sparc64_cbc_decrypt_256(rk_end, in, out, len, iv);
+	}
+}
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+static __always_inline bool
+aes_cbc_crypt_sparc64(u8 *dst, const u8 *src, size_t len, u8 iv[AES_BLOCK_SIZE],
+		      aes_encrypt_arg key_arg, bool enc)
+{
+	const struct aes_enckey *key = key_arg.enc_key;
+	u64 aligned_iv[2];
+
+	if (!static_branch_likely(&have_aes_opcodes))
+		return false;
+
+	memcpy(aligned_iv, iv, sizeof(aligned_iv));
+
+	aes_sparc64_load_round_keys(key, enc);
+
+	if (IS_ALIGNED((uintptr_t)src | (uintptr_t)dst, 8)) {
+		aes_sparc64_cbc_crypt(key, (const u64 *)src, (u64 *)dst, len,
+				      aligned_iv, enc);
+	} else {
+		u64 tmp[MISALIGNED_CHUNK_SIZE / sizeof(u64)];
+
+		do {
+			size_t n = min(len, sizeof(tmp));
+
+			memcpy(tmp, src, n);
+			aes_sparc64_cbc_crypt(key, tmp, tmp, n, aligned_iv,
+					      enc);
+			memcpy(dst, tmp, n);
+			src += n;
+			dst += n;
+			len -= n;
+		} while (len);
+		memzero_explicit(tmp, sizeof(tmp));
+	}
+	fprs_write(0);
+	memcpy(iv, aligned_iv, sizeof(aligned_iv));
+	return true;
+}
+
+#define aes_cbc_encrypt_arch aes_cbc_encrypt_arch
+static bool aes_cbc_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_enckey *key)
+{
+	return aes_cbc_crypt_sparc64(dst, src, len, iv, key, true);
+}
+
+#define aes_cbc_decrypt_arch aes_cbc_decrypt_arch
+static bool aes_cbc_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_key *key)
+{
+	return aes_cbc_crypt_sparc64(dst, src, len, iv, key, false);
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_CBC */
+
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
 void aes_sparc64_ctr_crypt_128(const u64 *key, const u64 *input, u64 *output,
 			       size_t len, u64 iv[2]);
@@ -407,4 +496,5 @@ static void aes_mod_init_arch(void)
 		return;
 
 	static_branch_enable(&have_aes_opcodes);
+	pr_info("Using sparc64 aes opcodes optimized AES implementation\n");
 }
diff --git a/lib/crypto/sparc/aes_asm.S b/lib/crypto/sparc/aes_asm.S
index fc63f3233ca23..35c3c29769bad 100644
--- a/lib/crypto/sparc/aes_asm.S
+++ b/lib/crypto/sparc/aes_asm.S
@@ -1178,6 +1178,7 @@ ENTRY(aes_sparc64_ecb_decrypt_256)
 ENDPROC(aes_sparc64_ecb_decrypt_256)
 #endif /* CONFIG_CRYPTO_LIB_AES_ECB */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC)
 	.align		32
 ENTRY(aes_sparc64_cbc_encrypt_128)
 	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
@@ -1357,6 +1358,7 @@ ENTRY(aes_sparc64_cbc_decrypt_256)
 	retl
 	 nop
 ENDPROC(aes_sparc64_cbc_decrypt_256)
+#endif /* CONFIG_CRYPTO_LIB_AES_CBC */
 
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
 	.align		32
-- 
2.56.1

