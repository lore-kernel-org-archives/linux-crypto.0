From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Clean up the LSB slot allocation code
Date: Tue, 18 Oct 2016 17:33:37 -0500
Message-ID: <147683001790.8273.9550490485955104780.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0059.outbound.protection.outlook.com ([104.47.42.59]:61856
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934261AbcJRWdr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 18:33:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a few problems revealed by testing: verify consistent
units, especially in public slot allocation. Percolate
some common initialization code up to a common routine.
Add some comments.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |    4 ----
 drivers/crypto/ccp/ccp-dev-v5.c |   20 ++++++++++++--------
 drivers/crypto/ccp/ccp-dev.c    |    4 ++++
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 8d2dbac..7bc0998 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -404,10 +404,6 @@ static int ccp_init(struct ccp_device *ccp)
 		goto e_pool;
 	}
 
-	/* Initialize the queues used to wait for KSB space and suspend */
-	init_waitqueue_head(&ccp->sb_queue);
-	init_waitqueue_head(&ccp->suspend_queue);
-
 	dev_dbg(dev, "Starting threads...\n");
 	/* Create a kthread for each queue */
 	for (i = 0; i < ccp->cmd_q_count; i++) {
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index faf3cb3..ff7816a 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -21,6 +21,12 @@
 
 #include "ccp-dev.h"
 
+/* Allocate the requested number of contiguous LSB slots
+ * from the LSB bitmap. Look in the private range for this
+ * queue first; failing that, check the public area.
+ * If no space is available, wait around.
+ * Return: first slot number
+ */
 static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
 {
 	struct ccp_device *ccp;
@@ -50,7 +56,7 @@ static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
 			bitmap_set(ccp->lsbmap, start, count);
 
 			mutex_unlock(&ccp->sb_mutex);
-			return start * LSB_ITEM_SIZE;
+			return start;
 		}
 
 		ccp->sb_avail = 0;
@@ -63,17 +69,18 @@ static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
 	}
 }
 
+/* Free a number of LSB slots from the bitmap, starting at
+ * the indicated starting slot number.
+ */
 static void ccp_lsb_free(struct ccp_cmd_queue *cmd_q, unsigned int start,
 			 unsigned int count)
 {
-	int lsbno = start / LSB_SIZE;
-
 	if (!start)
 		return;
 
-	if (cmd_q->lsb == lsbno) {
+	if (cmd_q->lsb == start) {
 		/* An entry from the private LSB */
-		bitmap_clear(cmd_q->lsbmap, start % LSB_SIZE, count);
+		bitmap_clear(cmd_q->lsbmap, start, count);
 	} else {
 		/* From the shared LSBs */
 		struct ccp_device *ccp = cmd_q->ccp;
@@ -751,9 +758,6 @@ static int ccp5_init(struct ccp_device *ccp)
 		goto e_pool;
 	}
 
-	/* Initialize the queue used to suspend */
-	init_waitqueue_head(&ccp->suspend_queue);
-
 	dev_dbg(dev, "Loading LSB map...\n");
 	/* Copy the private LSB mask to the public registers */
 	status_lo = ioread32(ccp->io_regs + LSB_PRIVATE_MASK_LO_OFFSET);
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index d9885ce..653b5a5 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -478,6 +478,10 @@ struct ccp_device *ccp_alloc_struct(struct device *dev)
 	ccp->sb_count = KSB_COUNT;
 	ccp->sb_start = 0;
 
+	/* Initialize the wait queues */
+	init_waitqueue_head(&ccp->sb_queue);
+	init_waitqueue_head(&ccp->suspend_queue);
+
 	ccp->ord = ccp_increment_unit_ordinal();
 	snprintf(ccp->name, MAX_CCP_NAME_LEN, "ccp-%u", ccp->ord);
 	snprintf(ccp->rngname, MAX_CCP_NAME_LEN, "ccp-%u-rng", ccp->ord);
