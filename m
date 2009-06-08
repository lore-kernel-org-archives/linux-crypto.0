From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 3/5] eseqiv: Add support for aead algorithms
Date: Mon, 8 Jun 2009 09:10:46 +0200
Message-ID: <20090608071046.GU20366@secunet.com>
References: <20090608070749.GR20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:58230 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbZFHHIT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2009 03:08:19 -0400
Content-Disposition: inline
In-Reply-To: <20090608070749.GR20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds eseqiv support for aead algorithms, this is usefull
for aead algorithms that need eseqiv as it's default IV generator.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/eseqiv.c        |  244 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/crypto.h |    1 +
 2 files changed, 232 insertions(+), 13 deletions(-)

diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 3ca3b66..04a8bba 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -15,6 +15,7 @@
  *
  */
 
+#include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/rng.h>
 #include <crypto/scatterwalk.h>
@@ -62,6 +63,29 @@ out:
 	skcipher_givcrypt_complete(req, err);
 }
 
+static void eseqiv_aead_complete2(struct aead_givcrypt_request *req)
+{
+	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
+	struct eseqiv_request_ctx *reqctx = aead_givcrypt_reqctx(req);
+
+	memcpy(req->giv, PTR_ALIGN((u8 *)reqctx->tail,
+			 crypto_aead_alignmask(geniv) + 1),
+	       crypto_aead_ivsize(geniv));
+}
+
+static void eseqiv_aead_complete(struct crypto_async_request *base, int err)
+{
+	struct aead_givcrypt_request *req = base->data;
+
+	if (err)
+		goto out;
+
+	eseqiv_aead_complete2(req);
+
+out:
+	aead_givcrypt_complete(req, err);
+}
+
 static void eseqiv_chain(struct scatterlist *head, struct scatterlist *sg,
 			 int chain)
 {
@@ -155,6 +179,90 @@ static int eseqiv_givencrypt(struct skcipher_givcrypt_request *req)
 
 	if (giv != req->giv)
 		eseqiv_complete2(req);
+out:
+	return err;
+}
+
+static int eseqiv_aead_givencrypt(struct aead_givcrypt_request *req)
+{
+	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
+	struct eseqiv_ctx *ctx = crypto_aead_ctx(geniv);
+	struct eseqiv_request_ctx *reqctx = aead_givcrypt_reqctx(req);
+	struct aead_request *subreq;
+	crypto_completion_t complete;
+	void *data;
+	struct scatterlist *osrc, *odst;
+	struct scatterlist *dst;
+	struct page *srcp;
+	struct page *dstp;
+	u8 *giv;
+	u8 *vsrc;
+	u8 *vdst;
+	__be64 seq;
+	unsigned int ivsize;
+	unsigned int len;
+	unsigned int flags;
+	int err;
+
+	subreq = (void *)(reqctx->tail + ctx->reqoff);
+	aead_request_set_tfm(subreq, aead_geniv_base(geniv));
+
+	giv = req->giv;
+	complete = req->areq.base.complete;
+	data = req->areq.base.data;
+
+	osrc = req->areq.src;
+	odst = req->areq.dst;
+	srcp = sg_page(osrc);
+	dstp = sg_page(odst);
+	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + osrc->offset;
+	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + odst->offset;
+
+	ivsize = crypto_aead_ivsize(geniv);
+	flags = req->areq.base.flags | CRYPTO_TFM_REQ_SG_HAS_IV;
+
+	if (vsrc != giv + ivsize && vdst != giv + ivsize) {
+		giv = PTR_ALIGN((u8 *)reqctx->tail,
+				crypto_aead_alignmask(geniv) + 1);
+		complete = eseqiv_aead_complete;
+		data = req;
+	}
+
+	aead_request_set_callback(subreq, flags, complete, data);
+
+	sg_init_table(reqctx->src, 2);
+	sg_set_buf(reqctx->src, giv, ivsize);
+	eseqiv_chain(reqctx->src, osrc, vsrc == giv + ivsize);
+
+	dst = reqctx->src;
+	if (osrc != odst) {
+		sg_init_table(reqctx->dst, 2);
+		sg_set_buf(reqctx->dst, giv, ivsize);
+		eseqiv_chain(reqctx->dst, odst, vdst == giv + ivsize);
+
+		dst = reqctx->dst;
+	}
+
+	aead_request_set_crypt(subreq, reqctx->src, dst,
+				     req->areq.cryptlen + ivsize, req->areq.iv);
+	aead_request_set_assoc(subreq, req->areq.assoc, req->areq.assoclen);
+
+	memcpy(req->areq.iv, ctx->salt, ivsize);
+
+	len = ivsize;
+	if (ivsize > sizeof(u64)) {
+		memset(req->giv, 0, ivsize - sizeof(u64));
+		len = sizeof(u64);
+	}
+	seq = cpu_to_be64(req->seq);
+	memcpy(req->giv + ivsize - len, &seq, len);
+
+	err = crypto_aead_encrypt(subreq);
+	if (err)
+		goto out;
+
+	if (giv != req->giv)
+		eseqiv_aead_complete2(req);
 
 out:
 	return err;
@@ -183,6 +291,29 @@ unlock:
 	return eseqiv_givencrypt(req);
 }
 
+static int eseqiv_aead_givencrypt_first(struct aead_givcrypt_request *req)
+{
+	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
+	struct eseqiv_ctx *ctx = crypto_aead_ctx(geniv);
+	int err = 0;
+
+	spin_lock_bh(&ctx->lock);
+	if (crypto_aead_crt(geniv)->givencrypt != eseqiv_aead_givencrypt_first)
+		goto unlock;
+
+	crypto_aead_crt(geniv)->givencrypt = eseqiv_aead_givencrypt;
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(geniv));
+
+unlock:
+	spin_unlock_bh(&ctx->lock);
+
+	if (err)
+		return err;
+
+	return eseqiv_aead_givencrypt(req);
+}
+
 static int eseqiv_init(struct crypto_tfm *tfm)
 {
 	struct crypto_ablkcipher *geniv = __crypto_ablkcipher_cast(tfm);
@@ -215,20 +346,47 @@ static int eseqiv_init(struct crypto_tfm *tfm)
 	return skcipher_geniv_init(tfm);
 }
 
+static int eseqiv_aead_init(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
+	struct eseqiv_ctx *ctx = crypto_aead_ctx(geniv);
+	unsigned long alignmask;
+	unsigned int reqsize;
+
+	spin_lock_init(&ctx->lock);
+
+	alignmask = crypto_tfm_ctx_alignment() - 1;
+	reqsize = sizeof(struct eseqiv_request_ctx);
+
+	if (alignmask & reqsize) {
+		alignmask &= reqsize;
+		alignmask--;
+	}
+
+	alignmask = ~alignmask;
+	alignmask &= crypto_aead_alignmask(geniv);
+
+	reqsize += alignmask;
+	reqsize += crypto_aead_ivsize(geniv);
+	reqsize = ALIGN(reqsize, crypto_tfm_ctx_alignment());
+
+	ctx->reqoff = reqsize - sizeof(struct eseqiv_request_ctx);
+
+	tfm->crt_aead.reqsize = reqsize + sizeof(struct aead_request);
+
+	return aead_geniv_init(tfm);
+}
+
 static struct crypto_template eseqiv_tmpl;
 
-static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
+static struct crypto_instance *eseqiv_ablkcipher_alloc(struct rtattr **tb)
 {
-	struct crypto_instance *inst;
 	int err;
-
-	err = crypto_get_default_rng();
-	if (err)
-		return ERR_PTR(err);
+	struct crypto_instance *inst;
 
 	inst = skcipher_geniv_alloc(&eseqiv_tmpl, tb, 0, 0);
 	if (IS_ERR(inst))
-		goto put_rng;
+		goto out;
 
 	err = -EINVAL;
 	if (inst->alg.cra_ablkcipher.ivsize != inst->alg.cra_blocksize)
@@ -236,18 +394,75 @@ static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
 
 	inst->alg.cra_ablkcipher.givencrypt = eseqiv_givencrypt_first;
 
-	inst->alg.cra_init = eseqiv_init;
-	inst->alg.cra_exit = skcipher_geniv_exit;
+	 inst->alg.cra_init = eseqiv_init;
+	 inst->alg.cra_exit = skcipher_geniv_exit;
 
-	inst->alg.cra_ctxsize = sizeof(struct eseqiv_ctx);
-	inst->alg.cra_ctxsize += inst->alg.cra_ablkcipher.ivsize;
+	inst->alg.cra_ctxsize = inst->alg.cra_ablkcipher.ivsize;
 
 out:
 	return inst;
 
 free_inst:
 	skcipher_geniv_free(inst);
-	inst = ERR_PTR(err);
+	return ERR_PTR(err);
+}
+
+static struct crypto_instance *eseqiv_aead_alloc(struct rtattr **tb)
+{
+	int err;
+	struct crypto_instance *inst;
+
+	inst = aead_geniv_alloc(&eseqiv_tmpl, tb, 0, 0);
+	if (IS_ERR(inst))
+		goto out;
+
+	err = -EINVAL;
+	if (inst->alg.cra_aead.ivsize != inst->alg.cra_blocksize)
+		goto free_inst;
+
+	inst->alg.cra_aead.givencrypt = eseqiv_aead_givencrypt_first;
+
+	 inst->alg.cra_init = eseqiv_aead_init;
+	 inst->alg.cra_exit = aead_geniv_exit;
+
+	inst->alg.cra_ctxsize = inst->alg.cra_aead.ivsize;
+
+out:
+	return inst;
+
+free_inst:
+	aead_geniv_free(inst);
+	return ERR_PTR(err);
+}
+
+static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
+{
+	struct crypto_attr_type *algt;
+	struct crypto_instance *inst;
+	int err;
+
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
+		return ERR_PTR(err);
+
+	err = crypto_get_default_rng();
+	if (err)
+		return ERR_PTR(err);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
+		inst = eseqiv_ablkcipher_alloc(tb);
+	else
+		inst = eseqiv_aead_alloc(tb);
+
+	if (IS_ERR(inst))
+		goto put_rng;
+
+	inst->alg.cra_ctxsize += sizeof(struct eseqiv_ctx);
+
+out:
+	return inst;
+
 put_rng:
 	crypto_put_default_rng();
 	goto out;
@@ -255,7 +470,10 @@ put_rng:
 
 static void eseqiv_free(struct crypto_instance *inst)
 {
-	skcipher_geniv_free(inst);
+	if ((inst->alg.cra_flags ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
+		skcipher_geniv_free(inst);
+	else
+		aead_geniv_free(inst);
 	crypto_put_default_rng();
 }
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ec29fa2..1af50e6 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -80,6 +80,7 @@
 #define CRYPTO_TFM_REQ_WEAK_KEY		0x00000100
 #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
 #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
+#define CRYPTO_TFM_REQ_SG_HAS_IV	0x00000800
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
 #define CRYPTO_TFM_RES_BAD_KEY_LEN   	0x00200000
 #define CRYPTO_TFM_RES_BAD_KEY_SCHED 	0x00400000
-- 
1.5.4.2

