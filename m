Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51DEC636CD
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 08:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjAaICF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 03:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjAaICA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 03:02:00 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8CD42BE2
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 00:01:58 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMlaV-005vfk-Vj; Tue, 31 Jan 2023 16:01:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 31 Jan 2023 16:01:55 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 31 Jan 2023 16:01:55 +0800
Subject: [PATCH 6/32] crypto: hash - Use crypto_request_complete
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
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
Message-Id: <E1pMlaV-005vfk-Vj@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the crypto_request_complete helper instead of calling the
completion function directly.

This patch also removes the voodoo programming previously used
for unaligned ahash operations and replaces it with a sub-request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |  137 +++++++++++++----------------------------
 include/crypto/internal/hash.h |    2 
 2 files changed, 45 insertions(+), 94 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 4b089f1b770f..369447e483cd 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -190,121 +190,69 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
-static inline unsigned int ahash_align_buffer_size(unsigned len,
-						   unsigned long mask)
-{
-	return len + (mask & ~(crypto_tfm_ctx_alignment() - 1));
-}
-
 static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	unsigned long alignmask = crypto_ahash_alignmask(tfm);
 	unsigned int ds = crypto_ahash_digestsize(tfm);
-	struct ahash_request_priv *priv;
+	struct ahash_request *subreq;
+	unsigned int subreq_size;
+	unsigned int reqsize;
+	u8 *result;
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
+	subreq = kmalloc(subreq_size, (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+				      GFP_KERNEL : GFP_ATOMIC);
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
@@ -391,15 +339,17 @@ static void ahash_def_finup_done2(struct crypto_async_request *req, int err)
 
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
 
 	err = crypto_ahash_reqtfm(req)->final(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
@@ -413,19 +363,20 @@ static int ahash_def_finup_finish1(struct ahash_request *req, int err)
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
