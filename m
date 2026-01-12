Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FC232E6B8;
	Mon, 12 Jan 2026 19:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245804; cv=none; b=l+opA65qjIxCA0YsLR6MRzfUxMy4KFH4fHR//PN3oRWWsJ626KS+SZ0InsBr78qiO6F+QlYyl8xl+ZYdphczZDm2PwW1OJmU9b0YXm/C/R5IFN5kAOQF2Kt4W1XjTcM/w+KjewJbGUkUVNf2r1uFUayJN9Ef2/2+/m2Cp13I39U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245804; c=relaxed/simple;
	bh=g5MvkBPONwRVRzJT68NyeO2krV6zGm/Kyvj5zIP7ZvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQfuWUSxN0m4B97RWXvdiaqpSC3wSBkoYx+roIfkQrYbsoYWXgdsvP6j14fRf60FjaHiJJ4YV5SKaXGr4cd+XjNTFsEnClDj06lvyWKgySDzApP/wBPMwxUkRQL6EdREeaEQmukRyE+y54oWqwSSEdb5jiC2UfMIeLmx1Mw1y5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=balRicSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="balRicSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AB2C2BC9E;
	Mon, 12 Jan 2026 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245804;
	bh=g5MvkBPONwRVRzJT68NyeO2krV6zGm/Kyvj5zIP7ZvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=balRicSfSJLDd+OQNdcwFspAZKFQ0vMK7Jrh+QBLAMP98qACHJ/mV5f4axBUki0YF
	 eQGho1v4+Am7kHyW5HQODAE9JIHoDqKwU6EFGsBMZHfJuXXgsVTiYsZ6ow7ZVuDqMY
	 01GaPkrgKYrbVp4p1pjyTIl5wiP71iHuphmb4AJiqxtNm1bohr/viimMvMB16Z9knD
	 RM/K5YZ/7/aJz8A+/O1x/X4AIkQJEYHgG2lqTC7+PhcMf9IMGZpfkM38pnK6Z/CotM
	 cQV9ooDK/YJbmZCH7Ge0nJwI+rlonGxTLs4x+P1EvAYwOIPjuT1hMqGPSUu78GRCkp
	 Ydui6sw9YEG2Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 12/35] lib/crypto: powerpc/aes: Migrate SPE optimized code into library
Date: Mon, 12 Jan 2026 11:20:10 -0800
Message-ID: <20260112192035.10427-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the PowerPC SPE AES assembly code into lib/crypto/, wire the key
expansion and single-block en/decryption functions up to the AES library
API, and remove the superseded "aes-ppc-spe" crypto_cipher algorithm.

The result is that both the AES library and crypto_cipher APIs are now
optimized with SPE, whereas previously only crypto_cipher was (and
optimizations weren't enabled by default, which this commit fixes too).

Note that many of the functions in the PowerPC SPE assembly code are
still used by the AES mode implementations in arch/powerpc/crypto/.  For
now, just export these functions.  These exports will go away once the
AES modes are migrated to the library as well.  (Trying to split up the
assembly files seemed like much more trouble than it would be worth.)

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/powerpc/crypto/Kconfig                   |  2 +-
 arch/powerpc/crypto/Makefile                  |  2 +-
 arch/powerpc/crypto/aes-spe-glue.c            | 88 ++-----------------
 include/crypto/aes.h                          | 31 +++++++
 lib/crypto/Kconfig                            |  1 +
 lib/crypto/Makefile                           |  9 ++
 .../crypto/powerpc}/aes-spe-core.S            |  0
 .../crypto/powerpc}/aes-spe-keys.S            |  0
 .../crypto/powerpc}/aes-spe-modes.S           |  0
 .../crypto/powerpc}/aes-spe-regs.h            |  0
 .../crypto/powerpc}/aes-tab-4k.S              |  0
 lib/crypto/powerpc/aes.h                      | 74 ++++++++++++++++
 12 files changed, 122 insertions(+), 85 deletions(-)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-core.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-keys.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-modes.S (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-spe-regs.h (100%)
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/aes-tab-4k.S (100%)
 create mode 100644 lib/crypto/powerpc/aes.h

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 662aed46f9c7..2d056f1fc90f 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -3,13 +3,13 @@
 menu "Accelerated Cryptographic Algorithms for CPU (powerpc)"
 
 config CRYPTO_AES_PPC_SPE
 	tristate "Ciphers: AES, modes: ECB/CBC/CTR/XTS (SPE)"
 	depends on SPE
+	select CRYPTO_LIB_AES
 	select CRYPTO_SKCIPHER
 	help
-	  Block ciphers: AES cipher algorithms (FIPS-197)
 	  Length-preserving ciphers: AES with ECB, CBC, CTR, and XTS modes
 
 	  Architecture: powerpc using:
 	  - SPE (Signal Processing Engine) extensions
 
diff --git a/arch/powerpc/crypto/Makefile b/arch/powerpc/crypto/Makefile
index 5960e5300db7..e22310da86b5 100644
--- a/arch/powerpc/crypto/Makefile
+++ b/arch/powerpc/crypto/Makefile
@@ -7,11 +7,11 @@
 
 obj-$(CONFIG_CRYPTO_AES_PPC_SPE) += aes-ppc-spe.o
 obj-$(CONFIG_CRYPTO_AES_GCM_P10) += aes-gcm-p10-crypto.o
 obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
 
-aes-ppc-spe-y := aes-spe-core.o aes-spe-keys.o aes-tab-4k.o aes-spe-modes.o aes-spe-glue.o
+aes-ppc-spe-y := aes-spe-glue.o
 aes-gcm-p10-crypto-y := aes-gcm-p10-glue.o aes-gcm-p10.o ghashp10-ppc.o aesp10-ppc.o
 vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o aes_xts.o ghash.o
 
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
 override flavour := linux-ppc64le
diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index efab78a3a8f6..7d2827e65240 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -49,34 +49,10 @@ struct ppc_xts_ctx {
 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
 	u32 key_twk[AES_MAX_KEYLENGTH_U32];
 	u32 rounds;
 };
 
-extern void ppc_encrypt_aes(u8 *out, const u8 *in, u32 *key_enc, u32 rounds);
-extern void ppc_decrypt_aes(u8 *out, const u8 *in, u32 *key_dec, u32 rounds);
-extern void ppc_encrypt_ecb(u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
-			    u32 bytes);
-extern void ppc_decrypt_ecb(u8 *out, const u8 *in, u32 *key_dec, u32 rounds,
-			    u32 bytes);
-extern void ppc_encrypt_cbc(u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
-			    u32 bytes, u8 *iv);
-extern void ppc_decrypt_cbc(u8 *out, const u8 *in, u32 *key_dec, u32 rounds,
-			    u32 bytes, u8 *iv);
-extern void ppc_crypt_ctr  (u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
-			    u32 bytes, u8 *iv);
-extern void ppc_encrypt_xts(u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
-			    u32 bytes, u8 *iv, u32 *key_twk);
-extern void ppc_decrypt_xts(u8 *out, const u8 *in, u32 *key_dec, u32 rounds,
-			    u32 bytes, u8 *iv, u32 *key_twk);
-
-extern void ppc_expand_key_128(u32 *key_enc, const u8 *key);
-extern void ppc_expand_key_192(u32 *key_enc, const u8 *key);
-extern void ppc_expand_key_256(u32 *key_enc, const u8 *key);
-
-extern void ppc_generate_decrypt_key(u32 *key_dec,u32 *key_enc,
-				     unsigned int key_len);
-
 static void spe_begin(void)
 {
 	/* disable preemption and save users SPE registers if required */
 	preempt_disable();
 	enable_kernel_spe();
@@ -87,14 +63,14 @@ static void spe_end(void)
 	disable_kernel_spe();
 	/* reenable preemption */
 	preempt_enable();
 }
 
-static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
-		unsigned int key_len)
+static int ppc_aes_setkey_skcipher(struct crypto_skcipher *tfm,
+				   const u8 *in_key, unsigned int key_len)
 {
-	struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	switch (key_len) {
 	case AES_KEYSIZE_128:
 		ctx->rounds = 4;
 		ppc_expand_key_128(ctx->key_enc, in_key);
@@ -114,16 +90,10 @@ static int ppc_aes_setkey(struct crypto_tfm *tfm, const u8 *in_key,
 	ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
 
 	return 0;
 }
 
-static int ppc_aes_setkey_skcipher(struct crypto_skcipher *tfm,
-				   const u8 *in_key, unsigned int key_len)
-{
-	return ppc_aes_setkey(crypto_skcipher_tfm(tfm), in_key, key_len);
-}
-
 static int ppc_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		   unsigned int key_len)
 {
 	struct ppc_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err;
@@ -157,28 +127,10 @@ static int ppc_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	ppc_generate_decrypt_key(ctx->key_dec, ctx->key_enc, key_len);
 
 	return 0;
 }
 
-static void ppc_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	spe_begin();
-	ppc_encrypt_aes(out, in, ctx->key_enc, ctx->rounds);
-	spe_end();
-}
-
-static void ppc_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
-{
-	struct ppc_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	spe_begin();
-	ppc_decrypt_aes(out, in, ctx->key_dec, ctx->rounds);
-	spe_end();
-}
-
 static int ppc_ecb_crypt(struct skcipher_request *req, bool enc)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct ppc_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
@@ -408,30 +360,10 @@ static int ppc_xts_decrypt(struct skcipher_request *req)
  * This improves IPsec thoughput by another few percent. Additionally we assume
  * that AES context is always aligned to at least 8 bytes because it is created
  * with kmalloc() in the crypto infrastructure
  */
 
-static struct crypto_alg aes_cipher_alg = {
-	.cra_name		=	"aes",
-	.cra_driver_name	=	"aes-ppc-spe",
-	.cra_priority		=	300,
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	AES_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct ppc_aes_ctx),
-	.cra_alignmask		=	0,
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{
-		.cipher = {
-			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
-			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey		=	ppc_aes_setkey,
-			.cia_encrypt		=	ppc_aes_encrypt,
-			.cia_decrypt		=	ppc_aes_decrypt
-		}
-	}
-};
-
 static struct skcipher_alg aes_skcipher_algs[] = {
 	{
 		.base.cra_name		=	"ecb(aes)",
 		.base.cra_driver_name	=	"ecb-ppc-spe",
 		.base.cra_priority	=	300,
@@ -486,26 +418,16 @@ static struct skcipher_alg aes_skcipher_algs[] = {
 	}
 };
 
 static int __init ppc_aes_mod_init(void)
 {
-	int err;
-
-	err = crypto_register_alg(&aes_cipher_alg);
-	if (err)
-		return err;
-
-	err = crypto_register_skciphers(aes_skcipher_algs,
-					ARRAY_SIZE(aes_skcipher_algs));
-	if (err)
-		crypto_unregister_alg(&aes_cipher_alg);
-	return err;
+	return crypto_register_skciphers(aes_skcipher_algs,
+					 ARRAY_SIZE(aes_skcipher_algs));
 }
 
 static void __exit ppc_aes_mod_fini(void)
 {
-	crypto_unregister_alg(&aes_cipher_alg);
 	crypto_unregister_skciphers(aes_skcipher_algs,
 				    ARRAY_SIZE(aes_skcipher_algs));
 }
 
 module_init(ppc_aes_mod_init);
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 18af1acbde58..c893c9214cb7 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -18,14 +18,26 @@
 #define AES_MAX_KEYLENGTH	(15 * 16)
 #define AES_MAX_KEYLENGTH_U32	(AES_MAX_KEYLENGTH / sizeof(u32))
 
 union aes_enckey_arch {
 	u32 rndkeys[AES_MAX_KEYLENGTH_U32];
+#ifdef CONFIG_CRYPTO_LIB_AES_ARCH
+#if defined(CONFIG_PPC) && defined(CONFIG_SPE)
+	/* Used unconditionally (when SPE AES code is enabled in kconfig) */
+	u32 spe_enc_key[AES_MAX_KEYLENGTH_U32] __aligned(8);
+#endif
+#endif /* CONFIG_CRYPTO_LIB_AES_ARCH */
 };
 
 union aes_invkey_arch {
 	u32 inv_rndkeys[AES_MAX_KEYLENGTH_U32];
+#ifdef CONFIG_CRYPTO_LIB_AES_ARCH
+#if defined(CONFIG_PPC) && defined(CONFIG_SPE)
+	/* Used unconditionally (when SPE AES code is enabled in kconfig) */
+	u32 spe_dec_key[AES_MAX_KEYLENGTH_U32] __aligned(8);
+#endif
+#endif /* CONFIG_CRYPTO_LIB_AES_ARCH */
 };
 
 /**
  * struct aes_enckey - An AES key prepared for encryption
  * @len: Key length in bytes: 16 for AES-128, 24 for AES-192, 32 for AES-256.
@@ -122,10 +134,29 @@ int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
  * that code is migrated into lib/crypto/.
  */
 #ifdef CONFIG_ARM64
 int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		     unsigned int key_len);
+#elif defined(CONFIG_PPC)
+void ppc_expand_key_128(u32 *key_enc, const u8 *key);
+void ppc_expand_key_192(u32 *key_enc, const u8 *key);
+void ppc_expand_key_256(u32 *key_enc, const u8 *key);
+void ppc_generate_decrypt_key(u32 *key_dec, u32 *key_enc, unsigned int key_len);
+void ppc_encrypt_ecb(u8 *out, const u8 *in, u32 *key_enc, u32 rounds,
+		     u32 bytes);
+void ppc_decrypt_ecb(u8 *out, const u8 *in, u32 *key_dec, u32 rounds,
+		     u32 bytes);
+void ppc_encrypt_cbc(u8 *out, const u8 *in, u32 *key_enc, u32 rounds, u32 bytes,
+		     u8 *iv);
+void ppc_decrypt_cbc(u8 *out, const u8 *in, u32 *key_dec, u32 rounds, u32 bytes,
+		     u8 *iv);
+void ppc_crypt_ctr(u8 *out, const u8 *in, u32 *key_enc, u32 rounds, u32 bytes,
+		   u8 *iv);
+void ppc_encrypt_xts(u8 *out, const u8 *in, u32 *key_enc, u32 rounds, u32 bytes,
+		     u8 *iv, u32 *key_twk);
+void ppc_decrypt_xts(u8 *out, const u8 *in, u32 *key_dec, u32 rounds, u32 bytes,
+		     u8 *iv, u32 *key_twk);
 #endif
 
 /**
  * aes_preparekey() - Prepare an AES key for encryption and decryption
  * @key: (output) The key structure to initialize
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index ead47b2a7db6..cfc6171203d0 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -14,10 +14,11 @@ config CRYPTO_LIB_AES
 config CRYPTO_LIB_AES_ARCH
 	bool
 	depends on CRYPTO_LIB_AES && !UML && !KMSAN
 	default y if ARM
 	default y if ARM64
+	default y if PPC && SPE
 
 config CRYPTO_LIB_AESCFB
 	tristate
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_UTILS
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 1b690c63fafb..d68fde004104 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -27,10 +27,19 @@ libaes-$(CONFIG_ARM) += arm/aes-cipher-core.o
 ifeq ($(CONFIG_ARM64),y)
 libaes-y += arm64/aes-cipher-core.o
 libaes-$(CONFIG_KERNEL_MODE_NEON) += arm64/aes-ce-core.o
 endif
 
+ifeq ($(CONFIG_PPC),y)
+ifeq ($(CONFIG_SPE),y)
+libaes-y += powerpc/aes-spe-core.o \
+	    powerpc/aes-spe-keys.o \
+	    powerpc/aes-spe-modes.o \
+	    powerpc/aes-tab-4k.o
+endif
+endif # CONFIG_PPC
+
 endif # CONFIG_CRYPTO_LIB_AES_ARCH
 
 ################################################################################
 
 obj-$(CONFIG_CRYPTO_LIB_AESCFB)			+= libaescfb.o
diff --git a/arch/powerpc/crypto/aes-spe-core.S b/lib/crypto/powerpc/aes-spe-core.S
similarity index 100%
rename from arch/powerpc/crypto/aes-spe-core.S
rename to lib/crypto/powerpc/aes-spe-core.S
diff --git a/arch/powerpc/crypto/aes-spe-keys.S b/lib/crypto/powerpc/aes-spe-keys.S
similarity index 100%
rename from arch/powerpc/crypto/aes-spe-keys.S
rename to lib/crypto/powerpc/aes-spe-keys.S
diff --git a/arch/powerpc/crypto/aes-spe-modes.S b/lib/crypto/powerpc/aes-spe-modes.S
similarity index 100%
rename from arch/powerpc/crypto/aes-spe-modes.S
rename to lib/crypto/powerpc/aes-spe-modes.S
diff --git a/arch/powerpc/crypto/aes-spe-regs.h b/lib/crypto/powerpc/aes-spe-regs.h
similarity index 100%
rename from arch/powerpc/crypto/aes-spe-regs.h
rename to lib/crypto/powerpc/aes-spe-regs.h
diff --git a/arch/powerpc/crypto/aes-tab-4k.S b/lib/crypto/powerpc/aes-tab-4k.S
similarity index 100%
rename from arch/powerpc/crypto/aes-tab-4k.S
rename to lib/crypto/powerpc/aes-tab-4k.S
diff --git a/lib/crypto/powerpc/aes.h b/lib/crypto/powerpc/aes.h
new file mode 100644
index 000000000000..cf22020f9050
--- /dev/null
+++ b/lib/crypto/powerpc/aes.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
+ * Copyright 2026 Google LLC
+ */
+#include <asm/simd.h>
+#include <asm/switch_to.h>
+#include <linux/cpufeature.h>
+#include <linux/jump_label.h>
+#include <linux/preempt.h>
+#include <linux/uaccess.h>
+
+EXPORT_SYMBOL_GPL(ppc_expand_key_128);
+EXPORT_SYMBOL_GPL(ppc_expand_key_192);
+EXPORT_SYMBOL_GPL(ppc_expand_key_256);
+EXPORT_SYMBOL_GPL(ppc_generate_decrypt_key);
+EXPORT_SYMBOL_GPL(ppc_encrypt_ecb);
+EXPORT_SYMBOL_GPL(ppc_decrypt_ecb);
+EXPORT_SYMBOL_GPL(ppc_encrypt_cbc);
+EXPORT_SYMBOL_GPL(ppc_decrypt_cbc);
+EXPORT_SYMBOL_GPL(ppc_crypt_ctr);
+EXPORT_SYMBOL_GPL(ppc_encrypt_xts);
+EXPORT_SYMBOL_GPL(ppc_decrypt_xts);
+
+void ppc_encrypt_aes(u8 *out, const u8 *in, const u32 *key_enc, u32 rounds);
+void ppc_decrypt_aes(u8 *out, const u8 *in, const u32 *key_dec, u32 rounds);
+
+static void spe_begin(void)
+{
+	/* disable preemption and save users SPE registers if required */
+	preempt_disable();
+	enable_kernel_spe();
+}
+
+static void spe_end(void)
+{
+	disable_kernel_spe();
+	/* reenable preemption */
+	preempt_enable();
+}
+
+static void aes_preparekey_arch(union aes_enckey_arch *k,
+				union aes_invkey_arch *inv_k,
+				const u8 *in_key, int key_len, int nrounds)
+{
+	if (key_len == AES_KEYSIZE_128)
+		ppc_expand_key_128(k->spe_enc_key, in_key);
+	else if (key_len == AES_KEYSIZE_192)
+		ppc_expand_key_192(k->spe_enc_key, in_key);
+	else
+		ppc_expand_key_256(k->spe_enc_key, in_key);
+
+	if (inv_k)
+		ppc_generate_decrypt_key(inv_k->spe_dec_key, k->spe_enc_key,
+					 key_len);
+}
+
+static void aes_encrypt_arch(const struct aes_enckey *key,
+			     u8 out[AES_BLOCK_SIZE],
+			     const u8 in[AES_BLOCK_SIZE])
+{
+	spe_begin();
+	ppc_encrypt_aes(out, in, key->k.spe_enc_key, key->nrounds / 2 - 1);
+	spe_end();
+}
+
+static void aes_decrypt_arch(const struct aes_key *key,
+			     u8 out[AES_BLOCK_SIZE],
+			     const u8 in[AES_BLOCK_SIZE])
+{
+	spe_begin();
+	ppc_decrypt_aes(out, in, key->inv_k.spe_dec_key, key->nrounds / 2 - 1);
+	spe_end();
+}
-- 
2.52.0

