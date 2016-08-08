From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 01/11] crypto: caam: fix DMA API mapping leak
Date: Mon, 08 Aug 2016 18:04:31 +0100
Message-ID: <E1bWnyZ-0002V4-LJ@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57469 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbcHHREh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:04:37 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caamhash contains this weird code:

	src_nents = sg_count(req->src, req->nbytes);
	dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
	...
	edesc->src_nents = src_nents;

sg_count() returns zero when sg_nents_for_len() returns zero or one.
This means we don't need to use a hardware scatterlist.  However,
setting src_nents to zero causes problems when we unmap:

	if (edesc->src_nents)
		dma_unmap_sg_chained(dev, req->src, edesc->src_nents,
				     DMA_TO_DEVICE, edesc->chained);

as zero here means that we have no entries to unmap.  This causes us
to leak DMA mappings, where we map one scatterlist entry and then
fail to unmap it.

This can be fixed in two ways: either by writing the number of entries
that were requested of dma_map_sg(), or by reworking the "no SG
required" case.

We adopt the re-work solution here - we replace sg_count() with
sg_nents_for_len(), so src_nents now contains the real number of
scatterlist entries, and we then change the test for using the
hardware scatterlist to src_nents > 1 rather than just non-zero.

This change passes my sshd, openssl tests hashing /bin and tcrypt
tests.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f1ecc8df8d41..85c8b048bdc1 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1094,13 +1094,16 @@ static int ahash_digest(struct ahash_request *req)
 	u32 options;
 	int sh_len;
 
-	src_nents = sg_count(req->src, req->nbytes);
+	src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (src_nents < 0) {
 		dev_err(jrdev, "Invalid number of src SG.\n");
 		return src_nents;
 	}
-	dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
-	sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+	dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
+	if (src_nents > 1)
+		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+	else
+		sec4_sg_bytes = 0;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes + DESC_JOB_IO_LEN,
@@ -1118,7 +1121,7 @@ static int ahash_digest(struct ahash_request *req)
 	desc = edesc->hw_desc;
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
-	if (src_nents) {
+	if (src_nents > 1) {
 		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1246,7 +1249,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src,
-					     req->nbytes - (*next_buflen));
+					     req->nbytes - *next_buflen);
 		if (src_nents < 0) {
 			dev_err(jrdev, "Invalid number of src SG.\n");
 			return src_nents;
@@ -1450,13 +1453,18 @@ static int ahash_update_first(struct ahash_request *req)
 	to_hash = req->nbytes - *next_buflen;
 
 	if (to_hash) {
-		src_nents = sg_count(req->src, req->nbytes - (*next_buflen));
+		src_nents = sg_nents_for_len(req->src,
+					     req->nbytes - *next_buflen);
 		if (src_nents < 0) {
 			dev_err(jrdev, "Invalid number of src SG.\n");
 			return src_nents;
 		}
-		dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
-		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+		dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
+		if (src_nents > 1)
+			sec4_sg_bytes = src_nents *
+					sizeof(struct sec4_sg_entry);
+		else
+			sec4_sg_bytes = 0;
 
 		/*
 		 * allocate space for base edesc and hw desc commands,
@@ -1476,7 +1484,7 @@ static int ahash_update_first(struct ahash_request *req)
 				 DESC_JOB_IO_LEN;
 		edesc->dst_dma = 0;
 
-		if (src_nents) {
+		if (src_nents > 1) {
 			sg_to_sec4_sg_last(req->src, src_nents,
 					   edesc->sec4_sg, 0);
 			edesc->sec4_sg_dma = dma_map_single(jrdev,
-- 
2.1.0
