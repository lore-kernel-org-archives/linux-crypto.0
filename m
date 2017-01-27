From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp: Fix DMA operations when IOMMU is enabled
Date: Fri, 27 Jan 2017 15:28:45 -0600
Message-ID: <20170127212845.27618.32169.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0084.outbound.protection.outlook.com ([104.47.36.84]:33048
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751258AbdA0V25 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2017 16:28:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

An I/O page fault occurs when the IOMMU is enabled on a
system that supports the v5 CCP.  DMA operations use a
Request ID value that does not match what is expected by
the IOMMU, resulting in the I/O page fault.  Setting the
Request ID value to 0 corrects this issue.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index e2ce819..612898b 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -959,7 +959,7 @@ static irqreturn_t ccp5_irq_handler(int irq, void *data)
 static void ccp5_config(struct ccp_device *ccp)
 {
 	/* Public side */
-	iowrite32(0x00001249, ccp->io_regs + CMD5_REQID_CONFIG_OFFSET);
+	iowrite32(0x0, ccp->io_regs + CMD5_REQID_CONFIG_OFFSET);
 }
 
 static void ccp5other_config(struct ccp_device *ccp)
