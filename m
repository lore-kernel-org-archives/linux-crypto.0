Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50746 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfAONnl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 08:43:41 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Hadar Gat <hadar.gat@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] crypto: ccree: fix free of unallocated mlli buffer
Date: Tue, 15 Jan 2019 15:43:13 +0200
Message-Id: <20190115134318.28712-4-gilad@benyossef.com>
In-Reply-To: <20190115134318.28712-1-gilad@benyossef.com>
References: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Hadar Gat <hadar.gat@arm.com>

In cc_unmap_aead_request(), call dma_pool_free() for mlli buffer only
if an item is allocated from the pool and not always if there is a
pool allocated.
This fixes a kernel panic when trying to free a non-allocated item.

Cc: stable@vger.kernel.org
Signed-off-by: Hadar Gat <hadar.gat@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_buffer_mgr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 237a87a57830..0ee1c52da0a4 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -614,10 +614,10 @@ void cc_unmap_aead_request(struct device *dev, struct aead_request *req)
 				 hw_iv_size, DMA_BIDIRECTIONAL);
 	}
 
-	/*In case a pool was set, a table was
-	 *allocated and should be released
-	 */
-	if (areq_ctx->mlli_params.curr_pool) {
+	/* Release pool */
+	if ((areq_ctx->assoc_buff_type == CC_DMA_BUF_MLLI ||
+	     areq_ctx->data_buff_type == CC_DMA_BUF_MLLI) &&
+	    (areq_ctx->mlli_params.mlli_virt_addr)) {
 		dev_dbg(dev, "free MLLI buffer: dma=%pad virt=%pK\n",
 			&areq_ctx->mlli_params.mlli_dma_addr,
 			areq_ctx->mlli_params.mlli_virt_addr);
-- 
2.20.1
