Return-Path: <SRS0=stso=4A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6A3C3B186
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 17:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B817920661
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Feb 2020 17:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgBLR4L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Feb 2020 12:56:11 -0500
Received: from inva021.nxp.com ([92.121.34.21]:45594 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727372AbgBLR4L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Feb 2020 12:56:11 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id DA60B2076A7;
        Wed, 12 Feb 2020 18:56:08 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CD627207661;
        Wed, 12 Feb 2020 18:56:08 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6AE9220567;
        Wed, 12 Feb 2020 18:56:08 +0100 (CET)
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
Subject: [PATCH v6 8/9] crypto: caam - add crypto_engine support for RSA algorithms
Date:   Wed, 12 Feb 2020 19:55:23 +0200
Message-Id: <1581530124-9135-9-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
References: <1581530124-9135-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_engine support for RSA algorithms, to make use of
the engine queue.
The requests, with backlog flag, will be listed into crypto-engine
queue and processed by CAAM when free. In case the queue is empty,
the request is directly sent to CAAM.
Only the backlog request are sent to crypto-engine since the others
can be handled by CAAM, if free, especially since JR has up to 1024
entries (more than the 10 entries from crypto-engine).

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 128 ++++++++++++++++++++++++++++++++++--------
 drivers/crypto/caam/caampkc.h |  10 ++++
 2 files changed, 114 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 7f7ea32..4fcae37 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -117,19 +117,28 @@ static void rsa_priv_f3_unmap(struct device *dev, struct rsa_edesc *edesc,
 static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 {
 	struct akcipher_request *req = context;
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	struct rsa_edesc *edesc;
 	int ecode = 0;
 
 	if (err)
 		ecode = caam_jr_strstatus(dev, err);
 
-	edesc = container_of(desc, struct rsa_edesc, hw_desc[0]);
+	edesc = req_ctx->edesc;
 
 	rsa_pub_unmap(dev, edesc, req);
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
 
-	akcipher_request_complete(req, ecode);
+	/*
+	 * If no backlog flag, the completion of the request is done
+	 * by CAAM, not crypto engine.
+	 */
+	if (!edesc->bklog)
+		akcipher_request_complete(req, ecode);
+	else
+		crypto_finalize_akcipher_request(jrp->engine, req, ecode);
 }
 
 static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
@@ -137,15 +146,17 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 {
 	struct akcipher_request *req = context;
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct rsa_edesc *edesc;
 	int ecode = 0;
 
 	if (err)
 		ecode = caam_jr_strstatus(dev, err);
 
-	edesc = container_of(desc, struct rsa_edesc, hw_desc[0]);
+	edesc = req_ctx->edesc;
 
 	switch (key->priv_form) {
 	case FORM1:
@@ -161,7 +172,14 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
 
-	akcipher_request_complete(req, ecode);
+	/*
+	 * If no backlog flag, the completion of the request is done
+	 * by CAAM, not crypto engine.
+	 */
+	if (!edesc->bklog)
+		akcipher_request_complete(req, ecode);
+	else
+		crypto_finalize_akcipher_request(jrp->engine, req, ecode);
 }
 
 /**
@@ -309,6 +327,8 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
 
+	req_ctx->edesc = edesc;
+
 	if (!sec4_sg_bytes)
 		return edesc;
 
@@ -339,6 +359,33 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	return ERR_PTR(-ENOMEM);
 }
 
+static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct akcipher_request *req = container_of(areq,
+						    struct akcipher_request,
+						    base);
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct device *jrdev = ctx->dev;
+	u32 *desc = req_ctx->edesc->hw_desc;
+	int ret;
+
+	req_ctx->edesc->bklog = true;
+
+	ret = caam_jr_enqueue(jrdev, desc, req_ctx->akcipher_op_done, req);
+
+	if (ret != -EINPROGRESS) {
+		rsa_pub_unmap(jrdev, req_ctx->edesc, req);
+		rsa_io_unmap(jrdev, req_ctx->edesc, req);
+		kfree(req_ctx->edesc);
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
 static int set_rsa_pub_pdb(struct akcipher_request *req,
 			   struct rsa_edesc *edesc)
 {
@@ -602,6 +649,53 @@ static int set_rsa_priv_f3_pdb(struct akcipher_request *req,
 	return -ENOMEM;
 }
 
+static int akcipher_enqueue_req(struct device *jrdev,
+				void (*cbk)(struct device *jrdev, u32 *desc,
+					    u32 err, void *context),
+				struct akcipher_request *req)
+{
+	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct caam_rsa_key *key = &ctx->key;
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	struct rsa_edesc *edesc = req_ctx->edesc;
+	u32 *desc = edesc->hw_desc;
+	int ret;
+
+	req_ctx->akcipher_op_done = cbk;
+	/*
+	 * Only the backlog request are sent to crypto-engine since the others
+	 * can be handled by CAAM, if free, especially since JR has up to 1024
+	 * entries (more than the 10 entries from crypto-engine).
+	 */
+	if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		ret = crypto_transfer_akcipher_request_to_engine(jrpriv->engine,
+								 req);
+	else
+		ret = caam_jr_enqueue(jrdev, desc, cbk, req);
+
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
+		switch (key->priv_form) {
+		case FORM1:
+			rsa_priv_f1_unmap(jrdev, edesc, req);
+			break;
+		case FORM2:
+			rsa_priv_f2_unmap(jrdev, edesc, req);
+			break;
+		case FORM3:
+			rsa_priv_f3_unmap(jrdev, edesc, req);
+			break;
+		default:
+			rsa_pub_unmap(jrdev, edesc, req);
+		}
+		rsa_io_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
+
+	return ret;
+}
+
 static int caam_rsa_enc(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
@@ -633,11 +727,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);
-	if (ret == -EINPROGRESS)
-		return ret;
-
-	rsa_pub_unmap(jrdev, edesc, req);
+	return akcipher_enqueue_req(jrdev, rsa_pub_done, req);
 
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
@@ -666,11 +756,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
-	if (ret == -EINPROGRESS)
-		return ret;
-
-	rsa_priv_f1_unmap(jrdev, edesc, req);
+	return akcipher_enqueue_req(jrdev, rsa_priv_f_done, req);
 
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
@@ -699,11 +785,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
-	if (ret == -EINPROGRESS)
-		return ret;
-
-	rsa_priv_f2_unmap(jrdev, edesc, req);
+	return akcipher_enqueue_req(jrdev, rsa_priv_f_done, req);
 
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
@@ -732,11 +814,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
-	if (ret == -EINPROGRESS)
-		return ret;
-
-	rsa_priv_f3_unmap(jrdev, edesc, req);
+	return akcipher_enqueue_req(jrdev, rsa_priv_f_done, req);
 
 init_fail:
 	rsa_io_unmap(jrdev, edesc, req);
@@ -1029,6 +1107,8 @@ static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return -ENOMEM;
 	}
 
+	ctx->enginectx.op.do_one_request = akcipher_do_one_req;
+
 	return 0;
 }
 
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index c68fb4c..cc889a5 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -12,6 +12,7 @@
 #define _PKC_DESC_H_
 #include "compat.h"
 #include "pdb.h"
+#include <crypto/engine.h>
 
 /**
  * caam_priv_key_form - CAAM RSA private key representation
@@ -87,11 +88,13 @@ struct caam_rsa_key {
 
 /**
  * caam_rsa_ctx - per session context.
+ * @enginectx   : crypto engine context
  * @key         : RSA key in DMA zone
  * @dev         : device structure
  * @padding_dma : dma address of padding, for adding it to the input
  */
 struct caam_rsa_ctx {
+	struct crypto_engine_ctx enginectx;
 	struct caam_rsa_key key;
 	struct device *dev;
 	dma_addr_t padding_dma;
@@ -103,11 +106,16 @@ struct caam_rsa_ctx {
  * @src           : input scatterlist (stripped of leading zeros)
  * @fixup_src     : input scatterlist (that might be stripped of leading zeros)
  * @fixup_src_len : length of the fixup_src input scatterlist
+ * @edesc         : s/w-extended rsa descriptor
+ * @akcipher_op_done : callback used when operation is done
  */
 struct caam_rsa_req_ctx {
 	struct scatterlist src[2];
 	struct scatterlist *fixup_src;
 	unsigned int fixup_src_len;
+	struct rsa_edesc *edesc;
+	void (*akcipher_op_done)(struct device *jrdev, u32 *desc, u32 err,
+				 void *context);
 };
 
 /**
@@ -117,6 +125,7 @@ struct caam_rsa_req_ctx {
  * @mapped_src_nents: number of segments in input h/w link table
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes : length of h/w link table
+ * @bklog         : stored to determine if the request needs backlog
  * @sec4_sg_dma   : dma address of h/w link table
  * @sec4_sg       : pointer to h/w link table
  * @pdb           : specific RSA Protocol Data Block (PDB)
@@ -128,6 +137,7 @@ struct rsa_edesc {
 	int mapped_src_nents;
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
+	bool bklog;
 	dma_addr_t sec4_sg_dma;
 	struct sec4_sg_entry *sec4_sg;
 	union {
-- 
2.1.0

