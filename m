From: Iaroslav Gridin <voker57@gmail.com>
Subject: [PATCH 3/4] crypto: qce: Ensure QCE receives no zero-sized updates
Date: Tue, 30 Aug 2016 18:53:52 +0300
Message-ID: <20160830155353.19500-4-voker57@gmail.com>
References: <20160830155353.19500-1-voker57@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.gross@linaro.org,
        david.brown@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, Voker57 <voker57@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33517 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756788AbcH3PyW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2016 11:54:22 -0400
In-Reply-To: <20160830155353.19500-1-voker57@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Voker57 <voker57@gmail.com>

Zero-sized updates lock QCE, so ensure there's always some data left
for the final update, up to blocksize.
Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
---
 drivers/crypto/qce/sha.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index a068d39..f199f28 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -240,9 +240,11 @@ static int qce_ahash_update(struct ahash_request *req)
 	struct qce_device *qce = tmpl->qce;
 	struct scatterlist *sg_last, *sg;
 	unsigned int total, len;
+	unsigned int tmpbuflen = 0;
 	unsigned int hash_later;
 	unsigned int nbytes;
 	unsigned int blocksize;
+	unsigned int src_offset;
 
 	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	rctx->count += req->nbytes;
@@ -265,21 +267,30 @@ static int qce_ahash_update(struct ahash_request *req)
 	 * if we have data from previous update copy them on buffer. The old
 	 * data will be combined with current request bytes.
 	 */
-	if (rctx->buflen)
+	if (rctx->buflen) {
 		memcpy(rctx->tmpbuf, rctx->buf, rctx->buflen);
+		tmpbuflen = rctx->buflen;
+	}
 
 	/* calculate how many bytes will be hashed later */
 	hash_later = total % blocksize;
-	if (hash_later) {
-		unsigned int src_offset = req->nbytes - hash_later;
-		scatterwalk_map_and_copy(rctx->buf, req->src, src_offset,
-					 hash_later, 0);
-	}
+	/* ensure we always have something on buffer */
+	if (hash_later == 0)
+		hash_later = blocksize;
+	src_offset = req->nbytes - hash_later;
+	scatterwalk_map_and_copy(rctx->buf, req->src, src_offset,
+				 hash_later, 0);
+	rctx->buflen = hash_later;
 
 	/* here nbytes is multiple of blocksize */
 	nbytes = total - hash_later;
 
-	len = rctx->buflen;
+	len = tmpbuflen;
+
+	/* Zero-length update is a no-op */
+	if (nbytes == 0)
+		return 0;
+
 	sg = sg_last = req->src;
 
 	while (len < nbytes && sg) {
@@ -293,15 +304,14 @@ static int qce_ahash_update(struct ahash_request *req)
 
 	sg_mark_end(sg_last);
 
-	if (rctx->buflen) {
+	if (tmpbuflen) {
 		sg_init_table(rctx->sg, 2);
-		sg_set_buf(rctx->sg, rctx->tmpbuf, rctx->buflen);
+		sg_set_buf(rctx->sg, rctx->tmpbuf, tmpbuflen);
 		sg_chain(rctx->sg, 2, req->src);
 		req->src = rctx->sg;
 	}
 
 	req->nbytes = nbytes;
-	rctx->buflen = hash_later;
 
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
-- 
2.9.3
