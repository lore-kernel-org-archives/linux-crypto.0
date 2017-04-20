From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V3 2/2] crypto: ccp - Disable interrupts early on unload
Date: Thu, 20 Apr 2017 15:24:22 -0500
Message-ID: <20170420202422.4843.38323.stgit@taos.amd.com>
References: <20170420202030.4843.76826.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0060.outbound.protection.outlook.com ([104.47.36.60]:55648
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1033664AbdDTUYk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 16:24:40 -0400
In-Reply-To: <20170420202030.4843.76826.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Gary R Hook <ghook@amd.com>

Ensure that we disable interrupts first when shutting down
the driver.

Cc: <stable@vger.kernel.org> # 4.9.x+

Signed-off-by: Gary R Hook <ghook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index c7972e733e43..13b81a1c1184 100644
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
