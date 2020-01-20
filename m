Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88620C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 12:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F88221569
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 12:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgATMZH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:25:07 -0500
Received: from inva021.nxp.com ([92.121.34.21]:46926 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbgATMYT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 07:24:19 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7A2C02002A0;
        Mon, 20 Jan 2020 13:24:17 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6C8B520058E;
        Mon, 20 Jan 2020 13:24:17 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EC74A20414;
        Mon, 20 Jan 2020 13:24:16 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v4 7/9] crypto: caam - add crypto_engine support for AEAD algorithms
Date:   Mon, 20 Jan 2020 14:24:06 +0200
Message-Id: <1579523048-21078-8-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
References: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_engine support for AEAD algorithms, to make use of
the engine queue.
The requests, with backlog flag, will be listed into crypto-engine
queue and processed by CAAM when free.
If sending just the backlog request to crypto-engine, and non-blocking
directly to CAAM, the latter requests have a better chance to be
executed since JR has up to 1024 entries, more than the 10 entries
from crypto-engine.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 108 ++++++++++++++++++++++++++++++------------
 1 file changed, 78 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 292db60..0f20bcf 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -120,6 +120,10 @@ struct caam_skcipher_req_ctx {
 	struct skcipher_edesc *edesc;
 };
 
+struct caam_aead_req_ctx {
+	struct aead_edesc *edesc;
+};
+
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -865,6 +869,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg_dma: bus physical mapped address of h/w link table
+ * @bklog: stored to determine if the request needs backlog
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  */
@@ -875,6 +880,7 @@ struct aead_edesc {
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
+	bool bklog;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[];
 };
@@ -953,12 +959,14 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 			    void *context)
 {
 	struct aead_request *req = context;
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct aead_edesc *edesc;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 
-	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
+	edesc = rctx->edesc;
 
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
@@ -967,7 +975,14 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	kfree(edesc);
 
-	aead_request_complete(req, ecode);
+	/*
+	 * If no backlog flag, the completion of the request is done
+	 * by CAAM, not crypto engine.
+	 */
+	if (!edesc->bklog)
+		aead_request_complete(req, ecode);
+	else
+		crypto_finalize_aead_request(jrp->engine, req, ecode);
 }
 
 static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
@@ -1262,6 +1277,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
@@ -1362,6 +1378,10 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	edesc->mapped_dst_nents = mapped_dst_nents;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
+
+	edesc->bklog = false;
+	rctx->edesc = edesc;
+
 	*all_contig_ptr = !(mapped_src_nents > 1);
 
 	sec4_sg_index = 0;
@@ -1392,6 +1412,33 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	return edesc;
 }
 
+static int aead_enqueue_req(struct device *jrdev, struct aead_request *req)
+{
+	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct aead_edesc *edesc = rctx->edesc;
+	u32 *desc = edesc->hw_desc;
+	int ret;
+
+	/*
+	 * Only the backlog request are sent to crypto-engine since the others
+	 * can be handled by CAAM, if free, especially since JR has up to 1024
+	 * entries (more than the 10 entries from crypto-engine).
+	 */
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		ret = crypto_transfer_aead_request_to_engine(jrpriv->engine,
+							     req);
+	else
+		ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
+
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
+		aead_unmap(jrdev, edesc, req);
+		kfree(rctx->edesc);
+	}
+
+	return ret;
+}
+
 static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 {
 	struct aead_edesc *edesc;
@@ -1400,7 +1447,6 @@ static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
 	u32 *desc;
-	int ret;
 
 	edesc = aead_edesc_alloc(req, CHACHAPOLY_DESC_JOB_IO_LEN, &all_contig,
 				 encrypt);
@@ -1414,13 +1460,7 @@ static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
-	if (ret != -EINPROGRESS) {
-		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
-
-	return ret;
+	return aead_enqueue_req(jrdev, req);
 }
 
 static int chachapoly_encrypt(struct aead_request *req)
@@ -1440,8 +1480,6 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
-	u32 *desc;
-	int ret = 0;
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,
@@ -1456,14 +1494,7 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 			     desc_bytes(edesc->hw_desc), 1);
 
-	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
-	if (ret != -EINPROGRESS) {
-		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
-
-	return ret;
+	return aead_enqueue_req(jrdev, req);
 }
 
 static int aead_encrypt(struct aead_request *req)
@@ -1476,6 +1507,28 @@ static int aead_decrypt(struct aead_request *req)
 	return aead_crypt(req, false);
 }
 
+static int aead_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = aead_request_cast(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	u32 *desc = rctx->edesc->hw_desc;
+	int ret;
+
+	rctx->edesc->bklog = true;
+
+	ret = caam_jr_enqueue(ctx->jrdev, desc, aead_crypt_done, req);
+
+	if (ret != -EINPROGRESS) {
+		aead_unmap(ctx->jrdev, rctx->edesc, req);
+		kfree(rctx->edesc);
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
 static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 {
 	struct aead_edesc *edesc;
@@ -1483,8 +1536,6 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
-	u32 *desc;
-	int ret = 0;
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, GCM_DESC_JOB_IO_LEN, &all_contig,
@@ -1499,14 +1550,7 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 			     desc_bytes(edesc->hw_desc), 1);
 
-	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
-	if (ret != -EINPROGRESS) {
-		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
-
-	return ret;
+	return aead_enqueue_req(jrdev, req);
 }
 
 static int gcm_encrypt(struct aead_request *req)
@@ -3336,6 +3380,10 @@ static int caam_aead_init(struct crypto_aead *tfm)
 		 container_of(alg, struct caam_aead_alg, aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
 
+	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
+
+	ctx->enginectx.op.do_one_request = aead_do_one_req;
+
 	return caam_init_common(ctx, &caam_alg->caam, !caam_alg->caam.nodkp);
 }
 
-- 
2.1.0

