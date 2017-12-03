From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 03/10] staging: ccree: remove more unnecessary parentheses
Date: Sun,  3 Dec 2017 13:58:14 +0000
Message-ID: <1512309503-29766-4-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
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

The removal of likely/unlikely unearthed some more
unnecessary parentheses. Remove them for better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c  | 4 ++--
 drivers/staging/ccree/ssi_driver.c      | 6 +++---
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 7ceee91..bac9d12 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -882,7 +882,7 @@ static int cc_aead_chain_assoc(
 	else
 		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
 
-	if ((do_chain) || areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) {
+	if (do_chain || areq_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI) {
 		dev_dbg(dev, "Chain assoc: buff_type=%s nents=%u\n",
 			cc_dma_buf_type(areq_ctx->assoc_buff_type),
 			areq_ctx->assoc.nents);
@@ -1656,7 +1656,7 @@ void cc_unmap_hash_request(struct device *dev, void *ctx,
 			      areq_ctx->mlli_params.mlli_dma_addr);
 	}
 
-	if ((src) && areq_ctx->in_nents) {
+	if (src && areq_ctx->in_nents) {
 		dev_dbg(dev, "Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
 			sg_virt(src), &sg_dma_address(src), sg_dma_len(src));
 		dma_unmap_sg(dev, src,
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 6282c37..0b2593f 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -111,7 +111,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 
 	drvdata->irq = irr;
 	/* Completion interrupt - most probable */
-	if ((irr & SSI_COMP_IRQ_MASK)) {
+	if (irr & SSI_COMP_IRQ_MASK) {
 		/* Mask AXI completion interrupt - will be unmasked in
 		 * Deferred service handler
 		 */
@@ -121,7 +121,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	}
 #ifdef CC_SUPPORT_FIPS
 	/* TEE FIPS interrupt */
-	if ((irr & SSI_GPR0_IRQ_MASK)) {
+	if (irr & SSI_GPR0_IRQ_MASK) {
 		/* Mask interrupt - will be unmasked in Deferred service
 		 * handler
 		 */
@@ -131,7 +131,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	}
 #endif
 	/* AXI error interrupt */
-	if ((irr & SSI_AXI_ERR_IRQ_MASK)) {
+	if (irr & SSI_AXI_ERR_IRQ_MASK) {
 		u32 axi_err;
 
 		/* Read the AXI error ID */
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 7a653f6..e890cb6 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -221,7 +221,7 @@ static int request_mgr_queues_status_check(
 		return -EBUSY;
 	}
 
-	if ((req_mgr_h->q_free_slots >= total_seq_len))
+	if (req_mgr_h->q_free_slots >= total_seq_len)
 		return 0;
 
 	/* Wait for space in HW queue. Poll constant num of iterations. */
-- 
2.7.4
