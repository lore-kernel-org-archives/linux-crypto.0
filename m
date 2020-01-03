Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A91C3276C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C40FA217F4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgACBD7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 20:03:59 -0500
Received: from inva020.nxp.com ([92.121.34.13]:47412 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgACBDS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 20:03:18 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 891EE1A1B16;
        Fri,  3 Jan 2020 02:03:15 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7BCF91A1B11;
        Fri,  3 Jan 2020 02:03:15 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2856920567;
        Fri,  3 Jan 2020 02:03:15 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v2 08/10] crypto: caam - add crypto_engine support for AEAD algorithms
Date:   Fri,  3 Jan 2020 03:02:51 +0200
Message-Id: <1578013373-1956-9-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_engine support for AEAD algorithms, to make use of
the engine queue.
The requests, with backlog flag, will be listed into crypto-engine
queue and processed by CAAM when free.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 106 ++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8911c04..7cefd0a 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -122,6 +122,12 @@ struct caam_skcipher_req_ctx {
 				 void *context);
 };
 
+struct caam_aead_req_ctx {
+	struct aead_edesc *edesc;
+	void (*aead_op_done)(struct device *jrdev, u32 *desc, u32 err,
+			     void *context);
+};
+
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -999,12 +1005,14 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct caam_aead_request_entry *jrentry = context;
 	struct aead_request *req = jrentry->base;
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct aead_edesc *edesc;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 
-	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
+	edesc = rctx->edesc;
 
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
@@ -1013,7 +1021,14 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 
 	kfree(edesc);
 
-	aead_request_complete(req, ecode);
+	/*
+	 * If no backlog flag, the completion of the request is done
+	 * by CAAM, not crypto engine.
+	 */
+	if (!jrentry->bklog)
+		aead_request_complete(req, ecode);
+	else
+		crypto_finalize_aead_request(jrp->engine, req, ecode);
 }
 
 static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
@@ -1309,6 +1324,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
@@ -1411,6 +1427,9 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			 desc_bytes;
 	edesc->jrentry.base = req;
 
+	rctx->edesc = edesc;
+	rctx->aead_op_done = aead_crypt_done;
+
 	*all_contig_ptr = !(mapped_src_nents > 1);
 
 	sec4_sg_index = 0;
@@ -1441,6 +1460,28 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	return edesc;
 }
 
+static int aead_enqueue_req(struct device *jrdev, u32 *desc,
+			    void (*cbk)(struct device *jrdev, u32 *desc,
+					u32 err, void *context),
+			    struct aead_request *req, struct aead_edesc *edesc)
+{
+	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
+	int ret;
+
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		return crypto_transfer_aead_request_to_engine(jrpriv->engine,
+								  req);
+	else
+		ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done,
+				      &edesc->jrentry);
+	if (ret != -EINPROGRESS) {
+		aead_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
+
+	return ret;
+}
+
 static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 {
 	struct aead_edesc *edesc;
@@ -1449,7 +1490,6 @@ static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
 	u32 *desc;
-	int ret;
 
 	edesc = aead_edesc_alloc(req, CHACHAPOLY_DESC_JOB_IO_LEN, &all_contig,
 				 encrypt);
@@ -1463,13 +1503,7 @@ static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
-	if (ret != -EINPROGRESS) {
-		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
-
-	return ret;
+	return aead_enqueue_req(jrdev, desc, aead_crypt_done, req, edesc);
 }
 
 static int chachapoly_encrypt(struct aead_request *req)
@@ -1489,8 +1523,6 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
-	u32 *desc;
-	int ret = 0;
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,
@@ -1505,14 +1537,8 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 			     desc_bytes(edesc->hw_desc), 1);
 
-	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
-	if (ret != -EINPROGRESS) {
-		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
-
-	return ret;
+	return aead_enqueue_req(jrdev, edesc->hw_desc, aead_crypt_done, req,
+				edesc);
 }
 
 static int aead_encrypt(struct aead_request *req)
@@ -1525,6 +1551,30 @@ static int aead_decrypt(struct aead_request *req)
 	return aead_crypt(req, false);
 }
 
+static int aead_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = aead_request_cast(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_aead_request_entry *jrentry;
+	u32 *desc = rctx->edesc->hw_desc;
+	int ret;
+
+	jrentry = &rctx->edesc->jrentry;
+	jrentry->bklog = true;
+
+	ret = caam_jr_enqueue(ctx->jrdev, desc, rctx->aead_op_done, jrentry);
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
@@ -1532,8 +1582,6 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
-	u32 *desc;
-	int ret = 0;
 
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, GCM_DESC_JOB_IO_LEN, &all_contig,
@@ -1548,14 +1596,8 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 			     desc_bytes(edesc->hw_desc), 1);
 
-	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
-	if (ret != -EINPROGRESS) {
-		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
-
-	return ret;
+	return aead_enqueue_req(jrdev, edesc->hw_desc, aead_crypt_done, req,
+				edesc);
 }
 
 static int gcm_encrypt(struct aead_request *req)
@@ -3385,6 +3427,10 @@ static int caam_aead_init(struct crypto_aead *tfm)
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

