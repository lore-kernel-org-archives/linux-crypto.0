From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/7] crypto: qce: check return value of sg_nents_for_len
Date: Wed,  4 Nov 2015 21:13:36 +0100
Message-ID: <1446668045-8620-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: axboe@fb.com, clabbe.montjoie@gmail.com,
	cristian.stoica@freescale.com, dan.j.williams@intel.com,
	davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sg_nents_for_len() function could fail, this patch add a check for
its return value.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/qce/ablkcipher.c | 8 ++++++++
 drivers/crypto/qce/sha.c        | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 2c0d63d..dbcbbe2 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -83,6 +83,14 @@ qce_ablkcipher_async_req_handle(struct crypto_async_request *async_req)
 		rctx->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
 	else
 		rctx->dst_nents = rctx->src_nents;
+	if (rctx->src_nents < 0) {
+		dev_err(qce->dev, "Invalid numbers of src SG.\n");
+		return rctx->src_nents;
+	}
+	if (rctx->dst_nents < 0) {
+		dev_err(qce->dev, "Invalid numbers of dst SG.\n");
+		return -rctx->dst_nents;
+	}
 
 	rctx->dst_nents += 1;
 
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 0c9973e..47e114a 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -92,6 +92,11 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 	}
 
 	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (rctx->src_nents < 0) {
+		dev_err(qce->dev, "Invalid numbers of src SG.\n");
+		return rctx->src_nents;
+	}
+
 	ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
 	if (ret < 0)
 		return ret;
-- 
2.4.10
