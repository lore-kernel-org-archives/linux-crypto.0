From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: chcr - checking for IS_ERR() instead of NULL
Date: Thu, 1 Dec 2016 23:49:37 +0300
Message-ID: <20161201204937.GA10701@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Harsh Jain <harsh@chelsio.com>,
        Jitendra Lulla <JLULLA@chelsio.com>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19047 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757877AbcLAUuE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 15:50:04 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The create_hash_wr() function never returns error pointers.  It returns
NULL on error.

Fixes: 358961d1cd1e ("crypto: chcr - Added new structure chcr_wr")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 32361dd..2ed1e24 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -958,9 +958,8 @@ static int chcr_ahash_update(struct ahash_request *req)
 	req_ctx->result = 0;
 	req_ctx->data_len += params.sg_len + params.bfr_len;
 	skb = create_hash_wr(req, &params);
-
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	if (!skb)
+		return -ENOMEM;
 
 	if (remainder) {
 		u8 *temp;
@@ -1023,8 +1022,8 @@ static int chcr_ahash_final(struct ahash_request *req)
 		params.more = 0;
 	}
 	skb = create_hash_wr(req, &params);
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	if (!skb)
+		return -ENOMEM;
 
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
@@ -1074,8 +1073,8 @@ static int chcr_ahash_finup(struct ahash_request *req)
 	}
 
 	skb = create_hash_wr(req, &params);
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	if (!skb)
+		return -ENOMEM;
 
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
@@ -1125,8 +1124,8 @@ static int chcr_ahash_digest(struct ahash_request *req)
 	}
 
 	skb = create_hash_wr(req, &params);
-	if (IS_ERR(skb))
-		return PTR_ERR(skb);
+	if (!skb)
+		return -ENOMEM;
 
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
