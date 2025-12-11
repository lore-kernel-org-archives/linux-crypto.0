Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B52242D72;
	Thu, 11 Dec 2025 01:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765416055; cv=none; b=FM31tSlMg0fF89AEdDb7YxYjGXjsnHi6qL8gjvPRVUXzLP8SLOFFAvDsmlR7G4l8cHU4AdrkvDLv4Ilz8eqxR0K45IkoW29xXlxypZKAPM9+PEAwCX5LU1vn5QAwUtBSvcP123MOsckbcmLs/P8+n0au8Qu1ncDSfZ9xaOR9SM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765416055; c=relaxed/simple;
	bh=A+CNVdsT6Wqi2GfioKWoooWo4EvER4pGygMuQqFuzCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyIiMBO6jiga1966rtHyXT7qaRmalwgrOwcKVGIv0DwfO4Q0JVlhjxpB7HwtsLlzuST0h8tf0fj6R2ftHgOk4KZM0wrgfJ31HpXl14S0Xpgc/E2kTz7mhwdz7IfK7RCRz0cumKTJYQw4lfKp+F1vMU5S7aIj8yXTut9FvBc1f6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q//ynOO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q//ynOO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C601C113D0;
	Thu, 11 Dec 2025 01:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765416054;
	bh=A+CNVdsT6Wqi2GfioKWoooWo4EvER4pGygMuQqFuzCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q//ynOO2OG4v0l/vtfkV7RfFzju1UYIyQeRtdPR63jqrPihCL2iw5XB5ffrynaVKX
	 DUgyZyjB7Rk8/y0jcmuVZ97kQbs90DlIhBwm0bf4FedU5/sw/9xyIC7G7wgjqGGtnu
	 al+JJNVNRCYduDYNdBXXn+uY9rhkkwudW9wakDuipTNoFYMDjSMx/R87wFZiCw5ML0
	 RH8oQk8Yfb8nOPxp2SPALuMhPUjaXwOGLnN7rbzlnOhPtDMpN5lpkvwJ7ZkLNGEkIf
	 BV7tpRxlTpIx8XomvM+DKXaSR30EwE1ejFyHkelykUMSKe0Hre/IiswI5IQGdyNdg6
	 daNvB2z+rgKow==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/12] crypto: adiantum - Convert to use NH library
Date: Wed, 10 Dec 2025 17:18:38 -0800
Message-ID: <20251211011846.8179-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251211011846.8179-1-ebiggers@kernel.org>
References: <20251211011846.8179-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reimplement the Adiantum message hashing using the nh() library
function, combined with some code which directly handles the Poly1305
stage.  The latter code is derived from crypto/nhpoly1305.c.

This eliminates the dependency on the "nhpoly1305" crypto_shash
algorithm, which existed only to fit Adiantum message hashing into the
traditional Linux crypto API paradigm.  Now that simple,
architecture-optimized library functions are a well-established option
too, we can switch to this simpler implementation.

Note: I've dropped the support for the optional third parameter of the
adiantum template, which specified the nhpoly1305 implementation.  We
could keep accepting some strings in this parameter for backwards
compatibility, but I don't think it's being used.  I believe only
"adiantum(xchacha12,aes)" and "adiantum(xchacha20,aes)" are used.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig    |   2 +-
 crypto/adiantum.c | 295 +++++++++++++++++++++++++++++-----------------
 crypto/testmgr.c  |   4 +-
 3 files changed, 191 insertions(+), 110 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2e5b195b1b06..89d1ccaa1fa0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -599,13 +599,13 @@ endmenu
 menu "Length-preserving ciphers and modes"
 
 config CRYPTO_ADIANTUM
 	tristate "Adiantum"
 	select CRYPTO_CHACHA20
+	select CRYPTO_LIB_NH
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC
-	select CRYPTO_NHPOLY1305
 	select CRYPTO_MANAGER
 	help
 	  Adiantum tweakable, length-preserving encryption mode
 
 	  Designed for fast and secure disk encryption, especially on
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index a6bca877c3c7..bbe519fbd739 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -18,27 +18,18 @@
  *
  * For flexibility, this implementation also allows other ciphers:
  *
  *	- Stream cipher: XChaCha12 or XChaCha20
  *	- Block cipher: any with a 128-bit block size and 256-bit key
- *
- * This implementation doesn't currently allow other ε-∆U hash functions, i.e.
- * HPolyC is not supported.  This is because Adiantum is ~20% faster than HPolyC
- * but still provably as secure, and also the ε-∆U hash function of HBSH is
- * formally defined to take two inputs (tweak, message) which makes it difficult
- * to wrap with the crypto_shash API.  Rather, some details need to be handled
- * here.  Nevertheless, if needed in the future, support for other ε-∆U hash
- * functions could be added here.
  */
 
 #include <crypto/b128ops.h>
 #include <crypto/chacha.h>
 #include <crypto/internal/cipher.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/poly1305.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/nhpoly1305.h>
+#include <crypto/nh.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 
 /*
  * Size of right-hand part of input data, in bytes; also the size of the block
@@ -48,11 +39,11 @@
 
 /* Size of the block cipher key (K_E) in bytes */
 #define BLOCKCIPHER_KEY_SIZE		32
 
 /* Size of the hash key (K_H) in bytes */
-#define HASH_KEY_SIZE		(POLY1305_BLOCK_SIZE + NHPOLY1305_KEY_SIZE)
+#define HASH_KEY_SIZE		(2 * POLY1305_BLOCK_SIZE + NH_KEY_BYTES)
 
 /*
  * The specification allows variable-length tweaks, but Linux's crypto API
  * currently only allows algorithms to support a single length.  The "natural"
  * tweak length for Adiantum is 16, since that fits into one Poly1305 block for
@@ -62,18 +53,35 @@
 #define TWEAK_SIZE		32
 
 struct adiantum_instance_ctx {
 	struct crypto_skcipher_spawn streamcipher_spawn;
 	struct crypto_cipher_spawn blockcipher_spawn;
-	struct crypto_shash_spawn hash_spawn;
 };
 
 struct adiantum_tfm_ctx {
 	struct crypto_skcipher *streamcipher;
 	struct crypto_cipher *blockcipher;
-	struct crypto_shash *hash;
 	struct poly1305_core_key header_hash_key;
+	struct poly1305_core_key msg_poly_key;
+	u32 nh_key[NH_KEY_WORDS];
+};
+
+struct nhpoly1305_ctx {
+	/* Running total of polynomial evaluation */
+	struct poly1305_state poly_state;
+
+	/* Partial block buffer */
+	u8 buffer[NH_MESSAGE_UNIT];
+	unsigned int buflen;
+
+	/*
+	 * Number of bytes remaining until the current NH message reaches
+	 * NH_MESSAGE_BYTES.  When nonzero, 'nh_hash' holds the partial NH hash.
+	 */
+	unsigned int nh_remaining;
+
+	__le64 nh_hash[NH_NUM_PASSES];
 };
 
 struct adiantum_request_ctx {
 
 	/*
@@ -96,13 +104,16 @@ struct adiantum_request_ctx {
 	 * The result of the Poly1305 ε-∆U hash function applied to
 	 * (bulk length, tweak)
 	 */
 	le128 header_hash;
 
-	/* Sub-requests, must be last */
+	/*
+	 * skcipher sub-request size is unknown at compile-time, so it needs to
+	 * go after the members with known sizes.
+	 */
 	union {
-		struct shash_desc hash_desc;
+		struct nhpoly1305_ctx hash_ctx;
 		struct skcipher_request streamcipher_req;
 	} u;
 };
 
 /*
@@ -168,16 +179,15 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	keyp += BLOCKCIPHER_KEY_SIZE;
 
 	/* Set the hash key (K_H) */
 	poly1305_core_setkey(&tctx->header_hash_key, keyp);
 	keyp += POLY1305_BLOCK_SIZE;
-
-	crypto_shash_clear_flags(tctx->hash, CRYPTO_TFM_REQ_MASK);
-	crypto_shash_set_flags(tctx->hash, crypto_skcipher_get_flags(tfm) &
-					   CRYPTO_TFM_REQ_MASK);
-	err = crypto_shash_setkey(tctx->hash, keyp, NHPOLY1305_KEY_SIZE);
-	keyp += NHPOLY1305_KEY_SIZE;
+	poly1305_core_setkey(&tctx->msg_poly_key, keyp);
+	keyp += POLY1305_BLOCK_SIZE;
+	for (int i = 0; i < NH_KEY_WORDS; i++)
+		tctx->nh_key[i] = get_unaligned_le32(&keyp[i * 4]);
+	keyp += NH_KEY_BYTES;
 	WARN_ON(keyp != &data->derived_keys[ARRAY_SIZE(data->derived_keys)]);
 out:
 	kfree_sensitive(data);
 	return err;
 }
@@ -241,39 +251,147 @@ static void adiantum_hash_header(struct skcipher_request *req)
 			     TWEAK_SIZE / POLY1305_BLOCK_SIZE, 1);
 
 	poly1305_core_emit(&state, NULL, &rctx->header_hash);
 }
 
-/* Hash the left-hand part (the "bulk") of the message using NHPoly1305 */
-static int adiantum_hash_message(struct skcipher_request *req,
-				 struct scatterlist *sgl, unsigned int nents,
-				 le128 *digest)
+/* Pass the next NH hash value through Poly1305 */
+static void process_nh_hash_value(struct nhpoly1305_ctx *ctx,
+				  const struct adiantum_tfm_ctx *key)
+{
+	static_assert(NH_HASH_BYTES % POLY1305_BLOCK_SIZE == 0);
+
+	poly1305_core_blocks(&ctx->poly_state, &key->msg_poly_key, ctx->nh_hash,
+			     NH_HASH_BYTES / POLY1305_BLOCK_SIZE, 1);
+}
+
+/*
+ * Feed the next portion of the message data, as a whole number of 16-byte
+ * "NH message units", through NH and Poly1305.  Each NH hash is taken over
+ * 1024 bytes, except possibly the final one which is taken over a multiple of
+ * 16 bytes up to 1024.  Also, in the case where data is passed in misaligned
+ * chunks, we combine partial hashes; the end result is the same either way.
+ */
+static void nhpoly1305_units(struct nhpoly1305_ctx *ctx,
+			     const struct adiantum_tfm_ctx *key,
+			     const u8 *data, size_t len)
+{
+	do {
+		unsigned int bytes;
+
+		if (ctx->nh_remaining == 0) {
+			/* Starting a new NH message */
+			bytes = min(len, NH_MESSAGE_BYTES);
+			nh(key->nh_key, data, bytes, ctx->nh_hash);
+			ctx->nh_remaining = NH_MESSAGE_BYTES - bytes;
+		} else {
+			/* Continuing a previous NH message */
+			__le64 tmp_hash[NH_NUM_PASSES];
+			unsigned int pos;
+
+			pos = NH_MESSAGE_BYTES - ctx->nh_remaining;
+			bytes = min(len, ctx->nh_remaining);
+			nh(&key->nh_key[pos / 4], data, bytes, tmp_hash);
+			for (int i = 0; i < NH_NUM_PASSES; i++)
+				le64_add_cpu(&ctx->nh_hash[i],
+					     le64_to_cpu(tmp_hash[i]));
+			ctx->nh_remaining -= bytes;
+		}
+		if (ctx->nh_remaining == 0)
+			process_nh_hash_value(ctx, key);
+		data += bytes;
+		len -= bytes;
+	} while (len);
+}
+
+static void nhpoly1305_init(struct nhpoly1305_ctx *ctx)
+{
+	poly1305_core_init(&ctx->poly_state);
+	ctx->buflen = 0;
+	ctx->nh_remaining = 0;
+}
+
+static void nhpoly1305_update(struct nhpoly1305_ctx *ctx,
+			      const struct adiantum_tfm_ctx *key,
+			      const u8 *data, size_t len)
 {
+	unsigned int bytes;
+
+	if (ctx->buflen) {
+		bytes = min(len, (int)NH_MESSAGE_UNIT - ctx->buflen);
+		memcpy(&ctx->buffer[ctx->buflen], data, bytes);
+		ctx->buflen += bytes;
+		if (ctx->buflen < NH_MESSAGE_UNIT)
+			return;
+		nhpoly1305_units(ctx, key, ctx->buffer, NH_MESSAGE_UNIT);
+		ctx->buflen = 0;
+		data += bytes;
+		len -= bytes;
+	}
+
+	if (len >= NH_MESSAGE_UNIT) {
+		bytes = round_down(len, NH_MESSAGE_UNIT);
+		nhpoly1305_units(ctx, key, data, bytes);
+		data += bytes;
+		len -= bytes;
+	}
+
+	if (len) {
+		memcpy(ctx->buffer, data, len);
+		ctx->buflen = len;
+	}
+}
+
+static void nhpoly1305_final(struct nhpoly1305_ctx *ctx,
+			     const struct adiantum_tfm_ctx *key, le128 *out)
+{
+	if (ctx->buflen) {
+		memset(&ctx->buffer[ctx->buflen], 0,
+		       NH_MESSAGE_UNIT - ctx->buflen);
+		nhpoly1305_units(ctx, key, ctx->buffer, NH_MESSAGE_UNIT);
+	}
+
+	if (ctx->nh_remaining)
+		process_nh_hash_value(ctx, key);
+
+	poly1305_core_emit(&ctx->poly_state, NULL, out);
+}
+
+/*
+ * Hash the left-hand part (the "bulk") of the message as follows:
+ *
+ *	H_L ← Poly1305_{K_L}(NH_{K_N}(pad_{128}(L)))
+ *
+ * See section 6.4 of the Adiantum paper.  This is an ε-almost-∆-universal
+ * (ε-∆U) hash function for equal-length inputs over Z/(2^{128}Z), where the "∆"
+ * operation is addition.  It hashes 1024-byte chunks of the input with the NH
+ * hash function, reducing the input length by 32x.  The resulting NH hashes are
+ * evaluated as a polynomial in GF(2^{130}-5), like in the Poly1305 MAC.  Note
+ * that the polynomial evaluation by itself would suffice to achieve the ε-∆U
+ * property; NH is used for performance since it's much faster than Poly1305.
+ */
+static void adiantum_hash_message(struct skcipher_request *req,
+				  struct scatterlist *sgl, unsigned int nents,
+				  le128 *out)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
-	struct shash_desc *hash_desc = &rctx->u.hash_desc;
 	struct sg_mapping_iter miter;
 	unsigned int i, n;
-	int err;
 
-	err = crypto_shash_init(hash_desc);
-	if (err)
-		return err;
+	nhpoly1305_init(&rctx->u.hash_ctx);
 
 	sg_miter_start(&miter, sgl, nents, SG_MITER_FROM_SG | SG_MITER_ATOMIC);
 	for (i = 0; i < bulk_len; i += n) {
 		sg_miter_next(&miter);
 		n = min_t(unsigned int, miter.length, bulk_len - i);
-		err = crypto_shash_update(hash_desc, miter.addr, n);
-		if (err)
-			break;
+		nhpoly1305_update(&rctx->u.hash_ctx, tctx, miter.addr, n);
 	}
 	sg_miter_stop(&miter);
-	if (err)
-		return err;
 
-	return crypto_shash_final(hash_desc, (u8 *)digest);
+	nhpoly1305_final(&rctx->u.hash_ctx, tctx, out);
 }
 
 /* Continue Adiantum encryption/decryption after the stream cipher step */
 static int adiantum_finish(struct skcipher_request *req)
 {
@@ -282,11 +400,10 @@ static int adiantum_finish(struct skcipher_request *req)
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
 	struct scatterlist *dst = req->dst;
 	const unsigned int dst_nents = sg_nents(dst);
 	le128 digest;
-	int err;
 
 	/* If decrypting, decrypt C_M with the block cipher to get P_M */
 	if (!rctx->enc)
 		crypto_cipher_decrypt_one(tctx->blockcipher, rctx->rbuf.bytes,
 					  rctx->rbuf.bytes);
@@ -294,32 +411,26 @@ static int adiantum_finish(struct skcipher_request *req)
 	/*
 	 * Second hash step
 	 *	enc: C_R = C_M - H_{K_H}(T, C_L)
 	 *	dec: P_R = P_M - H_{K_H}(T, P_L)
 	 */
-	rctx->u.hash_desc.tfm = tctx->hash;
 	le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
 	if (dst_nents == 1 && dst->offset + req->cryptlen <= PAGE_SIZE) {
 		/* Fast path for single-page destination */
 		struct page *page = sg_page(dst);
 		void *virt = kmap_local_page(page) + dst->offset;
 
-		err = crypto_shash_digest(&rctx->u.hash_desc, virt, bulk_len,
-					  (u8 *)&digest);
-		if (err) {
-			kunmap_local(virt);
-			return err;
-		}
+		nhpoly1305_init(&rctx->u.hash_ctx);
+		nhpoly1305_update(&rctx->u.hash_ctx, tctx, virt, bulk_len);
+		nhpoly1305_final(&rctx->u.hash_ctx, tctx, &digest);
 		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 		memcpy(virt + bulk_len, &rctx->rbuf.bignum, sizeof(le128));
 		flush_dcache_page(page);
 		kunmap_local(virt);
 	} else {
 		/* Slow path that works for any destination scatterlist */
-		err = adiantum_hash_message(req, dst, dst_nents, &digest);
-		if (err)
-			return err;
+		adiantum_hash_message(req, dst, dst_nents, &digest);
 		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 		scatterwalk_map_and_copy(&rctx->rbuf.bignum, dst,
 					 bulk_len, sizeof(le128), 1);
 	}
 	return 0;
@@ -343,11 +454,10 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
 	struct scatterlist *src = req->src;
 	const unsigned int src_nents = sg_nents(src);
 	unsigned int stream_len;
 	le128 digest;
-	int err;
 
 	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
 		return -EINVAL;
 
 	rctx->enc = enc;
@@ -356,27 +466,25 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	 * First hash step
 	 *	enc: P_M = P_R + H_{K_H}(T, P_L)
 	 *	dec: C_M = C_R + H_{K_H}(T, C_L)
 	 */
 	adiantum_hash_header(req);
-	rctx->u.hash_desc.tfm = tctx->hash;
 	if (src_nents == 1 && src->offset + req->cryptlen <= PAGE_SIZE) {
 		/* Fast path for single-page source */
 		void *virt = kmap_local_page(sg_page(src)) + src->offset;
 
-		err = crypto_shash_digest(&rctx->u.hash_desc, virt, bulk_len,
-					  (u8 *)&digest);
+		nhpoly1305_init(&rctx->u.hash_ctx);
+		nhpoly1305_update(&rctx->u.hash_ctx, tctx, virt, bulk_len);
+		nhpoly1305_final(&rctx->u.hash_ctx, tctx, &digest);
 		memcpy(&rctx->rbuf.bignum, virt + bulk_len, sizeof(le128));
 		kunmap_local(virt);
 	} else {
 		/* Slow path that works for any source scatterlist */
-		err = adiantum_hash_message(req, src, src_nents, &digest);
+		adiantum_hash_message(req, src, src_nents, &digest);
 		scatterwalk_map_and_copy(&rctx->rbuf.bignum, src,
 					 bulk_len, sizeof(le128), 0);
 	}
-	if (err)
-		return err;
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
 	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 
 	/* If encrypting, encrypt P_M with the block cipher to get C_M */
 	if (enc)
@@ -429,12 +537,10 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
 	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
 	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *streamcipher;
 	struct crypto_cipher *blockcipher;
-	struct crypto_shash *hash;
-	unsigned int subreq_size;
 	int err;
 
 	streamcipher = crypto_spawn_skcipher(&ictx->streamcipher_spawn);
 	if (IS_ERR(streamcipher))
 		return PTR_ERR(streamcipher);
@@ -443,36 +549,22 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(blockcipher)) {
 		err = PTR_ERR(blockcipher);
 		goto err_free_streamcipher;
 	}
 
-	hash = crypto_spawn_shash(&ictx->hash_spawn);
-	if (IS_ERR(hash)) {
-		err = PTR_ERR(hash);
-		goto err_free_blockcipher;
-	}
-
 	tctx->streamcipher = streamcipher;
 	tctx->blockcipher = blockcipher;
-	tctx->hash = hash;
 
 	BUILD_BUG_ON(offsetofend(struct adiantum_request_ctx, u) !=
 		     sizeof(struct adiantum_request_ctx));
-	subreq_size = max(sizeof_field(struct adiantum_request_ctx,
-				       u.hash_desc) +
-			  crypto_shash_descsize(hash),
-			  sizeof_field(struct adiantum_request_ctx,
-				       u.streamcipher_req) +
-			  crypto_skcipher_reqsize(streamcipher));
-
-	crypto_skcipher_set_reqsize(tfm,
-				    offsetof(struct adiantum_request_ctx, u) +
-				    subreq_size);
+	crypto_skcipher_set_reqsize(
+		tfm, max(sizeof(struct adiantum_request_ctx),
+			 offsetofend(struct adiantum_request_ctx,
+				     u.streamcipher_req) +
+				 crypto_skcipher_reqsize(streamcipher)));
 	return 0;
 
-err_free_blockcipher:
-	crypto_free_cipher(blockcipher);
 err_free_streamcipher:
 	crypto_free_skcipher(streamcipher);
 	return err;
 }
 
@@ -480,30 +572,28 @@ static void adiantum_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_skcipher(tctx->streamcipher);
 	crypto_free_cipher(tctx->blockcipher);
-	crypto_free_shash(tctx->hash);
 }
 
 static void adiantum_free_instance(struct skcipher_instance *inst)
 {
 	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ictx->streamcipher_spawn);
 	crypto_drop_cipher(&ictx->blockcipher_spawn);
-	crypto_drop_shash(&ictx->hash_spawn);
 	kfree(inst);
 }
 
 /*
  * Check for a supported set of inner algorithms.
  * See the comment at the beginning of this file.
  */
-static bool adiantum_supported_algorithms(struct skcipher_alg_common *streamcipher_alg,
-					  struct crypto_alg *blockcipher_alg,
-					  struct shash_alg *hash_alg)
+static bool
+adiantum_supported_algorithms(struct skcipher_alg_common *streamcipher_alg,
+			      struct crypto_alg *blockcipher_alg)
 {
 	if (strcmp(streamcipher_alg->base.cra_name, "xchacha12") != 0 &&
 	    strcmp(streamcipher_alg->base.cra_name, "xchacha20") != 0)
 		return false;
 
@@ -511,25 +601,20 @@ static bool adiantum_supported_algorithms(struct skcipher_alg_common *streamciph
 	    blockcipher_alg->cra_cipher.cia_max_keysize < BLOCKCIPHER_KEY_SIZE)
 		return false;
 	if (blockcipher_alg->cra_blocksize != BLOCKCIPHER_BLOCK_SIZE)
 		return false;
 
-	if (strcmp(hash_alg->base.cra_name, "nhpoly1305") != 0)
-		return false;
-
 	return true;
 }
 
 static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	u32 mask;
-	const char *nhpoly1305_name;
 	struct skcipher_instance *inst;
 	struct adiantum_instance_ctx *ictx;
 	struct skcipher_alg_common *streamcipher_alg;
 	struct crypto_alg *blockcipher_alg;
-	struct shash_alg *hash_alg;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return err;
@@ -553,27 +638,25 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 				 crypto_attr_alg_name(tb[2]), 0, mask);
 	if (err)
 		goto err_free_inst;
 	blockcipher_alg = crypto_spawn_cipher_alg(&ictx->blockcipher_spawn);
 
-	/* NHPoly1305 ε-∆U hash function */
-	nhpoly1305_name = crypto_attr_alg_name(tb[3]);
-	if (nhpoly1305_name == ERR_PTR(-ENOENT))
-		nhpoly1305_name = "nhpoly1305";
-	err = crypto_grab_shash(&ictx->hash_spawn,
-				skcipher_crypto_instance(inst),
-				nhpoly1305_name, 0, mask);
-	if (err)
+	/*
+	 * Originally there was an optional third parameter, for requesting a
+	 * specific implementation of "nhpoly1305" for message hashing.  This is
+	 * no longer supported.  The best implementation is just always used.
+	 */
+	if (crypto_attr_alg_name(tb[3]) != ERR_PTR(-ENOENT)) {
+		err = -ENOENT;
 		goto err_free_inst;
-	hash_alg = crypto_spawn_shash_alg(&ictx->hash_spawn);
+	}
 
 	/* Check the set of algorithms */
-	if (!adiantum_supported_algorithms(streamcipher_alg, blockcipher_alg,
-					   hash_alg)) {
-		pr_warn("Unsupported Adiantum instantiation: (%s,%s,%s)\n",
+	if (!adiantum_supported_algorithms(streamcipher_alg, blockcipher_alg)) {
+		pr_warn("Unsupported Adiantum instantiation: (%s,%s)\n",
 			streamcipher_alg->base.cra_name,
-			blockcipher_alg->cra_name, hash_alg->base.cra_name);
+			blockcipher_alg->cra_name);
 		err = -EINVAL;
 		goto err_free_inst;
 	}
 
 	/* Instance fields */
@@ -582,28 +665,26 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "adiantum(%s,%s)", streamcipher_alg->base.cra_name,
 		     blockcipher_alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "adiantum(%s,%s,%s)",
-		     streamcipher_alg->base.cra_driver_name,
-		     blockcipher_alg->cra_driver_name,
-		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		     "adiantum(%s,%s)", streamcipher_alg->base.cra_driver_name,
+		     blockcipher_alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
 	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask;
 	/*
 	 * The block cipher is only invoked once per message, so for long
 	 * messages (e.g. sectors for disk encryption) its performance doesn't
-	 * matter as much as that of the stream cipher and hash function.  Thus,
-	 * weigh the block cipher's ->cra_priority less.
+	 * matter as much as that of the stream cipher.  Thus, weigh the block
+	 * cipher's ->cra_priority less.
 	 */
 	inst->alg.base.cra_priority = (4 * streamcipher_alg->base.cra_priority +
-				       2 * hash_alg->base.cra_priority +
-				       blockcipher_alg->cra_priority) / 7;
+				       blockcipher_alg->cra_priority) /
+				      5;
 
 	inst->alg.setkey = adiantum_setkey;
 	inst->alg.encrypt = adiantum_encrypt;
 	inst->alg.decrypt = adiantum_decrypt;
 	inst->alg.init = adiantum_init_tfm;
@@ -620,11 +701,11 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		adiantum_free_instance(inst);
 	}
 	return err;
 }
 
-/* adiantum(streamcipher_name, blockcipher_name [, nhpoly1305_name]) */
+/* adiantum(streamcipher_name, blockcipher_name) */
 static struct crypto_template adiantum_tmpl = {
 	.name = "adiantum",
 	.create = adiantum_create,
 	.module = THIS_MODULE,
 };
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a302be53896d..d9fc671d5941 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4059,18 +4059,18 @@ static int alg_test_null(const struct alg_test_desc *desc,
 
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "adiantum(xchacha12,aes)",
-		.generic_driver = "adiantum(xchacha12-lib,aes-generic,nhpoly1305-generic)",
+		.generic_driver = "adiantum(xchacha12-lib,aes-generic)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(adiantum_xchacha12_aes_tv_template)
 		},
 	}, {
 		.alg = "adiantum(xchacha20,aes)",
-		.generic_driver = "adiantum(xchacha20-lib,aes-generic,nhpoly1305-generic)",
+		.generic_driver = "adiantum(xchacha20-lib,aes-generic)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(adiantum_xchacha20_aes_tv_template)
 		},
 	}, {
-- 
2.52.0

