From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v3 07/10] crypto/chcr: Adjust Dest. buffer size
Date: Tue, 29 Nov 2016 19:00:40 +0530
Message-ID: <6369a9370fba1001ebd74dacac2910c655484359.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        hariprasad@chelsio.com, jlulla@chelsio.com, atul.gupta@chelsio.com,
        yeshaswi@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:51543 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933265AbcK2NbT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:31:19 -0500
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Destination buffer size passed to hardware should not be greater
than crypto operation output.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 50 +++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 3cf0093..64cab64 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -335,25 +335,13 @@ static inline int is_hmac(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static inline unsigned int ch_nents(struct scatterlist *sg,
-				    unsigned int *total_size)
-{
-	unsigned int nents;
-
-	for (nents = 0, *total_size = 0; sg; sg = sg_next(sg)) {
-		nents++;
-		*total_size += sg->length;
-	}
-	return nents;
-}
-
 static void write_phys_cpl(struct cpl_rx_phys_dsgl *phys_cpl,
 			   struct scatterlist *sg,
 			   struct phys_sge_parm *sg_param)
 {
 	struct phys_sge_pairs *to;
-	unsigned int out_buf_size = sg_param->obsize;
-	unsigned int nents = sg_param->nents, i, j, tot_len = 0;
+	int out_buf_size = sg_param->obsize;
+	unsigned int nents = sg_param->nents, i, j = 0;
 
 	phys_cpl->op_to_tid = htonl(CPL_RX_PHYS_DSGL_OPCODE_V(CPL_RX_PHYS_DSGL)
 				    | CPL_RX_PHYS_DSGL_ISRDMA_V(0));
@@ -371,25 +359,24 @@ static void write_phys_cpl(struct cpl_rx_phys_dsgl *phys_cpl,
 				       sizeof(struct cpl_rx_phys_dsgl));
 
 	for (i = 0; nents; to++) {
-		for (j = i; (nents && (j < (8 + i))); j++, nents--) {
-			to->len[j] = htons(sg->length);
+		for (j = 0; j < 8 && nents; j++, nents--) {
+			out_buf_size -= sg_dma_len(sg);
+			to->len[j] = htons(sg_dma_len(sg));
 			to->addr[j] = cpu_to_be64(sg_dma_address(sg));
-			if (out_buf_size) {
-				if (tot_len + sg_dma_len(sg) >= out_buf_size) {
-					to->len[j] = htons(out_buf_size -
-							   tot_len);
-					return;
-				}
-				tot_len += sg_dma_len(sg);
-			}
 			sg = sg_next(sg);
 		}
 	}
+	if (out_buf_size) {
+		j--;
+		to--;
+		to->len[j] = htons(ntohs(to->len[j]) + (out_buf_size));
+	}
 }
 
-static inline unsigned
-int map_writesg_phys_cpl(struct device *dev, struct cpl_rx_phys_dsgl *phys_cpl,
-			 struct scatterlist *sg, struct phys_sge_parm *sg_param)
+static inline int map_writesg_phys_cpl(struct device *dev,
+					struct cpl_rx_phys_dsgl *phys_cpl,
+					struct scatterlist *sg,
+					struct phys_sge_parm *sg_param)
 {
 	if (!sg || !sg_param->nents)
 		return 0;
@@ -531,16 +518,19 @@ static inline void create_wreq(struct chcr_context *ctx,
 	struct cpl_rx_phys_dsgl *phys_cpl;
 	struct chcr_blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	struct phys_sge_parm sg_param;
-	unsigned int frags = 0, transhdr_len, phys_dsgl, dst_bufsize = 0;
+	unsigned int frags = 0, transhdr_len, phys_dsgl;
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm), kctx_len;
 	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 			GFP_ATOMIC;
 
 	if (!req->info)
 		return ERR_PTR(-EINVAL);
-	ablkctx->dst_nents = ch_nents(req->dst, &dst_bufsize);
+	ablkctx->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
+	if (ablkctx->dst_nents <= 0) {
+		pr_err("AES:Invalid Destination sg lists\n");
+		return ERR_PTR(-EINVAL);
+	}
 	ablkctx->enc = op_type;
-
 	if ((ablkctx->enckey_len == 0) || (ivsize > AES_BLOCK_SIZE) ||
 	    (req->nbytes <= 0) || (req->nbytes % AES_BLOCK_SIZE)) {
 		pr_err("AES: Invalid value of Key Len %d nbytes %d IV Len %d\n",
-- 
1.8.2.3
