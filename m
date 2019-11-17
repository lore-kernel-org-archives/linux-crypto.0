Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF10C432C0
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC7220727
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 22:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKQWbK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 17:31:10 -0500
Received: from inva020.nxp.com ([92.121.34.13]:56970 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfKQWbJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 17:31:09 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8E5F51A0D13;
        Sun, 17 Nov 2019 23:31:05 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7FA7C1A0D12;
        Sun, 17 Nov 2019 23:31:05 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1F71520395;
        Sun, 17 Nov 2019 23:31:05 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx <linux-imx@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: [PATCH 07/12] crypto: caam - refactor caam_jr_enqueue
Date:   Mon, 18 Nov 2019 00:30:40 +0200
Message-Id: <1574029845-22796-8-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
References: <1574029845-22796-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added a new struct - caam_jr_request_entry, to keep each request
information. This has a crypto_async_request, used to determine
the request type, and a bool to check if the request has backlog
flag or not.
This struct is passed to CAAM, via enqueue function - caam_jr_enqueue.

The new added caam_jr_enqueue_no_bklog function is used to enqueue a job
descriptor head for cases like caamrng, key_gen, digest_key, where we
don't have backlogged requests.

This is done for later use, on backlogging support in CAAM.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c  | 29 +++++++++++++++++-----
 drivers/crypto/caam/caamhash.c | 56 ++++++++++++++++++++++++++++++++----------
 drivers/crypto/caam/caampkc.c  | 32 +++++++++++++++++++-----
 drivers/crypto/caam/caampkc.h  |  3 +++
 drivers/crypto/caam/caamrng.c  |  3 ++-
 drivers/crypto/caam/intern.h   | 10 ++++++++
 drivers/crypto/caam/jr.c       | 53 +++++++++++++++++++++++++++++++++------
 drivers/crypto/caam/jr.h       |  4 +++
 drivers/crypto/caam/key_gen.c  |  2 +-
 9 files changed, 158 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 21b6172..abebcfc 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -878,6 +878,7 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg_dma: bus physical mapped address of h/w link table
+ * @jrentry: information about the current request that is processed by a ring
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  */
@@ -888,6 +889,7 @@ struct aead_edesc {
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
+	struct caam_jr_request_entry jrentry;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[];
 };
@@ -901,6 +903,7 @@ struct aead_edesc {
  * @iv_dma: dma address of iv for checking continuity and link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg_dma: bus physical mapped address of h/w link table
+ * @jrentry: information about the current request that is processed by a ring
  * @sec4_sg: pointer to h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  *	     and IV
@@ -913,6 +916,7 @@ struct skcipher_edesc {
 	dma_addr_t iv_dma;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
+	struct caam_jr_request_entry jrentry;
 	struct sec4_sg_entry *sec4_sg;
 	u32 hw_desc[0];
 };
@@ -963,7 +967,8 @@ static void skcipher_unmap(struct device *dev, struct skcipher_edesc *edesc,
 static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 			    void *context)
 {
-	struct aead_request *req = context;
+	struct caam_jr_request_entry *jrentry = context;
+	struct aead_request *req = aead_request_cast(jrentry->base);
 	struct aead_edesc *edesc;
 	int ecode = 0;
 
@@ -984,7 +989,8 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 				void *context)
 {
-	struct skcipher_request *req = context;
+	struct caam_jr_request_entry *jrentry = context;
+	struct skcipher_request *req = skcipher_request_cast(jrentry->base);
 	struct skcipher_edesc *edesc;
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
@@ -1364,6 +1370,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	edesc->mapped_dst_nents = mapped_dst_nents;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
+	edesc->jrentry.base = &req->base;
+
 	*all_contig_ptr = !(mapped_src_nents > 1);
 
 	sec4_sg_index = 0;
@@ -1416,7 +1424,7 @@ static inline int chachapoly_crypt(struct aead_request *req, bool encrypt)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, &edesc->jrentry);
 	if (ret != -EINPROGRESS) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
@@ -1440,6 +1448,7 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct caam_jr_request_entry *jrentry;
 	struct device *jrdev = ctx->jrdev;
 	bool all_contig;
 	u32 *desc;
@@ -1459,7 +1468,9 @@ static inline int aead_crypt(struct aead_request *req, bool encrypt)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
+	jrentry = &edesc->jrentry;
+
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, jrentry);
 	if (ret != -EINPROGRESS) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
@@ -1484,6 +1495,7 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_jr_request_entry *jrentry;
 	bool all_contig;
 	u32 *desc;
 	int ret = 0;
@@ -1502,7 +1514,9 @@ static inline int gcm_crypt(struct aead_request *req, bool encrypt)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, req);
+	jrentry = &edesc->jrentry;
+
+	ret = caam_jr_enqueue(jrdev, desc, aead_crypt_done, jrentry);
 	if (ret != -EINPROGRESS) {
 		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
@@ -1637,6 +1651,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (struct sec4_sg_entry *)((u8 *)edesc->hw_desc +
 						  desc_bytes);
+	edesc->jrentry.base = &req->base;
 
 	/* Make sure IV is located in a DMAable area */
 	if (ivsize) {
@@ -1698,6 +1713,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
+	struct caam_jr_request_entry *jrentry;
 	u32 *desc;
 	int ret = 0;
 
@@ -1717,8 +1733,9 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 			     desc_bytes(edesc->hw_desc), 1);
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, skcipher_crypt_done, req);
+	jrentry = &edesc->jrentry;
 
+	ret = caam_jr_enqueue(jrdev, desc, skcipher_crypt_done, jrentry);
 	if (ret != -EINPROGRESS) {
 		skcipher_unmap(jrdev, edesc, req);
 		kfree(edesc);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index baf4ab1..d9de3dc 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -421,7 +421,7 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
 	result.err = 0;
 	init_completion(&result.completion);
 
-	ret = caam_jr_enqueue(jrdev, desc, split_key_done, &result);
+	ret = caam_jr_enqueue_no_bklog(jrdev, desc, split_key_done, &result);
 	if (ret == -EINPROGRESS) {
 		/* in progress */
 		wait_for_completion(&result.completion);
@@ -553,6 +553,7 @@ static int acmac_setkey(struct crypto_ahash *ahash, const u8 *key,
  * @sec4_sg_dma: physical mapped address of h/w link table
  * @src_nents: number of segments in input scatterlist
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
+ * @jrentry:  information about the current request that is processed by a ring
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  * @sec4_sg: h/w link table
  */
@@ -560,6 +561,7 @@ struct ahash_edesc {
 	dma_addr_t sec4_sg_dma;
 	int src_nents;
 	int sec4_sg_bytes;
+	struct caam_jr_request_entry jrentry;
 	u32 hw_desc[DESC_JOB_IO_LEN_MAX / sizeof(u32)] ____cacheline_aligned;
 	struct sec4_sg_entry sec4_sg[0];
 };
@@ -600,7 +602,8 @@ static inline void ahash_unmap_ctx(struct device *dev,
 static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 				  void *context, enum dma_data_direction dir)
 {
-	struct ahash_request *req = context;
+	struct caam_jr_request_entry *jrentry = context;
+	struct ahash_request *req = ahash_request_cast(jrentry->base);
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	int digestsize = crypto_ahash_digestsize(ahash);
@@ -640,7 +643,8 @@ static void ahash_done_ctx_src(struct device *jrdev, u32 *desc, u32 err,
 static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 				     void *context, enum dma_data_direction dir)
 {
-	struct ahash_request *req = context;
+	struct caam_jr_request_entry *jrentry = context;
+	struct ahash_request *req = ahash_request_cast(jrentry->base);
 	struct ahash_edesc *edesc;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
@@ -702,6 +706,8 @@ static struct ahash_edesc *ahash_edesc_alloc(struct ahash_request *req,
 		return NULL;
 	}
 
+	edesc->jrentry.base = &req->base;
+
 	init_job_desc_shared(edesc->hw_desc, sh_desc_dma, desc_len(sh_desc),
 			     HDR_SHARE_DEFER | HDR_REVERSE);
 
@@ -760,6 +766,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 	u32 *desc;
 	int src_nents, mapped_nents, sec4_sg_bytes, sec4_sg_src_index;
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret = 0;
 
 	last_buflen = *next_buflen;
@@ -857,7 +864,9 @@ static int ahash_update_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
+		jrentry = &edesc->jrentry;
+
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, jrentry);
 		if (ret != -EINPROGRESS)
 			goto unmap_ctx;
 	} else if (*next_buflen) {
@@ -891,6 +900,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	int sec4_sg_bytes;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	sec4_sg_bytes = pad_sg_nents(1 + (buflen ? 1 : 0)) *
@@ -933,11 +943,13 @@ static int ahash_final_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	jrentry = &edesc->jrentry;
+
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
- unmap_ctx:
+unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);
 	kfree(edesc);
 	return ret;
@@ -955,6 +967,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
@@ -1009,11 +1022,13 @@ static int ahash_finup_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
+	jrentry = &edesc->jrentry;
+
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
- unmap_ctx:
+unmap_ctx:
 	ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_BIDIRECTIONAL);
 	kfree(edesc);
 	return ret;
@@ -1029,6 +1044,7 @@ static int ahash_digest(struct ahash_request *req)
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	state->buf_dma = 0;
@@ -1081,7 +1097,9 @@ static int ahash_digest(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	jrentry = &edesc->jrentry;
+
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, jrentry);
 	if (ret != -EINPROGRESS) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
@@ -1102,6 +1120,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
@@ -1131,7 +1150,9 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	jrentry = &edesc->jrentry;
+
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, jrentry);
 	if (ret != -EINPROGRESS) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
@@ -1160,6 +1181,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	int in_len = *buflen + req->nbytes, to_hash;
 	int sec4_sg_bytes, src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	u32 *desc;
 	int ret = 0;
 
@@ -1249,7 +1271,9 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		jrentry = &edesc->jrentry;
+
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, jrentry);
 		if (ret != -EINPROGRESS)
 			goto unmap_ctx;
 
@@ -1288,6 +1312,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
@@ -1343,7 +1368,9 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
 			     1);
 
-	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
+	jrentry = &edesc->jrentry;
+
+	ret = caam_jr_enqueue(jrdev, desc, ahash_done, jrentry);
 	if (ret != -EINPROGRESS) {
 		ahash_unmap_ctx(jrdev, edesc, req, digestsize, DMA_FROM_DEVICE);
 		kfree(edesc);
@@ -1371,6 +1398,7 @@ static int ahash_update_first(struct ahash_request *req)
 	u32 *desc;
 	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret = 0;
 
 	*next_buflen = req->nbytes & (blocksize - 1);
@@ -1440,7 +1468,9 @@ static int ahash_update_first(struct ahash_request *req)
 				     DUMP_PREFIX_ADDRESS, 16, 4, desc,
 				     desc_bytes(desc), 1);
 
-		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
+		jrentry = &edesc->jrentry;
+
+		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, jrentry);
 		if (ret != -EINPROGRESS)
 			goto unmap_ctx;
 
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 7f7ea32..bb0e4b9 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -116,7 +116,8 @@ static void rsa_priv_f3_unmap(struct device *dev, struct rsa_edesc *edesc,
 /* RSA Job Completion handler */
 static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 {
-	struct akcipher_request *req = context;
+	struct caam_jr_request_entry *jrentry = context;
+	struct akcipher_request *req = akcipher_request_cast(jrentry->base);
 	struct rsa_edesc *edesc;
 	int ecode = 0;
 
@@ -135,7 +136,8 @@ static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void *context)
 static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
 			    void *context)
 {
-	struct akcipher_request *req = context;
+	struct caam_jr_request_entry *jrentry = context;
+	struct akcipher_request *req = akcipher_request_cast(jrentry->base);
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
@@ -315,6 +317,8 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	edesc->mapped_src_nents = mapped_src_nents;
 	edesc->mapped_dst_nents = mapped_dst_nents;
 
+	edesc->jrentry.base = &req->base;
+
 	edesc->sec4_sg_dma = dma_map_single(dev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, edesc->sec4_sg_dma)) {
@@ -609,6 +613,7 @@ static int caam_rsa_enc(struct akcipher_request *req)
 	struct caam_rsa_key *key = &ctx->key;
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	if (unlikely(!key->n || !key->e))
@@ -633,7 +638,10 @@ static int caam_rsa_enc(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, req);
+	jrentry = &edesc->jrentry;
+	jrentry->base = &req->base;
+
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_pub_done, jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -651,6 +659,7 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	/* Allocate extended descriptor */
@@ -666,7 +675,10 @@ static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
+	jrentry = &edesc->jrentry;
+	jrentry->base = &req->base;
+
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -684,6 +696,7 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	/* Allocate extended descriptor */
@@ -699,7 +712,10 @@ static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
+	jrentry = &edesc->jrentry;
+	jrentry->base = &req->base;
+
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -717,6 +733,7 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *jrdev = ctx->dev;
 	struct rsa_edesc *edesc;
+	struct caam_jr_request_entry *jrentry;
 	int ret;
 
 	/* Allocate extended descriptor */
@@ -732,7 +749,10 @@ static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
 	/* Initialize Job Descriptor */
 	init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);
 
-	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, req);
+	jrentry = &edesc->jrentry;
+	jrentry->base = &req->base;
+
+	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f_done, jrentry);
 	if (ret == -EINPROGRESS)
 		return ret;
 
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index c68fb4c..fe46d73 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -11,6 +11,7 @@
 #ifndef _PKC_DESC_H_
 #define _PKC_DESC_H_
 #include "compat.h"
+#include "intern.h"
 #include "pdb.h"
 
 /**
@@ -118,6 +119,7 @@ struct caam_rsa_req_ctx {
  * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes : length of h/w link table
  * @sec4_sg_dma   : dma address of h/w link table
+ * @jrentry       : info about the current request that is processed by a ring
  * @sec4_sg       : pointer to h/w link table
  * @pdb           : specific RSA Protocol Data Block (PDB)
  * @hw_desc       : descriptor followed by link tables if any
@@ -129,6 +131,7 @@ struct rsa_edesc {
 	int mapped_dst_nents;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
+	struct caam_jr_request_entry jrentry;
 	struct sec4_sg_entry *sec4_sg;
 	union {
 		struct rsa_pub_pdb pub;
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e3e4bf2..96891b6 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -132,7 +132,8 @@ static inline int submit_job(struct caam_rng_ctx *ctx, int to_current)
 
 	dev_dbg(jrdev, "submitting job %d\n", !(to_current ^ ctx->current_buf));
 	init_completion(&bd->filled);
-	err = caam_jr_enqueue(jrdev, desc, rng_done, ctx);
+
+	err = caam_jr_enqueue_no_bklog(jrdev, desc, rng_done, ctx);
 	if (err != EINPROGRESS)
 		complete(&bd->filled); /* don't wait on failed job*/
 	else
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index c7c10c9..58be66c 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -11,6 +11,7 @@
 #define INTERN_H
 
 #include "ctrl.h"
+#include "regs.h"
 
 /* Currently comes from Kconfig param as a ^2 (driver-required) */
 #define JOBR_DEPTH (1 << CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE)
@@ -104,6 +105,15 @@ struct caam_drv_private {
 #endif
 };
 
+/*
+ * Storage for tracking each request that is processed by a ring
+ */
+struct caam_jr_request_entry {
+	/* Common attributes for async crypto requests */
+	struct crypto_async_request *base;
+	bool bklog;	/* Stored to determine if the request needs backlog */
+};
+
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API
 
 int caam_algapi_init(struct device *dev);
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index df2a050..544cafa 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -324,9 +324,9 @@ void caam_jr_free(struct device *rdev)
 EXPORT_SYMBOL(caam_jr_free);
 
 /**
- * caam_jr_enqueue() - Enqueue a job descriptor head. Returns -EINPROGRESS
- * if OK, -ENOSPC if the queue is full, -EIO if it cannot map the caller's
- * descriptor.
+ * caam_jr_enqueue_no_bklog() - Enqueue a job descriptor head for no
+ * backlogging requests. Returns -EINPROGRESS if OK, -ENOSPC if the queue
+ * is full, -EIO if it cannot map the caller's descriptor.
  * @dev:  device of the job ring to be used. This device should have
  *        been assigned prior by caam_jr_register().
  * @desc: points to a job descriptor that execute our request. All
@@ -351,10 +351,10 @@ EXPORT_SYMBOL(caam_jr_free);
  * @areq: optional pointer to a user argument for use at callback
  *        time.
  **/
-int caam_jr_enqueue(struct device *dev, u32 *desc,
-		    void (*cbk)(struct device *dev, u32 *desc,
-				u32 status, void *areq),
-		    void *areq)
+int caam_jr_enqueue_no_bklog(struct device *dev, u32 *desc,
+			     void (*cbk)(struct device *dev, u32 *desc,
+					 u32 status, void *areq),
+			     void *areq)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
 	struct caam_jrentry_info *head_entry;
@@ -416,6 +416,45 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
 
 	return -EINPROGRESS;
 }
+EXPORT_SYMBOL(caam_jr_enqueue_no_bklog);
+
+/**
+ * caam_jr_enqueue() - Enqueue a job descriptor head. Returns -EINPROGRESS
+ * if OK, -ENOSPC if the queue is full, -EIO if it cannot map the caller's
+ * descriptor.
+ * @dev:  device of the job ring to be used. This device should have
+ *        been assigned prior by caam_jr_register().
+ * @desc: points to a job descriptor that execute our request. All
+ *        descriptors (and all referenced data) must be in a DMAable
+ *        region, and all data references must be physical addresses
+ *        accessible to CAAM (i.e. within a PAMU window granted
+ *        to it).
+ * @cbk:  pointer to a callback function to be invoked upon completion
+ *        of this request. This has the form:
+ *        callback(struct device *dev, u32 *desc, u32 stat, void *arg)
+ *        where:
+ *        @dev:    contains the job ring device that processed this
+ *                 response.
+ *        @desc:   descriptor that initiated the request, same as
+ *                 "desc" being argued to caam_jr_enqueue().
+ *        @status: untranslated status received from CAAM. See the
+ *                 reference manual for a detailed description of
+ *                 error meaning, or see the JRSTA definitions in the
+ *                 register header file
+ *        @areq:   optional pointer to an argument passed with the
+ *                 original request
+ * @areq: optional pointer to a user argument for use at callback
+ *        time.
+ **/
+int caam_jr_enqueue(struct device *dev, u32 *desc,
+		    void (*cbk)(struct device *dev, u32 *desc,
+				u32 status, void *areq),
+		    void *areq)
+{
+	struct caam_jr_request_entry *jrentry = areq;
+
+	return caam_jr_enqueue_no_bklog(dev, desc, cbk, jrentry);
+}
 EXPORT_SYMBOL(caam_jr_enqueue);
 
 /*
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index eab6115..c47a0cd 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -11,6 +11,10 @@
 /* Prototypes for backend-level services exposed to APIs */
 struct device *caam_jr_alloc(void);
 void caam_jr_free(struct device *rdev);
+int caam_jr_enqueue_no_bklog(struct device *dev, u32 *desc,
+			     void (*cbk)(struct device *dev, u32 *desc,
+					 u32 status, void *areq),
+			     void *areq);
 int caam_jr_enqueue(struct device *dev, u32 *desc,
 		    void (*cbk)(struct device *dev, u32 *desc, u32 status,
 				void *areq),
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index b0e8a49..854e718 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -107,7 +107,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out,
 	result.err = 0;
 	init_completion(&result.completion);
 
-	ret = caam_jr_enqueue(jrdev, desc, split_key_done, &result);
+	ret = caam_jr_enqueue_no_bklog(jrdev, desc, split_key_done, &result);
 	if (ret == -EINPROGRESS) {
 		/* in progress */
 		wait_for_completion(&result.completion);
-- 
2.1.0

