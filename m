From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 15/27] staging: ccree: use Makefile to include PM code
Date: Sun,  7 Jan 2018 12:14:26 +0000
Message-ID: <1515327285-8948-16-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
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

Replace ugly ifdefs with some inline macros and Makefile magic
for optionally including power management related code for
better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Makefile          |  3 ++-
 drivers/staging/ccree/ssi_pm.c          |  9 +-------
 drivers/staging/ccree/ssi_pm.h          | 39 +++++++++++++++++++++++++++------
 drivers/staging/ccree/ssi_request_mgr.c | 18 ++-------------
 4 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index bb47144..c107e25 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o
+ccree-y := ssi_driver.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o
 ccree-$(CONFIG_CRYPTO_FIPS) += ssi_fips.o
 ccree-$(CONFIG_DEBUG_FS) += cc_debugfs.o
+ccree-$(CONFIG_PM) += ssi_pm.o
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 3d9d00b..3a8d91c 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -14,8 +14,6 @@
 #include "ssi_hash.h"
 #include "ssi_pm.h"
 
-#if defined(CONFIG_PM)
-
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
 
@@ -103,12 +101,9 @@ int cc_pm_put_suspend(struct device *dev)
 	return rc;
 }
 
-#endif
-
 int cc_pm_init(struct cc_drvdata *drvdata)
 {
 	int rc = 0;
-#if defined(CONFIG_PM)
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* must be before the enabling to avoid resdundent suspending */
@@ -120,13 +115,11 @@ int cc_pm_init(struct cc_drvdata *drvdata)
 		return rc;
 	/* enable the PM module*/
 	pm_runtime_enable(dev);
-#endif
+
 	return rc;
 }
 
 void cc_pm_fini(struct cc_drvdata *drvdata)
 {
-#if defined(CONFIG_PM)
 	pm_runtime_disable(drvdata_to_dev(drvdata));
-#endif
 }
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 87bc389..f603255 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -11,21 +11,46 @@
 
 #define CC_SUSPEND_TIMEOUT 3000
 
-int cc_pm_init(struct cc_drvdata *drvdata);
-
-void cc_pm_fini(struct cc_drvdata *drvdata);
-
 #if defined(CONFIG_PM)
 
 extern const struct dev_pm_ops ccree_pm;
 
+int cc_pm_init(struct cc_drvdata *drvdata);
+void cc_pm_fini(struct cc_drvdata *drvdata);
 int cc_pm_suspend(struct device *dev);
-
 int cc_pm_resume(struct device *dev);
-
 int cc_pm_get(struct device *dev);
-
 int cc_pm_put_suspend(struct device *dev);
+
+#else
+
+static inline int cc_pm_init(struct cc_drvdata *drvdata)
+{
+	return 0;
+}
+
+static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
+
+static inline int cc_pm_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_resume(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_get(struct device *dev)
+{
+	return 0;
+}
+
+static inline int cc_pm_put_suspend(struct device *dev)
+{
+	return 0;
+}
+
 #endif
 
 #endif /*__POWER_MGR_H__*/
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index ff751d3..78f25e5 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -46,9 +46,7 @@ struct cc_req_mgr_handle {
 #else
 	struct tasklet_struct comptask;
 #endif
-#if defined(CONFIG_PM)
 	bool is_runtime_suspended;
-#endif
 };
 
 struct cc_bl_item {
@@ -404,9 +402,7 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 		spin_unlock(&mgr->hw_lock);
 
 		if (rc != -EINPROGRESS) {
-#if defined(CONFIG_PM)
 			cc_pm_put_suspend(dev);
-#endif
 			creq->user_cb(dev, req, rc);
 		}
 
@@ -432,13 +428,12 @@ int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 	gfp_t flags = cc_gfp_flags(req);
 	struct cc_bl_item *bli;
 
-#if defined(CONFIG_PM)
 	rc = cc_pm_get(dev);
 	if (rc) {
 		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
 		return rc;
 	}
-#endif
+
 	spin_lock_bh(&mgr->hw_lock);
 	rc = cc_queues_status(drvdata, mgr, total_len);
 
@@ -452,9 +447,7 @@ int cc_send_request(struct cc_drvdata *drvdata, struct cc_crypto_req *cc_req,
 
 		bli = kmalloc(sizeof(*bli), flags);
 		if (!bli) {
-#if defined(CONFIG_PM)
 			cc_pm_put_suspend(dev);
-#endif
 			return -ENOMEM;
 		}
 
@@ -486,13 +479,12 @@ int cc_send_sync_request(struct cc_drvdata *drvdata,
 	cc_req->user_cb = request_mgr_complete;
 	cc_req->user_arg = &cc_req->seq_compl;
 
-#if defined(CONFIG_PM)
 	rc = cc_pm_get(dev);
 	if (rc) {
 		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
 		return rc;
 	}
-#endif
+
 	while (true) {
 		spin_lock_bh(&mgr->hw_lock);
 		rc = cc_queues_status(drvdata, mgr, len + 1);
@@ -502,9 +494,7 @@ int cc_send_sync_request(struct cc_drvdata *drvdata,
 
 		spin_unlock_bh(&mgr->hw_lock);
 		if (rc != -EAGAIN) {
-#if defined(CONFIG_PM)
 			cc_pm_put_suspend(dev);
-#endif
 			return rc;
 		}
 		wait_for_completion_interruptible(&drvdata->hw_queue_avail);
@@ -515,9 +505,7 @@ int cc_send_sync_request(struct cc_drvdata *drvdata,
 	spin_unlock_bh(&mgr->hw_lock);
 
 	if (rc != -EINPROGRESS) {
-#if defined(CONFIG_PM)
 		cc_pm_put_suspend(dev);
-#endif
 		return rc;
 	}
 
@@ -621,9 +609,7 @@ static void proc_completions(struct cc_drvdata *drvdata)
 		dev_dbg(dev, "Dequeue request tail=%u\n", *tail);
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
 			request_mgr_handle->axi_completed);
-#if defined(CONFIG_PM)
 		cc_pm_put_suspend(dev);
-#endif
 	}
 }
 
-- 
2.7.4
