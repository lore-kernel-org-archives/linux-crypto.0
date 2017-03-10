From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - Assign DMA commands to the channel's CCP
Date: Fri, 10 Mar 2017 12:28:18 -0600
Message-ID: <20170310182818.21186.92711.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <gary.hook@amd.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0081.outbound.protection.outlook.com ([104.47.34.81]:14008
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933059AbdCJS21 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2017 13:28:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Gary R Hook <ghook@amd.com>

The CCP driver generally uses a round-robin approach when
assigning operations to available CCPs. For the DMA engine,
however, the DMA mappings of the SGs are associated with a
specific CCP. When an IOMMU is enabled, the IOMMU is
programmed based on this specific device.

If the DMA operations are not performed by that specific
CCP then addressing errors and I/O page faults will occur.

Update the CCP driver to allow a specific CCP device to be
requested for an operation and use this in the DMA engine
support.

Cc: <stable@vger.kernel.org> # 4.9.x-
Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c       |    5 ++++-
 drivers/crypto/ccp/ccp-dmaengine.c |    1 +
 include/linux/ccp.h                |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 511ab04..92d1c69 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -283,11 +283,14 @@ unsigned int ccp_version(void)
  */
 int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 {
-	struct ccp_device *ccp = ccp_get_device();
+	struct ccp_device *ccp;
 	unsigned long flags;
 	unsigned int i;
 	int ret;
 
+	/* Some commands might need to be sent to a specific device */
+	ccp = cmd->ccp ? cmd->ccp : ccp_get_device();
+
 	if (!ccp)
 		return -ENODEV;
 
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index e5d9278..8d0eeb4 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -390,6 +390,7 @@ static struct ccp_dma_desc *ccp_create_desc(struct dma_chan *dma_chan,
 			goto err;
 
 		ccp_cmd = &cmd->ccp_cmd;
+		ccp_cmd->ccp = chan->ccp;
 		ccp_pt = &ccp_cmd->u.passthru_nomap;
 		ccp_cmd->flags = CCP_CMD_MAY_BACKLOG;
 		ccp_cmd->flags |= CCP_CMD_PASSTHRU_NO_DMA_MAP;
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index c71dd8f..c41b8d99 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -556,7 +556,7 @@ enum ccp_engine {
  * struct ccp_cmd - CCP operation request
  * @entry: list element (ccp driver use only)
  * @work: work element used for callbacks (ccp driver use only)
- * @ccp: CCP device to be run on (ccp driver use only)
+ * @ccp: CCP device to be run on
  * @ret: operation return code (ccp driver use only)
  * @flags: cmd processing flags
  * @engine: CCP operation to perform
