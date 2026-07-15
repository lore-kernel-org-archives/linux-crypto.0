Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C68C3CF04C;
	Wed, 15 Jul 2026 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153563; cv=none; b=CtPP/9El8QJcjiBbXk7pTcpM9YRvdhBe6hF+pNPl/3Te1ERj4Dq5Pdy+O+T+aBThLDlDrZfTzfeS8s0bXVNL4ee5o3sfJWQfTVGBL12L80L6AXTG6pSnQeJIgPITmFqQFlGy3ZxA+eGFXnz3WdJ5XJ5w9vfoog3czBJDxvWhn5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153563; c=relaxed/simple;
	bh=ABorqzBlOOPp3QQWidBwfsEeS3oqORKRTy7z0HfEP5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j89hF91iw5UguV/Ab9W+7Cbp8lIuuDSJEkBQoA4jQOHbP2PWCg8abCTWwap5HuR65IegAmdULSxAGwPS7lyd7CDWXjqrqmywpqNJ5Js/rmoD2v3UW6FaEsEQJjJN5bjGQFTBC2ADO8ne5oB0HTW51mQkgVQR2oXglwjL/7An8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNDMR2dP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNDMR2dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86231F00A3D;
	Wed, 15 Jul 2026 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153562;
	bh=13QMH3FKypAK5+AwFIW+R1CUkb3y40Q+4DTaJMAQIW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNDMR2dPOjUGJNm8Q7ncEtGMuxdB3xkREV85JdFK01JU0uNeiojJ13ZxKl0rKM1GS
	 Dh92kCoPKJhYxRp9c+vJX6saK+wTfmODzA3jEwlRfLWCxSOjK4JdOzGdq4jxCReJTI
	 MCa6j2enHUkER7wFnZCKDzp2FZlyj6YuJLfKogzUsZanQ5z0biTsJnc07Aygr5uMkJ
	 5kHYUc1PKpnCjFiU2TXEIk3+5fFDJGC224n0SxB5vAtNyCayWUYguLwar+iAjo9fuQ
	 2QsdzSCpcMHmiUN7WOSSF82ur7omavhzgbMgwFWTFihfFp4KpJYxxmYz+5O2KJioEX
	 h0O+I1PCH5q1Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 02/13] lib/crypto: aes: Add ECB support
Date: Wed, 15 Jul 2026 15:11:42 -0700
Message-ID: <20260715221153.246410-3-ebiggers@kernel.org>
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

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/libcrypto-unauth-encryption.rst    | 28 ++++++++++
 Documentation/crypto/libcrypto.rst            |  1 +
 include/crypto/aes-ecb.h                      | 49 ++++++++++++++++
 lib/crypto/Kconfig                            |  6 ++
 lib/crypto/aes.c                              | 56 +++++++++++++++++++
 lib/crypto/tests/Kconfig                      |  1 +
 6 files changed, 141 insertions(+)
 create mode 100644 Documentation/crypto/libcrypto-unauth-encryption.rst
 create mode 100644 include/crypto/aes-ecb.h

diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
new file mode 100644
index 000000000000..6a3397a8adae
--- /dev/null
+++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
@@ -0,0 +1,28 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Unauthenticated encryption
+==========================
+
+These APIs provide support for unauthenticated encryption and decryption,
+including bare stream ciphers and other length-preserving algorithms such as
+block ciphers in XTS mode.  The legitimate use cases for these algorithms are:
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
+This API provides support for AES in the ECB mode of operation.
+
+.. kernel-doc:: include/crypto/aes-ecb.h
diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
index 0733e603d229..33312c3ffad4 100644
--- a/Documentation/crypto/libcrypto.rst
+++ b/Documentation/crypto/libcrypto.rst
@@ -162,5 +162,6 @@ API documentation
    libcrypto-blockcipher
    libcrypto-hash
    libcrypto-signature
+   libcrypto-unauth-encryption
    libcrypto-utils
    sha3
diff --git a/include/crypto/aes-ecb.h b/include/crypto/aes-ecb.h
new file mode 100644
index 000000000000..8cac1f8794c7
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
+ * @key: The key, already prepared using aes_preparekey() or aes_prepareenckey()
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
+ * @key: The key, already prepared using aes_preparekey()
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
index 83d4c95e079e..26514c181a7f 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -35,6 +35,12 @@ config CRYPTO_LIB_AES_CBC_MACS
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
2.55.0

