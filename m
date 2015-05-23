From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] crypto: seqiv - Stop using cryptoff
Date: Sat, 23 May 2015 15:41:56 +0800
Message-ID: <E1Yw44C-0003tI-57@gondolin.me.apana.org.au>
References: <20150523074058.GA14781@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43141 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbbEWHmA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 03:42:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yw44C-00033j-VF
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2015 17:41:57 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The cryptoff parameter was added to facilitate the skipping of
IVs that sit between the AD and the plain/cipher text.  However,
it was never implemented correctly as and we do not handle users
such as IPsec setting cryptoff.  It is simply ignored.

Implementing correctly is in fact more trouble than what it's
worth.

This patch removes the uses of cryptoff by moving the AD forward
to fill the gap left by the IV.  The AD is moved back after the
underlying AEAD processing is finished.

This is in fact beter than the cryptoff solution because it allows
algorithms that use seqniv (i.e., GCM and CCM) to hash the whole
packet as a single piece, while cryptoff meant that there was
guaranteed to be a gap.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/seqiv.c |  225 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 158 insertions(+), 67 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 2680e94..16738c5 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -26,6 +26,11 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 
+struct seqniv_request_ctx {
+	struct scatterlist dst[2];
+	struct aead_request subreq;
+};
+
 struct seqiv_ctx {
 	spinlock_t lock;
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
@@ -135,6 +140,50 @@ static void seqiv_aead_encrypt_complete(struct crypto_async_request *base,
 	aead_request_complete(req, err);
 }
 
+static void seqniv_aead_encrypt_complete2(struct aead_request *req, int err)
+{
+	unsigned int ivsize = 8;
+	u8 data[20];
+
+	if (err == -EINPROGRESS)
+		return;
+
+	/* Swap IV and ESP header back to correct order. */
+	scatterwalk_map_and_copy(data, req->dst, 0, req->assoclen + ivsize, 0);
+	scatterwalk_map_and_copy(data + ivsize, req->dst, 0, req->assoclen, 1);
+	scatterwalk_map_and_copy(data, req->dst, req->assoclen, ivsize, 1);
+}
+
+static void seqniv_aead_encrypt_complete(struct crypto_async_request *base,
+					int err)
+{
+	struct aead_request *req = base->data;
+
+	seqniv_aead_encrypt_complete2(req, err);
+	aead_request_complete(req, err);
+}
+
+static void seqniv_aead_decrypt_complete2(struct aead_request *req, int err)
+{
+	u8 data[4];
+
+	if (err == -EINPROGRESS)
+		return;
+
+	/* Move ESP header back to correct location. */
+	scatterwalk_map_and_copy(data, req->dst, 16, req->assoclen - 8, 0);
+	scatterwalk_map_and_copy(data, req->dst, 8, req->assoclen - 8, 1);
+}
+
+static void seqniv_aead_decrypt_complete(struct crypto_async_request *base,
+					 int err)
+{
+	struct aead_request *req = base->data;
+
+	seqniv_aead_decrypt_complete2(req, err);
+	aead_request_complete(req, err);
+}
+
 static void seqiv_geniv(struct seqiv_ctx *ctx, u8 *info, u64 seq,
 			unsigned int ivsize)
 {
@@ -244,45 +293,62 @@ static int seqiv_aead_encrypt_compat(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	struct aead_request *subreq = aead_request_ctx(req);
+	struct seqniv_request_ctx *rctx = aead_request_ctx(req);
+	struct aead_request *subreq = &rctx->subreq;
+	struct scatterlist *dst;
 	crypto_completion_t compl;
 	void *data;
-	u8 *info;
-	unsigned int ivsize;
+	unsigned int ivsize = 8;
+	u8 buf[20] __attribute__ ((aligned(__alignof__(u32))));
 	int err;
 
-	aead_request_set_tfm(subreq, ctx->child);
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
 
-	compl = req->base.complete;
-	data = req->base.data;
-	info = req->iv;
+	/* ESP AD is at most 12 bytes (ESN). */
+	if (req->assoclen > 12)
+		return -EINVAL;
 
-	ivsize = crypto_aead_ivsize(geniv);
+	aead_request_set_tfm(subreq, ctx->child);
 
-	if (unlikely(!IS_ALIGNED((unsigned long)info,
-				 crypto_aead_alignmask(geniv) + 1))) {
-		info = kmalloc(ivsize, req->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
-		if (!info)
-			return -ENOMEM;
+	compl = seqniv_aead_encrypt_complete;
+	data = req;
 
-		memcpy(info, req->iv, ivsize);
-		compl = seqiv_aead_encrypt_complete;
-		data = req;
+	if (req->src != req->dst) {
+		struct scatterlist srcbuf[2];
+		struct scatterlist dstbuf[2];
+		struct blkcipher_desc desc = {
+			.tfm = ctx->null,
+		};
+
+		err = crypto_blkcipher_encrypt(
+			&desc,
+			scatterwalk_ffwd(dstbuf, req->dst,
+					 req->assoclen + ivsize),
+			scatterwalk_ffwd(srcbuf, req->src,
+					 req->assoclen + ivsize),
+			req->cryptlen - ivsize);
+		if (err)
+			return err;
 	}
 
+	dst = scatterwalk_ffwd(rctx->dst, req->dst, ivsize);
+
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
-	aead_request_set_crypt(subreq, req->src, req->dst,
-			       req->cryptlen - ivsize, info);
-	aead_request_set_ad(subreq, req->assoclen, ivsize);
+	aead_request_set_crypt(subreq, dst, dst,
+			       req->cryptlen - ivsize, req->iv);
+	aead_request_set_ad(subreq, req->assoclen, 0);
 
-	crypto_xor(info, ctx->salt, ivsize);
-	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
+	memcpy(buf, req->iv, ivsize);
+	crypto_xor(buf, ctx->salt, ivsize);
+	memcpy(req->iv, buf, ivsize);
+
+	/* Swap order of IV and ESP AD for ICV generation. */
+	scatterwalk_map_and_copy(buf + ivsize, req->dst, 0, req->assoclen, 0);
+	scatterwalk_map_and_copy(buf, req->dst, 0, req->assoclen + ivsize, 1);
 
 	err = crypto_aead_encrypt(subreq);
-	if (unlikely(info != req->iv))
-		seqiv_aead_encrypt_complete2(req, err);
+	seqniv_aead_encrypt_complete2(req, err);
 	return err;
 }
 
@@ -294,17 +360,18 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 	crypto_completion_t compl;
 	void *data;
 	u8 *info;
-	unsigned int ivsize;
+	unsigned int ivsize = 8;
 	int err;
 
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
+
 	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
 	info = req->iv;
 
-	ivsize = crypto_aead_ivsize(geniv);
-
 	if (req->src != req->dst) {
 		struct scatterlist src[2];
 		struct scatterlist dst[2];
@@ -354,26 +421,64 @@ static int seqiv_aead_decrypt_compat(struct aead_request *req)
 {
 	struct crypto_aead *geniv = crypto_aead_reqtfm(req);
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	struct aead_request *subreq = aead_request_ctx(req);
+	struct seqniv_request_ctx *rctx = aead_request_ctx(req);
+	struct aead_request *subreq = &rctx->subreq;
+	struct scatterlist *dst;
 	crypto_completion_t compl;
 	void *data;
-	unsigned int ivsize;
+	unsigned int ivsize = 8;
+	u8 buf[20];
+	int err;
+
+	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
+		return -EINVAL;
 
 	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
 
-	ivsize = crypto_aead_ivsize(geniv);
+	if (req->assoclen > 12)
+		return -EINVAL;
+	else if (req->assoclen > 8) {
+		compl = seqniv_aead_decrypt_complete;
+		data = req;
+	}
+
+	if (req->src != req->dst) {
+		struct scatterlist srcbuf[2];
+		struct scatterlist dstbuf[2];
+		struct blkcipher_desc desc = {
+			.tfm = ctx->null,
+		};
+
+		err = crypto_blkcipher_encrypt(
+			&desc,
+			scatterwalk_ffwd(dstbuf, req->dst,
+					 req->assoclen + ivsize),
+			scatterwalk_ffwd(srcbuf, req->src,
+					 req->assoclen + ivsize),
+			req->cryptlen - ivsize);
+		if (err)
+			return err;
+	}
+
+	/* Move ESP AD forward for ICV generation. */
+	scatterwalk_map_and_copy(buf, req->dst, 0, req->assoclen + ivsize, 0);
+	memcpy(req->iv, buf + req->assoclen, ivsize);
+	scatterwalk_map_and_copy(buf, req->dst, ivsize, req->assoclen, 1);
+
+	dst = scatterwalk_ffwd(rctx->dst, req->dst, ivsize);
 
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
-	aead_request_set_crypt(subreq, req->src, req->dst,
+	aead_request_set_crypt(subreq, dst, dst,
 			       req->cryptlen - ivsize, req->iv);
-	aead_request_set_ad(subreq, req->assoclen, ivsize);
+	aead_request_set_ad(subreq, req->assoclen, 0);
 
-	scatterwalk_map_and_copy(req->iv, req->src, req->assoclen, ivsize, 0);
-
-	return crypto_aead_decrypt(subreq);
+	err = crypto_aead_decrypt(subreq);
+	if (req->assoclen > 8)
+		seqniv_aead_decrypt_complete2(req, err);
+	return err;
 }
 
 static int seqiv_aead_decrypt(struct aead_request *req)
@@ -383,15 +488,16 @@ static int seqiv_aead_decrypt(struct aead_request *req)
 	struct aead_request *subreq = aead_request_ctx(req);
 	crypto_completion_t compl;
 	void *data;
-	unsigned int ivsize;
+	unsigned int ivsize = 8;
+
+	if (req->cryptlen < ivsize + crypto_aead_authsize(geniv))
+		return -EINVAL;
 
 	aead_request_set_tfm(subreq, ctx->child);
 
 	compl = req->base.complete;
 	data = req->base.data;
 
-	ivsize = crypto_aead_ivsize(geniv);
-
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
 	aead_request_set_crypt(subreq, req->src, req->dst,
 			       req->cryptlen - ivsize, req->iv);
@@ -522,25 +628,7 @@ static int seqiv_old_aead_init(struct crypto_tfm *tfm)
 	return aead_geniv_init(tfm);
 }
 
-static int seqiv_aead_compat_init(struct crypto_tfm *tfm)
-{
-	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
-	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
-	int err;
-
-	spin_lock_init(&ctx->lock);
-
-	crypto_aead_set_reqsize(geniv, sizeof(struct aead_request));
-
-	err = aead_geniv_init(tfm);
-
-	ctx->child = geniv->child;
-	geniv->child = geniv;
-
-	return err;
-}
-
-static int seqiv_aead_init(struct crypto_tfm *tfm)
+static int seqiv_aead_init_common(struct crypto_tfm *tfm, unsigned int reqsize)
 {
 	struct crypto_aead *geniv = __crypto_aead_cast(tfm);
 	struct seqiv_aead_ctx *ctx = crypto_aead_ctx(geniv);
@@ -570,11 +658,14 @@ drop_null:
 	goto out;
 }
 
-static void seqiv_aead_compat_exit(struct crypto_tfm *tfm)
+static int seqiv_aead_init(struct crypto_tfm *tfm)
 {
-	struct seqiv_aead_ctx *ctx = crypto_tfm_ctx(tfm);
+	return seqiv_aead_init_common(tfm, sizeof(struct aead_request));
+}
 
-	crypto_free_aead(ctx->child);
+static int seqniv_aead_init(struct crypto_tfm *tfm)
+{
+	return seqiv_aead_init_common(tfm, sizeof(struct seqniv_request_ctx));
 }
 
 static void seqiv_aead_exit(struct crypto_tfm *tfm)
@@ -669,7 +760,7 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return seqiv_old_aead_create(tmpl, inst);
 
 	err = -EINVAL;
-	if (inst->alg.ivsize < sizeof(u64))
+	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
 
 	spawn = aead_instance_ctx(inst);
@@ -690,8 +781,8 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 		inst->alg.encrypt = seqiv_aead_encrypt_compat_first;
 		inst->alg.decrypt = seqiv_aead_decrypt_compat;
 
-		inst->alg.base.cra_init = seqiv_aead_compat_init;
-		inst->alg.base.cra_exit = seqiv_aead_compat_exit;
+		inst->alg.base.cra_init = seqniv_aead_init;
+		inst->alg.base.cra_exit = seqiv_aead_exit;
 	}
 
 	err = aead_register_instance(tmpl, inst);
@@ -747,7 +838,7 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto put_rng;
 
 	err = -EINVAL;
-	if (inst->alg.ivsize < sizeof(u64))
+	if (inst->alg.ivsize != sizeof(u64))
 		goto free_inst;
 
 	spawn = aead_instance_ctx(inst);
@@ -758,8 +849,8 @@ static int seqniv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.encrypt = seqiv_aead_encrypt_compat_first;
 	inst->alg.decrypt = seqiv_aead_decrypt_compat;
 
-	inst->alg.base.cra_init = seqiv_aead_compat_init;
-	inst->alg.base.cra_exit = seqiv_aead_compat_exit;
+	inst->alg.base.cra_init = seqniv_aead_init;
+	inst->alg.base.cra_exit = seqiv_aead_exit;
 
 	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
 	inst->alg.base.cra_ctxsize = sizeof(struct seqiv_aead_ctx);
