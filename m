Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7F33CC7EB;
	Wed, 15 Jul 2026 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153564; cv=none; b=ZS3Q0xB5s8WRtPdj68ANy+7IPkHEZH9egforUWVE8sA15Tm9nhyK6dNeU0txMUwVwLb6IgMvSWTXpCePW2EFlalZhlMqt09CsUmSQ68wnESSQ/sO8aBoNWnY6CCoZgE/7tYAj7+e9VTIrQddwFXGjG62Wxi2Zdaj8ig44luc7KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153564; c=relaxed/simple;
	bh=bEc4j+/Hpz0s8hDCfudInMgzO3POsBWfyo85PjPnav0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOFNJWl3ZLWPy9joMb+EFGnLlXEGaFs8FE26gXMyi+ZDXZVZ900yDqrC/a1rVEAcpcvvap6aFaWu6yliIhZ4/SkLedsKzMmEQ3IYreTwwgu6OyDAbMYIQ4DBZtM7TD82ZCBQ8GO1eBZK4rvpKdKkTwK5qn3dpD4W9goo/mQkomo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQmsvCgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQmsvCgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A8D1F00AC4;
	Wed, 15 Jul 2026 22:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153562;
	bh=f0SwIMBeUDReOcK1TiWFlGVQvWlJUbvTC+WpayPEZ6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQmsvCgGRiK441RtuMFrIAUbOIA6xmP+va40TSkbp+u1q72VWi0lnMClASvHUZ0TQ
	 TdDC8FY62XmChDw6T6NOurit7hr0RDxOZECBigTlp7L02yJUTYBF/f9oQSF3AZuhGl
	 kVe9XlLOfQtvIuRXUv/chc0tkCqVTlDU+WtCvk2Ywm4Y+2Ijdy+SXluBPQ3s+PtAyr
	 Xvj52qcxnyPpdwTe9bCrGc4lNwSNCpzI9+X9phkcvrY0aAZVOjJ3F94bPeOFKSJzgS
	 EwU4TKq+84dfT0KpI22pxCeQNfdQI3D+dJX7BFdHqYVNGrOwotP01R5CTALgSmIb7R
	 9/+LMxUm824Nw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 03/13] lib/crypto: aes: Add CBC and CBC-CTS support
Date: Wed, 15 Jul 2026 15:11:43 -0700
Message-ID: <20260715221153.246410-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260715221153.246410-1-ebiggers@kernel.org>
References: <20260715221153.246410-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for AES-CBC and AES-CBC-CTS to the crypto library.

These will be used to provide streamlined implementations of the
"cbc(aes)" and "cts(cbc(aes))" crypto_skcipher algorithms.  Most users
of these crypto_skcipher algorithms will also be able to switch to the
library, which as usual will be simpler and faster, e.g.:

    - block/blk-crypto-fallback.c (for AES-128-CBC-ESSIV)
    - fs/crypto/crypto.c (for AES-128-CBC-ESSIV)
    - fs/crypto/fname.c (for AES-256-CTS and AES-128-CBC)
    - kernel/bpf/crypto.c
    - net/ceph/crypto.c
    - security/keys/encrypted-keys/encrypted.c

As usual, the architecture-optimized AES-CBC and AES-CBC-CTS code will
be migrated into the library as well (using the hooks provided in this
commit), eliminating lots of repetitive boilerplate code.

Initial test coverage is provided by the crypto_skcipher support added
in a later commit.  I'm planning a KUnit test suite as well.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/libcrypto-unauth-encryption.rst    |   7 +
 include/crypto/aes-cbc.h                      |  77 ++++++++
 lib/crypto/Kconfig                            |   6 +
 lib/crypto/aes.c                              | 187 ++++++++++++++++++
 lib/crypto/tests/Kconfig                      |   1 +
 5 files changed, 278 insertions(+)
 create mode 100644 include/crypto/aes-cbc.h

diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
index 6a3397a8adae..82bdb0d1b93e 100644
--- a/Documentation/crypto/libcrypto-unauth-encryption.rst
+++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
@@ -20,6 +20,13 @@ block ciphers in XTS mode.  The legitimate use cases for these algorithms are:
 
 Besides the above, these shouldn't be used.
 
+AES-CBC and AES-CBC-CTS
+-----------------------
+
+This API provides support for AES in the CBC and CBC-CTS modes of operation.
+
+.. kernel-doc:: include/crypto/aes-cbc.h
+
 AES-ECB
 -------
 
diff --git a/include/crypto/aes-cbc.h b/include/crypto/aes-cbc.h
new file mode 100644
index 000000000000..7bae340935f9
--- /dev/null
+++ b/include/crypto/aes-cbc.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AES-CBC and AES-CBC-CTS unauthenticated encryption and decryption
+ *
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_AES_CBC_H
+#define _CRYPTO_AES_CBC_H
+
+#include <crypto/aes.h>
+
+/**
+ * aes_cbc_encrypt() - Encrypt data using AES-CBC
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to encrypt.  Must be a multiple of AES_BLOCK_SIZE.
+ * @iv: The initialization vector.  It is updated with the next value, i.e. the
+ *	last ciphertext block (or left unchanged if @len == 0).
+ * @key: The key, already prepared using aes_preparekey() or aes_prepareenckey()
+ *
+ * This supports incremental encryption.  The length of each chunk must be a
+ * multiple of AES_BLOCK_SIZE, and the updated @iv must be passed in each time.
+ *
+ * Context: Any context.
+ */
+void aes_cbc_encrypt(u8 *dst, const u8 *src, size_t len,
+		     u8 iv[at_least AES_BLOCK_SIZE], aes_encrypt_arg key);
+
+/**
+ * aes_cbc_decrypt() - Decrypt data using AES-CBC
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to decrypt.  Must be a multiple of AES_BLOCK_SIZE.
+ * @iv: The initialization vector.  It is updated with the next value, i.e. the
+ *	last ciphertext block (or left unchanged if @len == 0).
+ * @key: The key, already prepared using aes_preparekey()
+ *
+ * This supports incremental decryption.  The length of each chunk must be a
+ * multiple of AES_BLOCK_SIZE, and the updated @iv must be passed in each time.
+ *
+ * Context: Any context.
+ */
+void aes_cbc_decrypt(u8 *dst, const u8 *src, size_t len,
+		     u8 iv[at_least AES_BLOCK_SIZE], const struct aes_key *key);
+
+/**
+ * aes_cbc_cts_encrypt() - Encrypt data using AES-CBC-CTS (CS3 variant)
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to encrypt, at least AES_BLOCK_SIZE
+ * @iv: The initialization vector, clobbered by this function
+ * @key: The key, already prepared using aes_preparekey() or aes_prepareenckey()
+ *
+ * Context: Any context.
+ */
+void aes_cbc_cts_encrypt(u8 *dst, const u8 *src, size_t len,
+			 u8 iv[at_least AES_BLOCK_SIZE], aes_encrypt_arg key);
+
+/**
+ * aes_cbc_cts_decrypt() - Decrypt data using AES-CBC-CTS (CS3 variant)
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to decrypt, at least AES_BLOCK_SIZE
+ * @iv: The initialization vector, clobbered by this function
+ * @key: The key, already prepared using aes_preparekey()
+ *
+ * Context: Any context.
+ */
+void aes_cbc_cts_decrypt(u8 *dst, const u8 *src, size_t len,
+			 u8 iv[at_least AES_BLOCK_SIZE],
+			 const struct aes_key *key);
+
+#endif /* _CRYPTO_AES_CBC_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 26514c181a7f..c64cc3e12b57 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -27,6 +27,12 @@ config CRYPTO_LIB_AESCFB
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_UTILS
 
+config CRYPTO_LIB_AES_CBC
+	tristate
+	select CRYPTO_LIB_AES
+	help
+	  The AES-CBC and AES-CBC-CTS library functions.
+
 config CRYPTO_LIB_AES_CBC_MACS
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index e2f1ebf81405..6710e8291504 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -5,6 +5,7 @@
  */
 
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/aes-cbc.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/utils.h>
@@ -793,6 +794,192 @@ void aes_ecb_decrypt(u8 *dst, const u8 *src, size_t len,
 EXPORT_SYMBOL_GPL(aes_ecb_decrypt);
 #endif /* CONFIG_CRYPTO_LIB_AES_ECB */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CBC)
+/*
+ * Hooks for optimized AES-CBC implementations, overridable by the architecture.
+ * They are called with len > 0 && len % AES_BLOCK_SIZE == 0.  Returning false
+ * causes the fallback implementation to be used instead.
+ */
+#ifndef aes_cbc_encrypt_arch
+static bool aes_cbc_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_enckey *key)
+{
+	return false;
+}
+#endif
+#ifndef aes_cbc_decrypt_arch
+static bool aes_cbc_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 iv[AES_BLOCK_SIZE],
+				 const struct aes_key *key)
+{
+	return false;
+}
+#endif
+
+void aes_cbc_encrypt(u8 *dst, const u8 *src, size_t len, u8 iv[AES_BLOCK_SIZE],
+		     aes_encrypt_arg key)
+{
+	const u8 *prev = iv;
+
+	if (WARN_ON_ONCE(len % AES_BLOCK_SIZE))
+		len = round_down(len, AES_BLOCK_SIZE);
+
+	if (unlikely(len == 0))
+		return;
+
+	if (likely(aes_cbc_encrypt_arch(dst, src, len, iv, key.enc_key)))
+		return;
+
+	do {
+		crypto_xor_cpy(dst, src, prev, AES_BLOCK_SIZE);
+		aes_encrypt(key, dst, dst);
+		prev = dst;
+		dst += AES_BLOCK_SIZE;
+		src += AES_BLOCK_SIZE;
+		len -= AES_BLOCK_SIZE;
+	} while (len);
+	memcpy(iv, prev, AES_BLOCK_SIZE);
+}
+EXPORT_SYMBOL_GPL(aes_cbc_encrypt);
+
+void aes_cbc_decrypt(u8 *dst, const u8 *src, size_t len, u8 iv[AES_BLOCK_SIZE],
+		     const struct aes_key *key)
+{
+	u8 next_iv[AES_BLOCK_SIZE];
+
+	if (WARN_ON_ONCE(len % AES_BLOCK_SIZE))
+		len = round_down(len, AES_BLOCK_SIZE);
+
+	if (unlikely(len == 0))
+		return;
+
+	if (likely(aes_cbc_decrypt_arch(dst, src, len, iv, key)))
+		return;
+
+	len -= AES_BLOCK_SIZE;
+	dst += len;
+	src += len;
+	memcpy(next_iv, src, AES_BLOCK_SIZE);
+	for (;;) {
+		aes_decrypt(key, dst, src);
+		if (len == 0)
+			break;
+		src -= AES_BLOCK_SIZE;
+		crypto_xor(dst, src, AES_BLOCK_SIZE);
+		dst -= AES_BLOCK_SIZE;
+		len -= AES_BLOCK_SIZE;
+	}
+	crypto_xor(dst, iv, AES_BLOCK_SIZE);
+	memcpy(iv, next_iv, AES_BLOCK_SIZE);
+}
+EXPORT_SYMBOL_GPL(aes_cbc_decrypt);
+
+/*
+ * Hooks for optimized AES-CBC-CTS implementations, overridable by the
+ * architecture.  They are called with len > AES_BLOCK_SIZE.  Returning false
+ * causes the fallback implementation to be used instead.  The fallback
+ * implementation still uses the arch-optimized AES-CBC code if available, but
+ * direct implementation of AES-CBC-CTS is helpful on short messages.
+ */
+#ifndef aes_cbc_cts_encrypt_arch
+static bool aes_cbc_cts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				     u8 iv[AES_BLOCK_SIZE],
+				     const struct aes_enckey *key)
+{
+	return false;
+}
+#endif
+#ifndef aes_cbc_cts_decrypt_arch
+static bool aes_cbc_cts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				     u8 iv[AES_BLOCK_SIZE],
+				     const struct aes_key *key)
+{
+	return false;
+}
+#endif
+
+void aes_cbc_cts_encrypt(u8 *dst, const u8 *src, size_t len,
+			 u8 iv[AES_BLOCK_SIZE], aes_encrypt_arg key)
+{
+	/* Offset to P[n] and C[n] (last plaintext and ciphertext block) */
+	size_t pn_offset = round_down(len - 1, AES_BLOCK_SIZE);
+	/* Length of P[n] and C[n], 1 <= pn_len <= AES_BLOCK_SIZE */
+	size_t pn_len = len - pn_offset;
+	u8 tmp[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+	u8 *pad;
+
+	if (WARN_ON_ONCE(len < AES_BLOCK_SIZE))
+		return;
+
+	if (len == AES_BLOCK_SIZE) {
+		aes_cbc_encrypt(dst, src, len, iv, key);
+		return;
+	}
+	if (likely(aes_cbc_cts_encrypt_arch(dst, src, len, iv, key.enc_key)))
+		return;
+
+	/* CBC-encrypt all blocks except the last. */
+	aes_cbc_encrypt(dst, src, pn_offset, iv, key);
+
+	/*
+	 * Compute C[n] and C[n - 1].
+	 *
+	 * Careful: src may equal dst (i.e., the encryption can be in-place), so
+	 * src[pn_offset..] can't be read after dst[pn_offset..] is written.
+	 */
+	pad = &dst[pn_offset - AES_BLOCK_SIZE];
+	memcpy(tmp, pad, AES_BLOCK_SIZE);
+	crypto_xor(tmp, &src[pn_offset], pn_len);
+	memcpy(&dst[pn_offset], pad, pn_len); /* C[n] */
+	aes_encrypt(key, pad, tmp); /* C[n - 1] */
+
+	memzero_explicit(tmp, sizeof(tmp));
+}
+EXPORT_SYMBOL_GPL(aes_cbc_cts_encrypt);
+
+void aes_cbc_cts_decrypt(u8 *dst, const u8 *src, size_t len,
+			 u8 iv[AES_BLOCK_SIZE], const struct aes_key *key)
+{
+	/* Offset to P[n] and C[n] (last plaintext and ciphertext block) */
+	size_t pn_offset = round_down(len - 1, AES_BLOCK_SIZE);
+	/* Length of P[n] and C[n], 1 <= pn_len <= AES_BLOCK_SIZE */
+	size_t pn_len = len - pn_offset;
+	u8 *pad;
+
+	if (WARN_ON_ONCE(len < AES_BLOCK_SIZE))
+		return;
+
+	if (len == AES_BLOCK_SIZE) {
+		aes_cbc_decrypt(dst, src, len, iv, key);
+		return;
+	}
+	if (likely(aes_cbc_cts_decrypt_arch(dst, src, len, iv, key)))
+		return;
+
+	/* Compute P[0]..P[n - 2]. */
+	aes_cbc_decrypt(dst, src, pn_offset - AES_BLOCK_SIZE, iv, key);
+
+	/*
+	 * Compute P[n] and P[n - 1].
+	 *
+	 * Careful: src may equal dst (i.e., the decryption can be in-place), so
+	 * src[pn_offset..] can't be read after dst[pn_offset..] is written.
+	 *
+	 * To avoid needing a temporary buffer, do a "redundant" XOR to recover
+	 * src[pn_offset..] from dst[pn_offset..] after the latter is written.
+	 */
+	pad = &dst[pn_offset - AES_BLOCK_SIZE];
+	aes_decrypt(key, pad, &src[pn_offset - AES_BLOCK_SIZE]);
+	crypto_xor_cpy(&dst[pn_offset], &src[pn_offset], pad,
+		       pn_len); /* P[n] */
+	crypto_xor(pad, &dst[pn_offset], pn_len);
+	aes_decrypt(key, pad, pad);
+	crypto_xor(pad, iv, AES_BLOCK_SIZE); /* P[n - 1] */
+}
+EXPORT_SYMBOL_GPL(aes_cbc_cts_decrypt);
+#endif /* CONFIG_CRYPTO_LIB_AES_CBC */
+
 static int __init aes_mod_init(void)
 {
 #ifdef aes_mod_init_arch
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index a57e87dbb1b1..e78086f3c954 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -144,6 +144,7 @@ config CRYPTO_LIB_SM3_KUNIT_TEST
 config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	tristate "Enable all crypto library code for KUnit tests"
 	depends on KUNIT
+	select CRYPTO_LIB_AES_CBC
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_AES_ECB
 	select CRYPTO_LIB_BLAKE2B
-- 
2.55.0

