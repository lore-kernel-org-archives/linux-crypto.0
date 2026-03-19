Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7781E34676D;
	Thu, 19 Mar 2026 06:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901156; cv=none; b=TSPhux+HXCasv5hTZ58etMv20xXGb0yeJ50pFctYOoozHt8SjUZ2x04jSIZSw3fMMyC6C5DaDZoFytCgMss/LhrvTc0bh3lRSQqfqiqBQ9fqbLmjsWH7n65tELmwxXahzTChKcvvlhNiOTfsjZ6AhgnWb7CESerMGaBu6gO35Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901156; c=relaxed/simple;
	bh=vAFsFueFVZjX8UrC9CKtb1LtlzSIZdgQBkLXwrqPjDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l66nf9OuKoPpVTTca6j6hjftDBXtINPIS0HFZfibDp4rwpGXjo8VLH3N9V2YIcMWvnY2ij6tG66Y3qfpjtg7oYO5eaOT3+ph3smscafFL4jyK1RgxgeuGLzKcvpgEJ4qdxsRdIkRAk7YngObPheE5B3mgfUYctw9C2HQfQg2lpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDxFlaf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDxFlaf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF37DC2BCB1;
	Thu, 19 Mar 2026 06:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901156;
	bh=vAFsFueFVZjX8UrC9CKtb1LtlzSIZdgQBkLXwrqPjDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDxFlaf2E9+JpBiICNMPfdXCbnzZlGDYC4q9HiG1RWXZUJy60eoR5S/7Z2KT20zm7
	 xz43ekPxXVtElzkcASlkj081iP1m4QuoUdnrJ1uhyTKuiiY/lFCqe3zry5n371t+nz
	 DgetuYl9Ut1aKCfwQQVhUGHH/BJZcigsTpzjuLgpetdX72Nne1hJbU0FylVjsQoQME
	 D9LhY4/DHIXUgkFpcNVYFrvhbhZA1o8NrEyzzKufVX9SFpc/nz0NmzVpGx6G574zb5
	 XGy+1PIDsumKRAEEVb/BZs/QXbQMZFBlIOnB94E5UNmGgVFogk3iOpm08ibdsx9ytz
	 uEtdqikcnUIKQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 03/19] lib/crypto: gf128hash: Add GHASH support
Date: Wed, 18 Mar 2026 23:17:04 -0700
Message-ID: <20260319061723.1140720-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add GHASH support to the gf128hash module.

This will replace the GHASH support in the crypto_shash API.  It will be
used by the "gcm" template and by the AES-GCM library (when an
arch-optimized implementation of the full AES-GCM is unavailable).

This consists of a simple API that mirrors the existing POLYVAL API, a
generic implementation of that API based on the existing efficient and
side-channel-resistant polyval_mul_generic(), and the framework for
architecture-optimized implementations of the GHASH functions.

The GHASH accumulator is stored in POLYVAL format rather than GHASH
format, since this is what most modern GHASH implementations actually
need.  The few implementations that expect the accumulator in GHASH
format will just convert the accumulator to/from GHASH format
temporarily.  (Supporting architecture-specific accumulator formats
would be possible, but doesn't seem worth the complexity.)

However, architecture-specific formats of struct ghash_key will be
supported, since a variety of formats will be needed there anyway.  The
default format is just the key in POLYVAL format.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/gf128hash.h |  95 ++++++++++++++++++++++++
 lib/crypto/gf128hash.c     | 145 +++++++++++++++++++++++++++++++++----
 2 files changed, 227 insertions(+), 13 deletions(-)

diff --git a/include/crypto/gf128hash.h b/include/crypto/gf128hash.h
index 1052041e3499..5090fbaa87f8 100644
--- a/include/crypto/gf128hash.h
+++ b/include/crypto/gf128hash.h
@@ -9,10 +9,12 @@
 #define _CRYPTO_GF128HASH_H
 
 #include <linux/string.h>
 #include <linux/types.h>
 
+#define GHASH_BLOCK_SIZE	16
+#define GHASH_DIGEST_SIZE	16
 #define POLYVAL_BLOCK_SIZE	16
 #define POLYVAL_DIGEST_SIZE	16
 
 /**
  * struct polyval_elem - An element of the POLYVAL finite field
@@ -31,10 +33,20 @@ struct polyval_elem {
 			__le64 hi;
 		};
 	};
 };
 
+/**
+ * struct ghash_key - Prepared key for GHASH
+ *
+ * Use ghash_preparekey() to initialize this.
+ */
+struct ghash_key {
+	/** @h: The hash key H, in POLYVAL format */
+	struct polyval_elem h;
+};
+
 /**
  * struct polyval_key - Prepared key for POLYVAL
  *
  * This may contain just the raw key H, or it may contain precomputed key
  * powers, depending on the platform's POLYVAL implementation.  Use
@@ -52,10 +64,24 @@ struct polyval_key {
 	/** @h: The hash key H */
 	struct polyval_elem h;
 #endif
 };
 
+/**
+ * struct ghash_ctx - Context for computing a GHASH value
+ * @key: Pointer to the prepared GHASH key.  The user of the API is
+ *	 responsible for ensuring that the key lives as long as the context.
+ * @acc: The accumulator.  It is stored in POLYVAL format rather than GHASH
+ *	 format, since most implementations want it in POLYVAL format.
+ * @partial: Number of data bytes processed so far modulo GHASH_BLOCK_SIZE
+ */
+struct ghash_ctx {
+	const struct ghash_key *key;
+	struct polyval_elem acc;
+	size_t partial;
+};
+
 /**
  * struct polyval_ctx - Context for computing a POLYVAL value
  * @key: Pointer to the prepared POLYVAL key.  The user of the API is
  *	 responsible for ensuring that the key lives as long as the context.
  * @acc: The accumulator
@@ -65,10 +91,22 @@ struct polyval_ctx {
 	const struct polyval_key *key;
 	struct polyval_elem acc;
 	size_t partial;
 };
 
+/**
+ * ghash_preparekey() - Prepare a GHASH key
+ * @key: (output) The key structure to initialize
+ * @raw_key: The raw hash key
+ *
+ * Initialize a GHASH key structure from a raw key.
+ *
+ * Context: Any context.
+ */
+void ghash_preparekey(struct ghash_key *key,
+		      const u8 raw_key[GHASH_BLOCK_SIZE]);
+
 /**
  * polyval_preparekey() - Prepare a POLYVAL key
  * @key: (output) The key structure to initialize
  * @raw_key: The raw hash key
  *
@@ -79,10 +117,22 @@ struct polyval_ctx {
  * Context: Any context.
  */
 void polyval_preparekey(struct polyval_key *key,
 			const u8 raw_key[POLYVAL_BLOCK_SIZE]);
 
+/**
+ * ghash_init() - Initialize a GHASH context for a new message
+ * @ctx: The context to initialize
+ * @key: The key to use.  Note that a pointer to the key is saved in the
+ *	 context, so the key must live at least as long as the context.
+ */
+static inline void ghash_init(struct ghash_ctx *ctx,
+			      const struct ghash_key *key)
+{
+	*ctx = (struct ghash_ctx){ .key = key };
+}
+
 /**
  * polyval_init() - Initialize a POLYVAL context for a new message
  * @ctx: The context to initialize
  * @key: The key to use.  Note that a pointer to the key is saved in the
  *	 context, so the key must live at least as long as the context.
@@ -123,10 +173,22 @@ static inline void polyval_export_blkaligned(const struct polyval_ctx *ctx,
 					     struct polyval_elem *acc)
 {
 	*acc = ctx->acc;
 }
 
+/**
+ * ghash_update() - Update a GHASH context with message data
+ * @ctx: The context to update; must have been initialized
+ * @data: The message data
+ * @len: The data length in bytes.  Doesn't need to be block-aligned.
+ *
+ * This can be called any number of times.
+ *
+ * Context: Any context.
+ */
+void ghash_update(struct ghash_ctx *ctx, const u8 *data, size_t len);
+
 /**
  * polyval_update() - Update a POLYVAL context with message data
  * @ctx: The context to update; must have been initialized
  * @data: The message data
  * @len: The data length in bytes.  Doesn't need to be block-aligned.
@@ -135,10 +197,24 @@ static inline void polyval_export_blkaligned(const struct polyval_ctx *ctx,
  *
  * Context: Any context.
  */
 void polyval_update(struct polyval_ctx *ctx, const u8 *data, size_t len);
 
+/**
+ * ghash_final() - Finish computing a GHASH value
+ * @ctx: The context to finalize
+ * @out: The output value
+ *
+ * If the total data length isn't a multiple of GHASH_BLOCK_SIZE, then the
+ * final block is automatically zero-padded.
+ *
+ * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
+ *
+ * Context: Any context.
+ */
+void ghash_final(struct ghash_ctx *ctx, u8 out[GHASH_BLOCK_SIZE]);
+
 /**
  * polyval_final() - Finish computing a POLYVAL value
  * @ctx: The context to finalize
  * @out: The output value
  *
@@ -149,10 +225,29 @@ void polyval_update(struct polyval_ctx *ctx, const u8 *data, size_t len);
  *
  * Context: Any context.
  */
 void polyval_final(struct polyval_ctx *ctx, u8 out[POLYVAL_BLOCK_SIZE]);
 
+/**
+ * ghash() - Compute a GHASH value
+ * @key: The prepared key
+ * @data: The message data
+ * @len: The data length in bytes.  Doesn't need to be block-aligned.
+ * @out: The output value
+ *
+ * Context: Any context.
+ */
+static inline void ghash(const struct ghash_key *key, const u8 *data,
+			 size_t len, u8 out[GHASH_BLOCK_SIZE])
+{
+	struct ghash_ctx ctx;
+
+	ghash_init(&ctx, key);
+	ghash_update(&ctx, data, len);
+	ghash_final(&ctx, out);
+}
+
 /**
  * polyval() - Compute a POLYVAL value
  * @key: The prepared key
  * @data: The message data
  * @len: The data length in bytes.  Doesn't need to be block-aligned.
diff --git a/lib/crypto/gf128hash.c b/lib/crypto/gf128hash.c
index 05f44a9193f7..2650603d8ba8 100644
--- a/lib/crypto/gf128hash.c
+++ b/lib/crypto/gf128hash.c
@@ -10,27 +10,34 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/unaligned.h>
 
 /*
- * POLYVAL is an almost-XOR-universal hash function.  Similar to GHASH, POLYVAL
- * interprets the message as the coefficients of a polynomial in GF(2^128) and
- * evaluates that polynomial at a secret point.  POLYVAL has a simple
- * mathematical relationship with GHASH, but it uses a better field convention
- * which makes it easier and faster to implement.
+ * GHASH and POLYVAL are almost-XOR-universal hash functions.  They interpret
+ * the message as the coefficients of a polynomial in the finite field GF(2^128)
+ * and evaluate that polynomial at a secret point.
  *
- * POLYVAL is not a cryptographic hash function, and it should be used only by
- * algorithms that are specifically designed to use it.
+ * Neither GHASH nor POLYVAL is a cryptographic hash function.  They should be
+ * used only by algorithms that are specifically designed to use them.
  *
- * POLYVAL is specified by "AES-GCM-SIV: Nonce Misuse-Resistant Authenticated
- * Encryption" (https://datatracker.ietf.org/doc/html/rfc8452)
+ * GHASH is the older variant, defined as part of GCM in NIST SP 800-38D
+ * (https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-38d.pdf).
+ * GHASH is hard to implement directly, due to its backwards mapping between
+ * bits and polynomial coefficients.  GHASH implementations typically pre and
+ * post-process the inputs and outputs (mainly by byte-swapping) to convert the
+ * GHASH computation into an equivalent computation over a different,
+ * easier-to-use representation of GF(2^128).
  *
- * POLYVAL is also used by HCTR2.  See "Length-preserving encryption with HCTR2"
- * (https://eprint.iacr.org/2021/1441.pdf).
+ * POLYVAL is a newer GF(2^128) polynomial hash, originally defined as part of
+ * AES-GCM-SIV (https://datatracker.ietf.org/doc/html/rfc8452) and also used by
+ * HCTR2 (https://eprint.iacr.org/2021/1441.pdf).  It uses that easier-to-use
+ * field representation directly, eliminating the data conversion steps.
  *
- * This file provides a library API for POLYVAL.  This API can delegate to
- * either a generic implementation or an architecture-optimized implementation.
+ * This file provides library APIs for GHASH and POLYVAL.  These APIs can
+ * delegate to either a generic implementation or an architecture-optimized
+ * implementation.  Due to the mathematical relationship between GHASH and
+ * POLYVAL, in some cases code for one is reused with the other.
  *
  * For the generic implementation, we don't use the traditional table approach
  * to GF(2^128) multiplication.  That approach is not constant-time and requires
  * a lot of memory.  Instead, we use a different approach which emulates
  * carryless multiplication using standard multiplications by spreading the data
@@ -203,10 +210,23 @@ polyval_mul_generic(struct polyval_elem *a, const struct polyval_elem *b)
 	/* Return (c2, c3).  This implicitly multiplies by x^-128. */
 	a->lo = cpu_to_le64(c2);
 	a->hi = cpu_to_le64(c3);
 }
 
+static void __maybe_unused ghash_blocks_generic(struct polyval_elem *acc,
+						const struct polyval_elem *key,
+						const u8 *data, size_t nblocks)
+{
+	do {
+		acc->lo ^=
+			cpu_to_le64(get_unaligned_be64((__be64 *)(data + 8)));
+		acc->hi ^= cpu_to_le64(get_unaligned_be64((__be64 *)data));
+		polyval_mul_generic(acc, key);
+		data += GHASH_BLOCK_SIZE;
+	} while (--nblocks);
+}
+
 static void __maybe_unused
 polyval_blocks_generic(struct polyval_elem *acc, const struct polyval_elem *key,
 		       const u8 *data, size_t nblocks)
 {
 	do {
@@ -215,14 +235,112 @@ polyval_blocks_generic(struct polyval_elem *acc, const struct polyval_elem *key,
 		polyval_mul_generic(acc, key);
 		data += POLYVAL_BLOCK_SIZE;
 	} while (--nblocks);
 }
 
+/* Convert the key from GHASH format to POLYVAL format. */
+static void __maybe_unused ghash_key_to_polyval(const u8 in[GHASH_BLOCK_SIZE],
+						struct polyval_elem *out)
+{
+	u64 hi = get_unaligned_be64(&in[0]);
+	u64 lo = get_unaligned_be64(&in[8]);
+	u64 mask = (s64)hi >> 63;
+
+	hi = (hi << 1) ^ (lo >> 63) ^ (mask & ((u64)0xc2 << 56));
+	lo = (lo << 1) ^ (mask & 1);
+	out->lo = cpu_to_le64(lo);
+	out->hi = cpu_to_le64(hi);
+}
+
+/* Convert the accumulator from POLYVAL format to GHASH format. */
+static void polyval_acc_to_ghash(const struct polyval_elem *in,
+				 u8 out[GHASH_BLOCK_SIZE])
+{
+	put_unaligned_be64(le64_to_cpu(in->hi), &out[0]);
+	put_unaligned_be64(le64_to_cpu(in->lo), &out[8]);
+}
+
+/* Convert the accumulator from GHASH format to POLYVAL format. */
+static void __maybe_unused ghash_acc_to_polyval(const u8 in[GHASH_BLOCK_SIZE],
+						struct polyval_elem *out)
+{
+	out->lo = cpu_to_le64(get_unaligned_be64(&in[8]));
+	out->hi = cpu_to_le64(get_unaligned_be64(&in[0]));
+}
+
 #ifdef CONFIG_CRYPTO_LIB_GF128HASH_ARCH
 #include "gf128hash.h" /* $(SRCARCH)/gf128hash.h */
 #endif
 
+void ghash_preparekey(struct ghash_key *key, const u8 raw_key[GHASH_BLOCK_SIZE])
+{
+#ifdef ghash_preparekey_arch
+	ghash_preparekey_arch(key, raw_key);
+#else
+	ghash_key_to_polyval(raw_key, &key->h);
+#endif
+}
+EXPORT_SYMBOL_GPL(ghash_preparekey);
+
+static void ghash_mul(struct ghash_ctx *ctx)
+{
+#ifdef ghash_mul_arch
+	ghash_mul_arch(&ctx->acc, ctx->key);
+#elif defined(ghash_blocks_arch)
+	static const u8 zeroes[GHASH_BLOCK_SIZE];
+
+	ghash_blocks_arch(&ctx->acc, ctx->key, zeroes, 1);
+#else
+	polyval_mul_generic(&ctx->acc, &ctx->key->h);
+#endif
+}
+
+/* nblocks is always >= 1. */
+static void ghash_blocks(struct ghash_ctx *ctx, const u8 *data, size_t nblocks)
+{
+#ifdef ghash_blocks_arch
+	ghash_blocks_arch(&ctx->acc, ctx->key, data, nblocks);
+#else
+	ghash_blocks_generic(&ctx->acc, &ctx->key->h, data, nblocks);
+#endif
+}
+
+void ghash_update(struct ghash_ctx *ctx, const u8 *data, size_t len)
+{
+	if (unlikely(ctx->partial)) {
+		size_t n = min(len, GHASH_BLOCK_SIZE - ctx->partial);
+
+		len -= n;
+		while (n--)
+			ctx->acc.bytes[GHASH_BLOCK_SIZE - 1 - ctx->partial++] ^=
+				*data++;
+		if (ctx->partial < GHASH_BLOCK_SIZE)
+			return;
+		ghash_mul(ctx);
+	}
+	if (len >= GHASH_BLOCK_SIZE) {
+		size_t nblocks = len / GHASH_BLOCK_SIZE;
+
+		ghash_blocks(ctx, data, nblocks);
+		data += len & ~(GHASH_BLOCK_SIZE - 1);
+		len &= GHASH_BLOCK_SIZE - 1;
+	}
+	for (size_t i = 0; i < len; i++)
+		ctx->acc.bytes[GHASH_BLOCK_SIZE - 1 - i] ^= data[i];
+	ctx->partial = len;
+}
+EXPORT_SYMBOL_GPL(ghash_update);
+
+void ghash_final(struct ghash_ctx *ctx, u8 out[GHASH_BLOCK_SIZE])
+{
+	if (unlikely(ctx->partial))
+		ghash_mul(ctx);
+	polyval_acc_to_ghash(&ctx->acc, out);
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+EXPORT_SYMBOL_GPL(ghash_final);
+
 void polyval_preparekey(struct polyval_key *key,
 			const u8 raw_key[POLYVAL_BLOCK_SIZE])
 {
 #ifdef polyval_preparekey_arch
 	polyval_preparekey_arch(key, raw_key);
@@ -251,10 +369,11 @@ static void polyval_mul(struct polyval_ctx *ctx)
 #else
 	polyval_mul_generic(&ctx->acc, &ctx->key->h);
 #endif
 }
 
+/* nblocks is always >= 1. */
 static void polyval_blocks(struct polyval_ctx *ctx,
 			   const u8 *data, size_t nblocks)
 {
 #ifdef polyval_blocks_arch
 	polyval_blocks_arch(&ctx->acc, ctx->key, data, nblocks);
-- 
2.53.0

