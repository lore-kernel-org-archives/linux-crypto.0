From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH] crypto: talitos - add handling for SEC 3.x treatment of
	link table
Date: Tue, 29 Jul 2008 17:29:06 -0500
Message-ID: <1217370547.17033.17.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:42213 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739AbYG2WVT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Jul 2008 18:21:19 -0400
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.12.11/az33egw02) with ESMTP id m6TMLG2U019849
	for <linux-crypto@vger.kernel.org>; Tue, 29 Jul 2008 15:21:16 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id m6TMLFbH004259
	for <linux-crypto@vger.kernel.org>; Tue, 29 Jul 2008 17:21:15 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Later SEC revision requires the link table (used for scatter/gather)
to have an extra entry to account for the total length in descriptor [4],
which contains cipher Input and ICV.
This only applies to decrypt, not encrypt.
Without this change, on 837x, a gather return/length error results
when a decryption uses a link table to gather the fragments.
This is observed by doing a ping with size of 1447 or larger with AES,
or a ping with size 1455 or larger with 3des.

So, add check for SEC compatible "fsl,3.0" for using extra link table entry.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
This patch applies against the kernel.org crypto tree at
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.
It has been tested on MPC8377E-RDB and MPC8349EA-MDS.

 drivers/crypto/talitos.c |   54 +++++++++++++++++++++++++++++++++------------
 1 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 681c15f..ee827a7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -96,6 +96,9 @@ struct talitos_private {
 	unsigned int exec_units;
 	unsigned int desc_types;
 
+	/* SEC Compatibility info */
+	unsigned long features;
+
 	/* next channel to be assigned next incoming descriptor */
 	atomic_t last_chan;
 
@@ -133,6 +136,9 @@ struct talitos_private {
 	struct hwrng rng;
 };
 
+/* .features flag */
+#define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
+
 /*
  * map virtual single (contiguous) pointer to h/w descriptor pointer
  */
@@ -785,7 +791,7 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	/* copy the generated ICV to dst */
 	if (edesc->dma_len) {
 		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 1];
+					   edesc->dst_nents + 2];
 		sg = sg_last(areq->dst, edesc->dst_nents);
 		memcpy((char *)sg_virt(sg) + sg->length - ctx->authsize,
 		       icvdata, ctx->authsize);
@@ -814,7 +820,7 @@ static void ipsec_esp_decrypt_done(struct device *dev,
 		/* auth check */
 		if (edesc->dma_len)
 			icvdata = &edesc->link_tbl[edesc->src_nents +
-						   edesc->dst_nents + 1];
+						   edesc->dst_nents + 2];
 		else
 			icvdata = &edesc->link_tbl[0];
 
@@ -921,10 +927,30 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
 					  &edesc->link_tbl[0]);
 		if (sg_count > 1) {
+			struct talitos_ptr *link_tbl_ptr =
+				&edesc->link_tbl[sg_count-1];
+			struct scatterlist *sg;
+			struct talitos_private *priv = dev_get_drvdata(dev);
+
 			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
 			desc->ptr[4].ptr = cpu_to_be32(edesc->dma_link_tbl);
 			dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
 						   edesc->dma_len, DMA_BIDIRECTIONAL);
+			/* If necessary for this SEC revision,
+			 * add a link table entry for ICV.
+			 */
+			if ((priv->features &
+			     TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT) &&
+			    (edesc->desc.hdr & DESC_HDR_MODE0_ENCRYPT) == 0) {
+				link_tbl_ptr->j_extent = 0;
+				link_tbl_ptr++;
+				link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+				link_tbl_ptr->len = cpu_to_be16(authsize);
+				sg = sg_last(areq->src, edesc->src_nents ? : 1);
+				link_tbl_ptr->ptr = cpu_to_be32(
+						(char *)sg_dma_address(sg)
+						+ sg->length - authsize);
+			}
 		} else {
 			/* Only one segment now, so no link tbl needed */
 			desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
@@ -944,12 +970,11 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 		desc->ptr[5].ptr = cpu_to_be32(sg_dma_address(areq->dst));
 	} else {
 		struct talitos_ptr *link_tbl_ptr =
-			&edesc->link_tbl[edesc->src_nents];
-		struct scatterlist *sg;
+			&edesc->link_tbl[edesc->src_nents + 1];
 
 		desc->ptr[5].ptr = cpu_to_be32((struct talitos_ptr *)
 					       edesc->dma_link_tbl +
-					       edesc->src_nents);
+					       edesc->src_nents + 1);
 		if (areq->src == areq->dst) {
 			memcpy(link_tbl_ptr, &edesc->link_tbl[0],
 			       edesc->src_nents * sizeof(struct talitos_ptr));
@@ -957,14 +982,10 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 			sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
 						  link_tbl_ptr);
 		}
+		/* Add an entry to the link table for ICV data */
 		link_tbl_ptr += sg_count - 1;
-
-		/* handle case where sg_last contains the ICV exclusively */
-		sg = sg_last(areq->dst, edesc->dst_nents);
-		if (sg->length == ctx->authsize)
-			link_tbl_ptr--;
-
 		link_tbl_ptr->j_extent = 0;
+		sg_count++;
 		link_tbl_ptr++;
 		link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
 		link_tbl_ptr->len = cpu_to_be16(authsize);
@@ -973,7 +994,7 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 		link_tbl_ptr->ptr = cpu_to_be32((struct talitos_ptr *)
 						edesc->dma_link_tbl +
 					        edesc->src_nents +
-						edesc->dst_nents + 1);
+						edesc->dst_nents + 2);
 
 		desc->ptr[5].j_extent |= DESC_PTR_LNKTBL_JUMP;
 		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
@@ -1040,12 +1061,12 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 
 	/*
 	 * allocate space for base edesc plus the link tables,
-	 * allowing for a separate entry for the generated ICV (+ 1),
+	 * allowing for two separate entries for ICV and generated ICV (+ 2),
 	 * and the ICV data itself
 	 */
 	alloc_len = sizeof(struct ipsec_esp_edesc);
 	if (src_nents || dst_nents) {
-		dma_len = (src_nents + dst_nents + 1) *
+		dma_len = (src_nents + dst_nents + 2) *
 				 sizeof(struct talitos_ptr) + ctx->authsize;
 		alloc_len += dma_len;
 	} else {
@@ -1104,7 +1125,7 @@ static int aead_authenc_decrypt(struct aead_request *req)
 	/* stash incoming ICV for later cmp with ICV generated by the h/w */
 	if (edesc->dma_len)
 		icvdata = &edesc->link_tbl[edesc->src_nents +
-					   edesc->dst_nents + 1];
+					   edesc->dst_nents + 2];
 	else
 		icvdata = &edesc->link_tbl[0];
 
@@ -1480,6 +1501,9 @@ static int talitos_probe(struct of_device *ofdev,
 		goto err_out;
 	}
 
+	if (of_device_is_compatible(np, "fsl,sec3.0"))
+		priv->features |= TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT;
+
 	priv->head_lock = kmalloc(sizeof(spinlock_t) * priv->num_channels,
 				  GFP_KERNEL);
 	priv->tail_lock = kmalloc(sizeof(spinlock_t) * priv->num_channels,
-- 
1.5.6.2


