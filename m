From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 4/4] crypto: ccp - Perform completion callbacks using a tasklet
Date: Fri, 24 Jan 2014 16:18:14 -0600
Message-ID: <20140124221814.1894.4001.stgit@tlendack-t1.amdoffice.net>
References: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Change from scheduling work to scheduling a tasklet to perform
the callback operations.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index c3bc212..2c78161 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -30,6 +30,11 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
 MODULE_DESCRIPTION("AMD Cryptographic Coprocessor driver");
 
+struct ccp_tasklet_data {
+	struct completion completion;
+	struct ccp_cmd *cmd;
+};
+
 
 static struct ccp_device *ccp_dev;
 static inline struct ccp_device *ccp_get_device(void)
@@ -192,17 +197,23 @@ static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
 	return cmd;
 }
 
-static void ccp_do_cmd_complete(struct work_struct *work)
+static void ccp_do_cmd_complete(unsigned long data)
 {
-	struct ccp_cmd *cmd = container_of(work, struct ccp_cmd, work);
+	struct ccp_tasklet_data *tdata = (struct ccp_tasklet_data *)data;
+	struct ccp_cmd *cmd = tdata->cmd;
 
 	cmd->callback(cmd->data, cmd->ret);
+	complete(&tdata->completion);
 }
 
 static int ccp_cmd_queue_thread(void *data)
 {
 	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
 	struct ccp_cmd *cmd;
+	struct ccp_tasklet_data tdata;
+	struct tasklet_struct tasklet;
+
+	tasklet_init(&tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
@@ -220,8 +231,10 @@ static int ccp_cmd_queue_thread(void *data)
 		cmd->ret = ccp_run_cmd(cmd_q, cmd);
 
 		/* Schedule the completion callback */
-		INIT_WORK(&cmd->work, ccp_do_cmd_complete);
-		schedule_work(&cmd->work);
+		tdata.cmd = cmd;
+		init_completion(&tdata.completion);
+		tasklet_schedule(&tasklet);
+		wait_for_completion(&tdata.completion);
 	}
 
 	__set_current_state(TASK_RUNNING);
