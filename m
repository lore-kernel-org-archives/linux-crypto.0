From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 1/2] crypto: ccp - clean up data structure
Date: Wed, 28 Sep 2016 11:53:47 -0500
Message-ID: <20160928165347.23263.45257.stgit@taos>
References: <20160928165204.23263.77515.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0064.outbound.protection.outlook.com ([104.47.38.64]:60672
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932988AbcI1Qxx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 12:53:53 -0400
In-Reply-To: <20160928165204.23263.77515.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change names of data structure instances.  Add const
keyword where appropriate.  Add error handling path.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |    2 +-
 drivers/crypto/ccp/ccp-dev-v5.c |    9 ++++++---
 drivers/crypto/ccp/ccp-dev.h    |    6 +++---
 drivers/crypto/ccp/ccp-pci.c    |    4 ++--
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 578522d..b6615b1 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -566,7 +566,7 @@ static const struct ccp_actions ccp3_actions = {
 	.irqhandler = ccp_irq_handler,
 };
 
-struct ccp_vdata ccpv3 = {
+const struct ccp_vdata ccpv3 = {
 	.version = CCP_VERSION(3, 0),
 	.setup = NULL,
 	.perform = &ccp3_actions,
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index f499e34..a90ca9e 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -835,10 +835,13 @@ static int ccp5_init(struct ccp_device *ccp)
 	/* Register the DMA engine support */
 	ret = ccp_dmaengine_register(ccp);
 	if (ret)
-		goto e_kthread;
+		goto e_hwrng;
 
 	return 0;
 
+e_hwrng:
+	ccp_unregister_rng(ccp);
+
 e_kthread:
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		if (ccp->cmd_q[i].kthread)
@@ -994,7 +997,7 @@ static const struct ccp_actions ccp5_actions = {
 	.irqhandler = ccp5_irq_handler,
 };
 
-struct ccp_vdata ccpv5 = {
+const struct ccp_vdata ccpv5a = {
 	.version = CCP_VERSION(5, 0),
 	.setup = ccp5_config,
 	.perform = &ccp5_actions,
@@ -1002,7 +1005,7 @@ struct ccp_vdata ccpv5 = {
 	.offset = 0x0,
 };
 
-struct ccp_vdata ccpv5other = {
+const struct ccp_vdata ccpv5b = {
 	.version = CCP_VERSION(5, 0),
 	.setup = ccp5other_config,
 	.perform = &ccp5_actions,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index ebc9365..08f58b0 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -639,8 +639,8 @@ struct ccp_vdata {
 	const unsigned int offset;
 };
 
-extern	struct ccp_vdata ccpv3;
-extern	struct ccp_vdata ccpv5;
-extern	struct ccp_vdata ccpv5other;
+extern const struct ccp_vdata ccpv3;
+extern const struct ccp_vdata ccpv5a;
+extern const struct ccp_vdata ccpv5b;
 
 #endif
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 239cbf2..28a9996 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -325,8 +325,8 @@ static int ccp_pci_resume(struct pci_dev *pdev)
 
 static const struct pci_device_id ccp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&ccpv3 },
-	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&ccpv5 },
-	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&ccpv5other },
+	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&ccpv5a },
+	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&ccpv5b },
 	/* Last entry must be zero */
 	{ 0, }
 };
