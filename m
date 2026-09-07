Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CCD389453;
	Mon,  7 Sep 2026 06:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788761133; cv=none; b=tlnn2rl5s6MEVlJIWdU5q2zmoICwpj6jKsvgm4pDKGyqKoAKgMr112BftjNQPL5KAHyuhUFwsTDCjtRDXyhLwC0FvjErNphQGBem1P+QNpyras65Yu6/nuH7oXeiEmWLyg8+l3vbcoxA+Etc6OpA3Sn8ZzLlR/eaLTWnEU2Ihy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788761133; c=relaxed/simple;
	bh=hBPwP8hp9KnGpZiFqIkc4EiMciV273dLIcexWcmIMBU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dVzEqB3W/K6gSaBVxaltCQ6O/bubrnVGs/SKaL22CpH96ZK991IeW7qiRUom0h7fbwsKTn4gOjgdGyaxhtlhP155x2EXMnJjQDCKMf8lupafDygTKu5z4QKcc40lR2o9m/gClCZiJEOikPXbcyw4Rm4dsnGRxF8APl2KvPHUJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wAn0zwXVJ5q93T5AA--.14170S3;
	Mon, 07 Sep 2026 14:05:12 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app4 (Coremail) with SMTP id zi_KCgDH+TAWVJ5qo3ygAw--.7687S2;
	Mon, 07 Sep 2026 14:05:11 +0800 (CST)
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
Subject: [PATCH] crypto: ccp - Fix use-after-free in backlog cmd advancement
Date: Mon,  7 Sep 2026 06:04:15 +0000
Message-Id: <20260907060415.575656-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zi_KCgDH+TAWVJ5qo3ygAw--.7687S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?50IpDgXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnXz+g1OQfMo27QHy5TwQyZy/t4PGctaocqOsNIP6GE/UUmFCxnK2Sp8FNgLAUIiRKKN7
	iy/VYjujIOzmHLN18sIB5rM+H8XhqwExY4Cjs2QP
X-Coremail-Antispam: 1Uk129KBj93XoW3Xw4UWr1xZFWDuFWDAr15WrX_yoW3Cryrpa
	1rJry5trWvqr47G3y3Zw4UXryfXFsYva4DK3yxW3WFkw15tFWFgrWfGFWjya4UZFykuF17
	JFW7uFy5Cr4IywcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
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
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8
	JbIYCTnIWIevJa73UjIFyTuYvjxU7gAwDUUUU

CCP_CMD_MAY_BACKLOG commands are removed from ccp->backlog by a
queue kthread and advanced asynchronously by ccp_do_cmd_backlog().
The promoted command is no longer on either command list.

During device removal, ccp*_destroy() stops the queue kthreads and
flushes the lists, but does not wait for a promoted work on system_wq.
That work can subsequently access the devm-allocated ccp_device after
it has been released, and wake a queue kthread whose task_struct
kthread_stop() has already released.

Use a per-device workqueue for backlog advancement and destroy it after
stopping all queue kthreads, so every promoted work has completed before
the command lists are flushed. The queue kthreads are the only source
of backlog works, so no new work can be queued once they are stopped.
Individual cancellation is not possible because a promoted command is
no longer reachable from either list.

Mark the device as halting before teardown. A draining backlog work
then completes its command with -ENODEV instead of re-queuing it.
Keep the halting check and the kthread wake under cmd_lock so teardown
cannot stop the selected kthread between them.

This issue was found by an in-house static analysis tool.

Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 19 +++++++++++++++++++
 drivers/crypto/ccp/ccp-dev-v5.c | 18 ++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.c    | 33 ++++++++++++++++++++++++++++-----
 drivers/crypto/ccp/ccp-dev.h    |  4 ++++
 4 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index fe69053b2394..b84ac117ea25 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -460,6 +460,14 @@ static int ccp_init(struct ccp_device *ccp)
 		tasklet_init(&ccp->irq_tasklet, ccp_irq_bh,
 			     (unsigned long)ccp);
 
+	ccp->backlog_wq = alloc_workqueue("%s-backlog", WQ_MEM_RECLAIM, 0,
+					  ccp->name);
+	if (!ccp->backlog_wq) {
+		dev_err(dev, "unable to allocate backlog workqueue\n");
+		ret = -ENOMEM;
+		goto e_irq;
+	}
+
 	dev_dbg(dev, "Starting threads...\n");
 	/* Create a kthread for each queue */
 	for (i = 0; i < ccp->cmd_q_count; i++) {
@@ -501,10 +509,15 @@ static int ccp_init(struct ccp_device *ccp)
 	ccp_unregister_rng(ccp);
 
 e_kthread:
+	ccp_halt_cmds(ccp);
+
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		if (ccp->cmd_q[i].kthread)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
+	destroy_workqueue(ccp->backlog_wq);
+
+e_irq:
 	sp_free_ccp_irq(ccp->sp, ccp);
 
 e_pool:
@@ -520,6 +533,9 @@ static void ccp_destroy(struct ccp_device *ccp)
 	struct ccp_cmd *cmd;
 	unsigned int i;
 
+	/* Complete pending backlog cmds instead of executing them */
+	ccp_halt_cmds(ccp);
+
 	/* Unregister the DMA engine */
 	ccp_dmaengine_unregister(ccp);
 
@@ -546,6 +562,9 @@ static void ccp_destroy(struct ccp_device *ccp)
 
 	sp_free_ccp_irq(ccp->sp, ccp);
 
+	/* Drain promoted backlog commands before flushing the command lists. */
+	destroy_workqueue(ccp->backlog_wq);
+
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
 
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 7b73332d6aa1..307a408eff89 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -943,6 +943,14 @@ static int ccp5_init(struct ccp_device *ccp)
 		ccp->cmd_q[i].sb_ctx = ccp_lsb_alloc(&ccp->cmd_q[i], 2);
 	}
 
+	ccp->backlog_wq = alloc_workqueue("%s-backlog", WQ_MEM_RECLAIM, 0,
+					  ccp->name);
+	if (!ccp->backlog_wq) {
+		dev_err(dev, "unable to allocate backlog workqueue\n");
+		ret = -ENOMEM;
+		goto e_irq;
+	}
+
 	dev_dbg(dev, "Starting threads...\n");
 	/* Create a kthread for each queue */
 	for (i = 0; i < ccp->cmd_q_count; i++) {
@@ -989,10 +997,14 @@ static int ccp5_init(struct ccp_device *ccp)
 	ccp_unregister_rng(ccp);
 
 e_kthread:
+	ccp_halt_cmds(ccp);
+
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		if (ccp->cmd_q[i].kthread)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
+	destroy_workqueue(ccp->backlog_wq);
+
 e_irq:
 	sp_free_ccp_irq(ccp->sp, ccp);
 
@@ -1009,6 +1021,9 @@ static void ccp5_destroy(struct ccp_device *ccp)
 	struct ccp_cmd *cmd;
 	unsigned int i;
 
+	/* Complete pending backlog cmds instead of executing them */
+	ccp_halt_cmds(ccp);
+
 	/* Unregister the DMA engine */
 	ccp_dmaengine_unregister(ccp);
 
@@ -1047,6 +1062,9 @@ static void ccp5_destroy(struct ccp_device *ccp)
 
 	sp_free_ccp_irq(ccp->sp, ccp);
 
+	/* Drain promoted backlog commands before flushing the command lists. */
+	destroy_workqueue(ccp->backlog_wq);
+
 	/* Flush the cmd and backlog queue */
 	while (!list_empty(&ccp->cmd)) {
 		/* Invoke the callback directly with an error code */
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 246801912e1a..b8eeaf0c3c95 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -177,6 +177,15 @@ void ccp_del_device(struct ccp_device *ccp)
 	write_unlock_irqrestore(&ccp_unit_lock, flags);
 }
 
+/* Mark the device halting so draining backlog works complete with -ENODEV. */
+void ccp_halt_cmds(struct ccp_device *ccp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+	ccp->halting = true;
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+}
 
 
 int ccp_register_rng(struct ccp_device *ccp)
@@ -349,6 +358,20 @@ static void ccp_do_cmd_backlog(struct work_struct *work)
 	unsigned long flags;
 	unsigned int i;
 
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+	if (ccp->halting) {
+		spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+		/* The device is being removed; the cmd can no longer be
+		 * executed, so complete it with an error like the cmds
+		 * still queued on the cmd and backlog lists
+		 */
+		cmd->callback(cmd->data, -ENODEV);
+
+		return;
+	}
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
 	cmd->callback(cmd->data, -EINPROGRESS);
 
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
@@ -364,11 +387,11 @@ static void ccp_do_cmd_backlog(struct work_struct *work)
 		break;
 	}
 
-	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
-
-	/* If we found an idle queue, wake it up */
-	if (i < ccp->cmd_q_count)
+	/* Keep this under cmd_lock so teardown cannot stop this kthread first. */
+	if (!ccp->halting && i < ccp->cmd_q_count)
 		wake_up_process(ccp->cmd_q[i].kthread);
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
 }
 
 static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
@@ -410,7 +433,7 @@ static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
 
 	if (backlog) {
 		INIT_WORK(&backlog->work, ccp_do_cmd_backlog);
-		schedule_work(&backlog->work);
+		queue_work(ccp->backlog_wq, &backlog->work);
 	}
 
 	return cmd;
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 83350e2d9821..91b303ec46a9 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -374,6 +374,9 @@ struct ccp_device {
 	struct list_head cmd;
 	struct list_head backlog;
 
+	struct workqueue_struct *backlog_wq;
+	bool halting;
+
 	/* The command queues. These represent the queues available on the
 	 * CCP that are available for processing cmds
 	 */
@@ -630,6 +633,7 @@ struct ccp5_desc {
 
 void ccp_add_device(struct ccp_device *ccp);
 void ccp_del_device(struct ccp_device *ccp);
+void ccp_halt_cmds(struct ccp_device *ccp);
 
 extern void ccp_log_error(struct ccp_device *, unsigned int);
 

