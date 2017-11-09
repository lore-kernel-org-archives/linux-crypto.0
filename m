From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 06/10] staging: ccree: simplify pm manager using local var
Date: Thu,  9 Nov 2017 09:16:14 +0000
Message-ID: <1510218980-3549-7-git-send-email-gilad@benyossef.com>
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

Make the code more readable by using a local variable.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_pm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index e1bc4c5..d60143c 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -90,20 +90,24 @@ int cc_pm_resume(struct device *dev)
 int cc_pm_get(struct device *dev)
 {
 	int rc = 0;
+	struct ssi_drvdata *drvdata =
+		(struct ssi_drvdata *)dev_get_drvdata(dev);
 
-	if (cc_req_queue_suspended((struct ssi_drvdata *)dev_get_drvdata(dev))) {
+	if (cc_req_queue_suspended(drvdata))
 		rc = pm_runtime_get_sync(dev);
-	} else {
+	else
 		pm_runtime_get_noresume(dev);
-	}
+
 	return rc;
 }
 
 int cc_pm_put_suspend(struct device *dev)
 {
 	int rc = 0;
+	struct ssi_drvdata *drvdata =
+		(struct ssi_drvdata *)dev_get_drvdata(dev);
 
-	if (!cc_req_queue_suspended((struct ssi_drvdata *)dev_get_drvdata(dev))) {
+	if (!cc_req_queue_suspended(drvdata)) {
 		pm_runtime_mark_last_busy(dev);
 		rc = pm_runtime_put_autosuspend(dev);
 	} else {
-- 
2.7.4
