From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 04/10] crypto: ccp - Refactor the storage block allocation
 code
Date: Tue, 26 Jul 2016 19:09:50 -0500
Message-ID: <20160727000950.24944.97174.stgit@taos>
References: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0064.outbound.protection.outlook.com ([104.47.41.64]:42442
	"EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756823AbcG0AZg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 20:25:36 -0400
In-Reply-To: <20160727000652.24944.44919.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the KSB access/management functions to the v3
device file, and add function pointers to the actions
structure. At the operations layer all of the references
to the storage block will be generic (virtual). This is
in preparation for a version 5 device, in which the
private storage block is managed differently.


Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c |   52 +++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.h    |   74 +++++++++++++++++++++++----------------
 drivers/crypto/ccp/ccp-ops.c    |   52 ++-------------------------
 3 files changed, 98 insertions(+), 80 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 19eafb8..5b06599 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -20,6 +20,56 @@
 
 #include "ccp-dev.h"
 
+static u32 ccp_alloc_ksb(struct ccp_cmd_queue *cmd_q, unsigned int count)
+{
+	int start;
+	struct ccp_device *ccp = cmd_q->ccp;
+
+	for (;;) {
+		mutex_lock(&ccp->sb_mutex);
+
+		start = (u32)bitmap_find_next_zero_area(ccp->sb,
+							ccp->sb_count,
+							ccp->sb_start,
+							count, 0);
+		if (start <= ccp->sb_count) {
+			bitmap_set(ccp->sb, start, count);
+
+			mutex_unlock(&ccp->sb_mutex);
+			break;
+		}
+
+		ccp->sb_avail = 0;
+
+		mutex_unlock(&ccp->sb_mutex);
+
+		/* Wait for KSB entries to become available */
+		if (wait_event_interruptible(ccp->sb_queue, ccp->sb_avail))
+			return 0;
+	}
+
+	return KSB_START + start;
+}
+
+static void ccp_free_ksb(struct ccp_cmd_queue *cmd_q, unsigned int start,
+			 unsigned int count)
+{
+	struct ccp_device *ccp = cmd_q->ccp;
+
+	if (!start)
+		return;
+
+	mutex_lock(&ccp->sb_mutex);
+
+	bitmap_clear(ccp->sb, start - KSB_START, count);
+
+	ccp->sb_avail = 1;
+
+	mutex_unlock(&ccp->sb_mutex);
+
+	wake_up_interruptible_all(&ccp->sb_queue);
+}
+
 static int ccp_do_cmd(struct ccp_op *op, u32 *cr, unsigned int cr_count)
 {
 	struct ccp_cmd_queue *cmd_q = op->cmd_q;
@@ -534,6 +584,8 @@ static const struct ccp_actions ccp3_actions = {
 	.rsa = ccp_perform_rsa,
 	.passthru = ccp_perform_passthru,
 	.ecc = ccp_perform_ecc,
+	.sballoc = ccp_alloc_ksb,
+	.sbfree = ccp_free_ksb,
 	.init = ccp_init,
 	.destroy = ccp_destroy,
 	.irqhandler = ccp_irq_handler,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 1e30568..4e38a61 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -147,30 +147,6 @@
 #define CCP_SB_BYTES			32
 
 struct ccp_op;
-
-/* Structure for computation functions that are device-specific */
-struct ccp_actions {
-	int (*aes)(struct ccp_op *);
-	int (*xts_aes)(struct ccp_op *);
-	int (*sha)(struct ccp_op *);
-	int (*rsa)(struct ccp_op *);
-	int (*passthru)(struct ccp_op *);
-	int (*ecc)(struct ccp_op *);
-	int (*init)(struct ccp_device *);
-	void (*destroy)(struct ccp_device *);
-	irqreturn_t (*irqhandler)(int, void *);
-};
-
-/* Structure to hold CCP version-specific values */
-struct ccp_vdata {
-	unsigned int version;
-	const struct ccp_actions *perform;
-	const unsigned int bar;
-	const unsigned int offset;
-};
-
-extern struct ccp_vdata ccpv3;
-
 struct ccp_device;
 struct ccp_cmd;
 
@@ -306,13 +282,22 @@ struct ccp_device {
 	 */
 	atomic_t current_id ____cacheline_aligned;
 
-	/* The CCP uses key storage blocks (KSB) to maintain context for certain
-	 * operations. To prevent multiple cmds from using the same KSB range
-	 * a command queue reserves a KSB range for the duration of the cmd.
-	 * Each queue, will however, reserve 2 KSB blocks for operations that
-	 * only require single KSB entries (eg. AES context/iv and key) in order
-	 * to avoid allocation contention.  This will reserve at most 10 KSB
-	 * entries, leaving 40 KSB entries available for dynamic allocation.
+	/* The v3 CCP uses key storage blocks (SB) to maintain context for
+	 * certain operations. To prevent multiple cmds from using the same
+	 * SB range a command queue reserves an SB range for the duration of
+	 * the cmd. Each queue, will however, reserve 2 SB blocks for
+	 * operations that only require single SB entries (eg. AES context/iv
+	 * and key) in order to avoid allocation contention.  This will reserve
+	 * at most 10 SB entries, leaving 40 SB entries available for dynamic
+	 * allocation.
+	 *
+	 * The v5 CCP Local Storage Block (LSB) is broken up into 8
+	 * memrory ranges, each of which can be enabled for access by one
+	 * or more queues. Device initialization takes this into account,
+	 * and attempts to assign one region for exclusive use by each
+	 * available queue; the rest are then aggregated as "public" use.
+	 * If there are fewer regions than queues, all regions are shared
+	 * amongst all queues.
 	 */
 	struct mutex sb_mutex ____cacheline_aligned;
 	DECLARE_BITMAP(sb, KSB_COUNT);
@@ -461,4 +446,31 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd);
 int ccp_dmaengine_register(struct ccp_device *ccp);
 void ccp_dmaengine_unregister(struct ccp_device *ccp);
 
+/* Structure for computation functions that are device-specific */
+struct ccp_actions {
+	int (*aes)(struct ccp_op *);
+	int (*xts_aes)(struct ccp_op *);
+	int (*sha)(struct ccp_op *);
+	int (*rsa)(struct ccp_op *);
+	int (*passthru)(struct ccp_op *);
+	int (*ecc)(struct ccp_op *);
+	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
+	void (*sbfree)(struct ccp_cmd_queue *, unsigned int,
+			       unsigned int);
+	int (*init)(struct ccp_device *);
+	void (*destroy)(struct ccp_device *);
+	irqreturn_t (*irqhandler)(int, void *);
+};
+
+/* Structure to hold CCP version-specific values */
+struct ccp_vdata {
+	unsigned int version;
+	int (*init)(struct ccp_device *);
+	const struct ccp_actions *perform;
+	const unsigned int bar;
+	const unsigned int offset;
+};
+
+extern	struct ccp_vdata ccpv3;
+
 #endif
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 2c2890a..bd9eb1d 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -41,53 +41,6 @@ static const __be32 ccp_sha256_init[CCP_SHA_CTXSIZE / sizeof(__be32)] = {
 	cpu_to_be32(SHA256_H6), cpu_to_be32(SHA256_H7),
 };
 
-static u32 ccp_alloc_ksb(struct ccp_device *ccp, unsigned int count)
-{
-	int start;
-
-	for (;;) {
-		mutex_lock(&ccp->sb_mutex);
-
-		start = (u32)bitmap_find_next_zero_area(ccp->sb,
-							ccp->sb_count,
-							ccp->sb_start,
-							count, 0);
-		if (start <= ccp->sb_count) {
-			bitmap_set(ccp->sb, start, count);
-
-			mutex_unlock(&ccp->sb_mutex);
-			break;
-		}
-
-		ccp->sb_avail = 0;
-
-		mutex_unlock(&ccp->sb_mutex);
-
-		/* Wait for KSB entries to become available */
-		if (wait_event_interruptible(ccp->sb_queue, ccp->sb_avail))
-			return 0;
-	}
-
-	return KSB_START + start;
-}
-
-static void ccp_free_ksb(struct ccp_device *ccp, unsigned int start,
-			 unsigned int count)
-{
-	if (!start)
-		return;
-
-	mutex_lock(&ccp->sb_mutex);
-
-	bitmap_clear(ccp->sb, start - KSB_START, count);
-
-	ccp->sb_avail = 1;
-
-	mutex_unlock(&ccp->sb_mutex);
-
-	wake_up_interruptible_all(&ccp->sb_queue);
-}
-
 static u32 ccp_gen_jobid(struct ccp_device *ccp)
 {
 	return atomic_inc_return(&ccp->current_id) & CCP_JOBID_MASK;
@@ -1214,7 +1167,8 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	memset(&op, 0, sizeof(op));
 	op.cmd_q = cmd_q;
 	op.jobid = ccp_gen_jobid(cmd_q->ccp);
-	op.sb_key = ccp_alloc_ksb(cmd_q->ccp, sb_count);
+	op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q, sb_count);
+
 	if (!op.sb_key)
 		return -EIO;
 
@@ -1293,7 +1247,7 @@ e_exp:
 	ccp_dm_free(&exp);
 
 e_sb:
-	ccp_free_ksb(cmd_q->ccp, op.sb_key, sb_count);
+	cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
 
 	return ret;
 }
