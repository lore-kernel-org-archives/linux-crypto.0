From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Fix non-conforming comment style
Date: Tue, 26 Jul 2016 18:09:46 -0500
Message-ID: <20160726230946.29862.97863.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0058.outbound.protection.outlook.com ([104.47.36.58]:19088
	"EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964812AbcGZXkT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 19:40:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adhere to the cryptodev comment convention.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index bd41ffce..5fbee638 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -253,16 +253,14 @@ struct ccp_device {
 
 	struct device *dev;
 
-	/*
-	 * Bus specific device information
+	/* Bus specific device information
 	 */
 	void *dev_specific;
 	int (*get_irq)(struct ccp_device *ccp);
 	void (*free_irq)(struct ccp_device *ccp);
 	unsigned int irq;
 
-	/*
-	 * I/O area used for device communication. The register mapping
+	/* I/O area used for device communication. The register mapping
 	 * starts at an offset into the mapped bar.
 	 *   The CMD_REQx registers and the Delete_Cmd_Queue_Job register
 	 *   need to be protected while a command queue thread is accessing
@@ -272,8 +270,7 @@ struct ccp_device {
 	void __iomem *io_map;
 	void __iomem *io_regs;
 
-	/*
-	 * Master lists that all cmds are queued on. Because there can be
+	/* Master lists that all cmds are queued on. Because there can be
 	 * more than one CCP command queue that can process a cmd a separate
 	 * backlog list is neeeded so that the backlog completion call
 	 * completes before the cmd is available for execution.
@@ -283,34 +280,29 @@ struct ccp_device {
 	struct list_head cmd;
 	struct list_head backlog;
 
-	/*
-	 * The command queues. These represent the queues available on the
+	/* The command queues. These represent the queues available on the
 	 * CCP that are available for processing cmds
 	 */
 	struct ccp_cmd_queue cmd_q[MAX_HW_QUEUES];
 	unsigned int cmd_q_count;
 
-	/*
-	 * Support for the CCP True RNG
+	/* Support for the CCP True RNG
 	 */
 	struct hwrng hwrng;
 	unsigned int hwrng_retries;
 
-	/*
-	 * Support for the CCP DMA capabilities
+	/* Support for the CCP DMA capabilities
 	 */
 	struct dma_device dma_dev;
 	struct ccp_dma_chan *ccp_dma_chan;
 	struct kmem_cache *dma_cmd_cache;
 	struct kmem_cache *dma_desc_cache;
 
-	/*
-	 * A counter used to generate job-ids for cmds submitted to the CCP
+	/* A counter used to generate job-ids for cmds submitted to the CCP
 	 */
 	atomic_t current_id ____cacheline_aligned;
 
-	/*
-	 * The CCP uses key storage blocks (KSB) to maintain context for certain
+	/* The CCP uses key storage blocks (KSB) to maintain context for certain
 	 * operations. To prevent multiple cmds from using the same KSB range
 	 * a command queue reserves a KSB range for the duration of the cmd.
 	 * Each queue, will however, reserve 2 KSB blocks for operations that
