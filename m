From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 2/7] crypto: aes - refactor shared routines into separate core module
Date: Tue, 20 Jun 2017 11:28:55 +0200
Message-ID: <1497950940-24243-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, nico@linaro.org, ebiggers3@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36178 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdFTJ3H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 05:29:07 -0400
Received: by mail-wm0-f49.google.com with SMTP id m125so15864245wmm.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2017 02:29:07 -0700 (PDT)
In-Reply-To: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation of further refactoring and cleanup of the AES code, move
the implementations of crypto_aes_expand_key() and crypto_aes_set_key()
into a separate module called aes_core, along with the forward Sbox and
some GF(2^8) routines that these routines rely on.

Also, introduce crypto_aes_[en|de]crypt() based on the fixed time code,
which will be used in future patches by time invariant SIMD drivers that
may need to fallback to scalar code in exceptional circumstances. These
fallbacks offer a different tradeoff between time invariance and speed,
but are generally more appropriate due to the smaller size and cache
footprint.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/Kconfig   |   2 +-
 arch/arm64/crypto/Kconfig |   2 +-
 crypto/Kconfig            |   5 +
 crypto/Makefile           |   1 +
 crypto/aes_core.c         | 333 ++++++++++++++++++++
 crypto/aes_generic.c      | 178 -----------
 crypto/aes_ti.c           | 315 ++----------------
 drivers/crypto/Kconfig    |   8 +-
 include/crypto/aes.h      |   6 +
 9 files changed, 376 insertions(+), 474 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index b9adedcc5b2e..fd77aebcb7a9 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -73,7 +73,7 @@ config CRYPTO_AES_ARM_BS
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_SIMD
-	select CRYPTO_AES
+	select CRYPTO_AES_CORE
 	help
 	  Use a faster and more secure NEON based implementation of AES in CBC,
 	  CTR and XTS modes
diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index d92293747d63..db55e069c17b 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -68,7 +68,7 @@ config CRYPTO_AES_ARM64_NEON_BLK
 	tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
 	depends on ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_AES_CORE
 	select CRYPTO_SIMD
 
 config CRYPTO_CHACHA20_NEON
diff --git a/crypto/Kconfig b/crypto/Kconfig
index caa770e535a2..b4edea2aed22 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -894,9 +894,13 @@ config CRYPTO_GHASH_CLMUL_NI_INTEL
 
 comment "Ciphers"
 
+config CRYPTO_AES_CORE
+	tristate
+
 config CRYPTO_AES
 	tristate "AES cipher algorithms"
 	select CRYPTO_ALGAPI
+	select CRYPTO_AES_CORE
 	help
 	  AES cipher algorithms (FIPS-197). AES uses the Rijndael
 	  algorithm.
@@ -917,6 +921,7 @@ config CRYPTO_AES
 config CRYPTO_AES_TI
 	tristate "Fixed time AES cipher"
 	select CRYPTO_ALGAPI
+	select CRYPTO_AES_CORE
 	help
 	  This is a generic implementation of AES that attempts to eliminate
 	  data dependent latencies as much as possible without affecting
diff --git a/crypto/Makefile b/crypto/Makefile
index d41f0331b085..0979ca461ddb 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 CFLAGS_serpent_generic.o := $(call cc-option,-fsched-pressure)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
+obj-$(CONFIG_CRYPTO_AES_CORE) += aes_core.o
 obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
 obj-$(CONFIG_CRYPTO_AES_TI) += aes_ti.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
diff --git a/crypto/aes_core.c b/crypto/aes_core.c
new file mode 100644
index 000000000000..d3c8b5eaaf42
--- /dev/null
+++ b/crypto/aes_core.c
@@ -0,0 +1,333 @@
+/*
+ * Shared AES primitives for accelerated and generic implementations
+ *
+ * Copyright (C) 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <crypto/aes.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+#include <asm/unaligned.h>
+
+static const u8 __cacheline_aligned aes_sbox[] = {
+	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
+	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
+	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
+	0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
+	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
+	0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
+	0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
+	0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
+	0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
+	0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
+	0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
+	0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
+	0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
+	0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
+	0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
+	0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
+	0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
+	0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
+	0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
+	0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
+	0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
+	0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
+	0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
+	0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
+	0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
+	0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
+	0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
+	0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
+	0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
+	0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
+	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
+	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
+};
+
+static const u8 __cacheline_aligned aes_inv_sbox[] = {
+	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
+	0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
+	0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,
+	0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
+	0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d,
+	0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
+	0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2,
+	0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
+	0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16,
+	0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
+	0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda,
+	0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
+	0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a,
+	0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
+	0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02,
+	0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
+	0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea,
+	0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
+	0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85,
+	0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
+	0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89,
+	0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
+	0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20,
+	0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
+	0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31,
+	0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
+	0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d,
+	0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
+	0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0,
+	0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
+	0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26,
+	0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d,
+};
+
+static u32 mul_by_x(u32 w)
+{
+	u32 x = w & 0x7f7f7f7f;
+	u32 y = w & 0x80808080;
+
+	/* multiply by polynomial 'x' (0b10) in GF(2^8) */
+	return (x << 1) ^ (y >> 7) * 0x1b;
+}
+
+static u32 mul_by_x2(u32 w)
+{
+	u32 x = w & 0x3f3f3f3f;
+	u32 y = w & 0x80808080;
+	u32 z = w & 0x40404040;
+
+	/* multiply by polynomial 'x^2' (0b100) in GF(2^8) */
+	return (x << 2) ^ (y >> 7) * 0x36 ^ (z >> 6) * 0x1b;
+}
+
+static u32 mix_columns(u32 x)
+{
+	/*
+	 * Perform the following matrix multiplication in GF(2^8)
+	 *
+	 * | 0x2 0x3 0x1 0x1 |   | x[0] |
+	 * | 0x1 0x2 0x3 0x1 |   | x[1] |
+	 * | 0x1 0x1 0x2 0x3 | x | x[2] |
+	 * | 0x3 0x1 0x1 0x2 |   | x[3] |
+	 */
+	u32 y = mul_by_x(x) ^ ror32(x, 16);
+
+	return y ^ ror32(x ^ y, 8);
+}
+
+static u32 inv_mix_columns(u32 x)
+{
+	/*
+	 * Perform the following matrix multiplication in GF(2^8)
+	 *
+	 * | 0xe 0xb 0xd 0x9 |   | x[0] |
+	 * | 0x9 0xe 0xb 0xd |   | x[1] |
+	 * | 0xd 0x9 0xe 0xb | x | x[2] |
+	 * | 0xb 0xd 0x9 0xe |   | x[3] |
+	 *
+	 * which can conveniently be reduced to
+	 *
+	 * | 0x2 0x3 0x1 0x1 |   | 0x5 0x0 0x4 0x0 |   | x[0] |
+	 * | 0x1 0x2 0x3 0x1 |   | 0x0 0x5 0x0 0x4 |   | x[1] |
+	 * | 0x1 0x1 0x2 0x3 | x | 0x4 0x0 0x5 0x0 | x | x[2] |
+	 * | 0x3 0x1 0x1 0x2 |   | 0x0 0x4 0x0 0x5 |   | x[3] |
+	 */
+	u32 y = mul_by_x2(x);
+
+	return mix_columns(x ^ y ^ ror32(y, 16));
+}
+
+static __always_inline u32 subshift(u32 in[], int pos)
+{
+	return (aes_sbox[in[pos] & 0xff]) ^
+	       (aes_sbox[(in[(pos + 1) % 4] >>  8) & 0xff] <<  8) ^
+	       (aes_sbox[(in[(pos + 2) % 4] >> 16) & 0xff] << 16) ^
+	       (aes_sbox[(in[(pos + 3) % 4] >> 24) & 0xff] << 24);
+}
+
+static __always_inline u32 inv_subshift(u32 in[], int pos)
+{
+	return (aes_inv_sbox[in[pos] & 0xff]) ^
+	       (aes_inv_sbox[(in[(pos + 3) % 4] >>  8) & 0xff] <<  8) ^
+	       (aes_inv_sbox[(in[(pos + 2) % 4] >> 16) & 0xff] << 16) ^
+	       (aes_inv_sbox[(in[(pos + 1) % 4] >> 24) & 0xff] << 24);
+}
+
+static u32 subw(u32 in)
+{
+	return (aes_sbox[in & 0xff]) ^
+	       (aes_sbox[(in >>  8) & 0xff] <<  8) ^
+	       (aes_sbox[(in >> 16) & 0xff] << 16) ^
+	       (aes_sbox[(in >> 24) & 0xff] << 24);
+}
+
+int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
+			  unsigned int key_len)
+{
+	u32 kwords = key_len / sizeof(u32);
+	u32 rc, i, j;
+
+	if (key_len != AES_KEYSIZE_128 &&
+	    key_len != AES_KEYSIZE_192 &&
+	    key_len != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->key_length = key_len;
+
+	for (i = 0; i < kwords; i++)
+		ctx->key_enc[i] = get_unaligned_le32(in_key + i * sizeof(u32));
+
+	for (i = 0, rc = 1; i < 10; i++, rc = mul_by_x(rc)) {
+		u32 *rki = ctx->key_enc + (i * kwords);
+		u32 *rko = rki + kwords;
+
+		rko[0] = ror32(subw(rki[kwords - 1]), 8) ^ rc ^ rki[0];
+		rko[1] = rko[0] ^ rki[1];
+		rko[2] = rko[1] ^ rki[2];
+		rko[3] = rko[2] ^ rki[3];
+
+		if (key_len == AES_KEYSIZE_192) {
+			if (i >= 7)
+				break;
+			rko[4] = rko[3] ^ rki[4];
+			rko[5] = rko[4] ^ rki[5];
+		} else if (key_len == AES_KEYSIZE_256) {
+			if (i >= 6)
+				break;
+			rko[4] = subw(rko[3]) ^ rki[4];
+			rko[5] = rko[4] ^ rki[5];
+			rko[6] = rko[5] ^ rki[6];
+			rko[7] = rko[6] ^ rki[7];
+		}
+	}
+
+	/*
+	 * Generate the decryption keys for the Equivalent Inverse Cipher.
+	 * This involves reversing the order of the round keys, and applying
+	 * the Inverse Mix Columns transformation to all but the first and
+	 * the last one.
+	 */
+	ctx->key_dec[0] = ctx->key_enc[key_len + 24];
+	ctx->key_dec[1] = ctx->key_enc[key_len + 25];
+	ctx->key_dec[2] = ctx->key_enc[key_len + 26];
+	ctx->key_dec[3] = ctx->key_enc[key_len + 27];
+
+	for (i = 4, j = key_len + 20; j > 0; i += 4, j -= 4) {
+		ctx->key_dec[i]     = inv_mix_columns(ctx->key_enc[j]);
+		ctx->key_dec[i + 1] = inv_mix_columns(ctx->key_enc[j + 1]);
+		ctx->key_dec[i + 2] = inv_mix_columns(ctx->key_enc[j + 2]);
+		ctx->key_dec[i + 3] = inv_mix_columns(ctx->key_enc[j + 3]);
+	}
+
+	ctx->key_dec[i]     = ctx->key_enc[0];
+	ctx->key_dec[i + 1] = ctx->key_enc[1];
+	ctx->key_dec[i + 2] = ctx->key_enc[2];
+	ctx->key_dec[i + 3] = ctx->key_enc[3];
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_aes_expand_key);
+
+/**
+ * crypto_aes_set_key - Set the AES key.
+ * @tfm:	The %crypto_tfm that is used in the context.
+ * @in_key:	The input key.
+ * @key_len:	The size of the key.
+ *
+ * Returns 0 on success, on failure the %CRYPTO_TFM_RES_BAD_KEY_LEN flag in tfm
+ * is set. The function uses crypto_aes_expand_key() to expand the key.
+ * &crypto_aes_ctx _must_ be the private data embedded in @tfm which is
+ * retrieved with crypto_tfm_ctx().
+ */
+int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+		unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (crypto_aes_expand_key(ctx, in_key, key_len)) {
+		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_aes_set_key);
+
+void crypto_aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
+{
+	const u32 *rkp = ctx->key_enc + 4;
+	int rounds = 6 + ctx->key_length / 4;
+	u32 st0[4], st1[4];
+	int round;
+
+	st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
+	st0[1] = ctx->key_enc[1] ^ get_unaligned_le32(in + 4);
+	st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
+	st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
+
+	for (round = 0;; round += 2, rkp += 8) {
+		st1[0] = mix_columns(subshift(st0, 0)) ^ rkp[0];
+		st1[1] = mix_columns(subshift(st0, 1)) ^ rkp[1];
+		st1[2] = mix_columns(subshift(st0, 2)) ^ rkp[2];
+		st1[3] = mix_columns(subshift(st0, 3)) ^ rkp[3];
+
+		if (round == rounds - 2)
+			break;
+
+		st0[0] = mix_columns(subshift(st1, 0)) ^ rkp[4];
+		st0[1] = mix_columns(subshift(st1, 1)) ^ rkp[5];
+		st0[2] = mix_columns(subshift(st1, 2)) ^ rkp[6];
+		st0[3] = mix_columns(subshift(st1, 3)) ^ rkp[7];
+	}
+
+	put_unaligned_le32(subshift(st1, 0) ^ rkp[4], out);
+	put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
+	put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
+	put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
+}
+EXPORT_SYMBOL_GPL(crypto_aes_encrypt);
+
+void crypto_aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
+{
+	const u32 *rkp = ctx->key_dec + 4;
+	int rounds = 6 + ctx->key_length / 4;
+	u32 st0[4], st1[4];
+	int round;
+
+	st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
+	st0[1] = ctx->key_dec[1] ^ get_unaligned_le32(in + 4);
+	st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
+	st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
+
+	for (round = 0;; round += 2, rkp += 8) {
+		st1[0] = inv_mix_columns(inv_subshift(st0, 0)) ^ rkp[0];
+		st1[1] = inv_mix_columns(inv_subshift(st0, 1)) ^ rkp[1];
+		st1[2] = inv_mix_columns(inv_subshift(st0, 2)) ^ rkp[2];
+		st1[3] = inv_mix_columns(inv_subshift(st0, 3)) ^ rkp[3];
+
+		if (round == rounds - 2)
+			break;
+
+		st0[0] = inv_mix_columns(inv_subshift(st1, 0)) ^ rkp[4];
+		st0[1] = inv_mix_columns(inv_subshift(st1, 1)) ^ rkp[5];
+		st0[2] = inv_mix_columns(inv_subshift(st1, 2)) ^ rkp[6];
+		st0[3] = inv_mix_columns(inv_subshift(st1, 3)) ^ rkp[7];
+	}
+
+	put_unaligned_le32(inv_subshift(st1, 0) ^ rkp[4], out);
+	put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
+	put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
+	put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
+}
+EXPORT_SYMBOL_GPL(crypto_aes_decrypt);
+
+extern volatile const u8 crypto_aes_sbox[256] __alias(aes_sbox);
+EXPORT_SYMBOL_GPL(crypto_aes_sbox);
+
+extern volatile const u8 crypto_aes_inv_sbox[256] __alias(aes_inv_sbox);
+EXPORT_SYMBOL_GPL(crypto_aes_inv_sbox);
+
+MODULE_DESCRIPTION("Shared AES core routines");
+MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_LICENSE("GPL v2");
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index ca554d57d01e..c0a7cf9ab574 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -61,8 +61,6 @@ static inline u8 byte(const u32 x, const unsigned n)
 	return x >> (n << 3);
 }
 
-static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
-
 __visible const u32 crypto_ft_tab[4][256] = {
 	{
 		0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
@@ -1124,182 +1122,6 @@ EXPORT_SYMBOL_GPL(crypto_fl_tab);
 EXPORT_SYMBOL_GPL(crypto_it_tab);
 EXPORT_SYMBOL_GPL(crypto_il_tab);
 
-/* initialise the key schedule from the user supplied key */
-
-#define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
-
-#define imix_col(y, x)	do {		\
-	u	= star_x(x);		\
-	v	= star_x(u);		\
-	w	= star_x(v);		\
-	t	= w ^ (x);		\
-	(y)	= u ^ v ^ w;		\
-	(y)	^= ror32(u ^ t, 8) ^	\
-		ror32(v ^ t, 16) ^	\
-		ror32(t, 24);		\
-} while (0)
-
-#define ls_box(x)		\
-	crypto_fl_tab[0][byte(x, 0)] ^	\
-	crypto_fl_tab[1][byte(x, 1)] ^	\
-	crypto_fl_tab[2][byte(x, 2)] ^	\
-	crypto_fl_tab[3][byte(x, 3)]
-
-#define loop4(i)	do {		\
-	t = ror32(t, 8);		\
-	t = ls_box(t) ^ rco_tab[i];	\
-	t ^= ctx->key_enc[4 * i];		\
-	ctx->key_enc[4 * i + 4] = t;		\
-	t ^= ctx->key_enc[4 * i + 1];		\
-	ctx->key_enc[4 * i + 5] = t;		\
-	t ^= ctx->key_enc[4 * i + 2];		\
-	ctx->key_enc[4 * i + 6] = t;		\
-	t ^= ctx->key_enc[4 * i + 3];		\
-	ctx->key_enc[4 * i + 7] = t;		\
-} while (0)
-
-#define loop6(i)	do {		\
-	t = ror32(t, 8);		\
-	t = ls_box(t) ^ rco_tab[i];	\
-	t ^= ctx->key_enc[6 * i];		\
-	ctx->key_enc[6 * i + 6] = t;		\
-	t ^= ctx->key_enc[6 * i + 1];		\
-	ctx->key_enc[6 * i + 7] = t;		\
-	t ^= ctx->key_enc[6 * i + 2];		\
-	ctx->key_enc[6 * i + 8] = t;		\
-	t ^= ctx->key_enc[6 * i + 3];		\
-	ctx->key_enc[6 * i + 9] = t;		\
-	t ^= ctx->key_enc[6 * i + 4];		\
-	ctx->key_enc[6 * i + 10] = t;		\
-	t ^= ctx->key_enc[6 * i + 5];		\
-	ctx->key_enc[6 * i + 11] = t;		\
-} while (0)
-
-#define loop8tophalf(i)	do {			\
-	t = ror32(t, 8);			\
-	t = ls_box(t) ^ rco_tab[i];		\
-	t ^= ctx->key_enc[8 * i];			\
-	ctx->key_enc[8 * i + 8] = t;			\
-	t ^= ctx->key_enc[8 * i + 1];			\
-	ctx->key_enc[8 * i + 9] = t;			\
-	t ^= ctx->key_enc[8 * i + 2];			\
-	ctx->key_enc[8 * i + 10] = t;			\
-	t ^= ctx->key_enc[8 * i + 3];			\
-	ctx->key_enc[8 * i + 11] = t;			\
-} while (0)
-
-#define loop8(i)	do {				\
-	loop8tophalf(i);				\
-	t  = ctx->key_enc[8 * i + 4] ^ ls_box(t);	\
-	ctx->key_enc[8 * i + 12] = t;			\
-	t ^= ctx->key_enc[8 * i + 5];			\
-	ctx->key_enc[8 * i + 13] = t;			\
-	t ^= ctx->key_enc[8 * i + 6];			\
-	ctx->key_enc[8 * i + 14] = t;			\
-	t ^= ctx->key_enc[8 * i + 7];			\
-	ctx->key_enc[8 * i + 15] = t;			\
-} while (0)
-
-/**
- * crypto_aes_expand_key - Expands the AES key as described in FIPS-197
- * @ctx:	The location where the computed key will be stored.
- * @in_key:	The supplied key.
- * @key_len:	The length of the supplied key.
- *
- * Returns 0 on success. The function fails only if an invalid key size (or
- * pointer) is supplied.
- * The expanded key size is 240 bytes (max of 14 rounds with a unique 16 bytes
- * key schedule plus a 16 bytes key which is used before the first round).
- * The decryption key is prepared for the "Equivalent Inverse Cipher" as
- * described in FIPS-197. The first slot (16 bytes) of each key (enc or dec) is
- * for the initial combination, the second slot for the first round and so on.
- */
-int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
-		unsigned int key_len)
-{
-	u32 i, t, u, v, w, j;
-
-	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
-			key_len != AES_KEYSIZE_256)
-		return -EINVAL;
-
-	ctx->key_length = key_len;
-
-	ctx->key_enc[0] = get_unaligned_le32(in_key);
-	ctx->key_enc[1] = get_unaligned_le32(in_key + 4);
-	ctx->key_enc[2] = get_unaligned_le32(in_key + 8);
-	ctx->key_enc[3] = get_unaligned_le32(in_key + 12);
-
-	ctx->key_dec[key_len + 24] = ctx->key_enc[0];
-	ctx->key_dec[key_len + 25] = ctx->key_enc[1];
-	ctx->key_dec[key_len + 26] = ctx->key_enc[2];
-	ctx->key_dec[key_len + 27] = ctx->key_enc[3];
-
-	switch (key_len) {
-	case AES_KEYSIZE_128:
-		t = ctx->key_enc[3];
-		for (i = 0; i < 10; ++i)
-			loop4(i);
-		break;
-
-	case AES_KEYSIZE_192:
-		ctx->key_enc[4] = get_unaligned_le32(in_key + 16);
-		t = ctx->key_enc[5] = get_unaligned_le32(in_key + 20);
-		for (i = 0; i < 8; ++i)
-			loop6(i);
-		break;
-
-	case AES_KEYSIZE_256:
-		ctx->key_enc[4] = get_unaligned_le32(in_key + 16);
-		ctx->key_enc[5] = get_unaligned_le32(in_key + 20);
-		ctx->key_enc[6] = get_unaligned_le32(in_key + 24);
-		t = ctx->key_enc[7] = get_unaligned_le32(in_key + 28);
-		for (i = 0; i < 6; ++i)
-			loop8(i);
-		loop8tophalf(i);
-		break;
-	}
-
-	ctx->key_dec[0] = ctx->key_enc[key_len + 24];
-	ctx->key_dec[1] = ctx->key_enc[key_len + 25];
-	ctx->key_dec[2] = ctx->key_enc[key_len + 26];
-	ctx->key_dec[3] = ctx->key_enc[key_len + 27];
-
-	for (i = 4; i < key_len + 24; ++i) {
-		j = key_len + 24 - (i & ~3) + (i & 3);
-		imix_col(ctx->key_dec[j], ctx->key_enc[i]);
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_aes_expand_key);
-
-/**
- * crypto_aes_set_key - Set the AES key.
- * @tfm:	The %crypto_tfm that is used in the context.
- * @in_key:	The input key.
- * @key_len:	The size of the key.
- *
- * Returns 0 on success, on failure the %CRYPTO_TFM_RES_BAD_KEY_LEN flag in tfm
- * is set. The function uses crypto_aes_expand_key() to expand the key.
- * &crypto_aes_ctx _must_ be the private data embedded in @tfm which is
- * retrieved with crypto_tfm_ctx().
- */
-int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
-		unsigned int key_len)
-{
-	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-	int ret;
-
-	ret = crypto_aes_expand_key(ctx, in_key, key_len);
-	if (!ret)
-		return 0;
-
-	*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(crypto_aes_set_key);
-
 /* encrypt a block of text */
 
 #define f_rn(bo, bi, n, k)	do {				\
diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 03023b2290e8..81bfc4b8ff56 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -13,225 +13,8 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 
-/*
- * Emit the sbox as volatile const to prevent the compiler from doing
- * constant folding on sbox references involving fixed indexes.
- */
-static volatile const u8 __cacheline_aligned __aesti_sbox[] = {
-	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
-	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
-	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
-	0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
-	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
-	0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
-	0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
-	0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
-	0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
-	0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
-	0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
-	0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
-	0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
-	0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
-	0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
-	0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
-	0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
-	0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
-	0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
-	0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
-	0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
-	0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
-	0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
-	0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
-	0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
-	0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
-	0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
-	0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
-	0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
-	0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
-	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
-	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
-};
-
-static volatile const u8 __cacheline_aligned __aesti_inv_sbox[] = {
-	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
-	0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
-	0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,
-	0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
-	0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d,
-	0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
-	0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2,
-	0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
-	0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16,
-	0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
-	0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda,
-	0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
-	0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a,
-	0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
-	0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02,
-	0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
-	0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea,
-	0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
-	0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85,
-	0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
-	0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89,
-	0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
-	0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20,
-	0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
-	0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31,
-	0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
-	0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d,
-	0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
-	0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0,
-	0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
-	0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26,
-	0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d,
-};
-
-static u32 mul_by_x(u32 w)
-{
-	u32 x = w & 0x7f7f7f7f;
-	u32 y = w & 0x80808080;
-
-	/* multiply by polynomial 'x' (0b10) in GF(2^8) */
-	return (x << 1) ^ (y >> 7) * 0x1b;
-}
-
-static u32 mul_by_x2(u32 w)
-{
-	u32 x = w & 0x3f3f3f3f;
-	u32 y = w & 0x80808080;
-	u32 z = w & 0x40404040;
-
-	/* multiply by polynomial 'x^2' (0b100) in GF(2^8) */
-	return (x << 2) ^ (y >> 7) * 0x36 ^ (z >> 6) * 0x1b;
-}
-
-static u32 mix_columns(u32 x)
-{
-	/*
-	 * Perform the following matrix multiplication in GF(2^8)
-	 *
-	 * | 0x2 0x3 0x1 0x1 |   | x[0] |
-	 * | 0x1 0x2 0x3 0x1 |   | x[1] |
-	 * | 0x1 0x1 0x2 0x3 | x | x[2] |
-	 * | 0x3 0x1 0x1 0x2 |   | x[3] |
-	 */
-	u32 y = mul_by_x(x) ^ ror32(x, 16);
-
-	return y ^ ror32(x ^ y, 8);
-}
-
-static u32 inv_mix_columns(u32 x)
-{
-	/*
-	 * Perform the following matrix multiplication in GF(2^8)
-	 *
-	 * | 0xe 0xb 0xd 0x9 |   | x[0] |
-	 * | 0x9 0xe 0xb 0xd |   | x[1] |
-	 * | 0xd 0x9 0xe 0xb | x | x[2] |
-	 * | 0xb 0xd 0x9 0xe |   | x[3] |
-	 *
-	 * which can conveniently be reduced to
-	 *
-	 * | 0x2 0x3 0x1 0x1 |   | 0x5 0x0 0x4 0x0 |   | x[0] |
-	 * | 0x1 0x2 0x3 0x1 |   | 0x0 0x5 0x0 0x4 |   | x[1] |
-	 * | 0x1 0x1 0x2 0x3 | x | 0x4 0x0 0x5 0x0 | x | x[2] |
-	 * | 0x3 0x1 0x1 0x2 |   | 0x0 0x4 0x0 0x5 |   | x[3] |
-	 */
-	u32 y = mul_by_x2(x);
-
-	return mix_columns(x ^ y ^ ror32(y, 16));
-}
-
-static __always_inline u32 subshift(u32 in[], int pos)
-{
-	return (__aesti_sbox[in[pos] & 0xff]) ^
-	       (__aesti_sbox[(in[(pos + 1) % 4] >>  8) & 0xff] <<  8) ^
-	       (__aesti_sbox[(in[(pos + 2) % 4] >> 16) & 0xff] << 16) ^
-	       (__aesti_sbox[(in[(pos + 3) % 4] >> 24) & 0xff] << 24);
-}
-
-static __always_inline u32 inv_subshift(u32 in[], int pos)
-{
-	return (__aesti_inv_sbox[in[pos] & 0xff]) ^
-	       (__aesti_inv_sbox[(in[(pos + 3) % 4] >>  8) & 0xff] <<  8) ^
-	       (__aesti_inv_sbox[(in[(pos + 2) % 4] >> 16) & 0xff] << 16) ^
-	       (__aesti_inv_sbox[(in[(pos + 1) % 4] >> 24) & 0xff] << 24);
-}
-
-static u32 subw(u32 in)
-{
-	return (__aesti_sbox[in & 0xff]) ^
-	       (__aesti_sbox[(in >>  8) & 0xff] <<  8) ^
-	       (__aesti_sbox[(in >> 16) & 0xff] << 16) ^
-	       (__aesti_sbox[(in >> 24) & 0xff] << 24);
-}
-
-static int aesti_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
-			    unsigned int key_len)
-{
-	u32 kwords = key_len / sizeof(u32);
-	u32 rc, i, j;
-
-	if (key_len != AES_KEYSIZE_128 &&
-	    key_len != AES_KEYSIZE_192 &&
-	    key_len != AES_KEYSIZE_256)
-		return -EINVAL;
-
-	ctx->key_length = key_len;
-
-	for (i = 0; i < kwords; i++)
-		ctx->key_enc[i] = get_unaligned_le32(in_key + i * sizeof(u32));
-
-	for (i = 0, rc = 1; i < 10; i++, rc = mul_by_x(rc)) {
-		u32 *rki = ctx->key_enc + (i * kwords);
-		u32 *rko = rki + kwords;
-
-		rko[0] = ror32(subw(rki[kwords - 1]), 8) ^ rc ^ rki[0];
-		rko[1] = rko[0] ^ rki[1];
-		rko[2] = rko[1] ^ rki[2];
-		rko[3] = rko[2] ^ rki[3];
-
-		if (key_len == 24) {
-			if (i >= 7)
-				break;
-			rko[4] = rko[3] ^ rki[4];
-			rko[5] = rko[4] ^ rki[5];
-		} else if (key_len == 32) {
-			if (i >= 6)
-				break;
-			rko[4] = subw(rko[3]) ^ rki[4];
-			rko[5] = rko[4] ^ rki[5];
-			rko[6] = rko[5] ^ rki[6];
-			rko[7] = rko[6] ^ rki[7];
-		}
-	}
-
-	/*
-	 * Generate the decryption keys for the Equivalent Inverse Cipher.
-	 * This involves reversing the order of the round keys, and applying
-	 * the Inverse Mix Columns transformation to all but the first and
-	 * the last one.
-	 */
-	ctx->key_dec[0] = ctx->key_enc[key_len + 24];
-	ctx->key_dec[1] = ctx->key_enc[key_len + 25];
-	ctx->key_dec[2] = ctx->key_enc[key_len + 26];
-	ctx->key_dec[3] = ctx->key_enc[key_len + 27];
-
-	for (i = 4, j = key_len + 20; j > 0; i += 4, j -= 4) {
-		ctx->key_dec[i]     = inv_mix_columns(ctx->key_enc[j]);
-		ctx->key_dec[i + 1] = inv_mix_columns(ctx->key_enc[j + 1]);
-		ctx->key_dec[i + 2] = inv_mix_columns(ctx->key_enc[j + 2]);
-		ctx->key_dec[i + 3] = inv_mix_columns(ctx->key_enc[j + 3]);
-	}
-
-	ctx->key_dec[i]     = ctx->key_enc[0];
-	ctx->key_dec[i + 1] = ctx->key_enc[1];
-	ctx->key_dec[i + 2] = ctx->key_enc[2];
-	ctx->key_dec[i + 3] = ctx->key_enc[3];
-
-	return 0;
-}
+extern volatile const u8 crypto_aes_sbox[];
+extern volatile const u8 crypto_aes_inv_sbox[];
 
 static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			 unsigned int key_len)
@@ -239,7 +22,7 @@ static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 	int err;
 
-	err = aesti_expand_key(ctx, in_key, key_len);
+	err = crypto_aes_expand_key(ctx, in_key, key_len);
 	if (err)
 		return err;
 
@@ -250,15 +33,15 @@ static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	 * the key is used, which will pull the entire Sbox into the D-cache
 	 * before any data dependent Sbox lookups are performed.
 	 */
-	ctx->key_enc[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
-	ctx->key_enc[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
-	ctx->key_enc[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
-	ctx->key_enc[3] ^= __aesti_sbox[96] ^ __aesti_sbox[224];
+	ctx->key_enc[0] ^= crypto_aes_sbox[ 0] ^ crypto_aes_sbox[128];
+	ctx->key_enc[1] ^= crypto_aes_sbox[32] ^ crypto_aes_sbox[160];
+	ctx->key_enc[2] ^= crypto_aes_sbox[64] ^ crypto_aes_sbox[192];
+	ctx->key_enc[3] ^= crypto_aes_sbox[96] ^ crypto_aes_sbox[224];
 
-	ctx->key_dec[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[128];
-	ctx->key_dec[1] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[160];
-	ctx->key_dec[2] ^= __aesti_inv_sbox[64] ^ __aesti_inv_sbox[192];
-	ctx->key_dec[3] ^= __aesti_inv_sbox[96] ^ __aesti_inv_sbox[224];
+	ctx->key_dec[0] ^= crypto_aes_inv_sbox[ 0] ^ crypto_aes_inv_sbox[128];
+	ctx->key_dec[1] ^= crypto_aes_inv_sbox[32] ^ crypto_aes_inv_sbox[160];
+	ctx->key_dec[2] ^= crypto_aes_inv_sbox[64] ^ crypto_aes_inv_sbox[192];
+	ctx->key_dec[3] ^= crypto_aes_inv_sbox[96] ^ crypto_aes_inv_sbox[224];
 
 	return 0;
 }
@@ -266,79 +49,31 @@ static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	const u32 *rkp = ctx->key_enc + 4;
-	int rounds = 6 + ctx->key_length / 4;
-	u32 st0[4], st1[4];
-	int round;
-
-	st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
-	st0[1] = ctx->key_enc[1] ^ get_unaligned_le32(in + 4);
-	st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
-	st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
-
-	st0[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
-	st0[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
-	st0[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
-	st0[3] ^= __aesti_sbox[96] ^ __aesti_sbox[224];
-
-	for (round = 0;; round += 2, rkp += 8) {
-		st1[0] = mix_columns(subshift(st0, 0)) ^ rkp[0];
-		st1[1] = mix_columns(subshift(st0, 1)) ^ rkp[1];
-		st1[2] = mix_columns(subshift(st0, 2)) ^ rkp[2];
-		st1[3] = mix_columns(subshift(st0, 3)) ^ rkp[3];
+	u8 src[AES_BLOCK_SIZE];
 
-		if (round == rounds - 2)
-			break;
+	memcpy(src, in, AES_BLOCK_SIZE);
 
-		st0[0] = mix_columns(subshift(st1, 0)) ^ rkp[4];
-		st0[1] = mix_columns(subshift(st1, 1)) ^ rkp[5];
-		st0[2] = mix_columns(subshift(st1, 2)) ^ rkp[6];
-		st0[3] = mix_columns(subshift(st1, 3)) ^ rkp[7];
-	}
+	src[ 0] ^= crypto_aes_sbox[ 0] ^ crypto_aes_sbox[128];
+	src[ 4] ^= crypto_aes_sbox[32] ^ crypto_aes_sbox[160];
+	src[ 8] ^= crypto_aes_sbox[64] ^ crypto_aes_sbox[192];
+	src[12] ^= crypto_aes_sbox[96] ^ crypto_aes_sbox[224];
 
-	put_unaligned_le32(subshift(st1, 0) ^ rkp[4], out);
-	put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
-	put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
-	put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
+	crypto_aes_encrypt(ctx, out, src);
 }
 
 static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
-	const u32 *rkp = ctx->key_dec + 4;
-	int rounds = 6 + ctx->key_length / 4;
-	u32 st0[4], st1[4];
-	int round;
-
-	st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
-	st0[1] = ctx->key_dec[1] ^ get_unaligned_le32(in + 4);
-	st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
-	st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
-
-	st0[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[128];
-	st0[1] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[160];
-	st0[2] ^= __aesti_inv_sbox[64] ^ __aesti_inv_sbox[192];
-	st0[3] ^= __aesti_inv_sbox[96] ^ __aesti_inv_sbox[224];
-
-	for (round = 0;; round += 2, rkp += 8) {
-		st1[0] = inv_mix_columns(inv_subshift(st0, 0)) ^ rkp[0];
-		st1[1] = inv_mix_columns(inv_subshift(st0, 1)) ^ rkp[1];
-		st1[2] = inv_mix_columns(inv_subshift(st0, 2)) ^ rkp[2];
-		st1[3] = inv_mix_columns(inv_subshift(st0, 3)) ^ rkp[3];
+	u8 src[AES_BLOCK_SIZE];
 
-		if (round == rounds - 2)
-			break;
+	memcpy(src, in, AES_BLOCK_SIZE);
 
-		st0[0] = inv_mix_columns(inv_subshift(st1, 0)) ^ rkp[4];
-		st0[1] = inv_mix_columns(inv_subshift(st1, 1)) ^ rkp[5];
-		st0[2] = inv_mix_columns(inv_subshift(st1, 2)) ^ rkp[6];
-		st0[3] = inv_mix_columns(inv_subshift(st1, 3)) ^ rkp[7];
-	}
+	src[ 0] ^= crypto_aes_inv_sbox[ 0] ^ crypto_aes_inv_sbox[128];
+	src[ 4] ^= crypto_aes_inv_sbox[32] ^ crypto_aes_inv_sbox[160];
+	src[ 8] ^= crypto_aes_inv_sbox[64] ^ crypto_aes_inv_sbox[192];
+	src[12] ^= crypto_aes_inv_sbox[96] ^ crypto_aes_inv_sbox[224];
 
-	put_unaligned_le32(inv_subshift(st1, 0) ^ rkp[4], out);
-	put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
-	put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
-	put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
+	crypto_aes_decrypt(ctx, out, src);
 }
 
 static struct crypto_alg aes_alg = {
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 7a737c1c669e..704712d226e4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_DEV_PADLOCK_AES
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_AES_CORE
 	help
 	  Use VIA PadLock for AES algorithm.
 
@@ -189,7 +189,7 @@ config CRYPTO_CRC32_S390
 config CRYPTO_DEV_MV_CESA
 	tristate "Marvell's Cryptographic Engine"
 	depends on PLAT_ORION
-	select CRYPTO_AES
+	select CRYPTO_AES_CORE
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select SRAM
@@ -203,7 +203,7 @@ config CRYPTO_DEV_MV_CESA
 config CRYPTO_DEV_MARVELL_CESA
 	tristate "New Marvell's Cryptographic Engine driver"
 	depends on PLAT_ORION || ARCH_MVEBU
-	select CRYPTO_AES
+	select CRYPTO_AES_CORE
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
@@ -655,7 +655,7 @@ config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
 	depends on HAS_DMA && OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
-	select CRYPTO_AES
+	select CRYPTO_AES_CORE
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select CRYPTO_HMAC
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 7524ba3b6f3c..6374f91f5a0a 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -36,4 +36,10 @@ int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
 int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		unsigned int key_len);
+
+void crypto_aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out,
+			const u8 *in);
+void crypto_aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out,
+			const u8 *in);
+
 #endif
-- 
2.7.4
