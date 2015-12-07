From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 01/11] crypto: caam: fix DMA API mapping leak
Date: Mon, 07 Dec 2015 19:12:00 +0000
Message-ID: <E1a61Ca-0007mB-6H@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60504 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbbLGTMI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:08 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
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
 drivers/crypto/caam/caamhash.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 49106ea42887..eccde7207f92 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1085,9 +1085,12 @@ static int ahash_digest(struct ahash_request *req)
 	u32 options;
 	int sh_len;
 
-	src_nents = sg_count(req->src, req->nbytes);
-	dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
-	sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+	src_nents = sg_nents_for_len(req->src, req->nbytes);
+	dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
+	if (src_nents > 1)
+		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+	else
+		sec4_sg_bytes = 0;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes + DESC_JOB_IO_LEN,
@@ -1105,7 +1108,7 @@ static int ahash_digest(struct ahash_request *req)
 	desc = edesc->hw_desc;
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
-	if (src_nents) {
+	if (src_nents > 1) {
 		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1232,8 +1235,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	to_hash = in_len - *next_buflen;
 
 	if (to_hash) {
-		src_nents = sg_nents_for_len(req->src,
-					     req->nbytes - (*next_buflen));
+		src_nents = sg_nents_for_len(req->src, req->nbytes -
+						       *next_buflen);
 		sec4_sg_bytes = (1 + src_nents) *
 				sizeof(struct sec4_sg_entry);
 
@@ -1429,9 +1432,14 @@ static int ahash_update_first(struct ahash_request *req)
 	to_hash = req->nbytes - *next_buflen;
 
 	if (to_hash) {
-		src_nents = sg_count(req->src, req->nbytes - (*next_buflen));
-		dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
-		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+		src_nents = sg_nents_for_len(req->src, req->nbytes -
+						       *next_buflen);
+		dma_map_sg(jrdev, req->src, src_nents, DMA_TO_DEVICE);
+		if (src_nents > 1)
+			sec4_sg_bytes = src_nents *
+					sizeof(struct sec4_sg_entry);
+		else
+			sec4_sg_bytes = 0;
 
 		/*
 		 * allocate space for base edesc and hw desc commands,
@@ -1451,7 +1459,7 @@ static int ahash_update_first(struct ahash_request *req)
 				 DESC_JOB_IO_LEN;
 		edesc->dst_dma = 0;
 
-		if (src_nents) {
+		if (src_nents > 1) {
 			sg_to_sec4_sg_last(req->src, src_nents,
 					   edesc->sec4_sg, 0);
 			edesc->sec4_sg_dma = dma_map_single(jrdev,
-- 
2.1.0
