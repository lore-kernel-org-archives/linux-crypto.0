From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 13/27] staging: ccree: check DMA pool buf !NULL  before free
Date: Sun,  7 Jan 2018 12:14:24 +0000
Message-ID: <1515327285-8948-14-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If we ran out of DMA pool buffers, we get into the unmap
code path with a NULL before. Deal with this by checking
the virtual mapping is not NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index e85bb53..78288ed 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -465,7 +465,8 @@ void cc_unmap_blkcipher_request(struct device *dev, void *ctx,
 				 DMA_TO_DEVICE);
 	}
 	/* Release pool */
-	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI) {
+	if (req_ctx->dma_buf_type == CC_DMA_BUF_MLLI &&
+	    req_ctx->mlli_params.mlli_virt_addr) {
 		dma_pool_free(req_ctx->mlli_params.curr_pool,
 			      req_ctx->mlli_params.mlli_virt_addr,
 			      req_ctx->mlli_params.mlli_dma_addr);
-- 
2.7.4
