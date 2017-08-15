From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 04/22] staging: ccree: Convert to devm_ioremap_resource for map, unmap
Date: Tue, 15 Aug 2017 09:26:32 +0300
Message-ID: <1502778412-16255-5-git-send-email-gilad@benyossef.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Suniel Mahesh <sunil.m@techveda.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Suniel Mahesh <sunil.m@techveda.org>

It is recommended to use managed function devm_ioremap_resource(),
which simplifies driver cleanup paths and driver code.
This patch does the following:
(a) replace request_mem_region(), ioremap() and corresponding error
handling with devm_ioremap_resource().
(b) remove struct resource pointer(res_mem) in struct ssi_drvdata as it
seems redundant, use struct resource pointer which is defined locally and
adjust return value of platform_get_resource() accordingly.
(c) release_mem_region() and iounmap() are dropped, since devm_ioremap_
resource() releases and unmaps mem region on driver detach.
(d) adjust log messages accordingly and remove any blank lines.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
[gby: rebase on top of latest coding style fixes changes]
Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 60 ++++++++++----------------------------
 drivers/staging/ccree/ssi_driver.h |  1 -
 2 files changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 97dfc2c..603eb03 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -246,35 +246,21 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	dev_set_drvdata(&plat_dev->dev, new_drvdata);
 	/* Get device resources */
 	/* First CC registers space */
-	new_drvdata->res_mem = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
-	if (unlikely(!new_drvdata->res_mem)) {
-		SSI_LOG_ERR("Failed getting IO memory resource\n");
-		rc = -ENODEV;
-		goto init_cc_res_err;
-	}
-	SSI_LOG_DEBUG("Got MEM resource (%s): start=%pad end=%pad\n",
-		      new_drvdata->res_mem->name,
-		      new_drvdata->res_mem->start,
-		      new_drvdata->res_mem->end);
+	req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
 	/* Map registers space */
-	req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
-	if (unlikely(!req_mem_cc_regs)) {
-		SSI_LOG_ERR("Couldn't allocate registers memory region at 0x%08X\n",
-			    (unsigned int)new_drvdata->res_mem->start);
-		rc = -EBUSY;
-		goto init_cc_res_err;
-	}
-	cc_base = ioremap(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem));
-	if (unlikely(!cc_base)) {
-		SSI_LOG_ERR("ioremap[CC](0x%08X,0x%08X) failed\n",
-			    (unsigned int)new_drvdata->res_mem->start,
-			    (unsigned int)resource_size(new_drvdata->res_mem));
-		rc = -ENOMEM;
+	new_drvdata->cc_base = devm_ioremap_resource(&plat_dev->dev,
+						     req_mem_cc_regs);
+	if (IS_ERR(new_drvdata->cc_base)) {
+		rc = PTR_ERR(new_drvdata->cc_base);
 		goto init_cc_res_err;
 	}
-	SSI_LOG_DEBUG("CC registers mapped from %pa to 0x%p\n", &new_drvdata->res_mem->start, cc_base);
-	new_drvdata->cc_base = cc_base;
-
+	SSI_LOG_DEBUG("Got MEM resource (%s): start=%pad end=%pad\n",
+		      req_mem_cc_regs->name,
+		      req_mem_cc_regs->start,
+		      req_mem_cc_regs->end);
+	SSI_LOG_DEBUG("CC registers mapped from %pa to 0x%p\n",
+		      &req_mem_cc_regs->start, new_drvdata->cc_base);
+	cc_base = new_drvdata->cc_base;
 	/* Then IRQ */
 	new_drvdata->res_irq = platform_get_resource(plat_dev, IORESOURCE_IRQ, 0);
 	if (unlikely(!new_drvdata->res_irq)) {
@@ -424,17 +410,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 #ifdef ENABLE_CC_SYSFS
 		ssi_sysfs_fini();
 #endif
-
-		if (req_mem_cc_regs) {
-			if (irq_registered) {
-				free_irq(new_drvdata->res_irq->start, new_drvdata);
-				new_drvdata->res_irq = NULL;
-				iounmap(cc_base);
-				new_drvdata->cc_base = NULL;
-			}
-			release_mem_region(new_drvdata->res_mem->start,
-					   resource_size(new_drvdata->res_mem));
-			new_drvdata->res_mem = NULL;
+		if (irq_registered) {
+			free_irq(new_drvdata->res_irq->start, new_drvdata);
+			new_drvdata->res_irq = NULL;
 		}
 		dev_set_drvdata(&plat_dev->dev, NULL);
 	}
@@ -470,14 +448,6 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_clk_off(drvdata);
 	free_irq(drvdata->res_irq->start, drvdata);
 	drvdata->res_irq = NULL;
-
-	if (drvdata->cc_base) {
-		iounmap(drvdata->cc_base);
-		release_mem_region(drvdata->res_mem->start,
-				   resource_size(drvdata->res_mem));
-		drvdata->cc_base = NULL;
-		drvdata->res_mem = NULL;
-	}
 	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index b6ad89a..518c0bf 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -128,7 +128,6 @@ struct ssi_crypto_req {
  * @fw_ver:	SeP loaded firmware version
  */
 struct ssi_drvdata {
-	struct resource *res_mem;
 	struct resource *res_irq;
 	void __iomem *cc_base;
 	unsigned int irq;
-- 
2.1.4
