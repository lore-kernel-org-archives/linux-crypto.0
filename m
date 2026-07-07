Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0613859EB;
	Tue,  7 Jul 2026 05:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402639; cv=none; b=Mv9eaQFA6DbGR6OTDbRZ9GRdxLAH1Rg3SvrnLeyj+EXtD7sXLGzVfAP0GjO3ZUmiDie19DcfUCLpMqJgruiY0vLRMNdvWR1/DSn5kKfET5JbJsQgvTam+eH0KKFiFvBfaQdsn4VqVZT3Uf0sBgK2epyxBsYvtqWCtMEx+cDoKt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402639; c=relaxed/simple;
	bh=PXdXwsrUi2NWo324JSarAOnx0zYwJLxJ5M91rveRiXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvMF22ci87Epe/Q5GfdzEXrz9SNBX/8XleXTSRC5Rocq9pXpmb8LU9ofdwR452IVymCZ3BAOS4f5CN2bZoeAPNLHDVWav6dB5qpH6Lyyo8Kl/0wtzaQGidetgqgvoETJWbzxSE75EH2+D0XlaDZyu7Uq7SPHt17/xWgtjAH/9ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+ognuI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+ognuI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9481F00A3A;
	Tue,  7 Jul 2026 05:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402637;
	bh=5T/jsOuvM2QUitIopTD+7S03PtU+f5Se909LBmt5gkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+ognuI1kREQB++GvnR7MFmdJ1C7IWwtK74zhZTaQ584dl31AU1Xrb+TaO4z5WF8O
	 gxv4NbNxXzmUfjXesws+WsiZ55vPoaGFOPjq/uhXp6VE1CcoJ4kGS3Hwg9OK9hB8zS
	 j/ZIC9FzKBAttn3mxGUTYwgV5ZP2W50kSNNhV1OP6LxxbHO5JGTMnUykDuwfzptk6S
	 A0e0XfSUi7ZUdceWVKWc8T7NVab6HKtUTzMq/dpoudzXAgjmEdWl256qKxvLiiMrf6
	 +G6rPbeYYwtlNukNiWMxv6iHLhaoNbFE6B6XfCHto1OYaXsqd2Lk1meykfkRNTkWm8
	 S0GL4AEuzOfEQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/33] lib/crypto: aes: Add CTR and XCTR support
Date: Mon,  6 Jul 2026 22:34:34 -0700
Message-ID: <20260707053503.209874-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for AES-CTR and AES-XCTR to the crypto library.

These will be used to provide streamlined implementations of the
"ctr(aes)" and "xctr(aes)" crypto_skcipher algorithms.  Most users of
"ctr(aes)" will also be able to switch to the library, which as usual
will be simpler and faster, e.g.:

  - net/mac80211/fils_aead.c
  - net/mac802154/llsec.c

As usual, the architecture-optimized AES-CTR and AES-XCTR code will be
migrated into the library as well (using the hooks provided in this
commit), eliminating lots of repetitive boilerplate code.

This is also a prerequisite for supporting AES-GCM, AES-CCM, and
AES-HCTR2 in the crypto library.

Initial test coverage is provided by the crypto_skcipher support added
in a later commit.  I'm planning a KUnit test suite as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/libcrypto-unauth-encryption.rst    |  7 ++
 include/crypto/aes-ctr.h                      | 56 +++++++++++
 lib/crypto/Kconfig                            |  6 ++
 lib/crypto/aes.c                              | 93 +++++++++++++++++++
 lib/crypto/tests/Kconfig                      |  1 +
 5 files changed, 163 insertions(+)
 create mode 100644 include/crypto/aes-ctr.h

diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
index fb8106034089..6aca01d715da 100644
--- a/Documentation/crypto/libcrypto-unauth-encryption.rst
+++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
@@ -27,6 +27,13 @@ Support for AES in the CBC and CBC-CTS modes of operation.
 
 .. kernel-doc:: include/crypto/aes-cbc.h
 
+AES-CTR and AES-XCTR
+--------------------
+
+Support for AES in the CTR and XCTR modes of operation.
+
+.. kernel-doc:: include/crypto/aes-ctr.h
+
 AES-ECB
 -------
 
diff --git a/include/crypto/aes-ctr.h b/include/crypto/aes-ctr.h
new file mode 100644
index 000000000000..fa2b7d303e55
--- /dev/null
+++ b/include/crypto/aes-ctr.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AES-CTR and AES-XCTR stream ciphers
+ *
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_AES_CTR_H
+#define _CRYPTO_AES_CTR_H
+
+#include <crypto/aes.h>
+
+/**
+ * aes_ctr() - AES-CTR en/decryption
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to en/decrypt
+ * @ctr: The counter.  It will be incremented by ceil(@len / AES_BLOCK_SIZE).
+ * @key: The key
+ *
+ * This implements AES in counter mode with a 128-bit big endian counter.
+ *
+ * This supports incremental en/decryption.  The length of each non-final chunk
+ * must be a multiple of AES_BLOCK_SIZE, and the updated @ctr must be passed in
+ * each time.
+ *
+ * Context: Any context.
+ */
+void aes_ctr(u8 *dst, const u8 *src, size_t len,
+	     u8 ctr[at_least AES_BLOCK_SIZE], aes_encrypt_arg key);
+
+/**
+ * aes_xctr() - AES-XCTR en/decryption
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to en/decrypt
+ * @ctr: The block counter.  For the first call, set it to 1.  It will be
+ *	 incremented by ceil(@len / AES_BLOCK_SIZE).
+ * @iv: The initialization vector
+ * @key: The key
+ *
+ * This implements AES in XOR Counter mode, as specified in the paper
+ * "Length-preserving encryption with HCTR2"
+ * (https://eprint.iacr.org/2021/1441.pdf).
+ *
+ * This supports incremental en/decryption.  The length of each non-final chunk
+ * must be a multiple of AES_BLOCK_SIZE, and the updated @ctr must be passed in
+ * each time.
+ *
+ * Context: Any context.
+ */
+void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
+	      const u8 iv[at_least AES_BLOCK_SIZE], aes_encrypt_arg key);
+
+#endif /* _CRYPTO_AES_CTR_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index c64cc3e12b57..96febc3df6d6 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -47,6 +47,12 @@ config CRYPTO_LIB_AES_ECB
 	help
 	  The AES-ECB library functions.
 
+config CRYPTO_LIB_AES_CTR
+	tristate
+	select CRYPTO_LIB_AES
+	help
+	  The AES-CTR and AES-XCTR library functions.
+
 config CRYPTO_LIB_AESGCM
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 3635fbe946f3..9da274a72221 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -6,6 +6,7 @@
 
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/aes-cbc.h>
+#include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/utils.h>
@@ -967,6 +968,98 @@ void aes_cbc_cts_decrypt(u8 *dst, const u8 *src, size_t len,
 EXPORT_SYMBOL_GPL(aes_cbc_cts_decrypt);
 #endif /* CONFIG_CRYPTO_LIB_AES_CBC */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CTR)
+/*
+ * Hooks for optimized AES-CTR and AES-XCTR implementations, overridable by the
+ * architecture.  They are called with any len >= 0.  Returning false causes the
+ * fallback implementation to be used instead.
+ */
+#ifndef aes_ctr_arch
+static bool aes_ctr_arch(u8 *dst, const u8 *src, size_t len,
+			 u8 ctr[AES_BLOCK_SIZE], const struct aes_enckey *key)
+{
+	return false;
+}
+#endif
+#ifndef aes_xctr_arch
+static bool aes_xctr_arch(u8 *dst, const u8 *src, size_t len, u64 *ctr,
+			  const u8 iv[AES_BLOCK_SIZE],
+			  const struct aes_enckey *key)
+{
+	return false;
+}
+#endif
+
+static __always_inline void inc_be128_ctr(u8 ctr[AES_BLOCK_SIZE])
+{
+	/* Casts to u8 are needed because of the implicit integer promotion. */
+	if (((u8)++ctr[AES_BLOCK_SIZE - 1]) != 0)
+		return;
+	for (int i = AES_BLOCK_SIZE - 2; i >= 0; i--) {
+		if ((u8)++ctr[i] != 0)
+			break;
+	}
+}
+
+void aes_ctr(u8 *dst, const u8 *src, size_t len, u8 ctr[AES_BLOCK_SIZE],
+	     aes_encrypt_arg key)
+{
+	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+
+	if (likely(aes_ctr_arch(dst, src, len, ctr, key.enc_key)))
+		return;
+
+	/* Handle the full blocks. */
+	for (; len >= AES_BLOCK_SIZE; len -= AES_BLOCK_SIZE) {
+		aes_encrypt(key, keystream, ctr);
+		crypto_xor_cpy(dst, src, keystream, AES_BLOCK_SIZE);
+		inc_be128_ctr(ctr);
+		dst += AES_BLOCK_SIZE;
+		src += AES_BLOCK_SIZE;
+	}
+	/* Handle any partial block at the end. */
+	if (len) {
+		aes_encrypt(key, keystream, ctr);
+		crypto_xor_cpy(dst, src, keystream, len);
+		/* Counter is incremented even with just a partial block. */
+		inc_be128_ctr(ctr);
+	}
+	memzero_explicit(keystream, sizeof(keystream));
+}
+EXPORT_SYMBOL_GPL(aes_ctr);
+
+void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
+	      const u8 iv[AES_BLOCK_SIZE], aes_encrypt_arg key)
+{
+	const __le64 iv0 = get_unaligned((const __le64 *)&iv[0]);
+	__le64 aes_input[2];
+	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+
+	if (likely(aes_xctr_arch(dst, src, len, ctr, iv, key.enc_key)))
+		return;
+
+	aes_input[1] = get_unaligned((const __le64 *)&iv[8]);
+	/* Handle the full blocks. */
+	for (; len >= AES_BLOCK_SIZE; len -= AES_BLOCK_SIZE) {
+		aes_input[0] = iv0 ^ cpu_to_le64((*ctr)++);
+		aes_encrypt(key, keystream, (const u8 *)aes_input);
+		crypto_xor_cpy(dst, src, keystream, AES_BLOCK_SIZE);
+		dst += AES_BLOCK_SIZE;
+		src += AES_BLOCK_SIZE;
+	}
+	/* Handle any partial block at the end. */
+	if (len) {
+		/* Counter is incremented even with just a partial block. */
+		aes_input[0] = iv0 ^ cpu_to_le64((*ctr)++);
+		aes_encrypt(key, keystream, (const u8 *)aes_input);
+		crypto_xor_cpy(dst, src, keystream, len);
+	}
+	memzero_explicit(keystream, sizeof(keystream));
+	memzero_explicit(aes_input, sizeof(aes_input));
+}
+EXPORT_SYMBOL_GPL(aes_xctr);
+#endif /* CONFIG_CRYPTO_LIB_AES_CTR */
+
 static int __init aes_mod_init(void)
 {
 #ifdef aes_mod_init_arch
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index e78086f3c954..9284d0134d77 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -146,6 +146,7 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	depends on KUNIT
 	select CRYPTO_LIB_AES_CBC
 	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_CTR
 	select CRYPTO_LIB_AES_ECB
 	select CRYPTO_LIB_BLAKE2B
 	select CRYPTO_LIB_CHACHA20POLY1305
-- 
2.54.0

