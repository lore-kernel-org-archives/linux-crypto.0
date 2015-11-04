From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 6/7] crypto: caam: check return value of sg_nents_for_len
Date: Wed,  4 Nov 2015 21:13:38 +0100
Message-ID: <1446668045-8620-6-git-send-email-clabbe.montjoie@gmail.com>
References: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: clabbe.montjoie@gmail.com, davem@davemloft.net,
	herbert@gondor.apana.org.au, horia.geanta@freescale.com,
	steve.cornelius@freescale.com, vicki.milhoan@freescale.com,
	yanjiang.jin@windriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446668045-8620-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The sg_nents_for_len() function could fail, this patch add a check for
its return value.
We do the same for sg_count since it use sg_nents_for_len().

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/caam/caamhash.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 9609f66..b894ce3 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -794,6 +794,10 @@ static int ahash_update_ctx(struct ahash_request *req)
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - (*next_buflen));
+		if (src_nents < 0) {
+			dev_err(jrdev, "Invalid number of src SG.\n");
+			return src_nents;
+		}
 		sec4_sg_src_index = 1 + (*buflen ? 1 : 0);
 		sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 				 sizeof(struct sec4_sg_entry);
@@ -993,6 +997,10 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int sh_len;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (src_nents < 0) {
+		dev_err(jrdev, "Invalid number of src SG.\n");
+		return src_nents;
+	}
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
 	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 			 sizeof(struct sec4_sg_entry);
@@ -1077,6 +1085,10 @@ static int ahash_digest(struct ahash_request *req)
 	int sh_len;
 
 	src_nents = sg_count(req->src, req->nbytes);
+	if (src_nents < 0) {
+		dev_err(jrdev, "Invalid number of src SG.\n");
+		return src_nents;
+	}
 	dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
 	sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
 
@@ -1225,6 +1237,10 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - (*next_buflen));
+		if (src_nents < 0) {
+			dev_err(jrdev, "Invalid number of src SG.\n");
+			return src_nents;
+		}
 		sec4_sg_bytes = (1 + src_nents) *
 				sizeof(struct sec4_sg_entry);
 
@@ -1333,6 +1349,10 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int ret = 0;
 
 	src_nents = sg_nents_for_len(req->src, req->nbytes);
+	if (src_nents < 0) {
+		dev_err(jrdev, "Invalid number of src SG.\n");
+		return src_nents;
+	}
 	sec4_sg_src_index = 2;
 	sec4_sg_bytes = (sec4_sg_src_index + src_nents) *
 			 sizeof(struct sec4_sg_entry);
@@ -1421,6 +1441,10 @@ static int ahash_update_first(struct ahash_request *req)
 
 	if (to_hash) {
 		src_nents = sg_count(req->src, req->nbytes - (*next_buflen));
+		if (src_nents < 0) {
+			dev_err(jrdev, "Invalid number of src SG.\n");
+			return src_nents;
+		}
 		dma_map_sg(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE);
 		sec4_sg_bytes = src_nents * sizeof(struct sec4_sg_entry);
 
-- 
2.4.10
