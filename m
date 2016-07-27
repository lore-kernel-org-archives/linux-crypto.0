From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 06/10] crypto: ccp - Refactor code to enable checks for
 queue space.
Date: Tue, 26 Jul 2016 19:10:13 -0500
Message-ID: <20160727001013.24944.95785.stgit@taos>
References: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0086.outbound.protection.outlook.com ([104.47.41.86]:48339
	"EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757175AbcG0AZ0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 20:25:26 -0400
In-Reply-To: <20160727000652.24944.44919.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Available queue space is used to decide (by counting free slots)
if we have to put a command on hold or if it can be sent
to the engine immediately.


Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |    8 +++++++-
 drivers/crypto/ccp/ccp-dev.h    |    1 +
 drivers/crypto/ccp/ccp-ops.c    |    2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 373ac4f..02c8c95 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -70,6 +70,11 @@ static void ccp_free_ksb(struct ccp_cmd_queue *cmd_q, unsigned int start,
 	wake_up_interruptible_all(&ccp->sb_queue);
 }
 
+static unsigned int ccp_get_free_slots(struct ccp_cmd_queue *cmd_q)
+{
+	return CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
+}
+
 static int ccp_do_cmd(struct ccp_op *op, u32 *cr, unsigned int cr_count)
 {
 	struct ccp_cmd_queue *cmd_q = op->cmd_q;
@@ -357,7 +362,7 @@ static int ccp_init(struct ccp_device *ccp)
 		cmd_q->int_ok = 1 << (i * 2);
 		cmd_q->int_err = 1 << ((i * 2) + 1);
 
-		cmd_q->free_slots = CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
+		cmd_q->free_slots = ccp_get_free_slots(cmd_q);
 
 		init_waitqueue_head(&cmd_q->int_queue);
 
@@ -559,6 +564,7 @@ static const struct ccp_actions ccp3_actions = {
 	.sbfree = ccp_free_ksb,
 	.init = ccp_init,
 	.destroy = ccp_destroy,
+	.get_free_slots = ccp_get_free_slots,
 	.irqhandler = ccp_irq_handler,
 };
 
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 0c44c5e0..de90702 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -458,6 +458,7 @@ struct ccp_actions {
 	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
 	void (*sbfree)(struct ccp_cmd_queue *, unsigned int,
 			       unsigned int);
+	unsigned int (*get_free_slots)(struct ccp_cmd_queue *);
 	int (*init)(struct ccp_device *);
 	void (*destroy)(struct ccp_device *);
 	irqreturn_t (*irqhandler)(int, void *);
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index bd9eb1d..fdab0ae 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1765,7 +1765,7 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	cmd->engine_error = 0;
 	cmd_q->cmd_error = 0;
 	cmd_q->int_rcvd = 0;
-	cmd_q->free_slots = CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
+	cmd_q->free_slots = cmd_q->ccp->vdata->perform->get_free_slots(cmd_q);
 
 	switch (cmd->engine) {
 	case CCP_ENGINE_AES:
