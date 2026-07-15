Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69B43CFF6C;
	Wed, 15 Jul 2026 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153564; cv=none; b=sE0Rhzp3jtv8wNzfmqISxAjpsTkyxLzrPmB2XyDeHBkeLBHYhieO9/mLJsiq+TO2DathdNTSxmEvuypRuTaU4bRTMItrkxOMFplbsGX34V/gT4TTH6LpS8NlUADN3mMkTPDNHGhZccIMVJa8WeXSltkPo0k0l3bl8B8vMUWFicY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153564; c=relaxed/simple;
	bh=B0fztXzIR2xwOw4aMHpGcVof/C+9ZXCQWotLBdlAd4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldyxnOp5fZK/z81VgNOOxKMUWzajejj/3HpnSXEteE5hh+aCUD5b316pg3QjGfN28uxl//bA/fe02SyxZ11ie6KhIIJEOXj8sXi0aetVwHXREsYtyvNm7W1ijcO+Nze1kveYHf1WfiTd7iXC8JVz756CpG8KRzwj8njeI7q8uYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olgoeN/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olgoeN/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9A71F00A3E;
	Wed, 15 Jul 2026 22:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153562;
	bh=oayr9qowYYpJzWDTfZs2bh+aLpd0OH9jYde0Q3W/KBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olgoeN/9A5CnE6COO8KTgqa8zMNhGHzThbXIldWdbBeZEGYFA3qc8dZti8z2W2zht
	 ew2Hg/1BFP1OkD7DlJwAS+3Ru6h2LNsm/ULLX/tjkqnrZQnOOTvUBt3m8ON4Y0Oux4
	 m6nKN+ecmLrF1LJWYbIXPWd42wvvPGczQiFaT9VJek8/CyQwXr4VcEzTCNF5+JiPWv
	 pB42SqIy1nNXeBgM5HbWMKo68xhfUSdLkenjybdA2RUYa4qcirAu3GlppuUEd+aniC
	 JZluR0aF4PVyybPxbpcX7D4jjM6oKhMnRUp13ZyYIOOS02nCk+YbtEvfZkHbxXJZG/
	 UEtyqD7LDhIYQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 04/13] lib/crypto: aes: Add CTR and XCTR support
Date: Wed, 15 Jul 2026 15:11:44 -0700
Message-ID: <20260715221153.246410-5-ebiggers@kernel.org>
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
 include/crypto/aes-ctr.h                      | 65 +++++++++++++
 lib/crypto/Kconfig                            |  6 ++
 lib/crypto/aes.c                              | 96 +++++++++++++++++++
 lib/crypto/tests/Kconfig                      |  1 +
 5 files changed, 175 insertions(+)
 create mode 100644 include/crypto/aes-ctr.h

diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
index 82bdb0d1b93e..4d3555ee81b7 100644
--- a/Documentation/crypto/libcrypto-unauth-encryption.rst
+++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
@@ -27,6 +27,13 @@ This API provides support for AES in the CBC and CBC-CTS modes of operation.
 
 .. kernel-doc:: include/crypto/aes-cbc.h
 
+AES-CTR and AES-XCTR
+--------------------
+
+This API provides support for AES in the CTR and XCTR modes of operation.
+
+.. kernel-doc:: include/crypto/aes-ctr.h
+
 AES-ECB
 -------
 
diff --git a/include/crypto/aes-ctr.h b/include/crypto/aes-ctr.h
new file mode 100644
index 000000000000..8e214a85716b
--- /dev/null
+++ b/include/crypto/aes-ctr.h
@@ -0,0 +1,65 @@
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
+ * @key: The key, already prepared using aes_preparekey() or aes_prepareenckey()
+ *
+ * This implements AES in counter mode with a 128-bit big endian counter.
+ *
+ * This exists only for use by the implementation of modes built on top of CTR
+ * (e.g., GCM and CCM) and some legacy protocols that use CTR mode directly.
+ * Callers are expected to know how to use CTR mode appropriately, including
+ * choosing (key, counter) pairs appropriately to avoid keystream reuse.
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
+ * @ctr: The block counter (in host endianness).  For the first call, set it to
+ *	 1.  It will be incremented by ceil(@len / AES_BLOCK_SIZE).
+ * @iv: The initialization vector
+ * @key: The key, already prepared using aes_preparekey() or aes_prepareenckey()
+ *
+ * This implements AES in XOR Counter mode, as specified in the paper
+ * "Length-preserving encryption with HCTR2"
+ * (https://eprint.iacr.org/2021/1441.pdf).
+ *
+ * This exists only for use by the implementation of modes built on top of XCTR.
+ * Callers are expected to know how to use XCTR mode appropriately, including
+ * choosing (key, IV) pairs appropriately to avoid keystream reuse.
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
index c64cc3e12b57..67a44e82309d 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -41,6 +41,12 @@ config CRYPTO_LIB_AES_CBC_MACS
 	  this if your module uses any of the functions from
 	  <crypto/aes-cbc-macs.h>.
 
+config CRYPTO_LIB_AES_CTR
+	tristate
+	select CRYPTO_LIB_AES
+	help
+	  The AES-CTR and AES-XCTR library functions.
+
 config CRYPTO_LIB_AES_ECB
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 6710e8291504..84384582b5bb 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -6,6 +6,7 @@
 
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/aes-cbc.h>
+#include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes.h>
 #include <crypto/utils.h>
@@ -980,6 +981,101 @@ void aes_cbc_cts_decrypt(u8 *dst, const u8 *src, size_t len,
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
+	/*
+	 * 255 times out of 256 the first iteration is enough, so unroll the
+	 * first iteration as a micro-optimization.
+	 */
+	if ((++ctr[AES_BLOCK_SIZE - 1]) != 0)
+		return;
+	for (int i = AES_BLOCK_SIZE - 2; i >= 0; i--) {
+		if (++ctr[i] != 0)
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
2.55.0

