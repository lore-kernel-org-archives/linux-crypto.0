From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] crypto/omap-sham: remove an open coded access to ->page_link
Date: Fri,  7 Aug 2015 18:15:15 +0200
Message-ID: <1438964116-24321-6-git-send-email-hch@lst.de>
References: <1438964116-24321-1-git-send-email-hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438964116-24321-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[hch: split from a larger patch by Dan]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index b2024c95..48adb2a 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -588,7 +588,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
 		 * the dmaengine may try to DMA the incorrect amount of data.
 		 */
 		sg_init_table(&ctx->sgl, 1);
-		ctx->sgl.page_link = ctx->sg->page_link;
+		sg_assign_page(&ctx->sgl, sg_page(ctx->sg));
 		ctx->sgl.offset = ctx->sg->offset;
 		sg_dma_len(&ctx->sgl) = len32;
 		sg_dma_address(&ctx->sgl) = sg_dma_address(ctx->sg);
-- 
1.9.1
