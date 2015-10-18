From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 6/6] crypto: caam: fix DMA API leak
Date: Sun, 18 Oct 2015 17:51:36 +0100
Message-ID: <E1ZnrBI-0005nl-65@rmk-PC.arm.linux.org.uk>
References: <20151018165046.GA7997@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45376 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbbJRQvo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:51:44 -0400
In-Reply-To: <20151018165046.GA7997@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caamhash contains this weird code:

	src_nents = sg_count(req->src, req->nbytes, &chained);
	dma_map_sg_chained(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE,
			   chained);
	...
	edesc->src_nents = src_nents;

sg_count() returns zero when __sg_count() returns zero or one.  This
is used to mean that we don't need to use a hardware scatterlist.
However, setting src_nents to zero causes problems when we unmap:

        if (edesc->src_nents)
                dma_unmap_sg_chained(dev, req->src, edesc->src_nents,
                                     DMA_TO_DEVICE, edesc->chained);

as zero here means that we have no entries to unmap.

This can be fixed in two ways: either by writing the number of entries
that were requested of dma_map_sg_chained(), or by reworking the "no
SG required" case.

We adopt the re-work solution here - we replace sg_count() with
__sg_count(), so src_nents now contains the real number of scatterlist
entries, and we then change the test for using the hardware scatterlist
to src_nents > 1 rather than just non-zero.

This change passes my sshd, openssl tests hashing /bin and tcrypt
tests.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f30c93840bba..28434ad08cb4 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1095,10 +1095,13 @@ static int ahash_digest(struct ahash_request *req)
 	u32 options;
 	int sh_len;
 
-	src_nents = sg_count(req->src, req->nbytes, &chained);
-	dma_map_sg_chained(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE,
+	src_nents = __sg_count(req->src, req->nbytes, &chained);
+	dma_map_sg_chained(jrdev, req->src, src_nents, DMA_TO_DEVICE,
 			   chained);
-	sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+	if (src_nents > 1)
+		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+	else
+		sec4_sg_bytes = 0;
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kzalloc(sizeof(*edesc) + sec4_sg_bytes + DESC_JOB_IO_LEN,
@@ -1117,7 +1120,7 @@ static int ahash_digest(struct ahash_request *req)
 	desc = edesc->hw_desc;
 	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
 
-	if (src_nents) {
+	if (src_nents > 1) {
 		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
@@ -1447,11 +1450,15 @@ static int ahash_update_first(struct ahash_request *req)
 	to_hash = req->nbytes - *next_buflen;
 
 	if (to_hash) {
-		src_nents = sg_count(req->src, req->nbytes - (*next_buflen),
-				     &chained);
-		dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+		src_nents = __sg_count(req->src, req->nbytes - (*next_buflen),
+				       &chained);
+		dma_map_sg_chained(jrdev, req->src, src_nents,
 				   DMA_TO_DEVICE, chained);
-		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
+		if (src_nents > 1)
+			sec4_sg_bytes = src_nents *
+					sizeof(struct sec4_sg_entry);
+		else
+			sec4_sg_bytes = 0;
 
 		/*
 		 * allocate space for base edesc and hw desc commands,
@@ -1472,7 +1479,7 @@ static int ahash_update_first(struct ahash_request *req)
 				 DESC_JOB_IO_LEN;
 		edesc->dst_dma = 0;
 
-		if (src_nents) {
+		if (src_nents > 1) {
 			sg_to_sec4_sg_last(req->src, src_nents,
 					   edesc->sec4_sg, 0);
 			edesc->sec4_sg_dma = dma_map_single(jrdev,
-- 
2.1.0
