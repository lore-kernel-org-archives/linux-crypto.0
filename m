Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381BDC43215
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1205520727
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKQWb2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 17:31:28 -0500
Received: from inva020.nxp.com ([92.121.34.13]:57022 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbfKQWbJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 17:31:09 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D98521A0D11;
        Sun, 17 Nov 2019 23:31:06 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D689C1A0D0C;
        Sun, 17 Nov 2019 23:31:06 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 78C2C202AF;
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
Subject: [PATCH 10/12] crypto: caam - add crypto_engine support for AEAD algorithms
Date:   Mon, 18 Nov 2019 00:30:43 +0200
Message-Id: <1574029845-22796-11-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto_engine support for AEAD algorithms, to make use of
the engine queue.
The requests, with backlog flag, will be listed into crypto-engine
queue and processed by CAAM when free. In case the queue is empty,
the request is directly sent to CAAM.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 80 +++++++++++++++++++++++++++++++++----------
 drivers/crypto/caam/jr.c      |  3 ++
 2 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 23de94d..786713a 100644
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
@@ -977,12 +983,14 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct caam_jr_request_entry *jrentry = context;
 	struct aead_request *req = aead_request_cast(jrentry->base);
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct aead_edesc *edesc;
 	int ecode = 0;
 
 	dev_dbg(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 
-	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
+	edesc = rctx->edesc;
 
 	if (err)
 		ecode = caam_jr_strstatus(jrdev, err);
@@ -991,7 +999,14 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 
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
@@ -1287,6 +1302,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
@@ -1389,6 +1405,9 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			 desc_bytes;
 	edesc->jrentry.base = &req->base;
 
+	rctx->edesc = edesc;
+	rctx->aead_op_done = aead_crypt_done;
+
 	*all_contig_ptr = !(mapped_src_nents > 1);
 
 	sec4_sg_index = 0;
@@ -1442,7 +1461,7 @@ static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 			     1);
 
 	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
-	if (ret != -EINPROGRESS) {
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
@@ -1465,7 +1484,6 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct caam_jr_request_entry *jrentry;
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
 	u32 *desc;
@@ -1479,16 +1497,14 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 
 	/* Create and submit job descriptor */
 	init_authenc_job(req, edesc, all_contig, encrypt);
+	desc = edesc->hw_desc;
 
 	print_hex_dump_debug("aead jobdesc@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-			     desc_bytes(edesc->hw_desc), 1);
-
-	desc = edesc->hw_desc;
-	jrentry = &edesc->jrentry;
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
+			     desc_bytes(desc), 1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, jrentry);
-	if (ret != -EINPROGRESS) {
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
@@ -1506,13 +1522,37 @@ static int aead_decrypt(struct aead_request *req)
 	return aead_crypt(req, false);
 }
 
+static int aead_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = aead_request_cast(areq);
+	struct caam_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_jr_request_entry *jrentry;
+	u32 *desc = rctx->edesc->hw_desc;
+	int ret;
+
+	jrentry = &rctx->edesc->jrentry;
+	jrentry->bklog = true;
+
+	ret = caam_jr_enqueue_no_bklog(ctx->jrdev, desc, rctx->aead_op_done,
+				       jrentry);
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
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	struct caam_jr_request_entry *jrentry;
 	bool all_contig;
 	u32 *desc;
 	int ret = 0;
@@ -1525,16 +1565,14 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 
 	/* Create and submit job descriptor */
 	init_gcm_job(req, edesc, all_contig, encrypt);
+	desc = edesc->hw_desc;
 
 	print_hex_dump_debug("aead jobdesc@"__stringify(__LINE__)": ",
-			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-			     desc_bytes(edesc->hw_desc), 1);
-
-	desc = edesc->hw_desc;
-	jrentry = &edesc->jrentry;
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc,
+			     desc_bytes(desc), 1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, jrentry);
-	if (ret != -EINPROGRESS) {
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
+	if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
@@ -3364,6 +3402,10 @@ static int caam_aead_init(struct crypto_aead *tfm)
 		 container_of(alg, struct caam_aead_alg, aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
 
+	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
+
+	ctx->enginectx.op.do_one_request = aead_do_one_req;
+
 	return caam_init_common(ctx, &caam_alg->caam, !caam_alg->caam.nodkp);
 }
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index ddf3d39..7e6632d 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -434,6 +434,9 @@ static int transfer_request_to_engine(struct crypto_engine *engine,
 	case CRYPTO_ALG_TYPE_SKCIPHER:
 		return crypto_transfer_skcipher_request_to_engine(engine,
 								  skcipher_request_cast(req));
+	case CRYPTO_ALG_TYPE_AEAD:
+		return crypto_transfer_aead_request_to_engine(engine,
+							      aead_request_cast(req));
 	default:
 		return -EINVAL;
 	}
-- 
2.1.0

