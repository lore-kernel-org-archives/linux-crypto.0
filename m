From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 05/24] staging: ccree: move logical cont. to 1st line
Date: Mon, 13 Nov 2017 14:45:33 +0000
Message-ID: <1510584358-29473-6-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
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

Move logical continuations to first line for readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 923a0df..cda5a30 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1473,8 +1473,8 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 				       &dummy, &mapped_nents))) {
 			goto unmap_curr_buff;
 		}
-		if (src && mapped_nents == 1
-		     && areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
+		if (src && mapped_nents == 1 &&
+		    areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
 			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
 			areq_ctx->buff_sg->length = nbytes;
@@ -1590,8 +1590,8 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 				       &mapped_nents))) {
 			goto unmap_curr_buff;
 		}
-		if (mapped_nents == 1
-		     && areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
+		if (mapped_nents == 1 &&
+		    areq_ctx->data_dma_buf_type == SSI_DMA_BUF_NULL) {
 			/* only one entry in the SG and no previous data */
 			memcpy(areq_ctx->buff_sg, src,
 			       sizeof(struct scatterlist));
-- 
2.7.4
