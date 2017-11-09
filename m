From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 07/10] staging: ccree: remove unneeded cast
Date: Thu,  9 Nov 2017 09:16:15 +0000
Message-ID: <1510218980-3549-8-git-send-email-gilad@benyossef.com>
References: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
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

Remove unneeded cast of the return value of dev_get_drvdata()
to struct ssi_drvdata * for better readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_pm.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index d60143c..d3e9382 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -36,8 +36,7 @@
 
 int cc_pm_suspend(struct device *dev)
 {
-	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(dev);
+	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
 	int rc;
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
@@ -56,8 +55,7 @@ int cc_pm_suspend(struct device *dev)
 int cc_pm_resume(struct device *dev)
 {
 	int rc;
-	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(dev);
+	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
 
 	dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
@@ -90,8 +88,7 @@ int cc_pm_resume(struct device *dev)
 int cc_pm_get(struct device *dev)
 {
 	int rc = 0;
-	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(dev);
+	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
 
 	if (cc_req_queue_suspended(drvdata))
 		rc = pm_runtime_get_sync(dev);
@@ -104,8 +101,7 @@ int cc_pm_get(struct device *dev)
 int cc_pm_put_suspend(struct device *dev)
 {
 	int rc = 0;
-	struct ssi_drvdata *drvdata =
-		(struct ssi_drvdata *)dev_get_drvdata(dev);
+	struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
 
 	if (!cc_req_queue_suspended(drvdata)) {
 		pm_runtime_mark_last_busy(dev);
-- 
2.7.4
