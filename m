From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/6] crypto-caamhash: Move common error handling code in two
 functions
Date: Thu, 15 Sep 2016 16:45:29 +0200
Message-ID: <baa5db91-27e7-ecab-f2c9-29e549b6e5f0@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 15 Sep 2016 16:00:55 +0200

Move statements for error handling which were identical
in two if branches to the end of these functions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/caam/caamhash.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index adb8b19..660dc20 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1231,9 +1231,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
 		dev_err(jrdev, "unable to map src\n");
-		ahash_unmap(jrdev, edesc, req, digestsize);
-		kfree(edesc);
-		return -ENOMEM;
+		goto unmap;
 	}
 
 	append_seq_in_ptr(desc, state->buf_dma, buflen, 0);
@@ -1242,9 +1240,7 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
-		ahash_unmap(jrdev, edesc, req, digestsize);
-		kfree(edesc);
-		return -ENOMEM;
+		goto unmap;
 	}
 	edesc->src_nents = 0;
 
@@ -1262,6 +1258,11 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	}
 
 	return ret;
+ unmap:
+	ahash_unmap(jrdev, edesc, req, digestsize);
+	kfree(edesc);
+	return -ENOMEM;
+
 }
 
 /* submit ahash update if it the first job descriptor after update */
@@ -1453,18 +1454,14 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 				  req->nbytes);
 	if (ret) {
 		dev_err(jrdev, "unable to map S/G table\n");
-		ahash_unmap(jrdev, edesc, req, digestsize);
-		kfree(edesc);
-		return -ENOMEM;
+		goto unmap;
 	}
 
 	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
-		ahash_unmap(jrdev, edesc, req, digestsize);
-		kfree(edesc);
-		return -ENOMEM;
+		goto unmap;
 	}
 
 #ifdef DEBUG
@@ -1481,6 +1478,11 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	}
 
 	return ret;
+ unmap:
+	ahash_unmap(jrdev, edesc, req, digestsize);
+	kfree(edesc);
+	return -ENOMEM;
+
 }
 
 /* submit first update job descriptor after init */
-- 
2.10.0
