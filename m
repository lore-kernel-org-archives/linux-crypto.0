Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A72438655C;
	Tue,  7 Jul 2026 05:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402641; cv=none; b=mZqanTo36WV5pVJnwqVJT8p7KUv1mVcxOnYTO218FsZb25XDNwNUKPREBjnAkr/4xytEvwwGEBLK9ftxk09UR+HTHq1nipuwr10/plMCMyV9gNbGzLdp779t0wa0gPzmWLTpnOVJipv6wEyD30Bg6PgNJ5s81jihCj14785wW5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402641; c=relaxed/simple;
	bh=8FPTAhCH9BVy8VfsLxLrsRaPyFtm1+jA8dUHm3WW4O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUYBPoYyi7CYnB4DG+uOvtcIN5rWOJHwBJ0i3fGClJufFtYVsI2Sj+LREG0VgVIlLeekHlaisj+vywVNLcB2NRvtOe/awBqGTbioRcyuaa8prOts0FLVrpRCUdnEjD1Sx55Qc906cHiLOHY8WtlYhl1bjMDC559pwe526+KgV8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxvSc79M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxvSc79M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C4C1F00A3F;
	Tue,  7 Jul 2026 05:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402638;
	bh=UODIKJddzBZE+EoXv8DKhQ8eAdDFv1bI5onErhyoFtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxvSc79MpClY2GAzvX+RR9b8uoneAfrsqMHPsc5h70EDCNKV2ie1bPnUu1SL68qBu
	 fCeQsIszWkWSvtijADUuzVit6DosiM0oKcvW9DptBACnzrr4tZbMWM3E1n/whZC8Ru
	 rOGHKkdSwDS31N366ohD/p+vzjkGMI4+t1ixC5SbbJ9sdqbjN41xoKKR4sd/uR1Q8h
	 rZrd8yplhETlN5UU+TrlL57bTz6kKKEuzFOv6J4O0AnfyMs7OA5h+DWus8qn1GuwhX
	 HA35tXGlPLFJKNMAaZmz1gSGrnTG53NWaSrlcD1eobWbAuuQxFnlgDpTnpScR/aZEX
	 Ilr1EF1mduaXg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 07/33] lib/crypto: aes: Add CCM support
Date: Mon,  6 Jul 2026 22:34:37 -0700
Message-ID: <20260707053503.209874-8-ebiggers@kernel.org>
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

Add support for AES-CCM to the crypto library.

This will be used to provide a streamlined implementation of the
"ccm(aes)" crypto_aead algorithm.  Most users of "ccm(aes)" will also be
able to switch to the library, which as usual will be faster and
simpler, e.g.:

   - fs/smb/client/
   - fs/smb/server/
   - net/mac80211/
   - net/mac802154/

(I've already written proof-of-concept patches for all the above, and
they helped inform the API design.)

As in the AES-GCM API, incremental operation is supported.  It has to be
used carefully, especially when decrypting, but it makes the API general
enough to work well for all users.

The AES-CCM library code calls aes_cbcmac_blocks() directly, bypassing
the higher-level aes_cbcmac_init(), aes_cbcmac_update(), and
aes_cbcmac_final().  The latter set of functions is useful only for
AES-CCM, so they don't make sense to keep around and will be removed
once the "ccm(aes)" crypto_aead starts using the AES-CCM library.

Initial test coverage is provided by the crypto_aead support added in a
later commit.  I'm planning a KUnit test suite as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 .../crypto/libcrypto-auth-encryption.rst      |   7 +
 include/crypto/aes-ccm.h                      | 244 +++++++++++++++
 lib/crypto/Kconfig                            |   8 +
 lib/crypto/aes.c                              | 287 ++++++++++++++++++
 lib/crypto/tests/Kconfig                      |   1 +
 5 files changed, 547 insertions(+)
 create mode 100644 include/crypto/aes-ccm.h

diff --git a/Documentation/crypto/libcrypto-auth-encryption.rst b/Documentation/crypto/libcrypto-auth-encryption.rst
index 17412b7bd7bb..f3fa5b5305eb 100644
--- a/Documentation/crypto/libcrypto-auth-encryption.rst
+++ b/Documentation/crypto/libcrypto-auth-encryption.rst
@@ -5,6 +5,13 @@ Authenticated encryption
 
 Support for authenticated encryption and decryption.
 
+AES-CCM
+-------
+
+Support for AES in the CCM mode of operation.
+
+.. kernel-doc:: include/crypto/aes-ccm.h
+
 AES-GCM
 -------
 
diff --git a/include/crypto/aes-ccm.h b/include/crypto/aes-ccm.h
new file mode 100644
index 000000000000..9c179944a2ed
--- /dev/null
+++ b/include/crypto/aes-ccm.h
@@ -0,0 +1,244 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * AES-CCM authenticated encryption and decryption
+ *
+ * Copyright 2026 Google LLC
+ */
+#ifndef _CRYPTO_AES_CCM_H
+#define _CRYPTO_AES_CCM_H
+
+#include <crypto/aes.h>
+
+/**
+ * struct aes_ccm_key - Prepared key for AES-CCM
+ */
+struct aes_ccm_key {
+	/* private: */
+	struct aes_enckey aes;
+	size_t authtag_len; /* Length of authentication tags in bytes */
+};
+
+/**
+ * struct aes_ccm_ctx - Context for incrementally en/decrypting a message
+ */
+struct aes_ccm_ctx {
+	/* private: */
+	/*
+	 * Pointer to the key, which is assumed to live at least as long as this
+	 * struct.
+	 */
+	const struct aes_ccm_key *key;
+	/*
+	 * The current CBC-MAC chaining value.  When not on a block boundary,
+	 * the partial block has been XOR'ed into this.  The number of partial
+	 * bytes is 'partial_len'.
+	 */
+	u8 mac[AES_BLOCK_SIZE] __aligned(__alignof__(__be64));
+	/* The current counter, a 128-bit big endian value */
+	u8 ctr[AES_BLOCK_SIZE] __aligned(__alignof__(__be64));
+	/* Buffered keystream for partial block updates */
+	u8 keystream[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+	/* Encrypted counter of 0.  This gets XOR'ed with the tag at the end */
+	u8 s0[AES_BLOCK_SIZE] __aligned(__alignof__(long));
+	/* Current partial block length, 0 <= partial_len < AES_BLOCK_SIZE */
+	u32 partial_len;
+	/* True if associated data padding has been done */
+	bool ad_padded;
+	/* Number of associated data bytes remaining to be provided */
+	s64 ad_remaining;
+	/* Number of en/decrypted data bytes remaining to be provided */
+	s64 data_remaining;
+};
+
+/**
+ * aes_ccm_preparekey() - Prepare an AES-CCM key
+ * @key: (output) The key structure to initialize
+ * @in_key: The raw AES-CCM key
+ * @key_len: Length of the raw key in bytes: 16, 24, or 32
+ * @authtag_len: Length of the authentication tag in bytes:
+ *		 4, 6, 8, 10, 12, 14, or 16 (16 is recommended)
+ *
+ * Users should use memzero_explicit() to zeroize the key at the end of its
+ * lifetime.  (But if this function fails, zeroization is unnecessary.)
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success
+ * * -EINVAL if either of the lengths is invalid
+ */
+int __must_check aes_ccm_preparekey(struct aes_ccm_key *key, const u8 *in_key,
+				    size_t key_len, size_t authtag_len);
+
+/**
+ * aes_ccm_encrypt() - Encrypt a message with AES-CCM
+ * @dst: The destination ciphertext data.  Can be in-place or out-of-place.
+ *	 For other overlaps the behavior is unspecified.
+ * @authtag: The output authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_ccm_preparekey().  Usually protocols using AES-CCM
+ *	     put the tag at the end of the ciphertext, in which case this should
+ *	     be set to @dst + @data_len and @dst must have room for the tag.
+ * @src: The source plaintext data
+ * @data_len: Length of plaintext in bytes (and ciphertext excluding the tag)
+ * @ad: The associated data
+ * @ad_len: Length of associated data in bytes
+ * @nonce: The nonce
+ * @nonce_len: Length of the nonce in bytes: between 7 and 13 inclusive
+ * @key: The key
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success
+ * * -EINVAL if nonce_len is invalid
+ * * -EOVERFLOW if data_len is too large for the selected nonce_len
+ *   or if ad_len exceeds U32_MAX
+ */
+int __must_check aes_ccm_encrypt(u8 *dst, u8 *authtag, const u8 *src,
+				 size_t data_len, const u8 *ad, size_t ad_len,
+				 const u8 *nonce, size_t nonce_len,
+				 const struct aes_ccm_key *key);
+
+/**
+ * aes_ccm_decrypt() - Decrypt a message with AES-CCM
+ * @dst: The destination plaintext data.  Can be in-place or out-of-place.
+ *	 For other overlaps the behavior is unspecified.
+ * @src: The source ciphertext data
+ * @authtag: The stored authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_ccm_preparekey().  Usually protocols using AES-CCM
+ *	     put the tag at the end of the ciphertext, in which case this should
+ *	     be set to @src + @data_len and @src must have room for the tag.
+ * @data_len: Length of plaintext in bytes (and ciphertext excluding the tag)
+ * @ad: The associated data
+ * @ad_len: Length of associated data in bytes
+ * @nonce: The nonce
+ * @nonce_len: Length of the nonce in bytes: between 7 and 13 inclusive
+ * @key: The key
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success.  This is the only case where any decrypted data can be used.
+ * * -EBADMSG if the message is inauthentic
+ * * -EINVAL if nonce_len is invalid
+ * * -EOVERFLOW if data_len is too large for the selected nonce_len
+ *   or if ad_len exceeds U32_MAX
+ */
+int __must_check aes_ccm_decrypt(u8 *dst, const u8 *src, const u8 *authtag,
+				 size_t data_len, const u8 *ad, size_t ad_len,
+				 const u8 *nonce, size_t nonce_len,
+				 const struct aes_ccm_key *key);
+
+/**
+ * aes_ccm_init() - Initialize context for incremental AES-CCM encryption or
+ *		    decryption
+ * @ctx: The context to initialize
+ * @nonce: The nonce
+ * @nonce_len: Length of the nonce in bytes: between 7 and 13 inclusive
+ * @ad_len: Length of the associated data that will be provided in bytes
+ * @data_len: Length of the plaintext that will be provided in bytes
+ * @key: The key.  Note that a pointer to the key is saved in the context, so
+ *	 the key must live at least as long as the context.
+ *
+ * Unlike AES-GCM, AES-CCM requires the total lengths of the associated data and
+ * plaintext to be known during initialization.  Callers MUST ensure that these
+ * lengths are correct.
+ *
+ * IMPORTANT: Callers that are decrypting MUST NOT assume that any decrypted or
+ * associated data is authentic until the authentication tag has been verified.
+ * This incremental API is provided solely to support callers that can't
+ * efficiently use the one-shot functions due to using a nonlinear data layout.
+ *
+ * For incremental AES-CCM encryption, use:
+ *
+ * 1. aes_ccm_init()
+ * 2. aes_ccm_auth_update() (any number of times)
+ * 3. aes_ccm_encrypt_update() (any number of times)
+ * 4. aes_ccm_encrypt_final()
+ *
+ * For incremental AES-CCM decryption, use:
+ *
+ * 1. aes_ccm_init()
+ * 2. aes_ccm_auth_update() (any number of times)
+ * 3. aes_ccm_decrypt_update() (any number of times)
+ * 4. aes_ccm_decrypt_final()
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success
+ * * -EINVAL if nonce_len is invalid
+ * * -EOVERFLOW if data_len is too large for the selected nonce_len
+ *   or if ad_len exceeds U32_MAX
+ */
+int __must_check aes_ccm_init(struct aes_ccm_ctx *ctx, const u8 *nonce,
+			      size_t nonce_len, u64 ad_len, u64 data_len,
+			      const struct aes_ccm_key *key);
+
+/**
+ * aes_ccm_auth_update() - Incrementally update AES-CCM associated data
+ * @ctx: An AES-CCM context
+ * @ad: The associated data
+ * @len: Length of the associated data in bytes
+ *
+ * IMPORTANT: Callers MUST NOT assume that any decrypted or associated data is
+ * authentic until the authentication tag has been verified.
+ *
+ * Context: Any context.
+ */
+void aes_ccm_auth_update(struct aes_ccm_ctx *ctx, const u8 *ad, size_t len);
+
+/**
+ * aes_ccm_encrypt_update() - Incrementally encrypt data with AES-CCM
+ * @ctx: An AES-CCM context
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source plaintext data
+ * @len: Number of bytes to encrypt
+ *
+ * Context: Any context.
+ */
+void aes_ccm_encrypt_update(struct aes_ccm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len);
+
+/**
+ * aes_ccm_decrypt_update() - Incrementally decrypt data with AES-CCM
+ * @ctx: An AES-CCM context
+ * @dst: The destination buffer.  Can be in-place or out-of-place.  For other
+ *	 overlaps the behavior is unspecified.
+ * @src: The source ciphertext data (not including auth tag)
+ * @len: Number of bytes to decrypt
+ *
+ * IMPORTANT: Callers MUST NOT assume that any decrypted or associated data is
+ * authentic until the authentication tag has been verified.
+ *
+ * Context: Any context.
+ */
+void aes_ccm_decrypt_update(struct aes_ccm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len);
+
+/**
+ * aes_ccm_encrypt_final() - Finish encrypting a message with AES-CCM
+ * @ctx: An AES-CCM context
+ * @authtag: The output authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_ccm_preparekey().
+ *
+ * This also zeroizes @ctx, so the caller doesn't need to do it.
+ *
+ * Context: Any context.
+ */
+void aes_ccm_encrypt_final(struct aes_ccm_ctx *ctx, u8 *authtag);
+
+/**
+ * aes_ccm_decrypt_final() - Finish decrypting a message with AES-CCM
+ * @ctx: An AES-CCM context
+ * @authtag: The stored authentication tag.  Length is the authtag_len that was
+ *	     passed to aes_ccm_preparekey().
+ *
+ * This also zeroizes @ctx, so the caller doesn't need to do it.
+ *
+ * Context: Any context.
+ * Return:
+ * * 0 on success.  This is the only case where any decrypted data can be used.
+ * * -EBADMSG if the message is inauthentic
+ */
+int __must_check aes_ccm_decrypt_final(struct aes_ccm_ctx *ctx,
+				       const u8 *authtag);
+
+#endif /* _CRYPTO_AES_CCM_H */
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 5d313c78b9fa..4066427017bc 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -47,6 +47,14 @@ config CRYPTO_LIB_AES_ECB
 	help
 	  The AES-ECB library functions.
 
+config CRYPTO_LIB_AES_CCM
+	tristate
+	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_CTR
+	help
+	  The AES-CCM library functions.
+
 config CRYPTO_LIB_AES_CTR
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 50f82437a5d8..1a1b32e41ac1 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -6,6 +6,7 @@
 
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/aes-cbc.h>
+#include <crypto/aes-ccm.h>
 #include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes-gcm.h>
@@ -1553,6 +1554,292 @@ EXPORT_SYMBOL_GPL(aes_gcm_decrypt);
 
 #endif /* CONFIG_CRYPTO_LIB_AES_GCM */
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_CCM)
+int aes_ccm_preparekey(struct aes_ccm_key *key, const u8 *in_key,
+		       size_t key_len, size_t authtag_len)
+{
+	int err;
+
+	if (authtag_len < 4 || authtag_len > 16 || authtag_len % 2)
+		return -EINVAL;
+
+	err = aes_prepareenckey(&key->aes, in_key, key_len);
+	if (err)
+		return err;
+
+	key->authtag_len = authtag_len;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aes_ccm_preparekey);
+
+int aes_ccm_init(struct aes_ccm_ctx *ctx, const u8 *nonce, size_t nonce_len,
+		 u64 ad_len, u64 data_len, const struct aes_ccm_key *key)
+{
+	/*
+	 * This is the value L defined in the CCM specification.  It determines
+	 * the maximum allowed message length, and it is itself determined by
+	 * the nonce length.  They are inversely related, i.e. the longer the
+	 * nonce the smaller the maximum message length is.
+	 */
+	unsigned int l = 15 - nonce_len;
+
+	if (unlikely(nonce_len < 7 || nonce_len > 13))
+		return -EINVAL;
+	/* Thus 2 <= l <= 8. */
+
+	if (unlikely(l < 8 && data_len >= (1ULL << (8 * l))))
+		return -EOVERFLOW;
+
+	if (unlikely(ad_len > U32_MAX))
+		return -EOVERFLOW;
+
+	ctx->key = key;
+	ctx->ad_remaining = ad_len;
+	ctx->data_remaining = data_len;
+	ctx->ad_padded = false;
+
+	/*
+	 * Initialize the zero-th counter block to:
+	 *
+	 *	L - 1 || nonce || 0
+	 *
+	 * ... and the zero-th CBC-MAC block to:
+	 *
+	 *	Flags || nonce || data_len
+	 */
+	*(__be64 *)&ctx->ctr[8] = 0;
+	*(__be64 *)&ctx->mac[8] = cpu_to_be64(data_len);
+	ctx->ctr[0] = l - 1;
+	ctx->mac[0] = (ad_len ? 0x40 : 0) |
+		      (((key->authtag_len - 2) / 2) << 3) | (l - 1);
+	memcpy(&ctx->ctr[1], nonce, nonce_len); /* Overlapping store */
+	memcpy(&ctx->mac[1], nonce, nonce_len); /* Overlapping store */
+
+	/*
+	 * Generate S_0 by encrypting the counter (this is used to encrypt the
+	 * auth tag later), and encrypt the zero-th CBC-MAC block.
+	 */
+	aes_encrypt(&key->aes, ctx->s0, ctx->ctr);
+	aes_encrypt(&key->aes, ctx->mac, ctx->mac);
+
+	/* Increment the counter from 0 to 1. */
+	ctx->ctr[15] = 1;
+
+	if (ad_len) {
+		/*
+		 * Update CBC-MAC with the associated data length, represented
+		 * using either 2 or 6 bytes depending on the length.
+		 */
+		if (likely(ad_len < 0xff00)) {
+			*(__be16 *)&ctx->mac[0] ^= cpu_to_be16(ad_len);
+			ctx->partial_len = 2;
+		} else {
+			*(__be16 *)&ctx->mac[0] ^= cpu_to_be16(0xfffe);
+			*(__be32 *)&ctx->mac[2] ^= cpu_to_be32(ad_len);
+			ctx->partial_len = 6;
+		}
+	} else {
+		ctx->partial_len = 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aes_ccm_init);
+
+void aes_ccm_auth_update(struct aes_ccm_ctx *ctx, const u8 *ad, size_t len)
+{
+	size_t partial_len = ctx->partial_len;
+	bool enc_before = false;
+	size_t nblocks;
+
+	ctx->ad_remaining -= len;
+
+	if (partial_len) {
+		size_t n = min(len, AES_BLOCK_SIZE - partial_len);
+
+		crypto_xor(&ctx->mac[partial_len], ad, n);
+		ad += n;
+		len -= n;
+		partial_len += n;
+		if (partial_len < AES_BLOCK_SIZE) {
+			ctx->partial_len = partial_len;
+			return;
+		}
+		enc_before = true;
+	}
+
+	nblocks = len / AES_BLOCK_SIZE;
+	len %= AES_BLOCK_SIZE;
+	if (nblocks == 0) {
+		if (enc_before)
+			aes_encrypt(&ctx->key->aes, ctx->mac, ctx->mac);
+	} else {
+		aes_cbcmac_blocks(ctx->mac, &ctx->key->aes, ad, nblocks,
+				  enc_before, /* enc_after= */ true);
+		ad += nblocks * AES_BLOCK_SIZE;
+	}
+	crypto_xor(ctx->mac, ad, len);
+	ctx->partial_len = len;
+}
+EXPORT_SYMBOL_GPL(aes_ccm_auth_update);
+
+static __always_inline void aes_ccm_crypt_update(struct aes_ccm_ctx *ctx,
+						 u8 *dst, const u8 *src,
+						 size_t len, bool enc)
+{
+	size_t partial_len = ctx->partial_len;
+	size_t n;
+
+	if (unlikely(len == 0))
+		return;
+
+	WARN_ON_ONCE(ctx->ad_remaining != 0);
+	ctx->data_remaining -= len;
+
+	if (!ctx->ad_padded) {
+		ctx->ad_padded = true;
+		if (partial_len)
+			aes_encrypt(&ctx->key->aes, ctx->mac, ctx->mac);
+	} else if (partial_len) {
+		/*
+		 * The previous call ended on a non-block-aligned data_len, so
+		 * continue using a previously-generated keystream block.
+		 */
+		n = min(len, AES_BLOCK_SIZE - partial_len);
+		if (enc)
+			crypto_xor(&ctx->mac[partial_len], src, n);
+		crypto_xor_cpy(dst, src, &ctx->keystream[partial_len], n);
+		if (!enc)
+			crypto_xor(&ctx->mac[partial_len], dst, n);
+		dst += n;
+		src += n;
+		len -= n;
+		partial_len += n;
+		if (partial_len < AES_BLOCK_SIZE) {
+			ctx->partial_len = partial_len;
+			return;
+		}
+		aes_encrypt(&ctx->key->aes, ctx->mac, ctx->mac);
+	}
+
+	if (len >= AES_BLOCK_SIZE) {
+		n = round_down(len, AES_BLOCK_SIZE);
+		if (enc)
+			aes_cbcmac_blocks(ctx->mac, &ctx->key->aes, src,
+					  len / AES_BLOCK_SIZE,
+					  /* enc_before= */ false,
+					  /* enc_after= */ true);
+		aes_ctr(dst, src, n, ctx->ctr, &ctx->key->aes);
+		if (!enc)
+			aes_cbcmac_blocks(ctx->mac, &ctx->key->aes, dst,
+					  len / AES_BLOCK_SIZE,
+					  /* enc_before= */ false,
+					  /* enc_after= */ true);
+		dst += n;
+		src += n;
+		len -= n;
+	}
+
+	if (len) {
+		/*
+		 * Ending on a non-block aligned data_len.  Generate the next
+		 * keystream block, use the needed portion of it, and leave it
+		 * cached in ctx->keystream in case this isn't the final call.
+		 */
+		aes_encrypt(&ctx->key->aes, ctx->keystream, ctx->ctr);
+		inc_be128_ctr(ctx->ctr);
+		if (enc)
+			crypto_xor(ctx->mac, src, len);
+		crypto_xor_cpy(dst, src, ctx->keystream, len);
+		if (!enc)
+			crypto_xor(ctx->mac, dst, len);
+	}
+	ctx->partial_len = len;
+}
+
+void aes_ccm_encrypt_update(struct aes_ccm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len)
+{
+	aes_ccm_crypt_update(ctx, dst, src, len, /* enc= */ true);
+}
+EXPORT_SYMBOL_GPL(aes_ccm_encrypt_update);
+
+void aes_ccm_decrypt_update(struct aes_ccm_ctx *ctx, u8 *dst, const u8 *src,
+			    size_t len)
+{
+	aes_ccm_crypt_update(ctx, dst, src, len, /* enc= */ false);
+}
+EXPORT_SYMBOL_GPL(aes_ccm_decrypt_update);
+
+void aes_ccm_encrypt_final(struct aes_ccm_ctx *ctx, u8 *authtag)
+{
+	WARN_ON_ONCE(ctx->ad_remaining != 0);
+	WARN_ON_ONCE(ctx->data_remaining != 0);
+	if (ctx->partial_len)
+		aes_encrypt(&ctx->key->aes, ctx->mac, ctx->mac);
+	crypto_xor_cpy(authtag, ctx->mac, ctx->s0, ctx->key->authtag_len);
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+EXPORT_SYMBOL_GPL(aes_ccm_encrypt_final);
+
+int aes_ccm_decrypt_final(struct aes_ccm_ctx *ctx, const u8 *authtag)
+{
+	int err;
+
+	WARN_ON_ONCE(ctx->ad_remaining != 0);
+	WARN_ON_ONCE(ctx->data_remaining != 0);
+	if (ctx->partial_len)
+		aes_encrypt(&ctx->key->aes, ctx->mac, ctx->mac);
+	crypto_xor(ctx->mac, ctx->s0, ctx->key->authtag_len);
+	err = crypto_memneq(ctx->mac, authtag, ctx->key->authtag_len) ?
+		      -EBADMSG :
+		      0;
+	memzero_explicit(ctx, sizeof(*ctx));
+	return err;
+}
+EXPORT_SYMBOL_GPL(aes_ccm_decrypt_final);
+
+int aes_ccm_encrypt(u8 *dst, u8 *authtag, const u8 *src, size_t data_len,
+		    const u8 *ad, size_t ad_len, const u8 *nonce,
+		    size_t nonce_len, const struct aes_ccm_key *key)
+{
+	struct aes_ccm_ctx ctx;
+	int err;
+
+	err = aes_ccm_init(&ctx, nonce, nonce_len, ad_len, data_len, key);
+	if (unlikely(err))
+		return err;
+	aes_ccm_auth_update(&ctx, ad, ad_len);
+	aes_ccm_encrypt_update(&ctx, dst, src, data_len);
+	aes_ccm_encrypt_final(&ctx, authtag);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aes_ccm_encrypt);
+
+int aes_ccm_decrypt(u8 *dst, const u8 *src, const u8 *authtag, size_t data_len,
+		    const u8 *ad, size_t ad_len, const u8 *nonce,
+		    size_t nonce_len, const struct aes_ccm_key *key)
+{
+	struct aes_ccm_ctx ctx;
+	int err;
+
+	err = aes_ccm_init(&ctx, nonce, nonce_len, ad_len, data_len, key);
+	if (unlikely(err))
+		return err;
+	aes_ccm_auth_update(&ctx, ad, ad_len);
+	aes_ccm_decrypt_update(&ctx, dst, src, data_len);
+	err = aes_ccm_decrypt_final(&ctx, authtag);
+	if (unlikely(err)) {
+		/*
+		 * Clear the inauthentic decrypted data so that callers won't
+		 * receive it even if they fail to correctly handle errors.
+		 */
+		memset(dst, 0, data_len);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(aes_ccm_decrypt);
+#endif /* CONFIG_CRYPTO_LIB_AES_CCM */
+
 static int __init aes_mod_init(void)
 {
 #ifdef aes_mod_init_arch
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 51183ffabbef..bc084dde424f 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -146,6 +146,7 @@ config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
 	depends on KUNIT
 	select CRYPTO_LIB_AES_CBC
 	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_AES_CCM
 	select CRYPTO_LIB_AES_CTR
 	select CRYPTO_LIB_AES_ECB
 	select CRYPTO_LIB_AES_GCM
-- 
2.54.0

