Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBC8385D8F;
	Tue,  7 Jul 2026 05:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402640; cv=none; b=HRF1XTNaTKGv3U0Hft2WxHenPiKG2MZ7vj3o10Jsf1OCDseKvoc8PHaL9GQ19DP/4jHvu/ZhlMoep9k71mDjWxg8E/awneZsAg3vCBFOTUfEa3uHslhTVetHQwh3qBdjHKcjJXm2WVrEwS/feaEtdM+cP9YKqKWnYIAFTFlRIBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402640; c=relaxed/simple;
	bh=jOgIiVD7Mn8gzoffnE6V3C17CLLNZD6il6P6m28k/7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2hI29fAHsSzCXh4Enx7khjt1UyVelj0KAMJliSCd0ysnfmmzJpVs/4NiTDanw2vtttFHecNInJ64tECTCLlxSzzUJwIhcP4B5t77z89z7q5JFtJCRanZp/F3uh9NKM1WUc+u/B3hgR+lhWFFtBnYsBl4pcmV6BZJO8wNfb5hEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ytyl0Qqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ytyl0Qqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BBB1F00ACA;
	Tue,  7 Jul 2026 05:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402637;
	bh=VptQ97cdXDaY+elAg+U/IfYlsYOqfzsoozECAUR1eD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ytyl0Qqz1CZ015iRlKA6D7C63yhv1FYEGHtBsFZzKm51nTb+v85FeySh9r3TUm1Kj
	 zaIHXmHO26u5H0Jtp0S56bt9kxMY0xnqV9XbiP4o2UrWkYg2V0IexMo9ieYns+zuqn
	 9iva3zq7As4Hvyl+QWvVskEirwswKzfQN5gaW8zBEU1P2jQDJ2wq3hJcQbE+8cnm+o
	 qcot//Jdm6LrQoMNxjgwTftu7SExPAl3lTGk3Fmw0hGEg/dvXHIeKnadZGDlJp0PsV
	 QEbGM+UQ35foRg/27qnPP2cJizQZUEAAPUmEwjvxOL9CSP4Qs4MDjXPcXiILtB593Q
	 DQseF2xMb/PRg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 05/33] lib/crypto: aes: Add XTS support
Date: Mon,  6 Jul 2026 22:34:35 -0700
Message-ID: <20260707053503.209874-6-ebiggers@kernel.org>
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

Add support for AES-XTS to the crypto library.

This will be used to provide a streamlined implementation of the
"xts(aes)" crypto_skcipher algorithm.  I'm also planning to use this
directly in fscrypt and blk-crypto-fallback.

As usual, the architecture-optimized AES-XTS code will be migrated into
the library as well (using the hooks provided in this commit),
eliminating lots of repetitive boilerplate code.  Compared to direct
implementation of "xts(aes)", I've also eliminated the requirement for
architectures to implement ciphertext stealing, as the library just
handles it portably instead.  That will simplify things considerably.

Initial test coverage is provided by the crypto_skcipher support added
in a later commit.  I'm planning a KUnit test suite as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/libcrypto-unauth-encryption.rst    |   7 +
 include/crypto/aes-xts.h                      |  87 +++++++
 lib/crypto/Kconfig                            |   6 +
 lib/crypto/aes.c                              | 224 ++++++++++++++++++
 lib/crypto/tests/Kconfig                      |   1 +
 5 files changed, 325 insertions(+)
 create mode 100644 include/crypto/aes-xts.h

diff --git a/Documentation/crypto/libcrypto-unauth-encryption.rst b/Documentation/crypto/libcrypto-unauth-encryption.rst
index 6aca01d715da..15deba7e53e8 100644
--- a/Documentation/crypto/libcrypto-unauth-encryption.rst
+++ b/Documentation/crypto/libcrypto-unauth-encryption.rst
@@ -40,3 +40,10 @@ AES-ECB
 Support for AES in the ECB mode of operation.
 
 .. kernel-doc:: include/crypto/aes-ecb.h
+
+AES-XTS
+-------
+
+Support for AES in the XTS mode of operation.
+
+.. kernel-doc:: include/crypto/aes-xts.h
diff --git a/include/crypto/aes-xts.h b/include/crypto/aes-xts.h
new file mode 100644
index 000000000000..226ac38d54ac
--- /dev/null
+++ b/include/crypto/aes-xts.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AES-XTS unauthenticated encryption and decryption
+ *
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_AES_XTS_H
+#define _CRYPTO_AES_XTS_H
+
+#include <crypto/aes.h>
+#include <crypto/xts.h>
+
+/**
+ * struct aes_xts_key - A key prepared for AES-XTS encryption and decryption
+ *
+ * Note that (depending on the architecture) this typically is around 768 bytes,
+ * which makes it a bit too large to allocate on the stack in most cases.
+ */
+struct aes_xts_key {
+	/* private: */
+	struct aes_key main_key;
+	struct aes_enckey tweak_key;
+};
+
+/**
+ * aes_xts_preparekey() - Prepare an AES-XTS key
+ * @key: (output) The key structure to initialize
+ * @in_key: The raw AES-XTS key
+ * @key_len: Length of the raw key in bytes
+ * @flags: Optional flag XTS_FORBID_WEAK_KEYS to forbid keys whose two halves
+ *	   are the same.
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success
+ * * -EINVAL if the key is rejected because its length isn't 32, 64, or (when
+ *   FIPS mode isn't enabled) 48; or because its two halves are the same and
+ *   either XTS_FORBID_WEAK_KEYS is given or FIPS mode is enabled.
+ */
+int __must_check aes_xts_preparekey(struct aes_xts_key *key, const u8 *in_key,
+				    size_t key_len, int flags);
+
+/**
+ * aes_xts_encrypt() - Encrypt data using AES-XTS
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to encrypt.  Must be >= AES_BLOCK_SIZE.  On non-last
+ *	 calls it also must be a multiple of AES_BLOCK_SIZE.
+ * @tweak: The tweak.  It is updated with the next value, unless @len isn't a
+ *	   multiple of AES_BLOCK_SIZE in which case the value is unspecified.
+ * @key: The key
+ * @cont: %true to continue same message (skip tweak encryption)
+ *
+ * This supports both one-shot and incremental encryption.  For incremental
+ * encryption, all non-last calls require @len aligned to AES_BLOCK_SIZE, and
+ * all non-first calls require @cont = %true.
+ *
+ * Context: Any context.
+ */
+void aes_xts_encrypt(u8 *dst, const u8 *src, size_t len,
+		     u8 tweak[at_least AES_BLOCK_SIZE],
+		     const struct aes_xts_key *key, bool cont);
+
+/**
+ * aes_xts_decrypt() - Decrypt data using AES-XTS
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source data
+ * @len: Number of bytes to decrypt.  Must be >= AES_BLOCK_SIZE.  On non-last
+ *	 calls it also must be a multiple of AES_BLOCK_SIZE.
+ * @tweak: The tweak.  It is updated with the next value, unless @len isn't a
+ *	   multiple of AES_BLOCK_SIZE in which case the value is unspecified.
+ * @key: The key
+ * @cont: %true to continue same message (skip tweak encryption)
+ *
+ * This supports both one-shot and incremental decryption.  For incremental
+ * decryption, all non-last calls require @len aligned to AES_BLOCK_SIZE, and
+ * all non-first calls require @cont = %true.
+ *
+ * Context: Any context.
+ */
+void aes_xts_decrypt(u8 *dst, const u8 *src, size_t len,
+		     u8 tweak[at_least AES_BLOCK_SIZE],
+		     const struct aes_xts_key *key, bool cont);
+
+#endif /* _CRYPTO_AES_XTS_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 96febc3df6d6..9af44cf743a7 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -53,6 +53,12 @@ config CRYPTO_LIB_AES_CTR
 	help
 	  The AES-CTR and AES-XCTR library functions.
 
+config CRYPTO_LIB_AES_XTS
+	tristate
+	select CRYPTO_LIB_AES
+	help
+	  The AES-XTS library functions.
+
 config CRYPTO_LIB_AESGCM
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 9da274a72221..630702a4228c 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -8,7 +8,9 @@
 #include <crypto/aes-cbc.h>
 #include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
+#include <crypto/aes-xts.h>
 #include <crypto/aes.h>
+#include <crypto/gf128mul.h>
 #include <crypto/utils.h>
 #include <linux/cache.h>
 #include <linux/crypto.h>
@@ -1060,6 +1062,228 @@ void aes_xctr(u8 *dst, const u8 *src, size_t len, u64 *ctr,
 EXPORT_SYMBOL_GPL(aes_xctr);
 #endif /* CONFIG_CRYPTO_LIB_AES_CTR */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
+int aes_xts_preparekey(struct aes_xts_key *key, const u8 *in_key,
+		       size_t key_len, int flags)
+{
+	int err;
+
+	err = __xts_verify_key(in_key, key_len, flags);
+	if (err)
+		return err;
+	/* First half of XTS key is the main key */
+	err = aes_preparekey(&key->main_key, in_key, key_len / 2);
+	if (err)
+		return err;
+	/* Second half of XTS key is the tweak key */
+	return aes_prepareenckey(&key->tweak_key, &in_key[key_len / 2],
+				 key_len / 2);
+}
+EXPORT_SYMBOL_GPL(aes_xts_preparekey);
+
+/*
+ * Hooks for optimized AES-XTS implementations, overridable by the architecture.
+ * They are called with len > 0 && len % AES_BLOCK_SIZE == 0.  In other words,
+ * they aren't expected to handle ciphertext stealing or empty inputs.
+ * Returning false causes the fallback implementation to be used instead.
+ *
+ * (Currently, all users of AES-XTS in the kernel seem to en/decrypt whole
+ * numbers of blocks anyway, with len >= 512.  So there's no need to heavily
+ * optimize ciphertext stealing for short messages.)
+ */
+#ifndef aes_xts_encrypt_arch
+static bool aes_xts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return false;
+}
+#endif
+#ifndef aes_xts_decrypt_arch
+static bool aes_xts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return false;
+}
+#endif
+
+static noinline void aes_xts_crypt_nocts_blockbyblock(
+	u8 *dst, const u8 *src, size_t len, u8 tweak[AES_BLOCK_SIZE],
+	const struct aes_xts_key *key, bool cont, bool enc)
+{
+	le128 t;
+
+	if (cont)
+		memcpy(&t, tweak, sizeof(t));
+	else
+		aes_encrypt(&key->tweak_key, (u8 *)&t, tweak);
+	do {
+		crypto_xor_cpy(dst, src, (const u8 *)&t, AES_BLOCK_SIZE);
+		if (enc)
+			aes_encrypt(&key->main_key, dst, dst);
+		else
+			aes_decrypt(&key->main_key, dst, dst);
+		crypto_xor(dst, (const u8 *)&t, AES_BLOCK_SIZE);
+		gf128mul_x_ble(&t, &t);
+		dst += AES_BLOCK_SIZE;
+		src += AES_BLOCK_SIZE;
+		len -= AES_BLOCK_SIZE;
+	} while (len);
+	memcpy(tweak, &t, sizeof(t));
+	memzero_explicit(&t, sizeof(t));
+}
+
+/* Requires len > 0 && len % AES_BLOCK_SIZE == 0 */
+static __always_inline void aes_xts_encrypt_nocts(u8 *dst, const u8 *src,
+						  size_t len,
+						  u8 tweak[AES_BLOCK_SIZE],
+						  const struct aes_xts_key *key,
+						  bool cont)
+{
+	if (likely(aes_xts_encrypt_arch(dst, src, len, tweak, key, cont)))
+		return;
+
+	/*
+	 * For the fallback, just go block-by-block.  It could be implemented on
+	 * top of AES-ECB, which could be significantly faster than this if the
+	 * arch has optimized AES-ECB code but not AES-XTS.  However, AES-XTS
+	 * performance is important enough that it needs to be (and has been)
+	 * implemented directly by every non-obsolete arch anyway.
+	 */
+	aes_xts_crypt_nocts_blockbyblock(dst, src, len, tweak, key, cont,
+					 /* enc= */ true);
+}
+
+/* Requires len > 0 && len % AES_BLOCK_SIZE == 0 */
+static __always_inline void aes_xts_decrypt_nocts(u8 *dst, const u8 *src,
+						  size_t len,
+						  u8 tweak[AES_BLOCK_SIZE],
+						  const struct aes_xts_key *key,
+						  bool cont)
+{
+	if (likely(aes_xts_decrypt_arch(dst, src, len, tweak, key, cont)))
+		return;
+
+	/* Just go block-by-block.  See comment in aes_xts_encrypt_nocts(). */
+	aes_xts_crypt_nocts_blockbyblock(dst, src, len, tweak, key, cont,
+					 /* enc= */ false);
+}
+
+static noinline void aes_xts_encrypt_cts(u8 *dst, const u8 *src, size_t len,
+					 u8 tweak[AES_BLOCK_SIZE],
+					 const struct aes_xts_key *key,
+					 bool cont)
+{
+	size_t partial_len = len % AES_BLOCK_SIZE; /* Length of partial block */
+	size_t nocts_len = round_down(len, AES_BLOCK_SIZE);
+	u8 tmp_block[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+
+	/* Encrypt all full blocks. */
+	aes_xts_encrypt_nocts(dst, src, nocts_len, tweak, key, cont);
+	dst += nocts_len - AES_BLOCK_SIZE;
+	src += nocts_len - AES_BLOCK_SIZE;
+
+	/*
+	 * Swap the partial block with the first 'partial_len' bytes of the
+	 * encrypted last full block.  Note that a temporary buffer is needed to
+	 * support in-place encryption.
+	 */
+	memcpy(tmp_block, src + AES_BLOCK_SIZE, partial_len);
+	memcpy(dst + AES_BLOCK_SIZE, dst, partial_len);
+	memcpy(dst, tmp_block, partial_len);
+
+	/* Encrypt the last full block again. */
+	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
+	aes_encrypt(&key->main_key, dst, dst);
+	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
+	memzero_explicit(tmp_block, sizeof(tmp_block));
+}
+
+static noinline void aes_xts_decrypt_cts(u8 *dst, const u8 *src, size_t len,
+					 u8 tweak[AES_BLOCK_SIZE],
+					 const struct aes_xts_key *key,
+					 bool cont)
+{
+	size_t partial_len = len % AES_BLOCK_SIZE; /* Length of partial block */
+	size_t nocts_len = round_down(len, AES_BLOCK_SIZE) - AES_BLOCK_SIZE;
+	union {
+		u8 block[AES_BLOCK_SIZE];
+		le128 tweak;
+	} tmp __aligned(__alignof__(long));
+
+	/*
+	 * Decrypt all blocks except the last full block and the partial block.
+	 * The last full block has to be handled specially because decryption
+	 * ciphertext stealing uses the last two tweaks in reverse order.
+	 *
+	 * nocts_len == 0 is possible here, which aes_xts_decrypt_nocts()
+	 * doesn't handle (so that the length doesn't get checked redundantly in
+	 * the fast path).  So handle that case specially as well.
+	 */
+	if (nocts_len)
+		aes_xts_decrypt_nocts(dst, src, nocts_len, tweak, key, cont);
+	else if (!cont)
+		aes_encrypt(&key->tweak_key, tweak, tweak);
+	dst += nocts_len;
+	src += nocts_len;
+
+	/* Copy the tweak, advance it again, then decrypt last full block. */
+	memcpy(&tmp.tweak, tweak, AES_BLOCK_SIZE);
+	gf128mul_x_ble(&tmp.tweak, &tmp.tweak);
+	crypto_xor_cpy(dst, src, tmp.block, AES_BLOCK_SIZE);
+	aes_decrypt(&key->main_key, dst, dst);
+	crypto_xor(dst, tmp.block, AES_BLOCK_SIZE);
+
+	/*
+	 * Swap the partial block with the first 'partial_len' bytes of the
+	 * decrypted last full block.  Note that a temporary buffer is needed to
+	 * support in-place decryption.
+	 */
+	memcpy(tmp.block, src + AES_BLOCK_SIZE, partial_len);
+	memcpy(dst + AES_BLOCK_SIZE, dst, partial_len);
+	memcpy(dst, tmp.block, partial_len);
+
+	/* Decrypt the last full block again. */
+	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
+	aes_decrypt(&key->main_key, dst, dst);
+	crypto_xor(dst, tweak, AES_BLOCK_SIZE);
+	memzero_explicit(&tmp, sizeof(tmp));
+}
+
+void aes_xts_encrypt(u8 *dst, const u8 *src, size_t len,
+		     u8 tweak[AES_BLOCK_SIZE], const struct aes_xts_key *key,
+		     bool cont)
+{
+	if (WARN_ON_ONCE(len < AES_BLOCK_SIZE))
+		return;
+
+	if (unlikely(len % AES_BLOCK_SIZE)) {
+		aes_xts_encrypt_cts(dst, src, len, tweak, key, cont);
+		return;
+	}
+
+	aes_xts_encrypt_nocts(dst, src, len, tweak, key, cont);
+}
+EXPORT_SYMBOL_GPL(aes_xts_encrypt);
+
+void aes_xts_decrypt(u8 *dst, const u8 *src, size_t len,
+		     u8 tweak[AES_BLOCK_SIZE], const struct aes_xts_key *key,
+		     bool cont)
+{
+	if (WARN_ON_ONCE(len < AES_BLOCK_SIZE))
+		return;
+
+	if (unlikely(len % AES_BLOCK_SIZE)) {
+		aes_xts_decrypt_cts(dst, src, len, tweak, key, cont);
+		return;
+	}
+
+	aes_xts_decrypt_nocts(dst, src, len, tweak, key, cont);
+}
+EXPORT_SYMBOL_GPL(aes_xts_decrypt);
+#endif /* CONFIG_CRYPTO_LIB_AES_XTS */
+
 static int __init aes_mod_init(void)
 {
 #ifdef aes_mod_init_arch
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 9284d0134d77..b559e7c79e76 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -148,6 +148,7 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_AES_CTR
 	select CRYPTO_LIB_AES_ECB
+	select CRYPTO_LIB_AES_XTS
 	select CRYPTO_LIB_BLAKE2B
 	select CRYPTO_LIB_CHACHA20POLY1305
 	select CRYPTO_LIB_CURVE25519
-- 
2.54.0

