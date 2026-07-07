Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDFE376A02;
	Tue,  7 Jul 2026 05:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402638; cv=none; b=sIEmtb7Xtia9FehrWFSyj7M5HeZCyGt0yGEB3XlrLZXTb2lQTsegcSSMoJYtN4jIesoS/9lfv4kk82v/XbdhhvGqBSa3nax+fNbKuXMIcqhyC/FkMUZMxqIF/a7hMKybQvoX7B1Wd7E5ZP08XZzZTUjI/+ljMT7yOwgB4lx/3Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402638; c=relaxed/simple;
	bh=OeWNVbgTJSNbl8qlmF/Hc8nghlNjQNVYaBhE7CY2F0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+lK4Q1TwYarDbJ5GKE6DWson8nK5S9J06FU4RvNpPMROBz1dwEK/ssSsyD1MKSUtRb4PLV9ospNFlLDIzyyAgNUV3+1gFrYwiooSbbR5Valj4keZ14+Sk48/D1v3ZLgphJF3AnSN91Vl+H/NPR/CGZPWI5nVWjqK918CpBTqIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coW/C5CM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coW/C5CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52351F00A3E;
	Tue,  7 Jul 2026 05:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402637;
	bh=8sNUhgScXm8dR1MHDBIUDLo9ViVtIikG2IEU+Pl4IQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=coW/C5CMQp4uTfukquWRySZKwmazl3ZPBXBpd7RX93HSpw24j2GvtRHMB7UpCFyU5
	 hTe15Burtuqiq/6N3JmzxD1gUWsjdRt1tj+6bB/APn0IEOhXEvLBXO1Wzv4ybPpp+G
	 0jISvwvmJ0F3QeWF1UHzhb//4L8Rg4KqI5rPue6IbTaELV1xWmflFkVIndazJa+p23
	 tsIenrIcu0NMAO/xW3MrVj87yhpbljNtuIzXTeAyCRIVJVqT1w62yQQrlFOPNt2/K2
	 plX5YoLIawwgCU2R17Ae+iUbg/1w38PEgvyM42FAdYleqL3nfZdhWK8MmCqkLHmAw1
	 OcvB8JKdM0hyQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 02/33] lib/crypto: aes: Add ECB support
Date: Mon,  6 Jul 2026 22:34:32 -0700
Message-ID: <20260707053503.209874-3-ebiggers@kernel.org>
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

Add support for AES-ECB to the crypto library.

This will be used to provide a streamlined implementation of the
"ecb(aes)" crypto_skcipher algorithm.  fs/crypto/keysetup_v1.c will also
use aes_ecb_encrypt() directly.

As usual, the architecture-optimized AES-ECB code will be migrated into
the library as well (using the hooks provided in this commit),
eliminating lots of repetitive boilerplate code.

ECB is obsolete of course, but we need this for parity with the
traditional API and to support some odd users of ECB in the kernel.

Initial test coverage is provided by the crypto_skcipher support added
in a later commit.  I'm planning a KUnit test suite as well.

Create a documentation file libcrypto-unauth-encryption.rst to hold the
documentation for this and other unauthenticated encryption modes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/libcrypto-unauth-encryption.rst    | 28 ++++++++++
 Documentation/crypto/libcrypto.rst            |  1 +
 include/crypto/aes-ecb.h                      | 49 ++++++++++++++++
 lib/crypto/Kconfig                            |  9 ++-
 lib/crypto/aes.c                              | 56 +++++++++++++++++++
 lib/crypto/tests/Kconfig                      |  1 +
 6 files changed, 142 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-unauth-encryption.rst
 create mode 100644 include/crypto/aes-ecb.h

diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
new file mode 100644
index 000000000000..891c15279749
--- /dev/null
+++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
@@ -0,0 +1,28 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Unauthenticated encryption
+==========================
+
+Support for unauthenticated encryption and decryption, including bare stream
+ciphers and other length-preserving algorithms such as block ciphers in XTS
+mode.  The legitimate use cases for these algorithms are:
+
+- Support for legacy protocols that really should have chosen an authenticated
+  mode (or even another primitive entirely) but didn't.
+
+- Internal components of authenticated modes.  For example, AES-CTR is used by
+  AES-GCM and AES-CCM internally.
+
+- Storage encryption that cannot accommodate ciphertext expansion.  Usually
+  AES-XTS is used for this.
+
+- Stream ciphers for key derivation and random number generation.
+
+Besides the above, these shouldn't be used.
+
+AES-ECB
+-------
+
+Support for AES in the ECB mode of operation.
+
+.. kernel-doc:: include/crypto/aes-ecb.h
diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
index a1557d45b0e5..bbf5ca137910 100644
--- a/Documentation/crypto/libcrypto.rst
+++ b/Documentation/crypto/libcrypto.rst
@@ -161,5 +161,6 @@ API documentation
    libcrypto-blockcipher
    libcrypto-hash
    libcrypto-signature
+   libcrypto-unauth-encryption
    libcrypto-utils
    sha3
diff --git a/include/crypto/aes-ecb.h b/include/crypto/aes-ecb.h
new file mode 100644
index 000000000000..bfc56bdb082c
--- /dev/null
+++ b/include/crypto/aes-ecb.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AES-ECB unauthenticated encryption and decryption
+ *
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_AES_ECB_H
+#define _CRYPTO_AES_ECB_H
+
+#include <crypto/aes.h>
+
+/**
+ * aes_ecb_encrypt() - Encrypt data using AES-ECB
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to encrypt.  Must be a multiple of AES_BLOCK_SIZE.
+ * @key: The key
+ *
+ * ECB mode is insecure by itself.  This function exists only for compatibility
+ * with legacy protocols and for internal use by other modes.
+ *
+ * This supports incremental encryption, but the length of each chunk must be a
+ * multiple of AES_BLOCK_SIZE.
+ *
+ * Context: Any context.
+ */
+void aes_ecb_encrypt(u8 *dst, const u8 *src, size_t len, aes_encrypt_arg key);
+
+/**
+ * aes_ecb_decrypt() - Decrypt data using AES-ECB
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to decrypt.  Must be a multiple of AES_BLOCK_SIZE.
+ * @key: The key
+ *
+ * ECB mode is insecure by itself.  This function exists only for compatibility
+ * with legacy protocols and for internal use by other modes.
+ *
+ * This supports incremental decryption, but the length of each chunk must be a
+ * multiple of AES_BLOCK_SIZE.
+ *
+ * Context: Any context.
+ */
+void aes_ecb_decrypt(u8 *dst, const u8 *src, size_t len,
+		     const struct aes_key *key);
+
+#endif /* _CRYPTO_AES_ECB_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 591c1c2a7fb3..26514c181a7f 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -8,8 +8,7 @@ config CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_AES
 	tristate
-	# Select dependencies of modes that are part of libaes.
-	select CRYPTO_LIB_UTILS if CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_AES_ARCH
 	bool
@@ -36,6 +35,12 @@ config CRYPTO_LIB_AES_CBC_MACS
 	  this if your module uses any of the functions from
 	  <crypto/aes-cbc-macs.h>.
 
+config CRYPTO_LIB_AES_ECB
+	tristate
+	select CRYPTO_LIB_AES
+	help
+	  The AES-ECB library functions.
+
 config CRYPTO_LIB_AESGCM
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index ca733f15b2a8..e2f1ebf81405 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -5,6 +5,7 @@
  */
 
 #include <crypto/aes-cbc-macs.h>
+#include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/utils.h>
 #include <linux/cache.h>
@@ -737,6 +738,61 @@ static inline void aes_cmac_fips_test(void)
 }
 #endif /* !CONFIG_CRYPTO_LIB_AES_CBC_MACS */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_ECB)
+/*
+ * Hooks for optimized AES-ECB implementations, overridable by the architecture.
+ * They are called with len > 0 && len % AES_BLOCK_SIZE == 0.  Returning false
+ * causes the fallback implementation to be used instead.
+ */
+#ifndef aes_ecb_encrypt_arch
+static bool aes_ecb_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_enckey *key)
+{
+	return false;
+}
+#endif
+#ifndef aes_ecb_decrypt_arch
+static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_key *key)
+{
+	return false;
+}
+#endif
+
+void aes_ecb_encrypt(u8 *dst, const u8 *src, size_t len, aes_encrypt_arg key)
+{
+	if (WARN_ON_ONCE(len % AES_BLOCK_SIZE))
+		len = round_down(len, AES_BLOCK_SIZE);
+
+	if (unlikely(len == 0))
+		return;
+
+	if (likely(aes_ecb_encrypt_arch(dst, src, len, key.enc_key)))
+		return;
+
+	for (size_t i = 0; i < len; i += AES_BLOCK_SIZE)
+		aes_encrypt(key, &dst[i], &src[i]);
+}
+EXPORT_SYMBOL_GPL(aes_ecb_encrypt);
+
+void aes_ecb_decrypt(u8 *dst, const u8 *src, size_t len,
+		     const struct aes_key *key)
+{
+	if (WARN_ON_ONCE(len % AES_BLOCK_SIZE))
+		len = round_down(len, AES_BLOCK_SIZE);
+
+	if (unlikely(len == 0))
+		return;
+
+	if (likely(aes_ecb_decrypt_arch(dst, src, len, key)))
+		return;
+
+	for (size_t i = 0; i < len; i += AES_BLOCK_SIZE)
+		aes_decrypt(key, &dst[i], &src[i]);
+}
+EXPORT_SYMBOL_GPL(aes_ecb_decrypt);
+#endif /* CONFIG_CRYPTO_LIB_AES_ECB */
+
 static int __init aes_mod_init(void)
 {
 #ifdef aes_mod_init_arch
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 9409c1a935c3..a57e87dbb1b1 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -145,6 +145,7 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	tristate "Enable all crypto library code for KUnit tests"
 	depends on KUNIT
 	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_ECB
 	select CRYPTO_LIB_BLAKE2B
 	select CRYPTO_LIB_CHACHA20POLY1305
 	select CRYPTO_LIB_CURVE25519
-- 
2.54.0

