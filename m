From: Qiang Liu <qiang.liu@freescale.com>
Subject: [PATCH v2 3/4] fsl-dma: change the release process of dma descriptor
Date: Wed, 11 Jul 2012 17:01:25 +0800
Message-ID: <1341997285-18459-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Li Yang <leoli@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:24593
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab2GKJWp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 05:22:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Modify the release process of dma descriptor for avoiding exception when
enable config NET_DMA, release dma descriptor from 1st to last second, the
last descriptor which is reserved in current descriptor register may not be
completed, race condition will be raised if free current descriptor.

A race condition which is raised when use both of talitos and dmaengine to
offload xor is because napi scheduler (NET_DMA is enabled) will sync all
pending requests in dma channels, it affects the process of raid operations.
The descriptor is freed which is submitted just now, but async_tx must check
whether this depend tx descriptor is acked, there are poison contents in the
invalid address, then BUG_ON() is thrown, so this descriptor will be freed
in the next time.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4f2f212..0ba3e40 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1035,14 +1035,22 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 static void dma_do_tasklet(unsigned long data)
 {
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
-	struct fsl_desc_sw *desc, *_desc;
+	struct fsl_desc_sw *desc, *_desc, *prev = NULL;
 	LIST_HEAD(ld_cleanup);
 	unsigned long flags;
+	dma_addr_t curr_phys = get_cdar(chan);

 	chan_dbg(chan, "tasklet entry\n");

 	spin_lock_irqsave(&chan->desc_lock, flags);

+	/* find the descriptor which is already completed */
+	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
+		if (prev && desc->async_tx.phys == curr_phys)
+			break;
+		prev = desc;
+	}
+
 	/* update the cookie if we have some descriptors to cleanup */
 	if (!list_empty(&chan->ld_running)) {
 		dma_cookie_t cookie;
@@ -1058,13 +1066,14 @@ static void dma_do_tasklet(unsigned long data)
 	 * move the descriptors to a temporary list so we can drop the lock
 	 * during the entire cleanup operation
 	 */
-	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
+	list_cut_position(&ld_cleanup, &chan->ld_running, &prev->node);

 	/* the hardware is now idle and ready for more */
 	chan->idle = true;

 	/*
-	 * Start any pending transactions automatically
+	 * Start any pending transactions automatically if current descriptor
+	 * list is completed
 	 *
 	 * In the ideal case, we keep the DMA controller busy while we go
 	 * ahead and free the descriptors below.
--
1.7.5.1
