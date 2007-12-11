From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/8] [CRYPTO] gcm: Use ctr(4,8,4)
Date: Tue, 11 Dec 2007 11:50:22 +0800
Message-ID: <E1J1w8U-0002eQ-00@gondolin.me.apana.org.au>
References: <20071211034945.GA10099@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1775 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751838AbXLKDu2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Dec 2007 22:50:28 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J1w8V-0005pZ-Td
	for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2007 14:50:24 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] gcm: Use ctr(4,8,4)

This patch changes gcm from using ctr(0,16,4) to ctr(4,8,4).  This is
so that we can utilise the IV generator that will be built into ctr
later.

However, this also changes the key layout of gcm so that the 4-byte
salt becomes part of the key.  This is consistent with RFC 4106.

eigned-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c         |  176 ++++++++++++++++++++++++++-------------------------
 crypto/tcrypt.h      |   94 +++++++++++++--------------
 include/crypto/ctr.h |   20 +++++
 3 files changed, 159 insertions(+), 131 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 73565d6..8f35670 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/ctr.h>
 #include <crypto/gf128mul.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -21,6 +22,7 @@
 
 struct gcm_instance_ctx {
 	struct crypto_spawn ctr;
+	char cipher_name[CRYPTO_MAX_ALG_NAME];
 };
 
 struct crypto_gcm_ctx {
@@ -36,9 +38,10 @@ struct crypto_gcm_ghash_ctx {
 };
 
 struct crypto_gcm_req_priv_ctx {
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
 	u8 auth_tag[16];
 	u8 iauth_tag[16];
-	u8 counter[16];
 	struct crypto_gcm_ghash_ctx ghash;
 	struct ablkcipher_request abreq;
 };
@@ -150,44 +153,17 @@ static void crypto_gcm_ghash_final_xor(struct crypto_gcm_ghash_ctx *ctx,
 	crypto_xor(dst, buf, 16);
 }
 
-static inline void crypto_gcm_set_counter(u8 *counterblock, u32 value)
-{
-	*((u32 *)&counterblock[12]) = cpu_to_be32(value);
-}
-
-static int crypto_gcm_encrypt_counter(struct crypto_aead *aead, u8 *block,
-				       u32 value, const u8 *iv)
-{
-	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
-	struct crypto_ablkcipher *ctr = ctx->ctr;
-	struct ablkcipher_request req;
-	struct scatterlist sg;
-	u8 counterblock[16];
-
-	if (iv == NULL)
-		memset(counterblock, 0, 12);
-	else
-		memcpy(counterblock, iv, 12);
-
-	crypto_gcm_set_counter(counterblock, value);
-
-	sg_init_one(&sg, block, 16);
-	ablkcipher_request_set_tfm(&req, ctr);
-	ablkcipher_request_set_crypt(&req, &sg, &sg, 16, counterblock);
-	ablkcipher_request_set_callback(&req, 0, NULL, NULL);
-	memset(block, 0, 16);
-	return crypto_ablkcipher_encrypt(&req);
-}
-
 static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 			     unsigned int keylen)
 {
+	struct crypto_instance *inst = crypto_tfm_alg_instance(
+		crypto_aead_tfm(aead));
+	struct gcm_instance_ctx *ictx = crypto_instance_ctx(inst);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_ablkcipher *ctr = ctx->ctr;
-	int alignmask = crypto_ablkcipher_alignmask(ctr);
-	u8 alignbuf[16+alignmask];
-	u8 *hash = (u8 *)ALIGN((unsigned long)alignbuf, alignmask+1);
-	int err = 0;
+	struct crypto_cipher *cipher;
+	be128 hash;
+	int err;
 
 	crypto_ablkcipher_clear_flags(ctr, CRYPTO_TFM_REQ_MASK);
 	crypto_ablkcipher_set_flags(ctr, crypto_aead_get_flags(aead) &
@@ -195,62 +171,80 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 
 	err = crypto_ablkcipher_setkey(ctr, key, keylen);
 	if (err)
-		goto out;
+		return err;
 
 	crypto_aead_set_flags(aead, crypto_ablkcipher_get_flags(ctr) &
 				       CRYPTO_TFM_RES_MASK);
 
-	err = crypto_gcm_encrypt_counter(aead, hash, -1, NULL);
+	cipher = crypto_alloc_cipher(ictx->cipher_name, 0, 0);
+	if (IS_ERR(cipher))
+		return PTR_ERR(cipher);
+
+	err = -EINVAL;
+	if (crypto_cipher_blocksize(cipher) != sizeof(hash))
+		goto out;
+
+	crypto_cipher_clear_flags(cipher, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(cipher, crypto_aead_get_flags(aead) &
+					CRYPTO_TFM_REQ_MASK);
+	err = crypto_cipher_setkey(cipher, key,
+				   keylen - CTR_RFC3686_NONCE_SIZE);
+	crypto_aead_set_flags(aead, crypto_cipher_get_flags(cipher) &
+				    CRYPTO_TFM_RES_MASK);
+
 	if (err)
 		goto out;
 
+	memset(&hash, 0, sizeof(hash));
+	crypto_cipher_encrypt_one(cipher, (u8 *)&hash, (u8 *)&hash);
+
 	if (ctx->gf128 != NULL)
 		gf128mul_free_4k(ctx->gf128);
 
-	ctx->gf128 = gf128mul_init_4k_lle((be128 *)hash);
+	ctx->gf128 = gf128mul_init_4k_lle((be128 *)&hash);
 
 	if (ctx->gf128 == NULL)
 		err = -ENOMEM;
 
  out:
+	crypto_free_cipher(cipher);
 	return err;
 }
 
-static int crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
-				 struct aead_request *req,
-				 unsigned int cryptlen,
-				 void (*done)(struct crypto_async_request *,
-					      int))
+static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
+				  struct aead_request *req,
+				  unsigned int cryptlen)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
 	u32 flags = req->base.tfm->crt_flags;
-	u8 *auth_tag = pctx->auth_tag;
-	u8 *counter = pctx->counter;
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
-	int err = 0;
+	struct scatterlist *dst;
 
-	ablkcipher_request_set_tfm(ablk_req, ctx->ctr);
-	ablkcipher_request_set_callback(ablk_req, aead_request_flags(req),
-					done, req);
-	ablkcipher_request_set_crypt(ablk_req, req->src, req->dst,
-				     cryptlen, counter);
+	memset(pctx->auth_tag, 0, sizeof(pctx->auth_tag));
 
-	err = crypto_gcm_encrypt_counter(aead, auth_tag, 0, req->iv);
-	if (err)
-		goto out;
+	sg_init_table(pctx->src, 2);
+	sg_set_buf(pctx->src, pctx->auth_tag, sizeof(pctx->auth_tag));
+	scatterwalk_sg_chain(pctx->src, 2, req->src);
 
-	memcpy(counter, req->iv, 12);
-	crypto_gcm_set_counter(counter, 1);
+	dst = pctx->src;
+	if (req->src != req->dst) {
+		sg_init_table(pctx->dst, 2);
+		sg_set_buf(pctx->dst, pctx->auth_tag, sizeof(pctx->auth_tag));
+		scatterwalk_sg_chain(pctx->dst, 2, req->dst);
+		dst = pctx->dst;
+	}
+
+	ablkcipher_request_set_tfm(ablk_req, ctx->ctr);
+	ablkcipher_request_set_crypt(ablk_req, pctx->src, dst,
+				     cryptlen + sizeof(pctx->auth_tag),
+				     req->iv);
 
 	crypto_gcm_ghash_init(ghash, flags, ctx->gf128);
 
 	crypto_gcm_ghash_update_sg(ghash, req->assoc, req->assoclen);
 	crypto_gcm_ghash_flush(ghash);
-
- out:
-	return err;
 }
 
 static int crypto_gcm_hash(struct aead_request *req)
@@ -283,25 +277,44 @@ static int crypto_gcm_encrypt(struct aead_request *req)
 {
 	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
 	struct ablkcipher_request *abreq = &pctx->abreq;
-	int err = 0;
+	int err;
+
+	crypto_gcm_init_crypt(abreq, req, req->cryptlen);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					crypto_gcm_encrypt_done, req);
 
-	err = crypto_gcm_init_crypt(abreq, req, req->cryptlen,
-				    crypto_gcm_encrypt_done);
+	err = crypto_ablkcipher_encrypt(abreq);
 	if (err)
 		return err;
 
-	if (req->cryptlen) {
-		err = crypto_ablkcipher_encrypt(abreq);
-		if (err)
-			return err;
-	}
-
 	return crypto_gcm_hash(req);
 }
 
+static int crypto_gcm_verify(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
+	u8 *auth_tag = pctx->auth_tag;
+	u8 *iauth_tag = pctx->iauth_tag;
+	unsigned int authsize = crypto_aead_authsize(aead);
+	unsigned int cryptlen = req->cryptlen - authsize;
+
+	crypto_gcm_ghash_final_xor(ghash, req->assoclen, cryptlen, auth_tag);
+
+	authsize = crypto_aead_authsize(aead);
+	scatterwalk_map_and_copy(iauth_tag, req->src, cryptlen, authsize, 0);
+	return memcmp(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
+}
+
 static void crypto_gcm_decrypt_done(struct crypto_async_request *areq, int err)
 {
-	aead_request_complete(areq->data, err);
+	struct aead_request *req = areq->data;
+
+	if (!err)
+		err = crypto_gcm_verify(req);
+
+	aead_request_complete(req, err);
 }
 
 static int crypto_gcm_decrypt(struct aead_request *req)
@@ -309,8 +322,6 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
 	struct ablkcipher_request *abreq = &pctx->abreq;
-	u8 *auth_tag = pctx->auth_tag;
-	u8 *iauth_tag = pctx->iauth_tag;
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(aead);
@@ -320,19 +331,17 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 		return -EINVAL;
 	cryptlen -= authsize;
 
-	err = crypto_gcm_init_crypt(abreq, req, cryptlen,
-				    crypto_gcm_decrypt_done);
-	if (err)
-		return err;
+	crypto_gcm_init_crypt(abreq, req, cryptlen);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					crypto_gcm_decrypt_done, req);
 
 	crypto_gcm_ghash_update_sg(ghash, req->src, cryptlen);
-	crypto_gcm_ghash_final_xor(ghash, req->assoclen, cryptlen, auth_tag);
 
-	scatterwalk_map_and_copy(iauth_tag, req->src, cryptlen, authsize, 0);
-	if (memcmp(iauth_tag, auth_tag, authsize))
-		return -EBADMSG;
+	err = crypto_ablkcipher_decrypt(abreq);
+	if (err)
+		return err;
 
-	return crypto_ablkcipher_decrypt(abreq);
+	return crypto_gcm_verify(req);
 }
 
 static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
@@ -395,7 +404,7 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 	inst = ERR_PTR(ENAMETOOLONG);
 	if (snprintf(
 		    ctr_name, CRYPTO_MAX_ALG_NAME,
-		    "ctr(%s,0,16,4)", cipher->cra_name) >= CRYPTO_MAX_ALG_NAME)
+		    "ctr(%s,4,8,4)", cipher->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		return inst;
 
 	ctr = crypto_alg_mod_lookup(ctr_name, CRYPTO_ALG_TYPE_BLKCIPHER,
@@ -404,9 +413,6 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 	if (IS_ERR(ctr))
 		return ERR_PTR(PTR_ERR(ctr));
 
-	if (cipher->cra_blocksize != 16)
-		goto out_put_ctr;
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!inst)
@@ -425,10 +431,12 @@ static struct crypto_instance *crypto_gcm_alloc(struct rtattr **tb)
 	if (err)
 		goto err_free_inst;
 
+	memcpy(ctx->cipher_name, cipher->cra_driver_name, CRYPTO_MAX_ALG_NAME);
+
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
 	inst->alg.cra_priority = ctr->cra_priority;
 	inst->alg.cra_blocksize = 16;
-	inst->alg.cra_alignmask = __alignof__(u32) - 1;
+	inst->alg.cra_alignmask = ctr->cra_alignmask | (__alignof__(u64) - 1);
 	inst->alg.cra_type = &crypto_aead_type;
 	inst->alg.cra_aead.ivsize = 12;
 	inst->alg.cra_aead.maxauthsize = 16;
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 5b86509..ac90cf1 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -4679,12 +4679,12 @@ static struct cipher_testvec aes_ctr_dec_tv_template[] = {
 
 static struct aead_testvec aes_gcm_enc_tv_template[] = {
 	{ /* From McGrew & Viega - http://citeseer.ist.psu.edu/656989.html */
-		.klen	= 16,
+		.klen	= 20,
 		.result	= { 0x58, 0xe2, 0xfc, 0xce, 0xfa, 0x7e, 0x30, 0x61,
 			    0x36, 0x7f, 0x1d, 0x57, 0xa4, 0xe7, 0x45, 0x5a },
 		.rlen	= 16,
 	}, {
-		.klen	= 16,
+		.klen	= 20,
 		.ilen	= 16,
 		.result = { 0x03, 0x88, 0xda, 0xce, 0x60, 0xb6, 0xa3, 0x92,
 			    0xf3, 0x28, 0xc2, 0xb9, 0x71, 0xb2, 0xfe, 0x78,
@@ -4693,10 +4693,10 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 		.rlen	= 32,
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
-			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08 },
-		.klen	= 16,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 20,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0xd9, 0x31, 0x32, 0x25, 0xf8, 0x84, 0x06, 0xe5,
 			    0xa5, 0x59, 0x09, 0xc5, 0xaf, 0xf5, 0x26, 0x9a,
 			    0x86, 0xa7, 0xa9, 0x53, 0x15, 0x34, 0xf7, 0xda,
@@ -4719,10 +4719,10 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 		.rlen	= 80,
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
-			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08 },
-		.klen	= 16,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 20,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0xd9, 0x31, 0x32, 0x25, 0xf8, 0x84, 0x06, 0xe5,
 			    0xa5, 0x59, 0x09, 0xc5, 0xaf, 0xf5, 0x26, 0x9a,
 			    0x86, 0xa7, 0xa9, 0x53, 0x15, 0x34, 0xf7, 0xda,
@@ -4748,12 +4748,12 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 			    0x94, 0xfa, 0xe9, 0x5a, 0xe7, 0x12, 0x1a, 0x47 },
 		.rlen	= 76,
 	}, {
-		.klen	= 24,
+		.klen	= 28,
 		.result	= { 0xcd, 0x33, 0xb2, 0x8a, 0xc7, 0x73, 0xf7, 0x4b,
 			    0xa0, 0x0e, 0xd1, 0xf3, 0x12, 0x57, 0x24, 0x35 },
 		.rlen	= 16,
 	}, {
-		.klen	= 24,
+		.klen	= 28,
 		.ilen	= 16,
 		.result = { 0x98, 0xe7, 0x24, 0x7c, 0x07, 0xf0, 0xfe, 0x41,
 			    0x1c, 0x26, 0x7e, 0x43, 0x84, 0xb0, 0xf6, 0x00,
@@ -4763,10 +4763,10 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
 			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
-			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c },
-		.klen	= 24,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 28,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0xd9, 0x31, 0x32, 0x25, 0xf8, 0x84, 0x06, 0xe5,
 			    0xa5, 0x59, 0x09, 0xc5, 0xaf, 0xf5, 0x26, 0x9a,
 			    0x86, 0xa7, 0xa9, 0x53, 0x15, 0x34, 0xf7, 0xda,
@@ -4790,10 +4790,10 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
 			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
-			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c },
-		.klen	= 24,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 28,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0xd9, 0x31, 0x32, 0x25, 0xf8, 0x84, 0x06, 0xe5,
 			    0xa5, 0x59, 0x09, 0xc5, 0xaf, 0xf5, 0x26, 0x9a,
 			    0x86, 0xa7, 0xa9, 0x53, 0x15, 0x34, 0xf7, 0xda,
@@ -4823,7 +4823,7 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 		.anp	= 2,
 		.atap	= { 8, 12 }
 	}, {
-		.klen	= 32,
+		.klen	= 36,
 		.result	= { 0x53, 0x0f, 0x8a, 0xfb, 0xc7, 0x45, 0x36, 0xb9,
 			    0xa9, 0x63, 0xb4, 0xf1, 0xc4, 0xcb, 0x73, 0x8b },
 		.rlen	= 16,
@@ -4832,7 +4832,7 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 
 static struct aead_testvec aes_gcm_dec_tv_template[] = {
 	{ /* From McGrew & Viega - http://citeseer.ist.psu.edu/656989.html */
-		.klen	= 32,
+		.klen	= 36,
 		.input	= { 0xce, 0xa7, 0x40, 0x3d, 0x4d, 0x60, 0x6b, 0x6e,
 			    0x07, 0x4e, 0xc5, 0xd3, 0xba, 0xf3, 0x9d, 0x18,
 			    0xd0, 0xd1, 0xc8, 0xa7, 0x99, 0x99, 0x6b, 0xf0,
@@ -4843,10 +4843,10 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
 			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
 			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
-			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08 },
-		.klen	= 32,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 36,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0x52, 0x2d, 0xc1, 0xf0, 0x99, 0x56, 0x7d, 0x07,
 			    0xf4, 0x7f, 0x37, 0xa3, 0x2a, 0x84, 0x42, 0x7d,
 			    0x64, 0x3a, 0x8c, 0xdc, 0xbf, 0xe5, 0xc0, 0xc9,
@@ -4871,10 +4871,10 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
 			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
 			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
-			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08 },
-		.klen	= 32,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 36,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0x52, 0x2d, 0xc1, 0xf0, 0x99, 0x56, 0x7d, 0x07,
 			    0xf4, 0x7f, 0x37, 0xa3, 0x2a, 0x84, 0x42, 0x7d,
 			    0x64, 0x3a, 0x8c, 0xdc, 0xbf, 0xe5, 0xc0, 0xc9,
@@ -4905,10 +4905,10 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 		.atap	= { 8, 8, 4 }
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
-			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08 },
-		.klen	= 16,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 20,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0x42, 0x83, 0x1e, 0xc2, 0x21, 0x77, 0x74, 0x24,
 			    0x4b, 0x72, 0x21, 0xb7, 0x84, 0xd0, 0xd4, 0x9c,
 			    0xe3, 0xaa, 0x21, 0x2f, 0x2c, 0x02, 0xa4, 0xe0,
@@ -4931,10 +4931,10 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 		.rlen	= 64,
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
-			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08 },
-		.klen	= 16,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 20,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0x42, 0x83, 0x1e, 0xc2, 0x21, 0x77, 0x74, 0x24,
 			    0x4b, 0x72, 0x21, 0xb7, 0x84, 0xd0, 0xd4, 0x9c,
 			    0xe3, 0xaa, 0x21, 0x2f, 0x2c, 0x02, 0xa4, 0xe0,
@@ -4960,7 +4960,7 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 			    0xba, 0x63, 0x7b, 0x39 },
 		.rlen	= 60,
 	}, {
-		.klen	= 24,
+		.klen	= 28,
 		.input	= { 0x98, 0xe7, 0x24, 0x7c, 0x07, 0xf0, 0xfe, 0x41,
 			    0x1c, 0x26, 0x7e, 0x43, 0x84, 0xb0, 0xf6, 0x00,
 			    0x2f, 0xf5, 0x8d, 0x80, 0x03, 0x39, 0x27, 0xab,
@@ -4970,10 +4970,10 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
 			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
-			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c },
-		.klen	= 24,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 28,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0x39, 0x80, 0xca, 0x0b, 0x3c, 0x00, 0xe8, 0x41,
 			    0xeb, 0x06, 0xfa, 0xc4, 0x87, 0x2a, 0x27, 0x57,
 			    0x85, 0x9e, 0x1c, 0xea, 0xa6, 0xef, 0xd9, 0x84,
@@ -4997,10 +4997,10 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 	}, {
 		.key	= { 0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
 			    0x6d, 0x6a, 0x8f, 0x94, 0x67, 0x30, 0x83, 0x08,
-			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c },
-		.klen	= 24,
-		.iv	= { 0xca, 0xfe, 0xba, 0xbe, 0xfa, 0xce, 0xdb, 0xad,
-			    0xde, 0xca, 0xf8, 0x88 },
+			    0xfe, 0xff, 0xe9, 0x92, 0x86, 0x65, 0x73, 0x1c,
+			    0xca, 0xfe, 0xba, 0xbe },
+		.klen	= 28,
+		.iv	= { 0xfa, 0xce, 0xdb, 0xad, 0xde, 0xca, 0xf8, 0x88 },
 		.input	= { 0x39, 0x80, 0xca, 0x0b, 0x3c, 0x00, 0xe8, 0x41,
 			    0xeb, 0x06, 0xfa, 0xc4, 0x87, 0x2a, 0x27, 0x57,
 			    0x85, 0x9e, 0x1c, 0xea, 0xa6, 0xef, 0xd9, 0x84,
diff --git a/include/crypto/ctr.h b/include/crypto/ctr.h
new file mode 100644
index 0000000..4180fc0
--- /dev/null
+++ b/include/crypto/ctr.h
@@ -0,0 +1,20 @@
+/*
+ * CTR: Counter mode
+ *
+ * Copyright (c) 2007 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#ifndef _CRYPTO_CTR_H
+#define _CRYPTO_CTR_H
+
+#define CTR_RFC3686_NONCE_SIZE 4
+#define CTR_RFC3686_IV_SIZE 8
+#define CTR_RFC3686_BLOCK_SIZE 16
+
+#endif  /* _CRYPTO_CTR_H */
