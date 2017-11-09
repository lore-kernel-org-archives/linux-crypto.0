From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] crypto: chelsio - Fix an error code in chcr_hash_dma_map()
Date: Fri, 10 Nov 2017 00:25:43 +0300
Message-ID: <20171109212543.6dpgzvtbhi4574wr@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27936 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbdKIV0E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 16:26:04 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The dma_map_sg() function returns zero on error and positive values on
success.  We want to return -ENOMEM on failure here and zero on success.

Fixes: 2f47d5804311 ("crypto: chelsio - Move DMA un/mapping to chcr from lld cxgb4 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 4eed7171e2ae..38fe59b5c689 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2414,7 +2414,7 @@ static inline int chcr_hash_dma_map(struct device *dev,
 	error = dma_map_sg(dev, req->src, sg_nents(req->src),
 			   DMA_TO_DEVICE);
 	if (!error)
-		return error;
+		return -ENOMEM;
 	req_ctx->is_sg_map = 1;
 	return 0;
 }
