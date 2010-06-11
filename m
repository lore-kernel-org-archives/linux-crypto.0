From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCH] crypto: talitos - fix ahash for multiple of blocksize
Date: Thu, 10 Jun 2010 23:55:30 -0500
Message-ID: <1276232130-19759-1-git-send-email-lee.nipper@gmail.com>
Cc: Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f204.google.com ([209.85.211.204]:61501 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0FKEzd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jun 2010 00:55:33 -0400
Received: by ywh42 with SMTP id 42so808376ywh.15
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jun 2010 21:55:32 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Correct ahash_process_req() to properly handle cases
where the total hash amount is a multiple of the blocksize.
The SEC must have some data to hash during the very last
descriptor operation; so up to one whole blocksize
of data is buffered until the final hash.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
 drivers/crypto/talitos.c |   77 ++++++++++++++++++++++++----------------------
 1 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6a0f59d..26156f9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -720,7 +720,6 @@ struct talitos_ctx {
 #define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
 
 struct talitos_ahash_req_ctx {
-	u64 count;
 	u32 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE / sizeof(u32)];
 	unsigned int hw_context_size;
 	u8 buf[HASH_MAX_BLOCK_SIZE];
@@ -729,6 +728,7 @@ struct talitos_ahash_req_ctx {
 	unsigned int first;
 	unsigned int last;
 	unsigned int to_hash_later;
+	u64 nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
 };
@@ -1609,6 +1609,7 @@ static void ahash_done(struct device *dev,
 	if (!req_ctx->last && req_ctx->to_hash_later) {
 		/* Position any partial block for next update/final/finup */
 		memcpy(req_ctx->buf, req_ctx->bufnext, req_ctx->to_hash_later);
+		req_ctx->nbuf = req_ctx->to_hash_later;
 	}
 	common_nonsnoop_hash_unmap(dev, edesc, areq);
 
@@ -1724,7 +1725,7 @@ static int ahash_init(struct ahash_request *areq)
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
 	/* Initialize the context */
-	req_ctx->count = 0;
+	req_ctx->nbuf = 0;
 	req_ctx->first = 1; /* first indicates h/w must init its context */
 	req_ctx->swinit = 0; /* assume h/w init of context */
 	req_ctx->hw_context_size =
@@ -1772,52 +1773,54 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
-	unsigned int index;
+	unsigned int nsg;
 	int chained;
 
-	index = req_ctx->count & (blocksize - 1);
-	req_ctx->count += nbytes;
-
-	if (!req_ctx->last && (index + nbytes) < blocksize) {
-		/* Buffer the partial block */
+	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
+		/* Buffer up to one whole block */
 		sg_copy_to_buffer(areq->src,
 				  sg_count(areq->src, nbytes, &chained),
-				  req_ctx->buf + index, nbytes);
+				  req_ctx->buf + req_ctx->nbuf, nbytes);
+		req_ctx->nbuf += nbytes;
 		return 0;
 	}
 
-	if (index) {
-		/* partial block from previous update; chain it in. */
-		sg_init_table(req_ctx->bufsl, (nbytes) ? 2 : 1);
-		sg_set_buf(req_ctx->bufsl, req_ctx->buf, index);
-		if (nbytes)
-			scatterwalk_sg_chain(req_ctx->bufsl, 2,
-					     areq->src);
+	/* At least (blocksize + 1) bytes are available to hash */
+	nbytes_to_hash = nbytes + req_ctx->nbuf;
+	to_hash_later = nbytes_to_hash & (blocksize - 1);
+
+	if (req_ctx->last)
+		to_hash_later = 0;
+	else if (to_hash_later)
+		/* There is a partial block. Hash the full block(s) now */
+		nbytes_to_hash -= to_hash_later;
+	else {
+		/* Keep one block buffered */
+		nbytes_to_hash -= blocksize;
+		to_hash_later = blocksize;
+	}
+
+	/* Chain in any previously buffered data */
+	if (req_ctx->nbuf) {
+		nsg = (req_ctx->nbuf < nbytes_to_hash) ? 2 : 1;
+		sg_init_table(req_ctx->bufsl, nsg);
+		sg_set_buf(req_ctx->bufsl, req_ctx->buf, req_ctx->nbuf);
+		if (nsg > 1)
+			scatterwalk_sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
-	} else {
+	} else
 		req_ctx->psrc = areq->src;
+
+	if (to_hash_later) {
+		int nents = sg_count(areq->src, nbytes, &chained);
+		sg_copy_end_to_buffer(areq->src, nents,
+				      req_ctx->bufnext,
+				      to_hash_later,
+				      nbytes - to_hash_later);
 	}
-	nbytes_to_hash =  index + nbytes;
-	if (!req_ctx->last) {
-		to_hash_later = (nbytes_to_hash & (blocksize - 1));
-		if (to_hash_later) {
-			int nents;
-			/* Must copy to_hash_later bytes from the end
-			 * to bufnext (a partial block) for later.
-			 */
-			nents = sg_count(areq->src, nbytes, &chained);
-			sg_copy_end_to_buffer(areq->src, nents,
-					      req_ctx->bufnext,
-					      to_hash_later,
-					      nbytes - to_hash_later);
-
-			/* Adjust count for what will be hashed now */
-			nbytes_to_hash -= to_hash_later;
-		}
-		req_ctx->to_hash_later = to_hash_later;
-	}
+	req_ctx->to_hash_later = to_hash_later;
 
-	/* allocate extended descriptor */
+	/* Allocate extended descriptor */
 	edesc = ahash_edesc_alloc(areq, nbytes_to_hash);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
-- 
1.6.0.4
