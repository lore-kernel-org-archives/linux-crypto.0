From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 3/8] staging: ccree: Use platform_get_irq and devm_request_irq
Date: Sun,  3 Sep 2017 11:56:45 +0300
Message-ID: <1504429011-25514-4-git-send-email-gilad@benyossef.com>
References: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Suniel Mahesh <sunil.m@techveda.org>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
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

From: Suniel Mahesh <sunil.m@techveda.org>

It is recommended to use managed function devm_request_irq(),
which simplifies driver cleanup paths and driver code.
This patch does the following:
(a) replace platform_get_resource(), request_irq() and corresponding
error handling with platform_get_irq() and devm_request_irq().
(b) remove struct resource pointer(res_irq) in struct ssi_drvdata as
it seems redundant.
(c) change type of member irq in struct ssi_drvdata from unsigned int
to int, as return type of platform_get_irq is int and can be used in
error handling.
(d) remove irq_registered variable from driver probe as it seems
redundant.
(e) free_irq is not required any more, devm_request_irq() free's it
on driver detach.
(f) adjust log messages accordingly and remove any blank lines.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 30 +++++++++---------------------
 drivers/staging/ccree/ssi_driver.h |  3 +--
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index cbe9a03..3e7193d 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -222,7 +222,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 {
 	struct resource *req_mem_cc_regs = NULL;
 	void __iomem *cc_base = NULL;
-	bool irq_registered = false;
 	struct ssi_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
@@ -262,26 +261,22 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		      &req_mem_cc_regs->start, new_drvdata->cc_base);
 	cc_base = new_drvdata->cc_base;
 	/* Then IRQ */
-	new_drvdata->res_irq = platform_get_resource(plat_dev, IORESOURCE_IRQ, 0);
-	if (unlikely(!new_drvdata->res_irq)) {
+	new_drvdata->irq = platform_get_irq(plat_dev, 0);
+	if (new_drvdata->irq < 0) {
 		SSI_LOG_ERR("Failed getting IRQ resource\n");
-		rc = -ENODEV;
+		rc = new_drvdata->irq;
 		goto init_cc_res_err;
 	}
-	rc = request_irq(new_drvdata->res_irq->start, cc_isr,
-			 IRQF_SHARED, "arm_cc7x", new_drvdata);
-	if (unlikely(rc != 0)) {
-		SSI_LOG_ERR("Could not register to interrupt %llu\n",
-			    (unsigned long long)new_drvdata->res_irq->start);
+	rc = devm_request_irq(&plat_dev->dev, new_drvdata->irq, cc_isr,
+			      IRQF_SHARED, "arm_cc7x", new_drvdata);
+	if (rc) {
+		SSI_LOG_ERR("Could not register to interrupt %d\n",
+			    new_drvdata->irq);
 		goto init_cc_res_err;
 	}
 	init_completion(&new_drvdata->icache_setup_completion);
 
-	irq_registered = true;
-	SSI_LOG_DEBUG("Registered to IRQ (%s) %llu\n",
-		      new_drvdata->res_irq->name,
-		      (unsigned long long)new_drvdata->res_irq->start);
-
+	SSI_LOG_DEBUG("Registered to IRQ: %d\n", new_drvdata->irq);
 	new_drvdata->plat_dev = plat_dev;
 
 	rc = cc_clk_on(new_drvdata);
@@ -410,10 +405,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 #ifdef ENABLE_CC_SYSFS
 		ssi_sysfs_fini();
 #endif
-		if (irq_registered) {
-			free_irq(new_drvdata->res_irq->start, new_drvdata);
-			new_drvdata->res_irq = NULL;
-		}
 		dev_set_drvdata(&plat_dev->dev, NULL);
 	}
 	return rc;
@@ -443,11 +434,8 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 #ifdef ENABLE_CC_SYSFS
 	ssi_sysfs_fini();
 #endif
-
 	fini_cc_regs(drvdata);
 	cc_clk_off(drvdata);
-	free_irq(drvdata->res_irq->start, drvdata);
-	drvdata->res_irq = NULL;
 	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 518c0bf..88ef370 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -128,9 +128,8 @@ struct ssi_crypto_req {
  * @fw_ver:	SeP loaded firmware version
  */
 struct ssi_drvdata {
-	struct resource *res_irq;
 	void __iomem *cc_base;
-	unsigned int irq;
+	int irq;
 	u32 irq_mask;
 	u32 fw_ver;
 	/* Calibration time of start/stop
-- 
2.1.4
