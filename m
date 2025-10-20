Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BC7220F5E;
	Mon, 20 Oct 2025 00:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921616; cv=none; b=mUyXs54uP3YZKD/OmC561AxAlLCT02q0Ar01+cEvFuBgyJs8hWV3m9Upib+JM+X0Y4D/QAmnd26TymLo3pCQfvQcqYG6gqBpFwzqjrF4UlEhdXwXqTEkX7qNT4HtJO88MJ6h5eluc80f/PZoYBJ1/9130xW3677FyXxqqbgrXAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921616; c=relaxed/simple;
	bh=RVyv+yeclwxuXntAMdmLEYWORjMLZXN8g4rEQIwL7y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/opUyFYLN0nduB819OJmdZNP04t9nBQKaxZNryQZ0BYkB7OPufY76nDMKkcGVH6WPQYb8PoaadklX4NZwTVCD3BuSPg8lesnPBcbQDCCDciNDo74Idm07pjK25QtJqYsd1Mmr2kLobSFfNadvWXAtueMOqhviCAeCc/03EPIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAbeiMxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAbeiMxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F39C16AAE;
	Mon, 20 Oct 2025 00:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921616;
	bh=RVyv+yeclwxuXntAMdmLEYWORjMLZXN8g4rEQIwL7y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAbeiMxm4V2sqtKRFzIVUZQCNjBUiIrPm2eDvrASABAU/GtItYLxCgObge73LrlVi
	 wpTxgWSju/yMJB+MS6zB2qR3tn3zZdIn1d9xfWv0v5kkWqTZ3eEgYk6S/KHxPMB20/
	 RPh6jaSIGQiEtPDdRcjsRAGJszM13mSq7eofmJbUQJSE+wBxUdsz/AA31sOF4qu2xp
	 DjzxhT8KhNi4Ywg1rEJ//xg/v4RRxpIeW0wt9NsvII9Sh/zZK3hntwg96aeGivaj/v
	 idmdwWWuIlbqb6Nrc3/W/lgt25IuePiMtEfH9suBEZElvuQBwF0ihyAur40mv6m4pP
	 62QZU2DD22T7g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/17] lib/crypto: sha3: Simplify the API
Date: Sun, 19 Oct 2025 17:50:32 -0700
Message-ID: <20251020005038.661542-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251020005038.661542-1-ebiggers@kernel.org>
References: <20251020005038.661542-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of having separate types and functions for each of the six SHA-3
algorithms, instead divide them into two groups: the digests and the
XOFs.  The digests use sha3_ctx and the XOFs use shake_ctx.  The
internal context is now called __sha3_ctx.

The result is a simpler, smaller API that is more convenient for users
that need to support multiple SHA-3 variants, e.g. crypto/sha3.c.

It still preserves the property that the digests can't be incorrectly
treated as XOFs and vice versa.

It does result in the explicit array bounds for the output digests being
lost from the incremental API.  However, explicit array bounds don't
really work properly in C anyway.  They're nice to have as hints, but
not worth duplicating all the update and final functions for.  Note that
the BLAKE2s and BLAKE2b code uses this same solution.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/sha3.rst | 194 +++++------------
 include/crypto/sha3.h         | 386 +++++++++-------------------------
 lib/crypto/sha3.c             |  87 +++-----
 lib/crypto/tests/sha3_kunit.c |  20 +-
 4 files changed, 184 insertions(+), 503 deletions(-)

diff --git a/Documentation/crypto/sha3.rst b/Documentation/crypto/sha3.rst
index 6d7a07e088e9a..c27da98c89b7f 100644
--- a/Documentation/crypto/sha3.rst
+++ b/Documentation/crypto/sha3.rst
@@ -5,14 +5,13 @@ SHA-3 Algorithm collection
 ==========================
 
 .. Contents:
 
   - Overview
-  - Basic API
-    - Extendable-Output Functions
+  - Digests
+  - Extendable-Output Functions
   - Convenience API
-  - Internal API
   - Testing
   - References
   - API Function Reference
 
 
@@ -39,95 +38,75 @@ and two Extendable-Output Functions (XOF):
 
  - SHAKE128
  - SHAKE256
 
 If selectable algorithms are required then the crypto_hash API may be used
-instead as this binds each algorithm to a specific C type.
-
-
-Basic API
-=========
-
-The basic API has a separate context struct for each algorithm in the SHA3
-suite, none of the contents of which are expected to be accessed directly::
-
-	struct sha3_224_ctx { ... };
-	struct sha3_256_ctx { ... };
-	struct sha3_384_ctx { ... };
-	struct sha3_512_ctx { ... };
-	struct shake128_ctx { ... };
-	struct shake256_ctx { ... };
-
-There are a collection of initialisation functions, one for each algorithm
-supported, that initialise the context appropriately for that algorithm::
-
-	void sha3_224_init(struct sha3_224_ctx *ctx);
-	void sha3_256_init(struct sha3_256_ctx *ctx);
-	void sha3_384_init(struct sha3_384_ctx *ctx);
-	void sha3_512_init(struct sha3_512_ctx *ctx);
-	void shake128_init(struct shake128_ctx *ctx);
-	void shake256_init(struct shake256_ctx *ctx);
-
-Data is then added with the appropriate update function, again one per
-algorithm::
-
-	void sha3_224_update(struct sha3_224_ctx *ctx,
-			     const u8 *data, size_t len);
-	void sha3_256_update(struct sha3_256_ctx *ctx,
-			     const u8 *data, size_t len);
-	void sha3_384_update(struct sha3_384_ctx *ctx,
-			     const u8 *data, size_t len);
-	void sha3_512_update(struct sha3_512_ctx *ctx,
-			     const u8 *data, size_t len);
-	void shake128_update(struct shake128_ctx *ctx,
-			     const u8 *data, size_t len);
-	void shake256_update(struct shake256_ctx *ctx,
-			     const u8 *data, size_t len);
+instead.
+
+
+Digests
+=======
+
+The SHA-3 digest API uses the following struct::
+
+	struct sha3_ctx { ... };
+
+There are a collection of initialization functions, one for each algorithm::
+
+	void sha3_224_init(struct sha3_ctx *ctx);
+	void sha3_256_init(struct sha3_ctx *ctx);
+	void sha3_384_init(struct sha3_ctx *ctx);
+	void sha3_512_init(struct sha3_ctx *ctx);
+
+Data is then added with::
+
+	void sha3_update(struct sha3_ctx *ctx, const u8 *in, size_t in_len);
 
 The update function may be called multiple times if need be to add
 non-contiguous data.
 
-For digest algorithms, the digest is finalised and extracted with the
-algorithm-specific function::
+Finally, the digest is generated using::
 
-	void sha3_224_final(struct sha3_224_ctx *ctx,
-			    u8 out[SHA3_224_DIGEST_SIZE]);
-	void sha3_256_final(struct sha3_256_ctx *ctx,
-			    u8 out[SHA3_256_DIGEST_SIZE]);
-	void sha3_384_final(struct sha3_384_ctx *ctx,
-			    u8 out[SHA3_384_DIGEST_SIZE]);
-	void sha3_512_final(struct sha3_512_ctx *ctx,
-			    u8 out[SHA3_512_DIGEST_SIZE]);
-
-which also explicitly clears the context.  The amount of data extracted is
-determined by the type.
+	void sha3_final(struct sha3_ctx *ctx, u8 *out);
 
+which also zeroizes the context.  The length of the digest is determined by the
+initialization function that was called.
 
 Extendable-Output Functions
----------------------------
+===========================
+
+The SHA-3 extendable-output function (XOF) API uses the following struct::
 
-For XOFs, once the data has been added to a context, a variable amount of data
-may be extracted.  This can be done by calling the appropriate squeeze
-function::
+	struct shake_ctx { ... };
 
-	void shake128_squeeze(struct shake128_ctx *ctx, u8 *out, size_t out_len);
-	void shake256_squeeze(struct shake256_ctx *ctx, u8 *out, size_t out_len);
+Initialization is done with one of::
+
+	void shake128_init(struct shake_ctx *ctx);
+	void shake256_init(struct shake_ctx *ctx);
+
+Data is then added with::
+
+	void shake_update(struct shake_ctx *ctx, const u8 *in, size_t in_len);
+
+The update function may be called multiple times if need be to add
+non-contiguous data.
+
+Finally, the output is extracted using::
+
+	void shake_squeeze(struct shake_ctx *ctx, u8 *out, size_t out_len);
 
 and telling it how much data should be extracted.  The squeeze function may be
 called multiple times but it will only append the domain separation suffix on
 the first invocation.
 
 Note that performing a number of squeezes, with the output laid consequitively
 in a buffer, gets exactly the same output as doing a single squeeze for the
 combined amount over the same buffer.
 
-Once all the desired output has been extracted, the context should be cleared
-with the clear function appropriate to the algorithm::
-
-	void shake128_clear(struct shake128_ctx *ctx);
-	void shake256_clear(struct shake256_ctx *ctx);
+Once all the desired output has been extracted, zeroize the context::
 
+	void shake_zeroize_ctx(struct shake_ctx *ctx);
 
 Convenience API
 ===============
 
 It only a single contiguous buffer of input needs to be added and only a single
@@ -141,87 +120,10 @@ function for each algorithm supported::
 	void sha3_512(const u8 *in, size_t in_len, u8 out[SHA3_512_DIGEST_SIZE]);
 	void shake128(const u8 *in, size_t in_len, u8 *out, size_t out_len);
 	void shake256(const u8 *in, size_t in_len, u8 *out, size_t out_len);
 
 
-Internal API
-============
-
-There is a common internal API underlying all of this that may be used to build
-further algorithms or APIs as the engine in the same in all cases.  The
-algorithm APIs all wrap the common context structure::
-
-	struct sha3_ctx {
-		struct sha3_state	state;
-		u8			block_size;
-		u8			padding;
-		u8			absorb_offset;
-		u8			squeeze_offset;
-		bool			end_marked;
-	};
-
-	struct sha3_state {
-		u64			st[SHA3_STATE_SIZE / 8];
-	};
-
-The fields are as follows:
-
- * ``state.st``
-
-   An array of 25 64-bit state buckets that are used to hold the mathematical
-   state of the Keccak engine.  Data is XOR'd onto part of this, the engine is
-   cranked and then the output is copied from this.
-
-   For the convenience of adding input and extract output from it, the array is
-   kept in little-endian order most of the time, but is byteswapped to
-   host-endian in order to perform the Keccak function and then byteswapped
-   back again.  On an LE machine, the byteswapping is a no-op.
-
- * ``block_size``
-
-   The size of the block of state that can be updated or extracted at a time.
-   This is related to the algorithm size and is analogous to the "rate" in the
-   algorithm definition.
-
- * ``padding``
-
-   The terminating byte to add when finalising the stat.  This may differ
-   between algorithms.
-
- * ``absorb_offset``
-
-   This tracks which is the next byte of state to be updated; when it hits
-   ``block_size``, the engine is cranked and this is reset to 0.
-
- * ``squeeze_offset``
-
-   This tracks which is the next byte of state to be extracted; similar to
-   ``partial``, when it hits ``block_size``, if more output is requested, the
-   engine is cranked to generate more and this is reset to 0.
-
- * ``end_marked``
-
-   This is set to true when the domain separation suffix and any padding have
-   been appended to the state to prevent multiple squeezings from XOF
-   algorithms from re-appending this.
-
-Note that the size of the digest is *not* included here as that's only needed
-at finalisation time for digest algorithms and can be supplied then.  It is not
-relevant to XOFs.
-
-To make use of the context, the following internal functions are provided::
-
-	void sha3_update(struct sha3_ctx *ctx, const u8 *data, size_t len);
-	void sha3_squeeze(struct sha3_ctx *ctx, u8 *out, size_t out_len);
-	void sha3_clear(struct sha3_ctx *ctx);
-
-These allow data to be appended to/absorbed into the state, output to be
-extracted/squeezed from the state and for the state to be cleared.  Note that
-there is no "final" function, per se, but that can be constructed by squeezing
-and clearing.
-
-
 Testing
 =======
 
 To test the SHA-3 code, use sha3_kunit.
 
@@ -239,7 +141,7 @@ References
 
 
 API Function Reference
 ======================
 
-.. kernel-doc:: crypto/lib/sha3.c
+.. kernel-doc:: lib/crypto/sha3.c
 .. kernel-doc:: include/crypto/sha3.h
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index a54117cb1546b..58d2b3e0663e8 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -36,427 +36,231 @@
 
 #define SHA3_STATE_SIZE		200
 
 struct shash_desc;
 
+int crypto_sha3_init(struct shash_desc *desc);
+
 struct sha3_state {
 	u64		st[SHA3_STATE_SIZE / 8];
 };
 
-/*
- * The SHA3 context structure and state buffer.
+/**
+ * Internal context, shared by the digests (SHA3-*) and the XOFs (SHAKE*).
  *
  * To avoid the need to byteswap when adding input and extracting output from
  * the state array, the state array is kept in little-endian order most of the
  * time, but is byteswapped to host-endian in order to perform the Keccak
  * function and then byteswapped back again after.  On a LE machine, the
  * byteswap step is a no-op.
  */
-struct sha3_ctx {
+struct __sha3_ctx {
 	struct sha3_state	state;
 	u8			block_size;	/* Block size in bytes */
 	u8			padding;	/* Padding byte */
 	u8			absorb_offset;	/* Next state byte to absorb into */
 	u8			squeeze_offset;	/* Next state byte to extract */
 	bool			end_marked;	/* T if end marker inserted */
 };
 
-int crypto_sha3_init(struct shash_desc *desc);
+void __sha3_update(struct __sha3_ctx *ctx, const u8 *in, size_t in_len);
+void __sha3_squeeze(struct __sha3_ctx *ctx, u8 *out, size_t out_len);
+
+/** Context for SHA3-224, SHA3-256, SHA3-384, or SHA3-512 */
+struct sha3_ctx {
+	struct __sha3_ctx	ctx;
+	u8			digest_size;	/* Digest size in bytes */
+};
 
 /**
- * sha3_clear() - Explicitly clear the entire context
- * @ctx: the context to clear
- *
- * Explicitly clear the entire context, including the type parameters; after
- * this, the context must be fully initialized again.
- *
- * Context: Any context.
+ * Zeroize a sha3_ctx.  This is already called by sha3_final().  Call this
+ * explicitly when abandoning a context without calling sha3_final().
  */
-static inline void sha3_clear(struct sha3_ctx *ctx)
+static inline void sha3_zeroize_ctx(struct sha3_ctx *ctx)
 {
 	memzero_explicit(ctx, sizeof(*ctx));
 }
 
-void sha3_update(struct sha3_ctx *ctx, const u8 *data, size_t len);
-void sha3_squeeze(struct sha3_ctx *ctx, u8 *out, size_t out_len);
-
-/*
- * Context wrapper for SHA3-224.
- */
-struct sha3_224_ctx {
-	struct sha3_ctx ctx;
+/** Context for SHAKE128 or SHAKE256 */
+struct shake_ctx {
+	struct __sha3_ctx ctx;
 };
 
-/**
- * sha3_224_init() - Set a SHA3 context for SHA3-224
- * @ctx: the context to initialize
- *
- * Initialize a SHA3 context for the production of a SHA3-224 digest of a
- * message.
- *
- * Context: Any context.
- */
-static inline void sha3_224_init(struct sha3_224_ctx *ctx)
-{
-	*ctx = (struct sha3_224_ctx){
-		.ctx.block_size	= SHA3_224_BLOCK_SIZE,
-		.ctx.padding	= 0x06,
-	};
-}
-
-/**
- * sha3_224_update() - Update a SHA3-224 hash with message data
- * @ctx: the context to update; must have been initialized
- * @data: the message data
- * @len: the data length in bytes
- *
- * This can be called any number of times to add data to the hash, performing
- * the "keccak sponge absorbing" phase.
- *
- * Context: Any context.
- */
-static inline void sha3_224_update(struct sha3_224_ctx *ctx, const u8 *data, size_t len)
+/** Zeroize a shake_ctx.  Call this after the last squeeze. */
+static inline void shake_zeroize_ctx(struct shake_ctx *ctx)
 {
-	return sha3_update(&ctx->ctx, data, len);
+	memzero_explicit(ctx, sizeof(*ctx));
 }
 
 /**
- * sha3_224_final() - Finalise a SHA3-224 hash and extract the digest
- * @ctx: The context to finalise; must have been initialized
- * @out: Where to write the resulting message digest
+ * sha3_224_init() - Initialize a context for SHA3-224
+ * @ctx: The context to initialize
  *
- * Finish the computation of a SHA3-224 hash and perform the "Keccak sponge
- * squeezing" phase.  The digest is written to @out buffer and the context will
- * be completely zeroed out.
+ * This begins a new SHA3-224 message digest computation.
  *
  * Context: Any context.
  */
-static inline void sha3_224_final(struct sha3_224_ctx *ctx, u8 out[SHA3_224_DIGEST_SIZE])
+static inline void sha3_224_init(struct sha3_ctx *ctx)
 {
-	sha3_squeeze(&ctx->ctx, out, SHA3_224_DIGEST_SIZE);
-	sha3_clear(&ctx->ctx);
+	*ctx = (struct sha3_ctx){
+		.digest_size	= SHA3_224_DIGEST_SIZE,
+		.ctx.block_size	= SHA3_224_BLOCK_SIZE,
+		.ctx.padding	= 0x06,
+	};
 }
 
-/*
- * Context wrapper for SHA3-256.
- */
-struct sha3_256_ctx {
-	struct sha3_ctx ctx;
-};
-
 /**
- * sha3_256_init() - Set a SHA3 context for SHA3-256
- * @ctx: the context to initialize
+ * sha3_256_init() - Initialize a context for SHA3-256
+ * @ctx: The context to initialize
  *
- * Initialize a SHA3 context for the production of a SHA3-256 digest of a
- * message.
+ * This begins a new SHA3-256 message digest computation.
  *
  * Context: Any context.
  */
-static inline void sha3_256_init(struct sha3_256_ctx *ctx)
+static inline void sha3_256_init(struct sha3_ctx *ctx)
 {
-	*ctx = (struct sha3_256_ctx){
+	*ctx = (struct sha3_ctx){
+		.digest_size	= SHA3_256_DIGEST_SIZE,
 		.ctx.block_size	= SHA3_256_BLOCK_SIZE,
 		.ctx.padding	= 0x06,
 	};
 }
 
 /**
- * sha3_256_update() - Update a SHA3-256 hash with message data
- * @ctx: the context to update; must have been initialized
- * @data: the message data
- * @len: the data length in bytes
- *
- * This can be called any number of times to add data to the hash, performing
- * the "keccak sponge absorbing" phase.
- *
- * Context: Any context.
- */
-static inline void sha3_256_update(struct sha3_256_ctx *ctx, const u8 *data, size_t len)
-{
-	return sha3_update(&ctx->ctx, data, len);
-}
-
-/**
- * sha3_256_final() - Finalise a SHA3-256 hash and extract the digest
- * @ctx: The context to finalise; must have been initialized
- * @out: Where to write the resulting message digest
- *
- * Finish the computation of a SHA3-256 hash and perform the "Keccak sponge
- * squeezing" phase.  The digest is written to @out buffer and the context will
- * be completely zeroed out.
- *
- * Context: Any context.
- */
-static inline void sha3_256_final(struct sha3_256_ctx *ctx, u8 out[SHA3_256_DIGEST_SIZE])
-{
-	sha3_squeeze(&ctx->ctx, out, SHA3_256_DIGEST_SIZE);
-	sha3_clear(&ctx->ctx);
-}
-
-/*
- * Context wrapper for SHA3-384.
- */
-struct sha3_384_ctx {
-	struct sha3_ctx ctx;
-};
-
-/**
- * sha3_384_init() - Set a SHA3 context for SHA3-384
- * @ctx: the context to initialize
+ * sha3_384_init() - Initialize a context for SHA3-384
+ * @ctx: The context to initialize
  *
- * Initialize a SHA3 context for the production of a SHA3-384 digest of a
- * message.
+ * This begins a new SHA3-384 message digest computation.
  *
  * Context: Any context.
  */
-static inline void sha3_384_init(struct sha3_384_ctx *ctx)
+static inline void sha3_384_init(struct sha3_ctx *ctx)
 {
-	*ctx = (struct sha3_384_ctx){
+	*ctx = (struct sha3_ctx){
+		.digest_size	= SHA3_384_DIGEST_SIZE,
 		.ctx.block_size	= SHA3_384_BLOCK_SIZE,
 		.ctx.padding	= 0x06,
 	};
 }
 
 /**
- * sha3_384_update() - Update a SHA3-384 hash with message data
- * @ctx: the context to update; must have been initialized
- * @data: the message data
- * @len: the data length in bytes
- *
- * This can be called any number of times to add data to the hash, performing
- * the "keccak sponge absorbing" phase.
- *
- * Context: Any context.
- */
-static inline void sha3_384_update(struct sha3_384_ctx *ctx, const u8 *data, size_t len)
-{
-	return sha3_update(&ctx->ctx, data, len);
-}
-
-/**
- * sha3_384_final() - Finalise a SHA3-384 hash and extract the digest
- * @ctx: The context to finalise; must have been initialized
- * @out: Where to write the resulting message digest
- *
- * Finish the computation of a SHA3-384 hash and perform the "Keccak sponge
- * squeezing" phase.  The digest is written to @out buffer and the context will
- * be completely zeroed out.
- *
- * Context: Any context.
- */
-static inline void sha3_384_final(struct sha3_384_ctx *ctx, u8 out[SHA3_384_DIGEST_SIZE])
-{
-	sha3_squeeze(&ctx->ctx, out, SHA3_384_DIGEST_SIZE);
-	sha3_clear(&ctx->ctx);
-}
-
-/*
- * Context wrapper for SHA3-512.
- */
-struct sha3_512_ctx {
-	struct sha3_ctx ctx;
-};
-
-/**
- * sha3_512_init() - Set a SHA3 context for SHA3-512
- * @ctx: the context to initialize
+ * sha3_512_init() - Initialize a context for SHA3-512
+ * @ctx: The context to initialize
  *
- * Initialize a SHA3 context for the production of a SHA3-512 digest of a
- * message.
+ * This begins a new SHA3-512 message digest computation.
  *
  * Context: Any context.
  */
-static inline void sha3_512_init(struct sha3_512_ctx *ctx)
+static inline void sha3_512_init(struct sha3_ctx *ctx)
 {
-	*ctx = (struct sha3_512_ctx){
+	*ctx = (struct sha3_ctx){
+		.digest_size	= SHA3_512_DIGEST_SIZE,
 		.ctx.block_size	= SHA3_512_BLOCK_SIZE,
 		.ctx.padding	= 0x06,
 	};
 }
 
 /**
- * sha3_512_update() - Update a SHA3-512 hash with message data
- * @ctx: the context to update; must have been initialized
- * @data: the message data
- * @len: the data length in bytes
+ * sha3_update() - Update a SHA-3 digest context with input data
+ * @ctx: The context to update; must have been initialized
+ * @in: The input data
+ * @in_len: Length of the input data in bytes
  *
- * This can be called any number of times to add data to the hash, performing
- * the "keccak sponge absorbing" phase.
+ * This can be called any number of times to add data to a SHA3-224, SHA3-256,
+ * SHA3-384, or SHA3-512 digest (depending on which init function was called).
  *
  * Context: Any context.
  */
-static inline void sha3_512_update(struct sha3_512_ctx *ctx, const u8 *data, size_t len)
+static inline void sha3_update(struct sha3_ctx *ctx,
+			       const u8 *in, size_t in_len)
 {
-	return sha3_update(&ctx->ctx, data, len);
+	__sha3_update(&ctx->ctx, in, in_len);
 }
 
 /**
- * sha3_512_final() - Finalise a SHA3-512 hash and extract the digest
- * @ctx: The context to finalise; must have been initialized
- * @out: Where to write the resulting message digest
+ * sha3_final() - Finish computing a SHA-3 message digest
+ * @ctx: The context to finalize; must have been initialized
+ * @out: (output) The resulting SHA3-224, SHA3-256, SHA3-384, or SHA3-512
+ *	 message digest, matching the init function that was called.  Note that
+ *	 the size differs for each one; see SHA3_*_DIGEST_SIZE.
  *
- * Finish the computation of a SHA3-512 hash and perform the "Keccak sponge
- * squeezing" phase.  The digest is written to @out buffer and the context will
- * be completely zeroed out.
+ * After finishing, this zeroizes @ctx.  So the caller does not need to do it.
  *
  * Context: Any context.
  */
-static inline void sha3_512_final(struct sha3_512_ctx *ctx, u8 out[SHA3_512_DIGEST_SIZE])
+static inline void sha3_final(struct sha3_ctx *ctx, u8 *out)
 {
-	sha3_squeeze(&ctx->ctx, out, SHA3_512_DIGEST_SIZE);
-	sha3_clear(&ctx->ctx);
+	__sha3_squeeze(&ctx->ctx, out, ctx->digest_size);
+	sha3_zeroize_ctx(ctx);
 }
 
-/*
- * Context wrapper for SHAKE128.
- */
-struct shake128_ctx {
-	struct sha3_ctx ctx;
-};
-
 /**
- * shake128_init() - Set a SHA3 context for SHAKE128
+ * shake128_init() - Initialize a context for SHAKE128
  * @ctx: The context to initialize
  *
- * Initialize a SHA3 context for the production of SHAKE128 output generation
- * from a message.  The sha3_squeeze() function can be used to extract an
- * arbitrary amount of data from the context.
+ * This begins a new SHAKE128 extendable-output function (XOF) computation.
  *
  * Context: Any context.
  */
-static inline void shake128_init(struct shake128_ctx *ctx)
+static inline void shake128_init(struct shake_ctx *ctx)
 {
-	*ctx = (struct shake128_ctx){
+	*ctx = (struct shake_ctx){
 		.ctx.block_size	= SHAKE128_BLOCK_SIZE,
 		.ctx.padding	= 0x1f,
 	};
 }
 
 /**
- * shake128_update() - Update a SHAKE128 hash with message data
- * @ctx: the context to update; must have been initialized
- * @data: the message data
- * @len: the data length in bytes
- *
- * This can be called any number of times to add data to the XOF state,
- * performing the "keccak sponge absorbing" phase.
- *
- * Context: Any context.
- */
-static inline void shake128_update(struct shake128_ctx *ctx, const u8 *data, size_t len)
-{
-	return sha3_update(&ctx->ctx, data, len);
-}
-
-/**
- * shake128_squeeze() - Finalize a SHAKE128 digest of any type and extract the digest
- * @ctx: the context to finalize; must have been initialized
- * @out: Where to write the resulting message digest
- * @out_size: The amount of digest to extract to @out in bytes
- *
- * Finish the computation of a SHAKE128 XOF and perform the "Keccak sponge
- * squeezing" phase.  @out_size amount of digest is written to @out buffer.
- *
- * This may be called multiple times to extract continuations of the digest.
- * Note that, a number of consecutive squeezes laid end-to-end will yield the
- * same output as one big squeeze generating the same total amount of output.
- *
- * Context: Any context.
- */
-static inline void shake128_squeeze(struct shake128_ctx *ctx, u8 *out, size_t out_size)
-{
-	return sha3_squeeze(&ctx->ctx, out, out_size);
-}
-
-/**
- * shake128_clear() - Explicitly clear the entire SHAKE128 context
- * @ctx: the context to clear
- *
- * Explicitly clear the entire context; after this, the context must be
- * initialized again.
- *
- * Context: Any context.
- */
-static inline void shake128_clear(struct shake128_ctx *ctx)
-{
-	sha3_clear(&ctx->ctx);
-}
-
-/*
- * Context wrapper for SHAKE256.
- */
-struct shake256_ctx {
-	struct sha3_ctx ctx;
-};
-
-/**
- * shake256_init() - Set a SHA3 context for SHAKE256
+ * shake256_init() - Initialize a context for SHAKE256
  * @ctx: The context to initialize
  *
- * Initialize a SHA3 context for the production of SHAKE256 output generation
- * from a message.  The sha3_squeeze() function can be used to extract an
- * arbitrary amount of data from the context.
+ * This begins a new SHAKE256 extendable-output function (XOF) computation.
  *
  * Context: Any context.
  */
-static inline void shake256_init(struct shake256_ctx *ctx)
+static inline void shake256_init(struct shake_ctx *ctx)
 {
-	*ctx = (struct shake256_ctx){
+	*ctx = (struct shake_ctx){
 		.ctx.block_size	= SHAKE256_BLOCK_SIZE,
 		.ctx.padding	= 0x1f,
 	};
 }
 
 /**
- * shake256_update() - Update a SHAKE256 hash with message data
- * @ctx: the context to update; must have been initialized
- * @data: the message data
- * @len: the data length in bytes
- *
- * This can be called any number of times to add data to the XOF state,
- * performing the "keccak sponge absorbing" phase.
- *
- * Context: Any context.
- */
-static inline void shake256_update(struct shake256_ctx *ctx, const u8 *data, size_t len)
-{
-	return sha3_update(&ctx->ctx, data, len);
-}
-
-/**
- * shake256_squeeze() - Finalize a SHAKE256 digest of any type and extract the digest
- * @ctx: the context to finalize; must have been initialized
- * @out: Where to write the resulting message digest
- * @out_size: The amount of digest to extract to @out in bytes
- *
- * Finish the computation of a SHAKE256 XOF and perform the "Keccak sponge
- * squeezing" phase.  @out_size amount of digest is written to @out buffer.
+ * shake_update() - Update a SHAKE context with input data
+ * @ctx: The context to update; must have been initialized
+ * @in: The input data
+ * @in_len: Length of the input data in bytes
  *
- * This may be called multiple times to extract continuations of the digest.
- * Note that, a number of consecutive squeezes laid end-to-end will yield the
- * same output as one big squeeze generating the same total amount of output.
+ * This can be called any number of times to add more input data to SHAKE128 or
+ * SHAKE256.  This cannot be called after squeezing has begun.
  *
  * Context: Any context.
  */
-static inline void shake256_squeeze(struct shake256_ctx *ctx, u8 *out, size_t out_size)
+static inline void shake_update(struct shake_ctx *ctx,
+				const u8 *in, size_t in_len)
 {
-	return sha3_squeeze(&ctx->ctx, out, out_size);
+	__sha3_update(&ctx->ctx, in, in_len);
 }
 
 /**
- * shake256_clear() - Explicitly clear the entire SHAKE256 context
- * @ctx: the context to clear
+ * shake_squeeze() - Generate output from SHAKE128 or SHAKE256
+ * @ctx: The context to squeeze; must have been initialized
+ * @out: Where to write the resulting output data
+ * @out_len: The amount of data to extract to @out in bytes
  *
- * Explicitly clear the entire context; after this, the context must be
- * initialized again.
+ * This may be called multiple times.  A number of consecutive squeezes laid
+ * end-to-end will yield the same output as one big squeeze generating the same
+ * total amount of output.  More input cannot be provided after squeezing has
+ * begun.  After all squeezing has been completed, call shake_zeroize_ctx().
  *
  * Context: Any context.
  */
-static inline void shake256_clear(struct shake256_ctx *ctx)
+static inline void shake_squeeze(struct shake_ctx *ctx,
+				 u8 *out, size_t out_len)
 {
-	sha3_clear(&ctx->ctx);
+	return __sha3_squeeze(&ctx->ctx, out, out_len);
 }
 
 void sha3_224(const u8 *in, size_t in_len, u8 out[SHA3_224_DIGEST_SIZE]);
 void sha3_256(const u8 *in, size_t in_len, u8 out[SHA3_256_DIGEST_SIZE]);
 void sha3_384(const u8 *in, size_t in_len, u8 out[SHA3_384_DIGEST_SIZE]);
diff --git a/lib/crypto/sha3.c b/lib/crypto/sha3.c
index 83fbfa1169cdb..6c13a43b0f868 100644
--- a/lib/crypto/sha3.c
+++ b/lib/crypto/sha3.c
@@ -177,11 +177,11 @@ static void sha3_keccakf_generic(struct sha3_state *state)
 
 	for (int  i = 0; i < ARRAY_SIZE(state->st); i++)
 		cpu_to_le64s(&state->st[i]);
 }
 
-static void sha3_absorb_block_generic(struct sha3_ctx *ctx, const u8 *data)
+static void sha3_absorb_block_generic(struct __sha3_ctx *ctx, const u8 *data)
 {
 	struct sha3_state *state = &ctx->state;
 	size_t bsize = ctx->block_size;
 
 	for (size_t i = 0; i < bsize / 8; i++)
@@ -191,11 +191,11 @@ static void sha3_absorb_block_generic(struct sha3_ctx *ctx, const u8 *data)
 
 /*
  * Perform rounds of XOR'ing whole blocks of data into the state buffer and
  * then performing a keccak mix step.
  */
-static void sha3_absorb_blocks_generic(struct sha3_ctx *ctx,
+static void sha3_absorb_blocks_generic(struct __sha3_ctx *ctx,
 				       const u8 *data, size_t nblocks)
 {
 	do {
 		sha3_absorb_block_generic(ctx, data);
 		data += ctx->block_size;
@@ -210,32 +210,21 @@ static void sha3_absorb_blocks_generic(struct sha3_ctx *ctx,
 #endif
 
 /*
  * XOR in partial data that's insufficient to fill a whole block.
  */
-static void sha3_absorb_xorle(struct sha3_ctx *ctx, const u8 *data,
+static void sha3_absorb_xorle(struct __sha3_ctx *ctx, const u8 *data,
 			      size_t partial, size_t len)
 {
 	u8 *buf = (u8 *)ctx->state.st;
 
 	buf += partial;
 	for (size_t i = 0; i < len; i++)
 		*buf++ ^= *data++;
 }
 
-/**
- * sha3_update() - Update a SHA3 context of any type with message data
- * @ctx: the context to update; must have been initialized
- * @data: the message data
- * @len: the data length in bytes
- *
- * This can be called any number of times to perform the "keccak sponge
- * absorbing" phase.
- *
- * Context: May use the FPU/Vector unit registers.
- */
-void sha3_update(struct sha3_ctx *ctx, const u8 *data, size_t len)
+void __sha3_update(struct __sha3_ctx *ctx, const u8 *data, size_t len)
 {
 	size_t absorb_offset = ctx->absorb_offset;
 	size_t bsize = ctx->block_size;
 
 	WARN_ON_ONCE(ctx->end_marked);
@@ -259,29 +248,13 @@ void sha3_update(struct sha3_ctx *ctx, const u8 *data, size_t len)
 	if (len) {
 		sha3_absorb_xorle(ctx, data, ctx->absorb_offset, len);
 		ctx->absorb_offset += len;
 	}
 }
-EXPORT_SYMBOL_GPL(sha3_update);
+EXPORT_SYMBOL_GPL(__sha3_update);
 
-/**
- * sha3_squeeze() - Finalize a SHA3 digest of any type and extract the digest
- * @ctx: the context to finalize; must have been initialized
- * @out: Where to write the resulting message digest
- * @out_size: The amount of digest to extract to @out
- *
- * Finish the computation of a SHA3 message digest of any type and perform the
- * "Keccak sponge squeezing" phase.  @out_size amount of digest is written to
- * @out buffer.
- *
- * This may be called multiple times to extract continuations of the digest.
- * Note that, for example, two consecutive 16-byte squeezes laid end-to-end
- * will yield the same as one 32-byte squeeze.
- *
- * Context: May use the FPU/Vector unit registers.
- */
-void sha3_squeeze(struct sha3_ctx *ctx, u8 *out, size_t out_size)
+void __sha3_squeeze(struct __sha3_ctx *ctx, u8 *out, size_t out_len)
 {
 	size_t squeeze_offset = ctx->squeeze_offset;
 	size_t bsize = ctx->block_size;
 	u8 *p = (u8 *)ctx->state.st, end_marker = 0x80;
 
@@ -293,27 +266,27 @@ void sha3_squeeze(struct sha3_ctx *ctx, u8 *out, size_t out_size)
 
 	for (;;) {
 		if (squeeze_offset == 0)
 			sha3_keccakf(&ctx->state);
 
-		size_t part = umin(out_size, bsize - squeeze_offset);
+		size_t part = umin(out_len, bsize - squeeze_offset);
 
 		if (part > 0) {
 			memcpy(out, p + squeeze_offset, part);
-			out_size -= part;
+			out_len -= part;
 			out += part;
 			squeeze_offset += part;
 		}
-		if (!out_size)
+		if (!out_len)
 			break;
 		if (squeeze_offset >= bsize)
 			squeeze_offset = 0;
 	}
 
 	ctx->squeeze_offset = squeeze_offset;
 }
-EXPORT_SYMBOL_GPL(sha3_squeeze);
+EXPORT_SYMBOL_GPL(__sha3_squeeze);
 
 /**
  * sha3_224() - Convenience wrapper to digest a simple buffer as SHA3-224
  * @in: The data to be digested
  * @in_len: The amount of data to be digested in bytes
@@ -324,15 +297,15 @@ EXPORT_SYMBOL_GPL(sha3_squeeze);
  *
  * Context: May use the FPU/Vector unit registers.
  */
 void sha3_224(const u8 *in, size_t in_len, u8 out[SHA3_224_DIGEST_SIZE])
 {
-	struct sha3_224_ctx ctx;
+	struct sha3_ctx ctx;
 
 	sha3_224_init(&ctx);
-	sha3_224_update(&ctx, in, in_len);
-	sha3_224_final(&ctx, out);
+	sha3_update(&ctx, in, in_len);
+	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_224);
 
 /**
  * sha3_256() - Convenience wrapper to digest a simple buffer as SHA3-256
@@ -345,15 +318,15 @@ EXPORT_SYMBOL_GPL(sha3_224);
  *
  * Context: May use the FPU/Vector unit registers.
  */
 void sha3_256(const u8 *in, size_t in_len, u8 out[SHA3_256_DIGEST_SIZE])
 {
-	struct sha3_256_ctx ctx;
+	struct sha3_ctx ctx;
 
 	sha3_256_init(&ctx);
-	sha3_256_update(&ctx, in, in_len);
-	sha3_256_final(&ctx, out);
+	sha3_update(&ctx, in, in_len);
+	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_256);
 
 /**
  * sha3_384() - Convenience wrapper to digest a simple buffer as SHA3-384
@@ -366,15 +339,15 @@ EXPORT_SYMBOL_GPL(sha3_256);
  *
  * Context: May use the FPU/Vector unit registers.
  */
 void sha3_384(const u8 *in, size_t in_len, u8 out[SHA3_384_DIGEST_SIZE])
 {
-	struct sha3_384_ctx ctx;
+	struct sha3_ctx ctx;
 
 	sha3_384_init(&ctx);
-	sha3_384_update(&ctx, in, in_len);
-	sha3_384_final(&ctx, out);
+	sha3_update(&ctx, in, in_len);
+	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_384);
 
 /**
  * sha3_512() - Convenience wrapper to digest a simple buffer as SHA3-512
@@ -387,15 +360,15 @@ EXPORT_SYMBOL_GPL(sha3_384);
  *
  * Context: May use the FPU/Vector unit registers.
  */
 void sha3_512(const u8 *in, size_t in_len, u8 out[SHA3_512_DIGEST_SIZE])
 {
-	struct sha3_512_ctx ctx;
+	struct sha3_ctx ctx;
 
 	sha3_512_init(&ctx);
-	sha3_512_update(&ctx, in, in_len);
-	sha3_512_final(&ctx, out);
+	sha3_update(&ctx, in, in_len);
+	sha3_final(&ctx, out);
 }
 EXPORT_SYMBOL_GPL(sha3_512);
 
 /**
  * shake128() - Convenience wrapper to apply SHAKE128 to a simple buffer
@@ -410,16 +383,16 @@ EXPORT_SYMBOL_GPL(sha3_512);
  *
  * Context: May use the FPU/Vector unit registers.
  */
 void shake128(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 {
-	struct shake128_ctx ctx;
+	struct shake_ctx ctx;
 
 	shake128_init(&ctx);
-	shake128_update(&ctx, in, in_len);
-	shake128_squeeze(&ctx, out, out_len);
-	shake128_clear(&ctx);
+	shake_update(&ctx, in, in_len);
+	shake_squeeze(&ctx, out, out_len);
+	shake_zeroize_ctx(&ctx);
 }
 EXPORT_SYMBOL_GPL(shake128);
 
 /**
  * shake256() - Convenience wrapper to apply SHAKE256 to a simple buffer
@@ -434,16 +407,16 @@ EXPORT_SYMBOL_GPL(shake128);
  *
  * Context: May use the FPU/Vector unit registers.
  */
 void shake256(const u8 *in, size_t in_len, u8 *out, size_t out_len)
 {
-	struct shake256_ctx ctx;
+	struct shake_ctx ctx;
 
 	shake256_init(&ctx);
-	shake256_update(&ctx, in, in_len);
-	shake256_squeeze(&ctx, out, out_len);
-	shake256_clear(&ctx);
+	shake_update(&ctx, in, in_len);
+	shake_squeeze(&ctx, out, out_len);
+	shake_zeroize_ctx(&ctx);
 }
 EXPORT_SYMBOL_GPL(shake256);
 
 #if defined(sha3_mod_init_arch) || defined(CONFIG_CRYPTO_FIPS)
 static int __init sha3_mod_init(void)
diff --git a/lib/crypto/tests/sha3_kunit.c b/lib/crypto/tests/sha3_kunit.c
index 032fa3950afe4..c2e0c37d8a543 100644
--- a/lib/crypto/tests/sha3_kunit.c
+++ b/lib/crypto/tests/sha3_kunit.c
@@ -5,15 +5,15 @@
  */
 #include <crypto/sha3.h>
 #include "sha3_testvecs.h"
 
 #define HASH		sha3_256
-#define HASH_CTX	sha3_256_ctx
+#define HASH_CTX	sha3_ctx
 #define HASH_SIZE	SHA3_256_DIGEST_SIZE
 #define HASH_INIT	sha3_256_init
-#define HASH_UPDATE	sha3_256_update
-#define HASH_FINAL	sha3_256_final
+#define HASH_UPDATE	sha3_update
+#define HASH_FINAL	sha3_final
 #include "hash-test-template.h"
 
 /*
  * Sample message and the output generated for various algorithms by passing it
  * into "openssl sha3-224" etc..
@@ -252,24 +252,25 @@ static void test_shake256_nist(struct kunit *test)
  * series of squeezings of the same context should, if laid end-to-end, match a
  * single squeezing of the combined size.
  */
 static void test_shake256_tiling(struct kunit *test)
 {
-	struct shake256_ctx ctx;
+	struct shake_ctx ctx;
 	u8 out[8 + SHA3_512_DIGEST_SIZE + 8];
 
 	for (int tile_size = 1; tile_size < SHAKE256_DEFAULT_SIZE; tile_size++) {
 		int left = SHAKE256_DEFAULT_SIZE;
 		u8 *p = out + 8;
 
 		memset(out, 0, sizeof(out));
 		shake256_init(&ctx);
-		shake256_update(&ctx, test_sha3_sample, sizeof(test_sha3_sample) - 1);
+		shake_update(&ctx, test_sha3_sample,
+			     sizeof(test_sha3_sample) - 1);
 		while (left > 0) {
 			int part = umin(tile_size, left);
 
-			shake256_squeeze(&ctx, p, part);
+			shake_squeeze(&ctx, p, part);
 			p += part;
 			left -= part;
 		}
 
 		KUNIT_ASSERT_MEMEQ_MSG(test, out, test_shake256, sizeof(test_shake256),
@@ -283,11 +284,11 @@ static void test_shake256_tiling(struct kunit *test)
  * context should, if laid end-to-end, match a single squeezing of the combined
  * size.
  */
 static void test_shake256_tiling2(struct kunit *test)
 {
-	struct shake256_ctx ctx;
+	struct shake_ctx ctx;
 	u8 out[8 + SHA3_512_DIGEST_SIZE + 8];
 
 	for (int first_tile_size = 3;
 	     first_tile_size < SHAKE256_DEFAULT_SIZE;
 	     first_tile_size++) {
@@ -295,15 +296,16 @@ static void test_shake256_tiling2(struct kunit *test)
 		int left = SHAKE256_DEFAULT_SIZE;
 		u8 *p = out + 8;
 
 		memset(out, 0, sizeof(out));
 		shake256_init(&ctx);
-		shake256_update(&ctx, test_sha3_sample, sizeof(test_sha3_sample) - 1);
+		shake_update(&ctx, test_sha3_sample,
+			     sizeof(test_sha3_sample) - 1);
 		while (left > 0) {
 			int part = umin(tile_size, left);
 
-			shake256_squeeze(&ctx, p, part);
+			shake_squeeze(&ctx, p, part);
 			p += part;
 			left -= part;
 			tile_size--;
 			if (tile_size < 1)
 				tile_size = 5;
-- 
2.51.1.dirty

