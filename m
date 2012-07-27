From: <qiang.liu@freescale.com>
Subject: [PATCH v4 7/7] fsl-dma: add memcpy self test interface
Date: Fri, 27 Jul 2012 17:16:56 +0800
Message-ID: <1343380616-12126-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
	<davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Li Yang <leoli@freescale.com>,
	"Ira W. Snyder" <iws@ovro.caltech.edu>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:38557
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab2G0JR1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Jul 2012 05:17:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Qiang Liu <qiang.liu@freescale.com>

Add memory copy self test when probe device, fsl-dma will be disabled
if self test failed.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 6fc22eb..5e0b162 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1277,6 +1277,82 @@ out_unwind:
 	return ret;
 }

+/*
+ * Perform a transaction to verify the HW works.
+ */
+#define FSL_DMA_TEST_SIZE 2000
+
+static int __devinit fsl_dma_memcpy_self_test(struct fsldma_device *device)
+{
+	int i;
+	void *src, *dest;
+	dma_addr_t src_dma, dest_dma;
+	struct dma_chan *dma_chan;
+	dma_cookie_t cookie;
+	struct dma_async_tx_descriptor *tx;
+	int err = 0;
+	struct fsldma_chan *chan;
+
+	src = kmalloc(sizeof(u8) * FSL_DMA_TEST_SIZE, GFP_KERNEL);
+	if (!src)
+		return -ENOMEM;
+
+	dest = kzalloc(sizeof(u8) * FSL_DMA_TEST_SIZE, GFP_KERNEL);
+	if (!dest) {
+		kfree(src);
+		return -ENOMEM;
+	}
+
+	/* Fill in src buffer */
+	for (i = 0; i < FSL_DMA_TEST_SIZE; i++)
+		((u8 *) src)[i] = (u8)i;
+
+	/* Start copy, using first DMA channel */
+	dma_chan = container_of(device->common.channels.next,
+			struct dma_chan, device_node);
+	if (fsl_dma_alloc_chan_resources(dma_chan) < 1) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	chan = to_fsl_chan(dma_chan);
+	dest_dma = dma_map_single(chan->common.device->dev, dest,
+			FSL_DMA_TEST_SIZE, DMA_FROM_DEVICE);
+
+	src_dma = dma_map_single(chan->common.device->dev, src,
+			FSL_DMA_TEST_SIZE, DMA_TO_DEVICE);
+
+	tx = fsl_dma_prep_memcpy(dma_chan, dest_dma, src_dma, FSL_DMA_TEST_SIZE,
+			DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SRC_UNMAP_SINGLE);
+	cookie = fsl_dma_tx_submit(tx);
+	fsl_dma_memcpy_issue_pending(dma_chan);
+	async_tx_ack(tx);
+	msleep(1);
+
+	if (fsl_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+				"Self-test copy timed out, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+	dma_sync_single_for_cpu(device->dev, dest_dma,
+			FSL_DMA_TEST_SIZE, DMA_FROM_DEVICE);
+	if (memcmp(src, dest, FSL_DMA_TEST_SIZE)) {
+		dev_printk(KERN_ERR, dma_chan->device->dev,
+				"Self-test copy failed compare, disabling\n");
+		err = -ENODEV;
+		goto free_resources;
+	}
+
+free_resources:
+	fsl_dma_free_chan_resources(dma_chan);
+out:
+	kfree(src);
+	kfree(dest);
+	return err;
+}
+
 /*----------------------------------------------------------------------------*/
 /* OpenFirmware Subsystem                                                     */
 /*----------------------------------------------------------------------------*/
@@ -1461,6 +1537,13 @@ static int __devinit fsldma_of_probe(struct platform_device *op)
 		goto out_free_fdev;
 	}

+	if (dma_has_cap(DMA_MEMCPY, fdev->common.cap_mask)) {
+		err = fsl_dma_memcpy_self_test(fdev);
+		printk(KERN_INFO "FSL-DMA Channel memcpy self test returned %d\n", err);
+		if (err)
+			goto out_free_fdev;
+	}
+
 	dma_async_device_register(&fdev->common);
 	return 0;

--
1.7.5.1
