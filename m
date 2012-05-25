From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 1/4] mv_cesa: add an expiry timer in case anything goes wrong
Date: Fri, 25 May 2012 15:54:46 +0200
Message-ID: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:45590 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab2EYOCS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 May 2012 10:02:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The timer triggers when 500ms have gone by after triggering the engine
and no completion interrupt was received. The callback then tries to
sanitise things as well as possible.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   41 +++++++++++++++++++++++++++++++----------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index e6ecc5f..8327bed 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -23,6 +23,7 @@
 
 #define MV_CESA	"MV-CESA:"
 #define MAX_HW_HASH_SIZE	0xFFFF
+#define MV_CESA_EXPIRE		500 /* msec */
 
 /*
  * STM:
@@ -85,6 +86,7 @@ struct crypto_priv {
 	spinlock_t lock;
 	struct crypto_queue queue;
 	enum engine_status eng_st;
+	struct timer_list completion_timer;
 	struct crypto_async_request *cur_req;
 	struct req_progress p;
 	int max_req_size;
@@ -136,6 +138,29 @@ struct mv_req_hash_ctx {
 	int count_add;
 };
 
+static void mv_completion_timer_callback(unsigned long unused)
+{
+	int active = readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_EN_SEC_ACCL0;
+
+	printk(KERN_ERR MV_CESA
+	       "completion timer expired (CESA %sactive), cleaning up.\n",
+	       active ? "" : "in");
+
+	del_timer(&cpg->completion_timer);
+	writel(SEC_CMD_DISABLE_SEC, cpg->reg + SEC_ACCEL_CMD);
+	while(readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_DISABLE_SEC)
+		printk(KERN_INFO MV_CESA "%s: waiting for engine finishing\n", __func__);
+	cpg->eng_st = ENGINE_W_DEQUEUE;
+	wake_up_process(cpg->queue_th);
+}
+
+static void mv_setup_timer(void)
+{
+	setup_timer(&cpg->completion_timer, &mv_completion_timer_callback, 0);
+	mod_timer(&cpg->completion_timer,
+			jiffies + msecs_to_jiffies(MV_CESA_EXPIRE));
+}
+
 static void compute_aes_dec_key(struct mv_ctx *ctx)
 {
 	struct crypto_aes_ctx gen_aes_key;
@@ -271,12 +296,8 @@ static void mv_process_current_q(int first_block)
 			sizeof(struct sec_accel_config));
 
 	/* GO */
+	mv_setup_timer();
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
-
-	/*
-	 * XXX: add timer if the interrupt does not occur for some mystery
-	 * reason
-	 */
 }
 
 static void mv_crypto_algo_completion(void)
@@ -355,12 +376,8 @@ static void mv_process_hash_current(int first_block)
 	memcpy(cpg->sram + SRAM_CONFIG, &op, sizeof(struct sec_accel_config));
 
 	/* GO */
+	mv_setup_timer();
 	writel(SEC_CMD_EN_SEC_ACCL0, cpg->reg + SEC_ACCEL_CMD);
-
-	/*
-	* XXX: add timer if the interrupt does not occur for some mystery
-	* reason
-	*/
 }
 
 static inline int mv_hash_import_sha1_ctx(const struct mv_req_hash_ctx *ctx,
@@ -886,6 +903,10 @@ irqreturn_t crypto_int(int irq, void *priv)
 	if (!(val & SEC_INT_ACCEL0_DONE))
 		return IRQ_NONE;
 
+	if (!del_timer(&cpg->completion_timer)) {
+		printk(KERN_WARNING MV_CESA
+		       "got an interrupt but no pending timer?\n");
+	}
 	val &= ~SEC_INT_ACCEL0_DONE;
 	writel(val, cpg->reg + FPGA_INT_STATUS);
 	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
-- 
1.7.3.4
