Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB44C43215
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD61A20740
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfKQWbK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 17:31:10 -0500
Received: from inva021.nxp.com ([92.121.34.21]:44710 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfKQWbK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 17:31:10 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 69C65200182;
        Sun, 17 Nov 2019 23:31:07 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4FD372000AA;
        Sun, 17 Nov 2019 23:31:07 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E466E202AF;
        Sun, 17 Nov 2019 23:31:06 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 11/12] crypto: caam - add crypto_engine support for RSA algorithms
Date:   Mon, 18 Nov 2019 00:30:44 +0200
Message-Id: <1574029845-22796-12-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
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

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 124 ++++++++++++++++++++++++++++++------------
 drivers/crypto/caam/caampkc.h |   8 +++
 drivers/crypto/caam/jr.c      |   3 +
 3 files changed, 101 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index bb0e4b9..8ffce06 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -118,19 +118,28 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 {
 	struct caam_jr_request_entry *jrentry = context;
 	struct akcipher_request *req = akcipher_request_cast(jrentry->base);
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
+	if (!jrentry->bklog)
+		akcipher_request_complete(req, ecode);
+	else
+		crypto_finalize_akcipher_request(jrp->engine, req, ecode);
 }
 
 static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
@@ -139,15 +148,17 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 	struct caam_jr_request_entry *jrentry = context;
 	struct akcipher_request *req = akcipher_request_cast(jrentry->base);
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
@@ -163,7 +174,14 @@ static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 	rsa_io_unmap(dev, edesc, req);
 	kfree(edesc);
 
-	akcipher_request_complete(req, ecode);
+	/*
+	 * If no backlog flag, the completion of the request is done
+	 * by CAAM, not crypto engine.
+	 */
+	if (!jrentry->bklog)
+		akcipher_request_complete(req, ecode);
+	else
+		crypto_finalize_akcipher_request(jrp->engine, req, ecode);
 }
 
 /**
@@ -311,14 +329,16 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
 
+	edesc->jrentry.base = &req->base;
+
+	req_ctx->edesc = edesc;
+
 	if (!sec4_sg_bytes)
 		return edesc;
 
 	edesc->mapped_src_nents = mapped_src_nents;
 	edesc->mapped_dst_nents = mapped_dst_nents;
 
-	edesc->jrentry.base = &req->base;
-
 	edesc->sec4_sg_dma = dma_map_single(dev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, edesc->sec4_sg_dma)) {
@@ -343,6 +363,34 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	return ERR_PTR(-ENOMEM);
 }
 
+static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	int ret;
+	struct akcipher_request *req = akcipher_request_cast(areq);
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct caam_jr_request_entry *jrentry;
+	struct device *jrdev = ctx->dev;
+	u32 *desc = req_ctx->edesc->hw_desc;
+
+	jrentry = &req_ctx->edesc->jrentry;
+	jrentry->bklog = true;
+
+	ret = caam_jr_enqueue_no_bklog(jrdev, desc, req_ctx->akcipher_op_done,
+				       jrentry);
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
@@ -610,10 +658,11 @@ static int caam_rsa_enc(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct caam_rsa_key *key = &ctx->key;
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
+	u32 *desc;
 	int ret;
 
 	if (unlikely(!key->n || !key->e))
@@ -635,14 +684,14 @@ static int caam_rsa_enc(struct akcipher_request *req)
 	if (ret)
 		goto init_fail;
 
-	/* Initialize Job Descriptor */
-	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);
+	desc = edesc->hw_desc;
 
-	jrentry = &edesc->jrentry;
-	jrentry->base = &req->base;
+	/* Initialize Job Descriptor */
+	init_rsa_pub_desc(desc, &edesc->pdb.pub);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, jrentry);
-	if (ret == -EINPROGRESS)
+	req_ctx->akcipher_op_done = rsa_pub_done;
+	ret = caam_jr_enqueue(jrdev, desc, rsa_pub_done, &edesc->jrentry);
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return ret;
 
 	rsa_pub_unmap(jrdev, edesc, req);
@@ -657,9 +706,10 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
+	u32 *desc;
 	int ret;
 
 	/* Allocate extended descriptor */
@@ -672,14 +722,14 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 	if (ret)
 		goto init_fail;
 
-	/* Initialize Job Descriptor */
-	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);
+	desc = edesc->hw_desc;
 
-	jrentry = &edesc->jrentry;
-	jrentry->base = &req->base;
+	/* Initialize Job Descriptor */
+	init_rsa_priv_f1_desc(desc, &edesc->pdb.priv_f1);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, jrentry);
-	if (ret == -EINPROGRESS)
+	req_ctx->akcipher_op_done = rsa_priv_f_done;
+	ret = caam_jr_enqueue(jrdev, desc, rsa_priv_f_done, &edesc->jrentry);
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return ret;
 
 	rsa_priv_f1_unmap(jrdev, edesc, req);
@@ -694,9 +744,10 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
+	u32 *desc;
 	int ret;
 
 	/* Allocate extended descriptor */
@@ -709,14 +760,14 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 	if (ret)
 		goto init_fail;
 
-	/* Initialize Job Descriptor */
-	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);
+	desc = edesc->hw_desc;
 
-	jrentry = &edesc->jrentry;
-	jrentry->base = &req->base;
+	/* Initialize Job Descriptor */
+	init_rsa_priv_f2_desc(desc, &edesc->pdb.priv_f2);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, jrentry);
-	if (ret == -EINPROGRESS)
+	req_ctx->akcipher_op_done = rsa_priv_f_done;
+	ret = caam_jr_enqueue(jrdev, desc, rsa_priv_f_done, &edesc->jrentry);
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return ret;
 
 	rsa_priv_f2_unmap(jrdev, edesc, req);
@@ -731,9 +782,10 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
-	struct caam_jr_request_entry *jrentry;
+	u32 *desc;
 	int ret;
 
 	/* Allocate extended descriptor */
@@ -746,14 +798,14 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 	if (ret)
 		goto init_fail;
 
-	/* Initialize Job Descriptor */
-	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);
+	desc = edesc->hw_desc;
 
-	jrentry = &edesc->jrentry;
-	jrentry->base = &req->base;
+	/* Initialize Job Descriptor */
+	init_rsa_priv_f3_desc(desc, &edesc->pdb.priv_f3);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, jrentry);
-	if (ret == -EINPROGRESS)
+	req_ctx->akcipher_op_done = rsa_priv_f_done;
+	ret = caam_jr_enqueue(jrdev, desc, rsa_priv_f_done, &edesc->jrentry);
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return ret;
 
 	rsa_priv_f3_unmap(jrdev, edesc, req);
@@ -1049,6 +1101,10 @@ static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return -ENOMEM;
 	}
 
+	ctx->enginectx.op.do_one_request = akcipher_do_one_req;
+
+	akcipher_set_reqsize(tfm, sizeof(struct caam_rsa_req_ctx));
+
 	return 0;
 }
 
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index fe46d73..d31b040 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -13,6 +13,7 @@
 #include "compat.h"
 #include "intern.h"
 #include "pdb.h"
+#include <crypto/engine.h>
 
 /**
  * caam_priv_key_form - CAAM RSA private key representation
@@ -88,11 +89,13 @@ struct caam_rsa_key {
 
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
@@ -104,11 +107,16 @@ struct caam_rsa_ctx {
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
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 7e6632d..579b1ba 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -437,6 +437,9 @@ static int transfer_request_to_engine(struct crypto_engine *engine,
 	case CRYPTO_ALG_TYPE_AEAD:
 		return crypto_transfer_aead_request_to_engine(engine,
 							      aead_request_cast(req));
+	case CRYPTO_ALG_TYPE_AKCIPHER:
+		return crypto_transfer_akcipher_request_to_engine(engine,
+								  akcipher_request_cast(req));
 	default:
 		return -EINVAL;
 	}
-- 
2.1.0

