Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96AE34AB17;
	Thu, 19 Mar 2026 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901161; cv=none; b=WO39TQ5V9ie02QXYQthj2P+G0owrwnexxGKUFmA20n/OH7QfCDW0LzjwRJudUHb0dmoUNWk577QCxy5hSM786iOgDC2jue4HsaGce3qdRb69rVRzyROhnQ2xn0eo8Hv6C3PbMLw3WIzr1Zvaaq4EcdCeO98rhEcTYf37mtcTC/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901161; c=relaxed/simple;
	bh=Y/jiAG4WYOgLgUKopzWm2Mr8y1Z3WH35BAGXg5EAIW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4JKqr94iJRGNziRBcgliICIiMJeEqyHJOvF4NdvgWeEN7IZQ2PGIaByyfGIi8PC5+zCh2nidpEgujJjziYmawJ5t2n6rj5EiqhURrtCDIKVTqrno+AsNAuGjnW7A2VAXGRwAdLXXZEE6xnsvk0QtkXoZ2X2tZEdBIe2appEP4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l9kgMshk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l9kgMshk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BB9C2BCB3;
	Thu, 19 Mar 2026 06:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901161;
	bh=Y/jiAG4WYOgLgUKopzWm2Mr8y1Z3WH35BAGXg5EAIW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9kgMshkfQJkJhsWfrrmEY/dXu0RsB5ej79ZbbCkwLerjo7cTRHJrk/0fDKn8OzoT
	 n8HH8zm+cZVC/e/xVtLaVxLEorCYoszIAt1OZitUUaoxmdTsQEXQG/5piFr+pXKJEF
	 CnIXhupQoxjzABf1u+5ylMlMSOMOvxwcu7EA9RbihORUTgdN/r80b32yaAxyb0/NYs
	 4W/nVgiu/SSCylqFIkm6uaouBhJHljhw8YwIw1uxme8JZRTXkuLBFMjEhjg4mGj6xQ
	 LK4dHNHorY1Zye9y8uO8qZHRKijSI+YfPoaxmqCjgJJpWU7rovcQNDlzqfEuhtoETI
	 xdyD4jaRYHwbg==
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
Subject: [PATCH 15/19] crypto: gcm - Use GHASH library instead of crypto_ahash
Date: Wed, 18 Mar 2026 23:17:16 -0700
Message-ID: <20260319061723.1140720-16-ebiggers@kernel.org>
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

Make the "gcm" template access GHASH using the library API instead of
crypto_ahash.  This is much simpler and more efficient, especially given
that all GHASH implementations are synchronous and CPU-based anyway.

Note that this allows "ghash" to be removed from the crypto_ahash (and
crypto_shash) API, which a later commit will do.

This mirrors the similar cleanup that was done with POLYVAL.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig                       |   2 +-
 crypto/gcm.c                         | 413 +++++----------------------
 crypto/testmgr.c                     |  10 +-
 drivers/crypto/starfive/jh7110-aes.c |   2 +-
 4 files changed, 85 insertions(+), 342 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5627b3691561..13ccf5ac2f1a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -792,11 +792,11 @@ config CRYPTO_CCM
 
 config CRYPTO_GCM
 	tristate "GCM (Galois/Counter Mode) and GMAC (GCM MAC)"
 	select CRYPTO_CTR
 	select CRYPTO_AEAD
-	select CRYPTO_GHASH
+	select CRYPTO_LIB_GF128HASH
 	select CRYPTO_MANAGER
 	help
 	  GCM (Galois/Counter Mode) authenticated encryption mode and GMAC
 	  (GCM Message Authentication Code) (NIST SP800-38D)
 
diff --git a/crypto/gcm.c b/crypto/gcm.c
index e1e878d37410..5f16b237b3c5 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -3,31 +3,28 @@
  * GCM: Galois/Counter Mode.
  *
  * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
  */
 
-#include <crypto/gf128mul.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/gcm.h>
-#include <crypto/hash.h>
+#include <crypto/gf128hash.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
 struct gcm_instance_ctx {
 	struct crypto_skcipher_spawn ctr;
-	struct crypto_ahash_spawn ghash;
 };
 
 struct crypto_gcm_ctx {
 	struct crypto_skcipher *ctr;
-	struct crypto_ahash *ghash;
+	struct ghash_key ghash;
 };
 
 struct crypto_rfc4106_ctx {
 	struct crypto_aead *child;
 	u8 nonce[4];
@@ -50,35 +47,19 @@ struct crypto_rfc4543_ctx {
 
 struct crypto_rfc4543_req_ctx {
 	struct aead_request subreq;
 };
 
-struct crypto_gcm_ghash_ctx {
-	unsigned int cryptlen;
-	struct scatterlist *src;
-	int (*complete)(struct aead_request *req, u32 flags);
-};
-
 struct crypto_gcm_req_priv_ctx {
 	u8 iv[16];
 	u8 auth_tag[16];
 	u8 iauth_tag[16];
 	struct scatterlist src[3];
 	struct scatterlist dst[3];
-	struct scatterlist sg;
-	struct crypto_gcm_ghash_ctx ghash_ctx;
-	union {
-		struct ahash_request ahreq;
-		struct skcipher_request skreq;
-	} u;
+	struct skcipher_request skreq; /* Must be last */
 };
 
-static struct {
-	u8 buf[16];
-	struct scatterlist sg;
-} *gcm_zeroes;
-
 static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 	struct aead_request *req)
 {
 	unsigned long align = crypto_aead_alignmask(crypto_aead_reqtfm(req));
 
@@ -87,14 +68,13 @@ static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 
 static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			     unsigned int keylen)
 {
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
-	struct crypto_ahash *ghash = ctx->ghash;
 	struct crypto_skcipher *ctr = ctx->ctr;
 	struct {
-		be128 hash;
+		u8 h[GHASH_BLOCK_SIZE];
 		u8 iv[16];
 
 		struct crypto_wait wait;
 
 		struct scatterlist sg[1];
@@ -113,29 +93,26 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 		       GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
 	crypto_init_wait(&data->wait);
-	sg_init_one(data->sg, &data->hash, sizeof(data->hash));
+	sg_init_one(data->sg, data->h, sizeof(data->h));
 	skcipher_request_set_tfm(&data->req, ctr);
 	skcipher_request_set_callback(&data->req, CRYPTO_TFM_REQ_MAY_SLEEP |
 						  CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      crypto_req_done,
 				      &data->wait);
 	skcipher_request_set_crypt(&data->req, data->sg, data->sg,
-				   sizeof(data->hash), data->iv);
+				   sizeof(data->h), data->iv);
 
 	err = crypto_wait_req(crypto_skcipher_encrypt(&data->req),
 							&data->wait);
 
 	if (err)
 		goto out;
 
-	crypto_ahash_clear_flags(ghash, CRYPTO_TFM_REQ_MASK);
-	crypto_ahash_set_flags(ghash, crypto_aead_get_flags(aead) &
-			       CRYPTO_TFM_REQ_MASK);
-	err = crypto_ahash_setkey(ghash, (u8 *)&data->hash, sizeof(be128));
+	ghash_preparekey(&ctx->ghash, data->h);
 out:
 	kfree_sensitive(data);
 	return err;
 }
 
@@ -174,288 +151,106 @@ static void crypto_gcm_init_crypt(struct aead_request *req,
 				  unsigned int cryptlen)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct skcipher_request *skreq = &pctx->u.skreq;
+	struct skcipher_request *skreq = &pctx->skreq;
 	struct scatterlist *dst;
 
 	dst = req->src == req->dst ? pctx->src : pctx->dst;
 
 	skcipher_request_set_tfm(skreq, ctx->ctr);
 	skcipher_request_set_crypt(skreq, pctx->src, dst,
 				     cryptlen + sizeof(pctx->auth_tag),
 				     pctx->iv);
 }
 
-static inline unsigned int gcm_remain(unsigned int len)
-{
-	len &= 0xfU;
-	return len ? 16 - len : 0;
-}
-
-static void gcm_hash_len_done(void *data, int err);
-
-static int gcm_hash_update(struct aead_request *req,
-			   crypto_completion_t compl,
-			   struct scatterlist *src,
-			   unsigned int len, u32 flags)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ahash_request *ahreq = &pctx->u.ahreq;
-
-	ahash_request_set_callback(ahreq, flags, compl, req);
-	ahash_request_set_crypt(ahreq, src, NULL, len);
-
-	return crypto_ahash_update(ahreq);
-}
-
-static int gcm_hash_remain(struct aead_request *req,
-			   unsigned int remain,
-			   crypto_completion_t compl, u32 flags)
-{
-	return gcm_hash_update(req, compl, &gcm_zeroes->sg, remain, flags);
-}
-
-static int gcm_hash_len(struct aead_request *req, u32 flags)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ahash_request *ahreq = &pctx->u.ahreq;
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-	be128 lengths;
-
-	lengths.a = cpu_to_be64(req->assoclen * 8);
-	lengths.b = cpu_to_be64(gctx->cryptlen * 8);
-	memcpy(pctx->iauth_tag, &lengths, 16);
-	sg_init_one(&pctx->sg, pctx->iauth_tag, 16);
-	ahash_request_set_callback(ahreq, flags, gcm_hash_len_done, req);
-	ahash_request_set_crypt(ahreq, &pctx->sg,
-				pctx->iauth_tag, sizeof(lengths));
-
-	return crypto_ahash_finup(ahreq);
-}
-
-static int gcm_hash_len_continue(struct aead_request *req, u32 flags)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-
-	return gctx->complete(req, flags);
-}
-
-static void gcm_hash_len_done(void *data, int err)
-{
-	struct aead_request *req = data;
-
-	if (err)
-		goto out;
-
-	err = gcm_hash_len_continue(req, 0);
-	if (err == -EINPROGRESS)
-		return;
-
-out:
-	aead_request_complete(req, err);
-}
-
-static int gcm_hash_crypt_remain_continue(struct aead_request *req, u32 flags)
-{
-	return gcm_hash_len(req, flags) ?:
-	       gcm_hash_len_continue(req, flags);
-}
-
-static void gcm_hash_crypt_remain_done(void *data, int err)
-{
-	struct aead_request *req = data;
-
-	if (err)
-		goto out;
-
-	err = gcm_hash_crypt_remain_continue(req, 0);
-	if (err == -EINPROGRESS)
-		return;
-
-out:
-	aead_request_complete(req, err);
-}
-
-static int gcm_hash_crypt_continue(struct aead_request *req, u32 flags)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-	unsigned int remain;
-
-	remain = gcm_remain(gctx->cryptlen);
-	if (remain)
-		return gcm_hash_remain(req, remain,
-				       gcm_hash_crypt_remain_done, flags) ?:
-		       gcm_hash_crypt_remain_continue(req, flags);
-
-	return gcm_hash_crypt_remain_continue(req, flags);
-}
-
-static void gcm_hash_crypt_done(void *data, int err)
-{
-	struct aead_request *req = data;
-
-	if (err)
-		goto out;
-
-	err = gcm_hash_crypt_continue(req, 0);
-	if (err == -EINPROGRESS)
-		return;
-
-out:
-	aead_request_complete(req, err);
-}
-
-static int gcm_hash_assoc_remain_continue(struct aead_request *req, u32 flags)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-
-	if (gctx->cryptlen)
-		return gcm_hash_update(req, gcm_hash_crypt_done,
-				       gctx->src, gctx->cryptlen, flags) ?:
-		       gcm_hash_crypt_continue(req, flags);
-
-	return gcm_hash_crypt_remain_continue(req, flags);
-}
-
-static void gcm_hash_assoc_remain_done(void *data, int err)
-{
-	struct aead_request *req = data;
-
-	if (err)
-		goto out;
-
-	err = gcm_hash_assoc_remain_continue(req, 0);
-	if (err == -EINPROGRESS)
-		return;
-
-out:
-	aead_request_complete(req, err);
-}
-
-static int gcm_hash_assoc_continue(struct aead_request *req, u32 flags)
+static void ghash_update_sg_and_pad(struct ghash_ctx *ghash,
+				    struct scatterlist *sg, unsigned int len)
 {
-	unsigned int remain;
+	static const u8 zeroes[GHASH_BLOCK_SIZE];
 
-	remain = gcm_remain(req->assoclen);
-	if (remain)
-		return gcm_hash_remain(req, remain,
-				       gcm_hash_assoc_remain_done, flags) ?:
-		       gcm_hash_assoc_remain_continue(req, flags);
+	if (len) {
+		unsigned int pad_len = -len % GHASH_BLOCK_SIZE;
+		struct scatter_walk walk;
 
-	return gcm_hash_assoc_remain_continue(req, flags);
-}
+		scatterwalk_start(&walk, sg);
+		do {
+			unsigned int n = scatterwalk_next(&walk, len);
 
-static void gcm_hash_assoc_done(void *data, int err)
-{
-	struct aead_request *req = data;
+			ghash_update(ghash, walk.addr, n);
+			scatterwalk_done_src(&walk, n);
+			len -= n;
+		} while (len);
 
-	if (err)
-		goto out;
-
-	err = gcm_hash_assoc_continue(req, 0);
-	if (err == -EINPROGRESS)
-		return;
-
-out:
-	aead_request_complete(req, err);
-}
-
-static int gcm_hash_init_continue(struct aead_request *req, u32 flags)
-{
-	if (req->assoclen)
-		return gcm_hash_update(req, gcm_hash_assoc_done,
-				       req->src, req->assoclen, flags) ?:
-		       gcm_hash_assoc_continue(req, flags);
-
-	return gcm_hash_assoc_remain_continue(req, flags);
+		if (pad_len)
+			ghash_update(ghash, zeroes, pad_len);
+	}
 }
 
-static void gcm_hash_init_done(void *data, int err)
+static void gcm_hash(struct aead_request *req, struct scatterlist *ctext,
+		     unsigned int datalen, u8 out[GHASH_BLOCK_SIZE])
 {
-	struct aead_request *req = data;
-
-	if (err)
-		goto out;
+	const struct crypto_gcm_ctx *ctx =
+		crypto_aead_ctx(crypto_aead_reqtfm(req));
+	__be64 lengths[2] = {
+		cpu_to_be64(8 * (u64)req->assoclen),
+		cpu_to_be64(8 * (u64)datalen),
+	};
+	struct ghash_ctx ghash;
 
-	err = gcm_hash_init_continue(req, 0);
-	if (err == -EINPROGRESS)
-		return;
+	ghash_init(&ghash, &ctx->ghash);
 
-out:
-	aead_request_complete(req, err);
-}
+	/* Associated data, then zero-padding to the next 16-byte boundary */
+	ghash_update_sg_and_pad(&ghash, req->src, req->assoclen);
 
-static int gcm_hash(struct aead_request *req, u32 flags)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ahash_request *ahreq = &pctx->u.ahreq;
-	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	/* Ciphertext, then zero-padding to the next 16-byte boundary */
+	ghash_update_sg_and_pad(&ghash, ctext, datalen);
 
-	ahash_request_set_tfm(ahreq, ctx->ghash);
+	/* Lengths block */
+	ghash_update(&ghash, (const u8 *)lengths, sizeof(lengths));
 
-	ahash_request_set_callback(ahreq, flags, gcm_hash_init_done, req);
-	return crypto_ahash_init(ahreq) ?:
-	       gcm_hash_init_continue(req, flags);
+	ghash_final(&ghash, out);
 }
 
-static int gcm_enc_copy_hash(struct aead_request *req, u32 flags)
+static int gcm_add_auth_tag(struct aead_request *req)
 {
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	u8 *auth_tag = pctx->auth_tag;
-
-	crypto_xor(auth_tag, pctx->iauth_tag, 16);
-	scatterwalk_map_and_copy(auth_tag, req->dst,
-				 req->assoclen + req->cryptlen,
-				 crypto_aead_authsize(aead), 1);
-	return 0;
-}
-
-static int gcm_encrypt_continue(struct aead_request *req, u32 flags)
-{
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 
-	gctx->src = sg_next(req->src == req->dst ? pctx->src : pctx->dst);
-	gctx->cryptlen = req->cryptlen;
-	gctx->complete = gcm_enc_copy_hash;
-
-	return gcm_hash(req, flags);
+	gcm_hash(req, sg_next(req->src == req->dst ? pctx->src : pctx->dst),
+		 req->cryptlen, pctx->iauth_tag);
+	crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
+	memcpy_to_sglist(req->dst, req->assoclen + req->cryptlen,
+			 pctx->auth_tag, crypto_aead_authsize(aead));
+	return 0;
 }
 
 static void gcm_encrypt_done(void *data, int err)
 {
 	struct aead_request *req = data;
 
 	if (err)
 		goto out;
 
-	err = gcm_encrypt_continue(req, 0);
-	if (err == -EINPROGRESS)
-		return;
+	err = gcm_add_auth_tag(req);
 
 out:
 	aead_request_complete(req, err);
 }
 
 static int crypto_gcm_encrypt(struct aead_request *req)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct skcipher_request *skreq = &pctx->u.skreq;
+	struct skcipher_request *skreq = &pctx->skreq;
 	u32 flags = aead_request_flags(req);
 
 	crypto_gcm_init_common(req);
 	crypto_gcm_init_crypt(req, req->cryptlen);
 	skcipher_request_set_callback(skreq, flags, gcm_encrypt_done, req);
 
-	return crypto_skcipher_encrypt(skreq) ?:
-	       gcm_encrypt_continue(req, flags);
+	return crypto_skcipher_encrypt(skreq) ?: gcm_add_auth_tag(req);
 }
 
 static int crypto_gcm_verify(struct aead_request *req)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
@@ -479,106 +274,71 @@ static void gcm_decrypt_done(void *data, int err)
 		err = crypto_gcm_verify(req);
 
 	aead_request_complete(req, err);
 }
 
-static int gcm_dec_hash_continue(struct aead_request *req, u32 flags)
-{
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct skcipher_request *skreq = &pctx->u.skreq;
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-
-	crypto_gcm_init_crypt(req, gctx->cryptlen);
-	skcipher_request_set_callback(skreq, flags, gcm_decrypt_done, req);
-	return crypto_skcipher_decrypt(skreq) ?: crypto_gcm_verify(req);
-}
-
 static int crypto_gcm_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
-	unsigned int authsize = crypto_aead_authsize(aead);
-	unsigned int cryptlen = req->cryptlen;
-	u32 flags = aead_request_flags(req);
-
-	cryptlen -= authsize;
+	struct skcipher_request *skreq = &pctx->skreq;
+	unsigned int datalen = req->cryptlen - crypto_aead_authsize(aead);
 
 	crypto_gcm_init_common(req);
 
-	gctx->src = sg_next(pctx->src);
-	gctx->cryptlen = cryptlen;
-	gctx->complete = gcm_dec_hash_continue;
+	gcm_hash(req, sg_next(pctx->src), datalen, pctx->iauth_tag);
 
-	return gcm_hash(req, flags);
+	crypto_gcm_init_crypt(req, datalen);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+				      gcm_decrypt_done, req);
+	return crypto_skcipher_decrypt(skreq) ?: crypto_gcm_verify(req);
 }
 
 static int crypto_gcm_init_tfm(struct crypto_aead *tfm)
 {
 	struct aead_instance *inst = aead_alg_instance(tfm);
 	struct gcm_instance_ctx *ictx = aead_instance_ctx(inst);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_skcipher *ctr;
-	struct crypto_ahash *ghash;
 	unsigned long align;
-	int err;
-
-	ghash = crypto_spawn_ahash(&ictx->ghash);
-	if (IS_ERR(ghash))
-		return PTR_ERR(ghash);
 
 	ctr = crypto_spawn_skcipher(&ictx->ctr);
-	err = PTR_ERR(ctr);
 	if (IS_ERR(ctr))
-		goto err_free_hash;
+		return PTR_ERR(ctr);
 
 	ctx->ctr = ctr;
-	ctx->ghash = ghash;
 
 	align = crypto_aead_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
 	crypto_aead_set_reqsize(tfm,
-		align + offsetof(struct crypto_gcm_req_priv_ctx, u) +
-		max(sizeof(struct skcipher_request) +
-		    crypto_skcipher_reqsize(ctr),
-		    sizeof(struct ahash_request) +
-		    crypto_ahash_reqsize(ghash)));
-
+				align + sizeof(struct crypto_gcm_req_priv_ctx) +
+					crypto_skcipher_reqsize(ctr));
 	return 0;
-
-err_free_hash:
-	crypto_free_ahash(ghash);
-	return err;
 }
 
 static void crypto_gcm_exit_tfm(struct crypto_aead *tfm)
 {
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(tfm);
 
-	crypto_free_ahash(ctx->ghash);
 	crypto_free_skcipher(ctx->ctr);
 }
 
 static void crypto_gcm_free(struct aead_instance *inst)
 {
 	struct gcm_instance_ctx *ctx = aead_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ctx->ctr);
-	crypto_drop_ahash(&ctx->ghash);
 	kfree(inst);
 }
 
 static int crypto_gcm_create_common(struct crypto_template *tmpl,
-				    struct rtattr **tb,
-				    const char *ctr_name,
-				    const char *ghash_name)
+				    struct rtattr **tb, const char *ctr_name)
 {
 	struct skcipher_alg_common *ctr;
 	u32 mask;
 	struct aead_instance *inst;
 	struct gcm_instance_ctx *ctx;
-	struct hash_alg_common *ghash;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AEAD, &mask);
 	if (err)
 		return err;
@@ -586,21 +346,10 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
 	ctx = aead_instance_ctx(inst);
 
-	err = crypto_grab_ahash(&ctx->ghash, aead_crypto_instance(inst),
-				ghash_name, 0, mask);
-	if (err)
-		goto err_free_inst;
-	ghash = crypto_spawn_ahash_alg(&ctx->ghash);
-
-	err = -EINVAL;
-	if (strcmp(ghash->base.cra_name, "ghash") != 0 ||
-	    ghash->digestsize != 16)
-		goto err_free_inst;
-
 	err = crypto_grab_skcipher(&ctx->ctr, aead_crypto_instance(inst),
 				   ctr_name, 0, mask);
 	if (err)
 		goto err_free_inst;
 	ctr = crypto_spawn_skcipher_alg_common(&ctx->ctr);
@@ -615,17 +364,15 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "gcm_base(%s,%s)", ctr->base.cra_driver_name,
-		     ghash->base.cra_driver_name) >=
-	    CRYPTO_MAX_ALG_NAME)
+		     "gcm_base(%s,ghash-lib)",
+		     ctr->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_priority = (ghash->base.cra_priority +
-				       ctr->base.cra_priority) / 2;
+	inst->alg.base.cra_priority = ctr->base.cra_priority;
 	inst->alg.base.cra_blocksize = 1;
 	inst->alg.base.cra_alignmask = ctr->base.cra_alignmask;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_gcm_ctx);
 	inst->alg.ivsize = GCM_AES_IV_SIZE;
 	inst->alg.chunksize = ctr->chunksize;
@@ -658,11 +405,11 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)", cipher_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
-	return crypto_gcm_create_common(tmpl, tb, ctr_name, "ghash");
+	return crypto_gcm_create_common(tmpl, tb, ctr_name);
 }
 
 static int crypto_gcm_base_create(struct crypto_template *tmpl,
 				  struct rtattr **tb)
 {
@@ -675,11 +422,20 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
 
 	ghash_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(ghash_name))
 		return PTR_ERR(ghash_name);
 
-	return crypto_gcm_create_common(tmpl, tb, ctr_name, ghash_name);
+	/*
+	 * Originally this parameter allowed requesting a specific
+	 * implementation of GHASH.  This is no longer supported.  Now the best
+	 * implementation of GHASH is just always used.
+	 */
+	if (strcmp(ghash_name, "ghash") != 0 &&
+	    strcmp(ghash_name, "ghash-lib") != 0)
+		return -EINVAL;
+
+	return crypto_gcm_create_common(tmpl, tb, ctr_name);
 }
 
 static int crypto_rfc4106_setkey(struct crypto_aead *parent, const u8 *key,
 				 unsigned int keylen)
 {
@@ -1094,29 +850,16 @@ static struct crypto_template crypto_gcm_tmpls[] = {
 	},
 };
 
 static int __init crypto_gcm_module_init(void)
 {
-	int err;
-
-	gcm_zeroes = kzalloc_obj(*gcm_zeroes);
-	if (!gcm_zeroes)
-		return -ENOMEM;
-
-	sg_init_one(&gcm_zeroes->sg, gcm_zeroes->buf, sizeof(gcm_zeroes->buf));
-
-	err = crypto_register_templates(crypto_gcm_tmpls,
-					ARRAY_SIZE(crypto_gcm_tmpls));
-	if (err)
-		kfree(gcm_zeroes);
-
-	return err;
+	return crypto_register_templates(crypto_gcm_tmpls,
+					 ARRAY_SIZE(crypto_gcm_tmpls));
 }
 
 static void __exit crypto_gcm_module_exit(void)
 {
-	kfree(gcm_zeroes);
 	crypto_unregister_templates(crypto_gcm_tmpls,
 				    ARRAY_SIZE(crypto_gcm_tmpls));
 }
 
 module_init(crypto_gcm_module_init);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fec950f1628b..0b0ad358e091 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4963,26 +4963,26 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.kpp = __VECS(ffdhe8192_dh_tv_template)
 		}
 	}, {
 #endif /* CONFIG_CRYPTO_DH_RFC7919_GROUPS */
 		.alg = "gcm(aes)",
-		.generic_driver = "gcm_base(ctr(aes-lib),ghash-generic)",
+		.generic_driver = "gcm_base(ctr(aes-lib),ghash-lib)",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(aes_gcm_tv_template)
 		}
 	}, {
 		.alg = "gcm(aria)",
-		.generic_driver = "gcm_base(ctr(aria-generic),ghash-generic)",
+		.generic_driver = "gcm_base(ctr(aria-generic),ghash-lib)",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(aria_gcm_tv_template)
 		}
 	}, {
 		.alg = "gcm(sm4)",
-		.generic_driver = "gcm_base(ctr(sm4-generic),ghash-generic)",
+		.generic_driver = "gcm_base(ctr(sm4-generic),ghash-lib)",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(sm4_gcm_tv_template)
 		}
 	}, {
@@ -5312,11 +5312,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.cipher = __VECS(sm4_ctr_rfc3686_tv_template)
 		}
 	}, {
 		.alg = "rfc4106(gcm(aes))",
-		.generic_driver = "rfc4106(gcm_base(ctr(aes-lib),ghash-generic))",
+		.generic_driver = "rfc4106(gcm_base(ctr(aes-lib),ghash-lib))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				____VECS(aes_gcm_rfc4106_tv_template),
@@ -5336,11 +5336,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.aad_iv = 1,
 			}
 		}
 	}, {
 		.alg = "rfc4543(gcm(aes))",
-		.generic_driver = "rfc4543(gcm_base(ctr(aes-lib),ghash-generic))",
+		.generic_driver = "rfc4543(gcm_base(ctr(aes-lib),ghash-lib))",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
 				____VECS(aes_gcm_rfc4543_tv_template),
 				.einval_allowed = 1,
diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 2e2d97d17e6c..a0713aa21250 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -1006,11 +1006,11 @@ static int starfive_aes_ccm_init_tfm(struct crypto_aead *tfm)
 	return starfive_aes_aead_init_tfm(tfm, "ccm_base(ctr(aes-lib),cbcmac-aes-lib)");
 }
 
 static int starfive_aes_gcm_init_tfm(struct crypto_aead *tfm)
 {
-	return starfive_aes_aead_init_tfm(tfm, "gcm_base(ctr(aes-lib),ghash-generic)");
+	return starfive_aes_aead_init_tfm(tfm, "gcm_base(ctr(aes-lib),ghash-lib)");
 }
 
 static struct skcipher_engine_alg skcipher_algs[] = {
 {
 	.base.init			= starfive_aes_ecb_init_tfm,
-- 
2.53.0

