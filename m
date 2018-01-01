From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 13/26] staging: ccree: check DMA pool buf !NULL  before free
Date: Mon,  1 Jan 2018 12:06:40 +0000
Message-ID: <1514808421-21993-14-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
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
index 795f403..33b9709 100644
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
