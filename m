From: Anup Patel <anup.patel@broadcom.com>
Subject: [PATCH 3/6] async_tx: Handle DMA devices having support for fewer PQ coefficients
Date: Thu,  2 Feb 2017 10:17:13 +0530
Message-ID: <1486010836-25228-4-git-send-email-anup.patel@broadcom.com>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-raid@vger.kernel.org, Anup Patel <anup.patel@broadcom.com>
To: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36407 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdBBEsY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 23:48:24 -0500
Received: by mail-qt0-f169.google.com with SMTP id k15so9742597qtg.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 20:48:24 -0800 (PST)
In-Reply-To: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The DMAENGINE framework assumes that if PQ offload is supported by a
DMA device then all 256 PQ coefficients are supported. This assumption
does not hold anymore because we now have BCM-SBA-RAID offload engine
which supports PQ offload with limited number of PQ coefficients.

This patch extends async_tx APIs to handle DMA devices with support
for fewer PQ coefficients.

Signed-off-by: Anup Patel <anup.patel@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
---
 crypto/async_tx/async_pq.c          |  3 +++
 crypto/async_tx/async_raid6_recov.c | 12 ++++++++++--
 include/linux/dmaengine.h           | 19 +++++++++++++++++++
 include/linux/raid/pq.h             |  3 +++
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index f83de99..16c6526 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -187,6 +187,9 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 
 	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
 
+	if (device && dma_maxpqcoef(device) < src_cnt)
+		device = NULL;
+
 	if (device)
 		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOWAIT);
 
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 8fab627..2916f95 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -352,6 +352,7 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 {
 	void *scribble = submit->scribble;
 	int non_zero_srcs, i;
+	struct dma_chan *chan = async_dma_find_channel(DMA_PQ);
 
 	BUG_ON(faila == failb);
 	if (failb < faila)
@@ -359,12 +360,15 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
 
+	if (chan && dma_maxpqcoef(chan->device) < RAID6_PQ_MAX_COEF)
+		chan = NULL;
+
 	/* if a dma resource is not available or a scribble buffer is not
 	 * available punt to the synchronous path.  In the 'dma not
 	 * available' case be sure to use the scribble buffer to
 	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
+	if (!chan || !scribble) {
 		void **ptrs = scribble ? scribble : (void **) blocks;
 
 		async_tx_quiesce(&submit->depend_tx);
@@ -432,15 +436,19 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	void *scribble = submit->scribble;
 	int good_srcs, good, i;
 	struct page *srcs[2];
+	struct dma_chan *chan = async_dma_find_channel(DMA_PQ);
 
 	pr_debug("%s: disks: %d len: %zu\n", __func__, disks, bytes);
 
+	if (chan && dma_maxpqcoef(chan->device) < RAID6_PQ_MAX_COEF)
+		chan = NULL;
+
 	/* if a dma resource is not available or a scribble buffer is not
 	 * available punt to the synchronous path.  In the 'dma not
 	 * available' case be sure to use the scribble buffer to
 	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
+	if (!chan || !scribble) {
 		void **ptrs = scribble ? scribble : (void **) blocks;
 
 		async_tx_quiesce(&submit->depend_tx);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index feee6ec..d938a8b 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -24,6 +24,7 @@
 #include <linux/scatterlist.h>
 #include <linux/bitmap.h>
 #include <linux/types.h>
+#include <linux/raid/pq.h>
 #include <asm/page.h>
 
 /**
@@ -668,6 +669,7 @@ struct dma_filter {
  * @cap_mask: one or more dma_capability flags
  * @max_xor: maximum number of xor sources, 0 if no capability
  * @max_pq: maximum number of PQ sources and PQ-continue capability
+ * @max_pqcoef: maximum number of PQ coefficients, 0 if all supported
  * @copy_align: alignment shift for memcpy operations
  * @xor_align: alignment shift for xor operations
  * @pq_align: alignment shift for pq operations
@@ -727,11 +729,13 @@ struct dma_device {
 	dma_cap_mask_t  cap_mask;
 	unsigned short max_xor;
 	unsigned short max_pq;
+	unsigned short max_pqcoef;
 	enum dmaengine_alignment copy_align;
 	enum dmaengine_alignment xor_align;
 	enum dmaengine_alignment pq_align;
 	enum dmaengine_alignment fill_align;
 	#define DMA_HAS_PQ_CONTINUE (1 << 15)
+	#define DMA_HAS_FEWER_PQ_COEF (1 << 15)
 
 	int dev_id;
 	struct device *dev;
@@ -1122,6 +1126,21 @@ static inline int dma_maxpq(struct dma_device *dma, enum dma_ctrl_flags flags)
 	BUG();
 }
 
+static inline void dma_set_maxpqcoef(struct dma_device *dma,
+				     unsigned short max_pqcoef)
+{
+	if (max_pqcoef < RAID6_PQ_MAX_COEF) {
+		dma->max_pqcoef = max_pqcoef;
+		dma->max_pqcoef |= DMA_HAS_FEWER_PQ_COEF;
+	}
+}
+
+static inline unsigned short dma_maxpqcoef(struct dma_device *dma)
+{
+	return (dma->max_pqcoef & DMA_HAS_FEWER_PQ_COEF) ?
+		(dma->max_pqcoef & ~DMA_HAS_FEWER_PQ_COEF) : RAID6_PQ_MAX_COEF;
+}
+
 static inline size_t dmaengine_get_icg(bool inc, bool sgl, size_t icg,
 				      size_t dir_icg)
 {
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 30f9453..f3a04bb 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -15,6 +15,9 @@
 
 #ifdef __KERNEL__
 
+/* Max number of PQ coefficients */
+#define RAID6_PQ_MAX_COEF 256
+
 /* Set to 1 to use kernel-wide empty_zero_page */
 #define RAID6_USE_EMPTY_ZERO_PAGE 0
 #include <linux/blkdev.h>
-- 
2.7.4
