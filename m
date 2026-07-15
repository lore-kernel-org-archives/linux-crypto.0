Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BF53D3D11;
	Wed, 15 Jul 2026 22:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153566; cv=none; b=jvlud4R0M3aQenFlTkw1Jdg/oMw1Ac5/on4I1MBFK3QmN+kLuM+rFISQsQoN93vu7NJadsPRcYpmmkmyb93y69hRFH1hzCGixY/y6JIhNCG5D1UTK2Iv9DHf/T74K+YBsh4s4RbEBkT9ONBMl7NM4+u01e+cTCyIqGFZ1lUouwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153566; c=relaxed/simple;
	bh=ZYnI2vykuZWNMgwSOIdxUUmz8p84CxKndMoqkaWjJb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ml/tnZjpulL91SQaMMOhNqMoRypQL4Uih3VkdcOOMTLOM3Kc/JLbqCz00Z8swZbQBNr1kBRnZzd99N6s5YmL/5YbitMDuzh0jY1kMlOC0UAZMXbHXmA9HIIvHy3qpZwiqRfYABaiwOq/LO7roN3He9pn894tR/MVdoDlvWF3NzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOjbsaD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOjbsaD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DA11F00ACF;
	Wed, 15 Jul 2026 22:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153563;
	bh=Od/wSK3eJIlKS67EdeBYfeVj+o5UpF68V4i+ayxx9BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOjbsaD/S+RP8aAOaYI5X8gX3m9gVf3PE69vQNt8Ah7ILb2Yhi3cLl55IUpM5JXgF
	 JWk5e8mvtxvaP3GoHH0slebk12eu+u88xk7o90RpxMNPAnFvS9RbMyTNH5gO7GVGNT
	 2Ts/CV/sS/qFJPRsunvpVKNjvHZ788KSIgi7QIa01D2dBB/zXQ59YryX22QGw/2TCU
	 P0nJg7ZP27i15fl0uT+ZgDjbos9bbPoN18jGi5llkin5+TIvrqVEA3CTUE4lL6hw+R
	 sV75KXXiefnedfk3neEAj0xxcQnNdJpms6nxXkS2dzKES8/FXLoWBAf//QmofLmKRT
	 +3AbIgDcR/zpQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 06/13] lib/crypto: aes: Add GCM support
Date: Wed, 15 Jul 2026 15:11:46 -0700
Message-ID: <20260715221153.246410-7-ebiggers@kernel.org>
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

Add support for AES-GCM to the crypto library.

This will be used to provide streamlined implementations of the
"gcm(aes)" and "rfc4106(gcm(aes))" crypto_aead algorithms.  Most users
of these will also be able to switch to the library, which as usual will
be faster and simpler, e.g.:

  - drivers/net/macsec.c
  - fs/smb/client/
  - fs/smb/server/
  - net/ceph/messenger_v2.c
  - net/mac80211/ (for both GMAC and GCMP)
  - net/tipc/crypto.c
  - security/keys/trusted-keys/trusted_dcp.c

(I've already written proof-of-concept patches for all the above, and
they helped inform the API design.)

As usual, the architecture-optimized AES-GCM code will be migrated into
the library as well (using the hooks provided in this commit as well as
the GHASH ones), eliminating lots of repetitive boilerplate code.

Incremental en/decryption is supported.  Incremental operation is a bit
controversial in AEAD APIs because users have to be careful not to
consume any decrypted data that hasn't been authenticated yet.  But I do
think it's the right choice here.  It's not fundamentally different from
the existing incremental MAC APIs, and it's the only approach that's
general enough to work well for all users in the kernel:

  - An array of virtually-addressed buffers (like that used by
    BoringSSL's EVP_AEAD_CTX_sealv() and EVP_AEAD_CTX_openv()) doesn't
    work in the kernel in general, since in some cases the data for a
    single AES-GCM message is contained in a large number of highmem
    pages that each need to be mapped into memory individually.  That
    can be done efficiently only by using CPU-local mappings, but there
    is a limited number of those.

    Ceph messenger v2 is a great example, as it can send or receive up
    to 32 MiB in a single AES-GCM message.  And it needs the
    en/decrypted data to go into a (potentially large) number of bvecs
    provided by a custom iterator, as well as into four
    virtually-addressed buffers, two of which can be large buffers in
    the vmalloc region.

    Even just allocating an array big enough to store all the pointers
    can be problematic in the kernel.  There are cases in which
    decryption runs in GFP_NOIO context or even in softirq context,
    where memory allocations are not as reliable as they normally are.

  - Meanwhile, 'struct scatterlist' (the choice of crypto_aead) has
    turned out to be really inconvenient for anyone who *does* just have
    virtually-addressed buffers.  This is especially true if they can be
    in the vmalloc region, including the stack, as in that case the
    conversion to a scatterlist has to be done page-by-page.

    And even for users who have all of their data in bare 'struct page',
    none of them actually use 'struct scatterlist' as their native data
    structure anyway.  They actually use skbs, bvecs, or other formats.

  - iov_iter is attractive, but ultimately not general enough either
    (considering the Ceph case for example), but also too general in
    some ways (like having support for userspace addresses).  Additional
    iter types like ITER_SKB would help a bit, but bloating iov_iter
    with more types would reduce performance elsewhere in the kernel.

Initial test coverage is provided by the crypto_aead support added in a
later commit.  I'm planning a KUnit test suite as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/libcrypto-auth-encryption.rst      |  13 +
 Documentation/crypto/libcrypto.rst            |   1 +
 include/crypto/aes-gcm.h                      | 260 ++++++++++++++++
 include/crypto/gcm.h                          |   4 +-
 lib/crypto/Kconfig                            |   8 +
 lib/crypto/aes.c                              | 280 ++++++++++++++++++
 lib/crypto/tests/Kconfig                      |   1 +
 7 files changed, 565 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-auth-encryption.rst
 create mode 100644 include/crypto/aes-gcm.h

diff --git a/Documentation/crypto/libcrypto-auth-encryption.rst b/Documentation/crypto/libcrypto-auth-encryption.rst
new file mode 100644
index 000000000000..06c94796b5f4
--- /dev/null
+++ b/Documentation/crypto/libcrypto-auth-encryption.rst
@@ -0,0 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Authenticated encryption
+========================
+
+These APIs provide support for authenticated encryption and decryption.
+
+AES-GCM
+-------
+
+This API provides support for AES in the GCM mode of operation.
+
+.. kernel-doc:: include/crypto/aes-gcm.h
diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
index 33312c3ffad4..e911e0521597 100644
--- a/Documentation/crypto/libcrypto.rst
+++ b/Documentation/crypto/libcrypto.rst
@@ -159,6 +159,7 @@ API documentation
 .. toctree::
    :maxdepth: 2
 
+   libcrypto-auth-encryption
    libcrypto-blockcipher
    libcrypto-hash
    libcrypto-signature
diff --git a/include/crypto/aes-gcm.h b/include/crypto/aes-gcm.h
new file mode 100644
index 000000000000..2aee62f01989
--- /dev/null
+++ b/include/crypto/aes-gcm.h
@@ -0,0 +1,260 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AES-GCM authenticated encryption and decryption
+ *
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_AES_GCM_H
+#define _CRYPTO_AES_GCM_H
+
+#include <crypto/aes.h>
+#include <crypto/gcm.h>
+#include <crypto/gf128hash.h>
+
+/**
+ * struct aes_gcm_key - A key prepared for AES-GCM encryption and decryption
+ */
+struct aes_gcm_key {
+	/* private: */
+	struct aes_enckey aes;
+	struct ghash_key ghash;
+	size_t authtag_len; /* Length of authentication tags in bytes */
+};
+
+/**
+ * struct aes_gcm_ctx - Context for incrementally en/decrypting a message
+ */
+struct aes_gcm_ctx {
+	/* private: */
+	/*
+	 * Pointer to the key, which is assumed to live at least as long as this
+	 * struct.
+	 */
+	const struct aes_gcm_key *key;
+	/* The current GHASH context */
+	struct ghash_ctx ghash;
+	/*
+	 * The current counter.  This can be viewed as either a 128-bit big
+	 * endian counter, or as a 96-bit nonce followed by a 32-bit big endian
+	 * counter; it doesn't matter, since the last 32-bit word starts at 1,
+	 * and AES-GCM is undefined for messages that would overflow that part.
+	 * In practice this means that code optimized for AES-GCM can just
+	 * increment the last 32-bit word (wrapping at 2^32), but when needed it
+	 * can still call AES-CTR code that does a 128-bit increment.
+	 *
+	 * 'long' alignment is for crypto_xor() to work more efficiently.
+	 */
+	union {
+		u8 ctr[AES_BLOCK_SIZE];
+		__be32 ctr32[AES_BLOCK_SIZE / 4];
+	} __aligned(__alignof__(long));
+	/* Buffered keystream for partial block updates */
+	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+	/* Encrypted counter of 1.  This gets XOR'ed with the tag at the end. */
+	u8 j0_enc[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+	/* Number of associated data bytes processed so far */
+	u64 ad_len;
+	/* Number of en/decrypted bytes processed so far */
+	u64 data_len;
+};
+
+/**
+ * aes_gcm_preparekey() - Prepare a key for AES-GCM encryption and decryption
+ * @key: (output) The key structure to initialize
+ * @in_key: The raw AES-GCM key
+ * @key_len: Length of the raw key in bytes: 16, 24, or 32
+ * @authtag_len: Length of the authentication tag in bytes:
+ *		 4, 8, 12, 13, 14, 15, or 16.  16 is recommended.
+ *
+ * Users should use memzero_explicit() to zeroize the key struct at the end of
+ * its lifetime.  (But if this function fails, zeroization is unnecessary.)
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success
+ * * -EINVAL if either of the lengths is invalid
+ */
+int __must_check aes_gcm_preparekey(struct aes_gcm_key *key, const u8 *in_key,
+				    size_t key_len, size_t authtag_len);
+
+/**
+ * aes_gcm_encrypt() - Encrypt a message with AES-GCM
+ * @dst: The destination ciphertext data.  Can be in-place or out-of-place.
+ *	 For other overlaps the behavior is unspecified.
+ * @src: The source plaintext data
+ * @data_len: Length of plaintext in bytes (and ciphertext excluding the tag):
+ *	      at most 2^36 - 32
+ * @authtag: The output authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_gcm_preparekey().  Usually protocols using AES-GCM
+ *	     put the tag at the end of the ciphertext, in which case this should
+ *	     be set to @dst + @data_len and @dst must have room for the tag.
+ * @ad: The associated data
+ * @ad_len: Length of associated data in bytes: at most 2^61 - 1
+ * @nonce: The 12-byte nonce.  All (key, nonce) pairs used MUST be distinct.
+ * @key: The key, already prepared using aes_gcm_preparekey()
+ *
+ * For AES-GMAC (i.e., AES-GCM without any data en/decrypted), use dst=NULL,
+ * src=NULL, and data_len=0 to generate the AES-GMAC value.
+ *
+ * Context: Any context.
+ */
+void aes_gcm_encrypt(u8 *dst, const u8 *src, size_t data_len, u8 *authtag,
+		     const u8 *ad, size_t ad_len, const u8 nonce[at_least 12],
+		     const struct aes_gcm_key *key);
+
+/**
+ * aes_gcm_decrypt() - Decrypt a message with AES-GCM
+ * @dst: The destination plaintext data.  Can be in-place or out-of-place.
+ *	 For other overlaps the behavior is unspecified.
+ * @src: The source ciphertext data
+ * @data_len: Length of plaintext in bytes (and ciphertext excluding the tag):
+ *	      at most 2^36 - 32
+ * @authtag: The stored authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_gcm_preparekey().  Usually protocols using AES-GCM
+ *	     put the tag at the end of the ciphertext, in which case this should
+ *	     be set to @src + @data_len and @src must have room for the tag.
+ * @ad: The associated data
+ * @ad_len: Length of associated data in bytes: at most 2^61 - 1
+ * @nonce: The 12-byte nonce
+ * @key: The key, already prepared using aes_gcm_preparekey()
+ *
+ * For AES-GMAC (i.e., AES-GCM without any data en/decrypted), use dst=NULL,
+ * src=NULL, and data_len=0 to verify the AES-GMAC value.
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success.  This is the only case where any decrypted or associated data
+ *   can be used.
+ * * -EBADMSG if the message is inauthentic
+ */
+int __must_check aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len,
+				 const u8 *authtag, const u8 *ad, size_t ad_len,
+				 const u8 nonce[at_least 12],
+				 const struct aes_gcm_key *key);
+
+/**
+ * aes_gcm_init() - Initialize context for incremental AES-GCM encryption or
+ *		    decryption, or for AES-GMAC computation
+ * @ctx: The context to initialize
+ * @nonce: The 12-byte nonce.  All (key, nonce) pairs used for encryption or MAC
+ *	   generation MUST be distinct.
+ * @key: The key, already prepared using aes_gcm_preparekey().  Note that a
+ *	 pointer to the key is saved in the context, so the key must live at
+ *	 least as long as the context.
+ *
+ * The context should be zeroized at the end of its lifetime.  Normally that
+ * happens in aes_gcm_encrypt_final() or aes_gcm_decrypt_final(), but callers
+ * that abandon a context without finalizing it should explicitly zeroize it.
+ *
+ * IMPORTANT: Callers that are decrypting data or computing a GMAC value for
+ * verification MUST NOT assume that any decrypted or associated data is
+ * authentic until the authentication tag has been verified.  This incremental
+ * API is provided solely to support callers that can't efficiently use the
+ * one-shot functions due to using a nonlinear data layout.
+ *
+ * For incremental AES-GCM encryption, use:
+ *
+ * 1. aes_gcm_init()
+ * 2. aes_gcm_auth_update() (any number of times)
+ * 3. aes_gcm_encrypt_update() (any number of times)
+ * 4. aes_gcm_encrypt_final()
+ *
+ * For incremental AES-GCM decryption, use:
+ *
+ * 1. aes_gcm_init()
+ * 2. aes_gcm_auth_update() (any number of times)
+ * 3. aes_gcm_decrypt_update() (any number of times)
+ * 4. aes_gcm_decrypt_final()
+ *
+ * AES-GMAC is just AES-GCM with zero bytes en/decrypted.  For incremental
+ * AES-GMAC computation, use:
+ *
+ * 1. aes_gcm_init()
+ * 2. aes_gcm_auth_update() (any number of times)
+ * 3. aes_gcm_encrypt_final() to return the computed tag to the caller, or
+ *    aes_gcm_decrypt_final() to directly verify the computed tag
+ *
+ * Context: Any context.
+ */
+void aes_gcm_init(struct aes_gcm_ctx *ctx, const u8 nonce[at_least 12],
+		  const struct aes_gcm_key *key);
+
+/**
+ * aes_gcm_auth_update() - Incrementally process AES-GCM associated data
+ * @ctx: An AES-GCM context
+ * @ad: The associated data
+ * @len: Number of bytes provided.  The caller must ensure that the total
+ *	 associated data length doesn't exceed GCM's limit of 2^61 - 1.
+ *
+ * IMPORTANT: Callers MUST NOT assume that any decrypted or associated data is
+ * authentic until the authentication tag has been verified.
+ *
+ * Context: Any context.
+ */
+void aes_gcm_auth_update(struct aes_gcm_ctx *ctx, const u8 *ad, size_t len);
+
+/**
+ * aes_gcm_encrypt_update() - Incrementally encrypt data with AES-GCM
+ * @ctx: An AES-GCM context
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source plaintext data
+ * @len: Number of bytes to encrypt.  The caller must ensure that the total
+ *	 number of bytes encrypted doesn't exceed GCM's limit of 2^36 - 32.
+ *
+ * This can be called only after all associated data has been processed.
+ *
+ * Context: Any context.
+ */
+void aes_gcm_encrypt_update(struct aes_gcm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len);
+
+/**
+ * aes_gcm_decrypt_update() - Incrementally decrypt data with AES-GCM
+ * @ctx: An AES-GCM context
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source ciphertext data (not including auth tag)
+ * @len: Number of bytes to decrypt.  The caller must ensure that the total
+ *	 number of bytes decrypted doesn't exceed GCM's limit of 2^36 - 32.
+ *
+ * This can be called only after all associated data has been processed.
+ *
+ * IMPORTANT: Callers MUST NOT assume that any decrypted or associated data is
+ * authentic until the authentication tag has been verified.
+ *
+ * Context: Any context.
+ */
+void aes_gcm_decrypt_update(struct aes_gcm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len);
+
+/**
+ * aes_gcm_encrypt_final() - Finish encrypting a message with AES-GCM
+ * @ctx: An AES-GCM context
+ * @authtag: The output authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_gcm_preparekey().
+ *
+ * This also zeroizes @ctx, so the caller doesn't need to do it.
+ *
+ * Context: Any context.
+ */
+void aes_gcm_encrypt_final(struct aes_gcm_ctx *ctx, u8 *authtag);
+
+/**
+ * aes_gcm_decrypt_final() - Finish decrypting a message with AES-GCM
+ * @ctx: An AES-GCM context
+ * @authtag: The stored authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_gcm_preparekey().
+ *
+ * This also zeroizes @ctx, so the caller doesn't need to do it.
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success.  This is the only case where any decrypted or associated data
+ *   can be used.
+ * * -EBADMSG if the message is inauthentic
+ */
+int __must_check aes_gcm_decrypt_final(struct aes_gcm_ctx *ctx,
+				       const u8 *authtag);
+
+#endif /* _CRYPTO_AES_GCM_H */
diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
index 1d5f39ff1dc4..7fd7892ad818 100644
--- a/include/crypto/gcm.h
+++ b/include/crypto/gcm.h
@@ -13,7 +13,7 @@
 /*
  * validate authentication tag for GCM
  */
-static inline int crypto_gcm_check_authsize(unsigned int authsize)
+static inline int crypto_gcm_check_authsize(size_t authsize)
 {
 	switch (authsize) {
 	case 4:
@@ -34,7 +34,7 @@ static inline int crypto_gcm_check_authsize(unsigned int authsize)
 /*
  * validate authentication tag for RFC4106
  */
-static inline int crypto_rfc4106_check_authsize(unsigned int authsize)
+static inline int crypto_rfc4106_check_authsize(size_t authsize)
 {
 	switch (authsize) {
 	case 8:
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 6ec47cc328c8..b48b0b2299a8 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -53,6 +53,14 @@ config CRYPTO_LIB_AES_ECB
 	help
 	  The AES-ECB library functions.
 
+config CRYPTO_LIB_AES_GCM
+	tristate
+	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_AES_CTR
+	select CRYPTO_LIB_GF128HASH
+	help
+	  The AES-GCM library functions.
+
 config CRYPTO_LIB_AES_XTS
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 03c80f4fe176..473c0c16bfa2 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -8,6 +8,7 @@
 #include <crypto/aes-cbc.h>
 #include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
+#include <crypto/aes-gcm.h>
 #include <crypto/aes-xts.h>
 #include <crypto/aes.h>
 #include <crypto/gf128mul.h>
@@ -1307,6 +1308,285 @@ void aes_xts_decrypt(u8 *dst, const u8 *src, size_t len,
 EXPORT_SYMBOL_GPL(aes_xts_decrypt);
 #endif /* CONFIG_CRYPTO_LIB_AES_XTS */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_GCM)
+/*
+ * Hooks for optimized AES-GCM implementations, overridable by the architecture.
+ * They are called with len > 0 && len % AES_BLOCK_SIZE == 0.  I.e. they aren't
+ * expected to handle empty inputs or partial blocks, as those cases are handled
+ * by non-arch-specific code instead.
+ *
+ * The GHASH accumulator is provided in POLYVAL format.  The counter is provided
+ * in big endian format, and it's read-only, as the caller handles updating it.
+ *
+ * Returning false causes the fallback implementation to be used instead.
+ *
+ * These hooks are used only for en/decrypted data.  For the associated data the
+ * GHASH functions are called instead, so those should be implemented too.
+ */
+#ifndef aes_gcm_encrypt_update_arch
+static bool aes_gcm_encrypt_update_arch(u8 *dst, const u8 *src, size_t len,
+					struct polyval_elem *ghash_acc,
+					const __be32 ctr32[4],
+					const struct aes_enckey *aes_key,
+					const struct ghash_key *ghash_key)
+{
+	return false;
+}
+#endif
+#ifndef aes_gcm_decrypt_update_arch
+static bool aes_gcm_decrypt_update_arch(u8 *dst, const u8 *src, size_t len,
+					struct polyval_elem *ghash_acc,
+					const __be32 ctr32[4],
+					const struct aes_enckey *aes_key,
+					const struct ghash_key *ghash_key)
+{
+	return false;
+}
+#endif
+
+int aes_gcm_preparekey(struct aes_gcm_key *key, const u8 *in_key,
+		       size_t key_len, size_t authtag_len)
+{
+	u8 h[AES_BLOCK_SIZE] = { 0 };
+	int err;
+
+	err = crypto_gcm_check_authsize(authtag_len);
+	if (unlikely(err))
+		return err;
+
+	err = aes_prepareenckey(&key->aes, in_key, key_len);
+	if (unlikely(err))
+		return err;
+
+	aes_encrypt(&key->aes, h, h);
+	ghash_preparekey(&key->ghash, h);
+
+	key->authtag_len = authtag_len;
+
+	memzero_explicit(h, sizeof(h));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aes_gcm_preparekey);
+
+void aes_gcm_init(struct aes_gcm_ctx *ctx, const u8 nonce[12],
+		  const struct aes_gcm_key *key)
+{
+	ctx->key = key;
+	ctx->ad_len = 0;
+	ctx->data_len = 0;
+	ghash_init(&ctx->ghash, &key->ghash);
+	memset(ctx->keystream, 0, sizeof(ctx->keystream));
+
+	memcpy(ctx->ctr32, nonce, 12);
+	ctx->ctr32[3] = cpu_to_be32(1);
+
+	aes_encrypt(&key->aes, ctx->j0_enc, ctx->ctr);
+	ctx->ctr32[3] = cpu_to_be32(2);
+}
+EXPORT_SYMBOL_GPL(aes_gcm_init);
+
+void aes_gcm_auth_update(struct aes_gcm_ctx *ctx, const u8 *ad, size_t len)
+{
+	WARN_ON_ONCE(ctx->data_len != 0);
+	if (len) {
+		ghash_update(&ctx->ghash, ad, len);
+		ctx->ad_len += len;
+	}
+}
+EXPORT_SYMBOL_GPL(aes_gcm_auth_update);
+
+static const u8 gcm_zeroes[AES_BLOCK_SIZE];
+
+static __always_inline void ghash_pad(struct ghash_ctx *ghash, u64 len)
+{
+	if (len % AES_BLOCK_SIZE)
+		ghash_update(ghash, gcm_zeroes, -len % AES_BLOCK_SIZE);
+}
+
+static __always_inline void aes_gcm_crypt_update(struct aes_gcm_ctx *ctx,
+						 u8 *dst, const u8 *src,
+						 size_t len, bool enc)
+{
+	size_t partial_len, n;
+
+	if (unlikely(len == 0))
+		return;
+
+	partial_len = ctx->data_len % AES_BLOCK_SIZE;
+	if (ctx->data_len == 0)
+		ghash_pad(&ctx->ghash, ctx->ad_len);
+	ctx->data_len += len;
+
+	if (unlikely(partial_len != 0)) {
+		/*
+		 * The previous call ended on a non-block-aligned data_len, so
+		 * continue using a previously-generated keystream block.
+		 */
+		n = min(len, AES_BLOCK_SIZE - partial_len);
+		if (enc) {
+			crypto_xor_cpy(dst, src, &ctx->keystream[partial_len],
+				       n);
+			ghash_update(&ctx->ghash, dst, n);
+		} else {
+			ghash_update(&ctx->ghash, src, n);
+			crypto_xor_cpy(dst, src, &ctx->keystream[partial_len],
+				       n);
+		}
+		dst += n;
+		src += n;
+		len -= n;
+	}
+
+	if (len >= AES_BLOCK_SIZE) {
+		n = round_down(len, AES_BLOCK_SIZE);
+		if (enc) {
+			if (likely(aes_gcm_encrypt_update_arch(
+				    dst, src, n, &ctx->ghash.acc, ctx->ctr32,
+				    &ctx->key->aes, &ctx->key->ghash))) {
+				be32_add_cpu(&ctx->ctr32[3],
+					     n / AES_BLOCK_SIZE);
+			} else {
+				aes_ctr(dst, src, n, ctx->ctr, &ctx->key->aes);
+				ghash_update(&ctx->ghash, dst, n);
+			}
+		} else {
+			if (likely(aes_gcm_decrypt_update_arch(
+				    dst, src, n, &ctx->ghash.acc, ctx->ctr32,
+				    &ctx->key->aes, &ctx->key->ghash))) {
+				be32_add_cpu(&ctx->ctr32[3],
+					     n / AES_BLOCK_SIZE);
+			} else {
+				ghash_update(&ctx->ghash, src, n);
+				aes_ctr(dst, src, n, ctx->ctr, &ctx->key->aes);
+			}
+		}
+		dst += n;
+		src += n;
+		len -= n;
+	}
+
+	if (len != 0) {
+		/*
+		 * Ending on a non-block aligned data_len.  Generate the next
+		 * keystream block, use the needed portion of it, and leave it
+		 * cached in ctx->keystream in case this isn't the final call.
+		 */
+		aes_encrypt(&ctx->key->aes, ctx->keystream, ctx->ctr);
+		be32_add_cpu(&ctx->ctr32[3], 1);
+		if (enc) {
+			crypto_xor_cpy(dst, src, ctx->keystream, len);
+			ghash_update(&ctx->ghash, dst, len);
+		} else {
+			ghash_update(&ctx->ghash, src, len);
+			crypto_xor_cpy(dst, src, ctx->keystream, len);
+		}
+	}
+}
+
+void aes_gcm_encrypt_update(struct aes_gcm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len)
+{
+	aes_gcm_crypt_update(ctx, dst, src, len, /* enc= */ true);
+}
+EXPORT_SYMBOL_GPL(aes_gcm_encrypt_update);
+
+void aes_gcm_decrypt_update(struct aes_gcm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len)
+{
+	aes_gcm_crypt_update(ctx, dst, src, len, /* enc= */ false);
+}
+EXPORT_SYMBOL_GPL(aes_gcm_decrypt_update);
+
+/* Maximum AES-GCM associated data length in bytes */
+#define AES_GCM_MAX_AD_LEN ((1ULL << 61) - 1)
+/* Maximum AES-GCM en/decrypted data length in bytes */
+#define AES_GCM_MAX_DATA_LEN ((1ULL << 36) - 32)
+
+void aes_gcm_encrypt_final(struct aes_gcm_ctx *ctx, u8 *authtag)
+{
+	__be64 tail[2];
+
+	WARN_ON_ONCE(ctx->ad_len > AES_GCM_MAX_AD_LEN);
+	WARN_ON_ONCE(ctx->data_len > AES_GCM_MAX_DATA_LEN);
+
+	ghash_pad(&ctx->ghash,
+		  ctx->data_len == 0 ? ctx->ad_len : ctx->data_len);
+
+	tail[0] = cpu_to_be64(ctx->ad_len * 8);
+	tail[1] = cpu_to_be64(ctx->data_len * 8);
+	ghash_update(&ctx->ghash, (const u8 *)tail, 16);
+	ghash_final(&ctx->ghash, ctx->ctr); /* Use ctr as temp buffer */
+
+	crypto_xor_cpy(authtag, ctx->ctr, ctx->j0_enc, ctx->key->authtag_len);
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+EXPORT_SYMBOL_GPL(aes_gcm_encrypt_final);
+
+int aes_gcm_decrypt_final(struct aes_gcm_ctx *ctx, const u8 *authtag)
+{
+	__be64 tail[2];
+	int err;
+
+	if (WARN_ON_ONCE(ctx->ad_len > AES_GCM_MAX_AD_LEN) ||
+	    WARN_ON_ONCE(ctx->data_len > AES_GCM_MAX_DATA_LEN)) {
+		err = -EBADMSG;
+		goto out;
+	}
+
+	ghash_pad(&ctx->ghash,
+		  ctx->data_len == 0 ? ctx->ad_len : ctx->data_len);
+
+	tail[0] = cpu_to_be64(ctx->ad_len * 8);
+	tail[1] = cpu_to_be64(ctx->data_len * 8);
+	ghash_update(&ctx->ghash, (const u8 *)tail, 16);
+	ghash_final(&ctx->ghash, ctx->ctr); /* Use ctr as temp buffer */
+	crypto_xor(ctx->ctr, ctx->j0_enc, ctx->key->authtag_len);
+	err = crypto_memneq(ctx->ctr, authtag, ctx->key->authtag_len) ?
+		      -EBADMSG :
+		      0;
+out:
+	memzero_explicit(ctx, sizeof(*ctx));
+	return err;
+}
+EXPORT_SYMBOL_GPL(aes_gcm_decrypt_final);
+
+void aes_gcm_encrypt(u8 *dst, const u8 *src, size_t data_len, u8 *authtag,
+		     const u8 *ad, size_t ad_len, const u8 nonce[12],
+		     const struct aes_gcm_key *key)
+{
+	struct aes_gcm_ctx ctx;
+
+	aes_gcm_init(&ctx, nonce, key);
+	aes_gcm_auth_update(&ctx, ad, ad_len);
+	aes_gcm_encrypt_update(&ctx, dst, src, data_len);
+	aes_gcm_encrypt_final(&ctx, authtag);
+}
+EXPORT_SYMBOL_GPL(aes_gcm_encrypt);
+
+int aes_gcm_decrypt(u8 *dst, const u8 *src, size_t data_len, const u8 *authtag,
+		    const u8 *ad, size_t ad_len, const u8 nonce[12],
+		    const struct aes_gcm_key *key)
+{
+	struct aes_gcm_ctx ctx;
+	int err;
+
+	aes_gcm_init(&ctx, nonce, key);
+	aes_gcm_auth_update(&ctx, ad, ad_len);
+	aes_gcm_decrypt_update(&ctx, dst, src, data_len);
+	err = aes_gcm_decrypt_final(&ctx, authtag);
+	if (unlikely(err) && data_len) {
+		/*
+		 * Clear the inauthentic decrypted data so that callers won't
+		 * receive it even if they fail to correctly handle errors.
+		 */
+		memset(dst, 0, data_len);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(aes_gcm_decrypt);
+
+#endif /* CONFIG_CRYPTO_LIB_AES_GCM */
+
 static int __init aes_mod_init(void)
 {
 #ifdef aes_mod_init_arch
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index b559e7c79e76..51183ffabbef 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -148,6 +148,7 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_AES_CTR
 	select CRYPTO_LIB_AES_ECB
+	select CRYPTO_LIB_AES_GCM
 	select CRYPTO_LIB_AES_XTS
 	select CRYPTO_LIB_BLAKE2B
 	select CRYPTO_LIB_CHACHA20POLY1305
-- 
2.55.0

