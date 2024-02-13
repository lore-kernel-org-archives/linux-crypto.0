Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DF9224FD
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815822; cv=none; b=vCcj6E9RONAwqUIbDuE4m9LSAvQsaqOoU8YIWVK2z3DPj5xcPkAEG1wHv82BXK6ra1ZpZAiErwd4EWz65UTTmdlI83jrAYSwVl582H+GAbRE86od7kQfaF/tlh0mdeBcsfQNogGP/krZQt3uEyVWDctUkR/xuYy7Hr04AzGnPk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815822; c=relaxed/simple;
	bh=+AQ5fApyH88ibA/3YdksNWIr5Xd7cMcNaMPrU4kS+70=;
	h=Message-Id:In-Reply-To:References:From:Date:Subject:To; b=nRJ4Q5nBBecC2U8rAkvE0vVTUkjWyc/aKJMLYRx/WFUnV6lW7c2nsgZ6QksjOi2KQ/Wy/0cwm4AIS2m4+i/niThqaTgw7lKMShzajcaBNJLZbci12K8bBPPZhwWxN4qXcec/ihhEolVfvfasc/z3r7VOfyVOwEHs/QapCYyW//8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZouN-00D1ug-Ay; Tue, 13 Feb 2024 17:16:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:17:09 +0800
Message-Id: <2d2b69d88cf5fea1b00b35853edc6dd7830dfa4f.1707815065.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1707815065.git.herbert@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 13 Feb 2024 16:48:11 +0800
Subject: [PATCH 15/15] crypto: adiantum - Convert from skcipher to lskcipher
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Replace skcipher implementation with lskcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/adiantum.c | 471 ++++++++++++++++++++++------------------------
 1 file changed, 222 insertions(+), 249 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index ee55b1f8565c..8ee48393c5c5 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -61,47 +61,45 @@
 #define TWEAK_SIZE		32
 
 struct adiantum_instance_ctx {
-	struct crypto_skcipher_spawn streamcipher_spawn;
+	struct crypto_lskcipher_spawn streamcipher_spawn;
 	struct crypto_lskcipher_spawn blockcipher_spawn;
 	struct crypto_shash_spawn hash_spawn;
 };
 
 struct adiantum_tfm_ctx {
-	struct crypto_skcipher *streamcipher;
+	struct crypto_lskcipher *streamcipher;
 	struct crypto_lskcipher *blockcipher;
 	struct crypto_shash *hash;
 	struct poly1305_core_key header_hash_key;
 };
 
-struct adiantum_request_ctx {
+/*
+ * Buffer for right-hand part of data, i.e.
+ *
+ *    P_L => P_M => C_M => C_R when encrypting, or
+ *    C_R => C_M => P_M => P_L when decrypting.
+ *
+ * Also used to build the IV for the stream cipher.
+ */
+union adiantum_rbuf {
+	u8 bytes[XCHACHA_IV_SIZE];
+	__le32 words[XCHACHA_IV_SIZE / sizeof(__le32)];
+	le128 bignum;	/* interpret as element of Z/(2^{128}Z) */
+};
 
+struct adiantum_state {
 	/*
-	 * Buffer for right-hand part of data, i.e.
-	 *
-	 *    P_L => P_M => C_M => C_R when encrypting, or
-	 *    C_R => C_M => P_M => P_L when decrypting.
-	 *
-	 * Also used to build the IV for the stream cipher.
-	 */
-	union {
-		u8 bytes[XCHACHA_IV_SIZE];
-		__le32 words[XCHACHA_IV_SIZE / sizeof(__le32)];
-		le128 bignum;	/* interpret as element of Z/(2^{128}Z) */
-	} rbuf;
-
-	bool enc; /* true if encrypting, false if decrypting */
-
-	/*
-	 * The result of the Poly1305 ε-∆U hash function applied to
+	 * The result of the Poly1305 \u03b5-\u2206U hash function applied to
 	 * (bulk length, tweak)
 	 */
 	le128 header_hash;
 
+	unsigned int bulk_len;
+	bool secondpass;
+	bool secondinit;
+
 	/* Sub-requests, must be last */
-	union {
-		struct shash_desc hash_desc;
-		struct skcipher_request streamcipher_req;
-	} u;
+	struct shash_desc hash_desc;
 };
 
 /*
@@ -113,44 +111,34 @@ struct adiantum_request_ctx {
  * Note that this denotes using bits from the XChaCha keystream, which here we
  * get indirectly by encrypting a buffer containing all 0's.
  */
-static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
+static int adiantum_setkey(struct crypto_lskcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
-	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct adiantum_tfm_ctx *tctx = crypto_lskcipher_ctx(tfm);
 	struct {
-		u8 iv[XCHACHA_IV_SIZE];
 		u8 derived_keys[BLOCKCIPHER_KEY_SIZE + HASH_KEY_SIZE];
-		struct scatterlist sg;
-		struct crypto_wait wait;
-		struct skcipher_request req; /* must be last */
+		u8 iv[XCHACHA_IV_SIZE];
 	} *data;
 	u8 *keyp;
 	int err;
 
 	/* Set the stream cipher key (K_S) */
-	crypto_skcipher_clear_flags(tctx->streamcipher, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(tctx->streamcipher,
-				  crypto_skcipher_get_flags(tfm) &
-				  CRYPTO_TFM_REQ_MASK);
-	err = crypto_skcipher_setkey(tctx->streamcipher, key, keylen);
+	crypto_lskcipher_clear_flags(tctx->streamcipher, CRYPTO_TFM_REQ_MASK);
+	crypto_lskcipher_set_flags(tctx->streamcipher,
+				   crypto_lskcipher_get_flags(tfm) &
+				   CRYPTO_TFM_REQ_MASK);
+	err = crypto_lskcipher_setkey(tctx->streamcipher, key, keylen);
 	if (err)
 		return err;
 
 	/* Derive the subkeys */
-	data = kzalloc(sizeof(*data) +
-		       crypto_skcipher_reqsize(tctx->streamcipher), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_ATOMIC);
 	if (!data)
 		return -ENOMEM;
 	data->iv[0] = 1;
-	sg_init_one(&data->sg, data->derived_keys, sizeof(data->derived_keys));
-	crypto_init_wait(&data->wait);
-	skcipher_request_set_tfm(&data->req, tctx->streamcipher);
-	skcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
-						  CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      crypto_req_done, &data->wait);
-	skcipher_request_set_crypt(&data->req, &data->sg, &data->sg,
-				   sizeof(data->derived_keys), data->iv);
-	err = crypto_wait_req(crypto_skcipher_encrypt(&data->req), &data->wait);
+	err = crypto_lskcipher_encrypt(tctx->streamcipher, data->derived_keys,
+				       data->derived_keys,
+				       sizeof(data->derived_keys), data->iv);
 	if (err)
 		goto out;
 	keyp = data->derived_keys;
@@ -158,7 +146,7 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	/* Set the block cipher key (K_E) */
 	crypto_lskcipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
 	crypto_lskcipher_set_flags(tctx->blockcipher,
-				   crypto_skcipher_get_flags(tfm) &
+				   crypto_lskcipher_get_flags(tfm) &
 				   CRYPTO_TFM_REQ_MASK);
 	err = crypto_lskcipher_setkey(tctx->blockcipher, keyp,
 				     BLOCKCIPHER_KEY_SIZE);
@@ -171,7 +159,7 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	keyp += POLY1305_BLOCK_SIZE;
 
 	crypto_shash_clear_flags(tctx->hash, CRYPTO_TFM_REQ_MASK);
-	crypto_shash_set_flags(tctx->hash, crypto_skcipher_get_flags(tfm) &
+	crypto_shash_set_flags(tctx->hash, crypto_lskcipher_get_flags(tfm) &
 					   CRYPTO_TFM_REQ_MASK);
 	err = crypto_shash_setkey(tctx->hash, keyp, NHPOLY1305_KEY_SIZE);
 	keyp += NHPOLY1305_KEY_SIZE;
@@ -205,7 +193,7 @@ static inline void le128_sub(le128 *r, const le128 *v1, const le128 *v2)
 
 /*
  * Apply the Poly1305 ε-∆U hash function to (bulk length, tweak) and save the
- * result to rctx->header_hash.  This is the calculation
+ * result to state->header_hash.  This is the calculation
  *
  *	H_T ← Poly1305_{K_T}(bin_{128}(|L|) || T)
  *
@@ -215,12 +203,11 @@ static inline void le128_sub(le128 *r, const le128 *v1, const le128 *v2)
  * inputs only) taken over the left-hand part (the "bulk") of the message, to
  * give the overall Adiantum hash of the (tweak, left-hand part) pair.
  */
-static void adiantum_hash_header(struct skcipher_request *req)
+static void adiantum_hash_header(struct crypto_lskcipher *tfm,
+				 struct adiantum_state *astate, u8 *iv)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
-	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	const struct adiantum_tfm_ctx *tctx = crypto_lskcipher_ctx(tfm);
+	const unsigned int bulk_len = astate->bulk_len;
 	struct {
 		__le64 message_bits;
 		__le64 padding;
@@ -236,157 +223,98 @@ static void adiantum_hash_header(struct skcipher_request *req)
 			     &header, sizeof(header) / POLY1305_BLOCK_SIZE, 1);
 
 	BUILD_BUG_ON(TWEAK_SIZE % POLY1305_BLOCK_SIZE != 0);
-	poly1305_core_blocks(&state, &tctx->header_hash_key, req->iv,
+	poly1305_core_blocks(&state, &tctx->header_hash_key, iv,
 			     TWEAK_SIZE / POLY1305_BLOCK_SIZE, 1);
 
-	poly1305_core_emit(&state, NULL, &rctx->header_hash);
-}
-
-/* Hash the left-hand part (the "bulk") of the message using NHPoly1305 */
-static int adiantum_hash_message(struct skcipher_request *req,
-				 struct scatterlist *sgl, unsigned int nents,
-				 le128 *digest)
-{
-	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
-	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
-	struct shash_desc *hash_desc = &rctx->u.hash_desc;
-	struct sg_mapping_iter miter;
-	unsigned int i, n;
-	int err;
-
-	err = crypto_shash_init(hash_desc);
-	if (err)
-		return err;
-
-	sg_miter_start(&miter, sgl, nents, SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	for (i = 0; i < bulk_len; i += n) {
-		sg_miter_next(&miter);
-		n = min_t(unsigned int, miter.length, bulk_len - i);
-		err = crypto_shash_update(hash_desc, miter.addr, n);
-		if (err)
-			break;
-	}
-	sg_miter_stop(&miter);
-	if (err)
-		return err;
-
-	return crypto_shash_final(hash_desc, (u8 *)digest);
+	poly1305_core_emit(&state, NULL, &astate->header_hash);
 }
 
 /* Continue Adiantum encryption/decryption after the stream cipher step */
-static int adiantum_finish(struct skcipher_request *req)
+static int adiantum_finish(struct adiantum_state *state,
+			   union adiantum_rbuf *subsiv, le128 *digest,
+			   u8 *dst)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
-	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
-	struct scatterlist *dst = req->dst;
-	const unsigned int dst_nents = sg_nents(dst);
-	le128 digest;
-	int err;
-
-	/* If decrypting, decrypt C_M with the block cipher to get P_M */
-	if (!rctx->enc) {
-		err = crypto_lskcipher_decrypt(tctx->blockcipher,
-					       rctx->rbuf.bytes,
-					       rctx->rbuf.bytes,
-					       BLOCKCIPHER_BLOCK_SIZE, NULL);
-		if (err)
-			return err;
-	}
-
 	/*
 	 * Second hash step
 	 *	enc: C_R = C_M - H_{K_H}(T, C_L)
 	 *	dec: P_R = P_M - H_{K_H}(T, P_L)
 	 */
-	rctx->u.hash_desc.tfm = tctx->hash;
-	le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
-	if (dst_nents == 1 && dst->offset + req->cryptlen <= PAGE_SIZE) {
-		/* Fast path for single-page destination */
-		struct page *page = sg_page(dst);
-		void *virt = kmap_local_page(page) + dst->offset;
-
-		err = crypto_shash_digest(&rctx->u.hash_desc, virt, bulk_len,
-					  (u8 *)&digest);
-		if (err) {
-			kunmap_local(virt);
-			return err;
-		}
-		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
-		memcpy(virt + bulk_len, &rctx->rbuf.bignum, sizeof(le128));
-		flush_dcache_page(page);
-		kunmap_local(virt);
-	} else {
-		/* Slow path that works for any destination scatterlist */
-		err = adiantum_hash_message(req, dst, dst_nents, &digest);
-		if (err)
-			return err;
-		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
-		scatterwalk_map_and_copy(&rctx->rbuf.bignum, dst,
-					 bulk_len, sizeof(le128), 1);
-	}
+	le128_sub(&subsiv->bignum, &subsiv->bignum, &state->header_hash);
+	le128_sub(&subsiv->bignum, &subsiv->bignum, digest);
+	memcpy(dst, &subsiv->bignum, sizeof(le128));
 	return 0;
 }
 
-static void adiantum_streamcipher_done(void *data, int err)
+static int adiantum_crypt(struct crypto_lskcipher *tfm, const u8 *src,
+			  u8 *dst, unsigned nbytes, u8 *siv, u32 flags,
+			  bool enc)
 {
-	struct skcipher_request *req = data;
-
-	if (!err)
-		err = adiantum_finish(req);
-
-	skcipher_request_complete(req, err);
-}
-
-static int adiantum_crypt(struct skcipher_request *req, bool enc)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
-	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
-	struct scatterlist *src = req->src;
-	const unsigned int src_nents = sg_nents(src);
-	unsigned int stream_len;
+	const struct adiantum_tfm_ctx *tctx = crypto_lskcipher_ctx(tfm);
+	struct adiantum_state *state = (void *)(siv + TWEAK_SIZE);
+	union adiantum_rbuf *subsiv;
+	unsigned int bulk_len;
 	le128 digest;
 	int err;
 
-	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
+	state = PTR_ALIGN(state, __alignof__(*state));
+	subsiv = (union adiantum_rbuf *)
+		 ((u8 *)shash_desc_ctx(&state->hash_desc) +
+		  crypto_shash_descsize(tctx->hash));
+
+	if (nbytes < BLOCKCIPHER_BLOCK_SIZE)
 		return -EINVAL;
 
-	rctx->enc = enc;
+	bulk_len = nbytes;
+	if ((flags & CRYPTO_LSKCIPHER_FLAG_FINAL))
+		bulk_len -= BLOCKCIPHER_BLOCK_SIZE;
+
+	if ((flags & CRYPTO_LSKCIPHER_FLAG_CONT)) {
+		if (state->secondpass)
+			goto secondpass;
+
+		if (state->bulk_len + bulk_len < state->bulk_len)
+			return -EOVERFLOW;
+
+		state->bulk_len += bulk_len;
+	} else {
+		state->bulk_len = bulk_len;
+		state->secondpass = false;
+		state->hash_desc.tfm = tctx->hash;
+
+		if (!(flags & CRYPTO_LSKCIPHER_FLAG_FINAL)) {
+			err = crypto_shash_init(&state->hash_desc);
+			if (err)
+				return err;
+		}
+	}
+
+	if (!(flags & CRYPTO_LSKCIPHER_FLAG_FINAL))
+		return crypto_shash_update(&state->hash_desc, src, bulk_len);
+
+	if ((flags & CRYPTO_LSKCIPHER_FLAG_CONT))
+		err = crypto_shash_finup(&state->hash_desc, src,
+					 bulk_len, (u8 *)&digest);
+	else
+		err = crypto_shash_digest(&state->hash_desc, src,
+					  bulk_len, (u8 *)&digest);
+	if (err)
+		return err;
 
 	/*
 	 * First hash step
 	 *	enc: P_M = P_R + H_{K_H}(T, P_L)
 	 *	dec: C_M = C_R + H_{K_H}(T, C_L)
 	 */
-	adiantum_hash_header(req);
-	rctx->u.hash_desc.tfm = tctx->hash;
-	if (src_nents == 1 && src->offset + req->cryptlen <= PAGE_SIZE) {
-		/* Fast path for single-page source */
-		void *virt = kmap_local_page(sg_page(src)) + src->offset;
-
-		err = crypto_shash_digest(&rctx->u.hash_desc, virt, bulk_len,
-					  (u8 *)&digest);
-		memcpy(&rctx->rbuf.bignum, virt + bulk_len, sizeof(le128));
-		kunmap_local(virt);
-	} else {
-		/* Slow path that works for any source scatterlist */
-		err = adiantum_hash_message(req, src, src_nents, &digest);
-		scatterwalk_map_and_copy(&rctx->rbuf.bignum, src,
-					 bulk_len, sizeof(le128), 0);
-	}
-	if (err)
-		return err;
-	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
-	le128_add(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
+	memcpy(&subsiv->bignum, src + bulk_len, sizeof(le128));
+	adiantum_hash_header(tfm, state, siv);
+	le128_add(&subsiv->bignum, &subsiv->bignum, &state->header_hash);
+	le128_add(&subsiv->bignum, &subsiv->bignum, &digest);
 
 	/* If encrypting, encrypt P_M with the block cipher to get C_M */
 	if (enc) {
 		err = crypto_lskcipher_encrypt(tctx->blockcipher,
-					       rctx->rbuf.bytes,
-					       rctx->rbuf.bytes,
+					       subsiv->bytes,
+					       subsiv->bytes,
 					       BLOCKCIPHER_BLOCK_SIZE, NULL);
 		if (err)
 			return err;
@@ -395,10 +323,22 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	/* Initialize the rest of the XChaCha IV (first part is C_M) */
 	BUILD_BUG_ON(BLOCKCIPHER_BLOCK_SIZE != 16);
 	BUILD_BUG_ON(XCHACHA_IV_SIZE != 32);	/* nonce || stream position */
-	rctx->rbuf.words[4] = cpu_to_le32(1);
-	rctx->rbuf.words[5] = 0;
-	rctx->rbuf.words[6] = 0;
-	rctx->rbuf.words[7] = 0;
+	subsiv->words[4] = cpu_to_le32(1);
+	subsiv->words[5] = 0;
+	subsiv->words[6] = 0;
+	subsiv->words[7] = 0;
+
+	state->secondpass = true;
+	state->secondinit = true;
+
+	if ((flags & CRYPTO_LSKCIPHER_FLAG_CONT))
+		return 0;
+
+secondpass:
+	if (state->secondinit) {
+		state->secondinit = false;
+		flags &= ~CRYPTO_LSKCIPHER_FLAG_CONT;
+	}
 
 	/*
 	 * XChaCha needs to be done on all the data except the last 16 bytes;
@@ -409,42 +349,69 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	 * as the second hash step will overwrite them.  Thus, round the XChaCha
 	 * length up to the next 64-byte boundary if possible.
 	 */
-	stream_len = bulk_len;
-	if (round_up(stream_len, CHACHA_BLOCK_SIZE) <= req->cryptlen)
-		stream_len = round_up(stream_len, CHACHA_BLOCK_SIZE);
+	err = crypto_lskcipher_encrypt_ext(tctx->streamcipher, src, dst,
+					   nbytes, subsiv->bytes, flags);
+	if (err < 0)
+		return err;
 
-	skcipher_request_set_tfm(&rctx->u.streamcipher_req, tctx->streamcipher);
-	skcipher_request_set_crypt(&rctx->u.streamcipher_req, req->src,
-				   req->dst, stream_len, &rctx->rbuf);
-	skcipher_request_set_callback(&rctx->u.streamcipher_req,
-				      req->base.flags,
-				      adiantum_streamcipher_done, req);
-	return crypto_skcipher_encrypt(&rctx->u.streamcipher_req) ?:
-		adiantum_finish(req);
+	if (!(flags & CRYPTO_LSKCIPHER_FLAG_FINAL)) {
+		bulk_len -= err;
+
+		if (!(flags & CRYPTO_LSKCIPHER_FLAG_CONT)) {
+			err = crypto_shash_init(&state->hash_desc);
+			if (err)
+				return err;
+		}
+		return crypto_shash_update(&state->hash_desc, dst, bulk_len) ?:
+		       nbytes - bulk_len;
+	}
+
+	if ((flags & CRYPTO_LSKCIPHER_FLAG_CONT))
+		err = crypto_shash_finup(&state->hash_desc, dst,
+					  bulk_len, (u8 *)&digest);
+	else
+		err = crypto_shash_digest(&state->hash_desc, dst,
+					  bulk_len, (u8 *)&digest);
+
+	if (err)
+		return err;
+
+	/* If decrypting, decrypt C_M with the block cipher to get P_M */
+	if (!enc) {
+		err = crypto_lskcipher_decrypt(tctx->blockcipher,
+					       subsiv->bytes,
+					       subsiv->bytes,
+					       BLOCKCIPHER_BLOCK_SIZE, NULL);
+		if (err)
+			return err;
+	}
+
+	return adiantum_finish(state, subsiv, &digest, dst + bulk_len);
 }
 
-static int adiantum_encrypt(struct skcipher_request *req)
+static int adiantum_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			    u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
 {
-	return adiantum_crypt(req, true);
+	return adiantum_crypt(tfm, src, dst, nbytes, siv, flags, true);
 }
 
-static int adiantum_decrypt(struct skcipher_request *req)
+static int adiantum_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
+			    u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
 {
-	return adiantum_crypt(req, false);
+	return adiantum_crypt(tfm, src, dst, nbytes, siv, flags, false);
 }
 
-static int adiantum_init_tfm(struct crypto_skcipher *tfm)
+static int adiantum_init_tfm(struct crypto_lskcipher *tfm)
 {
-	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
-	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *streamcipher;
+	struct lskcipher_instance *inst = lskcipher_alg_instance(tfm);
+	struct adiantum_instance_ctx *ictx = lskcipher_instance_ctx(inst);
+	struct adiantum_tfm_ctx *tctx = crypto_lskcipher_ctx(tfm);
+	struct crypto_lskcipher *streamcipher;
 	struct crypto_lskcipher *blockcipher;
 	struct crypto_shash *hash;
-	unsigned int subreq_size;
 	int err;
 
-	streamcipher = crypto_spawn_skcipher(&ictx->streamcipher_spawn);
+	streamcipher = crypto_spawn_lskcipher(&ictx->streamcipher_spawn);
 	if (IS_ERR(streamcipher))
 		return PTR_ERR(streamcipher);
 
@@ -460,45 +427,39 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 		goto err_free_blockcipher;
 	}
 
+	err = -EINVAL;
+	if (crypto_shash_descsize(hash) > crypto_shash_alg(hash)->descsize)
+		goto err_free_hash;
+
 	tctx->streamcipher = streamcipher;
 	tctx->blockcipher = blockcipher;
 	tctx->hash = hash;
 
-	BUILD_BUG_ON(offsetofend(struct adiantum_request_ctx, u) !=
-		     sizeof(struct adiantum_request_ctx));
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
 	return 0;
 
+err_free_hash:
+	crypto_free_shash(hash);
 err_free_blockcipher:
 	crypto_free_lskcipher(blockcipher);
 err_free_streamcipher:
-	crypto_free_skcipher(streamcipher);
+	crypto_free_lskcipher(streamcipher);
 	return err;
 }
 
-static void adiantum_exit_tfm(struct crypto_skcipher *tfm)
+static void adiantum_exit_tfm(struct crypto_lskcipher *tfm)
 {
-	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct adiantum_tfm_ctx *tctx = crypto_lskcipher_ctx(tfm);
 
-	crypto_free_skcipher(tctx->streamcipher);
+	crypto_free_lskcipher(tctx->streamcipher);
 	crypto_free_lskcipher(tctx->blockcipher);
 	crypto_free_shash(tctx->hash);
 }
 
-static void adiantum_free_instance(struct skcipher_instance *inst)
+static void adiantum_free_instance(struct lskcipher_instance *inst)
 {
-	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
+	struct adiantum_instance_ctx *ictx = lskcipher_instance_ctx(inst);
 
-	crypto_drop_skcipher(&ictx->streamcipher_spawn);
+	crypto_drop_lskcipher(&ictx->streamcipher_spawn);
 	crypto_drop_lskcipher(&ictx->blockcipher_spawn);
 	crypto_drop_shash(&ictx->hash_spawn);
 	kfree(inst);
@@ -508,12 +469,12 @@ static void adiantum_free_instance(struct skcipher_instance *inst)
  * Check for a supported set of inner algorithms.
  * See the comment at the beginning of this file.
  */
-static bool adiantum_supported_algorithms(struct skcipher_alg_common *streamcipher_alg,
+static bool adiantum_supported_algorithms(struct lskcipher_alg *streamcipher_alg,
 					  struct lskcipher_alg *blockcipher_alg,
 					  struct shash_alg *hash_alg)
 {
-	if (strcmp(streamcipher_alg->base.cra_name, "xchacha12") != 0 &&
-	    strcmp(streamcipher_alg->base.cra_name, "xchacha20") != 0)
+	if (strcmp(streamcipher_alg->co.base.cra_name, "xchacha12") != 0 &&
+	    strcmp(streamcipher_alg->co.base.cra_name, "xchacha20") != 0)
 		return false;
 
 	if (blockcipher_alg->co.min_keysize > BLOCKCIPHER_KEY_SIZE ||
@@ -536,9 +497,9 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	u32 mask;
 	const char *nhpoly1305_name;
-	struct skcipher_instance *inst;
+	struct lskcipher_instance *inst;
 	struct adiantum_instance_ctx *ictx;
-	struct skcipher_alg_common *streamcipher_alg;
+	struct lskcipher_alg *streamcipher_alg;
 	char ecb_driver_name[CRYPTO_MAX_ALG_NAME];
 	struct lskcipher_alg *blockcipher_alg;
 	char ecb_name[CRYPTO_MAX_ALG_NAME];
@@ -547,28 +508,28 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	const char *cipher_name;
 	int err;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_LSKCIPHER, &mask);
 	if (err)
 		return err;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
-	ictx = skcipher_instance_ctx(inst);
+	ictx = lskcipher_instance_ctx(inst);
 
 	/* Stream cipher, e.g. "xchacha12" */
-	err = crypto_grab_skcipher(&ictx->streamcipher_spawn,
-				   skcipher_crypto_instance(inst),
-				   crypto_attr_alg_name(tb[1]), 0, mask);
+	err = crypto_grab_lskcipher(&ictx->streamcipher_spawn,
+				    lskcipher_crypto_instance(inst),
+				    crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
-	streamcipher_alg = crypto_spawn_skcipher_alg_common(&ictx->streamcipher_spawn);
+	streamcipher_alg = crypto_spawn_lskcipher_alg(&ictx->streamcipher_spawn);
 
 	/* Block cipher, e.g. "aes" */
 	cipher_name = crypto_attr_alg_name(tb[2]);
 	cipher_driver_name = cipher_name;
 	err = crypto_grab_lskcipher(&ictx->blockcipher_spawn,
-				    skcipher_crypto_instance(inst),
+				    lskcipher_crypto_instance(inst),
 				    cipher_name, 0, mask);
 
 	ecb_name[0] = 0;
@@ -579,7 +540,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 			goto err_free_inst;
 
 		err = crypto_grab_lskcipher(&ictx->blockcipher_spawn,
-					    skcipher_crypto_instance(inst),
+					    lskcipher_crypto_instance(inst),
 					    ecb_name, 0, mask);
 	}
 
@@ -592,7 +553,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (nhpoly1305_name == ERR_PTR(-ENOENT))
 		nhpoly1305_name = "nhpoly1305";
 	err = crypto_grab_shash(&ictx->hash_spawn,
-				skcipher_crypto_instance(inst),
+				lskcipher_crypto_instance(inst),
 				nhpoly1305_name, 0, mask);
 	if (err)
 		goto err_free_inst;
@@ -602,7 +563,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!adiantum_supported_algorithms(streamcipher_alg, blockcipher_alg,
 					   hash_alg)) {
 		pr_warn("Unsupported Adiantum instantiation: (%s,%s,%s)\n",
-			streamcipher_alg->base.cra_name,
+			streamcipher_alg->co.base.cra_name,
 			blockcipher_alg->co.base.cra_name,
 			hash_alg->base.cra_name);
 		err = -EINVAL;
@@ -641,43 +602,55 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	}
 
 	err = -ENAMETOOLONG;
-	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "adiantum(%s,%s)", streamcipher_alg->base.cra_name,
+	if (snprintf(inst->alg.co.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "adiantum(%s,%s)", streamcipher_alg->co.base.cra_name,
 		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
-	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+	if (snprintf(inst->alg.co.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "adiantum(%s,%s,%s)",
-		     streamcipher_alg->base.cra_driver_name,
+		     streamcipher_alg->co.base.cra_driver_name,
 		     cipher_driver_name,
 		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
-	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
-	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask;
+	inst->alg.co.base.cra_blocksize = 1;
+	inst->alg.co.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
+	inst->alg.co.base.cra_alignmask = streamcipher_alg->co.base.cra_alignmask;
 	/*
 	 * The block cipher is only invoked once per message, so for long
 	 * messages (e.g. sectors for disk encryption) its performance doesn't
 	 * matter as much as that of the stream cipher and hash function.  Thus,
 	 * weigh the block cipher's ->cra_priority less.
 	 */
-	inst->alg.base.cra_priority = (4 * streamcipher_alg->base.cra_priority +
-				       2 * hash_alg->base.cra_priority +
-				       blockcipher_alg->co.base.cra_priority) / 7;
+	inst->alg.co.base.cra_priority = (4 * streamcipher_alg->co.base.cra_priority +
+					 2 * hash_alg->base.cra_priority +
+					 blockcipher_alg->co.base.cra_priority) / 7;
 
 	inst->alg.setkey = adiantum_setkey;
 	inst->alg.encrypt = adiantum_encrypt;
 	inst->alg.decrypt = adiantum_decrypt;
 	inst->alg.init = adiantum_init_tfm;
 	inst->alg.exit = adiantum_exit_tfm;
-	inst->alg.min_keysize = streamcipher_alg->min_keysize;
-	inst->alg.max_keysize = streamcipher_alg->max_keysize;
-	inst->alg.ivsize = TWEAK_SIZE;
+	inst->alg.co.min_keysize = streamcipher_alg->co.min_keysize;
+	inst->alg.co.max_keysize = streamcipher_alg->co.max_keysize;
+	inst->alg.co.ivsize = TWEAK_SIZE;
+	inst->alg.co.chunksize = streamcipher_alg->co.chunksize;
+	inst->alg.co.tailsize = streamcipher_alg->co.chunksize * 2;
+
+	BUILD_BUG_ON(offsetofend(struct adiantum_state, hash_desc) !=
+		     sizeof(struct adiantum_state));
+
+	inst->alg.co.statesize = sizeof(struct adiantum_state) +
+				 hash_alg->descsize +
+				 streamcipher_alg->co.ivsize +
+				 streamcipher_alg->co.statesize +
+				 ((__alignof__(struct adiantum_state) - 1) &
+				  ~streamcipher_alg->co.base.cra_alignmask);
 	inst->alg.co.twopass = true;
 
 	inst->free = adiantum_free_instance;
 
-	err = skcipher_register_instance(tmpl, inst);
+	err = lskcipher_register_instance(tmpl, inst);
 	if (err) {
 err_free_inst:
 		adiantum_free_instance(inst);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

