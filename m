From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: chcr - Replace _manual_ swap with swap macro
Date: Fri, 3 Nov 2017 11:58:23 -0500
Message-ID: <20171103165823.GA16842@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Make use of the swap macro and remove unnecessary variable temp.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 936bdd8..4b508cb 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1469,11 +1469,8 @@ static int chcr_ahash_update(struct ahash_request *req)
 		return -ENOMEM;
 
 	if (remainder) {
-		u8 *temp;
 		/* Swap buffers */
-		temp = req_ctx->reqbfr;
-		req_ctx->reqbfr = req_ctx->skbfr;
-		req_ctx->skbfr = temp;
+		swap(req_ctx->reqbfr, req_ctx->skbfr);
 		sg_pcopy_to_buffer(req->src, sg_nents(req->src),
 				   req_ctx->reqbfr, remainder, req->nbytes -
 				   remainder);
-- 
2.7.4
