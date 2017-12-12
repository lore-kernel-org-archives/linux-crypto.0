From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 07/24] staging: ccree: simplify expression with local var
Date: Tue, 12 Dec 2017 14:52:53 +0000
Message-ID: <1513090395-7938-8-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Simplify expression by using a local variable for better code
readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 099d83d..490dd5a 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -917,6 +917,7 @@ static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
 	unsigned int authsize = areq_ctx->req_authsize;
 	int rc = 0, icv_nents;
 	struct device *dev = drvdata_to_dev(drvdata);
+	struct scatterlist *sg;
 
 	if (req->src == req->dst) {
 		/*INPLACE*/
@@ -955,12 +956,11 @@ static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
 					areq_ctx->mac_buf_dma_addr;
 			}
 		} else { /* Contig. ICV */
+			sg = &areq_ctx->src_sgl[areq_ctx->src.nents - 1];
 			/*Should hanlde if the sg is not contig.*/
-			areq_ctx->icv_dma_addr = sg_dma_address(
-				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
+			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
 				(*src_last_bytes - authsize);
-			areq_ctx->icv_virt_addr = sg_virt(
-				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
+			areq_ctx->icv_virt_addr = sg_virt(sg) +
 				(*src_last_bytes - authsize);
 		}
 
@@ -993,12 +993,11 @@ static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
 			areq_ctx->icv_virt_addr = areq_ctx->backup_mac;
 
 		} else { /* Contig. ICV */
+			sg = &areq_ctx->src_sgl[areq_ctx->src.nents - 1];
 			/*Should hanlde if the sg is not contig.*/
-			areq_ctx->icv_dma_addr = sg_dma_address(
-				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
+			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
 				(*src_last_bytes - authsize);
-			areq_ctx->icv_virt_addr = sg_virt(
-				&areq_ctx->src_sgl[areq_ctx->src.nents - 1]) +
+			areq_ctx->icv_virt_addr = sg_virt(sg) +
 				(*src_last_bytes - authsize);
 		}
 
@@ -1023,12 +1022,11 @@ static int cc_prepare_aead_data_mlli(struct ssi_drvdata *drvdata,
 		}
 
 		if (!areq_ctx->is_icv_fragmented) {
+			sg = &areq_ctx->dst_sgl[areq_ctx->dst.nents - 1];
 			/* Contig. ICV */
-			areq_ctx->icv_dma_addr = sg_dma_address(
-				&areq_ctx->dst_sgl[areq_ctx->dst.nents - 1]) +
+			areq_ctx->icv_dma_addr = sg_dma_address(sg) +
 				(*dst_last_bytes - authsize);
-			areq_ctx->icv_virt_addr = sg_virt(
-				&areq_ctx->dst_sgl[areq_ctx->dst.nents - 1]) +
+			areq_ctx->icv_virt_addr = sg_virt(sg) +
 				(*dst_last_bytes - authsize);
 		} else {
 			areq_ctx->icv_dma_addr = areq_ctx->mac_buf_dma_addr;
-- 
2.7.4
