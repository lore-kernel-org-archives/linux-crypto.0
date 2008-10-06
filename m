From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH 3/3] crypto: talitos - perform auth check in h/w if on sec
	2.1 and above
Date: Mon, 06 Oct 2008 15:09:09 -0500
Message-ID: <1223323749.24986.14.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:63083 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYJFT65 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2008 15:58:57 -0400
Received: from de01smr01.freescale.net (de01smr01.freescale.net [10.208.0.31])
	by de01egw02.freescale.net (8.12.11/de01egw02) with ESMTP id m96JwrlI018056
	for <linux-crypto@vger.kernel.org>; Mon, 6 Oct 2008 12:58:54 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by de01smr01.freescale.net (8.13.1/8.13.0) with ESMTP id m96JwrCc029629
	for <linux-crypto@vger.kernel.org>; Mon, 6 Oct 2008 14:58:53 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Kim Phillips <kim.phillips@freescale.com>

SEC version 2.1 and above adds the capability to do the IPSec ICV
memcmp in h/w. Results of the cmp are written back in the descriptor
header, along with the done status.  A new callback is added that
checks these ICCR bits instead of performing the memcmp on the core,
and is enabled by h/w capability.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

After testing on different parts, another condition was added
before using h/w auth check because different
SEC revisions require different handling.

The SEC 3.0 allows a more flexible link table where
the auth data can span separate link table entries.
The SEC 2.4/2.1 does not support this case.
So a test was added in the decrypt routine
for a fragmented case; the h/w auth check is disallowed for
revisions not having the extent in the link table;
in this case the hw auth check is done by software.

A portion of a previous change for SEC 3.0 link table handling
was removed since it became dead code with the hw auth check supported.

This seems to be the best compromise for using hw auth check
on supporting SEC revisions; it keeps the link table logic
simpler for the fragmented cases.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
---
 drivers/crypto/talitos.c |  127 ++++++++++++++++++++++++++++++----------------
 drivers/crypto/talitos.h |    8 +++
 2 files changed, 91 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6ced894..ca4d36c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -137,6 +137,7 @@ struct talitos_private {
 
 /* .features flag */
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
+#define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
 
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
@@ -183,6 +184,11 @@ static int reset_channel(struct device *dev, int ch)
 	setbits32(priv->reg + TALITOS_CCCR_LO(ch), TALITOS_CCCR_LO_CDWE |
 		  TALITOS_CCCR_LO_CDIE);
 
+	/* and ICCR writeback, if available */
+	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
+		setbits32(priv->reg + TALITOS_CCCR_LO(ch),
+		          TALITOS_CCCR_LO_IWSE);
+
 	return 0;
 }
 
@@ -238,6 +244,11 @@ static int init_device(struct device *dev)
 	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
 	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
 
+	/* disable integrity check error interrupts (use writeback instead) */
+	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
+		setbits32(priv->reg + TALITOS_MDEUICR_LO,
+		          TALITOS_MDEUICR_LO_ICE);
+
 	return 0;
 }
 
@@ -375,7 +386,8 @@ static void talitos_done(unsigned long data)
 	/* At this point, all completed channels have been processed.
 	 * Unmask done interrupts for channels completed later on.
 	 */
-	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_DONE);
+	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
+	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
 }
 
 /*
@@ -812,7 +824,7 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	aead_request_complete(areq, err);
 }
 
-static void ipsec_esp_decrypt_done(struct device *dev,
+static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 				   struct talitos_desc *desc, void *context,
 				   int err)
 {
@@ -844,6 +856,27 @@ static void ipsec_esp_decrypt_done(struct device *dev,
 	aead_request_complete(req, err);
 }
 
+static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
+				   struct talitos_desc *desc, void *context,
+				   int err)
+{
+	struct aead_request *req = context;
+	struct ipsec_esp_edesc *edesc =
+		 container_of(desc, struct ipsec_esp_edesc, desc);
+
+	ipsec_esp_unmap(dev, edesc, req);
+
+	/* check ICV auth status */
+	if (!err)
+		if ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
+		    DESC_HDR_LO_ICCR1_PASS)
+			err = -EBADMSG;
+
+	kfree(edesc);
+
+	aead_request_complete(req, err);
+}
+
 /*
  * convert scatterlist to SEC h/w link table format
  * stop at cryptlen bytes
@@ -897,6 +930,7 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	unsigned int authsize = ctx->authsize;
 	unsigned int ivsize;
 	int sg_count, ret;
+	int sg_link_tbl_len;
 
 	/* hmac key */
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
@@ -934,33 +968,19 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	if (sg_count == 1) {
 		desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
 	} else {
-		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
+		sg_link_tbl_len = cryptlen;
+
+		if ((edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV) &&
+			(edesc->desc.hdr & DESC_HDR_MODE0_ENCRYPT) == 0) {
+			sg_link_tbl_len = cryptlen + authsize;
+		}
+		sg_count = sg_to_link_tbl(areq->src, sg_count, sg_link_tbl_len,
 					  &edesc->link_tbl[0]);
 		if (sg_count > 1) {
-			struct talitos_ptr *link_tbl_ptr =
-				&edesc->link_tbl[sg_count-1];
-			struct scatterlist *sg;
-			struct talitos_private *priv = dev_get_drvdata(dev);
-
 			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
 			desc->ptr[4].ptr = cpu_to_be32(edesc->dma_link_tbl);
 			dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
 						   edesc->dma_len, DMA_BIDIRECTIONAL);
-			/* If necessary for this SEC revision,
-			 * add a link table entry for ICV.
-			 */
-			if ((priv->features &
-			     TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT) &&
-			    (edesc->desc.hdr & DESC_HDR_MODE0_ENCRYPT) == 0) {
-				link_tbl_ptr->j_extent = 0;
-				link_tbl_ptr++;
-				link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
-				link_tbl_ptr->len = cpu_to_be16(authsize);
-				sg = sg_last(areq->src, edesc->src_nents ? : 1);
-				link_tbl_ptr->ptr = cpu_to_be32(
-						(char *)sg_dma_address(sg)
-						+ sg->length - authsize);
-			}
 		} else {
 			/* Only one segment now, so no link tbl needed */
 			desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
@@ -985,13 +1005,9 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 		desc->ptr[5].ptr = cpu_to_be32((struct talitos_ptr *)
 					       edesc->dma_link_tbl +
 					       edesc->src_nents + 1);
-		if (areq->src == areq->dst) {
-			memcpy(link_tbl_ptr, &edesc->link_tbl[0],
-			       edesc->src_nents * sizeof(struct talitos_ptr));
-		} else {
-			sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
-						  link_tbl_ptr);
-		}
+		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
+					  link_tbl_ptr);
+
 		/* Add an entry to the link table for ICV data */
 		link_tbl_ptr += sg_count - 1;
 		link_tbl_ptr->j_extent = 0;
@@ -1116,11 +1132,14 @@ static int aead_authenc_encrypt(struct aead_request *req)
 	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_encrypt_done);
 }
 
+
+
 static int aead_authenc_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	unsigned int authsize = ctx->authsize;
+	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
 	struct ipsec_esp_edesc *edesc;
 	struct scatterlist *sg;
 	void *icvdata;
@@ -1132,22 +1151,39 @@ static int aead_authenc_decrypt(struct aead_request *req)
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	/* stash incoming ICV for later cmp with ICV generated by the h/w */
-	if (edesc->dma_len)
-		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 2];
-	else
-		icvdata = &edesc->link_tbl[0];
+	if ((priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
+	    (((!edesc->src_nents && !edesc->dst_nents) ||
+		priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT))) {
 
-	sg = sg_last(req->src, edesc->src_nents ? : 1);
+		/* decrypt and check the ICV */
+		edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND |
+				  DESC_HDR_MODE1_MDEU_CICV;
 
-	memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
-	       ctx->authsize);
+		/* reset integrity check result bits */
+		edesc->desc.hdr_lo = 0;
 
-	/* decrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+		return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_hwauth_done);
 
-	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_done);
+	} else {
+
+		/* Have to check the ICV with software */
+
+		edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+
+		/* stash incoming ICV for later cmp with ICV generated by the h/w */
+		if (edesc->dma_len)
+			icvdata = &edesc->link_tbl[edesc->src_nents +
+						   edesc->dst_nents + 2];
+		else
+			icvdata = &edesc->link_tbl[0];
+
+		sg = sg_last(req->src, edesc->src_nents ? : 1);
+
+		memcpy(icvdata, (char *)sg_virt(sg) + sg->length - ctx->authsize,
+		       ctx->authsize);
+
+		return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_swauth_done);
+	}
 }
 
 static int aead_authenc_givencrypt(
@@ -1462,6 +1498,8 @@ static int talitos_probe(struct of_device *ofdev,
 
 	tasklet_init(&priv->done_task, talitos_done, (unsigned long)dev);
 
+	INIT_LIST_HEAD(&priv->alg_list);
+
 	priv->irq = irq_of_parse_and_map(np, 0);
 
 	if (priv->irq == NO_IRQ) {
@@ -1514,6 +1552,9 @@ static int talitos_probe(struct of_device *ofdev,
 	if (of_device_is_compatible(np, "fsl,sec3.0"))
 		priv->features |= TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT;
 
+	if (of_device_is_compatible(np, "fsl,sec2.1"))
+		priv->features |= TALITOS_FTR_HW_AUTH_CHECK;
+
 	priv->head_lock = kmalloc(sizeof(spinlock_t) * priv->num_channels,
 				  GFP_KERNEL);
 	priv->tail_lock = kmalloc(sizeof(spinlock_t) * priv->num_channels,
@@ -1585,8 +1626,6 @@ static int talitos_probe(struct of_device *ofdev,
 	}
 
 	/* register crypto algorithms the device supports */
-	INIT_LIST_HEAD(&priv->alg_list);
-
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
 			struct talitos_crypto_alg *t_alg;
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index e6b8777..125560a 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -56,6 +56,7 @@
 #define   TALITOS_CCCR_CONT		0x2    /* channel continue */
 #define   TALITOS_CCCR_RESET		0x1    /* channel reset */
 #define TALITOS_CCCR_LO(ch)		(ch * TALITOS_CH_STRIDE + 0x110c)
+#define   TALITOS_CCCR_LO_IWSE		0x80   /* chan. ICCR writeback enab. */
 #define   TALITOS_CCCR_LO_CDWE		0x10   /* chan. done writeback enab. */
 #define   TALITOS_CCCR_LO_NT		0x4    /* notification type */
 #define   TALITOS_CCCR_LO_CDIE		0x2    /* channel done IRQ enable */
@@ -103,6 +104,9 @@
 #define TALITOS_AESUISR_LO		0x4034
 #define TALITOS_MDEUISR			0x6030 /* message digest unit */
 #define TALITOS_MDEUISR_LO		0x6034
+#define TALITOS_MDEUICR			0x6038 /* interrupt control */
+#define TALITOS_MDEUICR_LO		0x603c
+#define   TALITOS_MDEUICR_LO_ICE	0x4000 /* integrity check IRQ enable */
 #define TALITOS_AFEUISR			0x8030 /* arc4 unit */
 #define TALITOS_AFEUISR_LO		0x8034
 #define TALITOS_RNGUISR			0xa030 /* random number unit */
@@ -131,6 +135,9 @@
 
 /* written back when done */
 #define DESC_HDR_DONE			__constant_cpu_to_be32(0xff000000)
+#define DESC_HDR_LO_ICCR1_MASK		__constant_cpu_to_be32(0x00180000)
+#define DESC_HDR_LO_ICCR1_PASS		__constant_cpu_to_be32(0x00080000)
+#define DESC_HDR_LO_ICCR1_FAIL		__constant_cpu_to_be32(0x00100000)
 
 /* primary execution unit select */
 #define	DESC_HDR_SEL0_MASK		__constant_cpu_to_be32(0xf0000000)
@@ -169,6 +176,7 @@
 #define	DESC_HDR_SEL1_CRCU		__constant_cpu_to_be32(0x00080000)
 
 /* secondary execution unit mode (MODE1) and derivatives */
+#define	DESC_HDR_MODE1_MDEU_CICV	__constant_cpu_to_be32(0x00004000)
 #define	DESC_HDR_MODE1_MDEU_INIT	__constant_cpu_to_be32(0x00001000)
 #define	DESC_HDR_MODE1_MDEU_HMAC	__constant_cpu_to_be32(0x00000800)
 #define	DESC_HDR_MODE1_MDEU_PAD		__constant_cpu_to_be32(0x00000400)
-- 
1.5.6.2


