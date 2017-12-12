From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 21/24] staging: ccree: fix buf mgr naming convention
Date: Tue, 12 Dec 2017 14:53:07 +0000
Message-ID: <1513090395-7938-22-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

The buffer manager files were using a func naming convention which was
inconsistent (ssi vs. cc) and often too long.

Make the code more readable by switching to a simpler, consistent naming
convention.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 8649bcb..6846d93 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -413,11 +413,9 @@ static int cc_map_sg(struct device *dev, struct scatterlist *sg,
 }
 
 static int
-ssi_aead_handle_config_buf(struct device *dev,
-			   struct aead_req_ctx *areq_ctx,
-			   u8 *config_data,
-			   struct buffer_array *sg_data,
-			   unsigned int assoclen)
+cc_set_aead_conf_buf(struct device *dev, struct aead_req_ctx *areq_ctx,
+		     u8 *config_data, struct buffer_array *sg_data,
+		     unsigned int assoclen)
 {
 	dev_dbg(dev, " handle additional data config set to DLLI\n");
 	/* create sg for the current buffer */
@@ -441,10 +439,9 @@ ssi_aead_handle_config_buf(struct device *dev,
 	return 0;
 }
 
-static int ssi_ahash_handle_curr_buf(struct device *dev,
-				     struct ahash_req_ctx *areq_ctx,
-				     u8 *curr_buff, u32 curr_buff_cnt,
-				     struct buffer_array *sg_data)
+static int cc_set_hash_buf(struct device *dev, struct ahash_req_ctx *areq_ctx,
+			   u8 *curr_buff, u32 curr_buff_cnt,
+			   struct buffer_array *sg_data)
 {
 	dev_dbg(dev, " handle curr buff %x set to   DLLI\n", curr_buff_cnt);
 	/* create sg for the current buffer */
@@ -1259,9 +1256,8 @@ int cc_map_aead_request(struct cc_drvdata *drvdata, struct aead_request *req)
 		}
 		areq_ctx->ccm_iv0_dma_addr = dma_addr;
 
-		if (ssi_aead_handle_config_buf(dev, areq_ctx,
-					       areq_ctx->ccm_config, &sg_data,
-					       req->assoclen)) {
+		if (cc_set_aead_conf_buf(dev, areq_ctx, areq_ctx->ccm_config,
+					 &sg_data, req->assoclen)) {
 			rc = -ENOMEM;
 			goto aead_map_failure;
 		}
@@ -1432,8 +1428,8 @@ int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 	/*TODO: copy data in case that buffer is enough for operation */
 	/* map the previous buffer */
 	if (*curr_buff_cnt) {
-		if (ssi_ahash_handle_curr_buf(dev, areq_ctx, curr_buff,
-					      *curr_buff_cnt, &sg_data)) {
+		if (cc_set_hash_buf(dev, areq_ctx, curr_buff, *curr_buff_cnt,
+				    &sg_data)) {
 			return -ENOMEM;
 		}
 	}
@@ -1545,8 +1541,8 @@ int cc_map_hash_request_update(struct cc_drvdata *drvdata, void *ctx,
 	}
 
 	if (*curr_buff_cnt) {
-		if (ssi_ahash_handle_curr_buf(dev, areq_ctx, curr_buff,
-					      *curr_buff_cnt, &sg_data)) {
+		if (cc_set_hash_buf(dev, areq_ctx, curr_buff, *curr_buff_cnt,
+				    &sg_data)) {
 			return -ENOMEM;
 		}
 		/* change the buffer index for next operation */
-- 
2.7.4
