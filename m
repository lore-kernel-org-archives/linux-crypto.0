From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 01/13] mv_cesa: do not use scatterlist iterators
Date: Fri, 25 May 2012 18:08:27 +0200
Message-ID: <1337962119-5509-2-git-send-email-phil.sutter@viprinet.com>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:47934 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171Ab2EYQJF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 12:09:05 -0400
In-Reply-To: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The big problem is they cannot be used to iterate over DMA mapped
scatterlists, so get rid of them in order to add DMA functionality to
mv_cesa.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   57 ++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 3cc9237..c305350 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -43,8 +43,8 @@ enum engine_status {
 
 /**
  * struct req_progress - used for every crypt request
- * @src_sg_it:		sg iterator for src
- * @dst_sg_it:		sg iterator for dst
+ * @src_sg:		sg list for src
+ * @dst_sg:		sg list for dst
  * @sg_src_left:	bytes left in src to process (scatter list)
  * @src_start:		offset to add to src start position (scatter list)
  * @crypt_len:		length of current hw crypt/hash process
@@ -59,8 +59,8 @@ enum engine_status {
  * track of progress within current scatterlist.
  */
 struct req_progress {
-	struct sg_mapping_iter src_sg_it;
-	struct sg_mapping_iter dst_sg_it;
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
 	void (*complete) (void);
 	void (*process) (int is_first);
 
@@ -210,19 +210,19 @@ static int mv_setkey_aes(struct crypto_ablkcipher *cipher, const u8 *key,
 
 static void copy_src_to_buf(struct req_progress *p, char *dbuf, int len)
 {
-	int ret;
 	void *sbuf;
 	int copy_len;
 
 	while (len) {
 		if (!p->sg_src_left) {
-			ret = sg_miter_next(&p->src_sg_it);
-			BUG_ON(!ret);
-			p->sg_src_left = p->src_sg_it.length;
+			/* next sg please */
+			p->src_sg = sg_next(p->src_sg);
+			BUG_ON(!p->src_sg);
+			p->sg_src_left = p->src_sg->length;
 			p->src_start = 0;
 		}
 
-		sbuf = p->src_sg_it.addr + p->src_start;
+		sbuf = sg_virt(p->src_sg) + p->src_start;
 
 		copy_len = min(p->sg_src_left, len);
 		memcpy(dbuf, sbuf, copy_len);
@@ -305,9 +305,6 @@ static void mv_crypto_algo_completion(void)
 	struct ablkcipher_request *req = ablkcipher_request_cast(cpg->cur_req);
 	struct mv_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 
-	sg_miter_stop(&cpg->p.src_sg_it);
-	sg_miter_stop(&cpg->p.dst_sg_it);
-
 	if (req_ctx->op != COP_AES_CBC)
 		return ;
 
@@ -437,7 +434,6 @@ static void mv_hash_algo_completion(void)
 
 	if (ctx->extra_bytes)
 		copy_src_to_buf(&cpg->p, ctx->buffer, ctx->extra_bytes);
-	sg_miter_stop(&cpg->p.src_sg_it);
 
 	if (likely(ctx->last_chunk)) {
 		if (likely(ctx->count <= MAX_HW_HASH_SIZE)) {
@@ -457,7 +453,6 @@ static void dequeue_complete_req(void)
 {
 	struct crypto_async_request *req = cpg->cur_req;
 	void *buf;
-	int ret;
 	cpg->p.hw_processed_bytes += cpg->p.crypt_len;
 	if (cpg->p.copy_back) {
 		int need_copy_len = cpg->p.crypt_len;
@@ -466,14 +461,14 @@ static void dequeue_complete_req(void)
 			int dst_copy;
 
 			if (!cpg->p.sg_dst_left) {
-				ret = sg_miter_next(&cpg->p.dst_sg_it);
-				BUG_ON(!ret);
-				cpg->p.sg_dst_left = cpg->p.dst_sg_it.length;
+				/* next sg please */
+				cpg->p.dst_sg = sg_next(cpg->p.dst_sg);
+				BUG_ON(!cpg->p.dst_sg);
+				cpg->p.sg_dst_left = cpg->p.dst_sg->length;
 				cpg->p.dst_start = 0;
 			}
 
-			buf = cpg->p.dst_sg_it.addr;
-			buf += cpg->p.dst_start;
+			buf = sg_virt(cpg->p.dst_sg) + cpg->p.dst_start;
 
 			dst_copy = min(need_copy_len, cpg->p.sg_dst_left);
 
@@ -523,7 +518,6 @@ static int count_sgs(struct scatterlist *sl, unsigned int total_bytes)
 static void mv_start_new_crypt_req(struct ablkcipher_request *req)
 {
 	struct req_progress *p = &cpg->p;
-	int num_sgs;
 
 	cpg->cur_req = &req->base;
 	memset(p, 0, sizeof(struct req_progress));
@@ -532,11 +526,14 @@ static void mv_start_new_crypt_req(struct ablkcipher_request *req)
 	p->process = mv_process_current_q;
 	p->copy_back = 1;
 
-	num_sgs = count_sgs(req->src, req->nbytes);
-	sg_miter_start(&p->src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);
-
-	num_sgs = count_sgs(req->dst, req->nbytes);
-	sg_miter_start(&p->dst_sg_it, req->dst, num_sgs, SG_MITER_TO_SG);
+	p->src_sg = req->src;
+	p->dst_sg = req->dst;
+	if (req->nbytes) {
+		BUG_ON(!req->src);
+		BUG_ON(!req->dst);
+		p->sg_src_left = req->src->length;
+		p->sg_dst_left = req->dst->length;
+	}
 
 	mv_process_current_q(1);
 }
@@ -545,7 +542,7 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 {
 	struct req_progress *p = &cpg->p;
 	struct mv_req_hash_ctx *ctx = ahash_request_ctx(req);
-	int num_sgs, hw_bytes, old_extra_bytes, rc;
+	int hw_bytes, old_extra_bytes, rc;
 	cpg->cur_req = &req->base;
 	memset(p, 0, sizeof(struct req_progress));
 	hw_bytes = req->nbytes + ctx->extra_bytes;
@@ -558,8 +555,11 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 	else
 		ctx->extra_bytes = 0;
 
-	num_sgs = count_sgs(req->src, req->nbytes);
-	sg_miter_start(&p->src_sg_it, req->src, num_sgs, SG_MITER_FROM_SG);
+	p->src_sg = req->src;
+	if (req->nbytes) {
+		BUG_ON(!req->src);
+		p->sg_src_left = req->src->length;
+	}
 
 	if (hw_bytes) {
 		p->hw_nbytes = hw_bytes;
@@ -576,7 +576,6 @@ static void mv_start_new_hash_req(struct ahash_request *req)
 	} else {
 		copy_src_to_buf(p, ctx->buffer + old_extra_bytes,
 				ctx->extra_bytes - old_extra_bytes);
-		sg_miter_stop(&p->src_sg_it);
 		if (ctx->last_chunk)
 			rc = mv_hash_final_fallback(req);
 		else
-- 
1.7.3.4
