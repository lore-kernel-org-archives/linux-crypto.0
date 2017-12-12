From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 09/24] staging: ccree: fix reg mgr naming convention
Date: Tue, 12 Dec 2017 14:52:55 +0000
Message-ID: <1513090395-7938-10-git-send-email-gilad@benyossef.com>
References: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
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

The request manager files were using a func naming convention which was
inconsistent (ssi vs. cc), included a useless prefix (ssi_request_mgr)
and often too long.

Make the code more readable by switching to a simpler, consistent naming
convention.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c      |  8 +++----
 drivers/staging/ccree/ssi_request_mgr.c | 40 ++++++++++++++++-----------------
 drivers/staging/ccree/ssi_request_mgr.h |  4 ++--
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 513c5e4..491e2b9 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -326,9 +326,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_sram_mgr_err;
 	}
 
-	rc = request_mgr_init(new_drvdata);
+	rc = cc_req_mgr_init(new_drvdata);
 	if (rc) {
-		dev_err(dev, "request_mgr_init failed\n");
+		dev_err(dev, "cc_req_mgr_init failed\n");
 		goto post_sram_mgr_err;
 	}
 
@@ -389,7 +389,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 post_buf_mgr_err:
 	 cc_buffer_mgr_fini(new_drvdata);
 post_req_mgr_err:
-	request_mgr_fini(new_drvdata);
+	cc_req_mgr_fini(new_drvdata);
 post_sram_mgr_err:
 	ssi_sram_mgr_fini(new_drvdata);
 post_fips_init_err:
@@ -422,7 +422,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	ssi_ivgen_fini(drvdata);
 	cc_pm_fini(drvdata);
 	cc_buffer_mgr_fini(drvdata);
-	request_mgr_fini(drvdata);
+	cc_req_mgr_fini(drvdata);
 	ssi_sram_mgr_fini(drvdata);
 	ssi_fips_fini(drvdata);
 #ifdef ENABLE_CC_SYSFS
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 5f34336..dbdfd0c 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -33,7 +33,7 @@
 
 #define SSI_MAX_POLL_ITER	10
 
-struct ssi_request_mgr_handle {
+struct cc_req_mgr_handle {
 	/* Request manager resources */
 	unsigned int hw_queue_size; /* HW capability */
 	unsigned int min_free_hw_slots;
@@ -68,9 +68,9 @@ static void comp_handler(unsigned long devarg);
 static void comp_work_handler(struct work_struct *work);
 #endif
 
-void request_mgr_fini(struct ssi_drvdata *drvdata)
+void cc_req_mgr_fini(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	if (!req_mgr_h)
@@ -92,14 +92,14 @@ void request_mgr_fini(struct ssi_drvdata *drvdata)
 	/* Kill tasklet */
 	tasklet_kill(&req_mgr_h->comptask);
 #endif
-	memset(req_mgr_h, 0, sizeof(struct ssi_request_mgr_handle));
+	memset(req_mgr_h, 0, sizeof(struct cc_req_mgr_handle));
 	kfree(req_mgr_h);
 	drvdata->request_mgr_handle = NULL;
 }
 
-int request_mgr_init(struct ssi_drvdata *drvdata)
+int cc_req_mgr_init(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle *req_mgr_h;
+	struct cc_req_mgr_handle *req_mgr_h;
 	struct device *dev = drvdata_to_dev(drvdata);
 	int rc = 0;
 
@@ -161,7 +161,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	return 0;
 
 req_mgr_init_err:
-	request_mgr_fini(drvdata);
+	cc_req_mgr_fini(drvdata);
 	return rc;
 }
 
@@ -202,9 +202,9 @@ static void request_mgr_complete(struct device *dev, void *dx_compl_h)
 	complete(this_compl);
 }
 
-static int request_mgr_queues_status_check(
+static int cc_queues_status(
 		struct ssi_drvdata *drvdata,
-		struct ssi_request_mgr_handle *req_mgr_h,
+		struct cc_req_mgr_handle *req_mgr_h,
 		unsigned int total_seq_len)
 {
 	unsigned long poll_queue;
@@ -264,7 +264,7 @@ int send_request(
 	struct cc_hw_desc *desc, unsigned int len, bool is_dout)
 {
 	void __iomem *cc_base = drvdata->cc_base;
-	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	unsigned int used_sw_slots;
 	unsigned int iv_seq_len = 0;
 	unsigned int total_seq_len = len; /*initial sequence length*/
@@ -291,8 +291,7 @@ int send_request(
 		 * in case iv gen add the max size and in case of no dout add 1
 		 * for the internal completion descriptor
 		 */
-		rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
-						     max_required_seq_len);
+		rc = cc_queues_status(drvdata, req_mgr_h, max_required_seq_len);
 		if (rc == 0)
 			/* There is enough place in the queue */
 			break;
@@ -418,14 +417,13 @@ int send_request_init(
 	struct ssi_drvdata *drvdata, struct cc_hw_desc *desc, unsigned int len)
 {
 	void __iomem *cc_base = drvdata->cc_base;
-	struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
+	struct cc_req_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
 	unsigned int total_seq_len = len; /*initial sequence length*/
 	int rc = 0;
 
 	/* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT.
 	 */
-	rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
-					     total_seq_len);
+	rc = cc_queues_status(drvdata, req_mgr_h, total_seq_len);
 	if (rc)
 		return rc;
 
@@ -448,7 +446,7 @@ int send_request_init(
 
 void complete_request(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle *request_mgr_handle =
+	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
 	complete(&drvdata->hw_queue_avail);
@@ -474,7 +472,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 {
 	struct ssi_crypto_req *ssi_req;
 	struct device *dev = drvdata_to_dev(drvdata);
-	struct ssi_request_mgr_handle *request_mgr_handle =
+	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 	unsigned int *tail = &request_mgr_handle->req_queue_tail;
 	unsigned int *head = &request_mgr_handle->req_queue_head;
@@ -540,7 +538,7 @@ static inline u32 cc_axi_comp_count(struct ssi_drvdata *drvdata)
 static void comp_handler(unsigned long devarg)
 {
 	struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
-	struct ssi_request_mgr_handle *request_mgr_handle =
+	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
 	u32 irq;
@@ -590,7 +588,7 @@ static void comp_handler(unsigned long devarg)
 #if defined(CONFIG_PM)
 int cc_resume_req_queue(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle *request_mgr_handle =
+	struct cc_req_mgr_handle *request_mgr_handle =
 		drvdata->request_mgr_handle;
 
 	spin_lock_bh(&request_mgr_handle->hw_lock);
@@ -606,7 +604,7 @@ int cc_resume_req_queue(struct ssi_drvdata *drvdata)
  */
 int cc_suspend_req_queue(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle *request_mgr_handle =
+	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
 	/* lock the send_request */
@@ -624,7 +622,7 @@ int cc_suspend_req_queue(struct ssi_drvdata *drvdata)
 
 bool cc_req_queue_suspended(struct ssi_drvdata *drvdata)
 {
-	struct ssi_request_mgr_handle *request_mgr_handle =
+	struct cc_req_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
 
 	return	request_mgr_handle->is_runtime_suspended;
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index 53eed5f..d018f51 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -23,7 +23,7 @@
 
 #include "cc_hw_queue_defs.h"
 
-int request_mgr_init(struct ssi_drvdata *drvdata);
+int cc_req_mgr_init(struct ssi_drvdata *drvdata);
 
 /*!
  * Enqueue caller request to crypto hardware.
@@ -47,7 +47,7 @@ int send_request_init(
 
 void complete_request(struct ssi_drvdata *drvdata);
 
-void request_mgr_fini(struct ssi_drvdata *drvdata);
+void cc_req_mgr_fini(struct ssi_drvdata *drvdata);
 
 #if defined(CONFIG_PM)
 int cc_resume_req_queue(struct ssi_drvdata *drvdata);
-- 
2.7.4
