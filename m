Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BA93B0599;
	Tue, 29 Sep 2026 14:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790692779; cv=none; b=nUYSFfuwbHWslNKQ2GobALcKtX8T7EXqjT5FDDPNjRTrxTQ6EZnU4zHl0+8CGJQwS9Q4nICvev6Pgqbi2oG/ao6Eih+mqodJ0YTgrIpLb5sKCIcnjV68sufZX3kAt53FPuY3yFkkoIsq4XPPFDkh4Z0J6yTaYSFxUtpxQGuhiCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790692779; c=relaxed/simple;
	bh=Iw7mcDx0RpVtRveoaa1tRxCnM6zuA/6aPN81mza5VrE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mR5CuTBTaQyO4S5Y/A5rfBI+9nK8CZJTGf4KuC51dQs/a0KBrsUITUd8be9Ysqx+V2Vqj7RsmmA91O9Or07lEZTI3ZMGCmjicKptUYtSbqfAnQuOCR1C42ptwna2oMVAn8yyx25vUxPNyQTYDuFTgLu40zOYDzlR7wIKE844CFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wCXn3+ZzbtqOuVGAQ--.5323S3;
	Tue, 29 Sep 2026 22:39:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app2 (Coremail) with UTF8SMTPA id zC_KCgCX8H6YzbtqMeYWAA--.26551S2;
	Tue, 29 Sep 2026 22:39:21 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: thomas.lendacky@amd.com,
	john.allen@amd.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>,
	Song Li <songl@zju.edu.cn>
Subject: [PATCH v2] crypto: ccp - Fix use-after-free in backlog cmd advancement
Date: Tue, 29 Sep 2026 14:38:25 +0000
Message-Id: <20260929143825.21349-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgCX8H6YzbtqMeYWAA--.26551S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?FMlrnQXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnVvLbuoOKy0xUR2OEh/Lyhl0VXVxchKRVnqmbCwnQwHxX+fnBG59VutvSe69IvMdqgs8
	/b6IxfG5MXLLFTbHL3+p9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW3Wr4xXr43ZFyUKF1kWrWrCrX_yoWfWw13pa
	95AFy5trWkZrWUG39rZ3y8u34fXwnY9FWDK3y8W3WSyw43KFWFgrWxCFWjya4UAFyv9F13
	JFW29Fy5Cr48ZagCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU85l1PUUUUU==

A CCP_CMD_MAY_BACKLOG command promoted by a queue kthread leaves the
backlog list and is re-queued only later, by a work running on the
system workqueue. Until that work runs, the command is on neither
list, so the flush in ccp*_destroy() cannot reach it: the work then
uses the ccp_device after it has been released and wakes a queue
kthread whose task_struct kthread_stop() has already freed.

The gap between the promotion and the requeue also lets concurrent
submissions claim the space meant for the backlogged command, so it
is not actually reserved and cmd_count can grow past MAX_CMD_QLEN.

Promote the backlogged command in ccp_dequeue_cmd() itself: the slot
freed by the dequeue is transferred to the backlog head under the
same cmd_lock, so the space is reserved atomically, and the command
is put on the normal queue only after its advancement callback
(-EINPROGRESS) has run from the queue kthread, which provides process
context and keeps the backlog completion ahead of execution. The work
struct is no longer needed and the unused member is removed from
ccp_cmd.

Mark the device halting before stopping its queues and suppress the
promotion wake under cmd_lock once teardown starts, so it cannot wake
a queue kthread that teardown has already stopped.

This issue was found by an in-house static analysis tool.

Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---

Link to v1: https://lore.kernel.org/linux-crypto/20260907060415.575656-1-fanwu01@zju.edu.cn/

- transfer the slot freed by the dequeue to the backlogged command
  under cmd_lock, as suggested by Herbert Xu, and drop the work
  struct and the per-device workqueue of v1.
- mark the device halting before stopping its queues and suppress
  the promotion wake under cmd_lock once teardown starts.
 drivers/crypto/ccp/ccp-dev-v3.c |  3 ++
 drivers/crypto/ccp/ccp-dev-v5.c |  3 ++
 drivers/crypto/ccp/ccp-dev.c    | 88 +++++++++++++++++++--------------
 drivers/crypto/ccp/ccp-dev.h    |  3 ++
 include/linux/ccp.h             |  5 +-
 5 files changed, 62 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index d92de4ad31..c5ab8beb16 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -501,6 +501,8 @@ static int ccp_init(struct ccp_device *ccp)
 	ccp_unregister_rng(ccp);
 
 e_kthread:
+	ccp_halt_cmds(ccp);
+
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		if (ccp->cmd_q[i].kthread)
 			kthread_stop(ccp->cmd_q[i].kthread);
@@ -542,6 +544,7 @@ static void ccp_destroy(struct ccp_device *ccp)
 	iowrite32(ccp->qim, ccp->io_regs + IRQ_STATUS_REG);
 
 	/* Stop the queue kthreads */
+	ccp_halt_cmds(ccp);
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		if (ccp->cmd_q[i].kthread)
 			kthread_stop(ccp->cmd_q[i].kthread);
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index dacde9614e..3b09befa45 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -989,6 +989,8 @@ static int ccp5_init(struct ccp_device *ccp)
 	ccp_unregister_rng(ccp);
 
 e_kthread:
+	ccp_halt_cmds(ccp);
+
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		if (ccp->cmd_q[i].kthread)
 			kthread_stop(ccp->cmd_q[i].kthread);
@@ -1043,6 +1045,7 @@ static void ccp5_destroy(struct ccp_device *ccp)
 	}
 
 	/* Stop the queue kthreads */
+	ccp_halt_cmds(ccp);
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		if (ccp->cmd_q[i].kthread)
 			kthread_stop(ccp->cmd_q[i].kthread);
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index aff3348b83..12c210acac 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -177,6 +177,15 @@ void ccp_del_device(struct ccp_device *ccp)
 	write_unlock_irqrestore(&ccp_unit_lock, flags);
 }
 
+/* Prevent promotion from waking an idle queue during teardown. */
+void ccp_halt_cmds(struct ccp_device *ccp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+	ccp->halting = true;
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+}
 
 
 int ccp_register_rng(struct ccp_device *ccp)
@@ -342,41 +351,13 @@ int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 }
 EXPORT_SYMBOL_GPL(ccp_enqueue_cmd);
 
-static void ccp_do_cmd_backlog(struct work_struct *work)
-{
-	struct ccp_cmd *cmd = container_of(work, struct ccp_cmd, work);
-	struct ccp_device *ccp = cmd->ccp;
-	unsigned long flags;
-	unsigned int i;
-
-	cmd->callback(cmd->data, -EINPROGRESS);
-
-	spin_lock_irqsave(&ccp->cmd_lock, flags);
-
-	ccp->cmd_count++;
-	list_add_tail(&cmd->entry, &ccp->cmd);
-
-	/* Find an idle queue */
-	for (i = 0; i < ccp->cmd_q_count; i++) {
-		if (ccp->cmd_q[i].active)
-			continue;
-
-		break;
-	}
-
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	/* If we found an idle queue, wake it up */
-	if (i < ccp->cmd_q_count)
-		wake_up_process(ccp->cmd_q[i].kthread);
-}
-
 static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
 {
 	struct ccp_device *ccp = cmd_q->ccp;
 	struct ccp_cmd *cmd = NULL;
 	struct ccp_cmd *backlog = NULL;
 	unsigned long flags;
+	unsigned int i = ccp->cmd_q_count;
 
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
 
@@ -391,26 +372,61 @@ static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
 		return NULL;
 	}
 
-	if (ccp->cmd_count) {
+	if (!list_empty(&ccp->cmd)) {
 		cmd_q->active = 1;
 
 		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
 		list_del(&cmd->entry);
 
-		ccp->cmd_count--;
-	}
-
-	if (!list_empty(&ccp->backlog)) {
+		if (!list_empty(&ccp->backlog)) {
+			/* Transfer the freed slot to the backlogged
+			 * command, so that concurrent submissions cannot
+			 * claim the space meant for it.
+			 */
+			backlog = list_first_entry(&ccp->backlog,
+						   struct ccp_cmd, entry);
+			list_del(&backlog->entry);
+		} else {
+			ccp->cmd_count--;
+		}
+	} else if (!list_empty(&ccp->backlog)) {
+		/* No command is available for execution, but a backlogged
+		 * command is stranded: reserve a slot for it.
+		 */
 		backlog = list_first_entry(&ccp->backlog, struct ccp_cmd,
 					   entry);
 		list_del(&backlog->entry);
+
+		ccp->cmd_count++;
 	}
 
 	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
 
 	if (backlog) {
-		INIT_WORK(&backlog->work, ccp_do_cmd_backlog);
-		schedule_work(&backlog->work);
+		/* Notify the advancement out of the backlog before the
+		 * command is made available for execution; the queue
+		 * kthread provides process context, so no work struct
+		 * is needed.
+		 */
+		backlog->callback(backlog->data, -EINPROGRESS);
+
+		spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+		list_add_tail(&backlog->entry, &ccp->cmd);
+
+		/* Find an idle queue */
+		for (i = 0; i < ccp->cmd_q_count; i++) {
+			if (ccp->cmd_q[i].active)
+				continue;
+
+			break;
+		}
+
+		/* Do not wake an idle queue after teardown has started. */
+		if (!ccp->halting && i < ccp->cmd_q_count)
+			wake_up_process(ccp->cmd_q[i].kthread);
+
+		spin_unlock_irqrestore(&ccp->cmd_lock, flags);
 	}
 
 	return cmd;
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 83350e2d98..ead87c138b 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -374,6 +374,8 @@ struct ccp_device {
 	struct list_head cmd;
 	struct list_head backlog;
 
+	bool halting;
+
 	/* The command queues. These represent the queues available on the
 	 * CCP that are available for processing cmds
 	 */
@@ -630,6 +632,7 @@ struct ccp5_desc {
 
 void ccp_add_device(struct ccp_device *ccp);
 void ccp_del_device(struct ccp_device *ccp);
+void ccp_halt_cmds(struct ccp_device *ccp);
 
 extern void ccp_log_error(struct ccp_device *, unsigned int);
 
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index e6c599243f..0386813361 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -12,7 +12,6 @@
 #define __CCP_H__
 
 #include <linux/scatterlist.h>
-#include <linux/workqueue.h>
 #include <linux/list.h>
 #include <crypto/aes.h>
 #include <crypto/sha1.h>
@@ -637,7 +636,6 @@ enum ccp_engine {
 /**
  * struct ccp_cmd - CCP operation request
  * @entry: list element (ccp driver use only)
- * @work: work element used for callbacks (ccp driver use only)
  * @ccp: CCP device to be run on
  * @ret: operation return code (ccp driver use only)
  * @flags: cmd processing flags
@@ -653,11 +651,10 @@ enum ccp_engine {
  *     operation.
  */
 struct ccp_cmd {
-	/* The list_head, work_struct, ccp and ret variables are for use
+	/* The list_head, ccp and ret variables are for use
 	 * by the CCP driver only.
 	 */
 	struct list_head entry;
-	struct work_struct work;
 	struct ccp_device *ccp;
 	int ret;
 

