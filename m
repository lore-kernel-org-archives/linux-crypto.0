From: sunil.m@techveda.org
Subject: [PATCH 1/3] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Sat, 15 Jul 2017 13:21:54 +0530
Message-ID: <1500105116-30290-2-git-send-email-sunil.m@techveda.org>
References: <1500105116-30290-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 karthik@techveda.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Suniel Mahesh <sunil.m@techveda.org>
To: gregkh@linuxfoundation.org,
	gilad@benyossef.com
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1500105116-30290-1-git-send-email-sunil.m@techveda.org>
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

It is recommended to use managed function devm_kzalloc, which
simplifies driver cleanup paths and driver code.
This patch does the following:
(a) replace kzalloc with devm_kzalloc.
(b) drop kfree(), because memory allocated with devm_kzalloc() is
automatically freed on driver detach, otherwise it leads to a double
free.
(c) remove unnecessary blank lines.

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Note:
- Patch was tested and built(ARCH=arm) on next-20170714.
  No build issues reported, however it was not tested on
  real hardware.
---
 drivers/staging/ccree/ssi_driver.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 78709b92..f231ecf 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -224,13 +224,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct resource *req_mem_cc_regs = NULL;
 	void __iomem *cc_base = NULL;
 	bool irq_registered = false;
-	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(struct ssi_drvdata), GFP_KERNEL);
+	struct ssi_drvdata *new_drvdata;
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
 	int rc = 0;
 
-	if (unlikely(!new_drvdata)) {
+	new_drvdata = devm_kzalloc(&plat_dev->dev, sizeof(struct ssi_drvdata),
+				   GFP_KERNEL);
+	if (!new_drvdata) {
 		SSI_LOG_ERR("Failed to allocate drvdata");
 		rc = -ENOMEM;
 		goto init_cc_res_err;
@@ -431,10 +433,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 				resource_size(new_drvdata->res_mem));
 			new_drvdata->res_mem = NULL;
 		}
-		kfree(new_drvdata);
 		dev_set_drvdata(&plat_dev->dev, NULL);
 	}
-
 	return rc;
 }
 
@@ -475,8 +475,6 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 		drvdata->cc_base = NULL;
 		drvdata->res_mem = NULL;
 	}
-
-	kfree(drvdata);
 	dev_set_drvdata(&plat_dev->dev, NULL);
 }
 
-- 
1.9.1
