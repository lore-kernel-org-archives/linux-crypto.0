From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] crypto: replace scatterwalk_sg_chain with sg_chain
Date: Fri,  7 Aug 2015 18:15:13 +0200
Message-ID: <1438964116-24321-4-git-send-email-hch@lst.de>
References: <1438964116-24321-1-git-send-email-hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438964116-24321-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[hch: split from a larger patch by Dan]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 crypto/algif_skcipher.c      |  2 +-
 crypto/ccm.c                 |  8 ++++----
 crypto/gcm.c                 |  4 ++--
 drivers/crypto/bfin_crc.c    |  3 +--
 drivers/crypto/qce/sha.c     |  2 +-
 drivers/crypto/sahara.c      |  2 +-
 drivers/crypto/talitos.c     |  2 +-
 include/crypto/scatterwalk.h | 10 +---------
 8 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 9450752..af31a0e 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -145,7 +145,7 @@ static int skcipher_alloc_sgl(struct sock *sk)
 		sgl->cur = 0;
 
 		if (sg)
-			scatterwalk_sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
+			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
 
 		list_add_tail(&sgl->list, &ctx->tsgl);
 	}
diff --git a/crypto/ccm.c b/crypto/ccm.c
index a4d1a5e..b3f52f5 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -329,13 +329,13 @@ static int crypto_ccm_encrypt(struct aead_request *req)
 
 	sg_init_table(pctx->src, 2);
 	sg_set_buf(pctx->src, odata, 16);
-	scatterwalk_sg_chain(pctx->src, 2, req->src);
+	sg_chain(pctx->src, 2, req->src);
 
 	dst = pctx->src;
 	if (req->src != req->dst) {
 		sg_init_table(pctx->dst, 2);
 		sg_set_buf(pctx->dst, odata, 16);
-		scatterwalk_sg_chain(pctx->dst, 2, req->dst);
+		sg_chain(pctx->dst, 2, req->dst);
 		dst = pctx->dst;
 	}
 
@@ -400,13 +400,13 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 
 	sg_init_table(pctx->src, 2);
 	sg_set_buf(pctx->src, authtag, 16);
-	scatterwalk_sg_chain(pctx->src, 2, req->src);
+	sg_chain(pctx->src, 2, req->src);
 
 	dst = pctx->src;
 	if (req->src != req->dst) {
 		sg_init_table(pctx->dst, 2);
 		sg_set_buf(pctx->dst, authtag, 16);
-		scatterwalk_sg_chain(pctx->dst, 2, req->dst);
+		sg_chain(pctx->dst, 2, req->dst);
 		dst = pctx->dst;
 	}
 
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 7d32d47..ab0b2f9 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -200,14 +200,14 @@ static void crypto_gcm_init_common(struct aead_request *req)
 	sg_set_buf(pctx->src, pctx->auth_tag, sizeof(pctx->auth_tag));
 	sg = scatterwalk_ffwd(pctx->src + 1, req->src, req->assoclen);
 	if (sg != pctx->src + 1)
-		scatterwalk_sg_chain(pctx->src, 2, sg);
+		sg_chain(pctx->src, 2, sg);
 
 	if (req->src != req->dst) {
 		sg_init_table(pctx->dst, 3);
 		sg_set_buf(pctx->dst, pctx->auth_tag, sizeof(pctx->auth_tag));
 		sg = scatterwalk_ffwd(pctx->dst + 1, req->dst, req->assoclen);
 		if (sg != pctx->dst + 1)
-			scatterwalk_sg_chain(pctx->dst, 2, sg);
+			sg_chain(pctx->dst, 2, sg);
 	}
 }
 
diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index d9af940..2f0b333 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -370,8 +370,7 @@ static int bfin_crypto_crc_handle_queue(struct bfin_crypto_crc *crc,
 			sg_init_table(ctx->bufsl, nsg);
 			sg_set_buf(ctx->bufsl, ctx->buflast, ctx->buflast_len);
 			if (nsg > 1)
-				scatterwalk_sg_chain(ctx->bufsl, nsg,
-						req->src);
+				sg_chain(ctx->bufsl, nsg, req->src);
 			ctx->sg = ctx->bufsl;
 		} else
 			ctx->sg = req->src;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 5c5df1d..be2f504 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -296,7 +296,7 @@ static int qce_ahash_update(struct ahash_request *req)
 	if (rctx->buflen) {
 		sg_init_table(rctx->sg, 2);
 		sg_set_buf(rctx->sg, rctx->tmpbuf, rctx->buflen);
-		scatterwalk_sg_chain(rctx->sg, 2, req->src);
+		sg_chain(rctx->sg, 2, req->src);
 		req->src = rctx->sg;
 	}
 
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 397a500..a75cf66 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -999,7 +999,7 @@ static int sahara_sha_prepare_request(struct ahash_request *req)
 		sg_init_table(rctx->in_sg_chain, 2);
 		sg_set_buf(rctx->in_sg_chain, rctx->rembuf, rctx->buf_cnt);
 
-		scatterwalk_sg_chain(rctx->in_sg_chain, 2, req->src);
+		sg_chain(rctx->in_sg_chain, 2, req->src);
 
 		rctx->total = req->nbytes + rctx->buf_cnt;
 		rctx->in_sg = rctx->in_sg_chain;
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 83aca95..6a7f024 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1986,7 +1986,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, req_ctx->buf, req_ctx->nbuf);
 		if (nsg > 1)
-			scatterwalk_sg_chain(req_ctx->bufsl, 2, areq->src);
+			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else
 		req_ctx->psrc = areq->src;
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 96670e7..35f99b6 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -25,14 +25,6 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 
-static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
-					struct scatterlist *sg2)
-{
-	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
-	sg1[num - 1].page_link &= ~0x02;
-	sg1[num - 1].page_link |= 0x01;
-}
-
 static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 					    struct scatterlist *sg,
 					    int chain, int num)
@@ -43,7 +35,7 @@ static inline void scatterwalk_crypto_chain(struct scatterlist *head,
 	}
 
 	if (sg)
-		scatterwalk_sg_chain(head, num, sg);
+		sg_chain(head, num, sg);
 	else
 		sg_mark_end(head);
 }
-- 
1.9.1
