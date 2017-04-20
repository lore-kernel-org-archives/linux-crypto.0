From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH V3 1/2] crypto: ccp - Use only the relevant interrupt bits
Date: Thu, 20 Apr 2017 15:24:09 -0500
Message-ID: <20170420202409.4843.6474.stgit@taos.amd.com>
References: <20170420202030.4843.76826.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0054.outbound.protection.outlook.com ([104.47.40.54]:6512
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1033360AbdDTUYV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 16:24:21 -0400
In-Reply-To: <20170420202030.4843.76826.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Each CCP queue can product interrupts for 4 conditions:
operation complete, queue empty, error, and queue stopped.
This driver only works with completion and error events.

Cc: <stable@vger.kernel.org> # 4.9.x+

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |    9 +++++----
 drivers/crypto/ccp/ccp-dev.h    |    5 ++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index e03d06a54d4e..c7972e733e43 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -801,7 +801,7 @@ static int ccp5_init(struct ccp_device *ccp)
 		ioread32(cmd_q->reg_status);
 
 		/* Clear the interrupts */
-		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
+		iowrite32(SUPPORTED_INTERRUPTS, cmd_q->reg_interrupt_status);
 	}
 
 	dev_dbg(dev, "Requesting an IRQ...\n");
@@ -882,7 +882,7 @@ static int ccp5_init(struct ccp_device *ccp)
 	/* Enable interrupts */
 	for (i = 0; i < ccp->cmd_q_count; i++) {
 		cmd_q = &ccp->cmd_q[i];
-		iowrite32(ALL_INTERRUPTS, cmd_q->reg_int_enable);
+		iowrite32(SUPPORTED_INTERRUPTS, cmd_q->reg_int_enable);
 	}
 
 	dev_dbg(dev, "Registering device...\n");
@@ -942,7 +942,7 @@ static void ccp5_destroy(struct ccp_device *ccp)
 		iowrite32(cmd_q->qcontrol & ~CMD5_Q_RUN, cmd_q->reg_control);
 
 		/* Disable the interrupts */
-		iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
+		iowrite32(SUPPORTED_INTERRUPTS, cmd_q->reg_interrupt_status);
 
 		/* Clear the interrupt status */
 		iowrite32(0x00, cmd_q->reg_int_enable);
@@ -1002,7 +1002,8 @@ static irqreturn_t ccp5_irq_handler(int irq, void *data)
 			cmd_q->int_rcvd = 1;
 
 			/* Acknowledge the interrupt and wake the kthread */
-			iowrite32(ALL_INTERRUPTS, cmd_q->reg_interrupt_status);
+			iowrite32(SUPPORTED_INTERRUPTS,
+				  cmd_q->reg_interrupt_status);
 			wake_up_interruptible(&cmd_q->int_queue);
 		}
 	}
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 191274d41036..2dfec019a832 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -109,9 +109,8 @@
 #define INT_COMPLETION			0x1
 #define INT_ERROR			0x2
 #define INT_QUEUE_STOPPED		0x4
-#define ALL_INTERRUPTS			(INT_COMPLETION| \
-					 INT_ERROR| \
-					 INT_QUEUE_STOPPED)
+#define	INT_EMPTY_QUEUE			0x8
+#define SUPPORTED_INTERRUPTS		(INT_COMPLETION | INT_ERROR)
 
 #define LSB_REGION_WIDTH		5
 #define MAX_LSB_CNT			8
