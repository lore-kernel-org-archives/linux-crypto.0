From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 3/7] fsl-dma: add fsl_dma_free_descriptor() to reduce code duplication
Date: Tue, 31 Jul 2012 16:45:48 -0700
Message-ID: <1343778352-5549-4-git-send-email-iws@ovro.caltech.edu>
References: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, B32616@freescale.com,
	"Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:59622 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2GaXp5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 19:45:57 -0400
In-Reply-To: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Ira W. Snyder" <iws@ovro.caltech.edu>

There are several places where descriptors are freed using identical
code. Put this code into a function to reduce code duplication.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8f0505d..c34a628 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -400,6 +400,15 @@ out_splice:
 	list_splice_tail_init(&desc->tx_list, &chan->ld_pending);
 }
 
+static void fsl_dma_free_descriptor(struct fsldma_chan *chan, struct fsl_desc_sw *desc)
+{
+	list_del(&desc->node);
+#ifdef FSL_DMA_LD_DEBUG
+	chan_dbg(chan, "LD %p free\n", desc);
+#endif
+	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
+}
+
 static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
@@ -499,13 +508,8 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
 {
 	struct fsl_desc_sw *desc, *_desc;
 
-	list_for_each_entry_safe(desc, _desc, list, node) {
-		list_del(&desc->node);
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p free\n", desc);
-#endif
-		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
-	}
+	list_for_each_entry_safe(desc, _desc, list, node)
+		fsl_dma_free_descriptor(chan, desc);
 }
 
 static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
@@ -513,13 +517,8 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 {
 	struct fsl_desc_sw *desc, *_desc;
 
-	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
-		list_del(&desc->node);
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p free\n", desc);
-#endif
-		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
-	}
+	list_for_each_entry_safe_reverse(desc, _desc, list, node)
+		fsl_dma_free_descriptor(chan, desc);
 }
 
 /**
@@ -852,10 +851,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 			dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
 	}
 
-#ifdef FSL_DMA_LD_DEBUG
-	chan_dbg(chan, "LD %p free\n", desc);
-#endif
-	dma_pool_free(chan->desc_pool, desc, txd->phys);
+	fsl_dma_free_descriptor(chan, desc);
 }
 
 /**
-- 
1.7.8.6
