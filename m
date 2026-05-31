Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97497324B33;
	Sun, 31 May 2026 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255384; cv=none; b=myvmdHF7EGxI7Tk1EwdQO0ChKKoWpf7BvXhtQY0waLq0lBwXRmiKDJp9qrSZQQXmLdl+X34n0/CVydrdWHioF85eZgXRMklP7J8sFn9JJg4BFRF80e/jAxychpFjgAsPQc/EOCk+agSVlg3wbBt3kB1Wds/GewXHQikNSLbyvT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255384; c=relaxed/simple;
	bh=IfNvRfWhN9cRwDxPoic3doQ5MhK69KshNi0akBgXXKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHsgxbSqZnX78bgHYEiGH2K7q0djzMtt3jgkX3ixWomU3bt4mzSnpqu5D5OlKVkb2EkMhlmU7ADm6bB5c+oco7y/JSWfAcuUwnTnHZlLwBHfME96rsd5OGhVAR4aCkarZvlYizXZhzXJRdEwjGhl3ktbxMx6zDIzH+59sxzTYHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGKpzsFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGKpzsFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8161F0089B;
	Sun, 31 May 2026 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780255382;
	bh=XmQepHfFgXjA+0v6SDJzJHGoPhtl4ztS6ylVSm5VPQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGKpzsFiPHS37JqBXlpwFj5adiE9aTBDi+GXXb9XQ7FfOMAruz4HO7Spmi7OYPcZf
	 +Oce7PXvihA/jHiUBuFXoDkQWSgNZZOQZjY/xCZIIHaaHvVBg/+lEomKuaVRI/itWf
	 8IIgXY10MA+6A0qY1v9xkLsDiWYzfFMsmxrpHZUvDbCbQ4gV4MDxMlXB1b9vfbJ7d6
	 Z5mr8yJZDDnHEuh9w9uUHe7MfuKwXGzHbIopglr8/QaFQhtlUTzxQdFHyEZC960i78
	 ESV81k7uXQ5Iq8jtl7exEKlYEN5MjJCc3wiJI/uQAhHw0num6sssmScwgKS4RU2P5k
	 XsAXAjKmiQROQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/4] crypto: xilinx-trng - Replace crypto_drbg_ctr_df() with HMAC-SHA512
Date: Sun, 31 May 2026 12:17:37 -0700
Message-ID: <20260531191738.55843-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260531191738.55843-1-ebiggers@kernel.org>
References: <20260531191738.55843-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This code is just trying to condition 48 bytes of random data.  This can
be done easily using HKDF-SHA512-Extract, saving 300 lines of code.

This commit also fixes forward security (in this particular case) by
clearing the entropy from memory after it's used.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig                      |   5 -
 crypto/Makefile                     |   2 -
 crypto/df_sp80090a.c                | 222 ----------------------------
 drivers/crypto/Kconfig              |   2 +-
 drivers/crypto/xilinx/xilinx-trng.c |  44 ++----
 include/crypto/df_sp80090a.h        |  53 -------
 6 files changed, 16 insertions(+), 312 deletions(-)
 delete mode 100644 crypto/df_sp80090a.c
 delete mode 100644 include/crypto/df_sp80090a.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b5c5a1e04435..c3d7a20d5cb1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1244,15 +1244,10 @@ endif	# if CRYPTO_JITTERENTROPY
 config CRYPTO_KDF800108_CTR
 	tristate
 	select CRYPTO_HMAC
 	select CRYPTO_SHA256
 
-config CRYPTO_DF80090A
-	tristate
-	select CRYPTO_AES
-	select CRYPTO_CTR
-
 endmenu
 menu "Userspace interface (deprecated)"
 
 config CRYPTO_USER_API
 	tristate
diff --git a/crypto/Makefile b/crypto/Makefile
index c73f4d51d036..f98f57c7a49f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -206,8 +206,6 @@ obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
 #
 # Key derivation function
 #
 obj-$(CONFIG_CRYPTO_KDF800108_CTR) += kdf_sp800108.o
 
-obj-$(CONFIG_CRYPTO_DF80090A) += df_sp80090a.o
-
 obj-$(CONFIG_CRYPTO_KRB5) += krb5/
diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
deleted file mode 100644
index 90e1973ee40c..000000000000
--- a/crypto/df_sp80090a.c
+++ /dev/null
@@ -1,222 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-/*
- * NIST SP800-90A DRBG derivation function
- *
- * Copyright (C) 2014, Stephan Mueller <smueller@chronox.de>
- */
-
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/unaligned.h>
-#include <crypto/aes.h>
-#include <crypto/df_sp80090a.h>
-
-static void drbg_kcapi_sym(struct aes_enckey *aeskey, unsigned char *outval,
-			   const struct drbg_string *in, u8 blocklen_bytes)
-{
-	/* there is only component in *in */
-	BUG_ON(in->len < blocklen_bytes);
-	aes_encrypt(aeskey, outval, in->buf);
-}
-
-/* BCC function for CTR DRBG as defined in 10.4.3 */
-
-static void drbg_ctr_bcc(struct aes_enckey *aeskey,
-			 unsigned char *out, const unsigned char *key,
-			 struct list_head *in,
-			 u8 blocklen_bytes,
-			 u8 keylen)
-{
-	struct drbg_string *curr = NULL;
-	struct drbg_string data;
-	short cnt = 0;
-
-	drbg_string_fill(&data, out, blocklen_bytes);
-
-	/* 10.4.3 step 2 / 4 */
-	aes_prepareenckey(aeskey, key, keylen);
-	list_for_each_entry(curr, in, list) {
-		const unsigned char *pos = curr->buf;
-		size_t len = curr->len;
-		/* 10.4.3 step 4.1 */
-		while (len) {
-			/* 10.4.3 step 4.2 */
-			if (blocklen_bytes == cnt) {
-				cnt = 0;
-				drbg_kcapi_sym(aeskey, out, &data, blocklen_bytes);
-			}
-			out[cnt] ^= *pos;
-			pos++;
-			cnt++;
-			len--;
-		}
-	}
-	/* 10.4.3 step 4.2 for last block */
-	if (cnt)
-		drbg_kcapi_sym(aeskey, out, &data, blocklen_bytes);
-}
-
-/*
- * scratchpad usage: drbg_ctr_update is interlinked with crypto_drbg_ctr_df
- * (and drbg_ctr_bcc, but this function does not need any temporary buffers),
- * the scratchpad is used as follows:
- * drbg_ctr_update:
- *	temp
- *		start: drbg->scratchpad
- *		length: drbg_statelen(drbg) + drbg_blocklen(drbg)
- *			note: the cipher writing into this variable works
- *			blocklen-wise. Now, when the statelen is not a multiple
- *			of blocklen, the generateion loop below "spills over"
- *			by at most blocklen. Thus, we need to give sufficient
- *			memory.
- *	df_data
- *		start: drbg->scratchpad +
- *				drbg_statelen(drbg) + drbg_blocklen(drbg)
- *		length: drbg_statelen(drbg)
- *
- * crypto_drbg_ctr_df:
- *	pad
- *		start: df_data + drbg_statelen(drbg)
- *		length: drbg_blocklen(drbg)
- *	iv
- *		start: pad + drbg_blocklen(drbg)
- *		length: drbg_blocklen(drbg)
- *	temp
- *		start: iv + drbg_blocklen(drbg)
- *		length: drbg_satelen(drbg) + drbg_blocklen(drbg)
- *			note: temp is the buffer that the BCC function operates
- *			on. BCC operates blockwise. drbg_statelen(drbg)
- *			is sufficient when the DRBG state length is a multiple
- *			of the block size. For AES192 (and maybe other ciphers)
- *			this is not correct and the length for temp is
- *			insufficient (yes, that also means for such ciphers,
- *			the final output of all BCC rounds are truncated).
- *			Therefore, add drbg_blocklen(drbg) to cover all
- *			possibilities.
- * refer to crypto_drbg_ctr_df_datalen() to get required length
- */
-
-/* Derivation Function for CTR DRBG as defined in 10.4.2 */
-int crypto_drbg_ctr_df(struct aes_enckey *aeskey,
-		       unsigned char *df_data, size_t bytes_to_return,
-		       struct list_head *seedlist,
-		       u8 blocklen_bytes,
-		       u8 statelen)
-{
-	unsigned char L_N[8];
-	/* S3 is input */
-	struct drbg_string S1, S2, S4, cipherin;
-	LIST_HEAD(bcc_list);
-	unsigned char *pad = df_data + statelen;
-	unsigned char *iv = pad + blocklen_bytes;
-	unsigned char *temp = iv + blocklen_bytes;
-	size_t padlen = 0;
-	unsigned int templen = 0;
-	/* 10.4.2 step 7 */
-	unsigned int i = 0;
-	/* 10.4.2 step 8 */
-	const unsigned char *K = (unsigned char *)
-			   "\x00\x01\x02\x03\x04\x05\x06\x07"
-			   "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
-			   "\x10\x11\x12\x13\x14\x15\x16\x17"
-			   "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f";
-	unsigned char *X;
-	size_t generated_len = 0;
-	size_t inputlen = 0;
-	struct drbg_string *seed = NULL;
-	u8 keylen;
-
-	memset(pad, 0, blocklen_bytes);
-	memset(iv, 0, blocklen_bytes);
-	keylen = statelen - blocklen_bytes;
-	/* 10.4.2 step 1 is implicit as we work byte-wise */
-
-	/* 10.4.2 step 2 */
-	if ((512 / 8) < bytes_to_return)
-		return -EINVAL;
-
-	/* 10.4.2 step 2 -- calculate the entire length of all input data */
-	list_for_each_entry(seed, seedlist, list)
-		inputlen += seed->len;
-	put_unaligned_be32(inputlen, &L_N[0]);
-
-	/* 10.4.2 step 3 */
-	put_unaligned_be32(bytes_to_return, &L_N[4]);
-
-	/* 10.4.2 step 5: length is L_N, input_string, one byte, padding */
-	padlen = (inputlen + sizeof(L_N) + 1) % (blocklen_bytes);
-	/* wrap the padlen appropriately */
-	if (padlen)
-		padlen = blocklen_bytes - padlen;
-	/*
-	 * pad / padlen contains the 0x80 byte and the following zero bytes.
-	 * As the calculated padlen value only covers the number of zero
-	 * bytes, this value has to be incremented by one for the 0x80 byte.
-	 */
-	padlen++;
-	pad[0] = 0x80;
-
-	/* 10.4.2 step 4 -- first fill the linked list and then order it */
-	drbg_string_fill(&S1, iv, blocklen_bytes);
-	list_add_tail(&S1.list, &bcc_list);
-	drbg_string_fill(&S2, L_N, sizeof(L_N));
-	list_add_tail(&S2.list, &bcc_list);
-	list_splice_tail(seedlist, &bcc_list);
-	drbg_string_fill(&S4, pad, padlen);
-	list_add_tail(&S4.list, &bcc_list);
-
-	/* 10.4.2 step 9 */
-	while (templen < (keylen + (blocklen_bytes))) {
-		/*
-		 * 10.4.2 step 9.1 - the padding is implicit as the buffer
-		 * holds zeros after allocation -- even the increment of i
-		 * is irrelevant as the increment remains within length of i
-		 */
-		put_unaligned_be32(i, iv);
-		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
-		drbg_ctr_bcc(aeskey, temp + templen, K, &bcc_list,
-			     blocklen_bytes, keylen);
-		/* 10.4.2 step 9.3 */
-		i++;
-		templen += blocklen_bytes;
-	}
-
-	/* 10.4.2 step 11 */
-	X = temp + (keylen);
-	drbg_string_fill(&cipherin, X, blocklen_bytes);
-
-	/* 10.4.2 step 12: overwriting of outval is implemented in next step */
-
-	/* 10.4.2 step 13 */
-	aes_prepareenckey(aeskey, temp, keylen);
-	while (generated_len < bytes_to_return) {
-		short blocklen = 0;
-		/*
-		 * 10.4.2 step 13.1: the truncation of the key length is
-		 * implicit as the key is only drbg_blocklen in size based on
-		 * the implementation of the cipher function callback
-		 */
-		drbg_kcapi_sym(aeskey, X, &cipherin, blocklen_bytes);
-		blocklen = (blocklen_bytes <
-				(bytes_to_return - generated_len)) ?
-			    blocklen_bytes :
-				(bytes_to_return - generated_len);
-		/* 10.4.2 step 13.2 and 14 */
-		memcpy(df_data + generated_len, X, blocklen);
-		generated_len += blocklen;
-	}
-
-	memset(iv, 0, blocklen_bytes);
-	memset(temp, 0, statelen + blocklen_bytes);
-	memset(pad, 0, blocklen_bytes);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_drbg_ctr_df);
-
-MODULE_IMPORT_NS("CRYPTO_INTERNAL");
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-MODULE_DESCRIPTION("Derivation Function conformant to SP800-90A");
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 26194c33cb32..ad6427f08d4f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -707,11 +707,11 @@ config CRYPTO_DEV_TEGRA
 	  AES encryption/decryption and HASH algorithms.
 
 config CRYPTO_DEV_XILINX_TRNG
 	tristate "Support for Xilinx True Random Generator"
 	depends on ZYNQMP_FIRMWARE || COMPILE_TEST
-	select CRYPTO_DF80090A
+	select CRYPTO_LIB_SHA512
 	select HW_RANDOM
 	help
 	  Xilinx Versal SoC driver provides kernel-side support for True Random Number
 	  Generator and Pseudo random Number in CTR_DRBG mode as defined in NIST SP800-90A.
 
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index a30b0b3b3685..f615d5adddde 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -2,10 +2,11 @@
 /*
  * AMD Versal True Random Number Generator driver
  * Copyright (c) 2024 - 2025 Advanced Micro Devices, Inc.
  */
 
+#include <crypto/sha2.h>
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/hw_random.h>
@@ -13,13 +14,10 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
-#include <crypto/aes.h>
-#include <crypto/df_sp80090a.h>
-#include <crypto/internal/cipher.h>
 
 /* TRNG Registers Offsets */
 #define TRNG_STATUS_OFFSET			0x4U
 #define TRNG_CTRL_OFFSET			0x8U
 #define TRNG_EXT_SEED_OFFSET			0x40U
@@ -41,11 +39,10 @@
 #define TRNG_STATUS_QCNT_MASK			GENMASK(11, 9)
 #define TRNG_STATUS_QCNT_16_BYTES		0x800
 
 /* Sizes in bytes */
 #define TRNG_SEED_LEN_BYTES			48U
-#define TRNG_ENTROPY_SEED_LEN_BYTES		64U
 #define TRNG_SEC_STRENGTH_SHIFT			5U
 #define TRNG_SEC_STRENGTH_BYTES			BIT(TRNG_SEC_STRENGTH_SHIFT)
 #define TRNG_BYTES_PER_REG			4U
 #define TRNG_RESET_DELAY			10
 #define TRNG_NUM_INIT_REGS			12U
@@ -53,12 +50,10 @@
 #define TRNG_DATA_READ_DELAY			8000
 
 struct xilinx_rng {
 	void __iomem *rng_base;
 	struct device *dev;
-	unsigned char *scratchpadbuf;
-	struct aes_enckey *aeskey;
 	struct hwrng trng;
 };
 
 static void xtrng_readwrite32(void __iomem *addr, u32 mask, u8 value)
 {
@@ -170,33 +165,34 @@ static void xtrng_enable_entropy(struct xilinx_rng *rng)
 	iowrite32(TRNG_CTRL_EUMODE_MASK | TRNG_CTRL_TRSSEN_MASK, rng->rng_base + TRNG_CTRL_OFFSET);
 }
 
 static int xtrng_reseed_internal(struct xilinx_rng *rng)
 {
-	u8 entropy[TRNG_ENTROPY_SEED_LEN_BYTES];
-	struct drbg_string data;
-	LIST_HEAD(seedlist);
+	static const u8 default_salt[SHA512_DIGEST_SIZE];
+	u8 entropy[SHA512_DIGEST_SIZE] __aligned(4);
 	u32 val;
 	int ret;
 
-	drbg_string_fill(&data, entropy, TRNG_SEED_LEN_BYTES);
-	list_add_tail(&data.list, &seedlist);
-	memset(entropy, 0, sizeof(entropy));
 	xtrng_enable_entropy(rng);
 
-	/* collect random data to use it as entropy (input for DF) */
+	/* Collect some output from the TRNG. */
+	static_assert(sizeof(entropy) >= TRNG_SEED_LEN_BYTES);
 	ret = xtrng_collect_random_data(rng, entropy, TRNG_SEED_LEN_BYTES, true);
 	if (ret != TRNG_SEED_LEN_BYTES)
 		return -EINVAL;
-	ret = crypto_drbg_ctr_df(rng->aeskey, rng->scratchpadbuf,
-				 TRNG_SEED_LEN_BYTES, &seedlist, AES_BLOCK_SIZE,
-				 TRNG_SEED_LEN_BYTES);
-	if (ret)
-		return ret;
 
+	/* Extract entropy from the TRNG output using HKDF-SHA512-Extract. */
+	hmac_sha512_usingrawkey(default_salt, sizeof(default_salt), entropy,
+				TRNG_SEED_LEN_BYTES, entropy);
+
+	/* Write the extracted entropy to the hardware. */
 	xtrng_write_multiple_registers(rng->rng_base + TRNG_EXT_SEED_OFFSET,
-				       (u32 *)rng->scratchpadbuf, TRNG_NUM_INIT_REGS);
+				       (u32 *)entropy, TRNG_NUM_INIT_REGS);
+
+	/* Clear the entropy from the stack. */
+	memzero_explicit(entropy, sizeof(entropy));
+
 	/* select reseed operation */
 	iowrite32(TRNG_CTRL_PRNGXS_MASK, rng->rng_base + TRNG_CTRL_OFFSET);
 
 	/* Start the reseed operation with above configuration and wait for STATUS.Done bit to be
 	 * set. Monitor STATUS.CERTF bit, if set indicates SP800-90B entropy health test has failed.
@@ -276,11 +272,10 @@ static void xtrng_hwrng_unregister(struct hwrng *trng)
 }
 
 static int xtrng_probe(struct platform_device *pdev)
 {
 	struct xilinx_rng *rng;
-	size_t sb_size;
 	int ret;
 
 	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
 	if (!rng)
 		return -ENOMEM;
@@ -290,19 +285,10 @@ static int xtrng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->rng_base)) {
 		dev_err(&pdev->dev, "Failed to map resource %pe\n", rng->rng_base);
 		return PTR_ERR(rng->rng_base);
 	}
 
-	rng->aeskey = devm_kzalloc(&pdev->dev, sizeof(*rng->aeskey), GFP_KERNEL);
-	if (!rng->aeskey)
-		return -ENOMEM;
-
-	sb_size = crypto_drbg_ctr_df_datalen(TRNG_SEED_LEN_BYTES, AES_BLOCK_SIZE);
-	rng->scratchpadbuf = devm_kzalloc(&pdev->dev, sb_size, GFP_KERNEL);
-	if (!rng->scratchpadbuf)
-		return -ENOMEM;
-
 	xtrng_trng_reset(rng->rng_base);
 	ret = xtrng_reseed_internal(rng);
 	if (ret) {
 		dev_err(&pdev->dev, "TRNG Seed fail\n");
 		return ret;
diff --git a/include/crypto/df_sp80090a.h b/include/crypto/df_sp80090a.h
deleted file mode 100644
index e594fb718eb8..000000000000
--- a/include/crypto/df_sp80090a.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-
-/*
- * Copyright Stephan Mueller <smueller@chronox.de>, 2014
- */
-
-#ifndef _CRYPTO_DF80090A_H
-#define _CRYPTO_DF80090A_H
-
-#include <crypto/internal/cipher.h>
-#include <crypto/aes.h>
-#include <linux/list.h>
-
-/*
- * Concatenation Helper and string operation helper
- *
- * SP800-90A requires the concatenation of different data. To avoid copying
- * buffers around or allocate additional memory, the following data structure
- * is used to point to the original memory with its size. In addition, it
- * is used to build a linked list. The linked list defines the concatenation
- * of individual buffers. The order of memory block referenced in that
- * linked list determines the order of concatenation.
- */
-struct drbg_string {
-	const unsigned char *buf;
-	size_t len;
-	struct list_head list;
-};
-
-static inline void drbg_string_fill(struct drbg_string *string,
-				    const unsigned char *buf, size_t len)
-{
-	string->buf = buf;
-	string->len = len;
-	INIT_LIST_HEAD(&string->list);
-}
-
-static inline int crypto_drbg_ctr_df_datalen(u8 statelen, u8 blocklen)
-{
-	return statelen +       /* df_data */
-		blocklen +      /* pad */
-		blocklen +      /* iv */
-		statelen + blocklen;  /* temp */
-}
-
-int crypto_drbg_ctr_df(struct aes_enckey *aes,
-		       unsigned char *df_data,
-		       size_t bytes_to_return,
-		       struct list_head *seedlist,
-		       u8 blocklen_bytes,
-		       u8 statelen);
-
-#endif /* _CRYPTO_DF80090A_H */
-- 
2.54.0

