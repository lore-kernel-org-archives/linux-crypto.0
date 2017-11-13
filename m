From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 13/24] staging: ccree: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Mon, 13 Nov 2017 14:45:41 +0000
Message-ID: <1510584358-29473-14-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
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

After commit b2b49ccbdd54
("PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is selected")
PM_RUNTIME is always set if PM is set, so #ifdef blocks
depending on CONFIG_PM_RUNTIME may now be changed to depend on
CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c      |  4 ++--
 drivers/staging/ccree/ssi_pm.c          |  6 +++---
 drivers/staging/ccree/ssi_pm.h          |  2 +-
 drivers/staging/ccree/ssi_request_mgr.c | 14 +++++++-------
 drivers/staging/ccree/ssi_request_mgr.h |  2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 0d5c1a9..8d16823 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -495,13 +495,13 @@ static int cc7x_remove(struct platform_device *plat_dev)
 	return 0;
 }
 
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 static const struct dev_pm_ops arm_cc7x_driver_pm = {
 	SET_RUNTIME_PM_OPS(cc_pm_suspend, cc_pm_resume, NULL)
 };
 #endif
 
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 #define	DX_DRIVER_RUNTIME_PM	(&arm_cc7x_driver_pm)
 #else
 #define	DX_DRIVER_RUNTIME_PM	NULL
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 86d403d..5e2ef5e 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -29,7 +29,7 @@
 #include "ssi_hash.h"
 #include "ssi_pm.h"
 
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
@@ -119,7 +119,7 @@ int cc_pm_put_suspend(struct device *dev)
 int cc_pm_init(struct ssi_drvdata *drvdata)
 {
 	int rc = 0;
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* must be before the enabling to avoid resdundent suspending */
@@ -137,7 +137,7 @@ int cc_pm_init(struct ssi_drvdata *drvdata)
 
 void cc_pm_fini(struct ssi_drvdata *drvdata)
 {
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 	pm_runtime_disable(drvdata_to_dev(drvdata));
 #endif
 }
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 557ec98..50bcf03 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -29,7 +29,7 @@ int cc_pm_init(struct ssi_drvdata *drvdata);
 
 void cc_pm_fini(struct ssi_drvdata *drvdata);
 
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 int cc_pm_suspend(struct device *dev);
 
 int cc_pm_resume(struct device *dev);
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 1d9c038..ab18851 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -58,7 +58,7 @@ struct ssi_request_mgr_handle {
 #else
 	struct tasklet_struct comptask;
 #endif
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 	bool is_runtime_suspended;
 #endif
 };
@@ -277,7 +277,7 @@ int send_request(
 					SSI_IVPOOL_SEQ_LEN) +
 					(!is_dout ? 1 : 0));
 
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 	rc = cc_pm_get(dev);
 	if (rc) {
 		dev_err(dev, "ssi_power_mgr_runtime_get returned %x\n", rc);
@@ -304,7 +304,7 @@ int send_request(
 			/* Any error other than HW queue full
 			 * (SW queue is full)
 			 */
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 			cc_pm_put_suspend(dev);
 #endif
 			return rc;
@@ -340,7 +340,7 @@ int send_request(
 		if (unlikely(rc)) {
 			dev_err(dev, "Failed to generate IV (rc=%d)\n", rc);
 			spin_unlock_bh(&req_mgr_h->hw_lock);
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 			cc_pm_put_suspend(dev);
 #endif
 			return rc;
@@ -469,7 +469,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 	struct device *dev = drvdata_to_dev(drvdata);
 	struct ssi_request_mgr_handle *request_mgr_handle =
 						drvdata->request_mgr_handle;
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 	int rc = 0;
 #endif
 
@@ -513,7 +513,7 @@ static void proc_completions(struct ssi_drvdata *drvdata)
 			request_mgr_handle->req_queue_tail);
 		dev_dbg(dev, "Request completed. axi_completed=%d\n",
 			request_mgr_handle->axi_completed);
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 		rc = cc_pm_put_suspend(dev);
 		if (rc)
 			dev_err(dev, "Failed to set runtime suspension %d\n",
@@ -579,7 +579,7 @@ static void comp_handler(unsigned long devarg)
  * resume the queue configuration - no need to take the lock as this happens inside
  * the spin lock protection
  */
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 int cc_resume_req_queue(struct ssi_drvdata *drvdata)
 {
 	struct ssi_request_mgr_handle *request_mgr_handle = drvdata->request_mgr_handle;
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/ssi_request_mgr.h
index 23883e2..53eed5f 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/ssi_request_mgr.h
@@ -49,7 +49,7 @@ void complete_request(struct ssi_drvdata *drvdata);
 
 void request_mgr_fini(struct ssi_drvdata *drvdata);
 
-#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM)
 int cc_resume_req_queue(struct ssi_drvdata *drvdata);
 
 int cc_suspend_req_queue(struct ssi_drvdata *drvdata);
-- 
2.7.4
