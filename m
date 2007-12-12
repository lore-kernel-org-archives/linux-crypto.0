From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/10] [CRYPTO] gcm: Fix request context alignment
Date: Wed, 12 Dec 2007 20:30:52 +0800
Message-ID: <E1J2Qjk-0006dI-00@gondolin.me.apana.org.au>
References: <20071212122944.GA25381@gondor.apana.org.au>
To: Joy Latten <latten@austin.ibm.com>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3722 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758021AbXLLMa5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Dec 2007 07:30:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] gcm: Fix request context alignment

This patch fixes the request context alignment so that it is actually
aligned to the value required by the algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 7775ea0..6c08587 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -37,14 +37,22 @@ struct crypto_gcm_ghash_ctx {
 };
 
 struct crypto_gcm_req_priv_ctx {
-	struct scatterlist src[2];
-	struct scatterlist dst[2];
 	u8 auth_tag[16];
 	u8 iauth_tag[16];
+	struct scatterlist src[2];
+	struct scatterlist dst[2];
 	struct crypto_gcm_ghash_ctx ghash;
 	struct skcipher_givcrypt_request greq;
 };
 
+static inline struct crypto_gcm_req_priv_ctx *crypto_gcm_reqctx(
+	struct aead_request *req)
+{
+	unsigned long align = crypto_aead_alignmask(crypto_aead_reqtfm(req));
+
+	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
+}
+
 static void crypto_gcm_ghash_init(struct crypto_gcm_ghash_ctx *ctx, u32 flags,
 				  struct gf128mul_4k *gf128)
 {
@@ -216,7 +224,7 @@ static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	u32 flags = req->base.tfm->crt_flags;
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	struct scatterlist *dst;
@@ -249,7 +257,7 @@ static void crypto_gcm_init_crypt(struct ablkcipher_request *ablk_req,
 static int crypto_gcm_hash(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	u8 *auth_tag = pctx->auth_tag;
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 
@@ -282,7 +290,7 @@ static void crypto_gcm_init_encrypt(struct ablkcipher_request *abreq,
 
 static int crypto_gcm_encrypt(struct aead_request *req)
 {
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ablkcipher_request *abreq = &pctx->greq.creq;
 	int err;
 
@@ -298,7 +306,7 @@ static int crypto_gcm_encrypt(struct aead_request *req)
 static int crypto_gcm_givencrypt(struct aead_givcrypt_request *req)
 {
 	struct aead_request *areq = &req->areq;
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(areq);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(areq);
 	struct skcipher_givcrypt_request *greq = &pctx->greq;
 	struct ablkcipher_request *abreq = &greq->creq;
 	int err;
@@ -316,7 +324,7 @@ static int crypto_gcm_givencrypt(struct aead_givcrypt_request *req)
 static int crypto_gcm_verify(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	u8 *auth_tag = pctx->auth_tag;
 	u8 *iauth_tag = pctx->iauth_tag;
@@ -344,7 +352,7 @@ static int crypto_gcm_init_decrypt(struct ablkcipher_request *abreq,
 				   struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct crypto_gcm_ghash_ctx *ghash = &pctx->ghash;
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int authsize = crypto_aead_authsize(aead);
@@ -363,7 +371,7 @@ static int crypto_gcm_init_decrypt(struct ablkcipher_request *abreq,
 
 static int crypto_gcm_decrypt(struct aead_request *req)
 {
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(req);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(req);
 	struct ablkcipher_request *abreq = &pctx->greq.creq;
 	int err;
 
@@ -381,7 +389,7 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 static int crypto_gcm_givdecrypt(struct aead_givcrypt_request *req)
 {
 	struct aead_request *areq = &req->areq;
-	struct crypto_gcm_req_priv_ctx *pctx = aead_request_ctx(areq);
+	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(areq);
 	struct skcipher_givcrypt_request *greq = &pctx->greq;
 	struct ablkcipher_request *abreq = &greq->creq;
 	int err;
@@ -416,8 +424,7 @@ static int crypto_gcm_init_tfm(struct crypto_tfm *tfm)
 	ctx->ctr = ctr;
 	ctx->gf128 = NULL;
 
-	align = max_t(unsigned long, crypto_ablkcipher_alignmask(ctr),
-		      __alignof__(u32) - 1);
+	align = crypto_tfm_alg_alignmask(tfm);
 	align &= ~(crypto_tfm_ctx_alignment() - 1);
 	tfm->crt_aead.reqsize = align +
 				sizeof(struct crypto_gcm_req_priv_ctx) +
