From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 2/2] crypto: ccp - Disable interrupts early on unload
Date: Wed, 12 Apr 2017 17:54:43 -0500
Message-ID: <20170412225443.17707.83299.stgit@taos>
References: <20170412225324.17707.75176.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0080.outbound.protection.outlook.com ([104.47.38.80]:24400
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755387AbdDLWzA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2017 18:55:00 -0400
In-Reply-To: <20170412225324.17707.75176.stgit@taos>
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
index e03d06a..293c08e 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -942,10 +942,10 @@ static void ccp5_destroy(struct ccp_device *ccp)
 		iowrite32(cmd_q->qcontrol & ~CMD5_Q_RUN, cmd_q->reg_control);
 
 		/* Disable the interrupts */
-		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
+		iowrite32(0x00, cmd_q->reg_int_enable);
 
 		/* Clear the interrupt status */
-		iowrite32(0x00, cmd_q->reg_int_enable);
+		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
 		ioread32(cmd_q->reg_int_status);
 		ioread32(cmd_q->reg_status);
 	}
