From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 2/5] crypto: Use GHASH digest algorithm in GCM
Date: Mon,  3 Aug 2009 15:45:28 +0800
Message-ID: <1249285531-22422-2-git-send-email-ying.huang@intel.com>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752966AbZHCHqd@vger.kernel.org>
In-Reply-To: <1249285531-22422-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the dedicated GHASH implementation in GCM, and uses the GHASH
digest algorithm instead. This will make GCM uses hardware accelerated
GHASH implementation automatically if available.

ahash instead of shash interface is used, because some hardware
accelerated GHASH implementation needs asynchronous interface.

v2:
 - Add parameter to gcm_base to choose ghash implementation.
 - Fix a memory leak about gcm_zeros (Thanks Sebastian)
 - Some minor fixes

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/Kconfig |    2 +-
 crypto/gcm.c   |  580 +++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 408 insertions(+), 174 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 0ae170e..5105cf1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -157,7 +157,7 @@ config CRYPTO_GCM
 	tristate "GCM/GMAC support"
 	select CRYPTO_CTR
 	select CRYPTO_AEAD
-	select CRYPTO_GF128MUL
+	select CRYPTO_GHASH
 	help
 	  Support for Galois/Counter Mode (GCM) and Galois Message
 	  Authentication Code (GMAC). Required for IPSec.
diff --git a/crypto/gcm.c b/crypto/gcm.c
index e70afd0..5fc3292 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -11,7 +11,10 @@
 #include <crypto/gf128mul.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/hash.h>
+#include "internal.h"
 #include <linux/completion.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -21,11 +24,12 @@
 
 struct gcm_instance_ctx {
 	struct crypto_skcipher_spawn ctr;
+	struct crypto_ahash_spawn ghash;
 };
 
 struct crypto_gcm_ctx {
 	struct crypto_ablkcipher *ctr;
-	struct gf128mul_4k *gf128;
+	struct crypto_ahash *ghash;
 };
 
 struct crypto_rfc4106_ctx {
@@ -34,10 +38,9 @@ struct crypto_rfc4106_ctx {
 };
 
 struct crypto_gcm_ghash_ctx {
-	u32 bytes;
-	u32 flags;
-	struct gf128mul_4k *gf128;
-	u8 buffer[16];
+	unsigned int cryptlen;
+	struct scatterlist *src;
+	crypto_completion_t complete;
 };
 
 struct crypto_gcm_req_priv_ctx {
@@ -45,8 +48,11 @@ struct crypto_gcm_req_priv_ctx {
 	u8 iauth_tag[16];
 	struct scatterlist src[2];
 	struct scatterlist dst[2];
-	struct crypto_gcm_ghash_ctx ghash;
-	struct ablkcipher_request abreq;
+	struct crypto_gcm_ghash_ctx ghash_ctx;
+	union {
+		struct ahash_request ahreq;
+		struct ablkcipher_request abreq;
+	} u;
 };
 
 struct crypto_gcm_setkey_result {
@@ -54,6 +60,8 @@ struct crypto_gcm_setkey_result {
 	struct completion completion;
 };
 
+static void *gcm_zeroes;
+
 static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 	struct aead_request *req)
 {
@@ -62,113 +70,6 @@ static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
 	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
 }
 
-static void crypto_gcm_ghash_init(struct crypto_gcm_ghash_ctx *ctx, u32 flags,
-				  struct gf128mul_4k *gf128)
-{
-	ctx->bytes = 0;
-	ctx->flags = flags;
-	ctx->gf128 = gf128;
-	memset(ctx->buffer, 0, 16);
-}
-
-static void crypto_gcm_ghash_update(struct crypto_gcm_ghash_ctx *ctx,
-				    const u8 *src, unsigned int srclen)
-{
-	u8 *dst = ctx->buffer;
-
-	if (ctx->bytes) {
-		int n = min(srclen, ctx->bytes);
-		u8 *pos = dst + (16 - ctx->bytes);
-
-		ctx->bytes -= n;
-		srclen -= n;
-
-		while (n--)
-			*pos++ ^= *src++;
-
-		if (!ctx->bytes)
-			gf128mul_4k_lle((be128 *)dst, ctx->gf128);
-	}
-
-	while (srclen >= 16) {
-		crypto_xor(dst, src, 16);
-		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
-		src += 16;
-		srclen -= 16;
-	}
-
-	if (srclen) {
-		ctx->bytes = 16 - srclen;
-		while (srclen--)
-			*dst++ ^= *src++;
-	}
-}
-
-static void crypto_gcm_ghash_update_sg(struct crypto_gcm_ghash_ctx *ctx,
-				       struct scatterlist *sg, int len)
-{
-	struct scatter_walk walk;
-	u8 *src;
-	int n;
-
-	if (!len)
-		return;
-
-	scatterwalk_start(&walk, sg);
-
-	while (len) {
-		n = scatterwalk_clamp(&walk, len);
-
-		if (!n) {
-			scatterwalk_start(&walk, scatterwalk_sg_next(walk.sg));
-			n = scatterwalk_clamp(&walk, len);
-		}
-
-		src = scatterwalk_map(&walk, 0);
-
-		crypto_gcm_ghash_update(ctx, src, n);
-		len -= n;
-
-		scatterwalk_unmap(src, 0);
-		scatterwalk_advance(&walk, n);
-		scatterwalk_done(&walk, 0, len);
-		if (len)
-			crypto_yield(ctx->flags);
-	}
-}
-
-static void crypto_gcm_ghash_flush(struct crypto_gcm_ghash_ctx *ctx)
-{
-	u8 *dst = ctx->buffer;
-
-	if (ctx->bytes) {
-		u8 *tmp = dst + (16 - ctx->bytes);
-
-		while (ctx->bytes--)
-			*tmp++ ^= 0;
-
-		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
-	}
-
-	ctx->bytes = 0;
-}
-
-static void crypto_gcm_ghash_final_xor(struct crypto_gcm_ghash_ctx *ctx,
-				       unsigned int authlen,
-				       unsigned int cryptlen, u8 *dst)
-{
-	u8 *buf = ctx->buffer;
-	u128 lengths;
-
-	lengths.a = cpu_to_be64(authlen * 8);
-	lengths.b = cpu_to_be64(cryptlen * 8);
-
-	crypto_gcm_ghash_flush(ctx);
-	crypto_xor(buf, (u8 *)&lengths, 16);
-	gf128mul_4k_lle((be128 *)buf, ctx->gf128);
-	crypto_xor(dst, buf, 16);
-}
-
 static void crypto_gcm_setkey_done(struct crypto_async_request *req, int err)
 {
 	struct crypto_gcm_setkey_result *result = req->data;
@@ -184,6 +85,7 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			     unsigned int keylen)
 {
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_ahash *ghash = ctx->ghash;
 	struct crypto_ablkcipher *ctr = ctx->ctr;
 	struct {
 		be128 hash;
@@ -233,13 +135,12 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	if (err)
 		goto out;
 
-	if (ctx->gf128 != NULL)
-		gf128mul_free_4k(ctx->gf128);
-
-	ctx->gf128 = gf128mul_init_4k_lle(&data->hash);
-
-	if (ctx->gf128 == NULL)
-		err = -ENOMEM;
+	crypto_ahash_clear_flags(ghash, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(ghash, crypto_aead_get_flags(aead) &
+			       CRYPTO_TFM_REQ_MASK);
+	err = crypto_ahash_setkey(ghash, (u8 *)&data->hash, sizeof(be128));
+	crypto_aead_set_flags(aead, crypto_ahash_get_flags(ghash) &
+			      CRYPTO_TFM_RES_MASK);
 
 out:
 	kfree(data);
@@ -272,8 +173,6 @@ static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	u32 flags = req->base.tfm->crt_flags;
-	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	struct scatterlist *dst;
 	__be32 counter = cpu_to_be32(1);
 
@@ -296,108 +195,398 @@ static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
 	ablkcipher_request_set_crypt(ablk_req, pctx->src, dst,
 				     cryptlen + sizeof(pctx->auth_tag),
 				     req->iv);
+}
+
+static inline unsigned int gcm_remain(unsigned int len)
+{
+	len &= 0xfU;
+	return len ? 16 - len : 0;
+}
+
+static void gcm_hash_len_done(struct crypto_async_request *areq, int err);
+static void gcm_hash_final_done(struct crypto_async_request *areq, int err);
 
-	crypto_gcm_ghash_init(ghash, flags, ctx->gf128);
+static int gcm_hash_update(struct aead_request *req,
+			   struct crypto_gcm_req_priv_ctx *pctx,
+			   crypto_completion_t complete,
+			   struct scatterlist *src,
+			   unsigned int len)
+{
+	struct ahash_request *ahreq = &pctx->u.ahreq;
 
-	crypto_gcm_ghash_update_sg(ghash, req->assoc, req->assoclen);
-	crypto_gcm_ghash_flush(ghash);
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   complete, req);
+	ahash_request_set_crypt(ahreq, src, NULL, len);
+
+	return crypto_ahash_update(ahreq);
 }
 
-static int crypto_gcm_hash(struct aead_request *req)
+static int gcm_hash_remain(struct aead_request *req,
+			   struct crypto_gcm_req_priv_ctx *pctx,
+			   unsigned int remain,
+			   crypto_completion_t complete)
 {
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct ahash_request *ahreq = &pctx->u.ahreq;
+
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   complete, req);
+	sg_init_one(pctx->src, gcm_zeroes, remain);
+	ahash_request_set_crypt(ahreq, pctx->src, NULL, remain);
+
+	return crypto_ahash_update(ahreq);
+}
+
+static int gcm_hash_len(struct aead_request *req,
+			struct crypto_gcm_req_priv_ctx *pctx)
+{
+	struct ahash_request *ahreq = &pctx->u.ahreq;
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
+	u128 lengths;
+
+	lengths.a = cpu_to_be64(req->assoclen * 8);
+	lengths.b = cpu_to_be64(gctx->cryptlen * 8);
+	memcpy(pctx->iauth_tag, &lengths, 16);
+	sg_init_one(pctx->src, pctx->iauth_tag, 16);
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   gcm_hash_len_done, req);
+	ahash_request_set_crypt(ahreq, pctx->src,
+				NULL, sizeof(lengths));
+
+	return crypto_ahash_update(ahreq);
+}
+
+static int gcm_hash_final(struct aead_request *req,
+			  struct crypto_gcm_req_priv_ctx *pctx)
+{
+	struct ahash_request *ahreq = &pctx->u.ahreq;
+
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   gcm_hash_final_done, req);
+	ahash_request_set_crypt(ahreq, NULL, pctx->iauth_tag, 0);
+
+	return crypto_ahash_final(ahreq);
+}
+
+static void gcm_hash_final_done(struct crypto_async_request *areq,
+				int err)
+{
+	struct aead_request *req = areq->data;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	u8 *auth_tag = pctx->auth_tag;
-	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
+
+	if (!err)
+		crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
 
-	crypto_gcm_ghash_update_sg(ghash, req->dst, req->cryptlen);
-	crypto_gcm_ghash_final_xor(ghash, req->assoclen, req->cryptlen,
-				   auth_tag);
+	gctx->complete(areq, err);
+}
+
+static void gcm_hash_len_done(struct crypto_async_request *areq,
+			      int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	if (!err) {
+		err = gcm_hash_final(req, pctx);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	gcm_hash_final_done(areq, err);
+}
+
+static void gcm_hash_crypt_remain_done(struct crypto_async_request *areq,
+				       int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	if (!err) {
+		err = gcm_hash_len(req, pctx);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	gcm_hash_len_done(areq, err);
+}
+
+static void gcm_hash_crypt_done(struct crypto_async_request *areq,
+				int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
+	unsigned int remain;
+
+	if (!err) {
+		remain = gcm_remain(gctx->cryptlen);
+		BUG_ON(!remain);
+		err = gcm_hash_remain(req, pctx, remain,
+				      gcm_hash_crypt_remain_done);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	gcm_hash_crypt_remain_done(areq, err);
+}
+
+static void gcm_hash_assoc_remain_done(struct crypto_async_request *areq,
+					   int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
+	crypto_completion_t complete;
+	unsigned int remain = 0;
+
+	if (!err && gctx->cryptlen) {
+		remain = gcm_remain(gctx->cryptlen);
+		complete = remain ? gcm_hash_crypt_done :
+			gcm_hash_crypt_remain_done;
+		err = gcm_hash_update(req, pctx, complete,
+				      gctx->src, gctx->cryptlen);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	if (remain)
+		gcm_hash_crypt_done(areq, err);
+	else
+		gcm_hash_crypt_remain_done(areq, err);
+}
+
+static void gcm_hash_assoc_done(struct crypto_async_request *areq,
+				int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+	unsigned int remain;
+
+	if (!err) {
+		remain = gcm_remain(req->assoclen);
+		BUG_ON(!remain);
+		err = gcm_hash_remain(req, pctx, remain,
+				      gcm_hash_assoc_remain_done);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	gcm_hash_assoc_remain_done(areq, err);
+}
+
+static void gcm_hash_init_done(struct crypto_async_request *areq,
+			       int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+	crypto_completion_t complete;
+	unsigned int remain = 0;
+
+	if (!err && req->assoclen) {
+		remain = gcm_remain(req->assoclen);
+		complete = remain ? gcm_hash_assoc_done :
+			gcm_hash_assoc_remain_done;
+		err = gcm_hash_update(req, pctx, complete,
+				      req->assoc, req->assoclen);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	if (remain)
+		gcm_hash_assoc_done(areq, err);
+	else
+		gcm_hash_assoc_remain_done(areq, err);
+}
+
+static int gcm_hash(struct aead_request *req,
+		    struct crypto_gcm_req_priv_ctx *pctx)
+{
+	struct ahash_request *ahreq = &pctx->u.ahreq;
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
+	struct crypto_gcm_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	unsigned int remain;
+	crypto_completion_t complete;
+	int err;
+
+	ahash_request_set_tfm(ahreq, ctx->ghash);
+
+	ahash_request_set_callback(ahreq, aead_request_flags(req),
+				   gcm_hash_init_done, req);
+	err = crypto_ahash_init(ahreq);
+	if (err)
+		return err;
+	remain = gcm_remain(req->assoclen);
+	complete = remain ? gcm_hash_assoc_done : gcm_hash_assoc_remain_done;
+	err = gcm_hash_update(req, pctx, complete, req->assoc, req->assoclen);
+	if (err)
+		return err;
+	if (remain) {
+		err = gcm_hash_remain(req, pctx, remain,
+				      gcm_hash_assoc_remain_done);
+		if (err)
+			return err;
+	}
+	remain = gcm_remain(gctx->cryptlen);
+	complete = remain ? gcm_hash_crypt_done : gcm_hash_crypt_remain_done;
+	err = gcm_hash_update(req, pctx, complete, gctx->src, gctx->cryptlen);
+	if (err)
+		return err;
+	if (remain) {
+		err = gcm_hash_remain(req, pctx, remain,
+				      gcm_hash_crypt_remain_done);
+		if (err)
+			return err;
+	}
+	err = gcm_hash_len(req, pctx);
+	if (err)
+		return err;
+	err = gcm_hash_final(req, pctx);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void gcm_enc_copy_hash(struct aead_request *req,
+			      struct crypto_gcm_req_priv_ctx *pctx)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	u8 *auth_tag = pctx->auth_tag;
 
 	scatterwalk_map_and_copy(auth_tag, req->dst, req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
-	return 0;
 }
 
-static void crypto_gcm_encrypt_done(struct crypto_async_request *areq, int err)
+static void gcm_enc_hash_done(struct crypto_async_request *areq,
+				     int err)
 {
 	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
 	if (!err)
-		err = crypto_gcm_hash(req);
+		gcm_enc_copy_hash(req, pctx);
 
 	aead_request_complete(req, err);
 }
 
+static void gcm_encrypt_done(struct crypto_async_request *areq,
+				     int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+
+	if (!err) {
+		err = gcm_hash(req, pctx);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	gcm_enc_hash_done(areq, err);
+}
+
 static int crypto_gcm_encrypt(struct aead_request *req)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ablkcipher_request *abreq = &pctx->abreq;
+	struct ablkcipher_request *abreq = &pctx->u.abreq;
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	int err;
 
 	crypto_gcm_init_crypt(abreq, req, req->cryptlen);
 	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					crypto_gcm_encrypt_done, req);
+					gcm_encrypt_done, req);
+
+	gctx->src = req->dst;
+	gctx->cryptlen = req->cryptlen;
+	gctx->complete = gcm_enc_hash_done;
 
 	err = crypto_ablkcipher_encrypt(abreq);
 	if (err)
 		return err;
 
-	return crypto_gcm_hash(req);
+	err = gcm_hash(req, pctx);
+	if (err)
+		return err;
+
+	crypto_xor(pctx->auth_tag, pctx->iauth_tag, 16);
+	gcm_enc_copy_hash(req, pctx);
+
+	return 0;
 }
 
-static int crypto_gcm_verify(struct aead_request *req)
+static int crypto_gcm_verify(struct aead_request *req,
+			     struct crypto_gcm_req_priv_ctx *pctx)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	u8 *auth_tag = pctx->auth_tag;
 	u8 *iauth_tag = pctx->iauth_tag;
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int cryptlen = req->cryptlen - authsize;
 
-	crypto_gcm_ghash_final_xor(ghash, req->assoclen, cryptlen, auth_tag);
-
-	authsize = crypto_aead_authsize(aead);
+	crypto_xor(auth_tag, iauth_tag, 16);
 	scatterwalk_map_and_copy(iauth_tag, req->src, cryptlen, authsize, 0);
 	return memcmp(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
 }
 
-static void crypto_gcm_decrypt_done(struct crypto_async_request *areq, int err)
+static void gcm_decrypt_done(struct crypto_async_request *areq, int err)
 {
 	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 
 	if (!err)
-		err = crypto_gcm_verify(req);
+		err = crypto_gcm_verify(req, pctx);
 
 	aead_request_complete(req, err);
 }
 
+static void gcm_dec_hash_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
+	struct ablkcipher_request *abreq = &pctx->u.abreq;
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
+
+	if (!err) {
+		ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+						gcm_decrypt_done, req);
+		crypto_gcm_init_crypt(abreq, req, gctx->cryptlen);
+		err = crypto_ablkcipher_decrypt(abreq);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			return;
+	}
+
+	gcm_decrypt_done(areq, err);
+}
+
 static int crypto_gcm_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
-	struct ablkcipher_request *abreq = &pctx->abreq;
-	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
-	unsigned int cryptlen = req->cryptlen;
+	struct ablkcipher_request *abreq = &pctx->u.abreq;
+	struct crypto_gcm_ghash_ctx *gctx = &pctx->ghash_ctx;
 	unsigned int authsize = crypto_aead_authsize(aead);
+	unsigned int cryptlen = req->cryptlen;
 	int err;
 
 	if (cryptlen < authsize)
 		return -EINVAL;
 	cryptlen -= authsize;
 
-	crypto_gcm_init_crypt(abreq, req, cryptlen);
-	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
-					crypto_gcm_decrypt_done, req);
+	gctx->src = req->src;
+	gctx->cryptlen = cryptlen;
+	gctx->complete = gcm_dec_hash_done;
 
-	crypto_gcm_ghash_update_sg(ghash, req->src, cryptlen);
+	err = gcm_hash(req, pctx);
+	if (err)
+		return err;
 
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					gcm_decrypt_done, req);
+	crypto_gcm_init_crypt(abreq, req, cryptlen);
 	err = crypto_ablkcipher_decrypt(abreq);
 	if (err)
 		return err;
 
-	return crypto_gcm_verify(req);
+	return crypto_gcm_verify(req, pctx);
 }
 
 static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
@@ -406,43 +595,56 @@ static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
 	struct gcm_instance_ctx *ictx = crypto_instance_ctx(inst);
 	struct crypto_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_ablkcipher *ctr;
+	struct crypto_ahash *ghash;
 	unsigned long align;
 	int err;
 
+	ghash = crypto_spawn_ahash(&ictx->ghash);
+	if (IS_ERR(ghash))
+		return PTR_ERR(ghash);
+
 	ctr = crypto_spawn_skcipher(&ictx->ctr);
 	err = PTR_ERR(ctr);
 	if (IS_ERR(ctr))
-		return err;
+		goto err_free_hash;
 
 	ctx->ctr = ctr;
-	ctx->gf128 = NULL;
+	ctx->ghash = ghash;
 
 	align = crypto_tfm_alg_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
 	tfm->crt_aead.reqsize = align +
-				sizeof(struct crypto_gcm_req_priv_ctx) +
-				crypto_ablkcipher_reqsize(ctr);
+		offsetof(struct crypto_gcm_req_priv_ctx, u) +
+		max(sizeof(struct ablkcipher_request) +
+		    crypto_ablkcipher_reqsize(ctr),
+		    sizeof(struct ahash_request) +
+		    crypto_ahash_reqsize(ghash));
 
 	return 0;
+
+err_free_hash:
+	crypto_free_ahash(ghash);
+	return err;
 }
 
 static void crypto_gcm_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_gcm_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (ctx->gf128 != NULL)
-		gf128mul_free_4k(ctx->gf128);
-
+	crypto_free_ahash(ctx->ghash);
 	crypto_free_ablkcipher(ctx->ctr);
 }
 
 static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 						       const char *full_name,
-						       const char *ctr_name)
+						       const char *ctr_name,
+						       const char *ghash_name)
 {
 	struct crypto_attr_type *algt;
 	struct crypto_instance *inst;
 	struct crypto_alg *ctr;
+	struct crypto_alg *ghash_alg;
+	struct ahash_alg *ghash_ahash_alg;
 	struct gcm_instance_ctx *ctx;
 	int err;
 
@@ -454,17 +656,31 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return ERR_PTR(-EINVAL);
 
+	ghash_alg = crypto_find_alg(ghash_name, &crypto_ahash_type,
+				    CRYPTO_ALG_TYPE_HASH,
+				    CRYPTO_ALG_TYPE_AHASH_MASK);
+	err = PTR_ERR(ghash_alg);
+	if (IS_ERR(ghash_alg))
+		return ERR_PTR(err);
+
+	err = -ENOMEM;
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
-		return ERR_PTR(-ENOMEM);
+		goto out_put_ghash;
 
 	ctx = crypto_instance_ctx(inst);
+	ghash_ahash_alg = container_of(ghash_alg, struct ahash_alg, halg.base);
+	err = crypto_init_ahash_spawn(&ctx->ghash, &ghash_ahash_alg->halg,
+				      inst);
+	if (err)
+		goto err_free_inst;
+
 	crypto_set_skcipher_spawn(&ctx->ctr, inst);
 	err = crypto_grab_skcipher(&ctx->ctr, ctr_name, 0,
 				   crypto_requires_sync(algt->type,
 							algt->mask));
 	if (err)
-		goto err_free_inst;
+		goto err_drop_ghash;
 
 	ctr = crypto_skcipher_spawn_alg(&ctx->ctr);
 
@@ -479,7 +695,8 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "gcm_base(%s)", ctr->cra_driver_name) >=
+		     "gcm_base(%s,%s)", ctr->cra_driver_name,
+		     ghash_alg->cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
@@ -502,12 +719,16 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	inst->alg.cra_aead.decrypt = crypto_gcm_decrypt;
 
 out:
+	crypto_mod_put(ghash_alg);
 	return inst;
 
 out_put_ctr:
 	crypto_drop_skcipher(&ctx->ctr);
+err_drop_ghash:
+	crypto_drop_ahash(&ctx->ghash);
 err_free_inst:
 	kfree(inst);
+out_put_ghash:
 	inst = ERR_PTR(err);
 	goto out;
 }
@@ -532,7 +753,7 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 	    CRYPTO_MAX_ALG_NAME)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	return crypto_gcm_alloc_common(tb, full_name, ctr_name);
+	return crypto_gcm_alloc_common(tb, full_name, ctr_name, "ghash");
 }
 
 static void crypto_gcm_free(struct crypto_instance *inst)
@@ -540,6 +761,7 @@ static void crypto_gcm_free(struct crypto_instance *inst)
 	struct gcm_instance_ctx *ctx = crypto_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ctx->ctr);
+	crypto_drop_ahash(&ctx->ghash);
 	kfree(inst);
 }
 
@@ -554,6 +776,7 @@ static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
 {
 	int err;
 	const char *ctr_name;
+	const char *ghash_name;
 	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
@@ -561,11 +784,16 @@ static struct crypto_instance *crypto_gcm_base_alloc(struct rtattr **tb)
 	if (IS_ERR(ctr_name))
 		return ERR_PTR(err);
 
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s)",
-		     ctr_name) >= CRYPTO_MAX_ALG_NAME)
+	ghash_name = crypto_attr_alg_name(tb[2]);
+	err = PTR_ERR(ghash_name);
+	if (IS_ERR(ghash_name))
+		return ERR_PTR(err);
+
+	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
+		     ctr_name, ghash_name) >= CRYPTO_MAX_ALG_NAME)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	return crypto_gcm_alloc_common(tb, full_name, ctr_name);
+	return crypto_gcm_alloc_common(tb, full_name, ctr_name, ghash_name);
 }
 
 static struct crypto_template crypto_gcm_base_tmpl = {
@@ -784,6 +1012,10 @@ static int __init crypto_gcm_module_init(void)
 {
 	int err;
 
+	gcm_zeroes = kzalloc(16, GFP_KERNEL);
+	if (!gcm_zeroes)
+		return -ENOMEM;
+
 	err = crypto_register_template(&crypto_gcm_base_tmpl);
 	if (err)
 		goto out;
@@ -796,18 +1028,20 @@ static int __init crypto_gcm_module_init(void)
 	if (err)
 		goto out_undo_gcm;
 
-out:
-	return err;
+	return 0;
 
 out_undo_gcm:
 	crypto_unregister_template(&crypto_gcm_tmpl);
 out_undo_base:
 	crypto_unregister_template(&crypto_gcm_base_tmpl);
-	goto out;
+out:
+	kfree(gcm_zeroes);
+	return err;
 }
 
 static void __exit crypto_gcm_module_exit(void)
 {
+	kfree(gcm_zeroes);
 	crypto_unregister_template(&crypto_rfc4106_tmpl);
 	crypto_unregister_template(&crypto_gcm_tmpl);
 	crypto_unregister_template(&crypto_gcm_base_tmpl);
-- 
1.6.3.3
