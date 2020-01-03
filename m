Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216D2C3276C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4BD6217F4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 01:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgACBDQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 20:03:16 -0500
Received: from inva020.nxp.com ([92.121.34.13]:47384 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgACBDQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 20:03:16 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C13261A1B14;
        Fri,  3 Jan 2020 02:03:14 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B2F251A1B07;
        Fri,  3 Jan 2020 02:03:14 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5EAFD20567;
        Fri,  3 Jan 2020 02:03:14 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH v2 06/10] crypto: caam - refactor caam_jr_enqueue
Date:   Fri,  3 Jan 2020 03:02:49 +0200
Message-Id: <1578013373-1956-7-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
References: <1578013373-1956-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added a new struct - caam_{skcipher, akcipher, ahash, aead}_request_entry,
to keep each request information. This has a specific crypto request and
a bool to check if the request has backlog flag or not.
This struct is passed to CAAM, via enqueue function - caam_jr_enqueue.

This is done for later use, on backlogging support in CAAM.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c  | 44 ++++++++++++++++++++++++++++++++++++------
 drivers/crypto/caam/caamhash.c | 40 ++++++++++++++++++++++++++++----------
 drivers/crypto/caam/caampkc.c  | 20 +++++++++++++------
 drivers/crypto/caam/caampkc.h  | 14 ++++++++++++++
 drivers/crypto/caam/intern.h   |  1 +
 5 files changed, 97 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 21b6172..34662b4 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -871,6 +871,17 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 }
 
 /*
+ * caam_aead_request_entry - storage for tracking each aead request
+ *                           that is processed by a ring
+ * @base: common attributes for aead requests
+ * @bklog: stored to determine if the request needs backlog
+ */
+struct caam_aead_request_entry {
+	struct aead_request *base;
+	bool bklog;
+};
+
+/*
  * aead_edesc - s/w-extended aead descriptor
  * @src_nents: number of segments in input s/w scatterlist
  * @dst_nents: number of segments in output s/w scatterlist
@@ -878,6 +889,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg_dma: bus physical mapped address of h/w link table
+ * @jrentry: information about the current request that is processed by a ring
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  */
@@ -888,11 +900,23 @@ struct aead_edesc {
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
+	struct caam_aead_request_entry jrentry;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[];
 };
 
 /*
+ * caam_skcipher_request_entry - storage for tracking each skcipher request
+ *                               that is processed by a ring
+ * @base: common attributes for skcipher requests
+ * @bklog: stored to determine if the request needs backlog
+ */
+struct caam_skcipher_request_entry {
+	struct skcipher_request *base;
+	bool bklog;
+};
+
+/*
  * skcipher_edesc - s/w-extended skcipher descriptor
  * @src_nents: number of segments in input s/w scatterlist
  * @dst_nents: number of segments in output s/w scatterlist
@@ -901,6 +925,7 @@ struct aead_edesc {
  * @iv_dma: dma address of iv for checking continuity and link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg_dma: bus physical mapped address of h/w link table
+ * @jrentry: information about the current request that is processed by a ring
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  *	     and IV
@@ -913,6 +938,7 @@ struct skcipher_edesc {
 	dma_addr_t iv_dma;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
+	struct caam_skcipher_request_entry jrentry;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[0];
 };
@@ -963,7 +989,8 @@ static void skcipher_unmap(struct device *dev, struct skcipher_edesc *edesc,
 static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 			    void *context)
 {
-	struct aead_request *req = context;
+	struct caam_aead_request_entry *jrentry = context;
+	struct aead_request *req = jrentry->base;
 	struct aead_edesc *edesc;
 	int ecode = 0;
 
@@ -984,7 +1011,8 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 				void *context)
 {
-	struct skcipher_request *req = context;
+	struct caam_skcipher_request_entry *jrentry = context;
+	struct skcipher_request *req = jrentry->base;
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
@@ -1364,6 +1392,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	edesc->mapped_dst_nents = mapped_dst_nents;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
+	edesc->jrentry.base = req;
+
 	*all_contig_ptr = !(mapped_src_nents > 1);
 
 	sec4_sg_index = 0;
@@ -1416,7 +1446,7 @@ static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
@@ -1459,7 +1489,7 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
@@ -1502,7 +1532,7 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
@@ -1637,6 +1667,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (struct sec4_sg_entry *)((u8 *)edesc->hw_desc +
 						  desc_bytes);
+	edesc->jrentry.base = req;
 
 	/* Make sure IV is located in a DMAable area */
 	if (ivsize) {
@@ -1717,8 +1748,9 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, skcipher_crypt_done, req);
 
+	ret = caam_jr_enqueue(jrdev, desc, skcipher_crypt_done,
+			      &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		skcipher_unmap(jrdev, edesc, req);
 		kfree(edesc);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index b019d7e..f179d39 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -522,10 +522,22 @@ static int acmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 }
 
 /*
+ * caam_ahash_request_entry - storage for tracking each ahash request that
+ *                            is processed by a ring
+ * @base: common attributes for ahash requests
+ * @bklog: stored to determine if the request needs backlog
+ */
+struct caam_ahash_request_entry {
+	struct ahash_request *base;
+	bool bklog;
+};
+
+/*
  * ahash_edesc - s/w-extended ahash descriptor
  * @sec4_sg_dma: physical mapped address of h/w link table
  * @src_nents: number of segments in input scatterlist
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
+ * @jrentry:  information about the current request that is processed by a ring
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  * @sec4_sg: h/w link table
  */
@@ -533,6 +545,7 @@ struct ahash_edesc {
 	dma_addr_t sec4_sg_dma;
 	int src_nents;
 	int sec4_sg_bytes;
+	struct caam_ahash_request_entry jrentry;
 	u32 hw_desc[DESC_JOB_IO_LEN_MAX / sizeof(u32)] ____cacheline_aligned;
 	struct sec4_sg_entry sec4_sg[0];
 };
@@ -573,7 +586,8 @@ static inline void ahash_unmap_ctx(struct device *dev,
 static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 				  void *context, enum dma_data_direction dir)
 {
-	struct ahash_request *req = context;
+	struct caam_ahash_request_entry *jrentry = context;
+	struct ahash_request *req = jrentry->base;
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
@@ -613,7 +627,8 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 				     void *context, enum dma_data_direction dir)
 {
-	struct ahash_request *req = context;
+	struct caam_ahash_request_entry *jrentry = context;
+	struct ahash_request *req = jrentry->base;
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
@@ -683,6 +698,8 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 		return NULL;
 	}
 
+	edesc->jrentry.base = req;
+
 	init_job_desc_shared(edesc->hw_desc, sh_desc_dma, desc_len(sh_desc),
 			     HDR_SHARE_DEFER | HDR_REVERSE);
 
@@ -832,7 +849,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi,
+				      &edesc->jrentry);
 		if (ret != -EINPROGRESS)
 			goto unmap_ctx;
 	} else if (*next_buflen) {
@@ -905,7 +923,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, &edesc->jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -981,7 +999,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, &edesc->jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -1053,7 +1071,7 @@ static int ahash_digest(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
@@ -1103,7 +1121,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
@@ -1214,7 +1232,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
+				      &edesc->jrentry);
 		if (ret != -EINPROGRESS)
 			goto unmap_ctx;
 
@@ -1305,7 +1324,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
@@ -1399,7 +1418,8 @@ static int ahash_update_first(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
+				      &edesc->jrentry);
 		if (ret != -EINPROGRESS)
 			goto unmap_ctx;
 
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 7f7ea32..858cc95 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -116,7 +116,8 @@ static void rsa_priv_f3_unmap(struct device *dev, struct rsa_edesc *edesc,
 /* RSA Job Completion handler */
 static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 {
-	struct akcipher_request *req = context;
+	struct caam_akcipher_request_entry *jrentry = context;
+	struct akcipher_request *req = jrentry->base;
 	struct rsa_edesc *edesc;
 	int ecode = 0;
 
@@ -135,7 +136,8 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 			    void *context)
 {
-	struct akcipher_request *req = context;
+	struct caam_akcipher_request_entry *jrentry = context;
+	struct akcipher_request *req = jrentry->base;
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
@@ -309,6 +311,8 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
 
+	edesc->jrentry.base = req;
+
 	if (!sec4_sg_bytes)
 		return edesc;
 
@@ -633,7 +637,8 @@ static int caam_rsa_enc(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done,
+			      &edesc->jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -666,7 +671,8 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done,
+			      &edesc->jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -699,7 +705,8 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done,
+			      &edesc->jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -732,7 +739,8 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done,
+			      &edesc->jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index c68fb4c..e0b1076 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -11,6 +11,7 @@
 #ifndef _PKC_DESC_H_
 #define _PKC_DESC_H_
 #include "compat.h"
+#include "intern.h"
 #include "pdb.h"
 
 /**
@@ -110,6 +111,17 @@ struct caam_rsa_req_ctx {
 	unsigned int fixup_src_len;
 };
 
+/*
+ * caam_akcipher_request_entry - Storage for tracking each akcipher request
+ *                               that is processed by a ring
+ * @base: common attributes for akcipher requests
+ * @bklog: stored to determine if the request needs backlog
+ */
+struct caam_akcipher_request_entry {
+	struct akcipher_request *base;
+	bool bklog;
+};
+
 /**
  * rsa_edesc - s/w-extended rsa descriptor
  * @src_nents     : number of segments in input s/w scatterlist
@@ -118,6 +130,7 @@ struct caam_rsa_req_ctx {
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes : length of h/w link table
  * @sec4_sg_dma   : dma address of h/w link table
+ * @jrentry       : info about the current request that is processed by a ring
  * @sec4_sg       : pointer to h/w link table
  * @pdb           : specific RSA Protocol Data Block (PDB)
  * @hw_desc       : descriptor followed by link tables if any
@@ -129,6 +142,7 @@ struct rsa_edesc {
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
+	struct caam_akcipher_request_entry jrentry;
 	struct sec4_sg_entry *sec4_sg;
 	union {
 		struct rsa_pub_pdb pub;
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c7c10c9..8ca884b 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -11,6 +11,7 @@
 #define INTERN_H
 
 #include "ctrl.h"
+#include "regs.h"
 
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
-- 
2.1.0

