From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V2 2/2] crypto: ccp - Disable interrupts early on unload
Date: Thu, 13 Apr 2017 11:46:57 -0500
Message-ID: <20170413164657.11624.3790.stgit@taos>
References: <20170413164352.11624.84058.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0086.outbound.protection.outlook.com ([104.47.41.86]:22688
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752689AbdDMQrM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 12:47:12 -0400
In-Reply-To: <20170413164352.11624.84058.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Gary R Hook <ghook@amd.com>

Ensure that we disable interrupts first when shutting down
the driver.

Signed-off-by: Gary R Hook <ghook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index c7972e7..13b81a1 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -942,10 +942,10 @@ static void ccp5_destroy(struct ccp_device *ccp)
 		iowrite32(cmd_q->qcontrol & ~CMD5_Q_RUN, cmd_q->reg_control);
 
 		/* Disable the interrupts */
-		iowrite32(SUPPORTED_INTERRUPTS, cmd_q->reg_interrupt_status);
+		iowrite32(0x00, cmd_q->reg_int_enable);
 
 		/* Clear the interrupt status */
-		iowrite32(0x00, cmd_q->reg_int_enable);
+		iowrite32(SUPPORTED_INTERRUPTS, cmd_q->reg_interrupt_status);
 		ioread32(cmd_q->reg_int_status);
 		ioread32(cmd_q->reg_status);
 	}
