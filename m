Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D87C05027
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 12:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjBJMUc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 07:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjBJMUb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 07:20:31 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B186E578
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 04:20:28 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQSO4-009f0n-2x; Fri, 10 Feb 2023 20:20:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Feb 2023 20:20:20 +0800
Date:   Fri, 10 Feb 2023 20:20:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com, Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: [v2 PATCH 6/32] crypto: hash - Use crypto_request_complete
Message-ID: <Y+Y2hGEdBvA4fCuT@gondor.apana.org.au>
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
 <E1pMlaV-005vfk-Vj@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pMlaV-005vfk-Vj@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v2 fixes the problem of the broken hash state in subreq.

---8<---
Use the crypto_request_complete helper instead of calling the
completion function directly.

This patch also removes the voodoo programming previously used
for unaligned ahash operations and replaces it with a sub-request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |  179 ++++++++++++++++-------------------------
 include/crypto/internal/hash.h |    2 
 2 files changed, 75 insertions(+), 106 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 4b089f1b770f..19241b18a4d1 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -190,133 +190,98 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
-static inline unsigned int ahash_align_buffer_size(unsigned len,
-						   unsigned long mask)
-{
-	return len + (mask & ~(crypto_tfm_ctx_alignment() - 1));
-}
-
-static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
+static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt,
+			  bool has_state)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	unsigned long alignmask = crypto_ahash_alignmask(tfm);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
-	struct ahash_request_priv *priv;
+	struct ahash_request *subreq;
+	unsigned int subreq_size;
+	unsigned int reqsize;
+	u8 *result;
+	gfp_t gfp;
+	u32 flags;
 
-	priv = kmalloc(sizeof(*priv) + ahash_align_buffer_size(ds, alignmask),
-		       (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		       GFP_KERNEL : GFP_ATOMIC);
-	if (!priv)
+	subreq_size = sizeof(*subreq);
+	reqsize = crypto_ahash_reqsize(tfm);
+	reqsize = ALIGN(reqsize, crypto_tfm_ctx_alignment());
+	subreq_size += reqsize;
+	subreq_size += ds;
+	subreq_size += alignmask & ~(crypto_tfm_ctx_alignment() - 1);
+
+	flags = ahash_request_flags(req);
+	gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?  GFP_KERNEL : GFP_ATOMIC;
+	subreq = kmalloc(subreq_size, gfp);
+	if (!subreq)
 		return -ENOMEM;
 
-	/*
-	 * WARNING: Voodoo programming below!
-	 *
-	 * The code below is obscure and hard to understand, thus explanation
-	 * is necessary. See include/crypto/hash.h and include/linux/crypto.h
-	 * to understand the layout of structures used here!
-	 *
-	 * The code here will replace portions of the ORIGINAL request with
-	 * pointers to new code and buffers so the hashing operation can store
-	 * the result in aligned buffer. We will call the modified request
-	 * an ADJUSTED request.
-	 *
-	 * The newly mangled request will look as such:
-	 *
-	 * req {
-	 *   .result        = ADJUSTED[new aligned buffer]
-	 *   .base.complete = ADJUSTED[pointer to completion function]
-	 *   .base.data     = ADJUSTED[*req (pointer to self)]
-	 *   .priv          = ADJUSTED[new priv] {
-	 *           .result   = ORIGINAL(result)
-	 *           .complete = ORIGINAL(base.complete)
-	 *           .data     = ORIGINAL(base.data)
-	 *   }
-	 */
-
-	priv->result = req->result;
-	priv->complete = req->base.complete;
-	priv->data = req->base.data;
-	priv->flags = req->base.flags;
-
-	/*
-	 * WARNING: We do not backup req->priv here! The req->priv
-	 *          is for internal use of the Crypto API and the
-	 *          user must _NOT_ _EVER_ depend on it's content!
-	 */
-
-	req->result = PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
-	req->base.complete = cplt;
-	req->base.data = req;
-	req->priv = priv;
+	ahash_request_set_tfm(subreq, tfm);
+	ahash_request_set_callback(subreq, flags, cplt, req);
+
+	result = (u8 *)(subreq + 1) + reqsize;
+	result = PTR_ALIGN(result, alignmask + 1);
+
+	ahash_request_set_crypt(subreq, req->src, result, req->nbytes);
+
+	if (has_state) {
+		void *state;
+
+		state = kmalloc(crypto_ahash_statesize(tfm), gfp);
+		if (!state) {
+			kfree(subreq);
+			return -ENOMEM;
+		}
+
+		crypto_ahash_export(req, state);
+		crypto_ahash_import(subreq, state);
+		kfree_sensitive(state);
+	}
+
+	req->priv = subreq;
 
 	return 0;
 }
 
 static void ahash_restore_req(struct ahash_request *req, int err)
 {
-	struct ahash_request_priv *priv = req->priv;
+	struct ahash_request *subreq = req->priv;
 
 	if (!err)
-		memcpy(priv->result, req->result,
+		memcpy(req->result, subreq->result,
 		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
 
-	/* Restore the original crypto request. */
-	req->result = priv->result;
-
-	ahash_request_set_callback(req, priv->flags,
-				   priv->complete, priv->data);
 	req->priv = NULL;
 
-	/* Free the req->priv.priv from the ADJUSTED request. */
-	kfree_sensitive(priv);
-}
-
-static void ahash_notify_einprogress(struct ahash_request *req)
-{
-	struct ahash_request_priv *priv = req->priv;
-	struct crypto_async_request oreq;
-
-	oreq.data = priv->data;
-
-	priv->complete(&oreq, -EINPROGRESS);
+	kfree_sensitive(subreq);
 }
 
 static void ahash_op_unaligned_done(struct crypto_async_request *req, int err)
 {
 	struct ahash_request *areq = req->data;
 
-	if (err == -EINPROGRESS) {
-		ahash_notify_einprogress(areq);
-		return;
-	}
-
-	/*
-	 * Restore the original request, see ahash_op_unaligned() for what
-	 * goes where.
-	 *
-	 * The "struct ahash_request *req" here is in fact the "req.base"
-	 * from the ADJUSTED request from ahash_op_unaligned(), thus as it
-	 * is a pointer to self, it is also the ADJUSTED "req" .
-	 */
+	if (err == -EINPROGRESS)
+		goto out;
 
 	/* First copy req->result into req->priv.result */
 	ahash_restore_req(areq, err);
 
+out:
 	/* Complete the ORIGINAL request. */
-	areq->base.complete(&areq->base, err);
+	ahash_request_complete(areq, err);
 }
 
 static int ahash_op_unaligned(struct ahash_request *req,
-			      int (*op)(struct ahash_request *))
+			      int (*op)(struct ahash_request *),
+			      bool has_state)
 {
 	int err;
 
-	err = ahash_save_req(req, ahash_op_unaligned_done);
+	err = ahash_save_req(req, ahash_op_unaligned_done, has_state);
 	if (err)
 		return err;
 
-	err = op(req);
+	err = op(req->priv);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
@@ -326,13 +291,14 @@ static int ahash_op_unaligned(struct ahash_request *req,
 }
 
 static int crypto_ahash_op(struct ahash_request *req,
-			   int (*op)(struct ahash_request *))
+			   int (*op)(struct ahash_request *),
+			   bool has_state)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	unsigned long alignmask = crypto_ahash_alignmask(tfm);
 
 	if ((unsigned long)req->result & alignmask)
-		return ahash_op_unaligned(req, op);
+		return ahash_op_unaligned(req, op, has_state);
 
 	return op(req);
 }
@@ -345,7 +311,7 @@ int crypto_ahash_final(struct ahash_request *req)
 	int ret;
 
 	crypto_stats_get(alg);
-	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
+	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final, true);
 	crypto_stats_ahash_final(nbytes, ret, alg);
 	return ret;
 }
@@ -359,7 +325,7 @@ int crypto_ahash_finup(struct ahash_request *req)
 	int ret;
 
 	crypto_stats_get(alg);
-	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
+	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup, true);
 	crypto_stats_ahash_final(nbytes, ret, alg);
 	return ret;
 }
@@ -376,7 +342,7 @@ int crypto_ahash_digest(struct ahash_request *req)
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		ret = -ENOKEY;
 	else
-		ret = crypto_ahash_op(req, tfm->digest);
+		ret = crypto_ahash_op(req, tfm->digest, false);
 	crypto_stats_ahash_final(nbytes, ret, alg);
 	return ret;
 }
@@ -391,17 +357,19 @@ static void ahash_def_finup_done2(struct crypto_async_request *req, int err)
 
 	ahash_restore_req(areq, err);
 
-	areq->base.complete(&areq->base, err);
+	ahash_request_complete(areq, err);
 }
 
 static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 {
+	struct ahash_request *subreq = req->priv;
+
 	if (err)
 		goto out;
 
-	req->base.complete = ahash_def_finup_done2;
+	subreq->base.complete = ahash_def_finup_done2;
 
-	err = crypto_ahash_reqtfm(req)->final(req);
+	err = crypto_ahash_reqtfm(req)->final(subreq);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
@@ -413,19 +381,20 @@ static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 static void ahash_def_finup_done1(struct crypto_async_request *req, int err)
 {
 	struct ahash_request *areq = req->data;
+	struct ahash_request *subreq;
 
-	if (err == -EINPROGRESS) {
-		ahash_notify_einprogress(areq);
-		return;
-	}
+	if (err == -EINPROGRESS)
+		goto out;
 
-	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+	subreq = areq->priv;
+	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 
 	err = ahash_def_finup_finish1(areq, err);
-	if (areq->priv)
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
-	areq->base.complete(&areq->base, err);
+out:
+	ahash_request_complete(areq, err);
 }
 
 static int ahash_def_finup(struct ahash_request *req)
@@ -433,11 +402,11 @@ static int ahash_def_finup(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	int err;
 
-	err = ahash_save_req(req, ahash_def_finup_done1);
+	err = ahash_save_req(req, ahash_def_finup_done1, true);
 	if (err)
 		return err;
 
-	err = tfm->update(req);
+	err = tfm->update(req->priv);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 1a2a41b79253..0b259dbb97af 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -199,7 +199,7 @@ static inline void *ahash_request_ctx_dma(struct ahash_request *req)
 
 static inline void ahash_request_complete(struct ahash_request *req, int err)
 {
-	req->base.complete(&req->base, err);
+	crypto_request_complete(&req->base, err);
 }
 
 static inline u32 ahash_request_flags(struct ahash_request *req)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
