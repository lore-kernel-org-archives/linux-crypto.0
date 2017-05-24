From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH 04/27] Drivers: ccree: ssi_request_mgr.c - align block comments
Date: Wed, 24 May 2017 16:41:49 +1200
Message-ID: <20170524044149.30051-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 37 ++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 48c2450d65c6..1bc6811d63c5 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -300,8 +300,9 @@ static inline int request_mgr_queues_status_check(
 	unsigned long poll_queue;
 
 	/* SW queue is checked only once as it will not
-	   be chaned during the poll becasue the spinlock_bh
-	   is held by the thread */
+	 * be chaned during the poll becasue the spinlock_bh
+	 * is held by the thread
+	 */
 	if (unlikely(((req_mgr_h->req_queue_head + 1) &
 		      (MAX_REQUEST_QUEUE_SIZE - 1)) ==
 		     req_mgr_h->req_queue_tail)) {
@@ -384,8 +385,9 @@ int send_request(
 		spin_lock_bh(&req_mgr_h->hw_lock);
 
 		/* Check if there is enough place in the SW/HW queues
-		in case iv gen add the max size and in case of no dout add 1
-		for the internal completion descriptor */
+		 * in case iv gen add the max size and in case of no dout add 1
+		 * for the internal completion descriptor
+		 */
 		rc = request_mgr_queues_status_check(req_mgr_h,
 					       cc_base,
 					       max_required_seq_len);
@@ -397,7 +399,8 @@ int send_request(
 
 		if (rc != -EAGAIN) {
 			/* Any error other than HW queue full
-			   (SW queue is full) */
+			 * (SW queue is full)
+			 */
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
 			ssi_power_mgr_runtime_put_suspend(&drvdata->plat_dev->dev);
 #endif
@@ -409,7 +412,8 @@ int send_request(
 	} while (1);
 
 	/* Additional completion descriptor is needed incase caller did not
-	   enabled any DLLI/MLLI DOUT bit in the given sequence */
+	 * enabled any DLLI/MLLI DOUT bit in the given sequence
+	 */
 	if (!is_dout) {
 		init_completion(&ssi_req->seq_compl);
 		ssi_req->user_cb = request_mgr_complete;
@@ -481,7 +485,8 @@ int send_request(
 
 	if (!is_dout) {
 		/* Wait upon sequence completion.
-		*  Return "0" -Operation done successfully. */
+		 *  Return "0" -Operation done successfully.
+		 */
 		return wait_for_completion_interruptible(&ssi_req->seq_compl);
 	} else {
 		/* Operation still in process */
@@ -633,7 +638,8 @@ static void comp_handler(unsigned long devarg)
 		/* ISR-to-Tasklet latency */
 		if (request_mgr_handle->axi_completed) {
 			/* Only if actually reflects ISR-to-completion-handling latency, i.e.,
-			   not duplicate as a result of interrupt after AXIM_MON_ERR clear, before end of loop */
+			 * not duplicate as a result of interrupt after AXIM_MON_ERR clear, before end of loop
+			 */
 			END_CYCLE_COUNT_AT(drvdata->isr_exit_cycles, STAT_OP_TYPE_GENERIC, STAT_PHASE_1);
 		}
 
@@ -641,7 +647,8 @@ static void comp_handler(unsigned long devarg)
 			do {
 				proc_completions(drvdata);
 				/* At this point (after proc_completions()), request_mgr_handle->axi_completed is always 0.
-				   The following assignment was changed to = (previously was +=) to conform KW restrictions. */
+				 * The following assignment was changed to = (previously was +=) to conform KW restrictions.
+				 */
 				request_mgr_handle->axi_completed = CC_REG_FLD_GET(CRY_KERNEL, AXIM_MON_COMP, VALUE,
 					CC_HAL_READ_REGISTER(AXIM_MON_BASE_OFFSET));
 			} while (request_mgr_handle->axi_completed > 0);
@@ -663,9 +670,9 @@ static void comp_handler(unsigned long devarg)
 }
 
 /*
-resume the queue configuration - no need to take the lock as this happens inside
-the spin lock protection
-*/
+ * resume the queue configuration - no need to take the lock as this happens inside
+ * the spin lock protection
+ */
 #if defined (CONFIG_PM_RUNTIME) || defined (CONFIG_PM_SLEEP)
 int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
 {
@@ -679,9 +686,9 @@ int ssi_request_mgr_runtime_resume_queue(struct ssi_drvdata *drvdata)
 }
 
 /*
-suspend the queue configuration. Since it is used for the runtime suspend
-only verify that the queue can be suspended.
-*/
+ * suspend the queue configuration. Since it is used for the runtime suspend
+ * only verify that the queue can be suspended.
+ */
 int ssi_request_mgr_runtime_suspend_queue(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle * request_mgr_handle =
-- 
2.12.2
